--// StrikeChat Mini Chat Test

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local API_URL = "https://strikechat-api.onrender.com"
local HEARTBEAT_INTERVAL = 15
local CHAT_REFRESH_INTERVAL = 3

local player = Players.LocalPlayer
local running = true

local httpRequest =
    request or
    http_request or
    (syn and syn.request)

if not httpRequest then
    warn("Tu ejecutor no soporta request/http_request.")
    return
end

local function encode(value)
    return HttpService:UrlEncode(tostring(value))
end

local function safeDecode(body)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if ok then
        return decoded
    end

    return nil
end

local function apiRequest(url, method)
    local ok, response = pcall(function()
        return httpRequest({
            Url = url,
            Method = method or "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)

    if not ok or not response or not response.Body then
        return nil
    end

    return safeDecode(response.Body)
end

local function heartbeat()
    local url =
        API_URL ..
        "/online-users/heartbeat" ..
        "?roblox_user_id=" .. encode(player.UserId) ..
        "&roblox_username=" .. encode(player.Name) ..
        "&roblox_display_name=" .. encode(player.DisplayName)

    return apiRequest(url, "POST")
end

local function getMessages()
    local url = API_URL .. "/chat/messages?room_id=global"
    local result = apiRequest(url, "GET")

    if result and result.messages then
        return result.messages
    end

    return {}
end

local function sendMessage(message)
    local body = HttpService:JSONEncode({
        room_id = "global",
        roblox_user_id = player.UserId,
        username = player.DisplayName,
        message = message
    })

    local ok, response = pcall(function()
        return httpRequest({
            Url = API_URL .. "/chat/send",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end)

    if not ok or not response or not response.Body then
        return nil
    end

    return safeDecode(response.Body)
end

local firstResult = heartbeat()

if not firstResult or firstResult.status ~= "ok" then
    warn("No se pudo conectar con StrikeChat API.")
    return
end

local gui = Instance.new("ScreenGui")
gui.Name = "StrikeChat_MiniChat"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5, -260, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(24, 25, 35)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(135, 95, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.2
stroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 42)
title.Position = UDim2.new(0, 16, 0, 8)
title.BackgroundTransparency = 1
title.Text = "StrikeChat - Chat Global"
title.TextColor3 = Color3.fromRGB(235, 235, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 32, 0, 32)
close.Position = UDim2.new(1, -44, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(40, 42, 58)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 120, 120)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = close

local messagesBox = Instance.new("ScrollingFrame")
messagesBox.Size = UDim2.new(1, -32, 1, -120)
messagesBox.Position = UDim2.new(0, 16, 0, 58)
messagesBox.BackgroundColor3 = Color3.fromRGB(18, 19, 28)
messagesBox.BorderSizePixel = 0
messagesBox.ScrollBarThickness = 4
messagesBox.CanvasSize = UDim2.new(0, 0, 0, 0)
messagesBox.Parent = frame

local messagesCorner = Instance.new("UICorner")
messagesCorner.CornerRadius = UDim.new(0, 10)
messagesCorner.Parent = messagesBox

local messagesLayout = Instance.new("UIListLayout")
messagesLayout.Padding = UDim.new(0, 6)
messagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
messagesLayout.Parent = messagesBox

local messagesPadding = Instance.new("UIPadding")
messagesPadding.PaddingTop = UDim.new(0, 8)
messagesPadding.PaddingLeft = UDim.new(0, 8)
messagesPadding.PaddingRight = UDim.new(0, 8)
messagesPadding.Parent = messagesBox

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -32, 0, 20)
statusLabel.Position = UDim2.new(0, 16, 1, -78)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -120, 0, 42)
input.Position = UDim2.new(0, 16, 1, -52)
input.BackgroundColor3 = Color3.fromRGB(35, 37, 52)
input.BorderSizePixel = 0
input.PlaceholderText = "Escribe un mensaje..."
input.Text = ""
input.TextColor3 = Color3.fromRGB(235, 235, 245)
input.PlaceholderColor3 = Color3.fromRGB(145, 145, 160)
input.Font = Enum.Font.Gotham
input.TextSize = 15
input.ClearTextOnFocus = false
input.Parent = frame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = input

local send = Instance.new("TextButton")
send.Size = UDim2.new(0, 88, 0, 42)
send.Position = UDim2.new(1, -104, 1, -52)
send.BackgroundColor3 = Color3.fromRGB(110, 82, 230)
send.Text = "Enviar"
send.TextColor3 = Color3.fromRGB(255, 255, 255)
send.Font = Enum.Font.GothamBold
send.TextSize = 15
send.Parent = frame

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 10)
sendCorner.Parent = send

local lastRendered = ""

local function renderMessages(messages)
    local signature = HttpService:JSONEncode(messages)

    if signature == lastRendered then
        return
    end

    lastRendered = signature

    for _, child in ipairs(messagesBox:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, msg in ipairs(messages) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -8, 0, 34)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(220, 220, 235)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextWrapped = true

        local name = msg.display_name or msg.username or "Usuario"

        if msg.clan_tag then
            if msg.clan_tag_style == "plain" then
                name = name .. msg.clan_tag
            else
                name = name .. "[" .. msg.clan_tag .. "]"
            end
        end

        label.Text = name .. ": " .. tostring(msg.message)
        label.Parent = messagesBox
    end

    task.wait()
    messagesBox.CanvasSize = UDim2.new(0, 0, 0, messagesLayout.AbsoluteContentSize.Y + 16)
    messagesBox.CanvasPosition = Vector2.new(0, messagesBox.AbsoluteCanvasSize.Y)
end

local function refreshChat()
    renderMessages(getMessages())
end

send.MouseButton1Click:Connect(function()
    local text = input.Text

    if text and text:gsub("%s+", "") ~= "" then
        input.Text = ""
        local result = sendMessage(text)

        if result and result.status == "blocked" then
            statusLabel.Text = result.display_message or "No puedes enviar este mensaje."

            task.spawn(function()
                local currentMessage = statusLabel.Text

                task.wait(4)

                if statusLabel.Text == currentMessage then
                    statusLabel.Text = ""
                end
            end)

        else
            statusLabel.Text = ""
        end

        task.wait(0.2)
        refreshChat()
    end
end)

input.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        send.MouseButton1Click:Fire()
    end
end)

close.MouseButton1Click:Connect(function()
    running = false
    gui:Destroy()
end)

task.spawn(function()
    while running do
        heartbeat()
        task.wait(HEARTBEAT_INTERVAL)
    end
end)

task.spawn(function()
    while running do
        refreshChat()
        task.wait(CHAT_REFRESH_INTERVAL)
    end
end)

refreshChat()