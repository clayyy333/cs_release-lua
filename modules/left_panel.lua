local LeftPanel = {}

function LeftPanel.Create(parent, Theme, profile, player)
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    local function getViewportSize()
        local camera = workspace.CurrentCamera

        if camera then
            return camera.ViewportSize
        end

        return Vector2.new(1280, 720)
    end

    local function isMobileLandscape()
        if _G.StrikeChatLayoutMode == "mobile" then
            return true
        end

        if _G.StrikeChatLayoutMode == "pc" then
            return false
        end

        local viewport = getViewportSize()
        local shortSide = math.min(viewport.X, viewport.Y)
        local longSide = math.max(viewport.X, viewport.Y)

        return UserInputService.TouchEnabled
            and viewport.X > viewport.Y
            and shortSide <= 650
            and longSide <= 1400
    end

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "LeftPanelScroll"
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 0
    scroll.ScrollingEnabled = true
    scroll.CanvasSize = UDim2.new(0, 0, 0, 440)
    scroll.Parent = parent

    local scrollHint = Instance.new("Frame")
    scrollHint.Name = "LeftScrollHint"
    scrollHint.Size = UDim2.new(0, 1, 1, -16)
    scrollHint.Position = UDim2.new(0, 1, 0, 8)
    scrollHint.BackgroundColor3 = Theme.Colors.TextMuted
    scrollHint.BackgroundTransparency = 0.2
    scrollHint.BorderSizePixel = 0
    scrollHint.Visible = false
    scrollHint.ZIndex = 20
    scrollHint.Parent = parent

    local scrollHintCorner = Instance.new("UICorner")
    scrollHintCorner.CornerRadius = UDim.new(1, 0)
    scrollHintCorner.Parent = scrollHint

    local content = Instance.new("Frame")
    content.Name = "LeftPanelContent"
    content.Size = UDim2.new(1, 0, 0, 440)
    content.BackgroundTransparency = 1
    content.Parent = scroll

    local function animatePointsIcon(iconHolder, icon)
        task.spawn(function()
            while iconHolder.Parent do
                local now = os.clock()
                icon.Rotation = math.sin(now * 2.1) * 8

                task.wait(0.05)
            end
        end)
    end

    local avatar = Instance.new("Frame")
    avatar.Name = "AvatarPlaceholder"
    avatar.Size = UDim2.new(0, 68, 0, 68)
    avatar.Position = UDim2.new(0, 14, 0, 14)
    avatar.BackgroundColor3 = Theme.Colors.PanelLight
    avatar.BorderSizePixel = 0
    avatar.Parent = content

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 14)
    avatarCorner.Parent = avatar

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = avatar

    local avatarImageCorner = Instance.new("UICorner")
    avatarImageCorner.CornerRadius = UDim.new(0, 14)
    avatarImageCorner.Parent = avatarImage

    local success, avatarContent = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.AvatarThumbnail,
            Enum.ThumbnailSize.Size180x180
        )
    end)

    if success then
        avatarImage.Image = avatarContent
    end

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -104, 0, 24)
    displayName.Position = UDim2.new(0, 92, 0, 18)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or player.DisplayName)
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 15
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.Parent = content

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -104, 0, 16)
    username.Position = UDim2.new(0, 92, 0, 42)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Regular
    username.TextSize = 12
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.Parent = content

    local adminButton = Instance.new("TextButton")
    adminButton.Name = "AdminButton"
    adminButton.Size = UDim2.new(0, 74, 0, 18)
    adminButton.Position = UDim2.new(0, 92, 0, 64)
    adminButton.BackgroundColor3 = Theme.Colors.PanelLight
    adminButton.BackgroundTransparency = 0.08
    adminButton.BorderSizePixel = 0
    adminButton.Text = "Admin"
    adminButton.TextColor3 = Theme.Colors.TextMuted
    adminButton.Font = Theme.Font.Bold
    adminButton.TextSize = 9
    adminButton.Visible = false
    adminButton.Parent = content

    local adminButtonCorner = Instance.new("UICorner")
    adminButtonCorner.CornerRadius = UDim.new(0, 6)
    adminButtonCorner.Parent = adminButton

    local pointsBox = Instance.new("Frame")
    pointsBox.Name = "PointsBox"
    pointsBox.Size = UDim2.new(1, -28, 0, 54)
    pointsBox.Position = UDim2.new(0, 14, 0, 92)
    pointsBox.BackgroundColor3 = Theme.Colors.Panel
    pointsBox.BorderSizePixel = 0
    pointsBox.Parent = content

    local pointsCorner = Instance.new("UICorner")
    pointsCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    pointsCorner.Parent = pointsBox

    local pointsTitle = Instance.new("TextLabel")
    pointsTitle.Size = UDim2.new(1, -16, 0, 20)
    pointsTitle.Position = UDim2.new(0, 10, 0, 6)
    pointsTitle.BackgroundTransparency = 1
    pointsTitle.Text = "Puntos de Jugador"
    pointsTitle.TextColor3 = Theme.Colors.TextMuted
    pointsTitle.Font = Theme.Font.Regular
    pointsTitle.TextSize = 11
    pointsTitle.TextXAlignment = Enum.TextXAlignment.Center
    pointsTitle.Parent = pointsBox

    local pointsRow = Instance.new("Frame")
    pointsRow.Name = "PointsRow"
    pointsRow.Size = UDim2.new(1, -16, 0, 24)
    pointsRow.Position = UDim2.new(0, 8, 0, 25)
    pointsRow.BackgroundTransparency = 1
    pointsRow.Parent = pointsBox

    local pointsRowLayout = Instance.new("UIListLayout")
    pointsRowLayout.FillDirection = Enum.FillDirection.Horizontal
    pointsRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pointsRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    pointsRowLayout.Padding = UDim.new(0, 5)
    pointsRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pointsRowLayout.Parent = pointsRow

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Size = UDim2.new(0, 0, 1, 0)
    pointsValue.AutomaticSize = Enum.AutomaticSize.X
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 17
    pointsValue.TextXAlignment = Enum.TextXAlignment.Center
    pointsValue.LayoutOrder = 1
    pointsValue.Parent = pointsRow

    local pointsIconHolder = Instance.new("Frame")
    pointsIconHolder.Name = "PointsIconHolder"
    pointsIconHolder.Size = UDim2.new(0, 28, 0, 28)
    pointsIconHolder.BackgroundTransparency = 1
    pointsIconHolder.LayoutOrder = 2
    pointsIconHolder.ClipsDescendants = false
    pointsIconHolder.Parent = pointsRow

    local pointsIcon = Instance.new("ImageLabel")
    pointsIcon.Name = "PointsIcon"
    pointsIcon.Size = UDim2.new(0, 20, 0, 20)
    pointsIcon.Position = UDim2.new(0.5, -10, 0.5, -10)
    pointsIcon.BackgroundTransparency = 1
    pointsIcon.Image = "rbxassetid://124520045081815"
    pointsIcon.ScaleType = Enum.ScaleType.Fit
    pointsIcon.ZIndex = 3
    pointsIcon.Parent = pointsIconHolder

    animatePointsIcon(pointsIconHolder, pointsIcon)

    local createdButtons = {}

    local function applyAnimatedBorder(guiObject)
        if not guiObject or guiObject:GetAttribute("StrikeMusicAnimatedBorderApplied") then
            return
        end

        guiObject:SetAttribute("StrikeMusicAnimatedBorderApplied", true)

        local stroke = guiObject:FindFirstChild("StrikeMusicAnimatedBorder")

        if not stroke then
            stroke = Instance.new("UIStroke")
            stroke.Name = "StrikeMusicAnimatedBorder"
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Color = Color3.fromRGB(255, 255, 255)
            stroke.Thickness = 1.6
            stroke.Transparency = 0.05
            stroke.Parent = guiObject
        end

        local gradient = stroke:FindFirstChild("StrikeMusicBorderGradient")

        if not gradient then
            gradient = Instance.new("UIGradient")
            gradient.Name = "StrikeMusicBorderGradient"
            gradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(137, 50, 235)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(180, 80, 255)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(78, 190, 92)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(137, 50, 235))
            })
            gradient.Rotation = 0
            gradient.Parent = stroke
        end

        local borderPalettes = {
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(137, 50, 235)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(180, 80, 255)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(78, 190, 92)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(137, 50, 235))
            }),
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(137, 50, 235)),
                ColorSequenceKeypoint.new(0.35, Color3.fromRGB(255, 92, 198)),
                ColorSequenceKeypoint.new(0.7, Color3.fromRGB(190, 115, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(137, 50, 235))
            })
        }

        task.spawn(function()
            local rotation = 0
            local paletteIndex = 1

            while guiObject.Parent and stroke.Parent and gradient.Parent do
                gradient.Color = borderPalettes[paletteIndex]
                paletteIndex = paletteIndex == #borderPalettes and 1 or paletteIndex + 1
                rotation += 360

                local tween = TweenService:Create(
                    gradient,
                    TweenInfo.new(4.5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {
                        Rotation = rotation
                    }
                )

                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end
    local function applyAnimatedTextColor(guiObject)
        if not guiObject or guiObject:GetAttribute("StrikeMusicAnimatedTextApplied") then
            return
        end

        local label = guiObject:FindFirstChild("Label")

        if not label or not label:IsA("TextLabel") then
            return
        end

        guiObject:SetAttribute("StrikeMusicAnimatedTextApplied", true)

        local colors = {
            Theme.Colors.Text,
            Color3.fromRGB(190, 115, 255),
            Color3.fromRGB(255, 92, 198),
            Color3.fromRGB(78, 190, 92),
            Color3.fromRGB(120, 220, 255),
            Color3.fromRGB(245, 245, 245)
        }

        task.spawn(function()
            local index = 1

            while guiObject.Parent and label.Parent do
                index += 1

                if index > #colors then
                    index = 1
                end

                local tween = TweenService:Create(
                    label,
                    TweenInfo.new(1.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {
                        TextColor3 = colors[index]
                    }
                )

                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end
    local function createTopButton(name, text, icon, size, position)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = size
        btn.Position = position
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = ""
        btn.Parent = content

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -36, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Bold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = btn

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 24, 1, 0)
        iconLabel.Position = UDim2.new(1, -30, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Theme.Colors.Text
        iconLabel.Font = Theme.Font.Bold
        iconLabel.TextSize = 14
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = btn

        createdButtons[name] = btn
        return btn
    end

    local function createMenuButton(name, text, icon, y)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "Button"
        btn.Size = UDim2.new(1, -36, 0, 32)
        btn.Position = UDim2.new(0, 18, 0, y)
        btn.BackgroundColor3 = Theme.Colors.PanelLight
        btn.Text = ""
        btn.Parent = content

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        btnCorner.Parent = btn

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, -58, 1, 0)
        label.Position = UDim2.new(0, 16, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Theme.Colors.Text
        label.Font = Theme.Font.Bold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = btn

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Name = "Icon"
        iconLabel.Size = UDim2.new(0, 26, 1, 0)
        iconLabel.Position = UDim2.new(1, -38, 0, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = icon
        iconLabel.TextColor3 = Theme.Colors.Text
        iconLabel.Font = Theme.Font.Bold
        iconLabel.TextSize = 14
        iconLabel.TextXAlignment = Enum.TextXAlignment.Center
        iconLabel.Parent = btn

        createdButtons[name] = btn
        return btn
    end

    createMenuButton("StrikeMusic", "StrikeMusic", "♫", 158)
    applyAnimatedBorder(createdButtons.StrikeMusic)
    applyAnimatedTextColor(createdButtons.StrikeMusic)

    createTopButton(
        "Tienda",
        "Tienda",
        "🛒",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0, 14, 0, 198)
    )

    createTopButton(
        "Perfil",
        "Perfil",
        "👤",
        UDim2.new(0.5, -19, 0, 32),
        UDim2.new(0.5, 5, 0, 198)
    )
    createMenuButton("CrearSalas", "Crear Sala", "+", 244)
    createMenuButton("SalasPublicas", "Salas Públicas", "🌐", 284)
    createMenuButton("SalasPrivadas", "Salas Privadas", "🔒", 324)
    createMenuButton("TablaClanes", "Tabla de Clanes", "🏆", 364)

    local function setButtonLayout(button, y)
        if not button then
            return
        end

        button.Size = UDim2.new(1, -28, 0, 32)
        button.Position = UDim2.new(0, 14, 0, y)

        local label = button:FindFirstChild("Label")
        local icon = button:FindFirstChild("Icon")

        if label then
            label.Size = UDim2.new(1, -54, 1, 0)
            label.Position = UDim2.new(0, 14, 0, 0)
            label.TextSize = 11
            label.TextTruncate = Enum.TextTruncate.AtEnd
        end

        if icon then
            icon.Size = UDim2.new(0, 24, 1, 0)
            icon.Position = UDim2.new(1, -32, 0, 0)
            icon.TextSize = 13
        end
    end

    local function resetTopButton(button, size, position)
        if not button then
            return
        end

        button.Size = size
        button.Position = position

        local label = button:FindFirstChild("Label")
        local icon = button:FindFirstChild("Icon")

        if label then
            label.Size = UDim2.new(1, -36, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.TextSize = 12
            label.TextTruncate = Enum.TextTruncate.None
        end

        if icon then
            icon.Size = UDim2.new(0, 24, 1, 0)
            icon.Position = UDim2.new(1, -30, 0, 0)
            icon.TextSize = 14
        end
    end

    local function resetMenuButton(button, y)
        if not button then
            return
        end

        button.Size = UDim2.new(1, -36, 0, 32)
        button.Position = UDim2.new(0, 18, 0, y)

        local label = button:FindFirstChild("Label")
        local icon = button:FindFirstChild("Icon")

        if label then
            label.Size = UDim2.new(1, -58, 1, 0)
            label.Position = UDim2.new(0, 16, 0, 0)
            label.TextSize = 12
            label.TextTruncate = Enum.TextTruncate.None
        end

        if icon then
            icon.Size = UDim2.new(0, 26, 1, 0)
            icon.Position = UDim2.new(1, -38, 0, 0)
            icon.TextSize = 14
        end
    end

    local function applyResponsiveLayout()
        if isMobileLandscape() then
            scroll.ScrollBarThickness = 0
            scroll.ScrollBarImageColor3 = Theme.Colors.TextMuted
            scroll.ScrollBarImageTransparency = 0.35
            scrollHint.Visible = true
            scrollHint.Size = UDim2.new(0, 1, 1, -16)
            scrollHint.Position = UDim2.new(0, 1, 0, 8)

            content.Size = UDim2.new(1, 0, 0, 404)
            scroll.CanvasSize = UDim2.new(0, 0, 0, 412)

            avatar.Size = UDim2.new(0, 50, 0, 50)
            avatar.Position = UDim2.new(0, 14, 0, 12)
            displayName.Size = UDim2.new(1, -82, 0, 20)
            displayName.Position = UDim2.new(0, 74, 0, 14)
            displayName.TextSize = 13
            username.Size = UDim2.new(1, -82, 0, 15)
            username.Position = UDim2.new(0, 74, 0, 34)
            username.TextSize = 10
            adminButton.Position = UDim2.new(0, 74, 0, 54)

            pointsBox.Size = UDim2.new(1, -28, 0, 48)
            pointsBox.Position = UDim2.new(0, 14, 0, 74)
            pointsTitle.Position = UDim2.new(0, 10, 0, 5)
            pointsTitle.TextSize = 10
            pointsRow.Position = UDim2.new(0, 8, 0, 22)
            pointsValue.TextSize = 15
            pointsIconHolder.Size = UDim2.new(0, 24, 0, 24)
            pointsIcon.Size = UDim2.new(0, 18, 0, 18)
            pointsIcon.Position = UDim2.new(0.5, -9, 0.5, -9)

            setButtonLayout(createdButtons.StrikeMusic, 136)
            setButtonLayout(createdButtons.Tienda, 174)
            setButtonLayout(createdButtons.Perfil, 212)
            setButtonLayout(createdButtons.CrearSalas, 250)
            setButtonLayout(createdButtons.SalasPublicas, 288)
            setButtonLayout(createdButtons.SalasPrivadas, 326)
            setButtonLayout(createdButtons.TablaClanes, 364)
        else
            scroll.ScrollBarThickness = 0
            scrollHint.Visible = false

            content.Size = UDim2.new(1, 0, 0, 440)
            scroll.CanvasSize = UDim2.new(0, 0, 0, 440)

            avatar.Size = UDim2.new(0, 68, 0, 68)
            avatar.Position = UDim2.new(0, 14, 0, 14)
            displayName.Size = UDim2.new(1, -104, 0, 24)
            displayName.Position = UDim2.new(0, 92, 0, 18)
            displayName.TextSize = 15
            username.Size = UDim2.new(1, -104, 0, 16)
            username.Position = UDim2.new(0, 92, 0, 42)
            username.TextSize = 12
            adminButton.Position = UDim2.new(0, 92, 0, 64)

            pointsBox.Size = UDim2.new(1, -28, 0, 54)
            pointsBox.Position = UDim2.new(0, 14, 0, 92)
            pointsTitle.Position = UDim2.new(0, 10, 0, 6)
            pointsTitle.TextSize = 11
            pointsRow.Position = UDim2.new(0, 8, 0, 25)
            pointsValue.TextSize = 17
            pointsIconHolder.Size = UDim2.new(0, 28, 0, 28)
            pointsIcon.Size = UDim2.new(0, 20, 0, 20)
            pointsIcon.Position = UDim2.new(0.5, -10, 0.5, -10)

            resetMenuButton(createdButtons.StrikeMusic, 158)
            resetTopButton(createdButtons.Tienda, UDim2.new(0.5, -19, 0, 32), UDim2.new(0, 14, 0, 198))
            resetTopButton(createdButtons.Perfil, UDim2.new(0.5, -19, 0, 32), UDim2.new(0.5, 5, 0, 198))
            resetMenuButton(createdButtons.CrearSalas, 244)
            resetMenuButton(createdButtons.SalasPublicas, 284)
            resetMenuButton(createdButtons.SalasPrivadas, 324)
            resetMenuButton(createdButtons.TablaClanes, 364)
        end
    end

    applyResponsiveLayout()

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveLayout)
    end

    return {
        Scroll = scroll,
        ScrollHint = scrollHint,
        Content = content,
        Avatar = avatar,
        DisplayName = displayName,
        Username = username,
        AdminButton = adminButton,
        PointsValue = pointsValue,
        Buttons = createdButtons
    }
end

return LeftPanel





