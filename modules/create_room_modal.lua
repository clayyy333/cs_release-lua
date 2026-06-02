local CreateRoomModal = {}

function CreateRoomModal.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "CreateRoomOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.35
    overlay.Visible = false
    overlay.ZIndex = 50
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 320, 0, 250)
    modal.Position = UDim2.new(0.5, -160, 0.5, -125)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 51
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 32)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Crear Sala"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 52
    title.Parent = modal

    local roomInput = Instance.new("TextBox")
    roomInput.Name = "RoomNameInput"
    roomInput.Size = UDim2.new(1, -24, 0, 38)
    roomInput.Position = UDim2.new(0, 12, 0, 58)
    roomInput.BackgroundColor3 = Theme.Colors.PanelLight
    roomInput.BorderSizePixel = 0
    roomInput.PlaceholderText = "Nombre de la sala..."
    roomInput.Text = ""
    roomInput.TextColor3 = Theme.Colors.Text
    roomInput.PlaceholderColor3 = Theme.Colors.TextMuted
    roomInput.Font = Theme.Font.Regular
    roomInput.TextSize = 14
    roomInput.ClearTextOnFocus = false
    roomInput.ZIndex = 52
    roomInput.Parent = modal

    local roomCorner = Instance.new("UICorner")
    roomCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    roomCorner.Parent = roomInput

    local roomPadding = Instance.new("UIPadding")
    roomPadding.PaddingLeft = UDim.new(0, 12)
    roomPadding.Parent = roomInput

    local publicOption = Instance.new("TextButton")
    publicOption.Name = "PublicOption"
    publicOption.Size = UDim2.new(0.5, -18, 0, 42)
    publicOption.Position = UDim2.new(0, 12, 0, 108)
    publicOption.BackgroundColor3 = Theme.Colors.PanelLight
    publicOption.BorderSizePixel = 0
    publicOption.Text = ""
    publicOption.ZIndex = 52
    publicOption.Parent = modal

    

    local publicCorner = Instance.new("UICorner")
    publicCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    publicCorner.Parent = publicOption

    local publicStroke = Instance.new("UIStroke")
    publicStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    publicStroke.Color = Color3.fromRGB(255, 255, 255)
    publicStroke.Thickness = 1
    publicStroke.Transparency = 0
    publicStroke.Enabled = true
    publicStroke.Parent = publicOption

    local publicCircle = Instance.new("Frame")
    publicCircle.Size = UDim2.new(0, 14, 0, 14)
    publicCircle.Position = UDim2.new(1, -26, 0.5, -7)
    publicCircle.BackgroundColor3 = Theme.Colors.AccentSoft
    publicCircle.BorderSizePixel = 0
    publicCircle.ZIndex = 53
    publicCircle.Parent = publicOption

    local publicCircleCorner = Instance.new("UICorner")
    publicCircleCorner.CornerRadius = UDim.new(1, 0)
    publicCircleCorner.Parent = publicCircle

    local publicText = Instance.new("TextLabel")
    publicText.Size = UDim2.new(1, -36, 1, 0)
    publicText.Position = UDim2.new(0, 32, 0, 0)
    publicText.BackgroundTransparency = 1
    publicText.Text = "Sala Pública"
    publicText.TextColor3 = Theme.Colors.Text
    publicText.Font = Theme.Font.Bold
    publicText.TextSize = 13
    publicText.TextXAlignment = Enum.TextXAlignment.Left
    publicText.ZIndex = 53
    publicText.Parent = publicOption

    local privateOption = Instance.new("TextButton")
    privateOption.Name = "PrivateOption"
    privateOption.Size = UDim2.new(0.5, -18, 0, 42)
    privateOption.Position = UDim2.new(0.5, 6, 0, 108)
    privateOption.BackgroundColor3 = Theme.Colors.PanelLight
    privateOption.BorderSizePixel = 0
    privateOption.Text = ""
    privateOption.ZIndex = 52
    privateOption.Parent = modal

   

    local privateCorner = Instance.new("UICorner")
    privateCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    privateCorner.Parent = privateOption

    local privateStroke = Instance.new("UIStroke")
    privateStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    privateStroke.Color = Color3.fromRGB(255, 255, 255)
    privateStroke.Thickness = 1
    privateStroke.Transparency = 0
    privateStroke.Enabled = false
    privateStroke.Parent = privateOption

    local privateCircle = Instance.new("Frame")
    privateCircle.Size = UDim2.new(0, 14, 0, 14)
    privateCircle.Position = UDim2.new(1, -26, 0.5, -7)
    privateCircle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    privateCircle.BorderSizePixel = 0
    privateCircle.ZIndex = 53
    privateCircle.Parent = privateOption

    local privateCircleCorner = Instance.new("UICorner")
    privateCircleCorner.CornerRadius = UDim.new(1, 0)
    privateCircleCorner.Parent = privateCircle

    local privateText = Instance.new("TextLabel")
    privateText.Size = UDim2.new(1, -36, 1, 0)
    privateText.Position = UDim2.new(0, 32, 0, 0)
    privateText.BackgroundTransparency = 1
    privateText.Text = "Sala Privada"
    privateText.TextColor3 = Theme.Colors.Text
    privateText.Font = Theme.Font.Bold
    privateText.TextSize = 13
    privateText.TextXAlignment = Enum.TextXAlignment.Left
    privateText.ZIndex = 53
    privateText.Parent = privateOption

    local passwordInput = Instance.new("TextBox")
    passwordInput.Name = "PasswordInput"
    passwordInput.Size = UDim2.new(1, -24, 0, 38)
    passwordInput.Position = UDim2.new(0, 12, 0, 158)
    passwordInput.BackgroundColor3 = Theme.Colors.PanelLight
    passwordInput.BorderSizePixel = 0
    passwordInput.PlaceholderText = "Contraseña..."
    passwordInput.Text = ""
    passwordInput.TextColor3 = Theme.Colors.Text
    passwordInput.PlaceholderColor3 = Theme.Colors.TextMuted
    passwordInput.Font = Theme.Font.Regular
    passwordInput.TextSize = 14
    passwordInput.ClearTextOnFocus = false
    passwordInput.Visible = false
    passwordInput.ZIndex = 52
    passwordInput.Parent = modal

    local passwordCorner = Instance.new("UICorner")
    passwordCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    passwordCorner.Parent = passwordInput

    local passwordPadding = Instance.new("UIPadding")
    passwordPadding.PaddingLeft = UDim.new(0, 12)
    passwordPadding.Parent = passwordInput

    local createButton = Instance.new("TextButton")
    createButton.Name = "CreateButton"
    createButton.Size = UDim2.new(0.5, -18, 0, 38)
    createButton.Position = UDim2.new(0, 12, 1, -50)
    createButton.BackgroundColor3 = Theme.Colors.AccentSoft
    createButton.BorderSizePixel = 0
    createButton.Text = "Crear"
    createButton.TextColor3 = Color3.fromRGB(255,255,255)
    createButton.Font = Theme.Font.Bold
    createButton.TextSize = 13
    createButton.ZIndex = 52
    createButton.Parent = modal

    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    createCorner.Parent = createButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.5, -18, 0, 38)
    cancelButton.Position = UDim2.new(0.5, 6, 1, -50)
    cancelButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "Cancelar"
    cancelButton.TextColor3 = Theme.Colors.Text
    cancelButton.Font = Theme.Font.Bold
    cancelButton.TextSize = 13
    cancelButton.ZIndex = 52
    cancelButton.Parent = modal

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelButton

    local isPrivate = false

    local function updateRoomTypeUI()
        publicOption.BackgroundColor3 = Theme.Colors.PanelLight
        privateOption.BackgroundColor3 = Theme.Colors.PanelLight

        publicOption.BackgroundTransparency = 0
        privateOption.BackgroundTransparency = 0

        if isPrivate then
            publicCircle.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            privateCircle.BackgroundColor3 = Theme.Colors.AccentSoft

            publicStroke.Enabled = false
            privateStroke.Enabled = true

            passwordInput.Visible = true
        else
            publicCircle.BackgroundColor3 = Theme.Colors.AccentSoft
            privateCircle.BackgroundColor3 = Color3.fromRGB(55, 55, 65)

            publicStroke.Enabled = true
            privateStroke.Enabled = false

            passwordInput.Visible = false
        end
    end

    publicOption.MouseEnter:Connect(function()
        publicStroke.Enabled = true
    end)

    publicOption.MouseLeave:Connect(function()
        if isPrivate then
            publicStroke.Enabled = false
        end
    end)

    privateOption.MouseEnter:Connect(function()
        privateStroke.Enabled = true
    end)

    privateOption.MouseLeave:Connect(function()
        if not isPrivate then
            privateStroke.Enabled = false
        end
    end)

    publicOption.MouseButton1Click:Connect(function()
        isPrivate = false
        updateRoomTypeUI()
    end)

    privateOption.MouseButton1Click:Connect(function()
        isPrivate = true
        updateRoomTypeUI()
    end)

    updateRoomTypeUI()

    return {
        Overlay = overlay,
        RoomInput = roomInput,
        PasswordInput = passwordInput,
        CreateButton = createButton,
        CancelButton = cancelButton,

        IsPrivate = function()
            return isPrivate
        end,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end
    }
end

return CreateRoomModal