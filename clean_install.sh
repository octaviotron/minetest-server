#!/bin/bash

echo "======================================"
echo "    Luanti Clean Install Script       "
echo "======================================"
echo "WARNING: This will completely delete your world, all installed mods, and player data."
read -p "Are you sure you want to proceed? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
echo "-> 1. Stopping the server..."
docker compose down

echo "-> 2. Wiping old data and world..."
# Use docker to delete the data folder to avoid permission issues with the 30000 UID
docker run --rm -v $(pwd):/work alpine rm -rf /work/data

echo "-> 3. Downloading a fresh copy of VoxeLibre (Mineclone2)..."
mkdir -p data/.minetest/games
git clone https://git.minetest.land/VoxeLibre/VoxeLibre.git data/.minetest/games/mineclone2

echo "-> 4. Fixing permissions for the container..."
docker run --rm -v $(pwd)/data:/var/lib/minetest -v $(pwd)/conf:/etc/minetest alpine chown -R 30000:30000 /var/lib/minetest /etc/minetest

echo "-> 5. Starting the server..."
docker compose up -d

echo ""
echo "✅ Clean install complete! Your server is generating a brand new world."
