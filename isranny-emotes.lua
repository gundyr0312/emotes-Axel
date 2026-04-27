--- Keybind: "," - Emotes & Animations v4 (FULL PACKAGES)
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then
    return
end
env.LastExecuted = tick()

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
local originalAnimateData = {}

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
    -- { name = "Dance", id = 3185670745, icon = "rbxthumb://type=Asset&id=3185670745&w=150&h=150" },
}

-- ============================================
-- ANIMACIONES COMPLETAS
-- ============================================
local Animations = {
    { name = "Astronaut", ids = { idle = 891621366, idle2 = 891633237, walk = 891667138, run = 891636393, jump = 891627522, climb = 891609353, fall = 891617961 } },
    { name = "Bubbly", ids = { idle = 910004836, idle2 = 910009958, walk = 910034870, run = 910025107, jump = 910016857, fall = 910001910, swimidle = 910030921, swim = 910028158 } },
    { name = "Cartoony", ids = { idle = 742637544, idle2 = 742638445, walk = 742640026, run = 742638842, jump = 742637942, climb = 742636889, fall = 742637151 } },
    { name = "Elder", ids = { idle = 845397899, idle2 = 845400520, walk = 845403856, run = 845386501, jump = 845398858, climb = 845392038, fall = 845396048 } },
    { name = "Knight", ids = { idle = 657595757, idle2 = 657568135, walk = 657552124, run = 657564596, jump = 658409194, climb = 658360781, fall = 657600338 } },
    { name = "Levitation", ids = { idle = 616006778, idle2 = 616008087, walk = 616013216, run = 616010382, jump = 616008936, climb = 616003713, fall = 616005863 } },
    { name = "Mage", ids = { idle = 707742142, idle2 = 707855907, walk = 707897309, run = 707861613, jump = 707853694, climb = 707826056, fall = 707829716 } },
    { name = "Ninja", ids = { idle = 656117400, idle2 = 656118341, walk = 656121766, run = 656118852, jump = 656117878, climb = 656114359, fall = 656115606 } },
    { name = "Pirate", ids = { idle = 750781874, idle2 = 750782770, walk = 750785693, run = 750783738, jump = 750782230, climb = 750779899, fall = 750780242 } },
    { name = "Robot", ids = { idle = 616088211, idle2 = 616089559, walk = 616095330, run = 616091570, jump = 616090535, climb = 616086039, fall = 616087089 } },
    { name = "Stylish", ids = { idle = 616136790, idle2 = 616138447, walk = 616146177, run = 616140816, jump = 616139451, climb = 616133594, fall = 616134815 } },
    { name = "SuperHero", ids = { idle = 616111295, idle2 = 616113536, walk = 616122287, run = 616117076, jump = 616115533, climb = 616104706, fall = 616108001 } },
    { name = "Toy", ids = { idle = 782841498, idle2 = 782845736, walk = 782843345, run = 782842708, jump = 782847020, climb = 782843869, fall = 782846423 } },
    { name = "Vampire", ids = { idle = 1083445855, idle2 = 1083450166, walk = 1083473930, run = 1083462077, jump = 1083455352, climb = 1083439238, fall = 1083443587 } },
    { name = "Werewolf", ids = { idle = 1083195517, idle2 = 1083214717, walk = 1083178339, run = 1083216690, jump = 1083218792, climb = 1083182000, fall = 1083189019 } },
    { name = "Zombie", ids = { idle = 616158929, idle2 = 616160636, walk = 616168032, run = 616163682, jump = 616161997, climb = 616156119, fall = 616157476 } },
    { name = "Patrol", ids = { idle = 1149612882, idle2 = 1150842221, walk = 1151231493, run = 1150967949, jump = 1148811837, climb = 1148811837, fall = 1148863382 } },
    { name = "Confident", ids = { idle = 1069977950, idle2 = 1069987858, walk = 1070017263, run = 1070001516, jump = 1069984524, climb = 1069946257, fall = 1069973677 } },
    { name = "Popstar", ids = { idle = 1212900985, idle2 = 1150842221, walk = 1212980338, run = 1212980348, jump = 1212954642, climb = 1213044953, fall = 1212900995 } },
    { name = "Cowboy", ids = { idle = 1014390418, idle2 = 1014398616, walk = 1014421541, run = 1014401683, jump = 1014394726, climb = 1014380606, fall = 1014384571 } },
    { name = "Ghost", ids = { idle = 616006778, idle2 = 616008087, walk = 616013216, run = 616013216, jump = 616008936, fall = 616005863, swimidle = 616012453, swim = 616011509 } },
    { name = "Sneaky", ids = { idle = 1132473842, idle2 = 1132477671, walk = 1132510133, run = 1132494274, jump = 1132489853, climb = 1132461372, fall = 1132469004 } },
    { name = "Princess", ids = { idle = 941003647, idle2 = 941013098, walk = 941028902, run = 941015281, jump = 941008832, climb = 940996062, fall = 941000007 } },
    { name = "Anthro", ids = { idle = 2510196951, idle2 = 2510197257, walk = 2510202577, run = 2510198475, jump = 2510197830, climb = 2510192778, fall = 2510195892 } },
}

-- ============================================
-- FUNCIONES PRINCIPALES
-- ============================================

-- Guardar animaciones originales
local function SaveOriginalAnimations(animate)
    if not originalAnimateData.saved then
        originalAnimateData = {
            saved = true,
            idle1 = animate.idle.Animation1.AnimationId,
            idle2 = animate.idle.Animation2.AnimationId,
            walk = animate.walk.WalkAnim.AnimationId,
            run = animate.run.RunAnim.AnimationId,
            jump = animate.jump.JumpAnim.AnimationId,
            climb = animate.climb.ClimbAnim.AnimationId,
            fall = animate.fall.FallAnim.AnimationId,
        }
        if animate.swim then
            originalAnimateData.swimidle = animate.swimidle.SwimIdle.AnimationId
            originalAnimateData.swim = animate.swim.Swim.AnimationId
        end
    end
end

-- Restaurar animaciones originales
local function RestoreOriginalAnimations(animate)
    if originalAnimateData.saved then
        animate.idle.Animation1.AnimationId = originalAnimateData.idle1
        animate.idle.Animation2.AnimationId = originalAnimateData.idle2
        animate.walk.WalkAnim.AnimationId = originalAnimateData.walk
        animate.run.RunAnim.AnimationId = originalAnimateData.run
        animate.jump.JumpAnim.AnimationId = originalAnimateData.jump
        animate.climb.ClimbAnim.AnimationId = originalAnimateData.climb
        animate.fall.FallAnim.AnimationId = originalAnimateData.fall
        if animate.swim and originalAnimateData.swim then
            animate.swimidle.SwimIdle.AnimationId = originalAnimateData.swimidle
            animate.swim.Swim.AnimationId = originalAnimateData.swim
        end
    end
end

-- Aplicar animación completa
local function ApplyFullAnimation(animData)
    local char = LocalPlayer.Character
    if not char then
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "Esperando personaje...", Duration = 2})
        return
    end

    local animate = char:FindFirstChild("Animate")
    if not animate then
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "No se encontró el script Animate", Duration = 2})
        return
    end

    SaveOriginalAnimations(animate)

    if animData.ids.idle then
        animate.idle.Animation1.AnimationId = "rbxassetid://" .. animData.ids.idle
    end
    if animData.ids.idle2 then
        animate.idle.Animation2.AnimationId = "rbxassetid://" .. animData.ids.idle2
    end
    if animData.ids.walk then
        animate.walk.WalkAnim.AnimationId = "rbxassetid://" .. animData.ids.walk
    end
    if animData.ids.run then
        animate.run.RunAnim.AnimationId = "rbxassetid://" .. animData.ids.run
    end
    if animData.ids.jump then
        animate.jump.JumpAnim.AnimationId = "rbxassetid://" .. animData.ids.jump
    end
    if animData.ids.climb then
        animate.climb.ClimbAnim.AnimationId = "rbxassetid://" .. animData.ids.climb
    end
    if animData.ids.fall then
        animate.fall.FallAnim.AnimationId = "rbxassetid://" .. animData.ids.fall
    end
    if animData.ids.swimidle and animate.swimidle then
        animate.swimidle.SwimIdle.AnimationId = "rbxassetid://" .. animData.ids.swimidle
    end
    if animData.ids.swim and animate.swim then
        animate.swim.Swim.AnimationId = "rbxassetid://" .. animData.ids.swim
    end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Jump = true
    end

    BackFrame.Visible = false
    Open.Text = "Open"
    StarterGui:SetCore("SendNotification", {Title = "✓ " .. animData.name, Text = "Animación aplicada", Duration = 3})
end

-- Reproducir emote normal
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

    -- Restaurar animaciones originales al usar un emote
    local animate = char:FindFirstChild("Animate")
    if animate and originalAnimateData.saved then
        RestoreOriginalAnimations(animate)
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
    -- Limpiar frame
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
                -- Emotes: usar ImageButton con ícono real
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

                -- Tooltip
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
                -- Animaciones: usar TextButton con emoji
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

                -- Tooltip
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

-- ============================================
-- EVENTOS DE BOTONES
-- ============================================

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

-- Recargar página cuando el personaje reaparezca
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    currentPage = 1
    ShowPage(1)
end)

-- Iniciar
if LocalPlayer.Character then
    ShowPage(1)
end

StarterGui:SetCore("SendNotification", {
    Title = "Ready!",
    Text = "Press , to open - " .. #Animations .. " anims loaded",
    Duration = 5
})
