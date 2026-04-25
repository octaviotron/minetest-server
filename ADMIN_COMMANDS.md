# Guía de Administración del Servidor Luanti (MineClone2)

Este documento cubre los comandos más comunes y útiles para los administradores que ejecutan un mundo de VoxeLibre/MineClone2.

Para usar estos comandos, primero debes ser designado como el propietario del servidor (a través de `name = TuUsuario` en `conf/minetest.conf`) o tener los privilegios adecuados otorgados (`/grant <jugador> all`).

Para escribir un comando, presiona `T` para abrir la ventana de chat, escribe el comando comenzando con una barra diagonal `/` y presiona Enter.

---

## 🎮 Comandos de Modo de Juego (Game Mode)

MineClone2 implementa un sistema robusto de modos de juego similar al de Minecraft. Necesitas los privilegios adecuados (como `server` o `bring`) para cambiar los modos de juego para ti o para otros.

*   `/gamemode survival` o `/gamemode s` - Cambiar al modo Supervivencia (salud, hambre, recursos limitados).
*   `/gamemode creative` o `/gamemode c` - Cambiar al modo Creativo (invencibilidad, vuelo, bloques infinitos).
*   `/gamemode spectator` - Cambiar al modo Espectador (atravesar bloques, invisible para otros).
*   `/gamemode adventure` - Cambiar al modo Aventura (puedes interactuar, pero no romper/colocar bloques sin herramientas específicas).
*   `/gamemode <modo> <jugador>` - Cambia el modo de juego de un jugador específico.

*(Atajos: También puedes escribir simplemente `/survival`, `/creative` o `/spectator`)*

### Cómo Cambiar los Modos de Juego Permanentemente

*   **Para un Solo Jugador:** Usar el comando `/gamemode <modo> <jugador>` es **permanente**. Se guarda directamente en el perfil del jugador. Permanecerán en ese modo cada vez que inicien sesión, incluso después de reiniciar el servidor.
*   **Para Todos los Jugadores (Predeterminado Global):** Para cambiar el modo de juego para *todo el servidor* (para que cada nuevo jugador entre en modo Creativo en lugar de Supervivencia), debes editar tu archivo `conf/minetest.conf` y agregar esta línea:
    ```ini
    creative_mode = true
    ```
    *(Establécelo en `false` para que todos vuelvan a Supervivencia por defecto).* Debes reiniciar el servidor (`docker compose restart`) para que esta configuración global surta efecto.

## 🌍 Comandos de Mundo y Entorno

*   `/time <0-24000>` - Establece la hora del día usando "ticks" de Minetest (ej. `/time 6000` para el mediodía, `/time 18000` para la medianoche).
*   `/time set <day | night>` - Establece la hora a día o noche usando palabras clave.
*   `/weather <clear | rain | thunder>` - Cambia el clima actual (despejado | lluvia | tormenta).
*   `/setspawn` - Establece el punto de aparición (spawn) global predeterminado para todos los nuevos jugadores en tu ubicación exacta actual.

## 🎁 Comandos de Inventario y Objetos

*   `/giveme <objeto> [cantidad]` - Te da un objeto a ti mismo. (Ejemplo: `/giveme mcl_core:diamond 64` o `/giveme mcl_core:apple 10`).
*   `/give <jugador> <objeto> [cantidad]` - Le da un objeto a un jugador específico.
*   `/clearinv [jugador]` - Limpia tu inventario por completo, o el inventario del jugador especificado.

## 🚀 Movimiento y Teletransporte

*   `/tp <x>,<y>,<z>` - Te teletransporta a unas coordenadas exactas del mundo. (Ejemplo: `/tp 100,20,-300`).
*   `/tp <jugador>` - Te teletransporta hacia otro jugador.
*   `/tp <jugador_1> <jugador_2>` - Teletransporta al Jugador 1 hacia el Jugador 2.

## 🛡️ Gestión de Jugadores (Moderación)

*   `/kick <jugador> [razón]` - Desconecta a un jugador del servidor temporalmente (expulsar).
*   `/ban <jugador>` - Banea (bloquea) permanentemente la IP y el nombre de un jugador para que no pueda unirse al servidor.
*   `/unban <jugador>` - Elimina un ban.
*   `/kill [jugador]` - Te mata instantáneamente a ti mismo (o al jugador especificado).

## 🔑 Gestión de Privilegios

Luanti se basa en un sistema granular de "privilegios" en lugar de rangos estándar de administrador. Puedes otorgar a los jugadores habilidades específicas sin convertirlos en administradores completos.

*   `/grant <jugador> <privilegio>` - Otorga un privilegio específico.
*   `/revoke <jugador> <privilegio>` - Elimina un privilegio específico.
*   `/grant <jugador> all` - Otorga todos los privilegios (Lo convierte en administrador).
*   `/privs [jugador]` - Mira qué privilegios tienes tú (o tiene otro jugador) actualmente.

**Privilegios Comunes:**
*   `interact`: Puede cavar/colocar bloques y usar objetos.
*   `shout`: Puede hablar en el chat global.
*   `fly`: Puede activar el modo de vuelo.
*   `noclip`: Puede activar el vuelo a través de paredes sólidas.
*   `fast`: Puede activar el modo de correr rápido.
*   `teleport`: Puede usar el comando `/tp`.
*   `give`: Puede usar el comando `/giveme`.
