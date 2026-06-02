local PublicProfileUI = {}

function PublicProfileUI.Create(parent, Theme, profile, player, AvatarRenderer)
    local Players = game:GetService("Players")
    local DEFAULT_PROFILE_BANNER_ID = "114828705105935"
    local isMobileLayout = _G.StrikeChatLayoutMode == "mobile"
    local resolvedImageCache = {}

    profile = profile or {}

    local modalColor = Color3.fromRGB(48, 49, 55)
    local panelColor = Color3.fromRGB(57, 58, 65)
    local inputColor = Color3.fromRGB(48, 49, 55)
    local borderColor = Color3.fromRGB(74, 76, 86)

    local overlay = Instance.new("Frame")
    overlay.Name = "PublicProfileOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.ZIndex = 90
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0.36, 0, 0.72, 0)
    modal.Position = UDim2.new(0.5, 0, 0.52, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = modalColor
    modal.BorderSizePixel = 0
    modal.ClipsDescendants = true
    modal.ZIndex = 91
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(350, 470)
    sizeConstraint.MaxSize = Vector2.new(370, 540)
    sizeConstraint.Parent = modal

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

    round(modal, Theme.Radius.Main)
    stroke(modal, Color3.fromRGB(96, 98, 110), 0.48)

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 28, 0, 24)
    closeButton.Position = UDim2.new(1, -34, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(65, 66, 74)
    closeButton.BackgroundTransparency = 0.12
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 96
    closeButton.Parent = modal
    round(closeButton, 10)

    local function createCardShadow(name, size, position, rotation, transparency)
        local shadow = Instance.new("Frame")
        shadow.Name = name
        shadow.Size = size
        shadow.Position = position
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 91
        shadow.Parent = modal

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

    createCardShadow(
        "PublicProfileCardShadowLeft",
        UDim2.new(0, 28, 1, -64),
        UDim2.new(0, 3, 0, 46),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 1.00),
            NumberSequenceKeypoint.new(0.72, 0.68),
            NumberSequenceKeypoint.new(1.00, 0.52)
        })
    )

    createCardShadow(
        "PublicProfileCardShadowRight",
        UDim2.new(0, 38, 1, -64),
        UDim2.new(1, -41, 0, 46),
        0,
        NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.52),
            NumberSequenceKeypoint.new(0.34, 0.64),
            NumberSequenceKeypoint.new(1.00, 1.00)
        })
    )

    local card = Instance.new("Frame")
    card.Name = "PublicProfileCard"
    card.Size = UDim2.new(1, -54, 1, -56)
    card.Position = UDim2.new(0, 27, 0, 42)
    card.BackgroundColor3 = panelColor
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.ZIndex = 92
    card.Parent = modal
    round(card, 14)
    stroke(card, Color3.fromRGB(82, 84, 94), 0.52)

    local bannerClip = Instance.new("Frame")
    bannerClip.Name = "BannerClip"
    bannerClip.Size = UDim2.new(1, 0, 0, 118)
    bannerClip.BackgroundTransparency = 1
    bannerClip.BorderSizePixel = 0
    bannerClip.ClipsDescendants = true
    bannerClip.ZIndex = 93
    bannerClip.Parent = card

    local banner = Instance.new("Frame")
    banner.Name = "Banner"
    banner.Size = UDim2.new(1, 0, 0, 132)
    banner.BackgroundColor3 = Color3.fromRGB(58, 16, 90)
    banner.BorderSizePixel = 0
    banner.ClipsDescendants = true
    banner.ZIndex = 93
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
    bannerStars.ZIndex = 93
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
        point.ZIndex = 93
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
    bannerComets.ZIndex = 93
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
            comet.ZIndex = 93
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
    bannerImage.ZIndex = 94
    bannerImage.Parent = banner
    round(bannerImage, 14)

    local bannerAsset = nil

    if profile.profile_banner_id and tostring(profile.profile_banner_id) ~= DEFAULT_PROFILE_BANNER_ID then
        bannerAsset = resolveImageAsset(profile.profile_banner_id)
    end

    if bannerAsset then
        bannerImage.Image = bannerAsset
        bannerImage.ImageTransparency = 0
        bannerImage.Visible = true
    else
        bannerImage.Visible = false
    end

    local activityText = tostring(profile.activity_text or "")

    if activityText ~= "" then
        local activityLabel = Instance.new("TextLabel")
        activityLabel.Name = "ActivityText"
        activityLabel.Size = UDim2.new(1, -150, 0, 18)
        activityLabel.Position = UDim2.new(0, 124, 0, 84)
        activityLabel.BackgroundTransparency = 1
        activityLabel.Text = activityText
        activityLabel.TextColor3 = Theme.Colors.Text
        activityLabel.Font = Theme.Font.Bold
        activityLabel.TextSize = 10
        activityLabel.TextXAlignment = Enum.TextXAlignment.Right
        activityLabel.TextTruncate = Enum.TextTruncate.AtEnd
        activityLabel.ZIndex = 96
        activityLabel.Parent = banner
    end

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 88, 0, 88)
    avatarFrame.Position = UDim2.new(0, 22, 0, 68)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(31, 32, 38)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 97
    avatarFrame.Parent = card
    round(avatarFrame, 44)
    stroke(avatarFrame, Color3.fromRGB(128, 130, 148), 0.08)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, -6, 1, -6)
    avatarImage.Position = UDim2.new(0, 3, 0, 3)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ZIndex = 98
    avatarImage.Parent = avatarFrame
    round(avatarImage, 41)

    local userId = tonumber(profile.roblox_user_id) or player.UserId

    if AvatarRenderer and AvatarRenderer.SetAvatar then
        AvatarRenderer.SetAvatar(avatarImage, userId, profile.profile_avatar_id, true)
    else
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(
                userId,
                Enum.ThumbnailType.AvatarBust,
                Enum.ThumbnailSize.Size180x180
            )
        end)

        if ok then
            avatarImage.Image = image
        end
    end

    local identityX = 0
    local identityOffset = 124

    local displayName = Instance.new("TextLabel")
    displayName.Name = "DisplayName"
    displayName.Size = UDim2.new(1, -142, 0, 28)
    displayName.Position = UDim2.new(identityX, identityOffset, 0, 122)
    displayName.BackgroundTransparency = 1
    displayName.Text = tostring(profile.display_name or "Usuario")
    displayName.TextColor3 = Theme.Colors.Text
    displayName.Font = Theme.Font.Bold
    displayName.TextSize = 20
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.TextTruncate = Enum.TextTruncate.AtEnd
    displayName.ZIndex = 95
    displayName.Parent = card

    local username = Instance.new("TextLabel")
    username.Name = "Username"
    username.Size = UDim2.new(1, -142, 0, 16)
    username.Position = UDim2.new(identityX, identityOffset, 0, 151)
    username.BackgroundTransparency = 1
    username.Text = "@" .. tostring(profile.roblox_username or player.Name)
    username.TextColor3 = Theme.Colors.TextMuted
    username.Font = Theme.Font.Bold
    username.TextSize = 11
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.TextTruncate = Enum.TextTruncate.AtEnd
    username.ZIndex = 95
    username.Parent = card

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
    pointsLabel.ZIndex = 95
    pointsLabel.Parent = card

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
    pointsValue.ZIndex = 95
    pointsValue.Parent = card

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
    clanLabel.ZIndex = 95
    clanLabel.Parent = card

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
    clanValue.ZIndex = 95
    clanValue.Parent = card

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
    descriptionTitle.ZIndex = 95
    descriptionTitle.Parent = card

    local descriptionBox = Instance.new("TextLabel")
    descriptionBox.Name = "DescriptionBox"
    descriptionBox.Size = UDim2.new(1, -64, 0, 72)
    descriptionBox.Position = UDim2.new(0, 32, 0, 296)
    descriptionBox.BackgroundColor3 = inputColor
    descriptionBox.BackgroundTransparency = 0
    descriptionBox.BorderSizePixel = 0
    descriptionBox.Text = tostring(profile.bio or "Cuentales algo sobre ti...")
    descriptionBox.TextColor3 = profile.bio and Theme.Colors.Text or Theme.Colors.TextMuted
    descriptionBox.Font = Theme.Font.Regular
    descriptionBox.TextSize = 12
    descriptionBox.TextWrapped = true
    descriptionBox.TextXAlignment = Enum.TextXAlignment.Left
    descriptionBox.TextYAlignment = Enum.TextYAlignment.Top
    descriptionBox.ZIndex = 95
    descriptionBox.Parent = card
    round(descriptionBox, 8)
    stroke(descriptionBox, Color3.fromRGB(43, 44, 50), 0.62)
    addPadding(descriptionBox, 12, 12, 10, 10)

    local actions = Instance.new("Frame")
    actions.Name = "Actions"
    actions.Size = UDim2.new(0, 176, 0, 32)
    actions.Position = UDim2.new(0.5, -88, 1, -36)
    actions.BackgroundTransparency = 1
    actions.ZIndex = 95
    actions.Parent = card

    local messageButton = Instance.new("TextButton")
    messageButton.Name = "MessageButton"
    messageButton.Size = UDim2.new(0, 94, 0, 30)
    messageButton.Position = UDim2.new(0, 0, 0, 0)
    messageButton.BackgroundColor3 = Color3.fromRGB(76, 86, 198)
    messageButton.BackgroundTransparency = 0.02
    messageButton.BorderSizePixel = 0
    messageButton.Text = "Mensaje"
    messageButton.TextColor3 = Theme.Colors.Text
    messageButton.Font = Theme.Font.Bold
    messageButton.TextSize = 12
    messageButton.ZIndex = 96
    messageButton.Parent = actions
    round(messageButton, 8)

    local addButton = Instance.new("TextButton")
    addButton.Name = "AddButton"
    addButton.Size = UDim2.new(0, 74, 0, 30)
    addButton.Position = UDim2.new(0, 102, 0, 0)
    addButton.BackgroundColor3 = Color3.fromRGB(66, 68, 78)
    addButton.BackgroundTransparency = 0.04
    addButton.BorderSizePixel = 0
    addButton.Text = "Agregar"
    addButton.TextColor3 = Theme.Colors.Text
    addButton.Font = Theme.Font.Bold
    addButton.TextSize = 12
    addButton.ZIndex = 96
    addButton.Parent = actions
    round(addButton, 8)

    if isMobileLayout then
        modal.AnchorPoint = Vector2.new(0.5, 1)
        modal.Size = UDim2.new(0.42, 0, 1, -32)
        modal.Position = UDim2.new(0.5, 0, 1, 0)
        sizeConstraint.MinSize = Vector2.new(280, 0)
        sizeConstraint.MaxSize = Vector2.new(360, 10000)

        closeButton.Size = UDim2.new(0, 32, 0, 28)
        closeButton.Position = UDim2.new(1, -42, 0, 5)

        card.Size = UDim2.new(1, -28, 1, -38)
        card.Position = UDim2.new(0, 14, 0, 30)

        bannerClip.Size = UDim2.new(1, 0, 0, 68)
        banner.Size = UDim2.new(1, 0, 0, 82)
        avatarFrame.Size = UDim2.new(0, 56, 0, 56)
        avatarFrame.Position = UDim2.new(0, 14, 0, 46)
        displayName.Size = UDim2.new(1, -88, 0, 22)
        displayName.Position = UDim2.new(0, 82, 0, 70)
        displayName.TextSize = 15
        username.Size = UDim2.new(1, -88, 0, 14)
        username.Position = UDim2.new(0, 82, 0, 94)
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
        descriptionTitle.Position = UDim2.new(0, 16, 0, 180)
        descriptionTitle.TextSize = 11
        descriptionBox.Size = UDim2.new(1, -32, 0, 46)
        descriptionBox.Position = UDim2.new(0, 16, 0, 196)
        descriptionBox.TextSize = 10

        actions.Size = UDim2.new(0, 162, 0, 28)
        actions.Position = UDim2.new(0.5, -81, 1, -34)
        messageButton.Size = UDim2.new(0, 86, 0, 26)
        messageButton.TextSize = 11
        addButton.Size = UDim2.new(0, 68, 0, 26)
        addButton.Position = UDim2.new(0, 94, 0, 0)
        addButton.TextSize = 11
    end

    closeButton.MouseButton1Click:Connect(function()
        overlay:Destroy()
    end)

    return {
        Overlay = overlay,
        CloseButton = closeButton,

        Destroy = function()
            overlay:Destroy()
        end
    }
end

return PublicProfileUI
