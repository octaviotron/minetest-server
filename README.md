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
Browse the official Luanti content repository for VoxeLibre-compatible mods using this direct link:
**[VoxeLibre/MineClone2 Compatible Mods on ContentDB](https://content.luanti.org/packages/?q=&type=mod&lang=&engine_version=&game=Wuzzy%2Fmineclone2&sort=&order=desc)**.

*(Example: Let's say you found a furniture mod called `mcl_furniture`)*

### 2. Install using the automation script
Download the `.zip` file for the mod to your machine. Instead of extracting it manually and editing the world configuration files, you can use the provided `install_mod.sh` script.

Run the script from the project root, providing the path to the downloaded zip file and the exact technical name of the mod:

```bash
./install_mod.sh /path/to/mod.zip <mod_name>
```

*Example for `mcl_furniture`:*
```bash
./install_mod.sh ~/Downloads/mcl_furniture-1.2.zip mcl_furniture
```

The script will automatically unzip the file, place it in the correct directory, rename it, enable it in your `world.mt` file, and fix Docker folder permissions for you.

### 3. Restart the Server
Apply the changes by restarting your Docker container:
```bash
docker compose restart
```

### 4. Disabling a Mod
If a mod is causing issues or you no longer want it, you can instantly disable it using the `disable_mod.sh` script. Just provide the exact name of the mod:

```bash
./disable_mod.sh mcl_furniture
```
Then restart the server to apply the changes.

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

## Troubleshooting & Debugging

If your server fails to start, crashes, or a mod breaks, you have two primary ways to check for errors:

### 1. View Live Server Logs
To view the live output of your Docker container (which shows errors, crashes, and player connections in real-time), run:
```bash
docker compose logs -f
```
*(Press `Ctrl+C` to exit the live log view)*

### 2. View the Debug Log File
Luanti writes a detailed log of everything that happens behind the scenes (including detailed stack traces when a Lua mod crashes). You can view the full log file here:
```bash
cat data/.minetest/debug.txt
```
Or, if you want to follow the file as it updates:
```bash
tail -f data/.minetest/debug.txt
```

## Factory Reset (Clean Install)

If your world becomes hopelessly corrupted or you just want to start completely fresh with a brand new world, you can run the factory reset script.

**⚠️ WARNING:** This will permanently delete your world, all installed mods, and all player inventories.

```bash
./clean_install.sh
```
This script will safely stop the container, delete the `data` folder using Docker (to bypass any permission locks), download a completely fresh copy of VoxeLibre (MineClone2), and automatically restart the server to generate your new world.
