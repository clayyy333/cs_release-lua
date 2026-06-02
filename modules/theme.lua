local Theme = {}

Theme.Colors = {
    Background = Color3.fromRGB(18, 19, 28),

    Panel = Color3.fromRGB(24, 25, 35),
    Border = Color3.fromRGB(24, 25, 35),

    PanelLight = Color3.fromRGB(35, 37, 52),

    Accent = Color3.fromRGB(110, 82, 230),
    AccentSoft = Color3.fromRGB(110, 82, 230),

    Text = Color3.fromRGB(235, 235, 255),
    TextMuted = Color3.fromRGB(170, 170, 190),

    Danger = Color3.fromRGB(255, 120, 120),
    Success = Color3.fromRGB(120, 255, 170),

    SoftBlack = Color3.fromRGB(15, 16, 22)
}

Theme.Radius = {
    Main = 16,
    Panel = 12,
    Button = 10
}

Theme.Font = {
    Regular = Enum.Font.Gotham,
    Bold = Enum.Font.GothamBold
}

return Theme