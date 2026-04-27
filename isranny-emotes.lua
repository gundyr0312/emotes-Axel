--- Keybind: "," - Emotes & Animations v4 (FULL PACKAGES - CON REMOTEEVENT Y SLOTS)
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

-- Iconos/Emojis para animaciones (paquetes)
local AnimationIcons = {
    AdidasCommunity = "👟", AdidasAura = "✨", Oldschool = "🕹️", WickedPopular = "🧙",
    Stylish = "😎", Robot = "🤖", AdidasSports = "⚽", Toy = "🧸", CatwalkGlam = "💃",
    Zombie = "🧟", Mage = "🔮", Rthro = "🦾", Unboxed = "📦", Bold = "💪",
    Cartoony = "🎨", Bubbly = "🫧", Elder = "👴", Vampire = "🧛", Ninja = "🥷",
    NoBoundaries = "🏃", WickedDancing = "💃", Superhero = "🦸", Levitation = "🌀",
    NFL = "🏈", Werewolf = "🐺", Knight = "⚔️", Astronaut = "🚀", Pirate = "🏴‍☠️",
    GlowMotion = "✨", Katseye = "⭐"
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
-- ANIMACIONES (PAQUETES CON SLOTS 1-7)
-- Basado en la lista que me diste
-- ============================================
local Animations = {
    { key = "AdidasCommunity", name = "Adidas Community", slots = {123695349157584, 93993406355955, 106810508343012, 106537993816942, 126354114956642, 124765145869332, 115715495289805} },
    { key = "AdidasAura", name = "Adidas Aura", slots = {140398319728398, 99457463463495, 129527230938281, 123973978164540, 73137983344853, 119007025452432, 75183215343859} },
    { key = "Oldschool", name = "Oldschool", slots = {5319900634, 5319909330, 5319914476, 5319917561, 5319922112, 5319927054, 5319931619} },
    { key = "WickedPopular", name = "Wicked Popular", slots = {135810009801094, 83937116921114, 130373407996664, 101839542383818, 136276875045281, 128475661806875, 133304526526319} },
    { key = "Stylish", name = "Stylish", slots = {619509955, 619511417, 619511648, 619511974, 619512153, 619512450, 619512767} },
    { key = "Robot", name = "Robot", slots = {619521311, 619521521, 619521748, 619522088, 619522386, 619522642, 619522849} },
    { key = "AdidasSports", name = "Adidas Sports", slots = {18538133604, 18538146480, 18538150608, 18538153691, 18538158932, 18538164337, 18538170170} },
    { key = "Toy", name = "Toy", slots = {973766674, 973767371, 973768058, 973770652, 973771666, 973772659, 973773170} },
    { key = "CatwalkGlam", name = "Catwalk Glam", slots = {104741822987331, 72706690305027, 138641066989023, 75036746190467, 101279640971758, 112231179705221, 103190462987721} },
    { key = "Zombie", name = "Zombie", slots = {619535091, 619535616, 619535834, 619536283, 619536621, 619537096, 619537468} },
    { key = "Mage", name = "Mage", slots = {754635032, 754636298, 754636589, 754637084, 754637456, 754638471, 754639239} },
    { key = "Rthro", name = "Rthro", slots = {2510230574, 2510233257, 2510235063, 2510236649, 2510238627, 2510240941, 2510242378} },
    { key = "Unboxed", name = "Unboxed", slots = {117011755848398, 125108870423182, 110418911914024, 114998633936467, 82219139681769, 137392271797713, 128339543796138} },
    { key = "Bold", name = "Bold", slots = {16744204409, 16744207822, 16744209868, 16744212581, 16744214662, 16744217055, 16744219182} },
    { key = "Cartoony", name = "Cartoony", slots = {837009922, 837010234, 837010685, 837011171, 837011741, 837012509, 837013990} },
    { key = "Bubbly", name = "Bubbly", slots = {1018554245, 1018553897, 1018553240, 1018552770, 1018549681, 1018548665, 1018554668} },
    { key = "Elder", name = "Elder", slots = {892267099, 892267521, 892267917, 892268340, 892268710, 892269341, 892265784} },
    { key = "Vampire", name = "Vampire", slots = {1113740510, 1113741192, 1113742092, 1113742359, 1113742618, 1113742944, 1113743239} },
    { key = "Ninja", name = "Ninja", slots = {658830056, 658831143, 658831500, 658832070, 658832408, 658832807, 658833139} },
    { key = "NoBoundaries", name = "No Boundaries", slots = {18755919175, 18755922352, 18755930927, 18755925411, 18755933883, 18755938274, 18755942776} },
    { key = "WickedDancing", name = "Wicked Dancing", slots = {123509187015792, 124742764102674, 79789194522561, 111157411630082, 82682578794949, 135050138303161, 94133616443608} },
    { key = "Superhero", name = "Superhero", slots = {619527470, 619527817, 619528125, 619528412, 619528716, 619529095, 619529601} },
    { key = "Levitation", name = "Levitation", slots = {619541458, 619541867, 619542203, 619542888, 619543231, 619543721, 619544080} },
    { key = "NFL", name = "NFL", slots = {122757794615785, 123307994439772, 101094325978637, 140600227095432, 84823630062362, 136750772888868, 120071305586627} },
    { key = "Werewolf", name = "Werewolf", slots = {1113750642, 1113751657, 1113751889, 1113752285, 1113752682, 1113752975, 1113754738} },
    { key = "Knight", name = "Knight", slots = {734325948, 734326330, 734326679, 734326930, 734327140, 734327363, 734329002} },
    { key = "Astronaut", name = "Astronaut", slots = {1090130630, 1090131576, 1090132063, 1090132507, 1090133099, 1090133583, 1090134016} },
    { key = "Pirate", name = "Pirate", slots = {837023444, 837023892, 837024147, 837024350, 837024662, 837025054, 837025325} },
    { key = "GlowMotion", name = "Glow Motion", slots = {122281742555667, 76868289213402, 72213510878866, 126137138096765, 91745899537026, 78813763153341, 124733969277188} },
    { key = "Katseye", name = "KATSEYE", slots = {130399277423748, 84737112249504, 125286451593779, 121868657321572, 140179859838109, 87465102258861, 105967194765350} },
}

-- ============================================
-- ENVIAR ANIMACIÓN AL SERVIDOR (con slots 1-7)
-- ============================================
local function ApplyFullAnimation(animData)
    -- Enviar los slots completos al servidor
    ChangeAnimationEvent:FireServer(animData.slots)
    
    BackFrame.Visible = false
    Open.Text = "Open"
    StarterGui:SetCore("SendNotification", {Title = "✓ " .. animData.name, Text = "Paquete de animaciones aplicado", Duration = 3})
end

-- Reproducir emote normal (solo local)
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
                btn.Text = AnimationIcons[item.key] or "🎮"
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
    Text = "Press , to open - " .. #Animations .. " animation packs loaded",
    Duration = 5
})

-- ============================================
-- CREAR EL SCRIPT DEL SERVIDOR AUTOMÁTICAMENTE
-- ============================================
task.wait(1)
local ServerScript = Instance.new("Script")
ServerScript.Name = "AnimationHandler"
ServerScript.Source = [[
-- SERVER SCRIPT - Animation Handler (CON SLOTS 1-7)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event = ReplicatedStorage:WaitForChild("ChangeAnimation")

-- Mapeo de slots a tipos de animación
local SlotTypes = {
    [1] = "idle",
    [2] = "walk",
    [3] = "run",
    [4] = "jump",
    [5] = "climb",
    [6] = "fall",
    [7] = "idle2"
}

event.OnServerEvent:Connect(function(player, slots)
    local char = player.Character
    if not char then return end
    
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    
    -- Aplicar cada slot a su categoría correspondiente
    for slot, animId in pairs(slots) do
        local animType = SlotTypes[slot]
        if animType and animId and animId ~= 0 then
            if animType == "idle" or animType == "idle2" then
                -- Para idle, asignar a Animation1 o Animation2
                local idleFolder = animate:FindFirstChild("idle")
                if idleFolder then
                    local animObj = idleFolder:FindFirstChild(animType == "idle" and "Animation1" or "Animation2")
                    if animObj and animObj:IsA("Animation") then
                        animObj.AnimationId = "rbxassetid://" .. animId
                    end
                end
            else
                -- Para walk, run, jump, climb, fall
                local folder = animate:FindFirstChild(animType)
                if folder then
                    for _, anim in pairs(folder:GetChildren()) do
                        if anim:IsA("Animation") then
                            anim.AnimationId = "rbxassetid://" .. animId
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- REINICIAR ANIMATE (importante para que los cambios surtan efecto)
    animate.Disabled = true
    task.wait(0.1)
    animate.Disabled = false
end)

print("Animation Handler con slots 1-7 cargado")
]]
ServerScript.Parent = game:GetService("ServerScriptService")

StarterGui:SetCore("SendNotification", {
    Title = "Completo!",
    Text = "Sistema listo - " .. #Animations .. " paquetes de animaciones disponibles",
    Duration = 4
})
