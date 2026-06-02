local I18n = {}

I18n.Language = "es"
I18n.Roots = {}

local esToEn = {
    ["Chat General"] = "General Chat",
    ["GLOBAL"] = "GLOBAL",
    ["SALA"] = "ROOM",
    ["PUBLICA"] = "PUBLIC",
    ["PRIVADA"] = "PRIVATE",
    ["En linea"] = "Online",
    ["Salir"] = "Leave",
    ["Enviar"] = "Send",
    ["Escribe un mensaje..."] = "Type a message...",
    ["El sistema de puntos y Premios estara disponible pronto"] = "The points and Rewards system will be available soon",
    ["Elige una opcion para una mejor Experiencia :"] = "Choose an option for a better Experience :",

    ["Puntos de Jugador"] = "Player Points",
    ["Crear Salas"] = "Create Rooms",
    ["Salas Publicas"] = "Public Rooms",
    ["Salas Privadas"] = "Private Rooms",
    ["Tabla Clanes"] = "Clan Board",
    ["Perfil"] = "Profile",
    ["Tienda"] = "Shop",
    ["Admin"] = "Admin",

    ["Actividad"] = "Activity",
    ["Publico"] = "Public",
    ["Privado"] = "Private",
    ["Actividad reciente"] = "Recent activity",
    ["Idioma / language"] = "Language / idioma",
    ["Español"] = "Spanish",
    ["English"] = "English",
    ["Puntos de Usuario:"] = "User Points:",
    ["Clan:"] = "Clan:",
    ["Sin clan"] = "No clan",
    ["Descripcion:"] = "Description:",
    ["Cuentales algo sobre ti..."] = "Tell them something about you...",
    ["Inventario"] = "Inventory",
    ["Guardar Cambios"] = "Save Changes",
    ["Ver Perfil Publico"] = "View Public Profile",
    ["Imagen de perfil"] = "Profile image",
    ["Inserta ID pfp de tu preferencia"] = "Insert your preferred pfp ID",
    ["Procura usar imagenes pfp"] = "Try to use pfp images",
    ["Aplicar"] = "Apply",
    ["Cerrar"] = "Close",
    ["Por defecto"] = "Default",
    ["Avatar de Roblox seleccionado."] = "Roblox avatar selected.",
    ["Imagen seleccionada."] = "Image selected.",
    ["Selecciona una imagen o inserta un ID."] = "Select an image or insert an ID.",
    ["El ID debe ser numerico."] = "The ID must be numeric.",
    ["Imagen aplicada. Guarda cambios para mantenerla."] = "Image applied. Save changes to keep it.",

    ["TIENDA"] = "SHOP",
    ["Mis puntos"] = "My points",
    ["2 cantidad por mes"] = "2 per month",
    ["10 cantidad por mes"] = "10 per month",
    ["Premio principal destacado"] = "Featured main reward",
    ["Comprar"] = "Buy",
    ["Generar codigo de Premio"] = "Generate Reward Code",
    ["AGOTADO"] = "SOLD OUT",
    ["Comprando..."] = "Buying...",
    ["COMPRADO"] = "BOUGHT",
    ["YA LO TIENES"] = "OWNED",
    ["TICKET DE CLAN"] = "CLAN TICKET",
    ["COLOR DE NOMBRE"] = "NAME COLOR",
    ["CHAT PERSONALIZADO"] = "CUSTOM CHAT",
    ["COLOR DE CHAT"] = "CHAT COLOR",
    ["DISEÑO DE FONDO"] = "BACKGROUND DESIGN",
    ["1000 ROBUX"] = "1000 ROBUX",
    ["100 ROBUX"] = "100 ROBUX",
    ["Valor 10"] = "Value 10",

    ["Crear Sala"] = "Create Room",
    ["Nombre de la sala..."] = "Room name...",
    ["Sala Pública"] = "Public Room",
    ["Sala Privada"] = "Private Room",
    ["Contraseña..."] = "Password...",
    ["Crear"] = "Create",
    ["Cancelar"] = "Cancel",
    ["Si"] = "Yes",
    ["No"] = "No",
    ["Contraseña de sala"] = "Room password",
    ["Ingresa la contraseña..."] = "Enter the password...",
    ["Entrar"] = "Enter",
    ["Contraseña incorrecta"] = "Incorrect password",

    ["Salas Públicas"] = "Public Rooms",
    ["Salas Privadas"] = "Private Rooms",
    ["Nº"] = "No.",
    ["Nombre de sala"] = "Room name",
    ["Participantes"] = "Participants",
    ["Cargando salas..."] = "Loading rooms...",
    ["No se pudieron cargar salas."] = "Rooms could not be loaded.",

    ["TABLA DE CLANES / FAMILIAS"] = "CLAN / FAMILY BOARD",
    ["CLAN/FAMILIA"] = "CLAN/FAMILY",
    ["PUNTOS"] = "POINTS",
    ["DESCRIPCIÓN"] = "DESCRIPTION",
    ["Puntos de Familia:"] = "Family Points:",
    ["Miembros:"] = "Members:",
    ["Descripción:"] = "Description:",
    ["Sin clanes"] = "No clans",
    ["Solicitar unirse"] = "Request to join",
    ["Salir de Clan"] = "Leave Clan",
    ["Eliminar Clan"] = "Delete Clan",
    ["Ver Clan/Familia"] = "View Clan/Family",
    ["Los clanes se actualizan automáticamente. 1 Ganador por Mes"] = "Clans update automatically. 1 winner per month",
    ["Solicitud enviada"] = "Request sent",
    ["Envia la solicitud cuando el Lider se encuentre En Linea"] = "Send the request when the Leader is Online",
    ["Solicitud aceptada."] = "Request accepted.",
    ["Solicitud rechazada."] = "Request rejected.",
    ["No se pudo enviar la solicitud."] = "The request could not be sent.",
    ["No se pudo salir del clan."] = "Could not leave the clan.",
    ["Saliste del clan."] = "You left the clan.",
    ["Estas seguro/a que quieres eliminar este clan? Se expulsara a todos los integrantes."] = "Are you sure you want to delete this clan? All members will be removed.",
    ["Eliminando clan..."] = "Deleting clan...",
    ["Clan eliminado correctamente."] = "Clan deleted successfully.",
    ["No se pudo eliminar el clan."] = "The clan could not be deleted.",

    ["Mis Items"] = "My Items",
    ["Crear Clan"] = "Create Clan",
    ["Chat Personalizado"] = "Custom Chat",
    ["Elige el estilo que quieres usar en tus mensajes."] = "Choose the style you want to use in your messages.",
    ["Color de Nombre"] = "Name Color",
    ["Elige el color que quieres usar en tu nombre."] = "Choose the color you want to use for your name.",
    ["Diseño de Fondo"] = "Background Design",
    ["Elige el fondo que quieres mostrar en tu perfil."] = "Choose the background you want to show on your profile.",
    ["Usar"] = "Use",
    ["En uso"] = "In use",
    ["Guardado"] = "Saved",
    ["Elegir"] = "Choose",
    ["Elegir fondo"] = "Choose background",
    ["Eliminar"] = "Delete",
    ["Todavia no tienes items comprados."] = "You do not have purchased items yet.",

    ["Panel Admin"] = "Admin Panel",
    ["Enviar Aviso"] = "Send Notice",
    ["Mensaje para todos"] = "Message for everyone",
    ["Actualizar"] = "Refresh",
    ["Premios pendientes"] = "Pending rewards",
    ["Entregado"] = "Delivered",
    ["Atras"] = "Back",
    ["Sin premios pendientes."] = "No pending rewards.",
    ["Introducir codigo de seguridad"] = "Enter security code",
    ["Codigo"] = "Code",
    ["Aceptar"] = "Accept",
    ["Rechazar"] = "Reject",

    ["TU CODIGO DE PREMIO ES:"] = "YOUR REWARD CODE IS:",
    ["TU CÓDIGO DE PREMIO ES:"] = "YOUR REWARD CODE IS:",
    ["Copiar"] = "Copy",
    ["Copiado"] = "Copied",
    ["Introducir Codigo"] = "Enter Code",
    ["Nota: El Premio puede ser canjeado en esta ventana, en la tienda o Redes Sociales del Script"] = "Note: The reward can be redeemed in this window, in the shop, or on the script social media",
    ["Canjear"] = "Redeem",
    ["¡Felicidades, Canjeaste tu código con éxito!"] = "Congratulations, you redeemed your code successfully!",
    ["Mensaje"] = "Message",
    ["Agregar"] = "Add",

    ["Escribe un aviso antes de enviarlo."] = "Write a notice before sending it.",
    ["Enviando aviso..."] = "Sending notice...",
    ["Aviso enviado correctamente."] = "Notice sent successfully.",
    ["No se pudo enviar el aviso."] = "The notice could not be sent.",
    ["Cargando premios pendientes..."] = "Loading pending rewards...",
    ["Premios pendientes actualizados."] = "Pending rewards updated.",
    ["No se pudieron cargar los premios pendientes."] = "Pending rewards could not be loaded.",
    ["Marcando premio como entregado..."] = "Marking reward as delivered...",
    ["Introduce el codigo."] = "Enter the code.",
    ["Verificando codigo..."] = "Verifying code...",
    ["Codigo incorrecto."] = "Incorrect code.",
    ["No se pudo comprar el premio."] = "The reward could not be purchased.",
    ["Introduce un codigo para canjear."] = "Enter a code to redeem.",
    ["No se pudo canjear el codigo."] = "The code could not be redeemed.",
    ["Codigo de premio no encontrado."] = "Reward code not found.",
    ["Este codigo pertenece a otro usuario."] = "This code belongs to another user.",
    ["Este codigo ya fue canjeado o entregado."] = "This code has already been redeemed or delivered.",
    ["Este codigo expiro. Genera uno nuevo desde la tienda."] = "This code expired. Generate a new one from the shop.",
    ["Este premio aun no fue canjeado."] = "This reward has not been redeemed yet.",
    ["No se encontro tu perfil."] = "Your profile was not found.",
    ["Este item no existe."] = "This item does not exist.",
    ["Este item no se puede comprar."] = "This item cannot be purchased.",
    ["Ya tienes este item en tu inventario."] = "You already have this item in your inventory.",
    ["No tienes puntos suficientes."] = "You do not have enough points.",
    ["Cargando inventario..."] = "Loading inventory...",
    ["Aplicando item..."] = "Applying item...",
    ["Item aplicado correctamente."] = "Item applied successfully.",
    ["Eliminando item..."] = "Deleting item...",
    ["Item eliminado correctamente."] = "Item deleted successfully.",
    ["Eliminacion cancelada."] = "Deletion canceled.",
    ["Estas seguro/a que quieres eliminar este item de tu inventario?"] = "Are you sure you want to delete this item from your inventory?",
    ["Creando clan..."] = "Creating clan...",
    ["Clan creado correctamente."] = "Clan created successfully.",
    ["No se pudo cargar tu inventario."] = "Your inventory could not be loaded.",
    ["Completa los datos para crear tu clan."] = "Complete the information to create your clan.",
    ["Selecciona el estilo de chat que quieres usar."] = "Select the chat style you want to use.",
    ["No tienes estilos de chat disponibles para aplicar."] = "You do not have chat styles available to apply.",
    ["No tienes color de nombre disponible para aplicar."] = "You do not have a name color available to apply.",
    ["Selecciona el color de nombre que quieres usar."] = "Select the name color you want to use.",
    ["Ya estas usando el color seleccionado."] = "You are already using the selected color.",
    ["No tienes diseños de fondo disponibles."] = "You do not have background designs available.",
    ["Selecciona el diseño de fondo que quieres usar."] = "Select the background design you want to use.",
    ["Ya estas usando el diseño seleccionado."] = "You are already using the selected design.",
    ["Selecciona un estilo de chat."] = "Select a chat style.",
    ["Selecciona un color de nombre."] = "Select a name color.",
    ["Selecciona un diseño de fondo."] = "Select a background design.",
    ["Perfil publico cargado correctamente."] = "Public profile loaded successfully.",
    ["No se pudo cargar el perfil publico."] = "Public profile could not be loaded.",
    ["Guardando cambios..."] = "Saving changes...",
    ["No hay cambios para guardar."] = "There are no changes to save.",
    ["Cambios guardados."] = "Changes saved.",
    ["No se pudo guardar el perfil."] = "Profile could not be saved."
}

local enToEs = {}

for es, en in pairs(esToEn) do
    enToEs[en] = es
end

local function translatePattern(text)
    local remaining = string.match(text, "^Restante%s+(%d+)$")

    if remaining then
        return I18n.Language == "en" and ("Remaining " .. remaining) or ("Restante " .. remaining)
    end

    local value = string.match(text, "^Valor%s+(%d+)$")

    if value then
        return I18n.Language == "en" and ("Value " .. value) or ("Valor " .. value)
    end

    local online = string.match(text, "^En Línea %- (%d+)$")

    if online then
        return I18n.Language == "en" and ("Online - " .. online) or ("En Línea - " .. online)
    end

    local onlineEncoded = string.match(text, "^En L.-nea %- (%d+)$")

    if onlineEncoded then
        return I18n.Language == "en" and ("Online - " .. onlineEncoded) or ("En Línea - " .. onlineEncoded)
    end

    local onlineEn = string.match(text, "^Online %- (%d+)$")

    if onlineEn then
        return I18n.Language == "en" and ("Online - " .. onlineEn) or ("En Línea - " .. onlineEn)
    end

    local room = string.match(text, "^En Sala %- (%d+)$")

    if room then
        return I18n.Language == "en" and ("In Room - " .. room) or ("En Sala - " .. room)
    end

    local roomEn = string.match(text, "^In Room %- (%d+)$")

    if roomEn then
        return I18n.Language == "en" and ("In Room - " .. roomEn) or ("En Sala - " .. roomEn)
    end

    local delivered = string.match(text, "^Entregados:%s+(%d+)$")

    if delivered then
        return I18n.Language == "en" and ("Delivered: " .. delivered) or ("Entregados: " .. delivered)
    end

    local deliveredEn = string.match(text, "^Delivered:%s+(%d+)$")

    if deliveredEn then
        return I18n.Language == "en" and ("Delivered: " .. deliveredEn) or ("Entregados: " .. deliveredEn)
    end

    local playingWithColon = string.match(text, "^Jugando a%s*:%s*(.+)$")

    if playingWithColon then
        return I18n.Language == "en" and ("Playing : " .. playingWithColon) or ("Jugando a : " .. playingWithColon)
    end

    local playingWithColonEn = string.match(text, "^Playing%s*:%s*(.+)$")

    if playingWithColonEn then
        return I18n.Language == "en" and ("Playing : " .. playingWithColonEn) or ("Jugando a : " .. playingWithColonEn)
    end

    local playing = string.match(text, "^Jugando a%s+(.+)$")

    if playing then
        return I18n.Language == "en" and ("Playing " .. playing) or ("Jugando a " .. playing)
    end

    local playingEn = string.match(text, "^Playing%s+(.+)$")

    if playingEn then
        return I18n.Language == "en" and ("Playing " .. playingEn) or ("Jugando a " .. playingEn)
    end

    return nil
end

function I18n.TranslateText(text)
    if text == nil then
        return text
    end

    local value = tostring(text)

    if value == "" then
        return value
    end

    local patternValue = translatePattern(value)

    if patternValue then
        return patternValue
    end

    if I18n.Language == "en" then
        return esToEn[value] or value
    end

    return enToEs[value] or value
end

function I18n.Apply(root)
    if not root then
        return
    end

    local descendants = root:GetDescendants()
    table.insert(descendants, root)

    for _, object in ipairs(descendants) do
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            object.Text = I18n.TranslateText(object.Text)

            if object:IsA("TextBox") then
                object.PlaceholderText = I18n.TranslateText(object.PlaceholderText)
            end
        end
    end
end

function I18n.RegisterRoot(root)
    if not root then
        return
    end

    for _, currentRoot in ipairs(I18n.Roots) do
        if currentRoot == root then
            I18n.Apply(root)
            return
        end
    end

    table.insert(I18n.Roots, root)
    I18n.Apply(root)
end

function I18n.Refresh()
    for index = #I18n.Roots, 1, -1 do
        local root = I18n.Roots[index]

        if root and root.Parent then
            I18n.Apply(root)
        else
            table.remove(I18n.Roots, index)
        end
    end
end

function I18n.SetLanguage(language)
    if language ~= "en" then
        language = "es"
    end

    I18n.Language = language
    I18n.Refresh()
end

function I18n.GetLanguage()
    return I18n.Language
end

return I18n
