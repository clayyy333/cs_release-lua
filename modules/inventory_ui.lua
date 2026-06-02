local InventoryUI = {}

local CATEGORY_LABELS = {
    username_color = "Color de nombre",
    chat_color = "Color de chat",
    chat_style = "Estilo de chat",
    profile_banner = "Diseño de fondo",
    clan = "Clan"
}

local CATEGORY_COLORS = {
    username_color = Color3.fromRGB(78, 158, 58),
    chat_color = Color3.fromRGB(255, 110, 180),
    chat_style = Color3.fromRGB(66, 135, 245),
    profile_banner = Color3.fromRGB(255, 170, 70),
    clan = Color3.fromRGB(168, 6, 235)
}

local COLOR_OPTIONS = {
    { value = "purple", label = "Morado", color = Color3.fromRGB(168, 6, 235) },
    { value = "blue", label = "Azul", color = Color3.fromRGB(66, 135, 245) },
    { value = "pink", label = "Rosado", color = Color3.fromRGB(255, 110, 180) },
    { value = "green", label = "Verde", color = Color3.fromRGB(78, 158, 58) },
    { value = "yellow", label = "Amarillo", color = Color3.fromRGB(245, 190, 60) }
}

local USERNAME_COLOR_OPTIONS = {
    { value = "red", label = "Rojo", color = Color3.fromRGB(235, 74, 74) },
    { value = "green", label = "Verde", color = Color3.fromRGB(78, 190, 92) },
    { value = "blue", label = "Azul", color = Color3.fromRGB(74, 142, 245) },
    { value = "yellow", label = "Amarillo", color = Color3.fromRGB(245, 205, 70) },
    { value = "orange", label = "Naranja", color = Color3.fromRGB(255, 156, 64) },
    { value = "pink", label = "Rosado", color = Color3.fromRGB(255, 110, 180) },
    { value = "purple", label = "Morado", color = Color3.fromRGB(168, 6, 235) },
    { value = "white", label = "Blanco", color = Color3.fromRGB(245, 245, 245) },
    { value = "black", label = "Negro", color = Color3.fromRGB(32, 32, 36) },
    { value = "cyan", label = "Celeste", color = Color3.fromRGB(64, 210, 230) }
}

local STYLE_OPTIONS = {
    { value = "bracket", label = "Tag Profesional = [TAG]" },
    { value = "plain", label = "Tag Normal = TAG" }
}

local CHAT_STYLE_NAMES = {
    bubble = "Burbuja",
    cloud = "Cute Cloud",
    galaxy = "Galaxy",
    hackermstrix = "HackerMatrix",
    royalgold = "Royal Gold",
    dog = "Perrito",
    cat = "Gatito",
    rainbow = "Arcoiris",
    hacker = "Hacker"
}

local CUSTOM_CHAT_ITEM_ID = "chat_personalizado"

local CUSTOM_CHAT_STYLES = {
    { value = "cloud", label = "Cute Cloud" },
    { value = "galaxy", label = "Galaxy" },
    { value = "hackermstrix", label = "HackerMatrix" },
    { value = "royalgold", label = "Royal Gold" }
}

local BACKGROUND_DESIGN_ITEM_ID = "profile_banner_space"
local DEFAULT_BACKGROUND_DESIGN_VALUE = "114828705105935"

local DEFAULT_BACKGROUND_DESIGN_OPTIONS = {
    { value = DEFAULT_BACKGROUND_DESIGN_VALUE, label = "Estilo Neon" },
    { value = "none", label = "Sin Diseño" },
    { value = "78042862196503", label = "neon v2" },
    { value = "108739418079272", label = "chico anime" },
    { value = "140536962305117", label = "chica anime" },
    { value = "75491780980123", label = "pareja anime" },
    { value = "87212336811608", label = "cyber city" },
    { value = "106061011904389", label = "cinnamoroll" },
    { value = "88694974755838", label = "anime face" }
}

local function getInventoryEntryData(entry)
    local item = entry.item or entry
    local inventoryItem = entry.inventory_item or entry

    return item, inventoryItem
end

function InventoryUI.Create(parent, Theme)
    local overlay = Instance.new("Frame")
    overlay.Name = "InventoryOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.42
    overlay.Visible = false
    overlay.ZIndex = 80
    overlay.Parent = parent

    local modal = Instance.new("Frame")
    modal.Name = "Modal"
    modal.Size = UDim2.new(0.86, 0, 0, 330)
    modal.Position = UDim2.new(0.5, 0, 0.5, 0)
    modal.AnchorPoint = Vector2.new(0.5, 0.5)
    modal.BackgroundColor3 = Theme.Colors.Panel
    modal.BorderSizePixel = 0
    modal.ZIndex = 81
    modal.Parent = overlay

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(320, 270)
    sizeConstraint.MaxSize = Vector2.new(520, 380)
    sizeConstraint.Parent = modal

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, Theme.Radius.Main)
    modalCorner.Parent = modal

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -64, 0, 30)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "Mis Items"
    title.TextColor3 = Theme.Colors.Text
    title.Font = Theme.Font.Bold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 82
    title.Parent = modal

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, -64, 0, 18)
    statusLabel.Position = UDim2.new(0, 16, 0, 39)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.TextColor3 = Theme.Colors.TextMuted
    statusLabel.Font = Theme.Font.Regular
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.ZIndex = 82
    statusLabel.Parent = modal

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 32, 0, 28)
    closeButton.Position = UDim2.new(1, -44, 0, 14)
    closeButton.BackgroundColor3 = Theme.Colors.PanelLight
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Theme.Colors.TextMuted
    closeButton.Font = Theme.Font.Bold
    closeButton.TextSize = 12
    closeButton.ZIndex = 82
    closeButton.Parent = modal

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    closeCorner.Parent = closeButton

    local list = Instance.new("ScrollingFrame")
    list.Name = "ItemsList"
    list.Size = UDim2.new(1, -32, 1, -76)
    list.Position = UDim2.new(0, 16, 0, 62)
    list.BackgroundColor3 = Theme.Colors.Background
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.ScrollBarImageColor3 = Theme.Colors.Accent
    list.CanvasSize = UDim2.new(0, 0, 0, 0)
    list.ZIndex = 82
    list.Parent = modal

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    listCorner.Parent = list

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = list

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = list

    local clanForm = Instance.new("Frame")
    clanForm.Name = "ClanCreateForm"
    clanForm.Size = UDim2.new(1, -32, 1, -76)
    clanForm.Position = UDim2.new(0, 16, 0, 62)
    clanForm.BackgroundColor3 = Theme.Colors.Background
    clanForm.BorderSizePixel = 0
    clanForm.Visible = false
    clanForm.ZIndex = 86
    clanForm.Parent = modal

    local clanFormCorner = Instance.new("UICorner")
    clanFormCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    clanFormCorner.Parent = clanForm

    local formPadding = Instance.new("UIPadding")
    formPadding.PaddingTop = UDim.new(0, 12)
    formPadding.PaddingLeft = UDim.new(0, 12)
    formPadding.PaddingRight = UDim.new(0, 12)
    formPadding.Parent = clanForm

    local formTitle = Instance.new("TextLabel")
    formTitle.Name = "FormTitle"
    formTitle.Size = UDim2.new(1, -8, 0, 24)
    formTitle.BackgroundTransparency = 1
    formTitle.Text = "Crear Clan"
    formTitle.TextColor3 = Theme.Colors.Text
    formTitle.Font = Theme.Font.Bold
    formTitle.TextSize = 15
    formTitle.TextXAlignment = Enum.TextXAlignment.Left
    formTitle.ZIndex = 87
    formTitle.Parent = clanForm

    local function createInput(name, placeholder, y)
        local input = Instance.new("TextBox")
        input.Name = name
        input.Size = UDim2.new(1, -8, 0, 34)
        input.Position = UDim2.new(0, 0, 0, y)
        input.BackgroundColor3 = Theme.Colors.PanelLight
        input.BorderSizePixel = 0
        input.PlaceholderText = placeholder
        input.Text = ""
        input.TextColor3 = Theme.Colors.Text
        input.PlaceholderColor3 = Theme.Colors.TextMuted
        input.Font = Theme.Font.Regular
        input.TextSize = 12
        input.TextXAlignment = Enum.TextXAlignment.Left
        input.ClearTextOnFocus = false
        input.ZIndex = 87
        input.Parent = clanForm

        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        inputCorner.Parent = input

        local inputPadding = Instance.new("UIPadding")
        inputPadding.PaddingLeft = UDim.new(0, 10)
        inputPadding.PaddingRight = UDim.new(0, 10)
        inputPadding.Parent = input

        return input
    end

    local clanNameInput = createInput("ClanNameInput", "Nombre del clan", 34)
    local clanTagInput = createInput("ClanTagInput", "Tag corto, ejemplo SC", 76)

    local selectedColorIndex = 1
    local selectedStyleIndex = 1

    local function getSelectedColorOption()
        return COLOR_OPTIONS[selectedColorIndex]
    end

    local function getSelectedStyleOption()
        return STYLE_OPTIONS[selectedStyleIndex]
    end

    local colorButton = Instance.new("TextButton")
    colorButton.Name = "ColorButton"
    colorButton.Size = UDim2.new(0.5, -8, 0, 32)
    colorButton.Position = UDim2.new(0, 0, 0, 120)
    colorButton.BackgroundColor3 = getSelectedColorOption().color
    colorButton.BorderSizePixel = 0
    colorButton.Text = "Color: " .. getSelectedColorOption().label
    colorButton.TextColor3 = Theme.Colors.Text
    colorButton.Font = Theme.Font.Bold
    colorButton.TextSize = 11
    colorButton.ZIndex = 87
    colorButton.Parent = clanForm

    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    colorCorner.Parent = colorButton

    local styleButton = Instance.new("TextButton")
    styleButton.Name = "StyleButton"
    styleButton.Size = UDim2.new(0.5, -8, 0, 32)
    styleButton.Position = UDim2.new(0.5, 8, 0, 120)
    styleButton.BackgroundColor3 = Theme.Colors.PanelLight
    styleButton.BorderSizePixel = 0
    styleButton.Text = getSelectedStyleOption().label
    styleButton.TextColor3 = Theme.Colors.Text
    styleButton.Font = Theme.Font.Bold
    styleButton.TextSize = 11
    styleButton.ZIndex = 87
    styleButton.Parent = clanForm

    local styleCorner = Instance.new("UICorner")
    styleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    styleCorner.Parent = styleButton

    local cancelClanButton = Instance.new("TextButton")
    cancelClanButton.Name = "CancelClanButton"
    cancelClanButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelClanButton.Position = UDim2.new(0, 0, 1, -46)
    cancelClanButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelClanButton.BorderSizePixel = 0
    cancelClanButton.Text = "Cancelar"
    cancelClanButton.TextColor3 = Theme.Colors.TextMuted
    cancelClanButton.Font = Theme.Font.Bold
    cancelClanButton.TextSize = 12
    cancelClanButton.ZIndex = 87
    cancelClanButton.Parent = clanForm

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelCorner.Parent = cancelClanButton

    local createClanButton = Instance.new("TextButton")
    createClanButton.Name = "CreateClanButton"
    createClanButton.Size = UDim2.new(0.5, -8, 0, 34)
    createClanButton.Position = UDim2.new(0.5, 8, 1, -46)
    createClanButton.BackgroundColor3 = CATEGORY_COLORS.clan
    createClanButton.BorderSizePixel = 0
    createClanButton.Text = "Crear"
    createClanButton.TextColor3 = Theme.Colors.Text
    createClanButton.Font = Theme.Font.Bold
    createClanButton.TextSize = 12
    createClanButton.ZIndex = 87
    createClanButton.Parent = clanForm

    local createCorner = Instance.new("UICorner")
    createCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    createCorner.Parent = createClanButton

    local chatStyleForm = Instance.new("Frame")
    chatStyleForm.Name = "ChatStyleForm"
    chatStyleForm.Size = UDim2.new(1, -32, 1, -76)
    chatStyleForm.Position = UDim2.new(0, 16, 0, 62)
    chatStyleForm.BackgroundColor3 = Theme.Colors.Background
    chatStyleForm.BorderSizePixel = 0
    chatStyleForm.Visible = false
    chatStyleForm.ZIndex = 86
    chatStyleForm.Parent = modal

    local chatStyleCorner = Instance.new("UICorner")
    chatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    chatStyleCorner.Parent = chatStyleForm

    local chatStylePadding = Instance.new("UIPadding")
    chatStylePadding.PaddingTop = UDim.new(0, 12)
    chatStylePadding.PaddingLeft = UDim.new(0, 12)
    chatStylePadding.PaddingRight = UDim.new(0, 12)
    chatStylePadding.Parent = chatStyleForm

    local chatStyleTitle = Instance.new("TextLabel")
    chatStyleTitle.Name = "ChatStyleTitle"
    chatStyleTitle.Size = UDim2.new(1, -8, 0, 24)
    chatStyleTitle.BackgroundTransparency = 1
    chatStyleTitle.Text = "Chat Personalizado"
    chatStyleTitle.TextColor3 = Theme.Colors.Text
    chatStyleTitle.Font = Theme.Font.Bold
    chatStyleTitle.TextSize = 15
    chatStyleTitle.TextXAlignment = Enum.TextXAlignment.Left
    chatStyleTitle.ZIndex = 87
    chatStyleTitle.Parent = chatStyleForm

    local chatStyleHint = Instance.new("TextLabel")
    chatStyleHint.Name = "ChatStyleHint"
    chatStyleHint.Size = UDim2.new(1, -8, 0, 34)
    chatStyleHint.Position = UDim2.new(0, 0, 0, 26)
    chatStyleHint.BackgroundTransparency = 1
    chatStyleHint.Text = "Elige el estilo que quieres usar en tus mensajes."
    chatStyleHint.TextColor3 = Theme.Colors.TextMuted
    chatStyleHint.Font = Theme.Font.Regular
    chatStyleHint.TextSize = 12
    chatStyleHint.TextWrapped = true
    chatStyleHint.TextXAlignment = Enum.TextXAlignment.Left
    chatStyleHint.ZIndex = 87
    chatStyleHint.Parent = chatStyleForm

    local chatStyleOptions = Instance.new("ScrollingFrame")
    chatStyleOptions.Name = "ChatStyleOptions"
    chatStyleOptions.Size = UDim2.new(1, -8, 1, -126)
    chatStyleOptions.Position = UDim2.new(0, 0, 0, 68)
    chatStyleOptions.BackgroundTransparency = 1
    chatStyleOptions.BorderSizePixel = 0
    chatStyleOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatStyleOptions.AutomaticCanvasSize = Enum.AutomaticSize.Y
    chatStyleOptions.ScrollingDirection = Enum.ScrollingDirection.Y
    chatStyleOptions.ScrollBarThickness = 3
    chatStyleOptions.ScrollBarImageColor3 = CATEGORY_COLORS.chat_style
    chatStyleOptions.ClipsDescendants = true
    chatStyleOptions.ZIndex = 87
    chatStyleOptions.Parent = chatStyleForm

    local chatStyleOptionsLayout = Instance.new("UIListLayout")
    chatStyleOptionsLayout.Padding = UDim.new(0, 8)
    chatStyleOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    chatStyleOptionsLayout.Parent = chatStyleOptions

    local cancelChatStyleButton = Instance.new("TextButton")
    cancelChatStyleButton.Name = "CancelChatStyleButton"
    cancelChatStyleButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelChatStyleButton.Position = UDim2.new(0, 0, 1, -46)
    cancelChatStyleButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelChatStyleButton.BorderSizePixel = 0
    cancelChatStyleButton.Text = "Cancelar"
    cancelChatStyleButton.TextColor3 = Theme.Colors.TextMuted
    cancelChatStyleButton.Font = Theme.Font.Bold
    cancelChatStyleButton.TextSize = 12
    cancelChatStyleButton.ZIndex = 87
    cancelChatStyleButton.Parent = chatStyleForm

    local cancelChatStyleCorner = Instance.new("UICorner")
    cancelChatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelChatStyleCorner.Parent = cancelChatStyleButton

    local applyChatStyleButton = Instance.new("TextButton")
    applyChatStyleButton.Name = "ApplyChatStyleButton"
    applyChatStyleButton.Size = UDim2.new(0.5, -8, 0, 34)
    applyChatStyleButton.Position = UDim2.new(0.5, 8, 1, -46)
    applyChatStyleButton.BackgroundColor3 = CATEGORY_COLORS.chat_style
    applyChatStyleButton.BorderSizePixel = 0
    applyChatStyleButton.Text = "Usar"
    applyChatStyleButton.TextColor3 = Theme.Colors.Text
    applyChatStyleButton.Font = Theme.Font.Bold
    applyChatStyleButton.TextSize = 12
    applyChatStyleButton.ZIndex = 87
    applyChatStyleButton.Parent = chatStyleForm

    local applyChatStyleCorner = Instance.new("UICorner")
    applyChatStyleCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    applyChatStyleCorner.Parent = applyChatStyleButton

    local nameColorForm = Instance.new("Frame")
    nameColorForm.Name = "NameColorForm"
    nameColorForm.Size = UDim2.new(1, -32, 1, -76)
    nameColorForm.Position = UDim2.new(0, 16, 0, 62)
    nameColorForm.BackgroundColor3 = Theme.Colors.Background
    nameColorForm.BorderSizePixel = 0
    nameColorForm.Visible = false
    nameColorForm.ZIndex = 86
    nameColorForm.Parent = modal

    local nameColorCorner = Instance.new("UICorner")
    nameColorCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    nameColorCorner.Parent = nameColorForm

    local nameColorPadding = Instance.new("UIPadding")
    nameColorPadding.PaddingTop = UDim.new(0, 12)
    nameColorPadding.PaddingLeft = UDim.new(0, 12)
    nameColorPadding.PaddingRight = UDim.new(0, 12)
    nameColorPadding.Parent = nameColorForm

    local nameColorTitle = Instance.new("TextLabel")
    nameColorTitle.Name = "NameColorTitle"
    nameColorTitle.Size = UDim2.new(1, -8, 0, 24)
    nameColorTitle.BackgroundTransparency = 1
    nameColorTitle.Text = "Color de Nombre"
    nameColorTitle.TextColor3 = Theme.Colors.Text
    nameColorTitle.Font = Theme.Font.Bold
    nameColorTitle.TextSize = 15
    nameColorTitle.TextXAlignment = Enum.TextXAlignment.Left
    nameColorTitle.ZIndex = 87
    nameColorTitle.Parent = nameColorForm

    local nameColorHint = Instance.new("TextLabel")
    nameColorHint.Name = "NameColorHint"
    nameColorHint.Size = UDim2.new(1, -8, 0, 34)
    nameColorHint.Position = UDim2.new(0, 0, 0, 26)
    nameColorHint.BackgroundTransparency = 1
    nameColorHint.Text = "Elige el color que quieres usar en tu nombre."
    nameColorHint.TextColor3 = Theme.Colors.TextMuted
    nameColorHint.Font = Theme.Font.Regular
    nameColorHint.TextSize = 12
    nameColorHint.TextWrapped = true
    nameColorHint.TextXAlignment = Enum.TextXAlignment.Left
    nameColorHint.ZIndex = 87
    nameColorHint.Parent = nameColorForm

    local nameColorOptions = Instance.new("ScrollingFrame")
    nameColorOptions.Name = "NameColorOptions"
    nameColorOptions.Size = UDim2.new(1, -8, 1, -126)
    nameColorOptions.Position = UDim2.new(0, 0, 0, 68)
    nameColorOptions.BackgroundTransparency = 1
    nameColorOptions.BorderSizePixel = 0
    nameColorOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    nameColorOptions.AutomaticCanvasSize = Enum.AutomaticSize.Y
    nameColorOptions.ScrollingDirection = Enum.ScrollingDirection.Y
    nameColorOptions.ScrollBarThickness = 3
    nameColorOptions.ScrollBarImageColor3 = CATEGORY_COLORS.username_color
    nameColorOptions.ClipsDescendants = true
    nameColorOptions.ZIndex = 87
    nameColorOptions.Parent = nameColorForm

    local nameColorOptionsLayout = Instance.new("UIListLayout")
    nameColorOptionsLayout.Padding = UDim.new(0, 8)
    nameColorOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    nameColorOptionsLayout.Parent = nameColorOptions

    local cancelNameColorButton = Instance.new("TextButton")
    cancelNameColorButton.Name = "CancelNameColorButton"
    cancelNameColorButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelNameColorButton.Position = UDim2.new(0, 0, 1, -46)
    cancelNameColorButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelNameColorButton.BorderSizePixel = 0
    cancelNameColorButton.Text = "Cancelar"
    cancelNameColorButton.TextColor3 = Theme.Colors.TextMuted
    cancelNameColorButton.Font = Theme.Font.Bold
    cancelNameColorButton.TextSize = 12
    cancelNameColorButton.ZIndex = 87
    cancelNameColorButton.Parent = nameColorForm

    local cancelNameColorCorner = Instance.new("UICorner")
    cancelNameColorCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelNameColorCorner.Parent = cancelNameColorButton

    local applyNameColorButton = Instance.new("TextButton")
    applyNameColorButton.Name = "ApplyNameColorButton"
    applyNameColorButton.Size = UDim2.new(0.5, -8, 0, 34)
    applyNameColorButton.Position = UDim2.new(0.5, 8, 1, -46)
    applyNameColorButton.BackgroundColor3 = CATEGORY_COLORS.username_color
    applyNameColorButton.BorderSizePixel = 0
    applyNameColorButton.Text = "Usar"
    applyNameColorButton.TextColor3 = Theme.Colors.Text
    applyNameColorButton.Font = Theme.Font.Bold
    applyNameColorButton.TextSize = 12
    applyNameColorButton.ZIndex = 87
    applyNameColorButton.Parent = nameColorForm

    local applyNameColorCorner = Instance.new("UICorner")
    applyNameColorCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    applyNameColorCorner.Parent = applyNameColorButton

    local backgroundDesignForm = Instance.new("Frame")
    backgroundDesignForm.Name = "BackgroundDesignForm"
    backgroundDesignForm.Size = UDim2.new(1, -32, 1, -76)
    backgroundDesignForm.Position = UDim2.new(0, 16, 0, 62)
    backgroundDesignForm.BackgroundColor3 = Theme.Colors.Background
    backgroundDesignForm.BorderSizePixel = 0
    backgroundDesignForm.Visible = false
    backgroundDesignForm.ZIndex = 86
    backgroundDesignForm.Parent = modal

    local backgroundDesignCorner = Instance.new("UICorner")
    backgroundDesignCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    backgroundDesignCorner.Parent = backgroundDesignForm

    local backgroundDesignPadding = Instance.new("UIPadding")
    backgroundDesignPadding.PaddingTop = UDim.new(0, 12)
    backgroundDesignPadding.PaddingLeft = UDim.new(0, 12)
    backgroundDesignPadding.PaddingRight = UDim.new(0, 12)
    backgroundDesignPadding.Parent = backgroundDesignForm

    local backgroundDesignTitle = Instance.new("TextLabel")
    backgroundDesignTitle.Name = "BackgroundDesignTitle"
    backgroundDesignTitle.Size = UDim2.new(1, -8, 0, 24)
    backgroundDesignTitle.BackgroundTransparency = 1
    backgroundDesignTitle.Text = "Diseño de Fondo"
    backgroundDesignTitle.TextColor3 = Theme.Colors.Text
    backgroundDesignTitle.Font = Theme.Font.Bold
    backgroundDesignTitle.TextSize = 15
    backgroundDesignTitle.TextXAlignment = Enum.TextXAlignment.Left
    backgroundDesignTitle.ZIndex = 87
    backgroundDesignTitle.Parent = backgroundDesignForm

    local backgroundDesignHint = Instance.new("TextLabel")
    backgroundDesignHint.Name = "BackgroundDesignHint"
    backgroundDesignHint.Size = UDim2.new(1, -8, 0, 34)
    backgroundDesignHint.Position = UDim2.new(0, 0, 0, 26)
    backgroundDesignHint.BackgroundTransparency = 1
    backgroundDesignHint.Text = "Elige el fondo que quieres mostrar en tu perfil."
    backgroundDesignHint.TextColor3 = Theme.Colors.TextMuted
    backgroundDesignHint.Font = Theme.Font.Regular
    backgroundDesignHint.TextSize = 12
    backgroundDesignHint.TextWrapped = true
    backgroundDesignHint.TextXAlignment = Enum.TextXAlignment.Left
    backgroundDesignHint.ZIndex = 87
    backgroundDesignHint.Parent = backgroundDesignForm

    local backgroundDesignOptions = Instance.new("ScrollingFrame")
    backgroundDesignOptions.Name = "BackgroundDesignOptions"
    backgroundDesignOptions.Size = UDim2.new(1, -14, 1, -126)
    backgroundDesignOptions.Position = UDim2.new(0, 0, 0, 68)
    backgroundDesignOptions.BackgroundTransparency = 1
    backgroundDesignOptions.BorderSizePixel = 0
    backgroundDesignOptions.CanvasSize = UDim2.new(0, 0, 0, 0)
    backgroundDesignOptions.AutomaticCanvasSize = Enum.AutomaticSize.Y
    backgroundDesignOptions.ScrollingDirection = Enum.ScrollingDirection.Y
    backgroundDesignOptions.ScrollBarThickness = 3
    backgroundDesignOptions.ScrollBarImageColor3 = Theme.Colors.TextMuted
    backgroundDesignOptions.ClipsDescendants = true
    backgroundDesignOptions.ZIndex = 87
    backgroundDesignOptions.Parent = backgroundDesignForm

    local backgroundDesignOptionsLayout = Instance.new("UIListLayout")
    backgroundDesignOptionsLayout.Padding = UDim.new(0, 8)
    backgroundDesignOptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    backgroundDesignOptionsLayout.Parent = backgroundDesignOptions

    local cancelBackgroundDesignButton = Instance.new("TextButton")
    cancelBackgroundDesignButton.Name = "CancelBackgroundDesignButton"
    cancelBackgroundDesignButton.Size = UDim2.new(0.5, -8, 0, 34)
    cancelBackgroundDesignButton.Position = UDim2.new(0, 0, 1, -46)
    cancelBackgroundDesignButton.BackgroundColor3 = Theme.Colors.PanelLight
    cancelBackgroundDesignButton.BorderSizePixel = 0
    cancelBackgroundDesignButton.Text = "Cancelar"
    cancelBackgroundDesignButton.TextColor3 = Theme.Colors.TextMuted
    cancelBackgroundDesignButton.Font = Theme.Font.Bold
    cancelBackgroundDesignButton.TextSize = 12
    cancelBackgroundDesignButton.ZIndex = 87
    cancelBackgroundDesignButton.Parent = backgroundDesignForm

    local cancelBackgroundDesignCorner = Instance.new("UICorner")
    cancelBackgroundDesignCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    cancelBackgroundDesignCorner.Parent = cancelBackgroundDesignButton

    local applyBackgroundDesignButton = Instance.new("TextButton")
    applyBackgroundDesignButton.Name = "ApplyBackgroundDesignButton"
    applyBackgroundDesignButton.Size = UDim2.new(0.5, -8, 0, 34)
    applyBackgroundDesignButton.Position = UDim2.new(0.5, 8, 1, -46)
    applyBackgroundDesignButton.BackgroundColor3 = CATEGORY_COLORS.profile_banner
    applyBackgroundDesignButton.BorderSizePixel = 0
    applyBackgroundDesignButton.Text = "Usar"
    applyBackgroundDesignButton.TextColor3 = Theme.Colors.Text
    applyBackgroundDesignButton.Font = Theme.Font.Bold
    applyBackgroundDesignButton.TextSize = 12
    applyBackgroundDesignButton.ZIndex = 87
    applyBackgroundDesignButton.Parent = backgroundDesignForm

    local applyBackgroundDesignCorner = Instance.new("UICorner")
    applyBackgroundDesignCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
    applyBackgroundDesignCorner.Parent = applyBackgroundDesignButton

    local selectedChatStyleItemId = nil
    local selectedChatStyleValue = nil
    local selectedChatStyleRows = {}
    local chatStyleUseCallback = nil
    local selectedNameColorItemId = nil
    local selectedNameColorValue = nil
    local selectedNameColorRows = {}
    local nameColorUseCallback = nil
    local selectedBackgroundDesignItemId = nil
    local selectedBackgroundDesignValue = nil
    local selectedBackgroundDesignRows = {}
    local backgroundDesignUseCallback = nil

    local function clearList()
        for _, child in ipairs(list:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end
    end

    local function setStatus(message, isError)
        if _G.StrikeChatI18n then
            statusLabel.Text = _G.StrikeChatI18n.TranslateText(message or "")
        else
            statusLabel.Text = message or ""
        end

        statusLabel.TextColor3 = isError and Color3.fromRGB(255, 120, 120) or Theme.Colors.TextMuted
    end

    local function showList()
        clanForm.Visible = false
        chatStyleForm.Visible = false
        nameColorForm.Visible = false
        backgroundDesignForm.Visible = false
        list.Visible = true
    end

    local function showClanForm()
        list.Visible = false
        chatStyleForm.Visible = false
        nameColorForm.Visible = false
        backgroundDesignForm.Visible = false
        clanForm.Visible = true
        setStatus("Completa los datos para crear tu clan.", false)
    end

    local function clearChatStyleOptions()
        for _, child in ipairs(chatStyleOptions:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        selectedChatStyleRows = {}
    end

    local function clearNameColorOptions()
        for _, child in ipairs(nameColorOptions:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        selectedNameColorRows = {}
    end

    local function clearBackgroundDesignOptions()
        for _, child in ipairs(backgroundDesignOptions:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                child:Destroy()
            end
        end

        selectedBackgroundDesignRows = {}
    end

    local function setSelectedChatStyle(itemId, styleValue)
        selectedChatStyleItemId = itemId
        selectedChatStyleValue = styleValue
        local selectedKey = tostring(itemId or "") .. ":" .. tostring(styleValue or "")

        for rowKey, row in pairs(selectedChatStyleRows) do
            row.BackgroundColor3 = rowKey == selectedKey and CATEGORY_COLORS.chat_style or Theme.Colors.PanelLight
        end
    end

    local function showChatStyleForm(items, onUse)
        list.Visible = false
        clanForm.Visible = false
        nameColorForm.Visible = false
        backgroundDesignForm.Visible = false
        chatStyleForm.Visible = true
        chatStyleUseCallback = onUse
        selectedChatStyleItemId = nil
        selectedChatStyleValue = nil

        clearChatStyleOptions()

        local firstAvailableItemId = nil
        local firstAvailableStyleValue = nil

        for _, entry in ipairs(items or {}) do
            local item = getInventoryEntryData(entry)

            if item.category == "chat_style" then
                local styleOptions = {}

                if item.item_id == CUSTOM_CHAT_ITEM_ID then
                    styleOptions = CUSTOM_CHAT_STYLES
                else
                    local styleValue = tostring(item.value or item.item_id or "")

                    styleOptions = {
                        {
                            value = styleValue,
                            label = CHAT_STYLE_NAMES[styleValue] or tostring(item.name or "Estilo")
                        }
                    }
                end

                for _, styleOption in ipairs(styleOptions) do
                    local isStyleEquipped = tostring(entry.active_chat_style or "") == styleOption.value
                    local option = Instance.new("TextButton")
                    option.Name = "ChatStyleOption"
                    option.Size = UDim2.new(1, 0, 0, 38)
                    option.BackgroundColor3 = Theme.Colors.PanelLight
                    option.BorderSizePixel = 0
                    option.Text = styleOption.label .. (isStyleEquipped and "  En uso" or "")
                    option.TextColor3 = Theme.Colors.Text
                    option.Font = Theme.Font.Bold
                    option.TextSize = 12
                    option.TextXAlignment = Enum.TextXAlignment.Left
                    option.ZIndex = 88
                    option.Parent = chatStyleOptions

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
                    optionCorner.Parent = option

                    local optionPadding = Instance.new("UIPadding")
                    optionPadding.PaddingLeft = UDim.new(0, 12)
                    optionPadding.PaddingRight = UDim.new(0, 12)
                    optionPadding.Parent = option

                    local rowKey = tostring(item.item_id or "") .. ":" .. tostring(styleOption.value or "")
                    selectedChatStyleRows[rowKey] = option

                    if not firstAvailableItemId and not isStyleEquipped then
                        firstAvailableItemId = item.item_id
                        firstAvailableStyleValue = styleOption.value
                    end

                    option.MouseButton1Click:Connect(function()
                        if not isStyleEquipped then
                            setSelectedChatStyle(item.item_id, styleOption.value)
                        end
                    end)
                end
            end
        end

        if firstAvailableItemId then
            setSelectedChatStyle(firstAvailableItemId, firstAvailableStyleValue)
            setStatus("Selecciona el estilo de chat que quieres usar.", false)
        else
            setStatus("No tienes estilos de chat disponibles para aplicar.", true)
        end
    end

    local function setSelectedNameColor(itemId, colorValue)
        selectedNameColorItemId = itemId
        selectedNameColorValue = colorValue

        for rowKey, row in pairs(selectedNameColorRows) do
            row.BackgroundColor3 = rowKey == colorValue and CATEGORY_COLORS.username_color or Theme.Colors.PanelLight
        end
    end

    local function showNameColorForm(items, onUse)
        list.Visible = false
        clanForm.Visible = false
        chatStyleForm.Visible = false
        backgroundDesignForm.Visible = false
        nameColorForm.Visible = true
        nameColorUseCallback = onUse
        selectedNameColorItemId = nil
        selectedNameColorValue = nil

        clearNameColorOptions()

        local firstUsernameColorItem = nil
        local firstAvailableColor = nil
        local activeUsernameColor = nil

        for _, entry in ipairs(items or {}) do
            local item = getInventoryEntryData(entry)

            if item.category == "username_color" then
                firstUsernameColorItem = firstUsernameColorItem or item.item_id
                activeUsernameColor = activeUsernameColor or entry.active_username_color
            end
        end

        if not firstUsernameColorItem then
            setStatus("No tienes color de nombre disponible para aplicar.", true)
            return
        end

        for _, colorOption in ipairs(USERNAME_COLOR_OPTIONS) do
            local isColorEquipped = tostring(activeUsernameColor or "") == colorOption.value
            local option = Instance.new("TextButton")
            option.Name = "NameColorOption"
            option.Size = UDim2.new(1, 0, 0, 38)
            option.BackgroundColor3 = Theme.Colors.PanelLight
            option.BorderSizePixel = 0
            option.Text = colorOption.label .. (isColorEquipped and "  En uso" or "")
            option.TextColor3 = Theme.Colors.Text
            option.Font = Theme.Font.Bold
            option.TextSize = 12
            option.TextXAlignment = Enum.TextXAlignment.Left
            option.ZIndex = 88
            option.Parent = nameColorOptions

            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
            optionCorner.Parent = option

            local optionStroke = Instance.new("UIStroke")
            optionStroke.Color = colorOption.color
            optionStroke.Thickness = 1
            optionStroke.Transparency = isColorEquipped and 0.05 or 0.35
            optionStroke.Parent = option

            local optionPadding = Instance.new("UIPadding")
            optionPadding.PaddingLeft = UDim.new(0, 12)
            optionPadding.PaddingRight = UDim.new(0, 12)
            optionPadding.Parent = option

            selectedNameColorRows[colorOption.value] = option

            if not firstAvailableColor and not isColorEquipped then
                firstAvailableColor = colorOption.value
            end

            option.MouseButton1Click:Connect(function()
                if not isColorEquipped then
                    setSelectedNameColor(firstUsernameColorItem, colorOption.value)
                end
            end)
        end

        if firstAvailableColor then
            setSelectedNameColor(firstUsernameColorItem, firstAvailableColor)
            setStatus("Selecciona el color de nombre que quieres usar.", false)
        else
            setStatus("Ya estas usando el color seleccionado.", false)
        end
    end

    local function setSelectedBackgroundDesign(itemId, designValue)
        selectedBackgroundDesignItemId = itemId
        selectedBackgroundDesignValue = designValue

        for rowKey, row in pairs(selectedBackgroundDesignRows) do
            if rowKey == designValue then
                row.Button.BackgroundColor3 = Color3.fromRGB(74, 76, 86)
            elseif row.IsEquipped then
                row.Button.BackgroundColor3 = Color3.fromRGB(62, 66, 76)
            else
                row.Button.BackgroundColor3 = Theme.Colors.PanelLight
            end
        end
    end

    local function getActiveBackgroundDesign(entry)
        local activeBackground = entry.active_profile_banner or entry.profile_banner_id or DEFAULT_BACKGROUND_DESIGN_VALUE
        local value = tostring(activeBackground or DEFAULT_BACKGROUND_DESIGN_VALUE):gsub("^%s+", ""):gsub("%s+$", "")

        if value == "" then
            return "none"
        end

        return value
    end

    local function getBackgroundDesignOptions(entry)
        local options = entry.profile_banner_options

        if typeof(options) == "table" and #options > 0 then
            return options
        end

        return DEFAULT_BACKGROUND_DESIGN_OPTIONS
    end

    local function showBackgroundDesignForm(items, onUse)
        list.Visible = false
        clanForm.Visible = false
        chatStyleForm.Visible = false
        nameColorForm.Visible = false
        backgroundDesignForm.Visible = true
        backgroundDesignUseCallback = onUse
        selectedBackgroundDesignItemId = nil
        selectedBackgroundDesignValue = nil

        clearBackgroundDesignOptions()

        local backgroundEntry = nil
        local backgroundItem = nil

        for _, entry in ipairs(items or {}) do
            local item = getInventoryEntryData(entry)

            if item.category == "profile_banner" then
                backgroundEntry = entry
                backgroundItem = item
                break
            end
        end

        if not backgroundEntry or not backgroundItem then
            setStatus("No tienes diseños de fondo disponibles.", true)
            return
        end

        local activeBackground = getActiveBackgroundDesign(backgroundEntry)
        local selectedOnOpenDesign = activeBackground

        for _, designOption in ipairs(getBackgroundDesignOptions(backgroundEntry)) do
            local designValue = tostring(designOption.value or "none")
            local designLabel = tostring(designOption.label or designOption.name or "Fondo")
            local isDesignEquipped =
                activeBackground == designValue or
                (activeBackground == "" and designValue == "none")

            local option = Instance.new("TextButton")
            option.Name = "BackgroundDesignOption"
            option.Size = UDim2.new(1, -6, 0, 38)
            option.BackgroundColor3 = isDesignEquipped and Color3.fromRGB(62, 66, 76) or Theme.Colors.PanelLight
            option.BorderSizePixel = 0
            option.Text = ""
            option.TextColor3 = Theme.Colors.Text
            option.Font = Theme.Font.Bold
            option.TextSize = 12
            option.TextXAlignment = Enum.TextXAlignment.Left
            option.ZIndex = 88
            option.Parent = backgroundDesignOptions

            local optionCorner = Instance.new("UICorner")
            optionCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
            optionCorner.Parent = option

            local optionPadding = Instance.new("UIPadding")
            optionPadding.PaddingLeft = UDim.new(0, 12)
            optionPadding.PaddingRight = UDim.new(0, 74)
            optionPadding.Parent = option

            local optionLabel = Instance.new("TextLabel")
            optionLabel.Name = "Label"
            optionLabel.Size = UDim2.new(1, -76, 1, 0)
            optionLabel.BackgroundTransparency = 1
            optionLabel.Text = designLabel
            optionLabel.TextColor3 = Theme.Colors.Text
            optionLabel.Font = Theme.Font.Bold
            optionLabel.TextSize = 12
            optionLabel.TextXAlignment = Enum.TextXAlignment.Left
            optionLabel.TextTruncate = Enum.TextTruncate.AtEnd
            optionLabel.ZIndex = 89
            optionLabel.Active = false
            optionLabel.Parent = option

            local activeLabel = Instance.new("TextLabel")
            activeLabel.Name = "ActiveLabel"
            activeLabel.AnchorPoint = Vector2.new(1, 0.5)
            activeLabel.Size = UDim2.new(0, 58, 0, 18)
            activeLabel.Position = UDim2.new(1, -10, 0.5, 0)
            activeLabel.BackgroundTransparency = 1
            activeLabel.Text = isDesignEquipped and "En uso" or ""
            activeLabel.TextColor3 = CATEGORY_COLORS.profile_banner
            activeLabel.Font = Theme.Font.Bold
            activeLabel.TextSize = 11
            activeLabel.TextXAlignment = Enum.TextXAlignment.Right
            activeLabel.ZIndex = 89
            activeLabel.Active = false
            activeLabel.Parent = option

            selectedBackgroundDesignRows[designValue] = {
                Button = option,
                IsEquipped = isDesignEquipped
            }

            option.MouseButton1Click:Connect(function()
                if not isDesignEquipped then
                    setSelectedBackgroundDesign(backgroundItem.item_id, designValue)
                end
            end)
        end

        if selectedOnOpenDesign then
            setSelectedBackgroundDesign(backgroundItem.item_id, selectedOnOpenDesign)
            setStatus("Selecciona el diseño de fondo que quieres usar.", false)
        else
            setStatus("Ya estas usando el diseño seleccionado.", false)
        end
    end

    local function renderEmpty(message)
        clearList()

        local empty = Instance.new("TextLabel")
        empty.Name = "Empty"
        empty.Size = UDim2.new(1, -10, 0, 118)
        empty.BackgroundTransparency = 1
        if _G.StrikeChatI18n then
            empty.Text = _G.StrikeChatI18n.TranslateText(message or "Todavia no tienes items comprados.")
        else
            empty.Text = message or "Todavia no tienes items comprados."
        end
        empty.TextColor3 = Theme.Colors.TextMuted
        empty.Font = Theme.Font.Regular
        empty.TextSize = 12
        empty.TextWrapped = true
        empty.TextXAlignment = Enum.TextXAlignment.Center
        empty.TextYAlignment = Enum.TextYAlignment.Center
        empty.ZIndex = 83
        empty.Parent = list
    end

    local function renderItem(entry, onUse, onDelete, items)
        local item = getInventoryEntryData(entry)
        local accent = CATEGORY_COLORS[item.category] or Theme.Colors.Accent
        local displayName = tostring(item.name or item.item_id or "Item")
        local displayDescription = tostring(item.description or "")

        if item.category == "username_color" then
            displayName = "Color de nombre"
            displayDescription = "Elige un color para mostrar en tu nombre."
        elseif item.category == "profile_banner" then
            displayName = "Diseño de fondo"
            displayDescription = "Elige un fondo para mostrar en tu perfil."
        end

        local row = Instance.new("Frame")
        row.Name = "InventoryItem"
        row.Size = UDim2.new(1, -4, 0, 74)
        row.BackgroundColor3 = Theme.Colors.PanelLight
        row.BackgroundTransparency = 0.08
        row.BorderSizePixel = 0
        row.ZIndex = 83
        row.Parent = list

        local rowCorner = Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        rowCorner.Parent = row

        local stroke = Instance.new("UIStroke")
        stroke.Color = accent
        stroke.Thickness = 1
        stroke.Transparency = entry.is_equipped and 0.05 or 0.45
        stroke.Parent = row

        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Size = UDim2.new(1, -218, 0, 22)
        name.Position = UDim2.new(0, 12, 0, 9)
        name.BackgroundTransparency = 1
        name.Text = displayName
        name.TextColor3 = Theme.Colors.Text
        name.Font = Theme.Font.Bold
        name.TextSize = 13
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.TextTruncate = Enum.TextTruncate.AtEnd
        name.ZIndex = 84
        name.Parent = row

        local category = Instance.new("TextLabel")
        category.Name = "Category"
        category.Size = UDim2.new(1, -218, 0, 18)
        category.Position = UDim2.new(0, 12, 0, 31)
        category.BackgroundTransparency = 1
        category.Text = CATEGORY_LABELS[item.category] or tostring(item.category or "Item")
        category.TextColor3 = accent
        category.Font = Theme.Font.Bold
        category.TextSize = 11
        category.TextXAlignment = Enum.TextXAlignment.Left
        category.TextTruncate = Enum.TextTruncate.AtEnd
        category.ZIndex = 84
        category.Parent = row

        local description = Instance.new("TextLabel")
        description.Name = "Description"
        description.Size = UDim2.new(1, -218, 0, 18)
        description.Position = UDim2.new(0, 12, 0, 50)
        description.BackgroundTransparency = 1
        description.Text = displayDescription
        description.TextColor3 = Theme.Colors.TextMuted
        description.Font = Theme.Font.Regular
        description.TextSize = 10
        description.TextXAlignment = Enum.TextXAlignment.Left
        description.TextTruncate = Enum.TextTruncate.AtEnd
        description.ZIndex = 84
        description.Parent = row

        local useButton = Instance.new("TextButton")
        useButton.Name = "UseButton"
        useButton.Size = UDim2.new(0, 80, 0, 32)
        useButton.Position = UDim2.new(1, -180, 0.5, -16)
        useButton.BackgroundColor3 = entry.is_equipped and Color3.fromRGB(60, 65, 75) or accent
        useButton.BorderSizePixel = 0
        useButton.Text = entry.is_equipped and "En uso" or "Usar"
        useButton.TextColor3 = Theme.Colors.Text
        useButton.Font = Theme.Font.Bold
        useButton.TextSize = 11
        useButton.AutoButtonColor = entry.can_use and not entry.is_equipped
        useButton.Active = entry.can_use and not entry.is_equipped
        useButton.ZIndex = 84
        useButton.Parent = row

        local useCorner = Instance.new("UICorner")
        useCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        useCorner.Parent = useButton

        local deleteButton = Instance.new("TextButton")
        deleteButton.Name = "DeleteButton"
        deleteButton.Size = UDim2.new(0, 72, 0, 32)
        deleteButton.Position = UDim2.new(1, -88, 0.5, -16)
        deleteButton.BackgroundColor3 = Color3.fromRGB(86, 38, 48)
        deleteButton.BorderSizePixel = 0
        deleteButton.Text = "Eliminar"
        deleteButton.TextColor3 = Color3.fromRGB(255, 210, 216)
        deleteButton.Font = Theme.Font.Bold
        deleteButton.TextSize = 11
        deleteButton.AutoButtonColor = true
        deleteButton.Active = true
        deleteButton.ZIndex = 84
        deleteButton.Visible = item.category ~= "limited_reward"
        deleteButton.Parent = row

        local deleteCorner = Instance.new("UICorner")
        deleteCorner.CornerRadius = UDim.new(0, Theme.Radius.Button)
        deleteCorner.Parent = deleteButton

        if not entry.can_use then
            useButton.Text = "Guardado"
            useButton.BackgroundColor3 = Color3.fromRGB(55, 58, 66)
            useButton.TextColor3 = Theme.Colors.TextMuted
        elseif item.item_id == "clan_ticket" and not entry.is_equipped then
            useButton.Text = "Crear"
        elseif item.category == "username_color" then
            useButton.Text = "Elegir"
            useButton.BackgroundColor3 = accent
            useButton.AutoButtonColor = entry.can_use
            useButton.Active = entry.can_use
        elseif item.category == "chat_style" and (not entry.is_equipped or item.item_id == CUSTOM_CHAT_ITEM_ID) then
            useButton.Text = "Elegir"
            useButton.AutoButtonColor = entry.can_use
            useButton.Active = entry.can_use
        elseif item.category == "profile_banner" then
            useButton.Text = "Elegir fondo"
            useButton.AutoButtonColor = entry.can_use
            useButton.Active = entry.can_use
        end

        useButton.MouseButton1Click:Connect(function()
            if entry.can_use and (
                not entry.is_equipped or
                item.category == "username_color" or
                item.item_id == CUSTOM_CHAT_ITEM_ID or
                item.item_id == BACKGROUND_DESIGN_ITEM_ID
            ) and onUse then
                if item.category == "username_color" then
                    showNameColorForm(items, onUse)
                elseif item.category == "chat_style" then
                    showChatStyleForm(items, onUse)
                elseif item.category == "profile_banner" then
                    showBackgroundDesignForm(items, onUse)
                else
                    onUse(item.item_id)
                end
            end
        end)

        deleteButton.MouseButton1Click:Connect(function()
            if deleteButton.Visible and onDelete then
                onDelete(item.item_id)
            end
        end)
    end

    local function render(items, onUse, onDelete)
        clearList()

        if not items or #items == 0 then
            renderEmpty("Todavia no tienes items comprados.")
            return
        end

        for _, entry in ipairs(items) do
            renderItem(entry, onUse, onDelete, items)
        end

        task.wait()

        list.CanvasSize = UDim2.new(
            0,
            0,
            0,
            layout.AbsoluteContentSize.Y + 22
        )
    end

    closeButton.MouseButton1Click:Connect(function()
        overlay.Visible = false
    end)

    colorButton.MouseButton1Click:Connect(function()
        selectedColorIndex = selectedColorIndex + 1

        if selectedColorIndex > #COLOR_OPTIONS then
            selectedColorIndex = 1
        end

        local option = getSelectedColorOption()

        colorButton.Text = "Color: " .. option.label
        colorButton.BackgroundColor3 = option.color
    end)

    styleButton.MouseButton1Click:Connect(function()
        selectedStyleIndex = selectedStyleIndex + 1

        if selectedStyleIndex > #STYLE_OPTIONS then
            selectedStyleIndex = 1
        end

        styleButton.Text = getSelectedStyleOption().label
    end)

    cancelClanButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    cancelChatStyleButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    cancelNameColorButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    cancelBackgroundDesignButton.MouseButton1Click:Connect(function()
        showList()
        setStatus("", false)
    end)

    applyChatStyleButton.MouseButton1Click:Connect(function()
        if selectedChatStyleItemId and chatStyleUseCallback then
            chatStyleUseCallback(selectedChatStyleItemId, selectedChatStyleValue)
        else
            setStatus("Selecciona un estilo de chat.", true)
        end
    end)

    applyNameColorButton.MouseButton1Click:Connect(function()
        if selectedNameColorItemId and selectedNameColorValue and nameColorUseCallback then
            nameColorUseCallback(selectedNameColorItemId, selectedNameColorValue)
        else
            setStatus("Selecciona un color de nombre.", true)
        end
    end)

    applyBackgroundDesignButton.MouseButton1Click:Connect(function()
        if selectedBackgroundDesignItemId and selectedBackgroundDesignValue and backgroundDesignUseCallback then
            backgroundDesignUseCallback(selectedBackgroundDesignItemId, selectedBackgroundDesignValue)
        else
            setStatus("Selecciona un diseño de fondo.", true)
        end
    end)

    renderEmpty("Abre el inventario para cargar tus items.")

    return {
        Overlay = overlay,
        CloseButton = closeButton,
        StatusLabel = statusLabel,

        Open = function()
            overlay.Visible = true
        end,

        Close = function()
            overlay.Visible = false
        end,

        Render = render,
        RenderEmpty = renderEmpty,
        ShowStatus = setStatus,
        ShowClanForm = showClanForm,
        ShowChatStyleForm = showChatStyleForm,
        ShowNameColorForm = showNameColorForm,
        ShowBackgroundDesignForm = showBackgroundDesignForm,
        ShowList = showList,
        CreateClanButton = createClanButton,

        GetClanFormData = function()
            return {
                name = clanNameInput.Text or "",
                tag = clanTagInput.Text or "",
                color = getSelectedColorOption().value,
                tag_style = getSelectedStyleOption().value
            }
        end,

        Destroy = function()
            overlay:Destroy()
        end
    }
end

return InventoryUI
