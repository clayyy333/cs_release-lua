local PasswordModal = {}

function PasswordModal.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "PasswordOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.Visible = false
    overlay.ZIndex = 80
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 300, 0, 170)
    modal.Position = UDim2.new(0.5, -150, 0.5, -85)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 81
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -24, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Contraseña de sala"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 82
    title.Parent = modal

    local input = Instance.new("TextBox")
    input.Name = "PasswordInput"
    input.Size = UDim2.new(1, -24, 0, 38)
    input.Position = UDim2.new(0, 12, 0, 56)
    input.BackgroundColor3 = Theme.Colors.PanelLight
    input.BorderSizePixel = 0
    input.PlaceholderText = "Ingresa la contraseña..."
    input.Text = ""
    input.TextColor3 = Theme.Colors.Text
    input.PlaceholderColor3 = Theme.Colors.TextMuted
    input.Font = Theme.Font.Regular
    input.TextSize = 14
    input.ClearTextOnFocus = false
    input.ZIndex = 82
    input.Parent = modal

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    inputCorner.Parent = input

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 12)
    inputPadding.Parent = input

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Name = "ErrorLabel"
    errorLabel.Size = UDim2.new(1, -24, 0, 18)
    errorLabel.Position = UDim2.new(0, 12, 0, 98)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Theme.Colors.Danger
    errorLabel.Font = Theme.Font.Bold
    errorLabel.TextSize = 11
    errorLabel.TextXAlignment = Enum.TextXAlignment.Left
    errorLabel.ZIndex = 82
    errorLabel.Parent = modal



    local enterButton = Instance.new("TextButton")
    enterButton.Name = "EnterButton"
    enterButton.Size = UDim2.new(0.5, -18, 0, 36)
    enterButton.Position = UDim2.new(0, 12, 1, -48)
    enterButton.BackgroundColor3 = Theme.Colors.AccentSoft
    enterButton.BorderSizePixel = 0
    enterButton.Text = "Entrar"
    enterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    enterButton.Font = Theme.Font.Bold
    enterButton.TextSize = 13
    enterButton.ZIndex = 82
    enterButton.Parent = modal

    local enterCorner = Instance.new("UICorner")
    enterCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    enterCorner.Parent = enterButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.5, -18, 0, 36)
    cancelButton.Position = UDim2.new(0.5, 6, 1, -48)
    cancelButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "Cancelar"
    cancelButton.TextColor3 = Theme.Colors.Text
    cancelButton.Font = Theme.Font.Bold
    cancelButton.TextSize = 13
    cancelButton.ZIndex = 82
    cancelButton.Parent = modal

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelButton

    return {
        Overlay = overlay,
        Input = input,
        ErrorLabel = errorLabel,
        EnterButton = enterButton,
        CancelButton = cancelButton,

        Open = function()
            input.Text = ""
            errorLabel.Text = ""
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end
    }
end

return PasswordModal