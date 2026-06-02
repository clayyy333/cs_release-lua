local AdminPanelUI = {}

function AdminPanelUI.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "AdminPanelOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 120
    overlay.Parent = parent

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local function stroke(instance, color, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or Color3.fromRGB(80, 82, 92)
        uiStroke.Thickness = 1
        uiStroke.Transparency = transparency or 0.35
        uiStroke.Parent = instance
        return uiStroke
    end

    local function addPadding(instance, left, right, top, bottom)
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, left or 10)
        pad.PaddingRight = UDim.new(0, right or 10)
        pad.PaddingTop = UDim.new(0, top or 0)
        pad.PaddingBottom = UDim.new(0, bottom or 0)
        pad.Parent = instance
        return pad
    end

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0, 560, 0, 390)
    modal.Position = UDim2.new(0.5, -280, 0.5, -195)
    modal.BackgroundColor3 = Color3.fromRGB(48, 49, 55)
    modal.BorderSizePixel = 0
    modal.ZIndex = 121
    modal.Parent = overlay
    round(modal, 12)
    stroke(modal, Color3.fromRGB(96, 98, 110), 0.38)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -52, 0, 34)
    title.Position = UDim2.new(0, 18, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Panel Admin"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 122
    title.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 24)
    closeButton.Position = UDim2.new(1, -38, 0, 14)
    closeButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 122
    closeButton.Parent = modal
    round(closeButton, 8)

    local noticeTitle = Instance.new("TextLabel")
    noticeTitle.Name = "NoticeTitle"
    noticeTitle.Size = UDim2.new(0, 236, 0, 22)
    noticeTitle.Position = UDim2.new(0, 18, 0, 56)
    noticeTitle.BackgroundTransparency = 1
    noticeTitle.Text = "Enviar Aviso"
    noticeTitle.TextColor3 = Theme.Colors.Text
    noticeTitle.Font = Theme.Font.Bold
    noticeTitle.TextSize = 13
    noticeTitle.TextXAlignment = Enum.TextXAlignment.Left
    noticeTitle.ZIndex = 122
    noticeTitle.Parent = modal

    local noticeInput = Instance.new("TextBox")
    noticeInput.Name = "NoticeInput"
    noticeInput.Size = UDim2.new(0, 244, 0, 88)
    noticeInput.Position = UDim2.new(0, 18, 0, 84)
    noticeInput.BackgroundColor3 = Color3.fromRGB(40, 41, 47)
    noticeInput.BorderSizePixel = 0
    noticeInput.Text = ""
    noticeInput.PlaceholderText = "Mensaje para todos"
    noticeInput.TextColor3 = Theme.Colors.Text
    noticeInput.PlaceholderColor3 = Theme.Colors.TextMuted
    noticeInput.Font = Theme.Font.Regular
    noticeInput.TextSize = 12
    noticeInput.TextWrapped = true
    noticeInput.TextXAlignment = Enum.TextXAlignment.Left
    noticeInput.TextYAlignment = Enum.TextYAlignment.Top
    noticeInput.ClearTextOnFocus = false
    noticeInput.MultiLine = true
    noticeInput.ZIndex = 122
    noticeInput.Parent = modal
    round(noticeInput, 8)
    stroke(noticeInput, Color3.fromRGB(72, 74, 84), 0.45)
    addPadding(noticeInput, 10, 10, 8, 8)

    local sendNoticeButton = Instance.new("TextButton")
    sendNoticeButton.Name = "SendNoticeButton"
    sendNoticeButton.Size = UDim2.new(0, 118, 0, 30)
    sendNoticeButton.Position = UDim2.new(0, 18, 0, 184)
    sendNoticeButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
    sendNoticeButton.BorderSizePixel = 0
    sendNoticeButton.Text = "Enviar"
    sendNoticeButton.TextColor3 = Theme.Colors.Text
    sendNoticeButton.Font = Theme.Font.Bold
    sendNoticeButton.TextSize = 12
    sendNoticeButton.ZIndex = 122
    sendNoticeButton.Parent = modal
    round(sendNoticeButton, 8)

    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0, 246, 0, 30)
    refreshButton.Position = UDim2.new(0, 292, 1, -42)
    refreshButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    refreshButton.BorderSizePixel = 0
    refreshButton.Text = "Actualizar"
    refreshButton.TextColor3 = Theme.Colors.Text
    refreshButton.Font = Theme.Font.Bold
    refreshButton.TextSize = 12
    refreshButton.ZIndex = 122
    refreshButton.Parent = modal
    round(refreshButton, 8)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 244, 0, 44)
    statusLabel.Position = UDim2.new(0, 18, 0, 226)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 11
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextYAlignment = Enum.TextYAlignment.Top
    statusLabel.ZIndex = 122
    statusLabel.Parent = modal

    local pendingTitle = Instance.new("TextLabel")
    pendingTitle.Name = "PendingTitle"
    pendingTitle.Size = UDim2.new(0, 246, 0, 22)
    pendingTitle.Position = UDim2.new(0, 292, 0, 56)
    pendingTitle.BackgroundTransparency = 1
    pendingTitle.Text = "Premios pendientes"
    pendingTitle.TextColor3 = Theme.Colors.Text
    pendingTitle.Font = Theme.Font.Bold
    pendingTitle.TextSize = 13
    pendingTitle.TextXAlignment = Enum.TextXAlignment.Left
    pendingTitle.ZIndex = 122
    pendingTitle.Parent = modal

    local pendingList = Instance.new("ScrollingFrame")
    pendingList.Name = "PendingList"
    pendingList.Size = UDim2.new(0, 246, 0, 236)
    pendingList.Position = UDim2.new(0, 292, 0, 84)
    pendingList.BackgroundColor3 = Color3.fromRGB(40, 41, 47)
    pendingList.BorderSizePixel = 0
    pendingList.ScrollBarThickness = 3
    pendingList.CanvasSize = UDim2.new(0, 0, 0, 0)
    pendingList.ZIndex = 122
    pendingList.Parent = modal
    round(pendingList, 8)
    stroke(pendingList, Color3.fromRGB(72, 74, 84), 0.45)

    local pendingLayout = Instance.new("UIListLayout")
    pendingLayout.Padding = UDim.new(0, 6)
    pendingLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pendingLayout.Parent = pendingList

    local pendingPadding = Instance.new("UIPadding")
    pendingPadding.PaddingTop = UDim.new(0, 8)
    pendingPadding.PaddingLeft = UDim.new(0, 8)
    pendingPadding.PaddingRight = UDim.new(0, 8)
    pendingPadding.Parent = pendingList

    local detailOverlay = Instance.new("Frame")
    detailOverlay.Name = "DetailOverlay"
    detailOverlay.Size = UDim2.new(1, 0, 1, 0)
    detailOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    detailOverlay.BackgroundTransparency = 0.35
    detailOverlay.Visible = false
    detailOverlay.ZIndex = 130
    detailOverlay.Parent = overlay

    local detailModal = Instance.new("Frame")
    detailModal.Name = "DetailModal"
    detailModal.Size = UDim2.new(0, 300, 0, 180)
    detailModal.Position = UDim2.new(0.5, -150, 0.5, -90)
    detailModal.BackgroundColor3 = Color3.fromRGB(48, 49, 55)
    detailModal.BorderSizePixel = 0
    detailModal.ZIndex = 131
    detailModal.Parent = detailOverlay
    round(detailModal, 12)
    stroke(detailModal, Color3.fromRGB(96, 98, 110), 0.38)

    local detailText = Instance.new("TextLabel")
    detailText.Name = "DetailText"
    detailText.Size = UDim2.new(1, -32, 0, 84)
    detailText.Position = UDim2.new(0, 16, 0, 18)
    detailText.BackgroundTransparency = 1
    detailText.Text = ""
    detailText.TextColor3 = Theme.Colors.Text
    detailText.Font = Theme.Font.Regular
    detailText.TextSize = 12
    detailText.TextWrapped = true
    detailText.TextXAlignment = Enum.TextXAlignment.Left
    detailText.TextYAlignment = Enum.TextYAlignment.Top
    detailText.ZIndex = 132
    detailText.Parent = detailModal

    local deliveredButton = Instance.new("TextButton")
    deliveredButton.Name = "DeliveredButton"
    deliveredButton.Size = UDim2.new(0, 118, 0, 32)
    deliveredButton.Position = UDim2.new(0, 24, 1, -48)
    deliveredButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
    deliveredButton.BorderSizePixel = 0
    deliveredButton.Text = "Entregado"
    deliveredButton.TextColor3 = Theme.Colors.Text
    deliveredButton.Font = Theme.Font.Bold
    deliveredButton.TextSize = 12
    deliveredButton.ZIndex = 132
    deliveredButton.Parent = detailModal
    round(deliveredButton, 8)

    local backButton = Instance.new("TextButton")
    backButton.Name = "BackButton"
    backButton.Size = UDim2.new(0, 118, 0, 32)
    backButton.Position = UDim2.new(1, -142, 1, -48)
    backButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    backButton.BorderSizePixel = 0
    backButton.Text = "Atras"
    backButton.TextColor3 = Theme.Colors.Text
    backButton.Font = Theme.Font.Bold
    backButton.TextSize = 12
    backButton.ZIndex = 132
    backButton.Parent = detailModal
    round(backButton, 8)

    local function getRewardAmount(rewardType)
        if rewardType == "robux_1000" then
            return "1000"
        end

        if rewardType == "robux_100" then
            return "100"
        end

        return tostring(rewardType or "?")
    end

    local function clearPendingList()
        for _, child in ipairs(pendingList:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
    end

    local function renderPending(groups, onSelect)
        clearPendingList()

        if not groups or #groups == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, -4, 0, 36)
            empty.BackgroundTransparency = 1
            empty.Text = "Sin premios pendientes."
            empty.TextColor3 = Theme.Colors.TextMuted
            empty.Font = Theme.Font.Regular
            empty.TextSize = 11
            empty.TextWrapped = true
            empty.ZIndex = 123
            empty.Parent = pendingList
        else
            for index, group in ipairs(groups) do
                local row = Instance.new("TextButton")
                row.Name = "PendingRow"
                row.Size = UDim2.new(1, -4, 0, 54)
                row.BackgroundColor3 = Color3.fromRGB(50, 51, 58)
                row.BorderSizePixel = 0
                row.Text = ""
                row.LayoutOrder = index
                row.ZIndex = 123
                row.Parent = pendingList
                round(row, 8)

                local name = Instance.new("TextLabel")
                name.Size = UDim2.new(1, -12, 0, 18)
                name.Position = UDim2.new(0, 8, 0, 6)
                name.BackgroundTransparency = 1
                name.Text = tostring(group.roblox_username or "Usuario")
                name.TextColor3 = Theme.Colors.Text
                name.Font = Theme.Font.Bold
                name.TextSize = 11
                name.TextXAlignment = Enum.TextXAlignment.Left
                name.TextTruncate = Enum.TextTruncate.AtEnd
                name.ZIndex = 124
                name.Parent = row

                local info = Instance.new("TextLabel")
                info.Size = UDim2.new(1, -12, 0, 26)
                info.Position = UDim2.new(0, 8, 0, 24)
                info.BackgroundTransparency = 1
                info.Text =
                    "ID " .. tostring(group.roblox_user_id) ..
                    " | Cantidad " .. tostring(group.count) ..
                    " | " .. getRewardAmount(group.reward_type)
                info.TextColor3 = Theme.Colors.TextMuted
                info.Font = Theme.Font.Regular
                info.TextSize = 10
                info.TextXAlignment = Enum.TextXAlignment.Left
                info.TextTruncate = Enum.TextTruncate.AtEnd
                info.ZIndex = 124
                info.Parent = row

                row.MouseButton1Click:Connect(function()
                    if onSelect then
                        onSelect(group)
                    end
                end)
            end
        end

        task.wait()
        pendingList.CanvasSize = UDim2.new(0, 0, 0, pendingLayout.AbsoluteContentSize.Y + 16)
    end

    return {
        Overlay = overlay,
        CloseButton = closeButton,
        NoticeInput = noticeInput,
        SendNoticeButton = sendNoticeButton,
        RefreshButton = refreshButton,
        DeliveredButton = deliveredButton,
        BackButton = backButton,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
            detailOverlay.Visible = false
        end,

        ShowStatus = function(message, isError)
            if _G.StrikeChatI18n then
                statusLabel.Text = _G.StrikeChatI18n.TranslateText(message or "")
            else
                statusLabel.Text = message or ""
            end

            statusLabel.TextColor3 = isError and Theme.Colors.Danger or Theme.Colors.TextMuted
        end,

        RenderPending = renderPending,

        OpenRewardDetail = function(group)
            detailText.Text =
                "Usuario: " .. tostring(group.roblox_username or "Usuario") ..
                "\nID: " .. tostring(group.roblox_user_id) ..
                "\nPremio: " .. getRewardAmount(group.reward_type) .. " Robux" ..
                "\nCantidad pendiente: " .. tostring(group.count)
            detailOverlay.Visible = true
        end,

        CloseRewardDetail = function()
            detailOverlay.Visible = false
        end
    }
end

function AdminPanelUI.CreateSecurityPrompt(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "AdminSecurityOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 150
    overlay.Parent = parent

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local function stroke(instance, color, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or Color3.fromRGB(80, 82, 92)
        uiStroke.Thickness = 1
        uiStroke.Transparency = transparency or 0.35
        uiStroke.Parent = instance
        return uiStroke
    end

    local modal = Instance.new("Frame")
    modal.Name = "SecurityModal"
    modal.Size = UDim2.new(0, 320, 0, 184)
    modal.Position = UDim2.new(0.5, -160, 0.5, -92)
    modal.BackgroundColor3 = Color3.fromRGB(48, 49, 55)
    modal.BorderSizePixel = 0
    modal.ZIndex = 151
    modal.Parent = overlay
    round(modal, 12)
    stroke(modal, Color3.fromRGB(96, 98, 110), 0.38)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -36, 0, 40)
    title.Position = UDim2.new(0, 18, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = "Introducir codigo de seguridad"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 14
    title.TextWrapped = true
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 152
    title.Parent = modal

    local codeInput = Instance.new("TextBox")
    codeInput.Name = "CodeInput"
    codeInput.Size = UDim2.new(1, -36, 0, 34)
    codeInput.Position = UDim2.new(0, 18, 0, 64)
    codeInput.BackgroundColor3 = Color3.fromRGB(40, 41, 47)
    codeInput.BorderSizePixel = 0
    codeInput.Text = ""
    codeInput.PlaceholderText = "Codigo"
    codeInput.TextColor3 = Theme.Colors.Text
    codeInput.PlaceholderColor3 = Theme.Colors.TextMuted
    codeInput.Font = Theme.Font.Regular
    codeInput.TextSize = 13
    codeInput.ClearTextOnFocus = false
    codeInput.ZIndex = 152
    codeInput.Parent = modal
    round(codeInput, 8)
    stroke(codeInput, Color3.fromRGB(72, 74, 84), 0.45)

    local acceptButton = Instance.new("TextButton")
    acceptButton.Name = "AcceptButton"
    acceptButton.Size = UDim2.new(0, 132, 0, 32)
    acceptButton.Position = UDim2.new(0, 18, 1, -48)
    acceptButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
    acceptButton.BorderSizePixel = 0
    acceptButton.Text = "Aceptar"
    acceptButton.TextColor3 = Theme.Colors.Text
    acceptButton.Font = Theme.Font.Bold
    acceptButton.TextSize = 12
    acceptButton.ZIndex = 152
    acceptButton.Parent = modal
    round(acceptButton, 8)

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 132, 0, 32)
    closeButton.Position = UDim2.new(1, -150, 1, -48)
    closeButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "Cerrar"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 152
    closeButton.Parent = modal
    round(closeButton, 8)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -36, 0, 22)
    statusLabel.Position = UDim2.new(0, 18, 0, 104)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 152
    statusLabel.Parent = modal

    return {
        Overlay = overlay,
        CodeInput = codeInput,
        AcceptButton = acceptButton,
        CloseButton = closeButton,

        Open = function()
            overlay.Visible = true
            statusLabel.Text = ""
            codeInput:CaptureFocus()
        end,

        Close = function()
            overlay.Visible = false
        end,

        ShowStatus = function(message, isError)
            if _G.StrikeChatI18n then
                statusLabel.Text = _G.StrikeChatI18n.TranslateText(message or "")
            else
                statusLabel.Text = message or ""
            end

            statusLabel.TextColor3 = isError and Theme.Colors.Danger or Theme.Colors.TextMuted
        end
    }
end

return AdminPanelUI
