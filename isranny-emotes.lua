--- Keybind: "," - Emotes & Animations v4 (FULL PACKAGES - CON REMOTEEVENT)
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then
    return
end
env.LastExecuted = tick()

-- ============================================
-- CREAR REMOTEEVENT SI NO EXISTE
-- ============================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChangeAnimationEvent = ReplicatedStorage:FindFirstChild("ChangeAnimation")

if not ChangeAnimationEvent then
    ChangeAnimationEvent = Instance.new("RemoteEvent")
    ChangeAnimationEvent.Name = "ChangeAnimation"
    ChangeAnimationEvent.Parent = ReplicatedStorage
end

-- ============================================
-- CARGAR GUI
-- ============================================
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Loading...", Text = "Emotes & Anims", Duration = 5})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end
wait(0.5)

local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local currentPage, EMOTES_PER_PAGE = 1, 300
local currentMode = "Emotes"
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)

-- Iconos/Emojis para animaciones
local AnimationIcons = {
    Astronaut = "🚀", Bubbly = "🫧", Cartoony = "🎨", Elder = "👴", Knight = "⚔️",
    Levitation = "🌀", Mage = "🔮", Ninja = "🥷", Pirate = "🏴‍☠️", Robot = "🤖",
    Stylish = "😎", SuperHero = "🦸", Toy = "🧸", Vampire = "🧛", Werewolf = "🐺",
    Zombie = "🧟", Patrol = "👮", Confident = "😏", Popstar = "⭐", Cowboy = "🤠",
    Ghost = "👻", Sneaky = "🥷", Princess = "👸", Anthro = "🐺"
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.9, 0, 0.55, 0)
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
BackFrame.BackgroundTransparency = 1
BackFrame.Parent = ScreenGui

local BackStroke = Instance.new("UIStroke", BackFrame)
BackStroke.Color = ELECTRIC_BLUE
BackStroke.Thickness = 2
BackStroke.Transparency = 0.3

local Open = Instance.new("TextButton")
Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0.05, 0, 0.114, 0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Close"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.new(1, 1, 1)
Open.TextScaled = true
Open.BackgroundTransparency = 0.5
Open.MouseButton1Up:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
end)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1, 0)
local OpenStroke = Instance.new("UIStroke", Open)
OpenStroke.Color = ELECTRIC_BLUE
OpenStroke.Thickness = 2

local Corner = Instance.new("UICorner")

local EmoteName = Instance.new("TextLabel")
EmoteName.Name = "EmoteName"
EmoteName.TextScaled = true
EmoteName.AnchorPoint = Vector2.new(0.5, 0.5)
EmoteName.Position = UDim2.new(-0.1, 0, 0.5, 0)
EmoteName.Size = UDim2.new(0.2, 0, 0.2, 0)
EmoteName.SizeConstraint = Enum.SizeConstraint.RelativeYY
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EmoteName.TextColor3 = Color3.new(1, 1, 1)
EmoteName.Text = "Select"
EmoteName.Parent = BackFrame
Corner:Clone().Parent = EmoteName
local NameStroke = Instance.new("UIStroke", EmoteName)
NameStroke.Color = ELECTRIC_BLUE
NameStroke.Thickness = 2

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.ScrollBarImageColor3 = ELECTRIC_BLUE
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.105, 0, 0, 0)
Grid.CellPadding = UDim2.new(0.006, 0, 0.006, 0)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

local ModeButton = Instance.new("TextButton")
ModeButton.Position = UDim2.new(0.075, 0, -0.075, 0)
ModeButton.Size = UDim2.new(0.15, 0, 0.1, 0)
ModeButton.AnchorPoint = Vector2.new(0.5, 0.5)
ModeButton.Text = "EMOTES"
ModeButton.TextScaled = true
ModeButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ModeButton.TextColor3 = Color3.new(1, 1, 1)
ModeButton.Parent = BackFrame
Corner:Clone().Parent = ModeButton
local ModeStroke = Instance.new("UIStroke", ModeButton)
ModeStroke.Color = ELECTRIC_BLUE
ModeStroke.Thickness = 2

local WalkButton = Instance.new("TextButton")
WalkButton.Position = UDim2.new(0.925, -5, -0.2, 0)
WalkButton.Size = UDim2.new(0.15, 0, 0.08, 0)
WalkButton.AnchorPoint = Vector2.new(0.5, 0.5)
WalkButton.Text = "Walk: OFF"
WalkButton.TextScaled = true
WalkButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
WalkButton.TextColor3 = Color3.new(1, 1, 1)
WalkButton.Parent = BackFrame
Corner:Clone().Parent = WalkButton
local WalkStroke = Instance.new("UIStroke", WalkButton)
WalkStroke.Color = ELECTRIC_BLUE
WalkStroke.Thickness = 2

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.new(0.75, 0, -0.2, 0)
SpeedLabel.Size = UDim2.new(0.12, 0, 0.08, 0)
SpeedLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedLabel.Text = "Speed: 1x"
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundColor3 = Color3.new(0, 0, 0)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 0.3
SpeedLabel.Parent = BackFrame
Corner:Clone().Parent = SpeedLabel
local SpeedLblStroke = Instance.new("UIStroke", SpeedLabel)
SpeedLblStroke.Color = ELECTRIC_BLUE
SpeedLblStroke.Thickness = 2

local SpeedUp = Instance.new("TextButton")
SpeedUp.Position = UDim2.new(0.85, 0, -0.2, 0)
SpeedUp.Size = UDim2.new(0.05, 0, 0.08, 0)
SpeedUp.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedUp.Text = "+"
SpeedUp.TextScaled = true
SpeedUp.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
SpeedUp.TextColor3 = Color3.new(1, 1, 1)
SpeedUp.Parent = BackFrame
Corner:Clone().Parent = SpeedUp
local UpStroke = Instance.new("UIStroke", SpeedUp)
UpStroke.Color = ELECTRIC_BLUE
UpStroke.Thickness = 2

local SpeedDown = Instance.new("TextButton")
SpeedDown.Position = UDim2.new(0.65, 0, -0.2, 0)
SpeedDown.Size = UDim2.new(0.05, 0, 0.08, 0)
SpeedDown.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedDown.Text = "-"
SpeedDown.TextScaled = true
SpeedDown.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
SpeedDown.TextColor3 = Color3.new(1, 1, 1)
SpeedDown.Parent = BackFrame
Corner:Clone().Parent = SpeedDown
local DownStroke = Instance.new("UIStroke", SpeedDown)
DownStroke.Color = ELECTRIC_BLUE
DownStroke.Thickness = 2

local PrevPage = Instance.new("TextButton")
PrevPage.Position = UDim2.new(0.25, 0, -0.075, 0)
PrevPage.Size = UDim2.new(0.08, 0, 0.1, 0)
PrevPage.AnchorPoint = Vector2.new(0.5, 0.5)
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.BackgroundColor3 = Color3.new(0, 0, 0)
PrevPage.TextColor3 = Color3.new(1, 1, 1)
PrevPage.BackgroundTransparency = 0.3
PrevPage.Parent = BackFrame
Corner:Clone().Parent = PrevPage
local PrevStroke = Instance.new("UIStroke", PrevPage)
PrevStroke.Color = ELECTRIC_BLUE
PrevStroke.Thickness = 2

local PageLabel = Instance.new("TextLabel")
PageLabel.Position = UDim2.new(0.34, 0, -0.075, 0)
PageLabel.Size = UDim2.new(0.1, 0, 0.1, 0)
PageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
PageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
PageLabel.BackgroundTransparency = 0.3
PageLabel.Parent = BackFrame
Corner:Clone().Parent = PageLabel
local PageStroke = Instance.new("UIStroke", PageLabel)
PageStroke.Color = ELECTRIC_BLUE
PageStroke.Thickness = 2

local NextPage = Instance.new("TextButton")
NextPage.Position = UDim2.new(0.43, 0, -0.075, 0)
NextPage.Size = UDim2.new(0.08, 0, 0.1, 0)
NextPage.AnchorPoint = Vector2.new(0.5, 0.5)
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.BackgroundColor3 = Color3.new(0, 0, 0)
NextPage.TextColor3 = Color3.new(1, 1, 1)
NextPage.BackgroundTransparency = 0.3
NextPage.Parent = BackFrame
Corner:Clone().Parent = NextPage
local NextStroke = Instance.new("UIStroke", NextPage)
NextStroke.Color = ELECTRIC_BLUE
NextStroke.Thickness = 2

local SearchBar = Instance.new("TextBox")
SearchBar.Position = UDim2.new(0.66, 0, -0.075, 0)
SearchBar.Size = UDim2.new(0.4, 0, 0.1, 0)
SearchBar.AnchorPoint = Vector2.new(0.5, 0.5)
SearchBar.PlaceholderText = "Search"
SearchBar.TextScaled = true
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.BackgroundTransparency = 0.3
SearchBar.Parent = BackFrame
Corner:Clone().Parent = SearchBar
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = ELECTRIC_BLUE
SearchStroke.Thickness = 2

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBar.Text:lower()
    for _, btn in pairs(Frame:GetChildren()) do
        if btn:IsA("GuiButton") then
            btn.Visible = text == "" or btn:GetAttribute("name"):lower():find(text)
        end
    end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_, s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

-- ============================================
-- EMOTES NORMALES (TÚ MISMO PEGARÁS TUS EMOTES AQUÍ)
-- ============================================
local Emotes = {
    -- Ejemplo:
    -- { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" },
}

-- ============================================
-- ANIMACIONES COMPLETAS CON SUS IDs
-- ============================================
local Animations = {
    { name = "Astronaut", walk = 891667138, run = 891636393, idle = 891621366, jump = 891627522, climb = 891609353, fall = 891617961, idle2 = 891633237 },
    { name = "Bubbly", walk = 910034870, run = 910025107, idle = 910004836, jump = 910016857, fall = 910001910, climb = "", idle2 = 910009958, swimidle = 910030921, swim = 910028158 },
    { name = "Cartoony", walk = 742640026, run = 742638842, idle = 742637544, jump = 742637942, fall = 742637151, climb = 742636889, idle2 = 742638445 },
    { name = "Elder", walk = 845403856, run = 845386501, idle = 845397899, jump = 845398858, fall = 845396048, climb = 845392038, idle2 = 845400520 },
    { name = "Knight", walk = 657552124, run = 657564596, idle = 657595757, jump = 658409194, fall = 657600338, climb = 658360781, idle2 = 657568135 },
    { name = "Levitation", walk = 616013216, run = 616010382, idle = 616006778, jump = 616008936, fall = 616005863, climb = 616003713, idle2 = 616008087 },
    { name = "Mage", walk = 707897309, run = 707861613, idle = 707742142, jump = 707853694, fall = 707829716, climb = 707826056, idle2 = 707855907 },
    { name = "Ninja", walk = 656121766, run = 656118852, idle = 656117400, jump = 656117878, fall = 656115606, climb = 656114359, idle2 = 656118341 },
    { name = "Pirate", walk = 750785693, run = 750783738, idle = 750781874, jump = 750782230, fall = 750780242, climb = 750779899, idle2 = 750782770 },
    { name = "Robot", walk = 616095330, run = 616091570, idle = 616088211, jump = 616090535, fall = 616087089, climb = 616086039, idle2 = 616089559 },
    { name = "Stylish", walk = 616146177, run = 616140816, idle = 616136790, jump = 616139451, fall = 616134815, climb = 616133594, idle2 = 616138447 },
    { name = "SuperHero", walk = 616122287, run = 616117076, idle = 616111295, jump = 616115533, fall = 616108001, climb = 616104706, idle2 = 616113536 },
    { name = "Toy", walk = 782843345, run = 782842708, idle = 782841498, jump = 782847020, fall = 782846423, climb = 782843869, idle2 = 782845736 },
    { name = "Vampire", walk = 1083473930, run = 1083462077, idle = 1083445855, jump = 1083455352, fall = 1083443587, climb = 1083439238, idle2 = 1083450166 },
    { name = "Werewolf", walk = 1083178339, run = 1083216690, idle = 1083195517, jump = 1083218792, fall = 1083189019, climb = 1083182000, idle2 = 1083214717 },
    { name = "Zombie", walk = 616168032, run = 616163682, idle = 616158929, jump = 616161997, fall = 616157476, climb = 616156119, idle2 = 616160636 },
    { name = "Patrol", walk = 1151231493, run = 1150967949, idle = 1149612882, jump = 1148811837, fall = 1148863382, climb = 1148811837, idle2 = 1150842221 },
    { name = "Confident", walk = 1070017263, run = 1070001516, idle = 1069977950, jump = 1069984524, fall = 1069973677, climb = 1069946257, idle2 = 1069987858 },
    { name = "Popstar", walk = 1212980338, run = 1212980348, idle = 1212900985, jump = 1212954642, fall = 1212900995, climb = 1213044953, idle2 = 1150842221 },
    { name = "Cowboy", walk = 1014421541, run = 1014401683, idle = 1014390418, jump = 1014394726, fall = 1014384571, climb = 1014380606, idle2 = 1014398616 },
    { name = "Ghost", walk = 616013216, run = 616013216, idle = 616006778, jump = 616008936, fall = 616005863, climb = "", idle2 = 616008087, swimidle = 616012453, swim = 616011509 },
    { name = "Sneaky", walk = 1132510133, run = 1132494274, idle = 1132473842, jump = 1132489853, fall = 1132469004, climb = 1132461372, idle2 = 1132477671 },
    { name = "Princess", walk = 941028902, run = 941015281, idle = 941003647, jump = 941008832, fall = 941000007, climb = 940996062, idle2 = 941013098 },
    { name = "Anthro", walk = 2510202577, run = 2510198475, idle = 2510196951, jump = 2510197830, fall = 2510195892, climb = 2510192778, idle2 = 2510197257 },
}

-- ============================================
-- ENVIAR ANIMACIÓN AL SERVIDOR (para que todos la vean)
-- ============================================
local function ApplyFullAnimation(animData)
    -- Construir el diccionario de animaciones
    local animationIds = {}
    
    if animData.idle then animationIds.idle = "rbxassetid://" .. animData.idle end
    if animData.idle2 then 
        if not animationIds.idle then animationIds.idle = {} end
        animationIds.idle2 = "rbxassetid://" .. animData.idle2
    end
    if animData.walk then animationIds.walk = "rbxassetid://" .. animData.walk end
    if animData.run then animationIds.run = "rbxassetid://" .. animData.run end
    if animData.jump then animationIds.jump = "rbxassetid://" .. animData.jump end
    if animData.climb and animData.climb ~= "" then animationIds.climb = "rbxassetid://" .. animData.climb end
    if animData.fall then animationIds.fall = "rbxassetid://" .. animData.fall end
    if animData.swim and animData.swim ~= "" then animationIds.swim = "rbxassetid://" .. animData.swim end
    if animData.swimidle and animData.swimidle ~= "" then animationIds.swimidle = "rbxassetid://" .. animData.swimidle end
    
    -- Enviar al servidor
    ChangeAnimationEvent:FireServer(animationIds)
    
    BackFrame.Visible = false
    Open.Text = "Open"
    StarterGui:SetCore("SendNotification", {Title = "✓ " .. animData.name, Text = "Animación aplicada (visible para todos)", Duration = 3})
end

-- Reproducir emote normal (solo local, como estaba antes)
local function PlayEmote(name, id)
    local char = LocalPlayer.Character
    if not char then
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Esperando personaje...", Duration = 2})
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "No se encontró Humanoid", Duration = 2})
        return
    end

    if currentTrack then
        currentTrack:Stop()
        currentTrack = nil
    end

    local success, track = pcall(function()
        return hum:PlayEmoteAndGetAnimTrackById(id)
    end)

    if success and track then
        currentTrack = track
        track:AdjustSpeed(emoteSpeed)
        if canWalk then
            track.Priority = Enum.AnimationPriority.Action
        end
        StarterGui:SetCore("SendNotification", {Title = "✓ " .. name, Text = "Emote reproducido", Duration = 2})
    else
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "No se pudo reproducir: " .. name, Duration = 2})
    end

    BackFrame.Visible = false
    Open.Text = "Open"
end

-- Mostrar página
local function ShowPage(page)
    for _, v in pairs(Frame:GetChildren()) do
        if not v:IsA("UIGridLayout") then
            v:Destroy()
        end
    end

    local list = currentMode == "Emotes" and Emotes or Animations
    if #list == 0 and currentMode == "Emotes" then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 1, 0)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "No hay emotes agregados aún\nPégalos en la lista 'Emotes'"
        emptyLabel.TextColor3 = Color3.new(1, 1, 1)
        emptyLabel.TextScaled = true
        emptyLabel.Parent = Frame
        PageLabel.Text = "0/0"
        PrevPage.Visible = false
        NextPage.Visible = false
        return
    end

    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #list)
    local totalPages = math.ceil(#list / EMOTES_PER_PAGE)

    PageLabel.Text = page .. "/" .. totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages

    for i = startIdx, endIdx do
        local item = list[i]
        if item then
            if currentMode == "Emotes" then
                -- Emotes: ImageButton con ícono real
                local btn = Instance.new("ImageButton")
                btn.Name = tostring(item.id)
                btn:SetAttribute("name", item.name)
                btn.Image = item.icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
                btn.BackgroundTransparency = 0.3
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                btn.LayoutOrder = i
                btn.Parent = Frame

                local aspect = Instance.new("UIAspectRatioConstraint", btn)
                aspect.AspectType = Enum.AspectType.ScaleWithParentSize

                Corner:Clone().Parent = btn

                local btnStroke = Instance.new("UIStroke", btn)
                btnStroke.Color = ELECTRIC_BLUE
                btnStroke.Thickness = 1.5
                btnStroke.Transparency = 0.6

                local tooltip = Instance.new("TextLabel")
                tooltip.Text = item.name
                tooltip.TextScaled = true
                tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                tooltip.BackgroundTransparency = 0.2
                tooltip.TextColor3 = Color3.new(1, 1, 1)
                tooltip.Size = UDim2.new(1, 0, 0.3, 0)
                tooltip.Position = UDim2.new(0, 0, 1, 0)
                tooltip.Visible = false
                tooltip.Parent = btn
                Corner:Clone().Parent = tooltip

                btn.MouseEnter:Connect(function()
                    EmoteName.Text = item.name
                    btnStroke.Transparency = 0
                    btnStroke.Thickness = 2.5
                    tooltip.Visible = true
                end)

                btn.MouseLeave:Connect(function()
                    btnStroke.Transparency = 0.6
                    btnStroke.Thickness = 1.5
                    tooltip.Visible = false
                end)

                btn.MouseButton1Click:Connect(function()
                    PlayEmote(item.name, item.id)
                end)
            else
                -- Animaciones: TextButton con emoji
                local btn = Instance.new("TextButton")
                btn.Name = item.name
                btn:SetAttribute("name", item.name)
                btn.Text = AnimationIcons[item.name] or "🏃"
                btn.TextScaled = true
                btn.TextSize = 30
                btn.BackgroundTransparency = 0.3
                btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.LayoutOrder = i
                btn.Parent = Frame

                local aspect = Instance.new("UIAspectRatioConstraint", btn)
                aspect.AspectType = Enum.AspectType.ScaleWithParentSize

                Corner:Clone().Parent = btn

                local btnStroke = Instance.new("UIStroke", btn)
                btnStroke.Color = ELECTRIC_BLUE
                btnStroke.Thickness = 1.5
                btnStroke.Transparency = 0.6

                local tooltip = Instance.new("TextLabel")
                tooltip.Text = item.name
                tooltip.TextScaled = true
                tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                tooltip.BackgroundTransparency = 0.2
                tooltip.TextColor3 = Color3.new(1, 1, 1)
                tooltip.Size = UDim2.new(1, 0, 0.3, 0)
                tooltip.Position = UDim2.new(0, 0, 1, 0)
                tooltip.Visible = false
                tooltip.Parent = btn
                Corner:Clone().Parent = tooltip

                btn.MouseEnter:Connect(function()
                    EmoteName.Text = item.name
                    btnStroke.Transparency = 0
                    btnStroke.Thickness = 2.5
                    tooltip.Visible = true
                end)

                btn.MouseLeave:Connect(function()
                    btnStroke.Transparency = 0.6
                    btnStroke.Thickness = 1.5
                    tooltip.Visible = false
                end)

                btn.MouseButton1Click:Connect(function()
                    ApplyFullAnimation(item)
                end)
            end
        end
    end
end

-- Eventos de botones
ModeButton.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeButton.Text = currentMode:upper()
    ModeButton.BackgroundColor3 = currentMode == "Emotes" and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(200, 100, 0)
    currentPage = 1
    ShowPage(1)
end)

WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: " .. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    if currentTrack then
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = "Speed: " .. emoteSpeed .. "x"
    if currentTrack then
        currentTrack:AdjustSpeed(emoteSpeed)
    end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = "Speed: " .. emoteSpeed .. "x"
    if currentTrack then
        currentTrack:AdjustSpeed(emoteSpeed)
    end
end)

PrevPage.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        ShowPage(currentPage)
    end
end)

NextPage.MouseButton1Click:Connect(function()
    local list = currentMode == "Emotes" and Emotes or Animations
    local total = math.ceil(#list / EMOTES_PER_PAGE)
    if currentPage < total then
        currentPage = currentPage + 1
        ShowPage(currentPage)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    currentPage = 1
    ShowPage(1)
end)

if LocalPlayer.Character then
    ShowPage(1)
end

StarterGui:SetCore("SendNotification", {
    Title = "Ready!",
    Text = "Press , to open - " .. #Animations .. " anims loaded",
    Duration = 5
})

-- ============================================
-- CREAR EL SCRIPT DEL SERVIDOR AUTOMÁTICAMENTE
-- ============================================
task.wait(1)
local ServerScript = Instance.new("Script")
ServerScript.Name = "AnimationHandler"
ServerScript.Source = [[
-- SERVER SCRIPT - Animation Handler
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("ChangeAnimation")

event.OnServerEvent:Connect(function(player, animData)
    local char = player.Character
    if not char then return end
    
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    
    -- Aplicar animaciones a cada categoría
    for category, animId in pairs(animData) do
        local folder = animate:FindFirstChild(category)
        if folder then
            for _, anim in pairs(folder:GetChildren()) do
                if anim:IsA("Animation") then
                    anim.AnimationId = animId
                end
            end
        end
    end
    
    -- Para el caso especial de idle (tiene Animation1 y Animation2)
    if animData.idle then
        local idleFolder = animate:FindFirstChild("idle")
        if idleFolder then
            local anim1 = idleFolder:FindFirstChild("Animation1")
            local anim2 = idleFolder:FindFirstChild("Animation2")
            if anim1 and anim1:IsA("Animation") then
                anim1.AnimationId = animData.idle
            end
            if anim2 and animData.idle2 and anim2:IsA("Animation") then
                anim2.AnimationId = animData.idle2
            end
        end
    end
    
    -- REINICIAR ANIMATE (importante para que los cambios surtan efecto)
    animate.Disabled = true
    task.wait()
    animate.Disabled = false
end)
]]
ServerScript.Parent = game:GetService("ServerScriptService")

StarterGui:SetCore("SendNotification", {
    Title = "Completo!",
    Text = "Sistema listo - Las animaciones se ven en todos los jugadores",
    Duration = 4
})
