local RightPanel = {}

function RightPanel.Create(parent, Theme, AvatarRenderer)
    local UserInputService = game:GetService("UserInputService")

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

    local clanColorMap = {
        white = Color3.fromRGB(245, 245, 245),
        red = Color3.fromRGB(235, 74, 74),
        green = Color3.fromRGB(78, 190, 92),
        blue = Color3.fromRGB(74, 142, 245),
        yellow = Color3.fromRGB(245, 205, 70),
        orange = Color3.fromRGB(255, 156, 64),
        pink = Color3.fromRGB(255, 110, 180),
        purple = Color3.fromRGB(168, 6, 235),
        black = Color3.fromRGB(32, 32, 36),
        cyan = Color3.fromRGB(64, 210, 230)
    }

    local usernameColorMap = {
        white = Color3.fromRGB(245, 245, 245),
        red = Color3.fromRGB(235, 74, 74),
        green = Color3.fromRGB(78, 190, 92),
        blue = Color3.fromRGB(74, 142, 245),
        yellow = Color3.fromRGB(245, 205, 70),
        orange = Color3.fromRGB(255, 156, 64),
        pink = Color3.fromRGB(255, 110, 180),
        purple = Color3.fromRGB(168, 6, 235),
        black = Color3.fromRGB(32, 32, 36),
        cyan = Color3.fromRGB(64, 210, 230)
    }

    local function getClanColor(colorName)
        local key = tostring(colorName or ""):lower()

        return clanColorMap[key] or Theme.Colors.TextMuted
    end

    local function getUsernameColor(colorName)
        local key = tostring(colorName or ""):lower()

        return usernameColorMap[key] or Theme.Colors.Text
    end

    local function colorToHex(color)
        return string.format(
            "#%02X%02X%02X",
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5)
        )
    end

    local function escapeRichText(text)
        return tostring(text or "")
            :gsub("&", "&amp;")
            :gsub("<", "&lt;")
            :gsub(">", "&gt;")
            :gsub('"', "&quot;")
            :gsub("'", "&apos;")
    end

    local function getUserStatusText(user)
        local visibility = tostring(user.game_status_visibility or user.activity_visibility or "private"):lower()

        if visibility ~= "public" then
            return _G.StrikeChatI18n and _G.StrikeChatI18n.TranslateText("En linea") or "En linea"
        end

        local activityText =
            user.activity_text or
            user.current_activity_text or
            user.game_activity_text

        if activityText and tostring(activityText):gsub("%s+", "") ~= "" then
            return tostring(activityText)
        end

        local placeName =
            user.place_name or
            user.current_place_name or
            user.game_name

        if placeName and tostring(placeName):gsub("%s+", "") ~= "" then
            return _G.StrikeChatI18n
                and _G.StrikeChatI18n.TranslateText("Jugando a " .. tostring(placeName))
                or "Jugando a " .. tostring(placeName)
        end

        return _G.StrikeChatI18n and _G.StrikeChatI18n.TranslateText("En linea") or "En linea"
    end

    local title = Instance.new("TextLabel")
    title.Name = "OnlineTitle"
    title.Size = UDim2.new(1, -24, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "En Línea - 0"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = parent

    local titleUnderline = Instance.new("Frame")
    titleUnderline.Name = "OnlineTitleUnderline"
    titleUnderline.Size = UDim2.new(1, -24, 0, 1)
    titleUnderline.Position = UDim2.new(0, 12, 0, 42)
    titleUnderline.BackgroundColor3 = Color3.fromRGB(71, 72, 82)
    titleUnderline.BackgroundTransparency = 0.35
    titleUnderline.BorderSizePixel = 0
    titleUnderline.Parent = parent

    local list = Instance.new("ScrollingFrame")
    list.Name = "OnlineList"
    list.Size = UDim2.new(1, -24, 1, -56)
    list.Position = UDim2.new(0, 12, 0, 46)
    list.BackgroundColor3 = Theme.Colors.Background
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 2
    list.ScrollingEnabled = true
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.Parent = parent

    local scrollHint = Instance.new("Frame")
    scrollHint.Name = "RightScrollHint"
    scrollHint.Size = UDim2.new(0, 1, 1, -16)
    scrollHint.Position = UDim2.new(1, -2, 0, 8)
    scrollHint.BackgroundColor3 = Theme.Colors.TextMuted
    scrollHint.BackgroundTransparency = 0.2
    scrollHint.BorderSizePixel = 0
    scrollHint.Visible = false
    scrollHint.ZIndex = 20
    scrollHint.Parent = parent

    local scrollHintCorner = Instance.new("UICorner")
    scrollHintCorner.CornerRadius = UDim.new(1, 0)
    scrollHintCorner.Parent = scrollHint

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, Theme.Radius.Panel)
    listCorner.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 0)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 0)
    padding.Parent = list

    local function clear()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("GuiObject") then
                child:Destroy()
            end
        end
    end

    local function renderUser(user, onUserSelected)
        local row = Instance.new("TextButton")
        row.Name = "UserRow"
        row.Size = UDim2.new(1, 0, 0, 54)
        row.BackgroundColor3 = Theme.Colors.Background
        row.BorderSizePixel = 0
        row.Text = ""
        row.AutoButtonColor = false
        row.Active = true
        row.Parent = list

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        rowCorner.Parent = row

        local avatarHolder = Instance.new("Frame")
        avatarHolder.Name = "AvatarHolder"
        avatarHolder.Size = UDim2.new(0, 34, 0, 34)
        avatarHolder.Position = UDim2.new(0, -2, 0.5, -17)
        avatarHolder.BackgroundColor3 = Theme.Colors.Panel
        avatarHolder.BorderSizePixel = 0
        avatarHolder.Parent = row

        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(1, 0)
        avatarCorner.Parent = avatarHolder

        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Avatar"
        avatar.Size = UDim2.new(1, 0, 1, 0)
        avatar.BackgroundTransparency = 1
        avatar.Parent = avatarHolder

        if AvatarRenderer and AvatarRenderer.SetAvatar then
            AvatarRenderer.SetAvatar(avatar, user.roblox_user_id, user.profile_avatar_id)
        else
            avatar.Image =
                "https://www.roblox.com/headshot-thumbnail/image?userId="
                .. tostring(user.roblox_user_id)
                .. "&width=48&height=48&format=png"
        end

        local avatarImageCorner = Instance.new("UICorner")
        avatarImageCorner.CornerRadius = UDim.new(1, 0)
        avatarImageCorner.Parent = avatar

        local statusDot = Instance.new("Frame")
        statusDot.Name = "StatusDot"
        statusDot.Size = UDim2.new(0, 10, 0, 10)
        statusDot.Position = UDim2.new(1, -8, 1, -8)
        statusDot.BackgroundColor3 = Theme.Colors.Success
        statusDot.BorderSizePixel = 0
        statusDot.ZIndex = 5
        statusDot.Parent = avatarHolder

        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = statusDot

        local displayName = user.display_name or user.roblox_username or "Usuario"

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, -54, 0, 16)
        name.Position = UDim2.new(0, 42, 0, 8)
        name.BackgroundTransparency = 1

        local clanText = ""

        if user.clan_tag then
            if user.clan_tag_style == "plain" then
                clanText = "_" .. tostring(user.clan_tag)
            else
                clanText = "[" .. tostring(user.clan_tag) .. "]"
            end
        end

        if isMobileLandscape() then
            name.Size = UDim2.new(1, -58, 0, 16)
        end

        name.RichText = true
        name.Text =
            '<font color="' ..
            colorToHex(getUsernameColor(user.active_username_color or user.username_color)) ..
            '">' ..
            escapeRichText(displayName) ..
            "</font>" ..
            '<font color="' ..
            colorToHex(getClanColor(user.clan_color)) ..
            '">' ..
            escapeRichText(clanText) ..
            "</font>"
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 12
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.Parent = row

        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Size = UDim2.new(1, -60, 0, 14)
        status.Position = UDim2.new(0, 42, 0, 26)
        status.BackgroundTransparency = 1
        status.Text = getUserStatusText(user)
        status.TextColor3 = Theme.Colors.TextMuted
        status.Font = Theme.Font.Regular
        status.TextSize = 11
        status.TextXAlignment = Enum.TextXAlignment.Left
        status.TextTruncate = Enum.TextTruncate.AtEnd
        status.Parent = row

        local openingProfile = false
        local function openProfile()
            if openingProfile then
                return
            end

            openingProfile = true

            if onUserSelected then
                onUserSelected(user)
            end

            task.delay(0.35, function()
                openingProfile = false
            end)
        end

        row.Activated:Connect(openProfile)
        row.MouseButton1Click:Connect(openProfile)
    end

    local function render(users, onUserSelected)
        clear()


        for _, user in ipairs(users or {}) do
            renderUser(user, onUserSelected)
        end

        task.wait()
        list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end

    local function applyResponsiveLayout()
        if isMobileLandscape() then
            title.Size = UDim2.new(1, -20, 0, 30)
            title.Position = UDim2.new(0, 10, 0, 7)
            title.TextSize = 13
            titleUnderline.Size = UDim2.new(1, -20, 0, 1)
            titleUnderline.Position = UDim2.new(0, 10, 0, 37)
            list.Size = UDim2.new(1, -20, 1, -48)
            list.Position = UDim2.new(0, 10, 0, 42)
            list.ScrollBarThickness = 1
            list.ScrollBarImageColor3 = Theme.Colors.TextMuted
            list.ScrollBarImageTransparency = 0.35
            scrollHint.Visible = true
            scrollHint.Size = UDim2.new(0, 1, 1, -16)
            scrollHint.Position = UDim2.new(1, -2, 0, 8)
        else
            title.Size = UDim2.new(1, -24, 0, 36)
            title.Position = UDim2.new(0, 12, 0, 8)
            title.TextSize = 15
            titleUnderline.Size = UDim2.new(1, -24, 0, 1)
            titleUnderline.Position = UDim2.new(0, 12, 0, 42)
            list.Size = UDim2.new(1, -24, 1, -56)
            list.Position = UDim2.new(0, 12, 0, 46)
            list.ScrollBarThickness = 2
            list.ScrollBarImageTransparency = 0
            scrollHint.Visible = false
        end
    end

    applyResponsiveLayout()

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveLayout)
    end

    return {
        Title = title,
        TitleUnderline = titleUnderline,
        List = list,
        ScrollHint = scrollHint,
        Render = render
    }
end

return RightPanel
