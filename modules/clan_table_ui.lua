local ClanTableUI = {}

function ClanTableUI.Create(parent, Theme, clans)
    local isMobileLayout = _G.StrikeChatLayoutMode == "mobile"
    local selectedClan = clans and clans[1] or nil
    local currentClanId = nil
    local ownedClanId = nil
    local pendingRequestClanId = nil
    local joinActionHandler = nil
    local updateJoinButton = function() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ClanTableUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0, 920, 0, 490)
    root.Position = UDim2.new(0.5, -460, 0.5, -245)
    root.BackgroundColor3 = Theme.Colors.Background

    local rootGradient = Instance.new("UIGradient")
    rootGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.Colors.PanelLight),
        ColorSequenceKeypoint.new(0.5, Theme.Colors.Background),
        ColorSequenceKeypoint.new(1, Theme.Colors.SoftBlack)
    })
    rootGradient.Rotation = 90
    rootGradient.Parent = root
    
    local backgroundImage = Instance.new("ImageLabel")
    backgroundImage.Name = "BackgroundImage"
    backgroundImage.Size = UDim2.new(1, 0, 1, 0)
    backgroundImage.Position = UDim2.new(0, 0, 0, 0)
    backgroundImage.BackgroundTransparency = 1
    backgroundImage.Image = "rbxassetid://104513803022128"
    backgroundImage.ScaleType = Enum.ScaleType.Crop
    backgroundImage.ImageTransparency = 0
    backgroundImage.ZIndex = 1
    backgroundImage.Parent = root

    local backgroundImageCorner = Instance.new("UICorner")
    backgroundImageCorner.CornerRadius = UDim.new(0, 12)
    backgroundImageCorner.Parent = backgroundImage

    root.BorderSizePixel = 0
    root.Parent = gui

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 12)
    rootCorner.Parent = root

    local rootStroke = Instance.new("UIStroke")
    rootStroke.Color = Color3.fromRGB(55, 55, 64)
    rootStroke.Thickness = 1
    rootStroke.Transparency = 0.2
    rootStroke.Parent = root


    local titleContainer = Instance.new("Frame")
    titleContainer.Name = "TitleContainer"
    titleContainer.Size = UDim2.new(1, -160, 0, 54)
    titleContainer.Position = UDim2.new(0, 80, 0, 18)
    titleContainer.BackgroundTransparency = 1
    titleContainer.ZIndex = 2
    titleContainer.Parent = root

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TABLA DE CLANES / FAMILIAS"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = titleContainer

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -58, 0, 18)
    closeButton.BackgroundColor3 = Color3.fromRGB(120, 36, 36)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 18
    closeButton.ZIndex = 2
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = UDim2.new(1, -40, 1, -138)
    mainContainer.Position = UDim2.new(0, 20, 0, 78)
    mainContainer.BackgroundTransparency = 1
    mainContainer.BorderSizePixel = 0
    mainContainer.ZIndex = 2
    mainContainer.Parent = root

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "LeftPanel"
    leftPanel.Size = UDim2.new(0.64, -10, 1, 0)
    leftPanel.Position = UDim2.new(0, 0, 0, 0)
    leftPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    leftPanel.BackgroundTransparency = 0.18
    leftPanel.BorderSizePixel = 0
    leftPanel.Parent = mainContainer

    local leftCorner = Instance.new("UICorner")
    leftCorner.CornerRadius = UDim.new(0, 8)
    leftCorner.Parent = leftPanel

    local leftStroke = Instance.new("UIStroke")
    leftStroke.Color = Color3.fromRGB(75, 75, 82)
    leftStroke.Thickness = 1
    leftStroke.Transparency = 0.15
    leftStroke.Parent = leftPanel

    local tableHeader = Instance.new("Frame")
    tableHeader.Name = "TableHeader"
    tableHeader.Size = UDim2.new(1, -24, 0, 34)
    tableHeader.Position = UDim2.new(0, 12, 0, 12)
    tableHeader.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
    tableHeader.BackgroundTransparency = 0.12
    tableHeader.BorderSizePixel = 0
    tableHeader.Parent = leftPanel

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 6)
    headerCorner.Parent = tableHeader

    local posHeader = Instance.new("TextLabel")
    posHeader.Size = UDim2.new(0, 52, 1, 0)
    posHeader.Position = UDim2.new(0, 10, 0, 0)
    posHeader.BackgroundTransparency = 1
    posHeader.Text = "POS"
    posHeader.TextColor3 = Theme.Colors.TextMuted
    posHeader.Font = Theme.Font.Bold
    posHeader.TextSize = 11
    posHeader.TextXAlignment = Enum.TextXAlignment.Left
    posHeader.Parent = tableHeader

    local nameHeader = Instance.new("TextLabel")
    nameHeader.Size = UDim2.new(0, 150, 1, 0)
    nameHeader.Position = UDim2.new(0, 70, 0, 0)
    nameHeader.BackgroundTransparency = 1
    nameHeader.Text = "CLAN/FAMILIA"
    nameHeader.TextColor3 = Theme.Colors.TextMuted
    nameHeader.Font = Theme.Font.Bold
    nameHeader.TextSize = 11
    nameHeader.TextXAlignment = Enum.TextXAlignment.Left
    nameHeader.Parent = tableHeader

    local pointsHeader = Instance.new("TextLabel")
    pointsHeader.Size = UDim2.new(0, 80, 1, 0)
    pointsHeader.Position = UDim2.new(0, 220, 0, 0)
    pointsHeader.BackgroundTransparency = 1
    pointsHeader.Text = "PUNTOS"
    pointsHeader.TextColor3 = Theme.Colors.TextMuted
    pointsHeader.Font = Theme.Font.Bold
    pointsHeader.TextSize = 11
    pointsHeader.TextXAlignment = Enum.TextXAlignment.Left
    pointsHeader.Parent = tableHeader

    local descHeader = Instance.new("TextLabel")
    descHeader.Size = UDim2.new(1, -310, 1, 0)
    descHeader.Position = UDim2.new(0, 316, 0, 0)
    descHeader.BackgroundTransparency = 1
    descHeader.Text = "DESCRIPCIÓN"
    descHeader.TextColor3 = Theme.Colors.TextMuted
    descHeader.Font = Theme.Font.Bold
    descHeader.TextSize = 11
    descHeader.TextXAlignment = Enum.TextXAlignment.Left
    descHeader.Parent = tableHeader

    local clanList = Instance.new("ScrollingFrame")
    clanList.Name = "ClanList"
    clanList.Size = UDim2.new(1, -32, 1, -62)
    clanList.Position = UDim2.new(0, 16, 0, 54)
    clanList.BackgroundTransparency = 1
    clanList.BorderSizePixel = 0
    clanList.ScrollBarThickness = 4
    clanList.CanvasSize = UDim2.new(0, 0, 0, 0)
    clanList.Parent = leftPanel

    local clanListLayout = Instance.new("UIListLayout")
    clanListLayout.Padding = UDim.new(0, 6)
    clanListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    clanListLayout.Parent = clanList

    local clanListPadding = Instance.new("UIPadding")
    clanListPadding.PaddingTop = UDim.new(0, 6)
    clanListPadding.PaddingLeft = UDim.new(0, 2)
    clanListPadding.PaddingRight = UDim.new(0, 2)
    clanListPadding.Parent = clanList


    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "RightPanel"
    rightPanel.Size = UDim2.new(0.36, -10, 1, 44)
    rightPanel.Position = UDim2.new(0.64, 10, 0, 0)
    rightPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    rightPanel.BackgroundTransparency = 0.18
    rightPanel.BorderSizePixel = 0
    rightPanel.Parent = mainContainer

    local rightCorner = Instance.new("UICorner")
    rightCorner.CornerRadius = UDim.new(0, 8)
    rightCorner.Parent = rightPanel

    local rightStroke = Instance.new("UIStroke")
    rightStroke.Color = Color3.fromRGB(75, 75, 82)
    rightStroke.Thickness = 1
    rightStroke.Transparency = 0.15
    rightStroke.Parent = rightPanel

    local clanTitle
    local clanPoints
    local clanPointsValue
    local clanMembers
    local clanMembersValue
    local clanDescription

    local function createClanRow(position, clan)

        local memberCount = #(clan.members or {})
        local pointsValue = clan.total_points_earned or 0
        local descriptionText = clan.description or ""

        local row = Instance.new("TextButton")
        row.Name = "ClanRow"
        row.Size = UDim2.new(1, 0, 0, isMobileLayout and 32 or 42)
        row.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
        row.BackgroundTransparency = 0.1
        
        row.BorderSizePixel = 0
        row.Text = ""
        row.Parent = clanList

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 6)
        rowCorner.Parent = row

        local rowStroke = Instance.new("UIStroke")
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        rowStroke.Color = Color3.fromRGB(55, 55, 64)
        rowStroke.Thickness = 1
        rowStroke.Transparency = 1
        rowStroke.Parent = row

        row.MouseButton1Click:Connect(function()
            selectedClan = clan

            for _, child in ipairs(clanList:GetChildren()) do
                if child:IsA("TextButton") then
                    local stroke = child:FindFirstChildOfClass("UIStroke")

                    if stroke then
                        stroke.Color = Color3.fromRGB(55, 55, 64)
                        stroke.Transparency = 1
                    end
                end
            end

            rowStroke.Color = Color3.fromRGB(255, 255, 255)
            rowStroke.Transparency = 0.15

            clanTitle.Text = tostring(clan.name or "Clan")

            clanPointsValue.Text =
                tostring(pointsValue)

            clanMembersValue.Text =
                tostring(memberCount)

            clanDescription.Text =
                tostring(descriptionText)

            updateJoinButton()
        end)

        local pos = Instance.new("TextLabel")
        pos.Size = UDim2.new(0, 52, 1, 0)
        pos.Position = UDim2.new(0, 10, 0, 0)
        pos.BackgroundTransparency = 1
        pos.Text = tostring(position)
        pos.TextColor3 = Theme.Colors.Text
        pos.Font = Theme.Font.Bold
        pos.TextSize = 13
        pos.TextXAlignment = Enum.TextXAlignment.Left
        pos.Parent = row

        local name = Instance.new("TextLabel")
        name.Size = UDim2.new(0, 150, 1, 0)
        name.Position = UDim2.new(0, 64, 0, 0)
        name.BackgroundTransparency = 1
        name.Text = tostring(clan.name or "Clan")
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 13
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Parent = row

        local points = Instance.new("TextLabel")
        points.Size = UDim2.new(0, 80, 1, 0)
        points.Position = UDim2.new(0, 220, 0, 0)
        points.BackgroundTransparency = 1
        points.Text = tostring(pointsValue)
        points.TextColor3 = Theme.Colors.TextMuted
        points.Font = Theme.Font.Bold
        points.TextSize = 12
        points.TextXAlignment = Enum.TextXAlignment.Left
        points.Parent = row

        local description = Instance.new("TextLabel")
        description.Size = UDim2.new(1, -310, 1, 0)
        description.Position = UDim2.new(0, 310, 0, 0)
        description.BackgroundTransparency = 1
        description.Text = tostring(descriptionText)
        description.TextColor3 = Theme.Colors.TextMuted
        description.Font = Theme.Font.Regular
        description.TextSize = 11
        description.TextXAlignment = Enum.TextXAlignment.Left
        description.TextTruncate = Enum.TextTruncate.AtEnd
        description.Parent = row

        if isMobileLayout then
            pos.Size = UDim2.new(0, 34, 1, 0)
            pos.Position = UDim2.new(0, 8, 0, 0)
            pos.TextSize = 11

            name.Size = UDim2.new(0, 104, 1, 0)
            name.Position = UDim2.new(0, 42, 0, 0)
            name.TextSize = 11

            points.Size = UDim2.new(0, 54, 1, 0)
            points.Position = UDim2.new(0, 150, 0, 0)
            points.TextSize = 10

            description.Size = UDim2.new(1, -218, 1, 0)
            description.Position = UDim2.new(0, 216, 0, 0)
            description.TextSize = 10
        end

        

        return row
    end

    if clans then
        for index, clan in ipairs(clans) do
            createClanRow(index, clan)
        end
    end

    clanList.CanvasSize = UDim2.new(
        0,
        0,
        0,
        clanListLayout.AbsoluteContentSize.Y + 12
    )

    clanTitle = Instance.new("TextLabel")
    clanTitle.Name = "ClanTitle"
    clanTitle.Size = UDim2.new(1, -24, 0, 34)
    clanTitle.Position = UDim2.new(0, 12, 0, 12)
    clanTitle.BackgroundTransparency = 1
    clanTitle.Text = ""
    clanTitle.TextColor3 = Theme.Colors.Text
    clanTitle.Font = Theme.Font.Bold
    clanTitle.TextSize = 20
    clanTitle.TextXAlignment = Enum.TextXAlignment.Center
    clanTitle.Parent = rightPanel

    local clanImage = Instance.new("Frame")
    clanImage.Name = "ClanImage"
    clanImage.Size = UDim2.new(1, -32, 0, 120)
    clanImage.Position = UDim2.new(0, 16, 0, 56)
    clanImage.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    clanImage.BackgroundTransparency = 0.18
    clanImage.BorderSizePixel = 0
    clanImage.Parent = rightPanel

    local clanImageCorner = Instance.new("UICorner")
    clanImageCorner.CornerRadius = UDim.new(0, 8)
    clanImageCorner.Parent = clanImage

    

    clanPoints = Instance.new("TextLabel")
    clanPoints.Size = UDim2.new(1, -32, 0, 22)
    clanPoints.Position = UDim2.new(0, 16, 0, 188)
    clanPoints.BackgroundTransparency = 1
    clanPoints.Text = "Puntos de Familia:"
    clanPoints.TextColor3 = Theme.Colors.Text
    clanPoints.Font = Theme.Font.Bold
    clanPoints.TextSize = 13
    clanPoints.TextXAlignment = Enum.TextXAlignment.Left
    clanPoints.Parent = rightPanel

    clanPointsValue = Instance.new("TextLabel")
    clanPointsValue.Size = UDim2.new(0, 90, 1, 0)
    clanPointsValue.Position = UDim2.new(1, -110, 0, 0)
    clanPointsValue.BackgroundTransparency = 1
    clanPointsValue.Text = "0"
    clanPointsValue.TextColor3 = Theme.Colors.Text
    clanPointsValue.Font = Theme.Font.Bold
    clanPointsValue.TextSize = 13
    clanPointsValue.TextXAlignment = Enum.TextXAlignment.Right
    clanPointsValue.Parent = clanPoints

    clanMembers = Instance.new("TextLabel")
    clanMembers.Size = UDim2.new(1, -32, 0, 22)
    clanMembers.Position = UDim2.new(0, 16, 0, 214)
    clanMembers.BackgroundTransparency = 1
    clanMembers.Text = "Miembros:"
    clanMembers.TextColor3 = Theme.Colors.Text
    clanMembers.Font = Theme.Font.Bold
    clanMembers.TextSize = 13
    clanMembers.TextXAlignment = Enum.TextXAlignment.Left
    clanMembers.Parent = rightPanel

    clanMembersValue = Instance.new("TextLabel")
    clanMembersValue.Size = UDim2.new(0, 90, 1, 0)
    clanMembersValue.Position = UDim2.new(1, -110, 0, 0)
    clanMembersValue.BackgroundTransparency = 1
    clanMembersValue.Text = "0"
    clanMembersValue.TextColor3 = Theme.Colors.Text
    clanMembersValue.Font = Theme.Font.Bold
    clanMembersValue.TextSize = 13
    clanMembersValue.TextXAlignment = Enum.TextXAlignment.Right
    clanMembersValue.Parent = clanMembers

    local clanDescriptionTitle = Instance.new("TextLabel")
    clanDescriptionTitle.Size = UDim2.new(1, -32, 0, 20)
    clanDescriptionTitle.Position = UDim2.new(0, 16, 0, 246)
    clanDescriptionTitle.BackgroundTransparency = 1
    clanDescriptionTitle.Text = "Descripción:"
    clanDescriptionTitle.TextColor3 = Theme.Colors.Text
    clanDescriptionTitle.Font = Theme.Font.Bold
    clanDescriptionTitle.TextSize = 13
    clanDescriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    clanDescriptionTitle.Parent = rightPanel

    clanDescription = Instance.new("TextLabel")
    clanDescription.Size = UDim2.new(1, -32, 0, 68)
    clanDescription.Position = UDim2.new(0, 16, 0, 270)
    clanDescription.BackgroundColor3 = Color3.fromRGB(24, 26, 31)
    clanDescription.BackgroundTransparency = 0.12
    clanDescription.BorderSizePixel = 0
    clanDescription.Text = ""
    clanDescription.TextColor3 = Theme.Colors.TextMuted
    clanDescription.Font = Theme.Font.Regular
    clanDescription.TextSize = 12
    clanDescription.TextWrapped = true
    clanDescription.TextYAlignment = Enum.TextYAlignment.Top
    clanDescription.TextXAlignment = Enum.TextXAlignment.Left
    clanDescription.Parent = rightPanel

    local clanDescriptionCorner = Instance.new("UICorner")
    clanDescriptionCorner.CornerRadius = UDim.new(0, 8)
    clanDescriptionCorner.Parent = clanDescription

    local clanDescriptionPadding = Instance.new("UIPadding")
    clanDescriptionPadding.PaddingTop = UDim.new(0, 8)
    clanDescriptionPadding.PaddingLeft = UDim.new(0, 8)
    clanDescriptionPadding.PaddingRight = UDim.new(0, 8)
    clanDescriptionPadding.PaddingBottom = UDim.new(0, 8)
    clanDescriptionPadding.Parent = clanDescription


    local firstClan = clans and clans[1]

    if firstClan then
        local memberCount = #(firstClan.members or {})

        selectedClan = firstClan
        clanTitle.Text = tostring(firstClan.name or "Clan")
        clanPointsValue.Text = tostring(firstClan.total_points_earned or 0)
        clanMembersValue.Text = tostring(memberCount)
        clanDescription.Text = tostring(firstClan.description or "")
    else
        clanTitle.Text = "Sin clanes"
        clanPointsValue.Text = "0"
        clanMembersValue.Text = "0"
        clanDescription.Text = ""
    end


    local joinButton = Instance.new("TextButton")
    joinButton.Name = "JoinButton"
    joinButton.Size = UDim2.new(0.5, -22, 0, 34)
    joinButton.Position = UDim2.new(0, 16, 1, -42)
    joinButton.BackgroundColor3 = Color3.fromRGB(78, 158, 58)
    joinButton.BorderSizePixel = 0
    joinButton.Text = "Solicitar unirse"
    joinButton.TextColor3 = Theme.Colors.Text
    joinButton.Font = Theme.Font.Bold
    joinButton.TextSize = 12
    joinButton.Parent = rightPanel

    local joinCorner = Instance.new("UICorner")
    joinCorner.CornerRadius = UDim.new(0, 8)
    joinCorner.Parent = joinButton

    updateJoinButton = function()
        if not selectedClan then
            joinButton.Active = false
            joinButton.AutoButtonColor = false
            joinButton.BackgroundColor3 = Color3.fromRGB(72, 72, 78)
            joinButton.Text = "Solicitar unirse"
            return
        end

        joinButton.Active = true
        joinButton.AutoButtonColor = true

        if currentClanId and tostring(currentClanId) == tostring(selectedClan.clan_id) then
            joinButton.BackgroundColor3 = Color3.fromRGB(150, 42, 42)
            if ownedClanId and tostring(ownedClanId) == tostring(selectedClan.clan_id) then
                joinButton.Text = "Eliminar Clan"
            else
                joinButton.Text = "Salir de Clan"
            end
        elseif pendingRequestClanId and tostring(pendingRequestClanId) == tostring(selectedClan.clan_id) then
            joinButton.BackgroundColor3 = Color3.fromRGB(78, 158, 58)
            joinButton.Text = "Solicitud enviada"
        else
            joinButton.BackgroundColor3 = Color3.fromRGB(78, 158, 58)
            joinButton.Text = "Solicitar unirse"
        end

        if _G.StrikeChatI18n then
            joinButton.Text = _G.StrikeChatI18n.TranslateText(joinButton.Text)
        end
    end

    joinButton.MouseButton1Click:Connect(function()
        if joinActionHandler and selectedClan then
            joinActionHandler(selectedClan)
        end
    end)

    local viewButton = Instance.new("TextButton")
    viewButton.Name = "ViewButton"
    viewButton.Size = UDim2.new(0.5, -22, 0, 34)
    viewButton.Position = UDim2.new(0.5, 6, 1, -42)
    viewButton.BackgroundColor3 = Color3.fromRGB(168, 6, 235)
    viewButton.BorderSizePixel = 0
    viewButton.Text = "Ver Clan/Familia"
    viewButton.TextColor3 = Theme.Colors.Text
    viewButton.Font = Theme.Font.Bold
    viewButton.TextSize = 12
    viewButton.Parent = rightPanel

    local viewCorner = Instance.new("UICorner")
    viewCorner.CornerRadius = UDim.new(0, 8)
    viewCorner.Parent = viewButton




    local footer = Instance.new("Frame")
    footer.Name = "Footer"
    footer.Size = UDim2.new(0.64, -36, 0, 28)
    footer.Position = UDim2.new(0, 20, 1, -38)
    footer.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
    footer.BackgroundTransparency = 0.18
    footer.BorderSizePixel = 0
    footer.ZIndex = 2
    footer.Parent = root

    local footerCorner = Instance.new("UICorner")
    footerCorner.CornerRadius = UDim.new(0, 8)
    footerCorner.Parent = footer

    local footerStroke = Instance.new("UIStroke")
    footerStroke.Color = Color3.fromRGB(55, 55, 64)
    footerStroke.Thickness = 1
    footerStroke.Transparency = 0.25
    footerStroke.Parent = footer

    local footerText = Instance.new("TextLabel")
    footerText.Name = "FooterText"
    footerText.Size = UDim2.new(1, -24, 1, 0)
    footerText.Position = UDim2.new(0, 12, 0, 0)
    footerText.BackgroundTransparency = 1
    footerText.Text = "Los clanes se actualizan automáticamente. 1 Ganador por Mes"
    footerText.TextColor3 = Color3.fromRGB(255, 255, 255)
    footerText.Font = Theme.Font.Regular
    footerText.TextSize = 13
    footerText.TextXAlignment = Enum.TextXAlignment.Left
    footerText.TextWrapped = true
    footerText.ZIndex = 3
    footerText.Parent = footer

    if isMobileLayout then
        pcall(function()
            gui.ScreenInsets = Enum.ScreenInsets.None
        end)

        pcall(function()
            gui.ClipToDeviceSafeArea = false
        end)

        root.AnchorPoint = Vector2.new(0, 1)
        root.Size = UDim2.new(1, 0, 1, -64)
        root.Position = UDim2.new(0, 0, 1, 0)
        rootCorner.CornerRadius = UDim.new(0, 0)
        backgroundImageCorner.CornerRadius = UDim.new(0, 0)

        titleContainer.Size = UDim2.new(1, -112, 0, 34)
        titleContainer.Position = UDim2.new(0, 56, 0, 8)
        title.TextSize = 16

        closeButton.Size = UDim2.new(0, 32, 0, 30)
        closeButton.Position = UDim2.new(1, -42, 0, 10)
        closeButton.TextSize = 14

        mainContainer.Size = UDim2.new(1, -28, 1, -88)
        mainContainer.Position = UDim2.new(0, 14, 0, 48)

        leftPanel.Size = UDim2.new(0.63, -8, 1, 0)
        rightPanel.Size = UDim2.new(0.37, -6, 1, 32)
        rightPanel.Position = UDim2.new(0.63, 8, 0, 0)

        tableHeader.Size = UDim2.new(1, -16, 0, 28)
        tableHeader.Position = UDim2.new(0, 8, 0, 8)

        posHeader.Size = UDim2.new(0, 34, 1, 0)
        posHeader.Position = UDim2.new(0, 8, 0, 0)
        posHeader.TextSize = 10

        nameHeader.Size = UDim2.new(0, 104, 1, 0)
        nameHeader.Position = UDim2.new(0, 42, 0, 0)
        nameHeader.TextSize = 10

        pointsHeader.Size = UDim2.new(0, 54, 1, 0)
        pointsHeader.Position = UDim2.new(0, 150, 0, 0)
        pointsHeader.TextSize = 10

        descHeader.Size = UDim2.new(1, -218, 1, 0)
        descHeader.Position = UDim2.new(0, 216, 0, 0)
        descHeader.TextSize = 10

        clanList.Size = UDim2.new(1, -20, 1, -46)
        clanList.Position = UDim2.new(0, 10, 0, 40)
        clanList.ScrollBarThickness = 2
        clanListLayout.Padding = UDim.new(0, 4)
        clanListPadding.PaddingTop = UDim.new(0, 3)

        clanTitle.Size = UDim2.new(1, -16, 0, 26)
        clanTitle.Position = UDim2.new(0, 8, 0, 8)
        clanTitle.TextSize = 15

        clanImage.Size = UDim2.new(1, -20, 0, 40)
        clanImage.Position = UDim2.new(0, 10, 0, 34)

        clanPoints.Size = UDim2.new(1, -20, 0, 18)
        clanPoints.Position = UDim2.new(0, 10, 0, 82)
        clanPoints.TextSize = 11
        clanPointsValue.Size = UDim2.new(0, 54, 1, 0)
        clanPointsValue.Position = UDim2.new(1, -78, 0, 0)
        clanPointsValue.TextSize = 11

        clanMembers.Size = UDim2.new(1, -20, 0, 18)
        clanMembers.Position = UDim2.new(0, 10, 0, 102)
        clanMembers.TextSize = 11
        clanMembersValue.Size = UDim2.new(0, 54, 1, 0)
        clanMembersValue.Position = UDim2.new(1, -78, 0, 0)
        clanMembersValue.TextSize = 11

        clanDescriptionTitle.Size = UDim2.new(1, -20, 0, 16)
        clanDescriptionTitle.Position = UDim2.new(0, 10, 0, 126)
        clanDescriptionTitle.TextSize = 11

        clanDescription.Size = UDim2.new(1, -20, 0, 58)
        clanDescription.Position = UDim2.new(0, 10, 0, 142)
        clanDescription.TextSize = 10
        clanDescriptionPadding.PaddingTop = UDim.new(0, 5)
        clanDescriptionPadding.PaddingLeft = UDim.new(0, 6)
        clanDescriptionPadding.PaddingRight = UDim.new(0, 6)
        clanDescriptionPadding.PaddingBottom = UDim.new(0, 5)

        joinButton.Size = UDim2.new(0.5, -14, 0, 28)
        joinButton.Position = UDim2.new(0, 10, 1, -34)
        joinButton.TextSize = 10

        viewButton.Size = UDim2.new(0.5, -14, 0, 28)
        viewButton.Position = UDim2.new(0.5, 4, 1, -34)
        viewButton.TextSize = 10

        footer.Size = UDim2.new(0.63, -22, 0, 24)
        footer.Position = UDim2.new(0, 14, 1, -32)
        footerText.Size = UDim2.new(1, -16, 1, 0)
        footerText.Position = UDim2.new(0, 8, 0, 0)
        footerText.TextSize = 11

        clanList.CanvasSize = UDim2.new(
            0,
            0,
            0,
            clanListLayout.AbsoluteContentSize.Y + 8
        )
    end

    updateJoinButton()

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        LeftPanel = leftPanel,
        RightPanel = rightPanel,

        ClanList = clanList,
        ClanListLayout = clanListLayout,

        ClanTitle = clanTitle,
        ClanPoints = clanPoints,
        ClanMembers = clanMembers,
        ClanDescription = clanDescription,

        JoinButton = joinButton,
        ViewButton = viewButton,

        GetSelectedClan = function()
            return selectedClan
        end,

        SetCurrentClanId = function(clanId)
            currentClanId = clanId
            updateJoinButton()
        end,

        SetOwnedClanId = function(clanId)
            ownedClanId = clanId
            updateJoinButton()
        end,

        SetPendingRequestClanId = function(clanId)
            pendingRequestClanId = clanId
            updateJoinButton()
        end,

        SetJoinActionHandler = function(handler)
            joinActionHandler = handler
        end,

        UpdateJoinButton = updateJoinButton,

        Footer = footer,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ClanTableUI
