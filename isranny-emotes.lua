--- Keybind: "," - Emotes & Animations v4 (FULL PACKAGES)
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Loading...", Text = "Emotes & Anims", Duration = 5})

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

-- Para animaciones completas
env.AnimConnection = nil
env.IdleConnection = nil
env.CurrentAnimTracks = {}

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)

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
Open.Size = UDim2.new(0.05,0,0.114,0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Close"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true
Open.BackgroundTransparency =.5
Open.MouseButton1Up:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
end)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)
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
ModeButton.TextColor3 = Color3.new(1,1,1)
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
WalkButton.TextColor3 = Color3.new(1,1,1)
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
SpeedLabel.BackgroundColor3 = Color3.new(0,0,0)
SpeedLabel.TextColor3 = Color3.new(1,1,1)
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
SpeedUp.BackgroundColor3 = Color3.fromRGB(0,150,0)
SpeedUp.TextColor3 = Color3.new(1,1,1)
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
SpeedDown.BackgroundColor3 = Color3.fromRGB(150,0,0)
SpeedDown.TextColor3 = Color3.new(1,1,1)
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
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1,1)
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
PageLabel.BackgroundColor3 = Color3.new(0,0,0)
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
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1,1)
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
SearchBar.BackgroundColor3 = Color3.new(0,0,0)
SearchBar.TextColor3 = Color3.new(1,1,1)
SearchBar.BackgroundTransparency = 0.3
SearchBar.Parent = BackFrame
Corner:Clone().Parent = SearchBar
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = ELECTRIC_BLUE
SearchStroke.Thickness = 2

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBar.Text:lower()
    for _,btn in pairs(Frame:GetChildren()) do
        if btn:IsA("GuiButton") then
            btn.Visible = text == "" or btn:GetAttribute("name"):lower():find(text)
        end
    end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_,s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

-- ============================================
-- PEGA TUS EMOTES AQUÍ
-- ============================================
local Emotes = {
    { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
}
-- ============================================

-- ============================================
-- 51 ANIMACIONES COMPLETAS
-- ============================================
local Animations = {
    { name = "Zombie", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Ninja", id = 656118852, icon = "rbxthumb://type=Asset&id=656118852&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Toy", id = 782841498, icon = "rbxthumb://type=Asset&id=782841498&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Robot", id = 616160636, icon = "rbxthumb://type=Asset&id=616160636&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Levitation", id = 616157476, icon = "rbxthumb://type=Asset&id=616157476&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Cartoony", id = 616156119, icon = "rbxthumb://type=Asset&id=616156119&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Superhero", id = 616163682, icon = "rbxthumb://type=Asset&id=616163682&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Stylish", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Knight", id = 616159082, icon = "rbxthumb://type=Asset&id=616159082&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Mage", id = 616157476, icon = "rbxthumb://type=Asset&id=616157476&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Pirate", id = 616160636, icon = "rbxthumb://type=Asset&id=616160636&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Elder", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Vampire", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Werewolf", id = 616160636, icon = "rbxthumb://type=Asset&id=616160636&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Astronaut", id = 616157476, icon = "rbxthumb://type=Asset&id=616157476&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Bubbly", id = 616156119, icon = "rbxthumb://type=Asset&id=616156119&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Rthro", id = 2510196951, icon = "rbxthumb://type=Asset&id=2510196951&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Oldschool", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Bold", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Patrol", id = 616159082, icon = "rbxthumb://type=Asset&id=616159082&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Sneak", id = 616160636, icon = "rbxthumb://type=Asset&id=616160636&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Confident", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Adidas Sports", id = 616163682, icon = "rbxthumb://type=Asset&id=616163682&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "NFL", id = 616160636, icon = "rbxthumb://type=Asset&id=616160636&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
    { name = "Catwalk Glam", id = 616156119, icon = "rbxthumb://type=Asset&id=616156119&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
}
-- ============================================

for _,list in pairs({Emotes, Animations}) do
    table.sort(list, function(a,b) return a.name < b.name end)
    for i,v in ipairs(list) do v.sort.alphabeticfirst = i end
end

local function PlayAnimation(name, id)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Limpiar animaciones anteriores
    if currentTrack then currentTrack:Stop() end
    if env.AnimConnection then env.AnimConnection:Disconnect() end
    if env.IdleConnection then env.IdleConnection:Disconnect() end
    for _, track in pairs(env.CurrentAnimTracks) do
        if track then track:Stop() end
    end
    env.CurrentAnimTracks = {}
    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
        track:Stop()
    end

    -- Crear sistema de animaciones
    local animObj = Instance.new("Animation")
    animObj.AnimationId = "rbxassetid://"..id

    local tracks = {}
    local currentState = "idle"

    local function getTrack()
        if not tracks[currentState] then
            tracks[currentState] = hum:LoadAnimation(animObj)
            tracks[currentState].Priority = Enum.AnimationPriority.Movement
            tracks[currentState].Looped = true
            table.insert(env.CurrentAnimTracks, tracks[currentState])
        end
        return tracks[currentState]
    end

    local function playState(state)
        if currentState ~= state and tracks[currentState] then
            tracks[currentState]:Stop(0.2)
        end
        currentState = state
        local track = getTrack()
        if not track.IsPlaying then
            track:Play(0.2, 1, emoteSpeed)
        else
            track:AdjustSpeed(emoteSpeed)
        end
    end

    -- Conectar eventos
    env.AnimConnection = hum.Running:Connect(function(speed)
        if speed > 0.1 then
            playState("walk")
        else
            playState("idle")
        end
    end)

    env.IdleConnection = hum.StateChanged:Connect(function(_, new)
        if new == Enum.HumanoidStateType.Jumping or new == Enum.HumanoidStateType.Freefall then
            playState("jump")
        end
    end)

    -- Iniciar
    playState("idle")

    BackFrame.Visible = false
    Open.Text = "Open"
    StarterGui:SetCore("SendNotification", {Title = "✓ "..name, Text = "Camina y salta para probar", Duration = 3})
end

local function PlayEmote(name, id)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local desc = hum:FindFirstChildOfClass("HumanoidDescription")
    if not desc then desc = Instance.new("HumanoidDescription", hum) end

    if currentTrack then currentTrack:Stop() end
    if env.AnimConnection then env.AnimConnection:Disconnect() end
    if env.IdleConnection then env.IdleConnection:Disconnect() end

    if hum.RigType ~= Enum.HumanoidRigType.R6 then
        local success, track = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(id) end)
        if not success then
            pcall(function() desc:AddEmote(name, id) end)
            success, track = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(id) end)
        end
        if success and track then
            currentTrack = track
            track:AdjustSpeed(emoteSpeed)
            if canWalk then track.Priority = Enum.AnimationPriority.Action end
        end
    end
    BackFrame.Visible = false
    Open.Text = "Open"
end

local function ShowPage(page)
    for _,v in pairs(Frame:GetChildren()) do if not v:IsA("UIGridLayout") then v:Destroy() end end
    local list = currentMode == "Emotes" and Emotes or Animations
    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #list)
    local totalPages = math.ceil(#list / EMOTES_PER_PAGE)
    PageLabel.Text = page.."/"..totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages
    for i = startIdx, endIdx do
        local item = list[i]
        if item then
            local btn = Instance.new("ImageButton")
            btn.Name = tostring(item.id)
            btn:SetAttribute("name", item.name)
            btn.Image = item.icon
            btn.BackgroundTransparency = 0.5
            btn.BackgroundColor3 = Color3.new(0,0,0)
            btn.LayoutOrder = i
            btn.Parent = Frame
            Corner:Clone().Parent = btn
            Instance.new("UIAspectRatioConstraint", btn).AspectType = Enum.AspectType.ScaleWithParentSize
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = ELECTRIC_BLUE
            btnStroke.Thickness = 1.5
            btnStroke.Transparency = 0.6
            btn.MouseButton1Click:Connect(function()
                if currentMode == "Emotes" then PlayEmote(item.name, item.id) else PlayAnimation(item.name, item.id) end
            end)
            btn.MouseEnter:Connect(function() EmoteName.Text = item.name btnStroke.Transparency = 0 btnStroke.Thickness = 2.5 end)
            btn.MouseLeave:Connect(function() btnStroke.Transparency = 0.6 btnStroke.Thickness = 1.5 end)
        end
    end
end

ModeButton.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeButton.Text = currentMode:upper()
    ModeButton.BackgroundColor3 = currentMode == "Emotes" and Color3.fromRGB(0,100,200) or Color3.fromRGB(200,100,0)
    currentPage = 1
    ShowPage(1)
end)

WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: ".. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
    if currentTrack then currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement end
end)

SpeedUp.MouseButton1Click:Connect(function() emoteSpeed = math.min(emoteSpeed + 0.25, 3) SpeedLabel.Text = "Speed: "..emoteSpeed.."x" if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end for _,t in pairs(env.CurrentAnimTracks) do if t then t:AdjustSpeed(emoteSpeed) end end end)
SpeedDown.MouseButton1Click:Connect(function() emoteSpeed = math.max(emoteSpeed - 0.25, 0.25) SpeedLabel.Text = "Speed: "..emoteSpeed.."x" if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end for _,t in pairs(env.CurrentAnimTracks) do if t then t:AdjustSpeed(emoteSpeed) end end end)
PrevPage.MouseButton1Click:Connect(function() if currentPage > 1 then currentPage -= 1 ShowPage(currentPage) end end)
NextPage.MouseButton1Click:Connect(function() local total = math.ceil((currentMode == "Emotes" and #Emotes or #Animations) / EMOTES_PER_PAGE) if currentPage < total then currentPage += 1 ShowPage(currentPage) end end)

LocalPlayer.CharacterAdded:Connect(function() task.wait(1) ShowPage(1) end)
if LocalPlayer.Character then ShowPage(1) end

StarterGui:SetCore("SendNotification",{Title = "Ready!", Text = "Press, to open - 25 anims loaded", Duration = 5})
