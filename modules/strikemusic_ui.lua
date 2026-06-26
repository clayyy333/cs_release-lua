local StrikeMusicUI = {}

local COLORS = {
    Background = Color3.fromRGB(8, 11, 17),
    Panel = Color3.fromRGB(15, 19, 28),
    PanelSoft = Color3.fromRGB(18, 22, 32),
    PanelLight = Color3.fromRGB(25, 30, 42),
    Border = Color3.fromRGB(38, 45, 58),
    Text = Color3.fromRGB(245, 247, 255),
    Muted = Color3.fromRGB(157, 164, 180),
    Purple = Color3.fromRGB(137, 50, 235),
    PurpleBright = Color3.fromRGB(180, 80, 255),
    Green = Color3.fromRGB(78, 190, 92),
    ProgressBack = Color3.fromRGB(42, 48, 61)
}

local TITLE_FONT = Enum.Font.GothamBold
local SECTION_TITLE_FONT = Enum.Font.GothamMedium

local function tr(text)
    local i18n = _G.StrikeChatI18n

    if i18n and i18n.TranslateText then
        return i18n.TranslateText(text)
    end

    return text
end

local function makeFloatingButtonDraggable(button)
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragStart = nil
    local startAbsolutePosition = nil
    local moved = false

    button.Active = true
    button:SetAttribute("WasDragged", false)

    local function getViewportSize()
        local camera = workspace.CurrentCamera

        if camera then
            return camera.ViewportSize
        end

        return Vector2.new(1280, 720)
    end

    local function clampPosition(position)
        local viewport = getViewportSize()
        local width = button.AbsoluteSize.X
        local height = button.AbsoluteSize.Y
        local x = math.clamp(position.X.Offset, 0, math.max(viewport.X - width, 0))
        local y = math.clamp(position.Y.Offset, 0, math.max(viewport.Y - height, 0))

        return UDim2.new(0, x, 0, y)
    end

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            moved = false
            button:SetAttribute("WasDragged", false)
            dragStart = input.Position
            startAbsolutePosition = button.AbsolutePosition
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            )
            and dragStart
            and startAbsolutePosition
        then
            local delta = input.Position - dragStart

            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
                moved = true
            end

            button.Position = clampPosition(UDim2.new(
                    0,
                    startAbsolutePosition.X + delta.X,
                    0,
                    startAbsolutePosition.Y + delta.Y
                ))
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = false
            dragStart = nil
            startAbsolutePosition = nil
            button:SetAttribute("WasDragged", moved)

            if moved then
                task.delay(0.12, function()
                    if button.Parent then
                        button:SetAttribute("WasDragged", false)
                    end
                end)
            end
        end
    end)
end
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent

    return corner
end

local function createStroke(parent, color, transparency, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or COLORS.Border
    stroke.Transparency = transparency or 0.45
    stroke.Thickness = thickness or 1
    stroke.Parent = parent

    return stroke
end

local function createLabel(parent, name, text, size, position, textSize, font, color)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position or UDim2.new()
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextColor3 = color or COLORS.Text
    label.Font = font or Enum.Font.Gotham
    label.TextSize = textSize or 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent

    return label
end

local function createIconButton(parent, name, text, size, position)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position or UDim2.new()
    button.BackgroundColor3 = COLORS.PanelLight
    button.BackgroundTransparency = 0.15
    button.BorderSizePixel = 0
    button.Text = text or ""
    button.TextColor3 = COLORS.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.AutoButtonColor = true
    button.Parent = parent
    createCorner(button, 10)

    return button
end

local function createPanel(parent, name, size, position)
    local panel = Instance.new("Frame")
    panel.Name = name
    panel.Size = size
    panel.Position = position or UDim2.new()
    panel.BackgroundColor3 = COLORS.Panel
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Active = true
    panel.Parent = parent
    createCorner(panel, 10)
    createStroke(panel, COLORS.Border, 0.72, 1)

    return panel
end

local function createEmptyState(parent, text)
    local empty = createLabel(
        parent,
        "EmptyState",
        text,
        UDim2.new(1, -24, 0, 34),
        UDim2.new(0, 12, 0.5, -17),
        12,
        Enum.Font.GothamBold,
        COLORS.Muted
    )
    empty.TextXAlignment = Enum.TextXAlignment.Center

    return empty
end

local function clearContainer(container)
    for _, child in ipairs(container:GetChildren()) do
        if child:IsA("GuiObject")
            or child:IsA("UIListLayout")
            or child:IsA("UIGridLayout")
        then
            child:Destroy()
        end
    end
end

local function createProgress(parent, position, size, value, interactive)
    local UserInputService = game:GetService("UserInputService")
    local changed = Instance.new("BindableEvent")
    local progressValue = math.clamp(value or 0.18, 0, 1)
    local previewValue = progressValue
    local dragging = false

    local back = Instance.new("Frame")
    back.Name = "ProgressBack"
    back.Size = size
    back.Position = position
    back.BackgroundColor3 = COLORS.ProgressBack
    back.BorderSizePixel = 0
    back.Active = true
    back.Parent = parent
    createCorner(back, 4)

    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(progressValue, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Purple
    fill.BorderSizePixel = 0
    fill.Parent = back
    createCorner(fill, 4)

    local knob = Instance.new("Frame")
    knob.Name = "ProgressKnob"
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(progressValue, -6, 0.5, -6)
    knob.BackgroundColor3 = COLORS.Text
    knob.BorderSizePixel = 0
    knob.Visible = false
    knob.ZIndex = (back.ZIndex or 1) + 2
    knob.Parent = back
    createCorner(knob, 6)

    local function setVisual(nextValue)
        previewValue = math.clamp(nextValue or 0, 0, 1)
        fill.Size = UDim2.new(previewValue, 0, 1, 0)
        knob.Position = UDim2.new(previewValue, -6, 0.5, -6)
    end

    local function setValue(nextValue)
        progressValue = math.clamp(nextValue or 0, 0, 1)
        setVisual(progressValue)
    end

    local function setFromX(x)
        local absoluteX = back.AbsolutePosition.X
        local width = math.max(back.AbsoluteSize.X, 1)
        setVisual((x - absoluteX) / width)
    end

    if interactive then
        local hitArea = Instance.new("TextButton")
        hitArea.Name = "ProgressHitArea"
        hitArea.Size = UDim2.new(1, 0, 0, 18)
        hitArea.Position = UDim2.new(0, 0, 0.5, -9)
        hitArea.BackgroundTransparency = 1
        hitArea.BorderSizePixel = 0
        hitArea.Text = ""
        hitArea.AutoButtonColor = false
        hitArea.Active = true
        hitArea.ZIndex = (back.ZIndex or 1) + 3
        hitArea.Parent = back

        hitArea.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                dragging = true
                knob.Visible = true
                setFromX(input.Position.X)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging
                and (
                    input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch
                )
            then
                setFromX(input.Position.X)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                if dragging then
                    progressValue = previewValue
                    changed:Fire(progressValue)
                end

                dragging = false
                knob.Visible = false
            end
        end)
    end

    return back, fill, changed.Event, function()
        return dragging
    end, setValue
end

local function createVolumeSlider(parent, position, size, initialValue)
    local UserInputService = game:GetService("UserInputService")
    local changed = Instance.new("BindableEvent")
    local value = math.clamp(initialValue or 0.52, 0, 1)
    local dragging = false

    local back = Instance.new("Frame")
    back.Name = "VolumeSlider"
    back.Size = size
    back.Position = position
    back.BackgroundColor3 = COLORS.ProgressBack
    back.BorderSizePixel = 0
    back.Parent = parent
    createCorner(back, 4)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(value, 0, 1, 0)
    fill.BackgroundColor3 = COLORS.Purple
    fill.BorderSizePixel = 0
    fill.Parent = back
    createCorner(fill, 4)

    local knob = Instance.new("TextButton")
    knob.Name = "Knob"
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(value, -7, 0.5, -7)
    knob.BackgroundColor3 = COLORS.Text
    knob.BorderSizePixel = 0
    knob.Text = ""
    knob.AutoButtonColor = true
    knob.Active = true
    knob.Parent = back
    createCorner(knob, 7)

    local function setValue(nextValue, fireChanged)
        value = math.clamp(nextValue or 0, 0, 1)
        fill.Size = UDim2.new(value, 0, 1, 0)
        knob.Position = UDim2.new(value, -7, 0.5, -7)

        if fireChanged then
            changed:Fire(value)
        end
    end

    local function setFromX(x)
        local absoluteX = back.AbsolutePosition.X
        local width = math.max(back.AbsoluteSize.X, 1)
        setValue((x - absoluteX) / width, true)
    end

    back.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            setFromX(input.Position.X)
        end
    end)

    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            setFromX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = false
        end
    end)

    return {
        Root = back,
        Fill = fill,
        Knob = knob,
        Changed = changed.Event,
        SetValue = function(nextValue)
            setValue(nextValue, false)
        end,
        GetValue = function()
            return value
        end
    }
end

local function applyThumbnail(target, item)
    if item and item.thumbnail_url and tostring(item.thumbnail_url) ~= "" then
        target.Image = tostring(item.thumbnail_url)
        target.ImageTransparency = 0
        return
    end

    target.Image = ""
    target.ImageTransparency = 1
end

local function createArtFrame(parent, name, size, position, item)
    local holder = Instance.new("Frame")
    holder.Name = name
    holder.Size = size
    holder.Position = position or UDim2.new()
    holder.BackgroundColor3 = Color3.fromRGB(35, 20, 55)
    holder.BorderSizePixel = 0
    holder.ClipsDescendants = true
    holder.Parent = parent
    createCorner(holder, 8)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 38, 175)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(22, 31, 58)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 13, 20))
    })
    gradient.Rotation = 25
    gradient.Parent = holder

    local image = Instance.new("ImageLabel")
    image.Name = "Image"
    image.Size = UDim2.new(1, 0, 1, 0)
    image.BackgroundTransparency = 1
    image.ScaleType = Enum.ScaleType.Crop
    image.Parent = holder
    createCorner(image, 8)
    applyThumbnail(image, item)

    if item and item.thumbnail_debug_text then
        local debugLabel = createLabel(
            holder,
            "ThumbnailDebug",
            tostring(item.thumbnail_debug_text),
            UDim2.new(1, -16, 0, 32),
            UDim2.new(0, 8, 0.5, -16),
            9,
            Enum.Font.GothamBold,
            COLORS.Muted
        )
        debugLabel.TextXAlignment = Enum.TextXAlignment.Center
        debugLabel.TextYAlignment = Enum.TextYAlignment.Center
        debugLabel.TextWrapped = true
    end

    return holder, image
end

local function createSection(parent, name, title, position, size)
    local section = Instance.new("Frame")
    section.Name = name
    section.Size = size
    section.Position = position
    section.BackgroundTransparency = 1
    section.BorderSizePixel = 0
    section.Parent = parent

    local titleLabel = createLabel(
        section,
        "Title",
        title,
        UDim2.new(1, -24, 0, 24),
        UDim2.new(0, 4, 0, 0),
        13,
        SECTION_TITLE_FONT,
        COLORS.Text
    )
    titleLabel.TextColor3 = Color3.fromRGB(232, 236, 246)

    local prevButton = createIconButton(section, "PrevButton", "<", UDim2.new(0, 30, 0, 28), UDim2.new(1, -70, 0, -2))
    prevButton.BackgroundTransparency = 0.42
    prevButton.TextSize = 13
    prevButton.Visible = false

    local nextButton = createIconButton(section, "NextButton", ">", UDim2.new(0, 30, 0, 28), UDim2.new(1, -34, 0, -2))
    nextButton.BackgroundTransparency = 0.42
    nextButton.TextSize = 13
    nextButton.Visible = false

    local list = Instance.new("ScrollingFrame")
    list.Name = "List"
    list.Size = UDim2.new(1, 0, 1, -34)
    list.Position = UDim2.new(0, 0, 0, 34)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ScrollBarThickness = 0
    list.ScrollingDirection = Enum.ScrollingDirection.X
    list.ScrollingEnabled = true
    list.Active = true
    list.Parent = section

    return section, list, titleLabel, prevButton, nextButton
end

local function createCard(parent, item, width, height, onPlay, onDownload)
    local card = Instance.new("Frame")
    card.Name = "MusicCard"
    card.Size = UDim2.new(0, width, 0, height)
    card.BackgroundColor3 = COLORS.PanelSoft
    card.BackgroundTransparency = 0.04
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Parent = parent
    createCorner(card, 8)
    createStroke(card, COLORS.Border, 0.55, 1)

    createArtFrame(card, "Art", UDim2.new(1, 0, 0, math.max(height - 60, 82)), UDim2.new(), item)

    local play = createIconButton(
        card,
        "PlayButton",
        "▶",
        UDim2.new(0, 28, 0, 28),
        UDim2.new(1, -36, 0, math.max(height - 88, 62))
    )
    play.BackgroundColor3 = Color3.fromRGB(235, 238, 246)
    play.TextColor3 = Color3.fromRGB(15, 16, 22)
    play.TextSize = 18
    local playCorner = play:FindFirstChildOfClass("UICorner")
    if playCorner then
        playCorner.CornerRadius = UDim.new(1, 0)
    end

    createLabel(
        card,
        "Name",
        tostring(item and item.title or tr("Sin titulo")),
        UDim2.new(1, -18, 0, 20),
        UDim2.new(0, 10, 1, -56),
        11,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        card,
        "Artist",
        tostring(item and item.artist or tr("Desconocido")),
        UDim2.new(1, -18, 0, 18),
        UDim2.new(0, 10, 1, -36),
        10,
        Enum.Font.Gotham,
        COLORS.Muted
    )

    createProgress(card, UDim2.new(0, 10, 1, -14), UDim2.new(1, -20, 0, 3), 0.18)

    if item and item.downloadable and onDownload and not item.local_playback_supported then
        play.Visible = false

        local mp3Button = createIconButton(
            card,
            "DownloadMp3Button",
            "MP3",
            UDim2.new(0, 34, 0, 22),
            UDim2.new(1, -78, 0, math.max(height - 88, 62))
        )
        mp3Button.TextSize = 9
        mp3Button.BackgroundColor3 = COLORS.Purple
        mp3Button.BackgroundTransparency = 0.08

        local mp4Button = createIconButton(
            card,
            "DownloadMp4Button",
            "MP4",
            UDim2.new(0, 34, 0, 22),
            UDim2.new(1, -40, 0, math.max(height - 88, 62))
        )
        mp4Button.TextSize = 9
        mp4Button.BackgroundColor3 = COLORS.PanelLight
        mp4Button.BackgroundTransparency = 0.08

        mp3Button.MouseButton1Click:Connect(function()
            print("StrikeMusic: MP3 pressed", tostring(item and item.source_id or "unknown"))
            onDownload(item, "mp3")
        end)
        mp4Button.MouseButton1Click:Connect(function()
            print("StrikeMusic: MP4 pressed", tostring(item and item.source_id or "unknown"))
            onDownload(item, "mp4")
        end)
    elseif item and item.playable == false then
        play.Visible = false
    elseif onPlay then
        play.MouseButton1Click:Connect(function()
            onPlay(item)
        end)
    end

    return card, play
end

local function cleanDownloadTitle(title, artist)
    local text = tostring(title or "")
    local artistText = tostring(artist or "")

    local function cleanExtraInfo(value)
        value = tostring(value or "")
        value = value:gsub("%b()", "")

        return value:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    end

    if text == "" then
        return tr("Sin titulo")
    end

    for _, separator in ipairs({" - ", " – ", " — "}) do
        local startIndex = text:find(separator, 1, true)

        if startIndex then
            local candidate = cleanExtraInfo(text:sub(startIndex + #separator))

            if candidate ~= "" then
                return candidate
            end
        end
    end

    if artistText ~= "" then
        local escapedArtist = artistText:gsub("([^%w])", "%%%1")
        text = text:gsub("^%s*" .. escapedArtist .. "%s*", "")
        text = text:gsub("^[-–—|:/,%s]+", "")
    end

    text = cleanExtraInfo(text)

    if text == "" then
        return tostring(title or tr("Sin titulo"))
    end

    return text
end
local function createWideRow(parent, item)
    local row = Instance.new("Frame")
    row.Name = "MusicRow"
    row.Size = UDim2.new(1, 0, 0, 48)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.ClipsDescendants = false
    row.Parent = parent

    local rowBackground = Instance.new("Frame")
    rowBackground.Name = "RowBackground"
    rowBackground.Size = UDim2.new(1, 0, 1, 0)
    rowBackground.Position = UDim2.new(0, 0, 0, 0)
    rowBackground.BackgroundColor3 = item and item.is_playing
        and Color3.fromRGB(50, 55, 64)
        or COLORS.PanelSoft
    rowBackground.BackgroundTransparency = item and item.is_playing and 0.18 or 0.78
    rowBackground.BorderSizePixel = 0
    rowBackground.ZIndex = 0
    rowBackground.Parent = row
    createCorner(rowBackground, 6)

    createArtFrame(row, "Art", UDim2.new(0, 38, 0, 38), UDim2.new(0, 8, 0.5, -19), item)

    createLabel(
        row,
        "Name",
        tostring(item and item.title or tr("Sin titulo")),
        UDim2.new(1, -246, 0, 20),
        UDim2.new(0, 60, 0, 4),
        12,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        row,
        "Artist",
        tostring(item and item.artist or tr("Desconocido")),
        UDim2.new(1, -246, 0, 18),
        UDim2.new(0, 60, 0, 25),
        11,
        Enum.Font.Gotham,
        COLORS.Muted
    )

    createLabel(
        row,
        "Duration",
        tostring(item and item.duration_text or "--:--"),
        UDim2.new(0, 190, 1, 0),
        UDim2.new(1, -228, 0, 0),
        11,
        Enum.Font.Gotham,
        COLORS.Muted
    ).TextXAlignment = Enum.TextXAlignment.Right

    local more = createIconButton(row, "MoreButton", "...", UDim2.new(0, 28, 0, 28), UDim2.new(1, -32, 0.5, -14))
    more.BackgroundTransparency = 1
    more.TextColor3 = COLORS.Muted

    return row, more
end

local function createDownloadPlayButton(parent)
    local button = createIconButton(
        parent,
        "DownloadPlayButton",
        "▶",
        UDim2.new(0, 24, 0, 24),
        UDim2.new(1, -72, 0.5, -12)
    )
    button.BackgroundColor3 = COLORS.Purple
    button.BackgroundTransparency = 0
    button.TextColor3 = COLORS.Text
    button.TextSize = 14
    button.ZIndex = 5

    local corner = button:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(1, 0)
    end

    return button
end

local function createFavoriteHeartButton(parent)
    local button = createIconButton(
        parent,
        "FavoriteRowButton",
        "♥",
        UDim2.new(0, 24, 0, 24),
        UDim2.new(1, -72, 0.5, -12)
    )
    button.BackgroundColor3 = COLORS.Green
    button.BackgroundTransparency = 0
    button.TextColor3 = COLORS.Text
    button.TextSize = 14
    button.ZIndex = 7

    local corner = button:FindFirstChildOfClass("UICorner")
    if corner then
        corner.CornerRadius = UDim.new(1, 0)
    end

    return button
end

function StrikeMusicUI.Create(parent, Theme)
    local theme = Theme or {
        Font = {
            Regular = Enum.Font.Gotham,
            Bold = Enum.Font.GothamBold
        }
    }

    local gui = Instance.new("ScreenGui")
    gui.Name = "StrikeMusicGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 1
    pcall(function()
        gui.ScreenInsets = Enum.ScreenInsets.None
    end)
    gui.Parent = parent

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(1, 0, 1, 0)
    root.BackgroundColor3 = COLORS.Background
    root.BorderSizePixel = 0
    root.Active = true
    root.Parent = gui

    local inputBlocker = Instance.new("TextButton")
    inputBlocker.Name = "InputBlocker"
    inputBlocker.Size = UDim2.new(1, 0, 1, 0)
    inputBlocker.BackgroundTransparency = 1
    inputBlocker.BorderSizePixel = 0
    inputBlocker.Text = ""
    inputBlocker.Active = true
    inputBlocker.AutoButtonColor = false
    inputBlocker.ZIndex = 0
    inputBlocker.Parent = root

    local downloadOptionsMenu = createPanel(
        root,
        "DownloadOptionsMenu",
        UDim2.new(0, 220, 0, 170),
        UDim2.new(0, 0, 0, 0)
    )
    downloadOptionsMenu.Visible = false
    downloadOptionsMenu.ZIndex = 40
    downloadOptionsMenu.BackgroundTransparency = 0.02

    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.Padding = UDim.new(0, 3)
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = downloadOptionsMenu

    local optionsPadding = Instance.new("UIPadding")
    optionsPadding.PaddingTop = UDim.new(0, 8)
    optionsPadding.PaddingBottom = UDim.new(0, 8)
    optionsPadding.PaddingLeft = UDim.new(0, 16)
    optionsPadding.PaddingRight = UDim.new(0, 12)
    optionsPadding.Parent = downloadOptionsMenu

    local function createOptionButton(name, text, color)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, 0, 0, 36)
        button.BackgroundColor3 = COLORS.Panel
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.Text = tr(text)
        button.TextColor3 = color or COLORS.Text
        button.Font = Enum.Font.GothamMedium
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.AutoButtonColor = false
        button.ZIndex = 41
        button.Parent = downloadOptionsMenu
        local function setOptionHover(active)
            button.BackgroundTransparency = active and 0.12 or 1
            button.TextColor3 = active
                and (color or Color3.fromRGB(224, 228, 240))
                or (color or COLORS.Text)
        end

        button.MouseEnter:Connect(function()
            setOptionHover(true)
        end)
        button.MouseLeave:Connect(function()
            setOptionHover(false)
        end)
        button.MouseButton1Down:Connect(function()
            setOptionHover(true)
        end)
        button.MouseButton1Up:Connect(function()
            setOptionHover(false)
        end)
        return button
    end

    local selectedDownloadJob = nil
    local selectedDeleteHandler = nil
    local selectedFavoriteHandler = nil
    local selectedQueueHandler = nil
    local selectedAddPlaylistHandler = nil
    local selectedRemovePlaylistHandler = nil
    local addPlaylistButton = createOptionButton("AddPlaylistButton", "Agregar a playlist")
    local addQueueButton = createOptionButton("AddQueueButton", "Agregar a la fila")
    local favoriteButton = createOptionButton("FavoriteButton", "Guardar en tus canciones favoritas")
    local removePlaylistButton = createOptionButton("RemovePlaylistButton", "Eliminar de Playlist", Color3.fromRGB(224, 92, 92))
    local deleteFileButton = createOptionButton("DeleteFileButton", "Eliminar archivo", Color3.fromRGB(224, 92, 92))

    local deleteConfirmModal = createPanel(
        root,
        "DeleteConfirmModal",
        UDim2.new(0, 300, 0, 156),
        UDim2.new(0.5, -150, 0.5, -78)
    )
    deleteConfirmModal.Visible = false
    deleteConfirmModal.ZIndex = 60
    deleteConfirmModal.BackgroundTransparency = 0.02

    local deleteTitle = createLabel(
        deleteConfirmModal,
        "Title",
        tr("Estas seguro de eliminar este archivo?"),
        UDim2.new(1, -28, 0, 28),
        UDim2.new(0, 14, 0, 14),
        13,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    local deleteSongName = createLabel(
        deleteConfirmModal,
        "SongName",
        "",
        UDim2.new(1, -28, 0, 40),
        UDim2.new(0, 14, 0, 48),
        12,
        Enum.Font.Gotham,
        COLORS.Muted
    )
    deleteSongName.TextWrapped = true
    deleteSongName.TextYAlignment = Enum.TextYAlignment.Top
    deleteTitle.ZIndex = 61
    deleteSongName.ZIndex = 61

    local confirmDeleteButton = createIconButton(
        deleteConfirmModal,
        "ConfirmDeleteButton",
        tr("Eliminar"),
        UDim2.new(0, 118, 0, 34),
        UDim2.new(1, -266, 1, -48)
    )
    confirmDeleteButton.BackgroundColor3 = Color3.fromRGB(155, 46, 56)
    confirmDeleteButton.TextSize = 12
    confirmDeleteButton.ZIndex = 61

    local cancelDeleteButton = createIconButton(
        deleteConfirmModal,
        "CancelDeleteButton",
        tr("Cancelar"),
        UDim2.new(0, 118, 0, 34),
        UDim2.new(1, -136, 1, -48)
    )
    cancelDeleteButton.BackgroundTransparency = 0.35
    cancelDeleteButton.TextSize = 12
    cancelDeleteButton.ZIndex = 61

    local function hideDeleteConfirm()
        deleteConfirmModal.Visible = false
    end

    local function hideDownloadOptions()
        downloadOptionsMenu.Visible = false
        hideDeleteConfirm()
    end

    local function showDownloadOptions(anchor, mode)
        hideDeleteConfirm()

        mode = mode or "downloads"
        favoriteButton.Text = mode == "favorites"
            and tr("Eliminar de favoritos")
            or tr("Guardar en tus canciones favoritas")
        removePlaylistButton.Visible = mode == "playlist"
        deleteFileButton.Visible = mode == "downloads"

        local rootPosition = root.AbsolutePosition
        local rootSize = root.AbsoluteSize
        local menuSize = downloadOptionsMenu.AbsoluteSize
        local anchorPosition = anchor.AbsolutePosition
        local anchorSize = anchor.AbsoluteSize
        local x = anchorPosition.X - rootPosition.X + anchorSize.X + 8
        local y = anchorPosition.Y - rootPosition.Y - 8

        if x + menuSize.X > rootSize.X - 8 then
            x = anchorPosition.X - rootPosition.X - menuSize.X - 8
        end

        x = math.clamp(x, 8, math.max(rootSize.X - menuSize.X - 8, 8))
        y = math.clamp(y, 8, math.max(rootSize.Y - menuSize.Y - 8, 8))

        downloadOptionsMenu.Position = UDim2.new(0, x, 0, y)
        downloadOptionsMenu.Visible = true
    end

    local function showDeleteConfirm()
        if not selectedDownloadJob then
            return
        end

        deleteSongName.Text = tostring(selectedDownloadJob.title or tr("Sin titulo"))
        deleteConfirmModal.AnchorPoint = Vector2.new(0.5, 0.5)
        deleteConfirmModal.Position = UDim2.new(0.5, 0, 0.5, 0)
        deleteConfirmModal.Visible = true
    end

    addPlaylistButton.MouseButton1Click:Connect(function()
        local job = selectedDownloadJob
        local handler = selectedAddPlaylistHandler
        hideDownloadOptions()

        if handler and job then
            handler(job)
        end
    end)

    favoriteButton.MouseButton1Click:Connect(function()
        local job = selectedDownloadJob
        local handler = selectedFavoriteHandler
        hideDownloadOptions()

        if handler and job then
            handler(job)
        end
    end)

    removePlaylistButton.MouseButton1Click:Connect(function()
        local job = selectedDownloadJob
        local handler = selectedRemovePlaylistHandler
        hideDownloadOptions()

        if handler and job then
            handler(job)
        end
    end)

    addQueueButton.MouseButton1Click:Connect(function()
        local job = selectedDownloadJob
        local handler = selectedQueueHandler
        hideDownloadOptions()

        if handler and job then
            handler(job)
        end
    end)

    deleteFileButton.MouseButton1Click:Connect(showDeleteConfirm)

    cancelDeleteButton.MouseButton1Click:Connect(function()
        hideDownloadOptions()
    end)

    confirmDeleteButton.MouseButton1Click:Connect(function()
        local job = selectedDownloadJob
        local handler = selectedDeleteHandler
        hideDownloadOptions()

        if handler and job then
            handler(job)
        end
    end)



    local createPlaylistHandler = nil
    local createPlaylistModal = createPanel(
        root,
        "CreatePlaylistModal",
        UDim2.new(0, 330, 0, 170),
        UDim2.new(0.5, -165, 0.5, -85)
    )
    createPlaylistModal.Visible = false
    createPlaylistModal.ZIndex = 60
    createPlaylistModal.BackgroundTransparency = 0.02

    local createPlaylistTitle = createLabel(
        createPlaylistModal,
        "Title",
        tr("Nueva lista"),
        UDim2.new(1, -28, 0, 28),
        UDim2.new(0, 14, 0, 14),
        14,
        Enum.Font.GothamBold,
        COLORS.Text
    )
    createPlaylistTitle.ZIndex = 61

    local playlistNameInput = Instance.new("TextBox")
    playlistNameInput.Name = "PlaylistNameInput"
    playlistNameInput.Size = UDim2.new(1, -28, 0, 38)
    playlistNameInput.Position = UDim2.new(0, 14, 0, 56)
    playlistNameInput.BackgroundColor3 = COLORS.PanelLight
    playlistNameInput.BackgroundTransparency = 0.05
    playlistNameInput.BorderSizePixel = 0
    playlistNameInput.Text = ""
    playlistNameInput.PlaceholderText = tr("Nombre de la lista")
    playlistNameInput.TextColor3 = COLORS.Text
    playlistNameInput.PlaceholderColor3 = COLORS.Muted
    playlistNameInput.Font = Enum.Font.Gotham
    playlistNameInput.TextSize = 13
    playlistNameInput.TextXAlignment = Enum.TextXAlignment.Left
    playlistNameInput.ClearTextOnFocus = false
    playlistNameInput.ZIndex = 61
    playlistNameInput.Parent = createPlaylistModal
    createCorner(playlistNameInput, 8)

    local acceptPlaylistButton = createIconButton(
        createPlaylistModal,
        "AcceptPlaylistButton",
        tr("Aceptar"),
        UDim2.new(0, 126, 0, 34),
        UDim2.new(1, -282, 1, -48)
    )
    acceptPlaylistButton.BackgroundColor3 = COLORS.Purple
    acceptPlaylistButton.TextSize = 12
    acceptPlaylistButton.ZIndex = 61

    local cancelPlaylistButton = createIconButton(
        createPlaylistModal,
        "CancelPlaylistButton",
        tr("Cancelar"),
        UDim2.new(0, 126, 0, 34),
        UDim2.new(1, -142, 1, -48)
    )
    cancelPlaylistButton.BackgroundTransparency = 0.35
    cancelPlaylistButton.TextSize = 12
    cancelPlaylistButton.ZIndex = 61

    local playlistPickerHandler = nil
    local playlistPickerModal = createPanel(
        root,
        "PlaylistPickerModal",
        UDim2.new(0, 300, 0, 240),
        UDim2.new(0.5, -150, 0.5, -120)
    )
    playlistPickerModal.Visible = false
    playlistPickerModal.ZIndex = 60
    playlistPickerModal.BackgroundTransparency = 0.02

    local playlistPickerTitle = createLabel(
        playlistPickerModal,
        "Title",
        tr("Agregar a playlist"),
        UDim2.new(1, -28, 0, 28),
        UDim2.new(0, 14, 0, 14),
        14,
        Enum.Font.GothamBold,
        COLORS.Text
    )
    playlistPickerTitle.ZIndex = 61

    local playlistPickerList = Instance.new("Frame")
    playlistPickerList.Name = "List"
    playlistPickerList.Size = UDim2.new(1, -28, 0, 136)
    playlistPickerList.Position = UDim2.new(0, 14, 0, 50)
    playlistPickerList.BackgroundTransparency = 1
    playlistPickerList.ZIndex = 61
    playlistPickerList.Parent = playlistPickerModal

    local pickerLayout = Instance.new("UIListLayout")
    pickerLayout.FillDirection = Enum.FillDirection.Vertical
    pickerLayout.Padding = UDim.new(0, 4)
    pickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pickerLayout.Parent = playlistPickerList

    local cancelPickerButton = createIconButton(
        playlistPickerModal,
        "CancelPickerButton",
        tr("Cancelar"),
        UDim2.new(0, 126, 0, 34),
        UDim2.new(1, -142, 1, -46)
    )
    cancelPickerButton.BackgroundTransparency = 0.35
    cancelPickerButton.TextSize = 12
    cancelPickerButton.ZIndex = 61

    local deletePlaylistHandler = nil
    local deletePlaylistModal = createPanel(
        root,
        "DeletePlaylistModal",
        UDim2.new(0, 330, 0, 164),
        UDim2.new(0.5, -165, 0.5, -82)
    )
    deletePlaylistModal.Visible = false
    deletePlaylistModal.ZIndex = 60
    deletePlaylistModal.BackgroundTransparency = 0.02

    local deletePlaylistTitle = createLabel(
        deletePlaylistModal,
        "Title",
        tr("Estas seguro de eliminar esta playlist?"),
        UDim2.new(1, -28, 0, 28),
        UDim2.new(0, 14, 0, 14),
        13,
        Enum.Font.GothamBold,
        COLORS.Text
    )
    deletePlaylistTitle.ZIndex = 61

    local deletePlaylistName = createLabel(
        deletePlaylistModal,
        "PlaylistName",
        "",
        UDim2.new(1, -28, 0, 38),
        UDim2.new(0, 14, 0, 50),
        12,
        Enum.Font.Gotham,
        COLORS.Muted
    )
    deletePlaylistName.TextWrapped = true
    deletePlaylistName.ZIndex = 61

    local confirmDeletePlaylistButton = createIconButton(
        deletePlaylistModal,
        "ConfirmDeletePlaylistButton",
        tr("Eliminar"),
        UDim2.new(0, 126, 0, 34),
        UDim2.new(1, -282, 1, -48)
    )
    confirmDeletePlaylistButton.BackgroundColor3 = Color3.fromRGB(155, 46, 56)
    confirmDeletePlaylistButton.TextSize = 12
    confirmDeletePlaylistButton.ZIndex = 61

    local cancelDeletePlaylistButton = createIconButton(
        deletePlaylistModal,
        "CancelDeletePlaylistButton",
        tr("Cancelar"),
        UDim2.new(0, 126, 0, 34),
        UDim2.new(1, -142, 1, -48)
    )
    cancelDeletePlaylistButton.BackgroundTransparency = 0.35
    cancelDeletePlaylistButton.TextSize = 12
    cancelDeletePlaylistButton.ZIndex = 61

    local function hideCreatePlaylistModal()
        createPlaylistModal.Visible = false
    end

    local function hidePlaylistPicker()
        playlistPickerModal.Visible = false
    end

    local function hideDeletePlaylistModal()
        deletePlaylistModal.Visible = false
    end

    cancelPlaylistButton.MouseButton1Click:Connect(hideCreatePlaylistModal)
    cancelPickerButton.MouseButton1Click:Connect(hidePlaylistPicker)
    cancelDeletePlaylistButton.MouseButton1Click:Connect(hideDeletePlaylistModal)

    acceptPlaylistButton.MouseButton1Click:Connect(function()
        local name = playlistNameInput.Text or ""
        hideCreatePlaylistModal()

        if createPlaylistHandler then
            createPlaylistHandler(name)
        end
    end)

    confirmDeletePlaylistButton.MouseButton1Click:Connect(function()
        hideDeletePlaylistModal()

        if deletePlaylistHandler then
            deletePlaylistHandler()
        end
    end)

    inputBlocker.MouseButton1Click:Connect(hideDownloadOptions)

    local backgroundGradient = Instance.new("UIGradient")
    backgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 10, 15)),
        ColorSequenceKeypoint.new(0.58, Color3.fromRGB(13, 18, 27)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 12))
    })
    backgroundGradient.Rotation = 20
    backgroundGradient.Parent = root

    local closeButton = createIconButton(root, "CloseButton", "x", UDim2.new(0, 28, 0, 28), UDim2.new(1, -34, 0, 18))
    closeButton.BackgroundTransparency = 0.35
    closeButton.TextColor3 = Color3.fromRGB(255, 223, 187)

    local minimizeButton = createIconButton(root, "MinimizeButton", "-", UDim2.new(0, 28, 0, 28), UDim2.new(1, -70, 0, 18))
    minimizeButton.BackgroundTransparency = 0.35
    minimizeButton.TextColor3 = Color3.fromRGB(255, 223, 187)

    local minimizedButton = createIconButton(gui, "MinimizedButton", "SM", UDim2.new(0, 46, 0, 46), UDim2.new(0, 18, 1, -64))
    minimizedButton.Visible = false
    minimizedButton.TextSize = 15
    minimizedButton.BackgroundColor3 = COLORS.PanelLight
    minimizedButton.BackgroundTransparency = 0.02
    minimizedButton.ZIndex = 20
    makeFloatingButtonDraggable(minimizedButton)

    local sideBar = createPanel(root, "Sidebar", UDim2.new(0, 242, 1, -160), UDim2.new(0, 10, 0, 72))
    sideBar.BackgroundTransparency = 0.14

    local sideBarScroll = Instance.new("ScrollingFrame")
    sideBarScroll.Name = "ContentScroll"
    sideBarScroll.Size = UDim2.new(1, 0, 1, 0)
    sideBarScroll.BackgroundTransparency = 1
    sideBarScroll.BorderSizePixel = 0
    sideBarScroll.CanvasSize = UDim2.new(0, 0, 0, 620)
    sideBarScroll.ScrollBarThickness = 3
    sideBarScroll.ScrollBarImageColor3 = COLORS.Purple
    sideBarScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    sideBarScroll.Active = true
    sideBarScroll.Parent = sideBar

    local logoMark = createLabel(
        root,
        "LogoMark",
        "",
        UDim2.new(0, 34, 0, 34),
        UDim2.new(0, 32, 0, 58),
        31,
        Enum.Font.GothamBlack,
        Color3.fromRGB(170, 75, 255)
    )
    logoMark.TextXAlignment = Enum.TextXAlignment.Center
    logoMark.Visible = false

    local logoTitle = createLabel(
        root,
        "LogoTitle",
        "StrikeMusic",
        UDim2.new(0, 170, 0, 26),
        UDim2.new(1, -220, 0, 22),
        23,
        Enum.Font.GothamBold,
        COLORS.Text
    )

    createLabel(
        root,
        "LogoSubtitle",
        "PERSONAL",
        UDim2.new(0, 110, 0, 14),
        UDim2.new(1, -218, 0, 50),
        10,
        Enum.Font.GothamBold,
        COLORS.PurpleBright
    )

    local searchHolder = createPanel(root, "SearchHolder", UDim2.new(0.4, 0, 0, 46), UDim2.new(0.3, -3, 0, 16))
    searchHolder.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    searchHolder.BackgroundTransparency = 0
    local searchLens = Instance.new("Frame")
    searchLens.Name = "SearchLens"
    searchLens.Size = UDim2.new(0, 12, 0, 12)
    searchLens.Position = UDim2.new(0, 18, 0, 15)
    searchLens.BackgroundTransparency = 1
    searchLens.BorderSizePixel = 0
    searchLens.Parent = searchHolder
    createCorner(searchLens, 12)

    local searchLensStroke = Instance.new("UIStroke")
    searchLensStroke.Thickness = 1.5
    searchLensStroke.Color = COLORS.Muted
    searchLensStroke.Parent = searchLens

    local searchHandle = Instance.new("Frame")
    searchHandle.Name = "SearchHandle"
    searchHandle.Size = UDim2.new(0, 2, 0, 7)
    searchHandle.Position = UDim2.new(0, 30, 0, 26)
    searchHandle.Rotation = -45
    searchHandle.BackgroundColor3 = COLORS.Muted
    searchHandle.BorderSizePixel = 0
    searchHandle.Parent = searchHolder
    createCorner(searchHandle, 2)

    local searchInput = Instance.new("TextBox")
    searchInput.Name = "SearchInput"
    searchInput.Size = UDim2.new(1, -64, 1, 0)
    searchInput.Position = UDim2.new(0, 48, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.PlaceholderText = tr("Busca musica o pega link para ver resultados")
    searchInput.Text = ""
    searchInput.TextColor3 = COLORS.Text
    searchInput.PlaceholderColor3 = COLORS.Muted
    searchInput.Font = theme.Font.Regular or Enum.Font.Gotham
    searchInput.TextSize = 13
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.ClearTextOnFocus = false
    searchInput.Parent = searchHolder


    local navItems = {
        {"Home", tr("Inicio")},
        {"Search", tr("Buscar")},
        {"YourLibrary", tr("Tu biblioteca")},
        {"Downloads", tr("Descargas")},
        {"Playlists", tr("Listas")},
        {"LikedSongs", tr("Canciones favoritas")},
        {"RecentlyPlayed", tr("Reproducido recientemente")}
    }

    local navButtons = {}
    local navIcons = {"H", "S", "L", "D", "P", "♥", "R"}
    local navY = 8

    for index, item in ipairs(navItems) do
        local button = Instance.new("TextButton")
        button.Name = item[1] .. "Button"
        button.Size = UDim2.new(1, -30, 0, 42)
        button.Position = UDim2.new(0, 15, 0, navY)
        button.BackgroundColor3 = index == 1 and COLORS.Purple or COLORS.Panel
        button.BackgroundTransparency = index == 1 and 0.15 or 1
        button.BorderSizePixel = 0
        button.Text = ""
        button.TextColor3 = COLORS.Text
        button.Font = theme.Font.Bold or Enum.Font.GothamBold
        button.TextSize = 13
        button.TextXAlignment = Enum.TextXAlignment.Left
        button.Parent = sideBarScroll
        createCorner(button, 9)

        local icon = createLabel(button, "Icon", navIcons[index] or "", UDim2.new(0, 32, 1, 0), UDim2.new(0, 14, 0, 0), 15, Enum.Font.GothamBold, COLORS.Text)
        icon.TextXAlignment = Enum.TextXAlignment.Center

        local text = createLabel(button, "Label", item[2], UDim2.new(1, -62, 1, 0), UDim2.new(0, 62, 0, 0), 13, theme.Font.Bold or Enum.Font.GothamBold, COLORS.Text)
        text.TextXAlignment = Enum.TextXAlignment.Left

        navButtons[item[1]] = button
        navY += 49
    end

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -42, 0, 1)
    divider.Position = UDim2.new(0, 21, 0, navY + 3)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.55
    divider.BorderSizePixel = 0
    divider.Parent = sideBarScroll

    createLabel(sideBarScroll, "PlaylistLabel", tr("LISTAS"), UDim2.new(1, -42, 0, 18), UDim2.new(0, 28, 0, navY + 22), 10, Enum.Font.GothamBold, COLORS.Muted)

    local playlistNames = {
        tr("Mis favoritos"),
        tr("Nueva lista")
    }

    local playlistY = navY + 58

    for index, name in ipairs(playlistNames) do
        local rowButton = Instance.new("TextButton")
        rowButton.Name = index == 1 and "FavoritesRowButton" or "NewPlaylistButton"
        rowButton.Size = UDim2.new(1, -42, 0, 32)
        rowButton.Position = UDim2.new(0, 21, 0, playlistY - 2)
        rowButton.BackgroundTransparency = 1
        rowButton.BorderSizePixel = 0
        rowButton.Text = ""
        rowButton.AutoButtonColor = false
        rowButton.Parent = sideBarScroll

        createLabel(rowButton, "Label", name, UDim2.new(1, -48, 1, 0), UDim2.new(0, 33, 0, 0), 13, Enum.Font.Gotham, COLORS.Text)

        if index == 1 then
            local favoriteButton = createIconButton(rowButton, "FavoritesButton", "<3", UDim2.new(0, 30, 0, 28), UDim2.new(0, 0, 0.5, -14))
            favoriteButton.BackgroundTransparency = 1
            favoriteButton.TextColor3 = COLORS.PurpleBright
            favoriteButton.TextSize = 15
            navButtons.MyFavorites = rowButton
        else
            createLabel(rowButton, "PlaylistIcon" .. tostring(index), "+", UDim2.new(0, 30, 0, 28), UDim2.new(0, 0, 0.5, -14), 14, Enum.Font.GothamBold, COLORS.Muted).TextXAlignment = Enum.TextXAlignment.Center
            navButtons.NewPlaylist = rowButton
        end

        playlistY += 44
    end

    local playlistEntries = Instance.new("Frame")
    playlistEntries.Name = "PlaylistEntries"
    playlistEntries.Size = UDim2.new(1, -42, 0, 0)
    playlistEntries.Position = UDim2.new(0, 21, 0, playlistY - 4)
    playlistEntries.BackgroundTransparency = 1
    playlistEntries.Parent = sideBarScroll

    local centerPanel = createPanel(root, "CenterPanel", UDim2.new(1, -526, 1, -160), UDim2.new(0, 260, 0, 72))
    centerPanel.BackgroundTransparency = 0.19

    local centerScroll = Instance.new("ScrollingFrame")
    centerScroll.Name = "ContentScroll"
    centerScroll.Size = UDim2.new(1, 0, 1, 0)
    centerScroll.BackgroundTransparency = 1
    centerScroll.BorderSizePixel = 0
    centerScroll.CanvasSize = UDim2.new(0, 0, 0, 610)
    centerScroll.ScrollBarThickness = 3
    centerScroll.ScrollBarImageColor3 = COLORS.Purple
    centerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    centerScroll.Active = true
    centerScroll.Parent = centerPanel

    local rightPanel = createPanel(root, "RightPanel", UDim2.new(0, 242, 1, -160), UDim2.new(1, -252, 0, 72))
    rightPanel.BackgroundTransparency = 0.08

    local rightScroll = Instance.new("ScrollingFrame")
    rightScroll.Name = "ContentScroll"
    rightScroll.Size = UDim2.new(1, 0, 1, 0)
    rightScroll.BackgroundTransparency = 1
    rightScroll.BorderSizePixel = 0
    rightScroll.CanvasSize = UDim2.new(0, 0, 0, 620)
    rightScroll.ScrollBarThickness = 3
    rightScroll.ScrollBarImageColor3 = COLORS.Purple
    rightScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    rightScroll.Active = true
    rightScroll.Parent = rightPanel

    local bottomPlayer = createPanel(root, "BottomPlayer", UDim2.new(1, -20, 0, 72), UDim2.new(0, 10, 1, -82))
    bottomPlayer.BackgroundTransparency = 0.02

    local searchSection, searchList, searchTitle, searchPrevButton, searchNextButton = createSection(
        centerScroll,
        "SearchResultsSection",
        tr("RESULTADOS DE BUSQUEDA :"),
        UDim2.new(0, 24, 0, 6),
        UDim2.new(1, -48, 0, 200)
    )

    local popularSection, popularList, popularTitle, popularPrevButton, popularNextButton = createSection(
        centerScroll,
        "PopularSection",
        tr("MAS ESCUCHADAS EN STRIKE MUSIC:"),
        UDim2.new(0, 24, 0, 216),
        UDim2.new(1, -48, 0, 200)
    )

    local recentPanel = createPanel(centerScroll, "RecentPanel", UDim2.new(1, -48, 0, 150), UDim2.new(0, 24, 0, 432))
    recentPanel.BackgroundTransparency = 0.62
    createLabel(recentPanel, "Title", tr("Reproducido recientemente"), UDim2.new(1, -100, 0, 30), UDim2.new(0, 0, 0, -34), 17, TITLE_FONT, COLORS.Text)

    local seeAllButton = createIconButton(recentPanel, "SeeAllButton", tr("Ver todo"), UDim2.new(0, 76, 0, 28), UDim2.new(1, -80, 0, -34))
    seeAllButton.TextSize = 11
    seeAllButton.BackgroundColor3 = COLORS.PanelLight
    seeAllButton.BackgroundTransparency = 0.28

    local recentList = Instance.new("Frame")
    recentList.Name = "List"
    recentList.Size = UDim2.new(1, -22, 1, -20)
    recentList.Position = UDim2.new(0, 11, 0, 10)
    recentList.BackgroundTransparency = 1
    recentList.Parent = recentPanel

    local recentLayout = Instance.new("UIListLayout")
    recentLayout.FillDirection = Enum.FillDirection.Vertical
    recentLayout.Padding = UDim.new(0, 2)
    recentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    recentLayout.Parent = recentList

    local downloadsView = Instance.new("Frame")
    downloadsView.Name = "DownloadsView"
    downloadsView.Size = UDim2.new(1, -48, 0, 560)
    downloadsView.Position = UDim2.new(0, 24, 0, 6)
    downloadsView.BackgroundTransparency = 1
    downloadsView.BorderSizePixel = 0
    downloadsView.Visible = false
    downloadsView.Parent = centerScroll

    local downloadsTitle = createLabel(
        downloadsView,
        "Title",
        tr("Descargas"),
        UDim2.new(1, -150, 0, 30),
        UDim2.new(0, 0, 0, 0),
        17,
        TITLE_FONT,
        COLORS.Text
    )

    local deletePlaylistButton = createIconButton(
        downloadsView,
        "DeletePlaylistButton",
        tr("Eliminar Playlist"),
        UDim2.new(0, 132, 0, 30),
        UDim2.new(1, -132, 0, 0)
    )
    deletePlaylistButton.BackgroundColor3 = Color3.fromRGB(155, 46, 56)
    deletePlaylistButton.BackgroundTransparency = 0.18
    deletePlaylistButton.TextSize = 11
    deletePlaylistButton.Visible = false

    local downloadsList = Instance.new("Frame")
    downloadsList.Name = "List"
    downloadsList.Size = UDim2.new(1, 0, 1, -42)
    downloadsList.Position = UDim2.new(0, 0, 0, 42)
    downloadsList.BackgroundTransparency = 1
    downloadsList.BorderSizePixel = 0
    downloadsList.ClipsDescendants = false
    downloadsList.Parent = downloadsView

    local function setDownloadsListHeight(contentHeight)
        local minHeight = math.max(downloadsView.AbsoluteSize.Y - 42, 520)
        local height = math.max(math.ceil(tonumber(contentHeight) or 0), minHeight)

        downloadsList.Size = UDim2.new(1, 0, 0, height)
        downloadsView.Size = UDim2.new(1, -48, 0, height + 42)
        centerScroll.CanvasSize = UDim2.new(0, 0, 0, downloadsView.Position.Y.Offset + height + 70)
    end
    local rightTitle = createLabel(rightScroll, "Title", tr("Reproduciendo ahora"), UDim2.new(1, -32, 0, 30), UDim2.new(0, 16, 0, 4), 15, SECTION_TITLE_FONT, COLORS.Text)

    local nowArt = createArtFrame(rightScroll, "NowArt", UDim2.new(1, -32, 0, 168), UDim2.new(0, 16, 0, 36), nil)
    local nowTitle = createLabel(rightScroll, "NowTitle", "Nada reproduciendose", UDim2.new(1, -60, 0, 26), UDim2.new(0, 16, 0, 208), 17, TITLE_FONT, COLORS.Text)
    local heartButton = createIconButton(rightScroll, "HeartButton", "♥", UDim2.new(0, 38, 0, 38), UDim2.new(1, -60, 0, 312))
    heartButton.BackgroundTransparency = 0.82
    heartButton.TextColor3 = COLORS.PurpleBright
    heartButton.TextSize = 17
    heartButton.Size = UDim2.new(0, 32, 0, 32)
    heartButton.Position = UDim2.new(1, -48, 0, 204)
    local nowArtist = createLabel(rightScroll, "NowArtist", "Selecciona una cancion", UDim2.new(1, -32, 0, 20), UDim2.new(0, 16, 0, 236), 12, Enum.Font.Gotham, COLORS.Muted)

    local nowProgress, nowProgressFill, nowProgressChanged, nowProgressDragging, setNowProgress = createProgress(rightScroll, UDim2.new(0, 16, 0, 272), UDim2.new(1, -32, 0, 4), 0, true)
    local currentTime = createLabel(rightScroll, "CurrentTime", "0:00", UDim2.new(0, 50, 0, 20), UDim2.new(0, 16, 0, 280), 10, Enum.Font.Gotham, COLORS.Muted)
    local totalTime = createLabel(rightScroll, "TotalTime", "0:00", UDim2.new(0, 50, 0, 20), UDim2.new(1, -66, 0, 280), 10, Enum.Font.Gotham, COLORS.Muted)
    totalTime.TextXAlignment = Enum.TextXAlignment.Right

    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Size = UDim2.new(1, -32, 0, 52)
    controls.Position = UDim2.new(0, 16, 0, 308)
    controls.BackgroundTransparency = 1
    controls.Parent = rightScroll

    local shuffleButton = createIconButton(controls, "ShuffleButton", "x", UDim2.new(0, 30, 0, 30), UDim2.new(0, 0, 0.5, -15))
    local shuffleIcon = Instance.new("ImageLabel")
    shuffleIcon.Name = "ShuffleIcon"
    shuffleIcon.Size = UDim2.new(0, 22, 0, 22)
    shuffleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    shuffleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    shuffleIcon.BackgroundTransparency = 1
    shuffleIcon.BorderSizePixel = 0
    shuffleIcon.Image = "rbxthumb://type=Asset&id=104578917205637&w=150&h=150"
    shuffleIcon.ScaleType = Enum.ScaleType.Fit
    shuffleIcon.Active = false
    shuffleIcon.ZIndex = shuffleButton.ZIndex + 1
    shuffleIcon.Parent = shuffleButton
    shuffleButton.TextTransparency = 1
    shuffleIcon.ImageColor3 = Color3.fromRGB(245, 247, 255)


    local previousButton = createIconButton(controls, "PreviousButton", "|◀", UDim2.new(0, 34, 0, 34), UDim2.new(0.25, -17, 0.5, -17))
    local playButton = createIconButton(controls, "PlayButton", "||", UDim2.new(0, 52, 0, 52), UDim2.new(0.5, -26, 0.5, -26))
    local nextButton = createIconButton(controls, "NextButton", "▶|", UDim2.new(0, 34, 0, 34), UDim2.new(0.75, -17, 0.5, -17))
    local repeatButton = createIconButton(controls, "RepeatButton", "o", UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0.5, -15))
    local repeatIcon = Instance.new("ImageLabel")
    repeatIcon.Name = "RepeatIcon"
    repeatIcon.Size = UDim2.new(0, 24, 0, 24)
    repeatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    repeatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    repeatIcon.BackgroundTransparency = 1
    repeatIcon.BorderSizePixel = 0
    repeatIcon.Image = "rbxthumb://type=Asset&id=107048339150841&w=150&h=150"
    repeatIcon.ScaleType = Enum.ScaleType.Fit
    repeatIcon.Active = false
    repeatIcon.ZIndex = repeatButton.ZIndex + 1
    repeatIcon.Parent = repeatButton
    repeatButton.TextTransparency = 1
    repeatIcon.ImageColor3 = Color3.fromRGB(245, 247, 255)



   for _, button in ipairs({shuffleButton, previousButton, nextButton, repeatButton}) do
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.TextColor3 = COLORS.Muted
    end

    playButton.BackgroundColor3 = COLORS.Purple
    playButton.TextSize = 22
    createCorner(playButton, 26)

    local queueDivider = Instance.new("Frame")
    queueDivider.Size = UDim2.new(1, -32, 0, 1)
    queueDivider.Position = UDim2.new(0, 16, 0, 382)
    queueDivider.BackgroundColor3 = COLORS.Border
    queueDivider.BackgroundTransparency = 0.72
    queueDivider.BorderSizePixel = 0
    queueDivider.Parent = rightScroll

    createLabel(rightScroll, "UpNextTitle", tr("Siguiente"), UDim2.new(1, -100, 0, 24), UDim2.new(0, 16, 0, 394), 13, SECTION_TITLE_FONT, COLORS.Text)
    local clearQueueButton = createIconButton(rightScroll, "ClearQueueButton", tr("Limpiar"), UDim2.new(0, 50, 0, 24), UDim2.new(1, -66, 0, 393))
    clearQueueButton.TextSize = 11
    clearQueueButton.BackgroundColor3 = COLORS.PanelLight
    clearQueueButton.BackgroundTransparency = 0.2

    local queueList = Instance.new("Frame")
    queueList.Name = "QueueList"
    queueList.Size = UDim2.new(1, -32, 1, -456)
    queueList.Position = UDim2.new(0, 16, 0, 424)
    queueList.BackgroundTransparency = 1
    queueList.Parent = rightScroll

    local queueLayout = Instance.new("UIListLayout")
    queueLayout.FillDirection = Enum.FillDirection.Vertical
    queueLayout.Padding = UDim.new(0, 4)
    queueLayout.SortOrder = Enum.SortOrder.LayoutOrder
    queueLayout.Parent = queueList

    local bottomArt = createArtFrame(bottomPlayer, "Art", UDim2.new(0, 50, 0, 50), UDim2.new(0, 18, 0.5, -25), nil)
    local bottomTitle = createLabel(bottomPlayer, "Title", "Nada reproduciendose", UDim2.new(0, 280, 0, 24), UDim2.new(0, 86, 0, 13), 15, TITLE_FONT, COLORS.Text)
    local bottomArtist = createLabel(bottomPlayer, "Artist", "Selecciona una cancion", UDim2.new(0, 260, 0, 20), UDim2.new(0, 86, 0, 39), 12, Enum.Font.Gotham, COLORS.Muted)
    local bottomHeart = createIconButton(bottomPlayer, "HeartButton", "♥", UDim2.new(0, 30, 0, 30), UDim2.new(0, 230, 0, 45))
    bottomHeart.BackgroundTransparency = 0.82
    bottomHeart.TextColor3 = COLORS.PurpleBright
    bottomHeart.TextSize = 17
    bottomHeart.Size = UDim2.new(0, 26, 0, 26)
    bottomHeart.Position = UDim2.new(0, 210, 0, 35)

    local bottomControls = Instance.new("Frame")
    bottomControls.Name = "Controls"
    bottomControls.Size = UDim2.new(0, 370, 0, 38)
    bottomControls.Position = UDim2.new(0.5, -185, 0, 5)
    bottomControls.BackgroundTransparency = 1
    bottomControls.Parent = bottomPlayer

    local bottomShuffle = createIconButton(bottomControls, "ShuffleButton", "x", UDim2.new(0, 30, 0, 30), UDim2.new(0, 42, 0.5, -15))
    local bottomShuffleIcon = Instance.new("ImageLabel")
    bottomShuffleIcon.Name = "ShuffleIcon"
    bottomShuffleIcon.Size = UDim2.new(0, 22, 0, 22)
    bottomShuffleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    bottomShuffleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    bottomShuffleIcon.BackgroundTransparency = 1
    bottomShuffleIcon.BorderSizePixel = 0
    bottomShuffleIcon.Image = "rbxthumb://type=Asset&id=104578917205637&w=150&h=150"
    bottomShuffleIcon.ScaleType = Enum.ScaleType.Fit
    bottomShuffleIcon.Active = false
    bottomShuffleIcon.ZIndex = bottomShuffle.ZIndex + 1
    bottomShuffleIcon.Parent = bottomShuffle
    bottomShuffle.TextTransparency = 1
    bottomShuffleIcon.ImageColor3 = Color3.fromRGB(245, 247, 255)



    local bottomPrevious = createIconButton(bottomControls, "PreviousButton", "|◀", UDim2.new(0, 32, 0, 32), UDim2.new(0, 96, 0.5, -16))
    local bottomPlay = createIconButton(bottomControls, "PlayButton", "||", UDim2.new(0, 38, 0, 38), UDim2.new(0.5, -19, 0, 0))
    local bottomNext = createIconButton(bottomControls, "NextButton", "▶|", UDim2.new(0, 32, 0, 32), UDim2.new(1, -128, 0.5, -16))
    local bottomRepeat = createIconButton(bottomControls, "RepeatButton", "o", UDim2.new(0, 30, 0, 30), UDim2.new(1, -72, 0.5, -15))
    local bottomRepeatIcon = Instance.new("ImageLabel")
    bottomRepeatIcon.Name = "RepeatIcon"
    bottomRepeatIcon.Size = UDim2.new(0, 24, 0, 24)
    bottomRepeatIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    bottomRepeatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    bottomRepeatIcon.BackgroundTransparency = 1
    bottomRepeatIcon.BorderSizePixel = 0
    bottomRepeatIcon.Image = "rbxthumb://type=Asset&id=107048339150841&w=150&h=150"
    bottomRepeatIcon.ScaleType = Enum.ScaleType.Fit
    bottomRepeatIcon.Active = false
    bottomRepeatIcon.ZIndex = bottomRepeat.ZIndex + 1
    bottomRepeatIcon.Parent = bottomRepeat
    bottomRepeat.TextTransparency = 1
    bottomRepeatIcon.ImageColor3 = Color3.fromRGB(245, 247, 255)

    local shuffleEnabled = false
    local repeatEnabled = false

    local function setShuffleEnabled(enabled)
        shuffleEnabled = enabled

        local color = enabled
            and Color3.fromRGB(78, 190, 92)
            or Color3.fromRGB(245, 247, 255)

        shuffleIcon.ImageColor3 = color
        bottomShuffleIcon.ImageColor3 = color
    end

    local function setRepeatEnabled(enabled)
        repeatEnabled = enabled

        local color = enabled
            and Color3.fromRGB(78, 190, 92)
            or Color3.fromRGB(245, 247, 255)

        repeatIcon.ImageColor3 = color
        bottomRepeatIcon.ImageColor3 = color
    end

    shuffleButton.MouseButton1Click:Connect(function()
        setShuffleEnabled(not shuffleEnabled)
    end)

    bottomShuffle.MouseButton1Click:Connect(function()
        setShuffleEnabled(not shuffleEnabled)
    end)

    repeatButton.MouseButton1Click:Connect(function()
        setRepeatEnabled(not repeatEnabled)
    end)

    bottomRepeat.MouseButton1Click:Connect(function()
        setRepeatEnabled(not repeatEnabled)
    end)



    for _, button in ipairs({bottomShuffle, bottomPrevious, bottomNext, bottomRepeat}) do
        button.BackgroundTransparency = 1
        button.BorderSizePixel = 0
        button.TextColor3 = COLORS.Muted
    end

    bottomPlay.BackgroundColor3 = COLORS.Purple
    createCorner(bottomPlay, 19)

    local bottomProgress, bottomProgressFill, bottomProgressChanged, bottomProgressDragging, setBottomProgress = createProgress(bottomPlayer, UDim2.new(0.31, 0, 0, 54), UDim2.new(0.38, 0, 0, 4), 0, true)
    local bottomCurrent = createLabel(bottomPlayer, "CurrentTime", "0:00", UDim2.new(0, 48, 0, 20), UDim2.new(0.28, 0, 0, 46), 10, Enum.Font.Gotham, COLORS.Muted)
    local bottomTotal = createLabel(bottomPlayer, "TotalTime", "0:00", UDim2.new(0, 48, 0, 20), UDim2.new(0.69, 0, 0, 46), 10, Enum.Font.Gotham, COLORS.Muted)
    bottomTotal.TextXAlignment = Enum.TextXAlignment.Right

    local seekChanged = Instance.new("BindableEvent")

    nowProgressChanged:Connect(function(value)
        seekChanged:Fire(value)
    end)

    bottomProgressChanged:Connect(function(value)
        seekChanged:Fire(value)
    end)

    local volumeIcon = createLabel(bottomPlayer, "VolumeIcon", "V", UDim2.new(0, 26, 0, 26), UDim2.new(0.82, 0, 0.5, -13), 15, Enum.Font.GothamBold, COLORS.Muted)
    volumeIcon.TextXAlignment = Enum.TextXAlignment.Center
    local volumeSlider = createVolumeSlider(bottomPlayer, UDim2.new(0.86, 0, 0.5, -2), UDim2.new(0.1, 0, 0, 4), 0.52)

    local lists = {
        Search = searchList,
        Popular = popularList,
        Recent = recentList,
        Queue = queueList
    }

    local function attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        local UserInputService = game:GetService("UserInputService")
        local padding = 12
        local contentWidth = math.max((count * cardWidth) + (math.max(count - 1, 0) * padding), 0)

        container.CanvasPosition = Vector2.new(0, 0)
        container.CanvasSize = UDim2.new(0, contentWidth, 0, cardHeight)
        container:SetAttribute("StrikeMusicCarouselContentWidth", contentWidth)

        local function getVisibleWidth()
            return math.max(container.AbsoluteSize.X, 1)
        end

        local function refreshButtons()
            local visibleWidth = getVisibleWidth()
            local hasOverflow = visibleWidth > 1 and contentWidth > visibleWidth + 2

            if prevButton then
                prevButton.Visible = hasOverflow
            end

            if nextButton then
                nextButton.Visible = hasOverflow
            end
        end

        refreshButtons()
        task.defer(refreshButtons)

        local function move(direction)
            local visibleWidth = getVisibleWidth()
            local maxX = math.max(contentWidth - visibleWidth, 0)
            local step = math.max(cardWidth + padding, 1)
            local nextX = math.clamp(container.CanvasPosition.X + (direction * step), 0, maxX)
            container.CanvasPosition = Vector2.new(nextX, 0)
        end

        if prevButton and not prevButton:GetAttribute("StrikeMusicCarouselBound") then
            prevButton:SetAttribute("StrikeMusicCarouselBound", true)
            prevButton.MouseButton1Click:Connect(function()
                move(-1)
            end)
        end

        if nextButton and not nextButton:GetAttribute("StrikeMusicCarouselBound") then
            nextButton:SetAttribute("StrikeMusicCarouselBound", true)
            nextButton.MouseButton1Click:Connect(function()
                move(1)
            end)
        end

        if not container:GetAttribute("StrikeMusicDragBound") then
            container:SetAttribute("StrikeMusicDragBound", true)

            local dragging = false
            local dragStartX = 0
            local dragStartCanvasX = 0

            local function getMaxCanvasX()
                local latestContentWidth = tonumber(container:GetAttribute("StrikeMusicCarouselContentWidth")) or 0
                return math.max(latestContentWidth - getVisibleWidth(), 0)
            end

            container.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = true
                    dragStartX = input.Position.X
                    dragStartCanvasX = container.CanvasPosition.X
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging
                    and (
                        input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch
                    )
                then
                    local delta = input.Position.X - dragStartX
                    local nextX = math.clamp(dragStartCanvasX - delta, 0, getMaxCanvasX())
                    container.CanvasPosition = Vector2.new(nextX, 0)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch
                then
                    dragging = false
                end
            end)
        end

        return padding
    end

    local function createCardLayout(container, padding)
        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.Padding = UDim.new(0, padding)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        return layout
    end

    local function renderPlaceholderCards(container, cardWidth, cardHeight, count, prevButton, nextButton)
        count = count or 4
        local padding = attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        createCardLayout(container, padding)

        for _ = 1, count or 4 do
            createCard(
                container,
                {
                    title = tr("Nombre de musica"),
                    artist = tr("Artista")
                },
                cardWidth,
                cardHeight
            )
        end
    end

    local function renderCards(container, items, emptyText, cardWidth, cardHeight, maxItems, prevButton, nextButton, onPlay, onDownload)
        clearContainer(container)

        items = items or {}

        if #items == 0 then
            if emptyText == "__placeholder_cards" then
                renderPlaceholderCards(container, cardWidth, cardHeight, maxItems or 4, prevButton, nextButton)
            elseif emptyText and emptyText ~= "" then
                if prevButton then
                    prevButton.Visible = false
                end

                if nextButton then
                    nextButton.Visible = false
                end

                container.CanvasSize = UDim2.new(0, 0, 0, 0)
                createEmptyState(container, emptyText)
            end
            return
        end

        local count = maxItems and math.min(#items, maxItems) or #items
        local padding = attachCardCarousel(container, count, cardWidth, cardHeight, prevButton, nextButton)
        createCardLayout(container, padding)

        for index, item in ipairs(items) do
            if maxItems and index > maxItems then
                break
            end

            createCard(container, item, cardWidth, cardHeight, onPlay, onDownload)
        end
    end

    local function renderRows(container, items, emptyText, maxItems)
        clearContainer(container)

        items = items or {}

        if #items == 0 then
            if emptyText and emptyText ~= "" then
                createEmptyState(container, emptyText)
            end
            return
        end

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 2)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = container

        for index, item in ipairs(items) do
            if maxItems and index > maxItems then
                break
            end

            createWideRow(container, item)
        end
    end

    local function renderDownloads(jobs, onPlay, onDelete, onReadyDownload, onFavorite, onQueue, onAddPlaylist)
        hideDownloadOptions()
        clearContainer(downloadsList)
        jobs = jobs or {}

        if #jobs == 0 then
            createEmptyState(downloadsList, tr("No hay descargas."))
            setDownloadsListHeight(0)
            return
        end

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = downloadsList

        for _, job in ipairs(jobs) do
            local status = tostring(job.status or "pending")
            local progress = math.clamp(tonumber(job.progress) or 0, 0, 100)
            local displayStatus = job.display_status
                or job.local_playback_label
                or status .. " " .. tostring(progress) .. "%"

            local hideMobileReadyStatus = _G.StrikeChatLayoutMode == "mobile"
                and status == "completed"
                and job.local_playback_supported == true
                and job.display_status == nil

            if hideMobileReadyStatus then
                displayStatus = ""
            end

            local item = {
                title = cleanDownloadTitle(job.title, job.artist),
                artist = job.artist or status,
                duration_text = displayStatus,
                thumbnail_url = job.thumbnail_url,
                is_playing = job.is_playing == true
            }
            local row, optionsButton = createWideRow(downloadsList, item)
            row.Size = UDim2.new(1, -6, 0, 48)

            local statusLabel = row:FindFirstChild("Duration")
            if statusLabel then
                statusLabel.Size = UDim2.new(0, 140, 0, 20)
                statusLabel.Position = UDim2.new(1, -236, 0, 20)
                statusLabel.Visible = not hideMobileReadyStatus
            end

            if hideMobileReadyStatus then
                local nameLabel = row:FindFirstChild("Name")
                local artistLabel = row:FindFirstChild("Artist")

                if nameLabel then
                    nameLabel.Size = UDim2.new(1, -132, 0, 20)
                end

                if artistLabel then
                    artistLabel.Size = UDim2.new(1, -132, 0, 18)
                end
            end

            optionsButton.Position = UDim2.new(1, -34, 0.5, -14)
            optionsButton.ZIndex = 6
            optionsButton.Text = "..."
            optionsButton.TextSize = 15
            optionsButton.TextColor3 = COLORS.Muted

            local canPlay = job.local_playback_supported and onPlay
            local canSaveReadyDownload = status == "ready"
                and job.download_url
                and onReadyDownload

            if canPlay or canSaveReadyDownload then
                local rowButton = Instance.new("TextButton")
                rowButton.Name = "RowPlayButton"
                rowButton.Size = UDim2.new(1, -108, 1, 0)
                rowButton.Position = UDim2.new(0, 0, 0, 0)
                rowButton.BackgroundTransparency = 1
                rowButton.BorderSizePixel = 0
                rowButton.Text = ""
                rowButton.AutoButtonColor = false
                rowButton.Active = true
                rowButton.ZIndex = 3
                rowButton.Parent = row
                rowButton.MouseButton1Click:Connect(function()
                    hideDownloadOptions()

                    if canPlay then
                        onPlay(job)
                    else
                        onReadyDownload(job)
                    end
                end)

                local playButton = createDownloadPlayButton(row)

                if canSaveReadyDownload and not canPlay then
                    playButton.Text = "↓"
                end

                playButton.MouseButton1Click:Connect(function()
                    hideDownloadOptions()

                    if canPlay then
                        onPlay(job)
                    else
                        onReadyDownload(job)
                    end
                end)
            end

            optionsButton.MouseButton1Click:Connect(function()
                selectedDownloadJob = job
                selectedDeleteHandler = onDelete
                selectedFavoriteHandler = onFavorite
                selectedQueueHandler = onQueue
                selectedAddPlaylistHandler = onAddPlaylist
                selectedRemovePlaylistHandler = nil
                showDownloadOptions(optionsButton, "downloads")
            end)
        end

        task.defer(function()
            setDownloadsListHeight(layout.AbsoluteContentSize.Y + 8)
        end)
    end

    local function renderFavorites(items, onPlay, onRemoveFavorite, onQueue, onAddPlaylist)
        hideDownloadOptions()
        clearContainer(downloadsList)
        items = items or {}

        if #items == 0 then
            createEmptyState(downloadsList, tr("No hay canciones favoritas."))
            setDownloadsListHeight(0)
            return
        end

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = downloadsList

        for _, item in ipairs(items) do
            local media = item.media or item
            media.title = cleanDownloadTitle(media.title, media.artist)
            media.duration_text = ""
            media.is_playing = item.is_playing == true or media.is_playing == true

            local row, optionsButton = createWideRow(downloadsList, media)
            row.Size = UDim2.new(1, -6, 0, 48)

            local statusLabel = row:FindFirstChild("Duration")
            if statusLabel then
                statusLabel.Visible = false
            end

            local nameLabel = row:FindFirstChild("Name")
            local artistLabel = row:FindFirstChild("Artist")

            if nameLabel then
                nameLabel.Size = UDim2.new(1, -150, 0, 20)
            end

            if artistLabel then
                artistLabel.Size = UDim2.new(1, -150, 0, 18)
            end

            optionsButton.Position = UDim2.new(1, -34, 0.5, -14)
            optionsButton.ZIndex = 6
            optionsButton.Text = "..."
            optionsButton.TextSize = 15
            optionsButton.TextColor3 = COLORS.Muted

            local rowButton = Instance.new("TextButton")
            rowButton.Name = "RowPlayButton"
            rowButton.Size = UDim2.new(1, -108, 1, 0)
            rowButton.Position = UDim2.new(0, 0, 0, 0)
            rowButton.BackgroundTransparency = 1
            rowButton.BorderSizePixel = 0
            rowButton.Text = ""
            rowButton.AutoButtonColor = false
            rowButton.Active = true
            rowButton.ZIndex = 3
            rowButton.Parent = row
            rowButton.MouseButton1Click:Connect(function()
                hideDownloadOptions()

                if onPlay then
                    onPlay(item)
                end
            end)

            local heart = createFavoriteHeartButton(row)
            heart.MouseButton1Click:Connect(function()
                hideDownloadOptions()

                if onRemoveFavorite then
                    onRemoveFavorite(item)
                end
            end)

            optionsButton.MouseButton1Click:Connect(function()
                selectedDownloadJob = item
                selectedFavoriteHandler = onRemoveFavorite
                selectedQueueHandler = onQueue
                selectedAddPlaylistHandler = onAddPlaylist
                selectedRemovePlaylistHandler = nil
                selectedDeleteHandler = nil
                showDownloadOptions(optionsButton, "favorites")
            end)
        end

        task.defer(function()
            setDownloadsListHeight(layout.AbsoluteContentSize.Y + 8)
        end)
    end


    local function renderPlaylistItems(items, onPlay, onRemoveFromPlaylist, onFavorite, onQueue, onAddPlaylist)
        hideDownloadOptions()
        clearContainer(downloadsList)
        items = items or {}

        if #items == 0 then
            createEmptyState(downloadsList, tr("Esta playlist esta vacia."))
            setDownloadsListHeight(0)
            return
        end

        local layout = Instance.new("UIListLayout")
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = downloadsList

        for _, item in ipairs(items) do
            local media = item.media or item
            media.title = cleanDownloadTitle(media.title, media.artist)
            media.duration_text = ""
            media.is_playing = item.is_playing == true or media.is_playing == true

            local row, optionsButton = createWideRow(downloadsList, media)
            row.Size = UDim2.new(1, -6, 0, 48)

            local statusLabel = row:FindFirstChild("Duration")
            if statusLabel then
                statusLabel.Visible = false
            end

            local nameLabel = row:FindFirstChild("Name")
            local artistLabel = row:FindFirstChild("Artist")

            if nameLabel then
                nameLabel.Size = UDim2.new(1, -150, 0, 20)
            end

            if artistLabel then
                artistLabel.Size = UDim2.new(1, -150, 0, 18)
            end

            optionsButton.Position = UDim2.new(1, -34, 0.5, -14)
            optionsButton.ZIndex = 6
            optionsButton.Text = "..."
            optionsButton.TextSize = 15
            optionsButton.TextColor3 = COLORS.Muted

            local rowButton = Instance.new("TextButton")
            rowButton.Name = "RowPlayButton"
            rowButton.Size = UDim2.new(1, -108, 1, 0)
            rowButton.Position = UDim2.new(0, 0, 0, 0)
            rowButton.BackgroundTransparency = 1
            rowButton.BorderSizePixel = 0
            rowButton.Text = ""
            rowButton.AutoButtonColor = false
            rowButton.Active = true
            rowButton.ZIndex = 3
            rowButton.Parent = row
            rowButton.MouseButton1Click:Connect(function()
                hideDownloadOptions()

                if onPlay then
                    onPlay(item)
                end
            end)

            local playButton = createDownloadPlayButton(row)
            playButton.MouseButton1Click:Connect(function()
                hideDownloadOptions()

                if onPlay then
                    onPlay(item)
                end
            end)

            optionsButton.MouseButton1Click:Connect(function()
                selectedDownloadJob = item
                selectedFavoriteHandler = onFavorite
                selectedQueueHandler = onQueue
                selectedAddPlaylistHandler = onAddPlaylist
                selectedRemovePlaylistHandler = onRemoveFromPlaylist
                selectedDeleteHandler = nil
                showDownloadOptions(optionsButton, "playlist")
            end)
        end

        task.defer(function()
            setDownloadsListHeight(layout.AbsoluteContentSize.Y + 8)
        end)
    end



    local function renderSidebarPlaylists(playlists, onOpen)
        clearContainer(playlistEntries)
        playlists = playlists or {}

        local entryHeight = 36
        playlistEntries.Size = UDim2.new(1, -42, 0, math.max(#playlists * entryHeight, 0))

        for index, playlist in ipairs(playlists) do
            local button = Instance.new("TextButton")
            button.Name = "PlaylistEntryButton"
            button.Size = UDim2.new(1, 0, 0, 32)
            button.Position = UDim2.new(0, 0, 0, (index - 1) * entryHeight)
            button.BackgroundTransparency = 1
            button.BorderSizePixel = 0
            button.Text = ""
            button.AutoButtonColor = false
            button.Parent = playlistEntries

            createLabel(button, "Icon", "P", UDim2.new(0, 30, 1, 0), UDim2.new(0, 0, 0, 0), 12, Enum.Font.GothamBold, COLORS.Muted).TextXAlignment = Enum.TextXAlignment.Center
            createLabel(button, "Label", tostring(playlist.name or tr("Lista")), UDim2.new(1, -36, 1, 0), UDim2.new(0, 36, 0, 0), 13, Enum.Font.Gotham, COLORS.Text)

            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = COLORS.PanelLight
                button.BackgroundTransparency = 0.45
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundTransparency = 1
            end)
            button.MouseButton1Click:Connect(function()
                if onOpen then
                    onOpen(playlist)
                end
            end)
        end

        sideBarScroll.CanvasSize = UDim2.new(0, 0, 0, playlistEntries.Position.Y.Offset + math.max(#playlists * entryHeight, 0) + 24)
    end

    local function setContentView(view, title)
        local showList = view == "downloads" or view == "favorites" or view == "playlist"
        searchSection.Visible = not showList
        popularSection.Visible = not showList
        recentPanel.Visible = not showList
        downloadsView.Visible = showList
        deletePlaylistButton.Visible = view == "playlist"
        downloadsTitle.Text = view == "favorites"
            and tr("Canciones favoritas")
            or (view == "playlist" and tostring(title or tr("Lista")) or tr("Descargas"))
        centerScroll.CanvasPosition = Vector2.new(0, 0)

        for name, button in pairs(navButtons) do
            local selected = (view == "downloads" and name == "Downloads")
                or (view == "favorites" and name == "LikedSongs")
                or (view == "playlist" and name == "Playlists")
                or (not showList and name == "Home")
            button.BackgroundColor3 = selected and COLORS.Purple or COLORS.Panel
            button.BackgroundTransparency = selected and 0.15 or 1
        end
    end
    minimizeButton.MouseButton1Click:Connect(function()
        root.Visible = false
        minimizedButton.Visible = false
    end)

    minimizedButton.MouseButton1Click:Connect(function()
        if minimizedButton:GetAttribute("WasDragged") then
            return
        end

        minimizedButton.Visible = false
        root.Visible = true
    end)

    local api = {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        MinimizeButton = minimizeButton,
        MinimizedButton = minimizedButton,
        SearchInput = searchInput,


        NavButtons = navButtons,
        SeeAllButton = seeAllButton,
        ClearQueueButton = clearQueueButton,
        VolumeSlider = volumeSlider,
        ProgressSeeked = seekChanged.Event,
        Buttons = {
            Play = playButton,
            Previous = previousButton,
            Next = nextButton,
            Shuffle = shuffleButton,
            Repeat = repeatButton,
            BottomShuffle = bottomShuffle,
            BottomPrevious = bottomPrevious,
            BottomPlay = bottomPlay,
            BottomNext = bottomNext,
            BottomRepeat = bottomRepeat,
            Heart = heartButton,
            BottomHeart = bottomHeart
        },
        Lists = lists,
        RenderSearchResults = function(items, onPlay, showEmptyState, onDownload, emptyText)
            renderCards(
                searchList,
                items,
                showEmptyState and (emptyText or tr("No hay resultados.")) or "__placeholder_cards",
                150,
                150,
                nil,
                searchPrevButton,
                searchNextButton,
                onPlay,
                onDownload
            )
        end,
        RenderPopular = function(items, onPlay, onDownload)
            renderCards(
                popularList,
                items,
                "__placeholder_cards",
                150,
                150,
                nil,
                popularPrevButton,
                popularNextButton,
                onPlay,
                onDownload
            )
        end,
        RenderRecent = function(items)
            renderRows(recentList, items, "", 3)
        end,
        DeletePlaylistButton = deletePlaylistButton,
        RenderDownloads = function(jobs, onPlay, onDelete, onReadyDownload, onFavorite, onQueue, onAddPlaylist)
            renderDownloads(jobs, onPlay, onDelete, onReadyDownload, onFavorite, onQueue, onAddPlaylist)
        end,
        RenderFavorites = function(items, onPlay, onRemoveFavorite, onQueue, onAddPlaylist)
            renderFavorites(items, onPlay, onRemoveFavorite, onQueue, onAddPlaylist)
        end,
        RenderPlaylistItems = function(items, onPlay, onRemoveFromPlaylist, onFavorite, onQueue, onAddPlaylist)
            renderPlaylistItems(items, onPlay, onRemoveFromPlaylist, onFavorite, onQueue, onAddPlaylist)
        end,
        RenderPlaylists = function(playlists, onOpen)
            renderSidebarPlaylists(playlists, onOpen)
        end,
        OpenCreatePlaylistModal = function(onCreate)
            createPlaylistHandler = onCreate
            playlistNameInput.Text = ""
            createPlaylistModal.Visible = true
            playlistNameInput:CaptureFocus()
        end,
        OpenPlaylistPicker = function(playlists, onSelect)
            playlistPickerHandler = onSelect
            clearContainer(playlistPickerList)

            playlists = playlists or {}

            if #playlists == 0 then
                createEmptyState(playlistPickerList, tr("No hay playlists."))
            else
                local pickerLayout = Instance.new("UIListLayout")
                pickerLayout.FillDirection = Enum.FillDirection.Vertical
                pickerLayout.Padding = UDim.new(0, 4)
                pickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
                pickerLayout.Parent = playlistPickerList

                for _, playlist in ipairs(playlists) do
                    local button = createIconButton(
                        playlistPickerList,
                        "PlaylistOptionButton",
                        tostring(playlist.name or tr("Lista")),
                        UDim2.new(1, 0, 0, 32),
                        UDim2.new(0, 0, 0, 0)
                    )
                    button.BackgroundTransparency = 0.25
                    button.TextXAlignment = Enum.TextXAlignment.Left
                    button.ZIndex = 61
                    button.MouseButton1Click:Connect(function()
                        hidePlaylistPicker()

                        if playlistPickerHandler then
                            playlistPickerHandler(playlist)
                        end
                    end)
                end
            end

            playlistPickerModal.Visible = true
        end,
        OpenDeletePlaylistConfirm = function(playlist, onDelete)
            deletePlaylistHandler = onDelete
            deletePlaylistName.Text = tostring(playlist and playlist.name or tr("Lista"))
            deletePlaylistModal.Visible = true
        end,
        SetContentView = function(view, title)
            setContentView(view, title)
        end,
        RenderQueue = function(items)
            renderRows(queueList, items, tr("La cola esta vacia."), 5)
        end,
        SetFavoriteActive = function(isFavorite)
            local active = isFavorite == true
            local color = active and COLORS.Green or COLORS.PanelLight
            local transparency = active and 0 or 0.82
            heartButton.BackgroundColor3 = color
            bottomHeart.BackgroundColor3 = color
            heartButton.BackgroundTransparency = transparency
            bottomHeart.BackgroundTransparency = transparency
        end,
        SetPlaybackState = function(isPlaying)
            local symbol = isPlaying and "||" or ">"
            playButton.Text = symbol
            bottomPlay.Text = symbol
        end,
        SetNowPlaying = function(item, progress, currentText, totalText)
            local artist = item and item.artist or tr("Selecciona una cancion")
            local title = item and cleanDownloadTitle(item.title, artist) or tr("Nada reproduciendose")

            nowTitle.Text = title
            nowArtist.Text = artist
            bottomTitle.Text = title
            bottomArtist.Text = artist
            currentTime.Text = currentText or "0:00"
            totalTime.Text = totalText or "0:00"
            bottomCurrent.Text = currentText or "0:00"
            bottomTotal.Text = totalText or "0:00"
            if not nowProgressDragging() then
                setNowProgress(progress or 0)
            end

            if not bottomProgressDragging() then
                setBottomProgress(progress or 0)
            end

            local nowImage = nowArt:FindFirstChild("Image")
            local bottomImage = bottomArt:FindFirstChild("Image")

            if nowImage then
                applyThumbnail(nowImage, item)
            end

            if bottomImage then
                applyThumbnail(bottomImage, item)
            end
        end,
        Destroy = function()
            gui:Destroy()
        end
    }

    api.RenderSearchResults({})
    api.RenderPopular({})
    api.RenderRecent({})
    api.RenderDownloads({})
    api.RenderQueue({})
    api.SetContentView("home")
    api.SetNowPlaying(nil, 0)
    api.SetFavoriteActive(false)

    if _G.StrikeChatLayoutMode == "mobile" then
        sideBar.Size = UDim2.new(0, 210, 1, -146)
        sideBar.Position = UDim2.new(0, 8, 0, 66)
        centerPanel.Position = UDim2.new(0, 226, 0, 66)
        centerPanel.Size = UDim2.new(1, -454, 1, -146)
        rightPanel.Size = UDim2.new(0, 210, 1, -146)
        rightPanel.Position = UDim2.new(1, -218, 0, 66)
        bottomPlayer.Size = UDim2.new(1, -16, 0, 68)
        bottomPlayer.Position = UDim2.new(0, 8, 1, -76)
        bottomTitle.Position = UDim2.new(0, 78, 0, 13)
        bottomTitle.Size = UDim2.new(0, 116, 0, 22)
        bottomTitle.TextSize = 14
        bottomArtist.Position = UDim2.new(0, 78, 0, 39)
        bottomArtist.Size = UDim2.new(0, 116, 0, 18)
        bottomArtist.TextSize = 11
        bottomHeart.Position = UDim2.new(0, 198, 0, 35)
        searchHolder.Position = UDim2.new(0.31, -1, 0, 14)
        searchHolder.Size = UDim2.new(0.38, 0, 0, 42)
    end

    return api
end

return StrikeMusicUI
