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

---

## 🏗️ WorldEdit: Construcción Rápida

WorldEdit es una herramienta extremadamente potente que te permite modificar miles de bloques en segundos mediante comandos. Es esencial para construcciones a gran escala.

### 1. Preparación
Para usar WorldEdit, asegúrate de tener el privilegio:
*   `/grant <tu_nombre> worldedit`

### 2. El Concepto de Selección
Casi todos los comandos de WorldEdit funcionan dentro de una **región rectangular** definida por dos puntos opuestos (Posición 1 y Posición 2).

*   **Método Rápido (Varita):** Escribe `//p set` y luego golpea (clic izquierdo) un bloque para el **Punto 1** y pica (clic derecho o usar herramienta de selección) para el **Punto 2**. Verás unos cubos negros con números flotando.
*   **Método por Coordenadas:**
    *   `//pos1` - Establece tu ubicación actual como el punto 1.
    *   `//pos2` - Establece tu ubicación actual como el punto 2.

### 3. Comandos de Llenado y Reemplazo
*   `//set <nombre_del_bloque>` - Llena toda la selección con ese bloque.
    *   *Ejemplo:* `//set mcl_core:stone` (Llena de piedra).
    *   *Ejemplo:* `//set air` (Borra todo en la selección).
*   `//replace <bloque_viejo> <bloque_nuevo>` - Cambia solo un tipo de bloque por otro.
    *   *Ejemplo:* `//replace mcl_core:dirt mcl_core:grass` (Cambia tierra por césped).

### 4. Creación de Formas Geométricas
Estos comandos crean formas alrededor de tu posición actual o del Punto 1.
*   `//sphere <radio> <bloque>` - Crea una esfera sólida.
*   `//hollowsphere <radio> <bloque>` - Crea una esfera hueca (una cáscara).
*   `//cylinder <eje> <radio> <longitud> <bloque>` - Crea un cilindro (Eje puede ser `x`, `y` o `z`).
*   `//walls <bloque>` - Crea paredes alrededor del perímetro de tu selección actual.

### 5. Copiar, Pegar y Manipular
*   `//copy` - Copia la selección actual a tu portapapeles (se basa en tu posición relativa).
*   `//paste` - Pega lo que copiaste en tu ubicación actual.
*   `//rotate <eje> <grados>` - Rota lo que tienes en el portapapeles (90, 180, 270).
*   `//stack <dirección> <cantidad>` - Repite la selección varias veces.
    *   *Direcciones:* `up`, `down`, `north`, `south`, `east`, `west`.

### 6. Control de Errores (¡Muy Importante!)
Si cometes un error y borras algo que no debías:
*   `//undo` - Deshace la última acción de WorldEdit.
*   `//redo` - Rehace lo que acabas de deshacer.

### 💡 Tips Pro:
1.  **Nombres de bloques:** Para saber el nombre técnico de un bloque, míralo y presiona `F5` (modo debug). Verás algo como `mcl_core:stone` en la pantalla.
2.  **Hacia dónde miras:** Muchos comandos (como `stack` o `move`) dependen de la dirección en la que estás mirando si no especificas una.
3.  **Límite de bloques:** Ten cuidado con selecciones masivas (millones de bloques), ya que pueden congelar el servidor temporalmente.

