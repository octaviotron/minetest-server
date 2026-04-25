#!/bin/bash

# Default paths
MODS_DIR="data/.minetest/mods"
WORLD_MT="data/.minetest/worlds/world/world.mt"

# Check arguments
if [ "$#" -lt 1 ]; then
    echo "====================================================="
    echo "Usage: $0 <path_to_zip_file>"
    echo "Example: $0 ~/Downloads/mcl_furniture-1.2.zip"
    echo "====================================================="
    exit 1
fi

ZIP_FILE="$1"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: Zip file '$ZIP_FILE' not found!"
    exit 1
fi

# Extract to a temporary directory
TMP_DIR=$(mktemp -d)
echo "-> Extracting $ZIP_FILE..."
unzip -q "$ZIP_FILE" -d "$TMP_DIR"

# Check if zip is packaged with a single root folder, or if files are directly at the root
NUM_ROOT_ITEMS=$(ls -1A "$TMP_DIR" | wc -l)
NUM_ROOT_DIRS=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | wc -l)

if [ "$NUM_ROOT_ITEMS" -eq 1 ] && [ "$NUM_ROOT_DIRS" -eq 1 ]; then
    # Standard format: one root folder inside the zip
    EXTRACTED_FOLDER=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)
    FLAT_ZIP=false
else
    # Flat format: files/folders are directly at the root of the zip
    EXTRACTED_FOLDER="$TMP_DIR"
    FLAT_ZIP=true
fi

if [ -z "$EXTRACTED_FOLDER" ] || [ "$NUM_ROOT_ITEMS" -eq 0 ]; then
    echo "Error: Zip file is empty."
    rm -rf "$TMP_DIR"
    exit 1
fi

# Try to automatically read the mod name from internal files
MOD_NAME=""

if [ -f "$EXTRACTED_FOLDER/mod.conf" ]; then
    MOD_NAME=$(awk -F'=' '/^name/ {gsub(/[ \t\r\n]/, "", $2); print $2}' "$EXTRACTED_FOLDER/mod.conf")
    if [ -n "$MOD_NAME" ]; then
        echo "-> Found mod.conf: Internal name is '$MOD_NAME'"
    fi
elif [ -f "$EXTRACTED_FOLDER/modpack.txt" ]; then
    MOD_NAME=$(awk -F'=' '/^name/ {gsub(/[ \t\r\n]/, "", $2); print $2}' "$EXTRACTED_FOLDER/modpack.txt")
    if [ -n "$MOD_NAME" ]; then
        echo "-> Found modpack.txt: Internal name is '$MOD_NAME'"
    fi
elif [ -f "$EXTRACTED_FOLDER/modpack.conf" ]; then
    MOD_NAME=$(awk -F'=' '/^name/ {gsub(/[ \t\r\n]/, "", $2); print $2}' "$EXTRACTED_FOLDER/modpack.conf")
    if [ -n "$MOD_NAME" ]; then
        echo "-> Found modpack.conf: Internal name is '$MOD_NAME'"
    fi
fi

# Fallback: Guess from the folder name or zip name
if [ -z "$MOD_NAME" ]; then
    if [ "$FLAT_ZIP" = true ]; then
        ZIP_BASENAME=$(basename "$ZIP_FILE" .zip)
        MOD_NAME=$(echo "$ZIP_BASENAME" | sed -E 's/_[0-9]+.*$//' | sed 's/-master//' | sed 's/-main//' | sed -E 's/-[0-9]+.*$//' | sed -E 's/^[0-9]+-//')
    else
        BASENAME=$(basename "$EXTRACTED_FOLDER")
        MOD_NAME=${BASENAME%-master}
        MOD_NAME=${MOD_NAME%-main}
    fi
    echo "-> No internal name found in config files. Guessing name: '$MOD_NAME'"
fi

echo "==================================="
echo "Installing mod: $MOD_NAME"
echo "==================================="

# Temporarily grant host write access to necessary directories using Docker
echo "-> Granting write permissions to host..."
docker run --rm -v $(pwd)/data:/var/lib/minetest alpine sh -c "mkdir -p /var/lib/minetest/.minetest/mods && chmod 777 /var/lib/minetest/.minetest/mods && if [ -d /var/lib/minetest/.minetest/worlds/world ]; then chmod 777 /var/lib/minetest/.minetest/worlds/world; fi && if [ -f /var/lib/minetest/.minetest/worlds/world/world.mt ]; then chmod 666 /var/lib/minetest/.minetest/worlds/world/world.mt; fi"

# Ensure mods directory exists
mkdir -p "$MODS_DIR"

# Move and rename the folder to the target mods directory
TARGET_DIR="$MODS_DIR/$MOD_NAME"
if [ -d "$TARGET_DIR" ]; then
    echo "-> Warning: Mod directory $TARGET_DIR already exists. Overwriting..."
    docker run --rm -v $(pwd)/data:/var/lib/minetest alpine rm -rf "/var/lib/minetest/.minetest/mods/$MOD_NAME"
fi

if [ "$FLAT_ZIP" = true ]; then
    mv "$TMP_DIR" "$TARGET_DIR"
else
    mv "$EXTRACTED_FOLDER" "$TARGET_DIR"
    rm -rf "$TMP_DIR"
fi

echo "-> Successfully moved mod to $TARGET_DIR"

# Enable the mod in world.mt
if [ -f "$WORLD_MT" ]; then
    # Detect if it's a modpack
    IS_MODPACK=false
    if [ -f "$TARGET_DIR/modpack.txt" ] || [ -f "$TARGET_DIR/modpack.conf" ]; then
        IS_MODPACK=true
    fi

    if [ "$IS_MODPACK" = true ]; then
        echo "-> Modpack detected! Enabling all contained mods individually..."
        for submod in "$TARGET_DIR"/*/; do
            if [ -d "$submod" ]; then
                SUBMOD_NAME=$(basename "$submod")
                # Try to parse exact name from submod
                if [ -f "$submod/mod.conf" ]; then
                    PARSED_NAME=$(awk -F'=' '/^name/ {gsub(/[ \t\r\n]/, "", $2); print $2}' "$submod/mod.conf")
                    if [ -n "$PARSED_NAME" ]; then
                        SUBMOD_NAME="$PARSED_NAME"
                    fi
                fi
                
                # Enable submod
                if grep -q "^load_mod_${SUBMOD_NAME} = " "$WORLD_MT"; then
                    sed -i "s/^load_mod_${SUBMOD_NAME} = .*/load_mod_${SUBMOD_NAME} = true/" "$WORLD_MT"
                else
                    echo "load_mod_${SUBMOD_NAME} = true" >> "$WORLD_MT"
                fi
                echo "   -> Enabled sub-mod: $SUBMOD_NAME"
            fi
        done
        # Clean up any bad modpack entry if it was accidentally created before
        sed -i "/^load_mod_${MOD_NAME} =/d" "$WORLD_MT"
    else
        # Single mod enablement
        if grep -q "^load_mod_${MOD_NAME} = " "$WORLD_MT"; then
            # Replace existing line (in case it was set to false)
            sed -i "s/^load_mod_${MOD_NAME} = .*/load_mod_${MOD_NAME} = true/" "$WORLD_MT"
            echo "-> Updated existing entry in world.mt to 'true'"
        else
            # Append new line
            echo "load_mod_${MOD_NAME} = true" >> "$WORLD_MT"
            echo "-> Added new entry to world.mt"
        fi
    fi
else
    echo "-> Warning: $WORLD_MT not found. The mod was installed, but you must enable it manually."
fi

# Fix permissions so the Docker container (UID 30000) can read/write the mod
echo "-> Fixing permissions for Docker..."
docker run --rm -v $(pwd)/data:/var/lib/minetest alpine chown -R 30000:30000 "/var/lib/minetest/.minetest/mods/$MOD_NAME"

echo ""
echo "✅ Mod installation complete! Run 'docker compose restart' to apply changes."
