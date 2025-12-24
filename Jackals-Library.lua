-- JackalsHub Universal v2.0
-- Compatible: Synapse X, KRNL, Fluxus, Codex, Delta, Solara, Xeno
-- Optimized for low-end devices

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Anti-duplicate injection
if _G.JackalsHub then
    return game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JackalsHub",
        Text = "Already Loaded!",
        Duration = 3
    })
end

_G.JackalsHub = true

-- Universal executor detection
local Executor = {
    Name = "Unknown",
    Version = "1.0"
}

-- Detect executor
if syn then
    Executor.Name = "Synapse X"
    Executor.Version = syn.version or "3.0"
elseif PROTOSMASHER_LOADED then
    Executor.Name = "ProtoSmasher"
elseif KRNL_LOADED then
    Executor.Name = "KRNL"
elseif fluxus then
    Executor.Name = "Fluxus"
elseif identifyexecutor then
    local id = identifyexecutor()
    if id:find("Codex") then
        Executor.Name = "Codex"
    elseif id:find("Delta") then
        Executor.Name = "Delta"
    elseif id:find("Solara") then
        Executor.Name = "Solara"
    end
elseif getexecutorname then
    Executor.Name = getexecutorname()
end

-- Performance Optimization
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Reduce graphics for potato devices
if settings().Rendering then
    settings().Rendering.QualityLevel = 5
    settings().Rendering.EnableFRM = false
    settings().Rendering.MeshCacheSize = 100
end

-- Theme
local Colors = {
    Primary = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(30, 30, 45),
    Tertiary = Color3.fromRGB(40, 40, 60),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(245, 245, 245),
    TextDark = Color3.fromRGB(180, 180, 180),
    Success = Color3.fromRGB(46, 204, 113),
    Warning = Color3.fromRGB(241, 196, 15),
    Danger = Color3.fromRGB(231, 76, 60)
}

local Fonts = {
    Title = Enum.Font.GothamBold,
    Normal = Enum.Font.Gotham,
    Code = Enum.Font.RobotoMono
}

-- Create main screen GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JackalsHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Colors.Primary
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Shadow effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.7
UIStroke.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Colors.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "JackalsHub"
Title.TextColor3 = Colors.Accent
Title.TextSize = 20
Title.Font = Fonts.Title
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(0, 200, 0, 20)
Subtitle.Position = UDim2.new(0, 15, 0, 25)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Universal Executor UI"
Subtitle.TextColor3 = Colors.TextDark
Subtitle.TextSize = 14
Subtitle.Font = Fonts.Normal
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = TopBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundColor3 = Colors.Danger
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "X"
CloseButton.TextColor3 = Colors.Text
CloseButton.TextSize = 16
CloseButton.Font = Fonts.Title
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeButton.BackgroundColor3 = Colors.Warning
MinimizeButton.BackgroundTransparency = 0.3
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Colors.Text
MinimizeButton.TextSize = 16
MinimizeButton.Font = Fonts.Title
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -20, 0, 35)
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Tab Buttons
local Tabs = {
    {Name = "Home", Icon = "🏠"},
    {Name = "Player", Icon = "👤"},
    {Name = "Scripts", Icon = "📜"},
    {Name = "Visuals", Icon = "👁️"},
    {Name = "Settings", Icon = "⚙️"}
}

local CurrentTab = "Home"
local TabButtons = {}

for i, tab in ipairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tab.Name .. "Tab"
    TabButton.Size = UDim2.new(0.2, -4, 1, 0)
    TabButton.Position = UDim2.new((i-1) * 0.2, 0, 0, 0)
    TabButton.BackgroundColor3 = Colors.Secondary
    TabButton.BackgroundTransparency = 0.3
    TabButton.Text = tab.Icon .. " " .. tab.Name
    TabButton.TextColor3 = Colors.Text
    TabButton.TextSize = 14
    TabButton.Font = Fonts.Normal
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    if i == 1 then
        TabButton.BackgroundColor3 = Colors.Accent
        TabButton.BackgroundTransparency = 0.2
    end
    
    table.insert(TabButtons, TabButton)
end

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -100)
ContentFrame.Position = UDim2.new(0, 10, 0, 90)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Create tab contents
local function createHomeTab()
    local HomeTab = Instance.new("ScrollingFrame")
    HomeTab.Name = "HomeTab"
    HomeTab.Size = UDim2.new(1, 0, 1, 0)
    HomeTab.BackgroundTransparency = 1
    HomeTab.ScrollBarThickness = 4
    HomeTab.ScrollBarImageColor3 = Colors.Accent
    HomeTab.Visible = (CurrentTab == "Home")
    HomeTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    HomeTab.Parent = ContentFrame
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.Parent = HomeTab
    
    -- Welcome Card
    local WelcomeCard = Instance.new("Frame")
    WelcomeCard.Size = UDim2.new(1, 0, 0, 120)
    WelcomeCard.BackgroundColor3 = Colors.Secondary
    WelcomeCard.BackgroundTransparency = 0.1
    
    local WelcomeCorner = Instance.new("UICorner")
    WelcomeCorner.CornerRadius = UDim.new(0, 12)
    WelcomeCorner.Parent = WelcomeCard
    
    local WelcomeStroke = Instance.new("UIStroke")
    WelcomeStroke.Color = Colors.Accent
    WelcomeStroke.Thickness = 2
    WelcomeStroke.Parent = WelcomeCard
    
    -- Welcome Text
    local WelcomeTitle = Instance.new("TextLabel")
    WelcomeTitle.Size = UDim2.new(1, -20, 0, 40)
    WelcomeTitle.Position = UDim2.new(0, 10, 0, 10)
    WelcomeTitle.BackgroundTransparency = 1
    WelcomeTitle.Text = "Welcome to JackalsHub!"
    WelcomeTitle.TextColor3 = Colors.Accent
    WelcomeTitle.TextSize = 22
    WelcomeTitle.Font = Fonts.Title
    WelcomeTitle.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeTitle.Parent = WelcomeCard
    
    local WelcomeDesc = Instance.new("TextLabel")
    WelcomeDesc.Size = UDim2.new(1, -20, 0, 60)
    WelcomeDesc.Position = UDim2.new(0, 10, 0, 50)
    WelcomeDesc.BackgroundTransparency = 1
    WelcomeDesc.Text = "Universal executor UI optimized for potato devices\nExecutor: " .. Executor.Name .. " v" .. Executor.Version
    WelcomeDesc.TextColor3 = Colors.TextDark
    WelcomeDesc.TextSize = 14
    WelcomeDesc.Font = Fonts.Normal
    WelcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    WelcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
    WelcomeDesc.Parent = WelcomeCard
    
    WelcomeCard.Parent = HomeTab
    
    -- Stats Cards Container
    local StatsContainer = Instance.new("Frame")
    StatsContainer.Size = UDim2.new(1, 0, 0, 100)
    StatsContainer.Position = UDim2.new(0, 0, 0, 130)
    StatsContainer.BackgroundTransparency = 1
    StatsContainer.Parent = HomeTab
    
    local stats = {
        {Name = "FPS", Value = "60", Color = Colors.Success},
        {Name = "Ping", Value = "50ms", Color = Colors.Accent},
        {Name = "Players", Value = "1/12", Color = Colors.Warning}
    }
    
    for i, stat in ipairs(stats) do
        local StatCard = Instance.new("Frame")
        StatCard.Size = UDim2.new(0.32, -5, 1, 0)
        StatCard.Position = UDim2.new((i-1) * 0.33, 0, 0, 0)
        StatCard.BackgroundColor3 = Colors.Tertiary
        StatCard.BackgroundTransparency = 0.1
        
        local StatCorner = Instance.new("UICorner")
        StatCorner.CornerRadius = UDim.new(0, 10)
        StatCorner.Parent = StatCard
        
        local StatName = Instance.new("TextLabel")
        StatName.Size = UDim2.new(1, -10, 0, 30)
        StatName.Position = UDim2.new(0, 5, 0, 10)
        StatName.BackgroundTransparency = 1
        StatName.Text = stat.Name
        StatName.TextColor3 = Colors.TextDark
        StatName.TextSize = 14
        StatName.Font = Fonts.Normal
        StatName.Parent = StatCard
        
        local StatValue = Instance.new("TextLabel")
        StatValue.Size = UDim2.new(1, -10, 0, 40)
        StatValue.Position = UDim2.new(0, 5, 0, 40)
        StatValue.BackgroundTransparency = 1
        StatValue.Text = stat.Value
        StatValue.TextColor3 = stat.Color
        StatValue.TextSize = 22
        StatValue.Font = Fonts.Title
        StatValue.Parent = StatCard
        
        StatCard.Parent = StatsContainer
    end
    
    -- Quick Scripts
    local QuickScriptsTitle = Instance.new("TextLabel")
    QuickScriptsTitle.Size = UDim2.new(1, 0, 0, 30)
    QuickScriptsTitle.Position = UDim2.new(0, 0, 0, 240)
    QuickScriptsTitle.BackgroundTransparency = 1
    QuickScriptsTitle.Text = "Quick Scripts"
    QuickScriptsTitle.TextColor3 = Colors.Text
    QuickScriptsTitle.TextSize = 18
    QuickScriptsTitle.Font = Fonts.Title
    QuickScriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
    QuickScriptsTitle.Parent = HomeTab
    
    local scripts = {
        {"Infinite Yield", "Load Infinite Yield admin script"},
        {"Fly Script", "Toggle flying mode"},
        {"ESP Players", "See players through walls"},
        {"Speed Hack", "Increase movement speed"}
    }
    
    for i, script in ipairs(scripts) do
        local ScriptButton = Instance.new("TextButton")
        ScriptButton.Size = UDim2.new(1, 0, 0, 40)
        ScriptButton.Position = UDim2.new(0, 0, 0, 240 + (i * 45))
        ScriptButton.BackgroundColor3 = Colors.Secondary
        ScriptButton.BackgroundTransparency = 0.1
        ScriptButton.Text = ""
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = ScriptButton
        
        local ScriptName = Instance.new("TextLabel")
        ScriptName.Size = UDim2.new(0.7, -5, 1, -10)
        ScriptName.Position = UDim2.new(0, 10, 0, 5)
        ScriptName.BackgroundTransparency = 1
        ScriptName.Text = script[1]
        ScriptName.TextColor3 = Colors.Text
        ScriptName.TextSize = 16
        ScriptName.Font = Fonts.Normal
        ScriptName.TextXAlignment = Enum.TextXAlignment.Left
        ScriptName.Parent = ScriptButton
        
        local ScriptDesc = Instance.new("TextLabel")
        ScriptDesc.Size = UDim2.new(0.7, -5, 1, -10)
        ScriptDesc.Position = UDim2.new(0, 10, 0, 20)
        ScriptDesc.BackgroundTransparency = 1
        ScriptDesc.Text = script[2]
        ScriptDesc.TextColor3 = Colors.TextDark
        ScriptDesc.TextSize = 12
        ScriptDesc.Font = Fonts.Normal
        ScriptDesc.TextXAlignment = Enum.TextXAlignment.Left
        ScriptDesc.Parent = ScriptButton
        
        local LoadButton = Instance.new("TextButton")
        LoadButton.Size = UDim2.new(0.25, -10, 0, 30)
        LoadButton.Position = UDim2.new(0.75, 5, 0.5, -15)
        LoadButton.BackgroundColor3 = Colors.Accent
        LoadButton.Text = "LOAD"
        LoadButton.TextColor3 = Colors.Text
        LoadButton.TextSize = 14
        LoadButton.Font = Fonts.Normal
        
        local LoadCorner = Instance.new("UICorner")
        LoadCorner.CornerRadius = UDim.new(0, 6)
        LoadCorner.Parent = LoadButton
        
        LoadButton.Parent = ScriptButton
        ScriptButton.Parent = HomeTab
    end
    
    return HomeTab
end

local function createPlayerTab()
    local PlayerTab = Instance.new("ScrollingFrame")
    PlayerTab.Name = "PlayerTab"
    PlayerTab.Size = UDim2.new(1, 0, 1, 0)
    PlayerTab.BackgroundTransparency = 1
    PlayerTab.ScrollBarThickness = 4
    PlayerTab.ScrollBarImageColor3 = Colors.Accent
    PlayerTab.Visible = (CurrentTab == "Player")
    PlayerTab.AutomaticCanvasSize = Enum.AutomaticSize.Y
    PlayerTab.Parent = ContentFrame
    
    -- Player Info Card
    local PlayerCard = Instance.new("Frame")
    PlayerCard.Size = UDim2.new(1, 0, 0, 150)
    PlayerCard.BackgroundColor3 = Colors.Secondary
    PlayerCard.BackgroundTransparency = 0.1
    
    local PlayerCorner = Instance.new("UICorner")
    PlayerCorner.CornerRadius = UDim.new(0, 12)
    PlayerCorner.Parent = PlayerCard
    
    -- Avatar (Placeholder)
    local AvatarFrame = Instance.new("Frame")
    AvatarFrame.Size = UDim2.new(0, 100, 0, 100)
    AvatarFrame.Position = UDim2.new(0, 20, 0.5, -50)
    AvatarFrame.BackgroundColor3 = Colors.Tertiary
    
    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(0, 50)
    AvatarCorner.Parent = AvatarFrame
    
    local AvatarText = Instance.new("TextLabel")
    AvatarText.Size = UDim2.new(1, 0, 1, 0)
    AvatarText.BackgroundTransparency = 1
    AvatarText.Text = Player.Name:sub(1, 2):upper()
    AvatarText.TextColor3 = Colors.Text
    AvatarText.TextSize = 32
    AvatarText.Font = Fonts.Title
    AvatarText.Parent = AvatarFrame
    
    AvatarFrame.Parent = PlayerCard
    
    -- Player Info
    local PlayerInfo = Instance.new("Frame")
    PlayerInfo.Size = UDim2.new(0, 280, 1, -20)
    PlayerInfo.Position = UDim2.new(0, 140, 0, 10)
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Parent = PlayerCard
    
    local info = {
        {"Username:", Player.Name},
        {"User ID:", tostring(Player.UserId)},
        {"Account Age:", "N/A days"},
        {"Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name}
    }
    
    for i, data in ipairs(info) do
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 0, 25)
        Label.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        Label.BackgroundTransparency = 1
        Label.Text = data[1]
        Label.TextColor3 = Colors.TextDark
        Label.TextSize = 14
        Label.Font = Fonts.Normal
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = PlayerInfo
        
        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.new(1, 0, 0, 25)
        Value.Position = UDim2.new(0, 120, 0, (i-1) * 30)
        Value.BackgroundTransparency = 1
        Value.Text = data[2]
        Value.TextColor3 = Colors.Text
        Value.TextSize = 14
        Value.Font = Fonts.Normal
        Value.TextXAlignment = Enum.TextXAlignment.Left
        Value.Parent = PlayerInfo
    end
    
    PlayerCard.Parent = PlayerTab
    
    -- Player Mods
    local ModsTitle = Instance.new("TextLabel")
    ModsTitle.Size = UDim2.new(1, 0, 0, 30)
    ModsTitle.Position = UDim2.new(0, 0, 0, 160)
    ModsTitle.BackgroundTransparency = 1
    ModsTitle.Text = "Player Modifications"
    ModsTitle.TextColor3 = Colors.Text
    ModsTitle.TextSize = 18
    ModsTitle.Font = Fonts.Title
    ModsTitle.TextXAlignment = Enum.TextXAlignment.Left
    ModsTitle.Parent = PlayerTab
    
    local mods = {
        {"WalkSpeed", 16, 100},
        {"JumpPower", 50, 200},
        {"Gravity", 196.2, 500}
    }
    
    for i, mod in ipairs(mods) do
        local ModFrame = Instance.new("Frame")
        ModFrame.Size = UDim2.new(1, 0, 0, 60)
        ModFrame.Position = UDim2.new(0, 0, 0, 160 + (i * 65))
        ModFrame.BackgroundColor3 = Colors.Tertiary
        ModFrame.BackgroundTransparency = 0.1
        
        local ModCorner = Instance.new("UICorner")
        ModCorner.CornerRadius = UDim.new(0, 8)
        ModCorner.Parent = ModFrame
        
        local ModName = Instance.new("TextLabel")
        ModName.Size = UDim2.new(0.3, -10, 1, 0)
        ModName.Position = UDim2.new(0, 10, 0, 0)
        ModName.BackgroundTransparency = 1
        ModName.Text = mod[1]
        ModName.TextColor3 = Colors.Text
        ModName.TextSize = 16
        ModName.Font = Fonts.Normal
        ModName.TextXAlignment = Enum.TextXAlignment.Left
        ModName.Parent = ModFrame
        
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0.2, -10, 1, 0)
        ValueLabel.Position = UDim2.new(0.3, 10, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(mod[2])
        ValueLabel.TextColor3 = Colors.Accent
        ValueLabel.TextSize = 16
        ValueLabel.Font = Fonts.Normal
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Center
        ValueLabel.Name = mod[1] .. "Value"
        ValueLabel.Parent = ModFrame
        
        local Slider = Instance.new("Frame")
        Slider.Size = UDim2.new(0.5, -20, 0, 20)
        Slider.Position = UDim2.new(0.5, 10, 0.5, -10)
        Slider.BackgroundColor3 = Colors.Secondary
        
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 10)
        SliderCorner.Parent = Slider
        
        local SliderFill = Instance.new("Frame")
        SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        SliderFill.BackgroundColor3 = Colors.Accent
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(0, 10)
        SliderFillCorner.Parent = SliderFill
        
        SliderFill.Parent = Slider
        Slider.Parent = ModFrame
        ModFrame.Parent = PlayerTab
    end
    
    return PlayerTab
end

-- Create all tabs
createHomeTab()
createPlayerTab()

-- Add empty tabs for now
for i = 3, #Tabs do
    local tab = Instance.new("Frame")
    tab.Name = Tabs[i].Name .. "Tab"
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = (CurrentTab == Tabs[i].Name)
    
    local tabText = Instance.new("TextLabel")
    tabText.Size = UDim2.new(1, 0, 0, 50)
    tabText.Position = UDim2.new(0, 0, 0.5, -25)
    tabText.BackgroundTransparency = 1
    tabText.Text = Tabs[i].Name .. " Tab - Coming Soon!"
    tabText.TextColor3 = Colors.Text
    tabText.TextSize = 20
    tabText.Font = Fonts.Title
    tabText.Parent = tab
    
    tab.Parent = ContentFrame
end

-- Function to switch tabs
local function switchTab(tabName)
    CurrentTab = tabName
    
    for _, tab in ipairs(Tabs) do
        local content = ContentFrame:FindFirstChild(tab.Name .. "Tab")
        if content then
            content.Visible = (tab.Name == tabName)
        end
    end
    
    -- Update tab buttons
    for i, button in ipairs(TabButtons) do
        if Tabs[i].Name == tabName then
            button.BackgroundColor3 = Colors.Accent
            button.BackgroundTransparency = 0.2
        else
            button.BackgroundColor3 = Colors.Secondary
            button.BackgroundTransparency = 0.3
        end
    end
end

-- Connect tab buttons
for i, button in ipairs(TabButtons) do
    button.MouseButton1Click:Connect(function()
        switchTab(Tabs[i].Name)
    end)
end

-- Dragging functionality
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Close button
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    _G.JackalsHub = false
end)

-- Minimize button
local minimized = false
local originalSize = MainFrame.Size
local minimizedSize = UDim2.new(0, 450, 0, 40)

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    if minimized then
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = minimizedSize})
        tween:Play()
        ContentFrame.Visible = false
        TabContainer.Visible = false
    else
        local tween = TweenService:Create(MainFrame, tweenInfo, {Size = originalSize})
        tween:Play()
        ContentFrame.Visible = true
        TabContainer.Visible = true
    end
end)

-- FPS Counter
local fps = 0
local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local currentTime = tick()
    
    if currentTime - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = currentTime
        
        -- Update FPS display if it exists
        local fpsLabel = ScreenGui:FindFirstChild("FPSLabel", true)
        if fpsLabel then
            fpsLabel.Text = tostring(fps)
            
            -- Color code based on FPS
            if fps < 20 then
                fpsLabel.TextColor3 = Colors.Danger
            elseif fps < 40 then
                fpsLabel.TextColor3 = Colors.Warning
            else
                fpsLabel.TextColor3 = Colors.Success
            end
        end
    end
end)

-- Ping monitor
local function updatePing()
    local ping = game:GetService("Stats").Network.ServerStatsItem:GetValue()
    local pingLabel = ScreenGui:FindFirstChild("PingLabel", true)
    
    if pingLabel then
        pingLabel.Text = tostring(math.floor(ping)) .. "ms"
        
        if ping > 200 then
            pingLabel.TextColor3 = Colors.Danger
        elseif ping > 100 then
            pingLabel.TextColor3 = Colors.Warning
        else
            pingLabel.TextColor3 = Colors.Success
        end
    end
    
    -- Auto-adjust quality for potato devices
    if fps < 20 then
        settings().Rendering.QualityLevel = 3
    end
end

-- Update ping every 5 seconds
game:GetService("RunService").Heartbeat:Connect(function()
    updatePing()
end)

-- Keybind to toggle UI (F9)
UIS.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode.F9 then
            MainFrame.Visible = not MainFrame.Visible
        elseif input.KeyCode == Enum.KeyCode.Insert then
            -- Alternative toggle key
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- Mobile support
if UIS.TouchEnabled then
    MainFrame.Size = UDim2.new(0, 400, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    
    -- Make buttons bigger for touch
    for _, button in ipairs(TabButtons) do
        button.TextSize = 16
    end
end

-- Final setup
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "JackalsHub",
    Text = "Loaded successfully! Press F9 to toggle",
    Duration = 5,
    Icon = "rbxassetid://4483345998"
})

print("JackalsHub v2.0 loaded - Executor: " .. Executor.Name)
