#!/bin/bash

WORLD_MT="data/.minetest/worlds/world/world.mt"

if [ "$#" -ne 1 ]; then
    echo "====================================================="
    echo "Usage: $0 <exact_mod_name>"
    echo "Example: $0 mcl_furniture"
    echo "====================================================="
    exit 1
fi

MOD_NAME="$1"

echo "Disabling mod: $MOD_NAME"

# Temporarily grant host write access to necessary directories using Docker
echo "-> Granting write permissions to host..."
docker run --rm -v $(pwd)/data:/var/lib/minetest alpine sh -c "if [ -f /var/lib/minetest/.minetest/worlds/world/world.mt ]; then chmod 666 /var/lib/minetest/.minetest/worlds/world/world.mt; fi"

if [ -f "$WORLD_MT" ]; then
    if grep -q "^load_mod_${MOD_NAME} = " "$WORLD_MT"; then
        sed -i "s/^load_mod_${MOD_NAME} = .*/load_mod_${MOD_NAME} = false/" "$WORLD_MT"
        echo "-> Successfully disabled '$MOD_NAME' in world.mt"
    else
        echo "-> Warning: Mod '$MOD_NAME' is not currently listed in world.mt. Adding as disabled."
        echo "load_mod_${MOD_NAME} = false" >> "$WORLD_MT"
    fi
else
    echo "Error: $WORLD_MT not found! Are you sure the world has been generated?"
    exit 1
fi

echo ""
echo "✅ Mod disabled! Run 'docker compose restart' to apply changes."
