local ConfirmModal = {}

function ConfirmModal.Create(parent, Theme)
    local function tr(text)
        if _G.StrikeChatI18n then
            return _G.StrikeChatI18n.TranslateText(text)
        end

        return text
    end

    local guiParent = parent

    if parent and parent:IsA("ScreenGui") then
        guiParent = parent.Parent
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeChatConfirmModalGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 10001
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = guiParent or parent

    local overlay = Instance.new("Frame")
    overlay.Name = "ConfirmOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.Visible = false
    overlay.ZIndex = 200
    overlay.Parent = gui

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 320, 0, 170)
    modal.Position = UDim2.new(0.5, -160, 0.5, -85)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 201
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 26)
    closeButton.Position = UDim2.new(1, -38, 0, 10)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 202
    closeButton.Parent = modal

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -36, 0, 70)
    message.Position = UDim2.new(0, 18, 0, 42)
    message.BackgroundTransparency = 1
    message.Text = ""
    message.TextColor3 = Theme.Colors.Text
    message.Font = Theme.Font.Bold
    message.TextSize = 14
    message.TextWrapped = true
    message.TextXAlignment = Enum.TextXAlignment.Center
    message.TextYAlignment = Enum.TextYAlignment.Center
    message.ZIndex = 202
    message.Parent = modal

    local primaryButton = Instance.new("TextButton")
    primaryButton.Name = "PrimaryButton"
    primaryButton.Size = UDim2.new(0.5, -22, 0, 36)
    primaryButton.Position = UDim2.new(0, 18, 1, -48)
    primaryButton.BackgroundColor3 = Theme.Colors.AccentSoft
    primaryButton.BorderSizePixel = 0
    primaryButton.Text = "Entrar"
    primaryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    primaryButton.Font = Theme.Font.Bold
    primaryButton.TextSize = 13
    primaryButton.ZIndex = 202
    primaryButton.Parent = modal

    local primaryCorner = Instance.new("UICorner")
    primaryCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    primaryCorner.Parent = primaryButton

    local secondaryButton = Instance.new("TextButton")
    secondaryButton.Name = "SecondaryButton"
    secondaryButton.Size = UDim2.new(0.5, -22, 0, 36)
    secondaryButton.Position = UDim2.new(0.5, 4, 1, -48)
    secondaryButton.BackgroundColor3 = Theme.Colors.PanelLight
    secondaryButton.BorderSizePixel = 0
    secondaryButton.Text = "Cancelar"
    secondaryButton.TextColor3 = Theme.Colors.Text
    secondaryButton.Font = Theme.Font.Bold
    secondaryButton.TextSize = 13
    secondaryButton.ZIndex = 202
    secondaryButton.Parent = modal

    local secondaryCorner = Instance.new("UICorner")
    secondaryCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    secondaryCorner.Parent = secondaryButton

    return {
        Gui = gui,
        Overlay = overlay,
        Message = message,
        CloseButton = closeButton,
        PrimaryButton = primaryButton,
        SecondaryButton = secondaryButton,

        Open = function(text, primaryText, secondaryText)
            message.Text = tr(text or "")
            primaryButton.Text = tr(primaryText or "Entrar")
            secondaryButton.Text = tr(secondaryText or "Cancelar")
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ConfirmModal
