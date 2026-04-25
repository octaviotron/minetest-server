#!/bin/bash

# Default paths
MODS_DIR="data/.minetest/mods"
WORLD_MT="data/.minetest/worlds/world/world.mt"

# Check arguments
if [ "$#" -ne 2 ]; then
    echo "====================================================="
    echo "Usage: $0 <path_to_zip_file> <exact_mod_name>"
    echo "Example: $0 ~/Downloads/mcl_furniture.zip mcl_furniture"
    echo "====================================================="
    exit 1
fi

ZIP_FILE="$1"
MOD_NAME="$2"

if [ ! -f "$ZIP_FILE" ]; then
    echo "Error: Zip file '$ZIP_FILE' not found!"
    exit 1
fi

echo "Installing mod: $MOD_NAME"

# Temporarily grant host write access to necessary directories using Docker
echo "-> Granting write permissions to host..."
docker run --rm -v $(pwd)/data:/var/lib/minetest alpine sh -c "mkdir -p /var/lib/minetest/.minetest/mods && chmod 777 /var/lib/minetest/.minetest/mods && if [ -d /var/lib/minetest/.minetest/worlds/world ]; then chmod 777 /var/lib/minetest/.minetest/worlds/world; fi && if [ -f /var/lib/minetest/.minetest/worlds/world/world.mt ]; then chmod 666 /var/lib/minetest/.minetest/worlds/world/world.mt; fi"

# Ensure mods directory exists
mkdir -p "$MODS_DIR"

# Extract to a temporary directory
TMP_DIR=$(mktemp -d)
echo "-> Extracting $ZIP_FILE..."
unzip -q "$ZIP_FILE" -d "$TMP_DIR"

# Find the extracted folder (assuming zip contains exactly one root folder)
EXTRACTED_FOLDER=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)

if [ -z "$EXTRACTED_FOLDER" ]; then
    echo "Error: No folder found inside the zip file."
    rm -rf "$TMP_DIR"
    exit 1
fi

# Move and rename the folder to the target mods directory
TARGET_DIR="$MODS_DIR/$MOD_NAME"
if [ -d "$TARGET_DIR" ]; then
    echo "-> Warning: Mod directory $TARGET_DIR already exists. Overwriting..."
    rm -rf "$TARGET_DIR"
fi

mv "$EXTRACTED_FOLDER" "$TARGET_DIR"
rm -rf "$TMP_DIR"

echo "-> Successfully moved mod to $TARGET_DIR"

# Enable the mod in world.mt
if [ -f "$WORLD_MT" ]; then
    if grep -q "^load_mod_${MOD_NAME} = " "$WORLD_MT"; then
        # Replace existing line (in case it was set to false)
        sed -i "s/^load_mod_${MOD_NAME} = .*/load_mod_${MOD_NAME} = true/" "$WORLD_MT"
        echo "-> Updated existing entry in world.mt to 'true'"
    else
        # Append new line
        echo "load_mod_${MOD_NAME} = true" >> "$WORLD_MT"
        echo "-> Added new entry to world.mt"
    fi
else
    echo "-> Warning: $WORLD_MT not found. The mod was installed, but you must enable it manually."
fi

# Fix permissions so the Docker container (UID 30000) can read/write the mod
echo "-> Fixing permissions for Docker..."
docker run --rm -v $(pwd)/data:/var/lib/minetest alpine chown -R 30000:30000 "/var/lib/minetest/.minetest/mods/$MOD_NAME"

echo ""
echo "✅ Mod installation complete! Run 'docker compose restart' to apply changes."
