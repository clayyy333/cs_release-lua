local ProfileUI = {}

function ProfileUI.Create(parent, Theme, profile, player, AvatarRenderer, currentActivity)
    local Players = game:GetService("Players")
    local DEFAULT_PROFILE_BANNER_ID = "114828705105935"
    local isMobileLayout = _G.StrikeChatLayoutMode == "mobile"
    local DEFAULT_PROFILE_AVATAR_IDS = {
        "79645048761895",
        "107672328050388",
        "94902567700413",
        "17164967802",
        "17165206355",
        "18679886860",
        "15209100462"
    }
    local resolvedImageCache = {}

    profile = profile or {}

    local function translateProfileText(text)
        if _G.StrikeChatI18n then
            return _G.StrikeChatI18n.TranslateText(text)
        end

        return text
    end

    local function getCurrentActivityText(nextProfile)
        local placeName = currentActivity and currentActivity.place_name

        if placeName and tostring(placeName):gsub("%s+", "") ~= "" then
            return "Jugando a : " .. tostring(placeName)
        end

        local activityText = nextProfile and nextProfile.activity_text

        if activityText and tostring(activityText):gsub("%s+", "") ~= "" then
            return tostring(activityText)
        end

        return "Jugando a : Roblox"
    end

    local original = {
        display_name = tostring(profile.display_name or player.DisplayName),
        bio = tostring(profile.bio or ""),
        profile_avatar_id = tostring(profile.profile_avatar_id or ""),
        game_status_visibility = tostring(profile.game_status_visibility or "public")
    }

    local modalColor = Color3.fromRGB(50, 51, 57)
    local panelColor = Color3.fromRGB(57, 58, 65)
    local inputColor = Color3.fromRGB(48, 49, 55)
    local borderColor = Color3.fromRGB(80, 82, 92)

    local gui = Instance.new("ScreenGui")
    gui.Name = "ProfileUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    if isMobileLayout then
        pcall(function()
            gui.ScreenInsets = Enum.ScreenInsets.None
        end)

        pcall(function()
            gui.ClipToDeviceSafeArea = false
        end)
    end

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0.78, 0, 0.72, 0)
    root.Position = UDim2.new(0.5, 0, 0.52, 0)
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.BackgroundColor3 = modalColor
    root.BorderSizePixel = 0
    root.ClipsDescendants = true
    root.Parent = gui

    local rootSize = Instance.new("UISizeConstraint")
    rootSize.MinSize = Vector2.new(620, 470)
    rootSize.MaxSize = Vector2.new(760, 540)
    rootSize.Parent = root

    local function round(instance, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or Theme.Radius.Button)
        corner.Parent = instance
        return corner
    end

    local function stroke(instance, color, transparency)
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Color = color or borderColor
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

    local function getAssetImage(assetId)
        if assetId == nil then
            return nil
        end

        local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

        if value == "" or value == "0" or value == "none" or value == "strikechat_space" then
            return nil
        end

        if value:match("^rbxassetid://") or value:match("^rbxasset://") or value:match("^http") then
            return value
        end

        if value:match("^%d+$") then
            return "rbxassetid://" .. value
        end

        return value
    end

    local function resolveImageAsset(assetId)
        local fallbackImage = getAssetImage(assetId)

        if assetId == nil then
            return nil
        end

        local value = tostring(assetId):gsub("^%s+", ""):gsub("%s+$", "")

        if not value:match("^%d+$") then
            return fallbackImage
        end

        if resolvedImageCache[value] then
            return resolvedImageCache[value]
        end

        local resolvedImage = nil
        local success, objects = pcall(function()
            return game:GetObjects("rbxassetid://" .. value)
        end)

        if success and objects then
            for _, object in ipairs(objects) do
                if object:IsA("Decal") or object:IsA("Texture") then
                    if object.Texture and object.Texture ~= "" then
                        resolvedImage = object.Texture
                        break
                    end
                elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                    if object.Image and object.Image ~= "" then
                        resolvedImage = object.Image
                        break
                    end
                end

                for _, descendant in ipairs(object:GetDescendants()) do
                    if descendant:IsA("Decal") or descendant:IsA("Texture") then
                        if descendant.Texture and descendant.Texture ~= "" then
                            resolvedImage = descendant.Texture
                            break
                        end
                    elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
                        if descendant.Image and descendant.Image ~= "" then
                            resolvedImage = descendant.Image
                            break
                        end
                    end
                end

                if resolvedImage then
                    break
                end
            end

            for _, object in ipairs(objects) do
                pcall(function()
                    object:Destroy()
                end)
            end
        end

        resolvedImageCache[value] = resolvedImage or fallbackImage

        return resolvedImageCache[value]
    end

    local rootCorner = round(root, Theme.Radius.Main)
    stroke(root, Color3.fromRGB(96, 98, 110), 0.48)

    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundTransparency = 1
    topBar.Parent = root

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 24)
    closeButton.Position = UDim2.new(1, -36, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(65, 66, 74)
    closeButton.BackgroundTransparency = 0.12
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.Parent = topBar
    round(closeButton, 10)

    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -54, 1, -56)
    content.Position = UDim2.new(0, 27, 0, 42)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.Parent = root

    local selectedVisibility = original.game_status_visibility
    local selectedProfileAvatarId = original.profile_avatar_id
    local avatarApplyHandler = nil

    local function createPanelShadow(name, size, position, rotation, transparency)
        local shadow = Instance.new("Frame")
        shadow.Name = name
        shadow.Size = size
        shadow.Position = position
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0
        shadow.BorderSizePixel = 0
        shadow.Parent = content

        local shadowGradient = Instance.new("UIGradient")
        shadowGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))
        })
        shadowGradient.Transparency = transparency
        shadowGradient.Rotation = rotation
        shadowGradient.Parent = shadow

        return shadow
    end

    createPanelShadow(
        "PrivateProfilePanelShadowLeft",
        UDim2.new(0, 28, 1, -8),
        UDim2.new(0, -24, 0, 4),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 1.00),
            NumberSequenceKeypoint.new(0.72, 0.68),
            NumberSequenceKeypoint.new(1.00, 0.52)
        })
    )

    createPanelShadow(
        "PrivateProfilePanelShadowRight",
        UDim2.new(0, 34, 1, -8),
        UDim2.new(0.45, -16, 0, 4),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.52),
            NumberSequenceKeypoint.new(0.28, 0.68),
            NumberSequenceKeypoint.new(1.00, 1.00)
        })
    )

    local leftPanel = Instance.new("Frame")
    leftPanel.Name = "PrivateProfilePanel"
    leftPanel.Size = UDim2.new(0.45, -10, 1, 0)
    leftPanel.Position = UDim2.new(0, 0, 0, 0)
    leftPanel.BackgroundColor3 = panelColor
    leftPanel.BorderSizePixel = 0
    leftPanel.ClipsDescendants = true
    leftPanel.Parent = content
    round(leftPanel, 14)
    stroke(leftPanel, Color3.fromRGB(82, 84, 94), 0.52)

    local bannerClip = Instance.new("Frame")
    bannerClip.Name = "BannerClip"
    bannerClip.Size = UDim2.new(1, 0, 0, 118)
    bannerClip.BackgroundTransparency = 1
    bannerClip.BorderSizePixel = 0
    bannerClip.ClipsDescendants = true
    bannerClip.Parent = leftPanel

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 132)
    banner.BackgroundColor3 = Color3.fromRGB(58, 16, 90)
    banner.BorderSizePixel = 0
    banner.ClipsDescendants = true
    banner.Parent = bannerClip
    round(banner, 14)

    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(32, 10, 56)),
        ColorSequenceKeypoint.new(0.18, Color3.fromRGB(150, 22, 190)),
        ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 56, 145)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(170, 44, 198)),
        ColorSequenceKeypoint.new(0.78, Color3.fromRGB(92, 28, 150)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 12, 52))
    })
    bannerGradient.Rotation = 25
    bannerGradient.Parent = banner

    local bannerStars = Instance.new("Frame")
    bannerStars.Name = "BannerStars"
    bannerStars.Size = UDim2.new(1, 0, 1, 0)
    bannerStars.BackgroundTransparency = 1
    bannerStars.BorderSizePixel = 0
    bannerStars.ClipsDescendants = true
    bannerStars.Parent = banner

    for _ = 1, 34 do
        local point = Instance.new("Frame")
        local size = math.random(1, 2)

        point.Size = UDim2.new(0, size, 0, size)
        point.Position = UDim2.new(
            math.random(4, 96) / 100,
            0,
            math.random(8, 84) / 100,
            0
        )
        point.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        point.BackgroundTransparency = math.random(38, 76) / 100
        point.BorderSizePixel = 0
        point.Parent = bannerStars
        round(point, 8)

        task.spawn(function()
            while point.Parent do
                task.wait(math.random(8, 18) / 10)

                point.BackgroundTransparency = math.clamp(
                    point.BackgroundTransparency + (math.random(-8, 8) / 100),
                    0.24,
                    0.82
                )
            end
        end)
    end

    local bannerComets = Instance.new("Frame")
    bannerComets.Name = "BannerComets"
    bannerComets.Size = UDim2.new(1, 0, 1, 0)
    bannerComets.BackgroundTransparency = 1
    bannerComets.BorderSizePixel = 0
    bannerComets.ClipsDescendants = true
    bannerComets.Parent = banner

    task.spawn(function()
        while bannerComets.Parent do
            task.wait(math.random(26, 48) / 10)

            local comet = Instance.new("Frame")
            local size = math.random(2, 3)

            comet.Size = UDim2.new(0, size, 0, size)
            comet.Position = UDim2.new(
                math.random(14, 82) / 100,
                0,
                math.random(8, 54) / 100,
                0
            )
            comet.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            comet.BackgroundTransparency = 0.18
            comet.BorderSizePixel = 0
            comet.Parent = bannerComets
            round(comet, 8)

            local direction = math.random(1, 2) == 1 and -1 or 1

            task.spawn(function()
                for _ = 1, 28 do
                    if not comet.Parent then
                        return
                    end

                    comet.Position = comet.Position + UDim2.new(0.004 * direction, 0, 0.005, 0)
                    comet.BackgroundTransparency += 0.026
                    task.wait(0.03)
                end

                comet:Destroy()
            end)
        end
    end)

    local bannerImage = Instance.new("ImageLabel")
    bannerImage.Name = "BannerImage"
    bannerImage.Size = UDim2.new(1, 0, 1, 0)
    bannerImage.BackgroundTransparency = 1
    bannerImage.BorderSizePixel = 0
    bannerImage.ScaleType = Enum.ScaleType.Crop
    bannerImage.Visible = false
    bannerImage.Parent = banner
    round(bannerImage, 14)

    local function applyBannerImage(bannerId)
        if bannerId == nil or tostring(bannerId) == DEFAULT_PROFILE_BANNER_ID then
            bannerImage.Image = ""
            bannerImage.Visible = false
            return
        end

        local image = resolveImageAsset(bannerId)

        if image then
            bannerImage.Image = image
            bannerImage.ImageTransparency = 0
            bannerImage.Visible = true
        else
            bannerImage.Image = ""
            bannerImage.Visible = false
        end
    end

    applyBannerImage(profile.profile_banner_id)

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 88, 0, 88)
    avatarFrame.Position = UDim2.new(0, 22, 0, 68)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(31, 32, 38)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 4
    avatarFrame.Parent = leftPanel
    round(avatarFrame, 44)
    stroke(avatarFrame, Color3.fromRGB(118, 120, 134), 0.15)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = avatarFrame.ZIndex + 1
    avatarImage.Parent = avatarFrame
    round(avatarImage, 41)

    local function applyProfileAvatar(profileAvatarId)
        if AvatarRenderer and AvatarRenderer.SetAvatar then
            AvatarRenderer.SetAvatar(avatarImage, player.UserId, profileAvatarId, true)
            return
        end

        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                player.UserId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size180x180
            )
        end)

        if ok then
            avatarImage.Image = image
        end
    end

    applyProfileAvatar(selectedProfileAvatarId)

    local editAvatarButton = Instance.new("TextButton")
    editAvatarButton.Name = "EditAvatarButton"
    editAvatarButton.Size = UDim2.new(0, 26, 0, 26)
    editAvatarButton.Position = UDim2.new(1, -26, 1, -26)
    editAvatarButton.BackgroundColor3 = Color3.fromRGB(54, 55, 62)
    editAvatarButton.BackgroundTransparency = 0.02
    editAvatarButton.BorderSizePixel = 0
    editAvatarButton.Text = "E"
    editAvatarButton.TextColor3 = Theme.Colors.Text
    editAvatarButton.Font = Theme.Font.Bold
    editAvatarButton.TextSize = 14
    editAvatarButton.ZIndex = avatarFrame.ZIndex + 3
    editAvatarButton.Parent = avatarFrame
    round(editAvatarButton, 13)
    stroke(editAvatarButton, Color3.fromRGB(94, 96, 108), 0.35)

    local displayInput = Instance.new("TextBox")
    displayInput.Name = "DisplayNameInput"
    displayInput.Size = UDim2.new(1, -142, 0, 28)
    displayInput.Position = UDim2.new(0, 124, 0, 122)
    displayInput.BackgroundTransparency = 1
    displayInput.BorderSizePixel = 0
    displayInput.Text = original.display_name
    displayInput.PlaceholderText = "Display Name"
    displayInput.TextColor3 = Theme.Colors.Text
    displayInput.PlaceholderColor3 = Theme.Colors.TextMuted
    displayInput.Font = Theme.Font.Bold
    displayInput.TextSize = 20
    displayInput.TextXAlignment = Enum.TextXAlignment.Left
    displayInput.TextTruncate = Enum.TextTruncate.AtEnd
    displayInput.ClearTextOnFocus = false
    displayInput.ZIndex = 5
    displayInput.Parent = leftPanel

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -142, 0, 16)
    username.Position = UDim2.new(0, 124, 0, 151)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Bold
    username.TextSize = 11
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 5
    username.Parent = leftPanel

    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(1, -48, 0, 20)
    pointsLabel.Position = UDim2.new(0, 24, 0, 178)
    pointsLabel.BackgroundTransparency = 1
    pointsLabel.Text = "Puntos de Usuario:"
    pointsLabel.TextColor3 = Theme.Colors.Text
    pointsLabel.Font = Theme.Font.Bold
    pointsLabel.TextSize = 13
    pointsLabel.TextXAlignment = Enum.TextXAlignment.Center
    pointsLabel.Parent = leftPanel

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Name = "PointsValue"
    pointsValue.Size = UDim2.new(1, -48, 0, 24)
    pointsValue.Position = UDim2.new(0, 24, 0, 198)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(profile.personal_points or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 14
    pointsValue.TextXAlignment = Enum.TextXAlignment.Center
    pointsValue.TextTruncate = Enum.TextTruncate.AtEnd
    pointsValue.Parent = leftPanel

    local clanLabel = Instance.new("TextLabel")
    clanLabel.Name = "ClanLabel"
    clanLabel.Size = UDim2.new(1, -52, 0, 20)
    clanLabel.Position = UDim2.new(0, 26, 0, 224)
    clanLabel.BackgroundTransparency = 1
    clanLabel.Text = "Clan:"
    clanLabel.TextColor3 = Theme.Colors.Text
    clanLabel.Font = Theme.Font.Bold
    clanLabel.TextSize = 13
    clanLabel.TextXAlignment = Enum.TextXAlignment.Left
    clanLabel.Parent = leftPanel

    local clanValue = Instance.new("TextLabel")
    clanValue.Name = "ClanValue"
    clanValue.Size = UDim2.new(1, -52, 0, 20)
    clanValue.Position = UDim2.new(0, 26, 0, 243)
    clanValue.BackgroundTransparency = 1
    clanValue.Text = tostring(profile.clan_name or "Sin clan")
    clanValue.TextColor3 = Theme.Colors.Text
    clanValue.Font = Theme.Font.Regular
    clanValue.TextSize = 12
    clanValue.TextXAlignment = Enum.TextXAlignment.Left
    clanValue.TextTruncate = Enum.TextTruncate.AtEnd
    clanValue.Parent = leftPanel

    local descriptionTitle = Instance.new("TextLabel")
    descriptionTitle.Name = "DescriptionTitle"
    descriptionTitle.Size = UDim2.new(1, -52, 0, 22)
    descriptionTitle.Position = UDim2.new(0, 26, 0, 268)
    descriptionTitle.BackgroundTransparency = 1
    descriptionTitle.Text = "Descripcion:"
    descriptionTitle.TextColor3 = Theme.Colors.Text
    descriptionTitle.Font = Theme.Font.Bold
    descriptionTitle.TextSize = 13
    descriptionTitle.TextXAlignment = Enum.TextXAlignment.Left
    descriptionTitle.Parent = leftPanel

    local descriptionInput = Instance.new("TextBox")
    descriptionInput.Name = "DescriptionInput"
    descriptionInput.Size = UDim2.new(1, -64, 0, 72)
    descriptionInput.Position = UDim2.new(0, 32, 0, 296)
    descriptionInput.BackgroundColor3 = inputColor
    descriptionInput.BackgroundTransparency = 0
    descriptionInput.BorderSizePixel = 0
    descriptionInput.Text = original.bio
    descriptionInput.PlaceholderText = "Cuentales algo sobre ti..."
    descriptionInput.TextColor3 = Theme.Colors.Text
    descriptionInput.PlaceholderColor3 = Theme.Colors.TextMuted
    descriptionInput.Font = Theme.Font.Regular
    descriptionInput.TextSize = 12
    descriptionInput.TextWrapped = true
    descriptionInput.TextXAlignment = Enum.TextXAlignment.Left
    descriptionInput.TextYAlignment = Enum.TextYAlignment.Top
    descriptionInput.ClearTextOnFocus = false
    descriptionInput.MultiLine = true
    descriptionInput.Parent = leftPanel
    round(descriptionInput, 6)
    stroke(descriptionInput, Color3.fromRGB(43, 44, 50), 0.55)
    addPadding(descriptionInput, 10, 10, 8, 8)

    descriptionInput:GetPropertyChangedSignal("Text"):Connect(function()
        if #descriptionInput.Text > 120 then
            descriptionInput.Text = string.sub(descriptionInput.Text, 1, 120)
        end
    end)

    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(0, 140, 0, 30)
    inventoryButton.Position = UDim2.new(0.5, -70, 1, -42)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
    inventoryButton.BackgroundTransparency = 0.02
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Inventario"
    inventoryButton.TextColor3 = Theme.Colors.Text
    inventoryButton.Font = Theme.Font.Bold
    inventoryButton.TextSize = 12
    inventoryButton.Parent = leftPanel
    round(inventoryButton, 8)

    local rightPanel = Instance.new("Frame")
    rightPanel.Name = "ActivityPanel"
    rightPanel.Size = UDim2.new(0.52, 0, 1, 0)
    rightPanel.Position = UDim2.new(0.48, 0, 0, 0)
    rightPanel.BackgroundTransparency = 1
    rightPanel.BorderSizePixel = 0
    rightPanel.Parent = content

    local tabRow = Instance.new("Frame")
    tabRow.Name = "TabRow"
    tabRow.Size = UDim2.new(1, 0, 0, 52)
    tabRow.BackgroundTransparency = 1
    tabRow.Parent = rightPanel

    local activityTab = Instance.new("TextLabel")
    activityTab.Name = "ActivityTab"
    activityTab.Size = UDim2.new(0, 92, 0, 34)
    activityTab.Position = UDim2.new(0, 0, 0, 10)
    activityTab.BackgroundTransparency = 1
    activityTab.Text = "Actividad"
    activityTab.TextColor3 = Theme.Colors.Text
    activityTab.Font = Theme.Font.Bold
    activityTab.TextSize = 14
    activityTab.TextXAlignment = Enum.TextXAlignment.Left
    activityTab.Parent = tabRow

    local activityUnderline = Instance.new("Frame")
    activityUnderline.Name = "ActivityUnderline"
    activityUnderline.Size = UDim2.new(0, 60, 0, 2)
    activityUnderline.Position = UDim2.new(0, 0, 1, -8)
    activityUnderline.BackgroundColor3 = Theme.Colors.Text
    activityUnderline.BorderSizePixel = 0
    activityUnderline.Parent = tabRow

    local visibilityRow = Instance.new("Frame")
    visibilityRow.Name = "VisibilityRow"
    visibilityRow.Size = UDim2.new(0, 200, 0, 30)
    visibilityRow.Position = UDim2.new(0, 112, 0, 12)
    visibilityRow.BackgroundTransparency = 1
    visibilityRow.Parent = tabRow

    local function makeVisibilityButton(name, text, x)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 88, 0, 28)
        button.Position = UDim2.new(0, x, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
        button.BackgroundTransparency = 0.08
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.Parent = visibilityRow
        round(button, 8)
        stroke(button, Color3.fromRGB(86, 88, 100), 0.5)

        return button
    end

    local publicButton = makeVisibilityButton("PublicButton", "Publico", 0)
    local privateButton = makeVisibilityButton("PrivateButton", "Privado", 100)

    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, 0, 0, 1)
    divider.Position = UDim2.new(0, 0, 0, 52)
    divider.BackgroundColor3 = Color3.fromRGB(71, 72, 82)
    divider.BackgroundTransparency = 0.35
    divider.BorderSizePixel = 0
    divider.Parent = rightPanel

    local recentLabel = Instance.new("TextLabel")
    recentLabel.Name = "RecentLabel"
    recentLabel.Size = UDim2.new(1, 0, 0, 18)
    recentLabel.Position = UDim2.new(0, 0, 0, 74)
    recentLabel.BackgroundTransparency = 1
    recentLabel.Text = "Actividad reciente"
    recentLabel.TextColor3 = Theme.Colors.TextMuted
    recentLabel.Font = Theme.Font.Bold
    recentLabel.TextSize = 12
    recentLabel.TextXAlignment = Enum.TextXAlignment.Left
    recentLabel.Parent = rightPanel

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.Size = UDim2.new(1, -20, 0, 30)
    status.Position = UDim2.new(0, 8, 0, 110)
    status.BackgroundTransparency = 1
    status.Text = translateProfileText(getCurrentActivityText(profile))
    status.TextColor3 = Theme.Colors.Text
    status.Font = Theme.Font.Bold
    status.TextSize = 15
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextTruncate = Enum.TextTruncate.AtEnd
    status.Parent = rightPanel

    local languageTitle = Instance.new("TextLabel")
    languageTitle.Name = "LanguageTitle"
    languageTitle.Size = UDim2.new(1, -20, 0, 20)
    languageTitle.Position = UDim2.new(0, 0, 0, 150)
    languageTitle.BackgroundTransparency = 1
    languageTitle.Text = "Idioma / language"
    languageTitle.TextColor3 = Theme.Colors.TextMuted
    languageTitle.Font = Theme.Font.Bold
    languageTitle.TextSize = 12
    languageTitle.TextXAlignment = Enum.TextXAlignment.Left
    languageTitle.Parent = rightPanel

    local languageUnderline = Instance.new("Frame")
    languageUnderline.Name = "LanguageUnderline"
    languageUnderline.Size = UDim2.new(0, 60, 0, 2)
    languageUnderline.Position = UDim2.new(0, 0, 0, 178)
    languageUnderline.BackgroundColor3 = Theme.Colors.Text
    languageUnderline.BorderSizePixel = 0
    languageUnderline.Parent = rightPanel

    local languageButtons = Instance.new("Frame")
    languageButtons.Name = "LanguageButtons"
    languageButtons.Size = UDim2.new(0, 208, 0, 30)
    languageButtons.Position = UDim2.new(0, 0, 0, 194)
    languageButtons.BackgroundTransparency = 1
    languageButtons.Parent = rightPanel

    local function makeLanguageButton(name, text, x)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, 96, 0, 28)
        button.Position = UDim2.new(0, x, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
        button.BackgroundTransparency = 0.08
        button.BorderSizePixel = 0
        button.Text = text
        button.TextColor3 = Theme.Colors.Text
        button.Font = Theme.Font.Bold
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Center
        button.Parent = languageButtons
        round(button, 8)
        stroke(button, Color3.fromRGB(86, 88, 100), 0.5)

        return button
    end

    local spanishButton = makeLanguageButton("SpanishButton", "Español", 0)
    local englishButton = makeLanguageButton("EnglishButton", "English", 108)

    local function updateLanguageButtons()
        local i18n = _G.StrikeChatI18n
        local language = i18n and i18n.GetLanguage and i18n.GetLanguage() or "es"

        if language == "en" then
            spanishButton.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
            englishButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
        else
            spanishButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
            englishButton.BackgroundColor3 = Color3.fromRGB(61, 62, 70)
        end
    end

    spanishButton.MouseButton1Click:Connect(function()
        if _G.StrikeChatI18n then
            _G.StrikeChatI18n.SetLanguage("es")
        end

        if _G.StrikeChatShowDefaultAdminNotice then
            _G.StrikeChatShowDefaultAdminNotice()
        end

        updateLanguageButtons()
    end)

    englishButton.MouseButton1Click:Connect(function()
        if _G.StrikeChatI18n then
            _G.StrikeChatI18n.SetLanguage("en")
        end

        if _G.StrikeChatShowDefaultAdminNotice then
            _G.StrikeChatShowDefaultAdminNotice()
        end

        updateLanguageButtons()
    end)

    updateLanguageButtons()

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -20, 0, 32)
    statusLabel.Position = UDim2.new(0, 0, 1, -110)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Bold
    statusLabel.TextSize = 11
    statusLabel.TextWrapped = true
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = rightPanel

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(1, 0, 0, 34)
    actions.Position = UDim2.new(0, 0, 1, -56)
    actions.BackgroundTransparency = 1
    actions.Parent = rightPanel

    local saveButton = Instance.new("TextButton")
    saveButton.Name = "SaveButton"
    saveButton.Size = UDim2.new(0.43, -6, 1, 0)
    saveButton.Position = UDim2.new(0.05, 0, 0, 0)
    saveButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
    saveButton.BackgroundTransparency = 0.06
    saveButton.BorderSizePixel = 0
    saveButton.Text = "Guardar Cambios"
    saveButton.TextColor3 = Theme.Colors.Text
    saveButton.Font = Theme.Font.Bold
    saveButton.TextSize = 12
    saveButton.Parent = actions
    round(saveButton, 8)
    stroke(saveButton, Color3.fromRGB(98, 142, 108), 0.36)

    local publicProfileButton = Instance.new("TextButton")
    publicProfileButton.Name = "PublicProfileButton"
    publicProfileButton.Size = UDim2.new(0.43, -6, 1, 0)
    publicProfileButton.Position = UDim2.new(0.52, 0, 0, 0)
    publicProfileButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    publicProfileButton.BackgroundTransparency = 0.06
    publicProfileButton.BorderSizePixel = 0
    publicProfileButton.Text = "Ver Perfil Publico"
    publicProfileButton.TextColor3 = Theme.Colors.Text
    publicProfileButton.Font = Theme.Font.Bold
    publicProfileButton.TextSize = 12
    publicProfileButton.Parent = actions
    round(publicProfileButton, 8)
    stroke(publicProfileButton, Color3.fromRGB(96, 98, 110), 0.38)

    local avatarModalOverlay = Instance.new("Frame")
    avatarModalOverlay.Name = "AvatarModalOverlay"
    avatarModalOverlay.Size = UDim2.new(1, 0, 1, 0)
    avatarModalOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    avatarModalOverlay.BackgroundTransparency = 0.42
    avatarModalOverlay.Visible = false
    avatarModalOverlay.ZIndex = 80
    avatarModalOverlay.Parent = gui

    local avatarModal = Instance.new("Frame")
    avatarModal.Name = "AvatarModal"
    avatarModal.Size = UDim2.new(0, 318, 0, 336)
    avatarModal.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarModal.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarModal.BackgroundColor3 = modalColor
    avatarModal.BorderSizePixel = 0
    avatarModal.ZIndex = 81
    avatarModal.Parent = avatarModalOverlay
    round(avatarModal, 12)
    stroke(avatarModal, Color3.fromRGB(96, 98, 110), 0.38)

    local avatarModalTitle = Instance.new("TextLabel")
    avatarModalTitle.Name = "Title"
    avatarModalTitle.Size = UDim2.new(1, -46, 0, 28)
    avatarModalTitle.Position = UDim2.new(0, 18, 0, 12)
    avatarModalTitle.BackgroundTransparency = 1
    avatarModalTitle.Text = "Imagen de perfil"
    avatarModalTitle.TextColor3 = Theme.Colors.Text
    avatarModalTitle.Font = Theme.Font.Bold
    avatarModalTitle.TextSize = 14
    avatarModalTitle.TextXAlignment = Enum.TextXAlignment.Left
    avatarModalTitle.ZIndex = 82
    avatarModalTitle.Parent = avatarModal

    local avatarModalClose = Instance.new("TextButton")
    avatarModalClose.Name = "Close"
    avatarModalClose.Size = UDim2.new(0, 26, 0, 24)
    avatarModalClose.Position = UDim2.new(1, -36, 0, 12)
    avatarModalClose.BackgroundColor3 = Color3.fromRGB(64, 65, 73)
    avatarModalClose.BorderSizePixel = 0
    avatarModalClose.Text = "X"
    avatarModalClose.TextColor3 = Theme.Colors.Text
    avatarModalClose.Font = Theme.Font.Bold
    avatarModalClose.TextSize = 12
    avatarModalClose.ZIndex = 82
    avatarModalClose.Parent = avatarModal
    round(avatarModalClose, 8)

    local avatarGrid = Instance.new("Frame")
    avatarGrid.Name = "AvatarGrid"
    avatarGrid.Size = UDim2.new(1, -34, 0, 112)
    avatarGrid.Position = UDim2.new(0, 17, 0, 52)
    avatarGrid.BackgroundTransparency = 1
    avatarGrid.ZIndex = 82
    avatarGrid.Parent = avatarModal

    local avatarGridLayout = Instance.new("UIGridLayout")
    avatarGridLayout.CellSize = UDim2.new(0, 58, 0, 48)
    avatarGridLayout.CellPadding = UDim2.new(0, 12, 0, 12)
    avatarGridLayout.FillDirectionMaxCells = 4
    avatarGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
    avatarGridLayout.Parent = avatarGrid

    local customPreviewHolder = Instance.new("Frame")
    customPreviewHolder.Name = "CustomPreviewHolder"
    customPreviewHolder.Size = UDim2.new(0, 98, 0, 98)
    customPreviewHolder.Position = UDim2.new(0.5, -49, 0, 58)
    customPreviewHolder.BackgroundColor3 = Color3.fromRGB(24, 25, 30)
    customPreviewHolder.BorderSizePixel = 0
    customPreviewHolder.Visible = false
    customPreviewHolder.ZIndex = 82
    customPreviewHolder.Parent = avatarModal
    round(customPreviewHolder, 12)
    stroke(customPreviewHolder, Color3.fromRGB(75, 77, 88), 0.45)

    local customPreviewImage = Instance.new("ImageLabel")
    customPreviewImage.Name = "PreviewImage"
    customPreviewImage.Size = UDim2.new(1, -10, 1, -10)
    customPreviewImage.Position = UDim2.new(0, 5, 0, 5)
    customPreviewImage.BackgroundColor3 = Color3.fromRGB(16, 17, 20)
    customPreviewImage.BorderSizePixel = 0
    customPreviewImage.ScaleType = Enum.ScaleType.Crop
    customPreviewImage.ZIndex = 83
    customPreviewImage.Parent = customPreviewHolder
    round(customPreviewImage, 10)

    local clearCustomPreview = Instance.new("TextButton")
    clearCustomPreview.Name = "ClearPreview"
    clearCustomPreview.Size = UDim2.new(0, 22, 0, 22)
    clearCustomPreview.Position = UDim2.new(1, -14, 0, -8)
    clearCustomPreview.BackgroundColor3 = Color3.fromRGB(64, 65, 73)
    clearCustomPreview.BorderSizePixel = 0
    clearCustomPreview.Text = "X"
    clearCustomPreview.TextColor3 = Theme.Colors.Text
    clearCustomPreview.Font = Theme.Font.Bold
    clearCustomPreview.TextSize = 11
    clearCustomPreview.ZIndex = 84
    clearCustomPreview.Parent = customPreviewHolder
    round(clearCustomPreview, 11)

    local avatarInputLabel = Instance.new("TextLabel")
    avatarInputLabel.Name = "InputLabel"
    avatarInputLabel.Size = UDim2.new(1, -36, 0, 18)
    avatarInputLabel.Position = UDim2.new(0, 18, 0, 178)
    avatarInputLabel.BackgroundTransparency = 1
    avatarInputLabel.Text = "Inserta ID pfp de tu preferencia"
    avatarInputLabel.TextColor3 = Theme.Colors.TextMuted
    avatarInputLabel.Font = Theme.Font.Bold
    avatarInputLabel.TextSize = 11
    avatarInputLabel.TextXAlignment = Enum.TextXAlignment.Left
    avatarInputLabel.ZIndex = 82
    avatarInputLabel.Parent = avatarModal

    local avatarIdInput = Instance.new("TextBox")
    avatarIdInput.Name = "AvatarIdInput"
    avatarIdInput.Size = UDim2.new(1, -36, 0, 34)
    avatarIdInput.Position = UDim2.new(0, 18, 0, 202)
    avatarIdInput.BackgroundColor3 = Color3.fromRGB(30, 31, 36)
    avatarIdInput.BorderSizePixel = 0
    avatarIdInput.Text = ""
    avatarIdInput.PlaceholderText = "Procura usar imagenes pfp"
    avatarIdInput.TextColor3 = Theme.Colors.Text
    avatarIdInput.PlaceholderColor3 = Theme.Colors.TextMuted
    avatarIdInput.Font = Theme.Font.Regular
    avatarIdInput.TextSize = 11
    avatarIdInput.ClearTextOnFocus = false
    avatarIdInput.ZIndex = 82
    avatarIdInput.Parent = avatarModal
    round(avatarIdInput, 8)
    stroke(avatarIdInput, Color3.fromRGB(96, 98, 112), 0.28)
    addPadding(avatarIdInput, 10, 10, 0, 0)

    local avatarModalStatus = Instance.new("TextLabel")
    avatarModalStatus.Name = "Status"
    avatarModalStatus.Size = UDim2.new(1, -36, 0, 22)
    avatarModalStatus.Position = UDim2.new(0, 18, 0, 242)
    avatarModalStatus.BackgroundTransparency = 1
    avatarModalStatus.Text = ""
    avatarModalStatus.TextColor3 = Theme.Colors.TextMuted
    avatarModalStatus.Font = Theme.Font.Regular
    avatarModalStatus.TextSize = 10
    avatarModalStatus.TextWrapped = true
    avatarModalStatus.TextXAlignment = Enum.TextXAlignment.Left
    avatarModalStatus.ZIndex = 82
    avatarModalStatus.Parent = avatarModal

    local avatarApplyButton = Instance.new("TextButton")
    avatarApplyButton.Name = "Apply"
    avatarApplyButton.Size = UDim2.new(0, 122, 0, 32)
    avatarApplyButton.Position = UDim2.new(0.5, -132, 1, -48)
    avatarApplyButton.BackgroundColor3 = Color3.fromRGB(66, 102, 76)
    avatarApplyButton.BorderSizePixel = 0
    avatarApplyButton.Text = "Aplicar"
    avatarApplyButton.TextColor3 = Theme.Colors.Text
    avatarApplyButton.Font = Theme.Font.Bold
    avatarApplyButton.TextSize = 12
    avatarApplyButton.ZIndex = 82
    avatarApplyButton.Parent = avatarModal
    round(avatarApplyButton, 8)

    local avatarCloseButton = Instance.new("TextButton")
    avatarCloseButton.Name = "CloseButton"
    avatarCloseButton.Size = UDim2.new(0, 122, 0, 32)
    avatarCloseButton.Position = UDim2.new(0.5, 10, 1, -48)
    avatarCloseButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    avatarCloseButton.BorderSizePixel = 0
    avatarCloseButton.Text = "Cerrar"
    avatarCloseButton.TextColor3 = Theme.Colors.Text
    avatarCloseButton.Font = Theme.Font.Bold
    avatarCloseButton.TextSize = 12
    avatarCloseButton.ZIndex = 82
    avatarCloseButton.Parent = avatarModal
    round(avatarCloseButton, 8)

    local avatarCandidateId = selectedProfileAvatarId
    local avatarCandidateIsDefault = selectedProfileAvatarId == ""
    local suppressAvatarInputChange = false
    local avatarInputVersion = 0
    local avatarOptionBorders = {}

    local function getAvatarOptionKey(isDefault, assetId)
        if isDefault then
            return "__default"
        end

        return tostring(assetId or "")
    end

    local function registerAvatarOptionBorder(button, isDefault, assetId)
        local optionStroke = stroke(button, Color3.fromRGB(80, 82, 92), 0.5)

        avatarOptionBorders[getAvatarOptionKey(isDefault, assetId)] = {
            Stroke = optionStroke,
            Color = optionStroke.Color,
            Transparency = optionStroke.Transparency
        }
    end

    local function updateAvatarOptionBorders()
        local selectedKey = getAvatarOptionKey(avatarCandidateIsDefault, avatarCandidateId)

        for key, border in pairs(avatarOptionBorders) do
            if key == selectedKey then
                border.Stroke.Color = Color3.fromRGB(0, 0, 0)
                border.Stroke.Transparency = 0
            else
                border.Stroke.Color = border.Color
                border.Stroke.Transparency = border.Transparency
            end
        end
    end

    local function setAvatarModalMode(showCustomPreview)
        avatarGrid.Visible = not showCustomPreview
        customPreviewHolder.Visible = showCustomPreview
    end

    local function setAvatarCandidate(assetId, showCustomPreview)
        avatarCandidateIsDefault = false
        avatarCandidateId = tostring(assetId or ""):gsub("^%s+", ""):gsub("%s+$", "")
        avatarModalStatus.Text = ""

        if showCustomPreview then
            setAvatarModalMode(true)

            if AvatarRenderer and AvatarRenderer.SetAssetPreview then
                AvatarRenderer.SetAssetPreview(customPreviewImage, avatarCandidateId)
            else
                customPreviewImage.Image = resolveImageAsset(avatarCandidateId) or ""
            end
        else
            setAvatarModalMode(false)
        end

        updateAvatarOptionBorders()
    end

    local defaultOption = Instance.new("ImageButton")
    defaultOption.Name = "AvatarOptionDefault"
    defaultOption.BackgroundColor3 = Color3.fromRGB(45, 46, 52)
    defaultOption.BorderSizePixel = 0
    defaultOption.Image = AvatarRenderer and AvatarRenderer.GetRobloxHeadshot
        and AvatarRenderer.GetRobloxHeadshot(player.UserId)
        or ""
    defaultOption.ScaleType = Enum.ScaleType.Crop
    defaultOption.ZIndex = 83
    defaultOption.LayoutOrder = 0
    defaultOption.Parent = avatarGrid
    round(defaultOption, 9)
    registerAvatarOptionBorder(defaultOption, true, "")

    local defaultOptionLabel = Instance.new("TextLabel")
    defaultOptionLabel.Name = "Label"
    defaultOptionLabel.Size = UDim2.new(1, 0, 0, 14)
    defaultOptionLabel.Position = UDim2.new(0, 0, 1, -14)
    defaultOptionLabel.BackgroundColor3 = Color3.fromRGB(20, 21, 25)
    defaultOptionLabel.BackgroundTransparency = 0.18
    defaultOptionLabel.BorderSizePixel = 0
    defaultOptionLabel.Text = "Por defecto"
    defaultOptionLabel.TextColor3 = Theme.Colors.Text
    defaultOptionLabel.Font = Theme.Font.Bold
    defaultOptionLabel.TextSize = 8
    defaultOptionLabel.TextXAlignment = Enum.TextXAlignment.Center
    defaultOptionLabel.ZIndex = 84
    defaultOptionLabel.Parent = defaultOption
    round(defaultOptionLabel, 6)

    defaultOption.MouseButton1Click:Connect(function()
        suppressAvatarInputChange = true
        avatarIdInput.Text = ""
        suppressAvatarInputChange = false
        avatarInputVersion += 1
        avatarCandidateId = ""
        avatarCandidateIsDefault = true
        setAvatarModalMode(false)
        updateAvatarOptionBorders()
        avatarModalStatus.Text = "Avatar de Roblox seleccionado."
    end)

    for index, avatarId in ipairs(DEFAULT_PROFILE_AVATAR_IDS) do
        local option = Instance.new("ImageButton")
        option.Name = "AvatarOption" .. tostring(index)
        option.BackgroundColor3 = Color3.fromRGB(45, 46, 52)
        option.BorderSizePixel = 0
        option.Image = ""
        option.ScaleType = Enum.ScaleType.Crop
        option.ZIndex = 83
        option.LayoutOrder = index
        option.Parent = avatarGrid
        round(option, 9)
        registerAvatarOptionBorder(option, false, avatarId)

        if AvatarRenderer and AvatarRenderer.SetAssetPreview then
            AvatarRenderer.SetAssetPreview(option, avatarId)
        else
            option.Image = resolveImageAsset(avatarId) or ""
        end

        option.MouseButton1Click:Connect(function()
            suppressAvatarInputChange = true
            avatarIdInput.Text = ""
            suppressAvatarInputChange = false
            avatarInputVersion += 1
            setAvatarCandidate(avatarId, false)
            avatarModalStatus.Text = "Imagen seleccionada."
        end)
    end

    avatarIdInput:GetPropertyChangedSignal("Text"):Connect(function()
        if suppressAvatarInputChange then
            return
        end

        local text = (avatarIdInput.Text or ""):gsub("%D", "")

        if text ~= avatarIdInput.Text then
            avatarIdInput.Text = text
            return
        end

        if text == "" then
            avatarCandidateId = selectedProfileAvatarId
            avatarCandidateIsDefault = selectedProfileAvatarId == ""
            setAvatarModalMode(false)
            updateAvatarOptionBorders()
            avatarModalStatus.Text = ""
            return
        end

        avatarCandidateId = text
        avatarCandidateIsDefault = false
        avatarModalStatus.Text = ""
        customPreviewImage.Image = ""
        setAvatarModalMode(true)
        updateAvatarOptionBorders()

        avatarInputVersion += 1
        local currentVersion = avatarInputVersion

        task.delay(0.35, function()
            if currentVersion ~= avatarInputVersion then
                return
            end

            if avatarIdInput.Text ~= text then
                return
            end

            if AvatarRenderer and AvatarRenderer.SetAssetPreview then
                AvatarRenderer.SetAssetPreview(customPreviewImage, text)
            else
                customPreviewImage.Image = resolveImageAsset(text) or ""
            end
        end)
    end)

    clearCustomPreview.MouseButton1Click:Connect(function()
        suppressAvatarInputChange = true
        avatarIdInput.Text = ""
        suppressAvatarInputChange = false
        avatarInputVersion += 1
        avatarCandidateId = selectedProfileAvatarId
        avatarCandidateIsDefault = selectedProfileAvatarId == ""
        setAvatarModalMode(false)
        updateAvatarOptionBorders()
        avatarModalStatus.Text = ""
    end)

    local function closeAvatarModal()
        avatarModalOverlay.Visible = false
        avatarModalStatus.Text = ""
    end

    editAvatarButton.MouseButton1Click:Connect(function()
        avatarCandidateId = selectedProfileAvatarId
        avatarCandidateIsDefault = selectedProfileAvatarId == ""
        suppressAvatarInputChange = true
        avatarIdInput.Text = ""
        suppressAvatarInputChange = false
        avatarInputVersion += 1
        setAvatarModalMode(false)
        updateAvatarOptionBorders()
        avatarModalStatus.Text = ""
        avatarModalOverlay.Visible = true
    end)

    avatarApplyButton.MouseButton1Click:Connect(function()
        if not avatarCandidateIsDefault and (not avatarCandidateId or avatarCandidateId:gsub("%s+", "") == "") then
            avatarModalStatus.Text = "Selecciona una imagen o inserta un ID."
            return
        end

        if not avatarCandidateIsDefault and (not avatarCandidateId:match("^%d+$") or #avatarCandidateId < 6) then
            avatarModalStatus.Text = "El ID debe ser numerico."
            return
        end

        local previousProfileAvatarId = selectedProfileAvatarId

        selectedProfileAvatarId = avatarCandidateIsDefault and "" or avatarCandidateId
        applyProfileAvatar(selectedProfileAvatarId)

        if avatarApplyHandler then
            avatarModalStatus.Text = "Aplicando imagen..."

            local ok, result = pcall(avatarApplyHandler, selectedProfileAvatarId)

            if not ok or not result or result.status ~= "ok" then
                selectedProfileAvatarId = previousProfileAvatarId
                avatarCandidateId = previousProfileAvatarId
                avatarCandidateIsDefault = previousProfileAvatarId == ""
                applyProfileAvatar(selectedProfileAvatarId)
                updateAvatarOptionBorders()

                if result and result.reason == "invalid_profile_avatar" then
                    avatarModalStatus.Text = "El ID de imagen de perfil no es valido."
                else
                    avatarModalStatus.Text = "No se pudo aplicar la imagen."
                end

                return
            end
        end

        closeAvatarModal()
        statusLabel.Text = "Imagen aplicada."
        statusLabel.TextColor3 = Theme.Colors.TextMuted
    end)

    avatarModalClose.MouseButton1Click:Connect(closeAvatarModal)
    avatarCloseButton.MouseButton1Click:Connect(closeAvatarModal)

    local function updateVisibilityButtons()
        publicButton.BackgroundColor3 =
            selectedVisibility == "public" and Color3.fromRGB(76, 78, 90) or Color3.fromRGB(56, 57, 64)
        publicButton.BackgroundTransparency =
            selectedVisibility == "public" and 0.02 or 0.16

        privateButton.BackgroundColor3 =
            selectedVisibility == "private" and Color3.fromRGB(76, 78, 90) or Color3.fromRGB(56, 57, 64)
        privateButton.BackgroundTransparency =
            selectedVisibility == "private" and 0.02 or 0.16
    end

    publicButton.MouseButton1Click:Connect(function()
        selectedVisibility = "public"
        updateVisibilityButtons()
    end)

    privateButton.MouseButton1Click:Connect(function()
        selectedVisibility = "private"
        updateVisibilityButtons()
    end)

    updateVisibilityButtons()

    local function refreshCanvas()
        return
    end

    if isMobileLayout then
        root.AnchorPoint = Vector2.new(0, 1)
        root.Size = UDim2.new(1, 0, 1, -64)
        root.Position = UDim2.new(0, 0, 1, 0)
        rootSize.MinSize = Vector2.new(0, 0)
        rootSize.MaxSize = Vector2.new(10000, 10000)
        rootCorner.CornerRadius = UDim.new(0, 0)

        closeButton.Size = UDim2.new(0, 32, 0, 28)
        closeButton.Position = UDim2.new(1, -42, 0, 9)

        content.Size = UDim2.new(1, -20, 1, -50)
        content.Position = UDim2.new(0, 10, 0, 30)

        local mobileLeftPanelScale = 0.37
        local mobileLeftPanelX = 30
        local mobileLeftPanelWidthOffset = -10

        leftPanel.Size = UDim2.new(mobileLeftPanelScale, mobileLeftPanelWidthOffset, 1, 14)
        leftPanel.Position = UDim2.new(0, mobileLeftPanelX, 0, -4)

        local leftShadow = content:FindFirstChild("PrivateProfilePanelShadowLeft")
        local rightShadow = content:FindFirstChild("PrivateProfilePanelShadowRight")

        if leftShadow then
            leftShadow.Size = UDim2.new(0, 30, 1, 14)
            leftShadow.Position = UDim2.new(0, mobileLeftPanelX - 24, 0, -4)
        end

        if rightShadow then
            rightShadow.Size = UDim2.new(0, 30, 1, 14)
            rightShadow.Position = UDim2.new(
                mobileLeftPanelScale,
                mobileLeftPanelX + mobileLeftPanelWidthOffset - 6,
                0,
                -4
            )
        end

        rightPanel.Size = UDim2.new(0.5, -14, 1, 0)
        rightPanel.Position = UDim2.new(0.47, 22, 0, 0)

        bannerClip.Size = UDim2.new(1, 0, 0, 70)
        banner.Size = UDim2.new(1, 0, 0, 84)
        avatarFrame.Size = UDim2.new(0, 56, 0, 56)
        avatarFrame.Position = UDim2.new(0, 14, 0, 48)
        displayInput.Size = UDim2.new(1, -184, 0, 22)
        displayInput.Position = UDim2.new(0, 82, 0, 72)
        displayInput.TextSize = 15
        username.Size = UDim2.new(1, -190, 0, 14)
        username.Position = UDim2.new(0, 82, 0, 95)
        username.TextSize = 10

        pointsLabel.Size = UDim2.new(1, -32, 0, 16)
        pointsLabel.Position = UDim2.new(0, 16, 0, 114)
        pointsLabel.TextSize = 11
        pointsValue.Size = UDim2.new(1, -32, 0, 18)
        pointsValue.Position = UDim2.new(0, 16, 0, 130)
        pointsValue.TextSize = 12

        clanLabel.Size = UDim2.new(1, -32, 0, 16)
        clanLabel.Position = UDim2.new(0, 16, 0, 150)
        clanLabel.TextSize = 11
        clanValue.Size = UDim2.new(1, -32, 0, 16)
        clanValue.Position = UDim2.new(0, 16, 0, 166)
        clanValue.TextSize = 11

        descriptionTitle.Size = UDim2.new(1, -32, 0, 16)
        descriptionTitle.Position = UDim2.new(0, 16, 0, 184)
        descriptionTitle.TextSize = 11
        descriptionInput.Size = UDim2.new(1, -32, 1, -214)
        descriptionInput.Position = UDim2.new(0, 16, 0, 202)
        descriptionInput.TextSize = 10

        inventoryButton.Size = UDim2.new(0, 92, 0, 22)
        inventoryButton.Position = UDim2.new(1, -102, 0, 72)
        inventoryButton.BackgroundColor3 = Color3.fromRGB(42, 43, 50)
        inventoryButton.BackgroundTransparency = 0
        inventoryButton.TextSize = 10
        inventoryButton.ZIndex = 6

        tabRow.Size = UDim2.new(1, 0, 0, 38)
        activityTab.Size = UDim2.new(0, 74, 0, 28)
        activityTab.Position = UDim2.new(0, 14, 0, 6)
        activityTab.TextSize = 12
        visibilityRow.Size = UDim2.new(0, 172, 0, 26)
        visibilityRow.Position = UDim2.new(0, 96, 0, 7)
        publicButton.Size = UDim2.new(0, 78, 0, 24)
        publicButton.TextSize = 10
        privateButton.Size = UDim2.new(0, 78, 0, 24)
        privateButton.Position = UDim2.new(0, 86, 0, 0)
        privateButton.TextSize = 10
        activityUnderline.Position = UDim2.new(0, 14, 1, -8)
        divider.Position = UDim2.new(0, 14, 0, 38)

        recentLabel.Position = UDim2.new(0, 14, 0, 52)
        recentLabel.TextSize = 11
        status.Size = UDim2.new(1, -12, 0, 24)
        status.Position = UDim2.new(0, 14, 0, 72)
        status.TextSize = 13
        languageTitle.Position = UDim2.new(0, 14, 0, 98)
        languageTitle.TextSize = 11
        languageUnderline.Position = UDim2.new(0, 14, 0, 120)
        languageButtons.Size = UDim2.new(0, 176, 0, 26)
        languageButtons.Position = UDim2.new(0, 14, 0, 130)
        spanishButton.Size = UDim2.new(0, 82, 0, 24)
        spanishButton.TextSize = 10
        englishButton.Size = UDim2.new(0, 82, 0, 24)
        englishButton.Position = UDim2.new(0, 90, 0, 0)
        englishButton.TextSize = 10

        statusLabel.Size = UDim2.new(0.88, 0, 0, 24)
        statusLabel.Position = UDim2.new(0, 14, 1, -82)
        statusLabel.TextSize = 10
        statusLabel.TextXAlignment = Enum.TextXAlignment.Left
        actions.Size = UDim2.new(0.88, 0, 0, 28)
        actions.Position = UDim2.new(0, -10, 1, -42)
        saveButton.Size = UDim2.new(0.41, -4, 1, 0)
        saveButton.Position = UDim2.new(0.07, 0, 0, 0)
        saveButton.TextSize = 10
        publicProfileButton.Size = UDim2.new(0.44, -4, 1, 0)
        publicProfileButton.Position = UDim2.new(0.51, 0, 0, 0)
        publicProfileButton.TextSize = 10
    end

    refreshCanvas()

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        SaveButton = saveButton,
        PublicProfileButton = publicProfileButton,
        InventoryButton = inventoryButton,
        StatusLabel = statusLabel,

        SetAvatarApplyHandler = function(handler)
            avatarApplyHandler = handler
        end,

        GetChangedData = function()
            local data = {}
            local nextDisplayName = displayInput.Text or ""
            local nextBio = descriptionInput.Text or ""

            if nextDisplayName ~= original.display_name then
                data.display_name = nextDisplayName
            end

            if nextBio ~= original.bio then
                data.bio = nextBio
            end

            if selectedProfileAvatarId ~= original.profile_avatar_id then
                data.profile_avatar_id = selectedProfileAvatarId
            end

            if selectedVisibility ~= original.game_status_visibility then
                data.game_status_visibility = selectedVisibility
            end

            return data
        end,

        GetChanges = function()
            return {
                display_name = displayInput.Text,
                bio = descriptionInput.Text,
                profile_avatar_id = selectedProfileAvatarId,
                game_status_visibility = selectedVisibility
            }
        end,

        ApplyProfile = function(nextProfile)
            profile = nextProfile or profile

            original.display_name = tostring(profile.display_name or player.DisplayName)
            original.bio = tostring(profile.bio or "")
            original.profile_avatar_id = tostring(profile.profile_avatar_id or "")
            original.game_status_visibility = tostring(profile.game_status_visibility or "public")

            displayInput.Text = original.display_name
            username.Text = "@" .. tostring(profile.roblox_username or player.Name)
            descriptionInput.Text = original.bio
            selectedProfileAvatarId = original.profile_avatar_id
            selectedVisibility = original.game_status_visibility
            avatarCandidateId = selectedProfileAvatarId
            avatarCandidateIsDefault = selectedProfileAvatarId == ""
            pointsValue.Text = tostring(profile.personal_points or 0)
            clanValue.Text = tostring(profile.clan_name or "Sin clan")
            status.Text = translateProfileText(getCurrentActivityText(profile))
            applyBannerImage(profile.profile_banner_id)
            applyProfileAvatar(selectedProfileAvatarId)
            updateAvatarOptionBorders()
            updateVisibilityButtons()
            refreshCanvas()
        end,

        ShowStatus = function(message, isError)
            if _G.StrikeChatI18n then
                statusLabel.Text = _G.StrikeChatI18n.TranslateText(message or "")
            else
                statusLabel.Text = message or ""
            end

            statusLabel.TextColor3 = isError and Theme.Colors.Danger or Theme.Colors.TextMuted
        end,

        Destroy = function()
            gui:Destroy()
        end
    }
end

return ProfileUI
