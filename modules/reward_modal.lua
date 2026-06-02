local RewardModal = {}

function RewardModal.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "RewardOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 100
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 420, 0, 380)
    modal.Position = UDim2.new(0.5, -210, 0.5, -190)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 101
    modal.Parent = overlay

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -52, 0, 32)
    title.Position = UDim2.new(0, 18, 0, 14)
    title.BackgroundTransparency = 1
    title.Text = "TU CODIGO DE PREMIO ES:"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 102
    title.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 28)
    closeButton.Position = UDim2.new(1, -42, 0, 14)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 102
    closeButton.Parent = modal

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local codeLabel = Instance.new("TextLabel")
    codeLabel.Name = "CodeLabel"
    codeLabel.Size = UDim2.new(1, -36, 0, 46)
    codeLabel.Position = UDim2.new(0, 18, 0, 54)
    codeLabel.BackgroundColor3 = Theme.Colors.PanelLight
    codeLabel.BorderSizePixel = 0
    codeLabel.Text = ""
    codeLabel.TextColor3 = Theme.Colors.Text
    codeLabel.Font = Theme.Font.Bold
    codeLabel.TextSize = 18
    codeLabel.TextXAlignment = Enum.TextXAlignment.Center
    codeLabel.ZIndex = 102
    codeLabel.Parent = modal

    local codeCorner = Instance.new("UICorner")
    codeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    codeCorner.Parent = codeLabel

    local copyButton = Instance.new("TextButton")
    copyButton.Name = "CopyButton"
    copyButton.Size = UDim2.new(0, 110, 0, 32)
    copyButton.Position = UDim2.new(1, -128, 0, 108)
    copyButton.BackgroundColor3 = Theme.Colors.AccentSoft
    copyButton.BorderSizePixel = 0
    copyButton.Text = "Copiar"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Theme.Font.Bold
    copyButton.TextSize = 12
    copyButton.ZIndex = 102
    copyButton.Parent = modal

    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    copyCorner.Parent = copyButton

    local userInfo = Instance.new("TextLabel")
    userInfo.Name = "UserInfo"
    userInfo.Size = UDim2.new(1, -36, 0, 42)
    userInfo.Position = UDim2.new(0, 18, 0, 146)
    userInfo.BackgroundTransparency = 1
    userInfo.Text = ""
    userInfo.TextColor3 = Theme.Colors.TextMuted
    userInfo.Font = Theme.Font.Regular
    userInfo.TextSize = 12
    userInfo.TextWrapped = true
    userInfo.TextXAlignment = Enum.TextXAlignment.Left
    userInfo.TextYAlignment = Enum.TextYAlignment.Top
    userInfo.ZIndex = 102
    userInfo.Parent = modal

    local codeInput = Instance.new("TextBox")
    codeInput.Name = "CodeInput"
    codeInput.Size = UDim2.new(1, -36, 0, 38)
    codeInput.Position = UDim2.new(0, 18, 0, 198)
    codeInput.BackgroundColor3 = Theme.Colors.PanelLight
    codeInput.BorderSizePixel = 0
    codeInput.PlaceholderText = "Introducir Codigo"
    codeInput.Text = ""
    codeInput.TextColor3 = Theme.Colors.Text
    codeInput.PlaceholderColor3 = Theme.Colors.TextMuted
    codeInput.Font = Theme.Font.Regular
    codeInput.TextSize = 13
    codeInput.ClearTextOnFocus = false
    codeInput.ZIndex = 102
    codeInput.Parent = modal

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    inputCorner.Parent = codeInput

    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 12)
    inputPadding.PaddingRight = UDim.new(0, 12)
    inputPadding.Parent = codeInput

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Name = "ErrorLabel"
    errorLabel.Size = UDim2.new(1, -36, 0, 18)
    errorLabel.Position = UDim2.new(0, 18, 0, 236)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = ""
    errorLabel.TextColor3 = Theme.Colors.Danger
    errorLabel.Font = Theme.Font.Bold
    errorLabel.TextSize = 11
    errorLabel.TextWrapped = true
    errorLabel.TextXAlignment = Enum.TextXAlignment.Left
    errorLabel.ZIndex = 102
    errorLabel.Parent = modal

    local note = Instance.new("TextLabel")
    note.Name = "Note"
    note.Size = UDim2.new(1, -36, 0, 44)
    note.Position = UDim2.new(0, 18, 0, 258)
    note.BackgroundTransparency = 1
    note.Text = "Nota: El Premio puede ser canjeado en esta ventana, en la tienda o Redes Sociales del Script"
    note.TextColor3 = Theme.Colors.TextMuted
    note.Font = Theme.Font.Regular
    note.TextSize = 11
    note.TextWrapped = true
    note.TextXAlignment = Enum.TextXAlignment.Left
    note.TextYAlignment = Enum.TextYAlignment.Top
    note.ZIndex = 102
    note.Parent = modal

    local successText = Instance.new("TextLabel")
    successText.Name = "SuccessText"
    successText.Size = UDim2.new(1, -36, 0, 84)
    successText.Position = UDim2.new(0, 18, 0, 244)
    successText.BackgroundTransparency = 1
    successText.Text = ""
    successText.TextColor3 = Theme.Colors.Text
    successText.Font = Theme.Font.Bold
    successText.TextSize = 13
    successText.TextWrapped = true
    successText.TextXAlignment = Enum.TextXAlignment.Center
    successText.TextYAlignment = Enum.TextYAlignment.Top
    successText.Visible = false
    successText.ZIndex = 102
    successText.Parent = modal

    local redeemButton = Instance.new("TextButton")
    redeemButton.Name = "RedeemButton"
    redeemButton.Size = UDim2.new(0.5, -24, 0, 38)
    redeemButton.Position = UDim2.new(0, 18, 1, -52)
    redeemButton.BackgroundColor3 = Theme.Colors.AccentSoft
    redeemButton.BorderSizePixel = 0
    redeemButton.Text = "Canjear"
    redeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    redeemButton.Font = Theme.Font.Bold
    redeemButton.TextSize = 13
    redeemButton.ZIndex = 102
    redeemButton.Parent = modal

    local redeemCorner = Instance.new("UICorner")
    redeemCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    redeemCorner.Parent = redeemButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0.5, -24, 0, 38)
    cancelButton.Position = UDim2.new(0.5, 6, 1, -52)
    cancelButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelButton.BorderSizePixel = 0
    cancelButton.Text = "Cerrar"
    cancelButton.TextColor3 = Theme.Colors.Text
    cancelButton.Font = Theme.Font.Bold
    cancelButton.TextSize = 13
    cancelButton.ZIndex = 102
    cancelButton.Parent = modal

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelButton

    local currentCode = ""

    copyButton.MouseButton1Click:Connect(function()
        if setclipboard and currentCode ~= "" then
            setclipboard(currentCode)
            copyButton.Text = "Copiado"
            task.delay(1.5, function()
                if copyButton.Parent then
                    copyButton.Text = "Copiar"
                end
            end)
        end
    end)

    local function setSuccessVisible(isVisible)
        note.Visible = not isVisible
        successText.Visible = isVisible
        codeInput.Visible = not isVisible
        redeemButton.Visible = not isVisible
    end

    return {
        Overlay = overlay,
        CodeLabel = codeLabel,
        CodeInput = codeInput,
        CopyButton = copyButton,
        RedeemButton = redeemButton,
        CloseButton = closeButton,
        CancelButton = cancelButton,
        UserInfo = userInfo,
        SuccessText = successText,
        ErrorLabel = errorLabel,

        GetCode = function()
            return codeInput.Text or ""
        end,

        ShowSuccess = function()
            title.Text = "¡Felicidades, Canjeaste tu código con éxito!"
            successText.Text =
                "El premio será entregado por @Intensiveee(RyanGosling), Aceptalo en amigos solo para la entrega del Premio (El Premio se tarda en entregar hasta en 24 horas)."
            errorLabel.Text = ""
            setSuccessVisible(true)
        end,

        ShowError = function(message)
            if _G.StrikeChatI18n then
                errorLabel.Text = _G.StrikeChatI18n.TranslateText(message or "No se pudo canjear el codigo.")
            else
                errorLabel.Text = message or "No se pudo canjear el codigo."
            end
        end,

        ClearError = function()
            errorLabel.Text = ""
        end,

        Open = function(code, userId, username)
            currentCode = tostring(code or "")
            title.Text = "TU CÓDIGO DE PREMIO ES:"
            codeLabel.Text = currentCode
            codeInput.Text = currentCode
            userInfo.Text =
                "User ID Roblox: " .. tostring(userId or "") ..
                "\nNombre de usuario: " .. tostring(username or "")
            copyButton.Text = "Copiar"
            errorLabel.Text = ""
            setSuccessVisible(false)
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end
    }
end

return RewardModal
