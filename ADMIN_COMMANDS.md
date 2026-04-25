# Luanti (MineClone2) Server Administration Guide

This document covers the most common and useful commands for server administrators running a VoxeLibre/MineClone2 world. 

To use these commands, you must first be designated as the server owner (via `name = YourUsername` in `conf/minetest.conf`) or have the appropriate privileges granted to you (`/grant <playername> all`).

To type a command, press `T` to open the chat window, type the command starting with a forward slash `/`, and press Enter.

---

## 🎮 Game Mode Commands

MineClone2 implements a robust gamemode system similar to Minecraft. You need the appropriate privileges (like `server` or `bring`) to change gamemodes for yourself or others.

*   `/gamemode survival` or `/gamemode s` - Switch to Survival mode (health, hunger, limited resources).
*   `/gamemode creative` or `/gamemode c` - Switch to Creative mode (invincibility, flying, infinite blocks).
*   `/gamemode spectator` - Switch to Spectator mode (fly through blocks, invisible to others).
*   `/gamemode adventure` - Switch to Adventure mode (can interact, but cannot break/place blocks without specific tools).
*   `/gamemode <mode> <player>` - Change the game mode of a specific player.

*(Shortcuts: You can also just type `/survival`, `/creative`, or `/spectator`)*

## 🌍 World & Environment Commands

*   `/time <0-24000>` - Set the time of day using raw Minetest ticks (e.g., `/time 6000` for midday, `/time 18000` for midnight).
*   `/time set <day | night>` - Set the time to day or night using standard keywords.
*   `/weather <clear | rain | thunder>` - Change the current weather.
*   `/setspawn` - Sets the default global spawn point for all new players who join the server to your current exact location.

## 🎁 Inventory & Item Commands

*   `/giveme <item_name> [amount]` - Gives yourself an item. (Example: `/giveme mcl_core:diamond 64` or `/giveme mcl_core:apple 10`).
*   `/give <player> <item_name> [amount]` - Gives an item to a specific player.
*   `/clearinv [player]` - Clears your inventory entirely, or the inventory of the specified player.

## 🚀 Movement & Teleportation

*   `/tp <x>,<y>,<z>` - Teleport yourself to exact world coordinates. (Example: `/tp 100,20,-300`).
*   `/tp <player_name>` - Teleport yourself to another player.
*   `/tp <player_1> <player_2>` - Teleport Player 1 to Player 2.

## 🛡️ Player Management (Moderation)

*   `/kick <player_name> [reason]` - Disconnects a player from the server temporarily.
*   `/ban <player_name>` - Permanently bans a player's IP and Name from joining the server.
*   `/unban <player_name>` - Removes a ban.
*   `/kill [player_name]` - Instantly kills yourself (or the specified player).

## 🔑 Privilege Management

Luanti relies on a granular "privilege" system rather than standard admin ranks. You can give players specific abilities without making them full admins.

*   `/grant <player> <privilege>` - Give a specific privilege.
*   `/revoke <player> <privilege>` - Remove a specific privilege.
*   `/grant <player> all` - Give all privileges (Make them an admin).
*   `/privs [player]` - See what privileges you (or another player) currently have.

**Common Privileges:**
*   `interact`: Can dig/place blocks and use items.
*   `shout`: Can speak in global chat.
*   `fly`: Can toggle flying mode.
*   `noclip`: Can toggle flying through solid walls.
*   `fast`: Can toggle fast-running mode.
*   `teleport`: Can use `/tp`.
*   `give`: Can use `/giveme`.
