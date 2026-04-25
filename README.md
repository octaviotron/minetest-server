# Luanti Minecraft-Compatible Server

This repository contains the configuration and Docker setup for a Luanti (Minetest) server running the Minecraft-compatible game VoxeLibre (MineClone2).

## Getting Started

Start the server using Docker Compose:

```bash
docker compose up -d
```

## How to Install Mods

Adding mods to a Luanti (Minetest) server is straightforward, but since you are running the **VoxeLibre (MineClone2)** game, there is one very important rule to keep in mind:

> **⚠️ Mod Compatibility Rule**
> Standard Minetest mods are usually built for the default "Minetest Game" and will crash or break if loaded into VoxeLibre/MineClone2. You must ensure you only download mods that explicitly say they are compatible with **MineClone2** or **VoxeLibre**.

Here is the step-by-step guide to installing mods for your server to add new objects and materials:

### 1. Find a Compatible Mod
Browse the official Luanti content repository at **[ContentDB](https://content.minetest.net/packages/?type=mod)**. 
Use the filter options on the left to filter for `MineClone2` compatibility.

*(Example: Let's say you found a furniture mod called `mcl_furniture`)*

### 2. Download and Extract to the `mods` folder
You need to create a `mods` folder in your server's data directory and extract the downloaded zip file there.

You can do this directly from your terminal. Make sure you are in your project's root folder, then run:

```bash
# Create the mods directory
mkdir -p data/.minetest/mods

# Navigate into it, download the mod, and extract it
cd data/.minetest/mods
wget <mod_zip_url_here>
unzip <mod_zip_file.zip>
```
*Note: Make sure the extracted folder is named exactly after the mod's technical name (e.g., `mcl_furniture`). If it extracts as `mcl_furniture-master`, rename it.*

### 3. Enable the Mod in your World
Even if a mod is in the `mods` folder, it won't load until you explicitly enable it for your specific world. 

Open your world configuration file located at `data/.minetest/worlds/world/world.mt`. 

To enable the mod, add a new line at the bottom in this format: `load_mod_<modname> = true`.
For example:
```ini
load_mod_mcl_furniture = true
```

### 4. Restart the Server
Apply the changes by restarting your Docker container:
```bash
docker compose restart
```

## Server Administration (Permissions & Admins)

By default, players joining the server will only have basic privileges (like `interact` and `shout`). To manage the server, give permissions, or use cheats, you must designate a server owner.

### 1. Set the Server Owner (Admin)
Open your main configuration file at `conf/minetest.conf` and add your username to it using the `name` setting:

```ini
name = YourUsername
```
*Note: Replace `YourUsername` with the exact in-game name you plan to use when joining the server.*

Restart the server so the changes take effect:
```bash
docker compose restart
```

### 2. Grant Permissions
Once you join the game as the owner, the server automatically grants you all privileges (including the `server` and `privs` permissions).

You can now open the chat (press `T` in-game) and run commands to manage other players:
*   **Give all privileges to a player:** `/grant <playername> all`
*   **Give specific privileges:** `/grant <playername> fly`
*   **Revoke a privilege:** `/revoke <playername> fly`
*   **Check a player's privileges:** `/privs <playername>`

**Common Useful Privileges:**
*   `interact`: Allows modifying blocks and picking up items.
*   `shout`: Allows talking in the public chat.
*   `fly`: Allows the player to fly (press `K` or double-tap jump to toggle).
*   `noclip`: Allows flying through solid blocks (press `H` to toggle).
*   `fast`: Allows the player to move quickly (press `J` to toggle).
*   `teleport`: Allows the player to teleport to other coordinates.
*   `give`: Allows using the `/give` and `/giveme` commands to spawn items.
