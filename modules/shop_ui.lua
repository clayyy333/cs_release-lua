local ShopUI = {}

local POINTS_ICON_IMAGE = "rbxassetid://124520045081815"

function ShopUI.Create(parent, Theme, initialPoints)
    local TweenService = game:GetService("TweenService")

    local function animatePointsIcon(iconHolder, icon)
        task.spawn(function()
            while iconHolder.Parent do
                local now = os.clock()
                icon.Rotation = math.sin(now * 2.1) * 8

                task.wait(0.05)
            end
        end)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "ShopUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    pcall(function()
        gui.ScreenInsets = Enum.ScreenInsets.None
    end)
    pcall(function()
        gui.ClipToDeviceSafeArea = false
    end)
    gui.Parent = parent

    local function createPriceRow(parentInstance, amount, position, size, textSize, zIndex)
        local priceRow = Instance.new("Frame")
        priceRow.Name = "PriceRow"
        priceRow.Size = size
        priceRow.Position = position
        priceRow.BackgroundTransparency = 1
        priceRow.BorderSizePixel = 0
        priceRow.Active = false
        priceRow.ZIndex = zIndex or 3
        priceRow.Parent = parentInstance

        local pillLayout = Instance.new("UIListLayout")
        pillLayout.FillDirection = Enum.FillDirection.Horizontal
        pillLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        pillLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        pillLayout.Padding = UDim.new(0, 4)
        pillLayout.SortOrder = Enum.SortOrder.LayoutOrder
        pillLayout.Parent = priceRow

        local priceText = Instance.new("TextLabel")
        priceText.Name = "PriceText"
        priceText.Size = UDim2.new(0, 0, 1, 0)
        priceText.AutomaticSize = Enum.AutomaticSize.X
        priceText.BackgroundTransparency = 1
        priceText.Text = tostring(amount)
        priceText.TextColor3 = Theme.Colors.Text
        priceText.Font = Theme.Font.Bold
        priceText.TextSize = textSize or 13
        priceText.TextXAlignment = Enum.TextXAlignment.Center
        priceText.LayoutOrder = 1
        priceText.ZIndex = (zIndex or 3) + 1
        priceText.Parent = priceRow

        local priceIcon = Instance.new("ImageLabel")
        priceIcon.Name = "PriceIcon"
        priceIcon.Size = UDim2.new(0, 16, 0, 16)
        priceIcon.BackgroundTransparency = 1
        priceIcon.Image = POINTS_ICON_IMAGE
        priceIcon.ScaleType = Enum.ScaleType.Fit
        priceIcon.LayoutOrder = 2
        priceIcon.ZIndex = (zIndex or 3) + 1
        priceIcon.Parent = priceRow

        task.spawn(function()
            local fadeOut = true

            while priceRow.Parent do
                if fadeOut then
                    priceText.TextTransparency += 0.03
                    priceIcon.ImageTransparency += 0.03

                    if priceText.TextTransparency >= 0.45 then
                        fadeOut = false
                    end
                else
                    priceText.TextTransparency -= 0.03
                    priceIcon.ImageTransparency -= 0.03

                    if priceText.TextTransparency <= 0 then
                        fadeOut = true
                    end
                end

                task.wait(0.05)
            end
        end)

        return priceRow
    end

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.new(0, 920, 0, 510)
    root.Position = UDim2.new(0.5, -460, 0.5, -238)
    root.BackgroundColor3 = Color3.fromRGB(40, 10, 65)
    root.BorderSizePixel = 0
    root.Parent = gui

    local rootCorner = Instance.new("UICorner")
    rootCorner.CornerRadius = UDim.new(0, 14)
    rootCorner.Parent = root

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(15, 6, 30)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(120, 12, 160)),
        ColorSequenceKeypoint.new(0.40, Color3.fromRGB(255, 30, 120)),
        ColorSequenceKeypoint.new(0.60, Color3.fromRGB(50, 70, 180)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(20, 40, 100)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(8, 8, 18))
    })
    gradient.Rotation = 25
    gradient.Parent = root

    local starsFrame = Instance.new("Frame")
    starsFrame.Name = "Stars"
    starsFrame.Size = UDim2.new(1, 0, 1, 0)
    starsFrame.BackgroundTransparency = 1
    starsFrame.ZIndex = -1
    starsFrame.Parent = root

    math.randomseed(tick())

    local STAR_COUNT = 120

    for i = 1, STAR_COUNT do
        local star = Instance.new("Frame")

        local size = math.random(1, 2)

        star.Size = UDim2.new(0, size, 0, size)

        star.Position = UDim2.new(
            math.random(),
            0,
            math.random(),
            0
        )

        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BorderSizePixel = 0
        star.BackgroundTransparency = math.random(35, 80) / 100

        local starCorner = Instance.new("UICorner")
        starCorner.CornerRadius = UDim.new(1, 0)
        starCorner.Parent = star

        star.Parent = starsFrame

        task.spawn(function()
            while star.Parent do
                task.wait(math.random(2, 6) / 10)

                star.BackgroundTransparency =
                    math.clamp(
                        star.BackgroundTransparency +
                        ((math.random(-10, 10)) / 100),
                        0.20,
                        0.85
                    )
            end
        end)
    end

    local cometLayer = Instance.new("Frame")
    cometLayer.Name = "CometLayer"
    cometLayer.Size = UDim2.new(1, 0, 1, 0)
    cometLayer.BackgroundTransparency = 1
    cometLayer.ClipsDescendants = true
    cometLayer.ZIndex = 1
    cometLayer.Parent = root

    task.spawn(function()
        while cometLayer.Parent do
            task.wait(math.random(20, 45) / 10)

            local comet = Instance.new("Frame")
            local size = math.random(2, 3)

            comet.Size = UDim2.new(0, size, 0, size)
            comet.Position = UDim2.new(
                math.random(10, 90) / 100,
                0,
                math.random(8, 80) / 100,
                0
            )
            comet.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            comet.BackgroundTransparency = 0.15
            comet.BorderSizePixel = 0
            comet.ZIndex = 1
            comet.Parent = cometLayer

            local cometCorner = Instance.new("UICorner")
            cometCorner.CornerRadius = UDim.new(1, 0)
            cometCorner.Parent = comet

            local direction = math.random(1, 2) == 1 and -1 or 1

            task.spawn(function()
                for _ = 1, 45 do
                    comet.Position = comet.Position + UDim2.new(0.0035 * direction, 0, 0.004, 0)
                    comet.BackgroundTransparency += 0.018
                    task.wait(0.025)
                end

                comet:Destroy()
            end)
        end
    end)


    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -58, 0, 8)
    closeButton.BackgroundColor3 = Color3.fromRGB(120, 36, 36)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.Text
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 18
    closeButton.Parent = root

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local pointsBadge = Instance.new("Frame")
    pointsBadge.Name = "PointsBadge"
    pointsBadge.Size = UDim2.new(0, 178, 0, 38)
    pointsBadge.Position = UDim2.new(0, 18, 0, 12)
    pointsBadge.BackgroundColor3 = Color3.fromRGB(14, 12, 22)
    pointsBadge.BackgroundTransparency = 0.08
    pointsBadge.BorderSizePixel = 0
    pointsBadge.Parent = root

    local pointsBadgeCorner = Instance.new("UICorner")
    pointsBadgeCorner.CornerRadius = UDim.new(0, 9)
    pointsBadgeCorner.Parent = pointsBadge

    local pointsBadgeStroke = Instance.new("UIStroke")
    pointsBadgeStroke.Color = Color3.fromRGB(24, 22, 34)
    pointsBadgeStroke.Thickness = 1
    pointsBadgeStroke.Transparency = 0.35
    pointsBadgeStroke.Parent = pointsBadge

    local pointsLabel = Instance.new("TextLabel")
    pointsLabel.Name = "PointsLabel"
    pointsLabel.Size = UDim2.new(0, 72, 1, 0)
    pointsLabel.Position = UDim2.new(0, 12, 0, 0)
    pointsLabel.BackgroundTransparency = 1
    pointsLabel.Text = "Mis puntos"
    pointsLabel.TextColor3 = Theme.Colors.TextMuted
    pointsLabel.Font = Theme.Font.Bold
    pointsLabel.TextSize = 11
    pointsLabel.TextXAlignment = Enum.TextXAlignment.Left
    pointsLabel.Parent = pointsBadge

    local pointsValue = Instance.new("TextLabel")
    pointsValue.Name = "PointsValue"
    pointsValue.Size = UDim2.new(1, -116, 1, 0)
    pointsValue.Position = UDim2.new(0, 84, 0, 0)
    pointsValue.BackgroundTransparency = 1
    pointsValue.Text = tostring(initialPoints or 0)
    pointsValue.TextColor3 = Theme.Colors.Text
    pointsValue.Font = Theme.Font.Bold
    pointsValue.TextSize = 15
    pointsValue.TextXAlignment = Enum.TextXAlignment.Right
    pointsValue.TextTruncate = Enum.TextTruncate.AtEnd
    pointsValue.Parent = pointsBadge

    local pointsIconHolder = Instance.new("Frame")
    pointsIconHolder.Name = "PointsIconHolder"
    pointsIconHolder.Size = UDim2.new(0, 32, 0, 32)
    pointsIconHolder.Position = UDim2.new(1, -35, 0.5, -16)
    pointsIconHolder.BackgroundTransparency = 1
    pointsIconHolder.BorderSizePixel = 0
    pointsIconHolder.ClipsDescendants = false
    pointsIconHolder.Parent = pointsBadge

    local pointsIcon = Instance.new("ImageLabel")
    pointsIcon.Name = "PointsIcon"
    pointsIcon.Size = UDim2.new(0, 22, 0, 22)
    pointsIcon.Position = UDim2.new(0.5, -11, 0.5, -11)
    pointsIcon.BackgroundTransparency = 1
    pointsIcon.Image = POINTS_ICON_IMAGE
    pointsIcon.ScaleType = Enum.ScaleType.Fit
    pointsIcon.ZIndex = 3
    pointsIcon.Parent = pointsIconHolder

    animatePointsIcon(pointsIconHolder, pointsIcon)

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -140, 0, 48)
    title.Position = UDim2.new(0, 70, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = "TIENDA"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = root


    local featuredCard = Instance.new("Frame")
    featuredCard.Name = "FeaturedCard"
    featuredCard.Size = UDim2.new(0, 360, 0, 210)
    featuredCard.Position = UDim2.new(0, 28, 0, 82)
    featuredCard.BackgroundColor3 = Color3.fromRGB(48, 24, 82)

    local featuredGradient = Instance.new("UIGradient")
    featuredGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(95, 28, 145)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(48, 24, 82)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 12, 28))
    })
    featuredGradient.Rotation = 35
    featuredGradient.Parent = featuredCard


    featuredCard.BorderSizePixel = 0
    featuredCard.Parent = root

    local featuredCorner = Instance.new("UICorner")
    featuredCorner.CornerRadius = UDim.new(0, 14)
    featuredCorner.Parent = featuredCard

    local featuredStroke = Instance.new("UIStroke")
    featuredStroke.Color = Color3.fromRGB(168, 6, 235)
    featuredStroke.Thickness = 1
    featuredStroke.Transparency = 0.15
    featuredStroke.Parent = featuredCard

    




    local featuredBadge = Instance.new("TextLabel")
    featuredBadge.Name = "MonthlyBadge"
    featuredBadge.Size = UDim2.new(0, 132, 0, 26)
    featuredBadge.Position = UDim2.new(0, 14, 0, 12)
    featuredBadge.BackgroundColor3 = Color3.fromRGB(245, 190, 60)
    featuredBadge.BorderSizePixel = 0
    featuredBadge.Text = "2 cantidad por mes"
    featuredBadge.TextColor3 = Color3.fromRGB(20, 20, 24)
    featuredBadge.Font = Theme.Font.Bold
    featuredBadge.TextSize = 11
    featuredBadge.Parent = featuredCard

    local featuredBadgeCorner = Instance.new("UICorner")
    featuredBadgeCorner.CornerRadius = UDim.new(0, 8)
    featuredBadgeCorner.Parent = featuredBadge


    local featuredRemaining = Instance.new("TextLabel")
    featuredRemaining.Name = "RemainingLabel"
    featuredRemaining.Size = UDim2.new(0, 100, 0, 26)
    featuredRemaining.Position = UDim2.new(1, -114, 0, 12)
    featuredRemaining.BackgroundTransparency = 1
    featuredRemaining.Text = "Restante 2"
    featuredRemaining.TextColor3 = Color3.fromRGB(255, 220, 120)
    featuredRemaining.Font = Theme.Font.Bold
    featuredRemaining.TextSize = 12
    featuredRemaining.TextXAlignment = Enum.TextXAlignment.Right
    featuredRemaining.Parent = featuredCard

    task.spawn(function()
        local fadeOut = true

        while featuredRemaining.Parent do
            if fadeOut then
                featuredRemaining.TextTransparency += 0.03

                if featuredRemaining.TextTransparency >= 0.45 then
                    fadeOut = false
                end
            else
                featuredRemaining.TextTransparency -= 0.03

                if featuredRemaining.TextTransparency <= 0 then
                    fadeOut = true
                end
            end

            task.wait(0.05)
        end
    end)



    local featuredTitle = Instance.new("TextLabel")
    featuredTitle.Size = UDim2.new(1, -28, 0, 44)
    featuredTitle.Position = UDim2.new(0, 14, 0, 54)
    featuredTitle.BackgroundTransparency = 1
    featuredTitle.Text = "1000 ROBUX"
    featuredTitle.TextColor3 = Theme.Colors.Text
    featuredTitle.Font = Theme.Font.Bold
    featuredTitle.TextSize = 28
    featuredTitle.TextXAlignment = Enum.TextXAlignment.Left
    featuredTitle.Parent = featuredCard

    local featuredPriceRow = createPriceRow(
        featuredCard,
        1000,
        UDim2.new(1, -112, 0, 62),
        UDim2.new(0, 92, 0, 22),
        13,
        3
    )

    local featuredSubtitle = Instance.new("TextLabel")
    featuredSubtitle.Size = UDim2.new(1, -28, 0, 30)
    featuredSubtitle.Position = UDim2.new(0, 14, 0, 100)
    featuredSubtitle.BackgroundTransparency = 1
    featuredSubtitle.Text = "Premio principal destacado"
    featuredSubtitle.TextColor3 = Theme.Colors.TextMuted
    featuredSubtitle.Font = Theme.Font.Regular
    featuredSubtitle.TextSize = 13
    featuredSubtitle.TextXAlignment = Enum.TextXAlignment.Left
    featuredSubtitle.Parent = featuredCard

    local featuredPrice = Instance.new("TextButton")
    featuredPrice.Name = "FeaturedPriceButton"
    featuredPrice.Size = UDim2.new(1, -28, 0, 42)
    featuredPrice.Position = UDim2.new(0, 14, 1, -56)
    featuredPrice.BackgroundColor3 = Color3.fromRGB(168, 6, 235)
    featuredPrice.BorderSizePixel = 0
    featuredPrice.Text = "Precio: próximamente"
    featuredPrice.TextColor3 = Theme.Colors.Text
    featuredPrice.Font = Theme.Font.Bold
    featuredPrice.TextSize = 13
    featuredPrice.Parent = featuredCard

    local featuredPriceCorner = Instance.new("UICorner")
    featuredPriceCorner.CornerRadius = UDim.new(0, 10)
    featuredPriceCorner.Parent = featuredPrice

    local itemsContainer = Instance.new("ScrollingFrame")
    itemsContainer.Name = "ItemsContainer"
    itemsContainer.Size = UDim2.new(0, 470, 0, 360)
    itemsContainer.Position = UDim2.new(0, 420, 0, 82)
    itemsContainer.BackgroundTransparency = 1
    itemsContainer.BorderSizePixel = 0
    itemsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    itemsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    itemsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    itemsContainer.ScrollBarThickness = 4
    itemsContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
    itemsContainer.Parent = root

    local itemsPadding = Instance.new("UIPadding")
    itemsPadding.PaddingTop = UDim.new(0, 3)
    itemsPadding.PaddingBottom = UDim.new(0, 8)
    itemsPadding.PaddingLeft = UDim.new(0, 3)
    itemsPadding.PaddingRight = UDim.new(0, 8)
    itemsPadding.Parent = itemsContainer

    local itemsLayout = Instance.new("UIGridLayout")
    itemsLayout.CellSize = UDim2.new(0, 216, 0, 108)
    itemsLayout.CellPadding = UDim2.new(0, 16, 0, 16)
    itemsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemsLayout.Parent = itemsContainer

    local function createShopItem(title, color, badgeText, showPrice)
        if showPrice == nil then
            showPrice = true
        end

        local item = Instance.new("Frame")
        item.BackgroundColor3 = Color3.fromRGB(22, 24, 30)

        local itemGradient = Instance.new("UIGradient")
        itemGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                color:Lerp(Color3.fromRGB(25, 25, 40), 0.15)
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(10, 10, 18)
            )
        })

        itemGradient.Rotation = 90
        itemGradient.Parent = item

        item.BorderSizePixel = 0

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 12)
        itemCorner.Parent = item

        local itemStroke = Instance.new("UIStroke")
        itemStroke.Color = color
        itemStroke.Thickness = 1
        itemStroke.Transparency = 0.15
        itemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        itemStroke.Parent = item

        if badgeText then
            local badge = Instance.new("TextLabel")
            badge.Name = "Badge"
            badge.Size = UDim2.new(0, 120, 0, 22)
            badge.Position = UDim2.new(0, 10, 0, 10)
            badge.BackgroundColor3 = Color3.fromRGB(245, 190, 60)
            badge.BorderSizePixel = 0
            badge.Text = badgeText
            badge.TextColor3 = Color3.fromRGB(20, 20, 24)
            badge.Font = Theme.Font.Bold
            badge.TextSize = 10
            badge.Parent = item

            local badgeCorner = Instance.new("UICorner")
            badgeCorner.CornerRadius = UDim.new(0, 8)
            badgeCorner.Parent = badge
        end

        local itemTitle = Instance.new("TextLabel")
        itemTitle.Size = UDim2.new(1, -20, 0, showPrice and 30 or 36)
        itemTitle.Position = UDim2.new(0, 10, 0, showPrice and 4 or 38)
        itemTitle.BackgroundTransparency = 1
        itemTitle.Name = "ItemTitle"
        itemTitle.Text = title
        itemTitle.TextColor3 = Theme.Colors.Text
        itemTitle.Font = Theme.Font.Bold
        itemTitle.TextSize = 16
        itemTitle.TextWrapped = true
        itemTitle.TextXAlignment = Enum.TextXAlignment.Center
        itemTitle.TextYAlignment = Enum.TextYAlignment.Center
        itemTitle.Parent = item

        if showPrice then
            local priceRow = Instance.new("Frame")
            priceRow.Name = "PriceRow"
            priceRow.Size = UDim2.new(1, -20, 0, 18)
            priceRow.Position = UDim2.new(0, 10, 0, 34)
            priceRow.BackgroundTransparency = 1
            priceRow.BorderSizePixel = 0
            priceRow.Active = false
            priceRow.Parent = item

            local priceLayout = Instance.new("UIListLayout")
            priceLayout.FillDirection = Enum.FillDirection.Horizontal
            priceLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            priceLayout.VerticalAlignment = Enum.VerticalAlignment.Center
            priceLayout.Padding = UDim.new(0, 4)
            priceLayout.SortOrder = Enum.SortOrder.LayoutOrder
            priceLayout.Parent = priceRow

            local priceLabel = Instance.new("TextLabel")
            priceLabel.Name = "PriceLabel"
            priceLabel.Size = UDim2.new(0, 0, 1, 0)
            priceLabel.AutomaticSize = Enum.AutomaticSize.X
            priceLabel.BackgroundTransparency = 1
            priceLabel.Text = "Valor 10"
            priceLabel.TextColor3 = Theme.Colors.Text
            priceLabel.Font = Theme.Font.Bold
            priceLabel.TextSize = 12
            priceLabel.TextXAlignment = Enum.TextXAlignment.Center
            priceLabel.LayoutOrder = 1
            priceLabel.Parent = priceRow

            local priceIcon = Instance.new("ImageLabel")
            priceIcon.Name = "PriceIcon"
            priceIcon.Size = UDim2.new(0, 16, 0, 16)
            priceIcon.BackgroundTransparency = 1
            priceIcon.Image = POINTS_ICON_IMAGE
            priceIcon.ScaleType = Enum.ScaleType.Fit
            priceIcon.LayoutOrder = 2
            priceIcon.Parent = priceRow

            task.spawn(function()
                local fadeOut = true

                while priceRow.Parent do
                    if fadeOut then
                        priceLabel.TextTransparency += 0.03
                        priceIcon.ImageTransparency += 0.03

                        if priceLabel.TextTransparency >= 0.45 then
                            fadeOut = false
                        end
                    else
                        priceLabel.TextTransparency -= 0.03
                        priceIcon.ImageTransparency -= 0.03

                        if priceLabel.TextTransparency <= 0 then
                            fadeOut = true
                        end
                    end

                    task.wait(0.05)
                end
            end)
        end

        local buyButton = Instance.new("TextButton")
        buyButton.Size = UDim2.new(1, -20, 0, 32)
        buyButton.Position = UDim2.new(0, 10, 1, -42)
        buyButton.BackgroundColor3 = color
        buyButton.BorderSizePixel = 0
        buyButton.Text = "Comprar"
        buyButton.TextColor3 = Theme.Colors.Text
        buyButton.Font = Theme.Font.Bold
        buyButton.TextSize = 11
        buyButton.Parent = item

        local buyCorner = Instance.new("UICorner")
        buyCorner.CornerRadius = UDim.new(0, 8)
        buyCorner.Parent = buyButton

        return item, buyButton
    end

    local item1, item1BuyButton = createShopItem(
        "TICKET DE CLAN",
        Color3.fromRGB(168, 6, 235)
    )
    item1.Parent = itemsContainer

    local item2, item2BuyButton = createShopItem(
        "COLOR DE NOMBRE",
        Color3.fromRGB(78, 158, 58)
    )
    item2.Parent = itemsContainer

    local item3, item3BuyButton = createShopItem(
        "CHAT PERSONALIZADO",
        Color3.fromRGB(66, 135, 245)
    )
    item3.Parent = itemsContainer

    local item4, item4BuyButton = createShopItem(
        "COLOR DE CHAT",
        Color3.fromRGB(255, 110, 180)
    )
    item4.Parent = itemsContainer

    local item5, item5BuyButton = createShopItem(
        "DISEÑO DE FONDO",
        Color3.fromRGB(255, 170, 70)
    )
    item5.Parent = itemsContainer

    local item6, item6BuyButton = createShopItem(
        "100 ROBUX",
        Color3.fromRGB(245, 190, 60),
        "10 cantidad por mes",
        false
    )
    item6.Parent = itemsContainer

    local item6Title = item6:FindFirstChild("ItemTitle")

    if item6Title then
        item6Title.Size = UDim2.new(0, 112, 0, 36)
        item6Title.Position = UDim2.new(0, 10, 0, 31)
        item6Title.TextXAlignment = Enum.TextXAlignment.Left
    end

    createPriceRow(
        item6,
        200,
        UDim2.new(1, -84, 0, 36),
        UDim2.new(0, 68, 0, 20),
        12,
        3
    )

    local item6Gradient = Instance.new("UIGradient")


    item6Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 210, 90)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 85, 170)),
        ColorSequenceKeypoint.new(0.62, Color3.fromRGB(80, 110, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(18, 12, 35))
    })
    item6Gradient.Rotation = 35
    item6Gradient.Parent = item6

    local item6Stroke = item6:FindFirstChildOfClass("UIStroke")

    local item6Remaining = Instance.new("TextLabel")
    item6Remaining.Name = "RemainingLabel"
    item6Remaining.Size = UDim2.new(0, 92, 0, 20)
    item6Remaining.Position = UDim2.new(1, -102, 0, 10)
    item6Remaining.BackgroundTransparency = 1
    item6Remaining.Text = "Restante 10"
    item6Remaining.TextColor3 = Color3.fromRGB(255, 220, 90)
    item6Remaining.Font = Theme.Font.Bold
    item6Remaining.TextSize = 10
    item6Remaining.TextXAlignment = Enum.TextXAlignment.Right
    item6Remaining.Parent = item6

    task.spawn(function()
        local fadeOut = true

        while item6Remaining.Parent do
            if fadeOut then
                item6Remaining.TextTransparency += 0.03

                if item6Remaining.TextTransparency >= 0.45 then
                    fadeOut = false
                end
            else
                item6Remaining.TextTransparency -= 0.03

                if item6Remaining.TextTransparency <= 0 then
                    fadeOut = true
                end
            end

            task.wait(0.05)
        end
    end)



    if item6Stroke then
        item6Stroke.Color = Color3.fromRGB(255, 220, 90)
        item6Stroke.Transparency = 0.05
    end

    featuredPrice.Text = "Generar codigo de Premio"
    item6BuyButton.Text = "Generar codigo de Premio"

    local function playOpeningReveal()
        local revealZIndex = 80

        local leftReveal = Instance.new("Frame")
        leftReveal.Name = "LeftOpeningReveal"
        leftReveal.Size = UDim2.new(0.5, 1, 1, 0)
        leftReveal.Position = UDim2.new(0, 0, 0, 0)
        leftReveal.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        leftReveal.BorderSizePixel = 0
        leftReveal.ZIndex = revealZIndex
        leftReveal.Parent = root

        local leftGradient = Instance.new("UIGradient")
        leftGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 22, 36)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(76, 24, 96))
        })
        leftGradient.Rotation = 0
        leftGradient.Parent = leftReveal

        local rightReveal = Instance.new("Frame")
        rightReveal.Name = "RightOpeningReveal"
        rightReveal.Size = UDim2.new(0.5, 1, 1, 0)
        rightReveal.Position = UDim2.new(0.5, -1, 0, 0)
        rightReveal.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        rightReveal.BorderSizePixel = 0
        rightReveal.ZIndex = revealZIndex
        rightReveal.Parent = root

        local rightGradient = Instance.new("UIGradient")
        rightGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(76, 24, 96)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(26, 22, 36))
        })
        rightGradient.Rotation = 0
        rightGradient.Parent = rightReveal

        local tweenInfo = TweenInfo.new(
            0.82,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        )

        task.delay(0.08, function()
            if not root.Parent then
                return
            end

            TweenService:Create(leftReveal, tweenInfo, {
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            TweenService:Create(rightReveal, tweenInfo, {
                Position = UDim2.new(1, 0, 0, 0),
                Size = UDim2.new(0, 0, 1, 0)
            }):Play()

            task.delay(0.92, function()
                if leftReveal.Parent then
                    leftReveal:Destroy()
                end

                if rightReveal.Parent then
                    rightReveal:Destroy()
                end
            end)
        end)
    end

    if _G.StrikeChatLayoutMode == "mobile" then
        root.AnchorPoint = Vector2.new(0, 1)
        root.Size = UDim2.new(1, 0, 1, -64)
        root.Position = UDim2.new(0, 0, 1, 0)
        rootCorner.CornerRadius = UDim.new(0, 0)

        closeButton.Position = UDim2.new(1, -50, 0, 8)
        pointsBadge.Position = UDim2.new(0, 14, 0, 12)
        title.Size = UDim2.new(1, -220, 0, 48)
        title.Position = UDim2.new(0, 110, 0, 6)

        featuredCard.Size = UDim2.new(0, 340, 0, 190)
        featuredCard.Position = UDim2.new(0, 24, 0, 66)
        featuredBadge.Position = UDim2.new(0, 14, 0, 10)
        featuredRemaining.Position = UDim2.new(1, -114, 0, 10)
        featuredTitle.Position = UDim2.new(0, 14, 0, 46)
        featuredPriceRow.Position = UDim2.new(1, -112, 0, 54)
        featuredSubtitle.Position = UDim2.new(0, 14, 0, 86)
        featuredPrice.Size = UDim2.new(1, -28, 0, 38)
        featuredPrice.Position = UDim2.new(0, 14, 1, -50)

        itemsContainer.Position = UDim2.new(0, 408, 0, 66)
        itemsContainer.Size = UDim2.new(1, -424, 1, -88)
        itemsContainer.ScrollBarThickness = 2
        itemsContainer.ScrollBarImageTransparency = 0

        itemsPadding.PaddingTop = UDim.new(0, 3)
        itemsPadding.PaddingBottom = UDim.new(0, 12)
        itemsPadding.PaddingLeft = UDim.new(0, 3)
        itemsPadding.PaddingRight = UDim.new(0, 6)

        itemsLayout.CellSize = UDim2.new(0.5, -10, 0, 108)
        itemsLayout.CellPadding = UDim2.new(0, 14, 0, 16)

        local item3Title = item3:FindFirstChild("ItemTitle")

        if item3Title then
            item3Title.Text = "PERS. CHAT"
        end

        local item6Badge = item6:FindFirstChild("Badge")

        if item6Badge then
            item6Badge.Size = UDim2.new(0, 104, 0, 22)
            item6Badge.Position = UDim2.new(0, 8, 0, 10)
        end

        item6Remaining.Size = UDim2.new(0, 76, 0, 20)
        item6Remaining.Position = UDim2.new(1, -84, 0, 10)
    end

    playOpeningReveal()

    return {
        Gui = gui,
        Root = root,
        CloseButton = closeButton,
        PointsValue = pointsValue,

        FeaturedButton = featuredPrice,
        ItemsContainer = itemsContainer,

        LimitedStockLabels = {
            Robux1000 = featuredRemaining,
            Robux100 = item6Remaining
        },

        LimitedButtons = {
            Robux1000 = featuredPrice,
            Robux100 = item6BuyButton
        },

        ItemButtons = {
            ClanTicket = item1BuyButton,
            NameColor = item2BuyButton,
            CustomChat = item3BuyButton,
            ChatColor = item4BuyButton,
            BackgroundDesign = item5BuyButton,
            Robux100 = item6BuyButton
        },

        Destroy = function()
            gui:Destroy()
        end,

        SetPoints = function(value)
            pointsValue.Text = tostring(value or 0)
        end
    }
end

return ShopUI
