--- Keybind: "," - Emotes v4 (SOLO EMOTES - FINAL)
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then
    return
end
env.LastExecuted = tick()

-- ============================================
-- CARGAR GUI
-- ============================================
game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Loading...", Text = "Emotes", Duration = 5})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end
wait(0.5)

local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local currentPage, EMOTES_PER_PAGE = 1, 300
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil

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
BackFrame.Visible = false
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
Open.Text = "Open"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.new(1, 1, 1)
Open.TextScaled = true
Open.BackgroundTransparency = 0.5
Open.MouseButton1Up:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
    EmoteName.Text = "Select" -- 🔧 FIX 4: Reset nombre al abrir/cerrar
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
            local name = btn:GetAttribute("name") or ""
            btn.Visible = text == "" or name:lower():find(text)
        end
    end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_, s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
        EmoteName.Text = "Select" -- 🔧 FIX 4: Reset nombre al abrir/cerrar
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

-- ============================================
-- EMOTES
-- ============================================
local Emotes = {
    { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" },
    { name = "Applaud", id = 5915779043, icon = "rbxthumb://type=Asset&id=5915779043&w=150&h=150" },
    { name = "Tilt", id = 3360692915, icon = "rbxthumb://type=Asset&id=3360692915&w=150&h=150" },
    { name = "Eenie 1", id = 75838008464033, icon = "rbxthumb://type=Asset&id=75838008464033&w=150&h=150" },
    { name = "God Floating Aura", id = 135810912344769, icon = "rbxthumb://type=Asset&id=135810912344769&w=150&h=150" }
}

-- Reproducir emote
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
        currentTrack:Destroy()
        currentTrack = nil
    end

    local success, track = pcall(function()
        return hum:PlayEmoteAndGetAnimTrackById(id)
    end)

    -- 🔧 FIX 2: Verificación más robusta
    if success and track then
        currentTrack = track
        if not track.IsPlaying then
            track:Play()
        end
        track:AdjustSpeed(emoteSpeed)
        track.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Idle
        StarterGui:SetCore("SendNotification", {Title = "✓ ".. name, Text = "Emote reproducido", Duration = 2})
    else
        StarterGui:SetCore("SendNotification", {Title = "Error", Text = "No se pudo reproducir: ".. name, Duration = 2})
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

    if #Emotes == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 1, 0)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "No hay emotes agregados\nPégalos en la lista 'Emotes'"
        emptyLabel.TextColor3 = Color3.new(1, 1, 1)
        emptyLabel.TextScaled = true
        emptyLabel.Parent = Frame
        PageLabel.Text = "0/0"
        PrevPage.Visible = false
        NextPage.Visible = false
        return
    end

    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #Emotes)
    local totalPages = math.ceil(#Emotes / EMOTES_PER_PAGE)

    PageLabel.Text = page.. "/".. totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages

    for i = startIdx, endIdx do
        local item = Emotes[i]
        if item then
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
            btnStroke.Thickness = 1 -- 🔧 FIX 3: Empezar en 1
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
                btnStroke.Thickness = 2 -- 🔧 FIX 3: Solo sube a 2
                tooltip.Visible = true
            end)

            btn.MouseLeave:Connect(function()
                btnStroke.Transparency = 0.6
                btnStroke.Thickness = 1 -- 🔧 FIX 3: Vuelve a 1
                tooltip.Visible = false
            end)

            btn.MouseButton1Click:Connect(function()
                PlayEmote(item.name, item.id)
            end)
        end
    end
end

-- Eventos de botones
WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: ".. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    if currentTrack then
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Idle
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
    if currentTrack then
        currentTrack:AdjustSpeed(emoteSpeed)
    end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
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
    local total = math.ceil(#Emotes / EMOTES_PER_PAGE)
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
    -- 🔧 FIX 1: Texto con espacio correcto
    Text = "Press, to open - ".. #Emotes.. " emotes loaded",
    Duration = 5
})
