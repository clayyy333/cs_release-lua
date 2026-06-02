local ClanRequestModal = {}

function ClanRequestModal.Create(parent, Theme)
    local function tr(text)
        if _G.StrikeChatI18n then
            return _G.StrikeChatI18n.TranslateText(text)
        end

        return text
    end

    local function requestMessage(request)
        local displayName = tostring(request and request.requester_display_name or "Usuario")
        local clanName = tostring(request and request.clan_name or "Clan")

        if _G.StrikeChatI18n and _G.StrikeChatI18n.GetLanguage and _G.StrikeChatI18n.GetLanguage() == "en" then
            return displayName .. " wants to join " .. clanName
        end

        return displayName .. " quiere unirse a " .. clanName
    end

    local isMobile = _G.StrikeChatLayoutMode == "mobile"

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeChatClanRequestModalGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 10000
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local overlay = Instance.new("Frame")
    overlay.Name = "ClanRequestModalOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 120
    overlay.Parent = gui

    local modal = Instance.new("Frame")
    modal.Name = "ClanRequestModal"
    modal.Size = isMobile and UDim2.new(0, 300, 0, 150) or UDim2.new(0, 360, 0, 162)
    modal.Position = UDim2.new(0.5, 0, 0.5, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Color3.fromRGB(50, 51, 57)
    modal.BorderSizePixel = 0
    modal.ZIndex = 121
    modal.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = modal

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(96, 98, 110)
    stroke.Thickness = 1
    stroke.Transparency = 0.32
    stroke.Parent = modal

    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -36, 0, isMobile and 58 or 66)
    message.Position = UDim2.new(0, 18, 0, 18)
    message.BackgroundTransparency = 1
    message.Text = ""
    message.TextColor3 = Theme.Colors.Text
    message.Font = Theme.Font.Bold
    message.TextSize = isMobile and 12 or 14
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 122
    message.Parent = modal

    local acceptButton = Instance.new("TextButton")
    acceptButton.Name = "AcceptButton"
    acceptButton.Size = UDim2.new(0.5, -23, 0, isMobile and 28 or 32)
    acceptButton.Position = UDim2.new(0, 18, 1, isMobile and -44 or -50)
    acceptButton.BackgroundColor3 = Color3.fromRGB(78, 158, 58)
    acceptButton.BorderSizePixel = 0
    acceptButton.Text = tr("Aceptar")
    acceptButton.TextColor3 = Theme.Colors.Text
    acceptButton.Font = Theme.Font.Bold
    acceptButton.TextSize = isMobile and 11 or 12
    acceptButton.ZIndex = 122
    acceptButton.Parent = modal

    local acceptCorner = Instance.new("UICorner")
    acceptCorner.CornerRadius = UDim.new(0, 8)
    acceptCorner.Parent = acceptButton

    local rejectButton = Instance.new("TextButton")
    rejectButton.Name = "RejectButton"
    rejectButton.Size = UDim2.new(0.5, -23, 0, isMobile and 28 or 32)
    rejectButton.Position = UDim2.new(0.5, 5, 1, isMobile and -44 or -50)
    rejectButton.BackgroundColor3 = Color3.fromRGB(120, 36, 36)
    rejectButton.BorderSizePixel = 0
    rejectButton.Text = tr("Rechazar")
    rejectButton.TextColor3 = Theme.Colors.Text
    rejectButton.Font = Theme.Font.Bold
    rejectButton.TextSize = isMobile and 11 or 12
    rejectButton.ZIndex = 122
    rejectButton.Parent = modal

    local rejectCorner = Instance.new("UICorner")
    rejectCorner.CornerRadius = UDim.new(0, 8)
    rejectCorner.Parent = rejectButton

    local currentAccept = nil
    local currentReject = nil

    local function close()
        overlay.Visible = false
        currentAccept = nil
        currentReject = nil
    end

    acceptButton.MouseButton1Click:Connect(function()
        if currentAccept then
            currentAccept()
        end

        close()
    end)

    rejectButton.MouseButton1Click:Connect(function()
        if currentReject then
            currentReject()
        end

        close()
    end)

    return {
        Gui = gui,
        Overlay = overlay,
        Message = message,
        AcceptButton = acceptButton,
        RejectButton = rejectButton,

        OpenInfo = function(text)
            message.Text = tr(text)
            acceptButton.Size = UDim2.new(0, 132, 0, isMobile and 28 or 32)
            acceptButton.Position = UDim2.new(0.5, -66, 1, isMobile and -44 or -50)
            acceptButton.Text = tr("Aceptar")
            rejectButton.Visible = false
            currentAccept = nil
            currentReject = nil
            overlay.Visible = true
        end,

        OpenJoinRequest = function(request, onAccept, onReject)
            message.Text = requestMessage(request)
            acceptButton.Size = UDim2.new(0.5, -23, 0, isMobile and 28 or 32)
            acceptButton.Position = UDim2.new(0, 18, 1, isMobile and -44 or -50)
            acceptButton.Text = tr("Aceptar")
            rejectButton.Text = tr("Rechazar")
            rejectButton.Visible = true
            currentAccept = onAccept
            currentReject = onReject
            overlay.Visible = true
        end,

        Close = close,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ClanRequestModal
