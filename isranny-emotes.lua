--- Emotes v3 - Electric Blue Edition
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Loading...", Text = "Electric Blue UI", Duration = 5})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end
wait(0.5)

local CAS = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local currentPage, EMOTES_PER_PAGE = 1, 300
local currentMode = "Emotes"
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)
local DARK_BG = Color3.fromRGB(15, 15, 25)
local PANEL_BG = Color3.fromRGB(25, 25, 35)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- MAIN CONTAINER CON BORDE
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
MainFrame.BackgroundColor3 = DARK_BG
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainBorder = Instance.new("UIStroke")
MainBorder.Color = ELECTRIC_BLUE
MainBorder.Thickness = 3
MainBorder.Transparency = 0
MainBorder.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- HEADER BAR
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = PANEL_BG
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 12)
HeaderFix.Position = UDim2.new(0, 0, 1, -12)
HeaderFix.BackgroundColor3 = PANEL_BG
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local HeaderBorder = Instance.new("UIStroke")
HeaderBorder.Color = ELECTRIC_BLUE
HeaderBorder.Thickness = 2
HeaderBorder.Parent = Header

-- TÍTULO
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "EMOTE DASHBOARD"
Title.TextColor3 = ELECTRIC_BLUE
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- BOTÓN OPEN/CLOSE
local Open = Instance.new("TextButton")
Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0, 80, 0, 80)
Open.Position = UDim2.new(0.02, 0, 0.25, 0)
Open.Text = "CLOSE"
Open.BackgroundColor3 = DARK_BG
Open.TextColor3 = ELECTRIC_BLUE
Open.TextScaled = true
Open.Font = Enum.Font.GothamBold
Open.MouseButton1Up:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    Open.Text = MainFrame.Visible and "CLOSE" or "OPEN"
end)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = ELECTRIC_BLUE
OpenStroke.Thickness = 2
OpenStroke.Parent = Open

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(1, 0)
OpenCorner.Parent = Open

-- CONTROLES HEADER (ORGANIZADOS)
local ControlsFrame = Instance.new("Frame")
ControlsFrame.Size = UDim2.new(1, -220, 1, -10)
ControlsFrame.Position = UDim2.new(0, 210, 0, 5)
ControlsFrame.BackgroundTransparency = 1
ControlsFrame.Parent = Header

local UIList = Instance.new("UIListLayout")
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 8)
UIList.VerticalAlignment = Enum.VerticalAlignment.Center
UIList.Parent = ControlsFrame

-- BOTÓN MODO
local ModeButton = Instance.new("TextButton")
ModeButton.Size = UDim2.new(0, 110, 0, 35)
ModeButton.LayoutOrder = 1
ModeButton.Text = "EMOTES"
ModeButton.TextScaled = true
ModeButton.Font = Enum.Font.GothamBold
ModeButton.BackgroundColor3 = PANEL_BG
ModeButton.TextColor3 = ELECTRIC_BLUE
ModeButton.Parent = ControlsFrame

local ModeStroke = Instance.new("UIStroke")
ModeStroke.Color = ELECTRIC_BLUE
ModeStroke.Thickness = 2
ModeStroke.Parent = ModeButton
Instance.new("UICorner", ModeButton).CornerRadius = UDim.new(0, 8)

-- PAGINACIÓN
local PrevPage = Instance.new("TextButton")
PrevPage.Size = UDim2.new(0, 35, 0, 35)
PrevPage.LayoutOrder = 2
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.Font = Enum.Font.GothamBold
PrevPage.BackgroundColor3 = PANEL_BG
PrevPage.TextColor3 = ELECTRIC_BLUE
PrevPage.Parent = ControlsFrame
Instance.new("UIStroke", PrevPage).Color = ELECTRIC_BLUE
Instance.new("UICorner", PrevPage).CornerRadius = UDim.new(0, 8)

local PageLabel = Instance.new("TextLabel")
PageLabel.Size = UDim2.new(0, 70, 0, 35)
PageLabel.LayoutOrder = 3
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.Font = Enum.Font.GothamBold
PageLabel.BackgroundColor3 = DARK_BG
PageLabel.TextColor3 = ELECTRIC_BLUE
PageLabel.Parent = ControlsFrame
Instance.new("UIStroke", PageLabel).Color = ELECTRIC_BLUE
Instance.new("UICorner", PageLabel).CornerRadius = UDim.new(0, 8)

local NextPage = Instance.new("TextButton")
NextPage.Size = UDim2.new(0, 35, 0, 35)
NextPage.LayoutOrder = 4
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.Font = Enum.Font.GothamBold
NextPage.BackgroundColor3 = PANEL_BG
NextPage.TextColor3 = ELECTRIC_BLUE
NextPage.Parent = ControlsFrame
Instance.new("UIStroke", NextPage).Color = ELECTRIC_BLUE
Instance.new("UICorner", NextPage).CornerRadius = UDim.new(0, 8)

-- SEARCH
local SearchBar = Instance.new("TextBox")
SearchBar.Size = UDim2.new(0, 180, 0, 35)
SearchBar.LayoutOrder = 5
SearchBar.PlaceholderText = "Search..."
SearchBar.Text = ""
SearchBar.TextScaled = true
SearchBar.Font = Enum.Font.Gotham
SearchBar.BackgroundColor3 = DARK_BG
SearchBar.TextColor3 = Color3.new(1,1,1)
SearchBar.PlaceholderColor3 = Color3.fromRGB(150,150,150)
SearchBar.Parent = ControlsFrame
Instance.new("UIStroke", SearchBar).Color = ELECTRIC_BLUE
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 8)

-- PANEL LATERAL IZQUIERDO
local SidePanel = Instance.new("Frame")
SidePanel.Size = UDim2.new(0, 180, 1, -60)
SidePanel.Position = UDim2.new(0, 10, 0, 55)
SidePanel.BackgroundColor3 = PANEL_BG
SidePanel.Parent = MainFrame
Instance.new("UIStroke", SidePanel).Color = ELECTRIC_BLUE
Instance.new("UICorner", SidePanel).CornerRadius = UDim.new(0, 10)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 10)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
SideLayout.Parent = SidePanel

local SidePadding = Instance.new("UIPadding")
SidePadding.PaddingTop = UDim.new(0, 15)
SidePadding.PaddingLeft = UDim.new(0, 10)
SidePadding.PaddingRight = UDim.new(0, 10)
SidePadding.Parent = SidePanel

-- NOMBRE EMOTE
local EmoteName = Instance.new("TextLabel")
EmoteName.Size = UDim2.new(1, 0, 0, 60)
EmoteName.LayoutOrder = 1
EmoteName.BackgroundColor3 = DARK_BG
EmoteName.TextColor3 = ELECTRIC_BLUE
EmoteName.Text = "Select an Emote"
EmoteName.TextScaled = true
EmoteName.Font = Enum.Font.GothamBold
EmoteName.TextWrapped = true
EmoteName.Parent = SidePanel
Instance.new("UIStroke", EmoteName).Color = ELECTRIC_BLUE
Instance.new("UICorner", EmoteName).CornerRadius = UDim.new(0, 8)

-- BOTÓN WALK
local WalkButton = Instance.new("TextButton")
WalkButton.Size = UDim2.new(1, 0, 0, 40)
WalkButton.LayoutOrder = 2
WalkButton.Text = "WALK: OFF"
WalkButton.TextScaled = true
WalkButton.Font = Enum.Font.GothamBold
WalkButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
WalkButton.TextColor3 = Color3.new(1,1,1)
WalkButton.Parent = SidePanel
Instance.new("UIStroke", WalkButton).Color = ELECTRIC_BLUE
Instance.new("UICorner", WalkButton).CornerRadius = UDim.new(0, 8)

-- CONTROL VELOCIDAD
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Size = UDim2.new(1, 0, 0, 40)
SpeedFrame.LayoutOrder = 3
SpeedFrame.BackgroundTransparency = 1
SpeedFrame.Parent = SidePanel

local SpeedDown = Instance.new("TextButton")
SpeedDown.Size = UDim2.new(0, 40, 1, 0)
SpeedDown.Position = UDim2.new(0, 0, 0, 0)
SpeedDown.Text = "-"
SpeedDown.TextScaled = true
SpeedDown.Font = Enum.Font.GothamBold
SpeedDown.BackgroundColor3 = PANEL_BG
SpeedDown.TextColor3 = ELECTRIC_BLUE
SpeedDown.Parent = SpeedFrame
Instance.new("UIStroke", SpeedDown).Color = ELECTRIC_BLUE
Instance.new("UICorner", SpeedDown).CornerRadius = UDim.new(0, 8)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -90, 1, 0)
SpeedLabel.Position = UDim2.new(0, 45, 0, 0)
SpeedLabel.Text = "1.0x"
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.BackgroundColor3 = DARK_BG
SpeedLabel.TextColor3 = ELECTRIC_BLUE
SpeedLabel.Parent = SpeedFrame
Instance.new("UIStroke", SpeedLabel).Color = ELECTRIC_BLUE
Instance.new("UICorner", SpeedLabel).CornerRadius = UDim.new(0, 8)

local SpeedUp = Instance.new("TextButton")
SpeedUp.Size = UDim2.new(0, 40, 1, 0)
SpeedUp.Position = UDim2.new(1, -40, 0, 0)
SpeedUp.Text = "+"
SpeedUp.TextScaled = true
SpeedUp.Font = Enum.Font.GothamBold
SpeedUp.BackgroundColor3 = PANEL_BG
SpeedUp.TextColor3 = ELECTRIC_BLUE
SpeedUp.Parent = SpeedFrame
Instance.new("UIStroke", SpeedUp).Color = ELECTRIC_BLUE
Instance.new("UICorner", SpeedUp).CornerRadius = UDim.new(0, 8)

-- BOTÓN KILL
local KillButton = Instance.new("TextButton")
KillButton.Size = UDim2.new(1, 0, 0, 35)
KillButton.LayoutOrder = 4
KillButton.Text = "CLOSE GUI"
KillButton.TextScaled = true
KillButton.Font = Enum.Font.GothamBold
KillButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
KillButton.TextColor3 = Color3.new(1,1,1)
KillButton.Parent = SidePanel
KillButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
Instance.new("UIStroke", KillButton).Color = ELECTRIC_BLUE
Instance.new("UICorner", KillButton).CornerRadius = UDim.new(0, 8)

-- ÁREA PRINCIPAL EMOTES
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -200, 1, -60)
ContentFrame.Position = UDim2.new(0, 195, 0, 55)
ContentFrame.BackgroundColor3 = PANEL_BG
ContentFrame.Parent = MainFrame
Instance.new("UIStroke", ContentFrame).Color = ELECTRIC_BLUE
Instance.new("UICorner", ContentFrame).CornerRadius = UDim.new(0, 10)

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1, -10, 1, -10)
Frame.Position = UDim2.new(0, 5, 0, 5)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 6
Frame.ScrollBarImageColor3 = ELECTRIC_BLUE
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.Parent = ContentFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 90, 0, 90)
Grid.CellPadding = UDim2.new(0, 8, 0, 8)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

-- FUNCIONES
CAS:BindCoreActionAtPriority("Emote Menu", function(_,s)
    if s == Enum.UserInputState.Begin then
        MainFrame.Visible = not MainFrame.Visible
        Open.Text = MainFrame.Visible and "CLOSE" or "OPEN"
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

-- PEGA TUS EMOTES AQUÍ
local Emotes = {
    { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
}

-- PEGA TUS ANIMACIONES AQUÍ
local Animations = {
    { name = "Zombie", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150", price = 0, lastupdated = 0, sort = {} },
}

local currentTrack = nil

local function PlayItem(name, id, isAnim)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if currentTrack then currentTrack:Stop() end

    if isAnim then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..id
        currentTrack = hum:LoadAnimation(anim)
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
        currentTrack:AdjustSpeed(emoteSpeed)
        currentTrack.Looped = true
        currentTrack:Play()
    else
        local desc = hum:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", hum)
        local success, track = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(id) end)
        if not success then pcall(function() desc:AddEmote(name, id) end) success, track = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(id) end) end
        if success and track then
            currentTrack = track
            track:AdjustSpeed(emoteSpeed)
            if canWalk then track.Priority = Enum.AnimationPriority.Action end
        end
    end
    MainFrame.Visible = false
    Open.Text = "OPEN"
end

local function ShowPage(page)
    for _,v in pairs(Frame:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end end
    local list = currentMode == "Emotes" and Emotes or Animations
    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #list)
    local totalPages = math.max(1, math.ceil(#list / EMOTES_PER_PAGE))
    PageLabel.Text = page.."/"..totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages

    for i = startIdx, endIdx do
        local item = list[i]
        if item then
            local btn = Instance.new("ImageButton")
            btn.Size = UDim2.new(0, 90, 0, 90)
            btn.Image = item.icon
            btn.BackgroundColor3 = DARK_BG
            btn.LayoutOrder = i
            btn:SetAttribute("name", item.name)
            btn.Parent = Frame

            local stroke = Instance.new("UIStroke", btn)
            stroke.Color = ELECTRIC_BLUE
            stroke.Thickness = 2
            stroke.Transparency = 0.5

            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            btn.MouseEnter:Connect(function()
                EmoteName.Text = item.name
                stroke.Transparency = 0
                stroke.Thickness = 3
            end)
            btn.MouseLeave:Connect(function()
                stroke.Transparency = 0.5
                stroke.Thickness = 2
            end)
            btn.MouseButton1Click:Connect(function()
                PlayItem(item.name, item.id, currentMode == "Animations")
            end)
        end
    end
end

ModeButton.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeButton.Text = currentMode:upper()
    currentPage = 1
    ShowPage(1)
end)

WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "WALK: "..(canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0, 80, 0) or Color3.fromRGB(80, 0, 0)
    if currentTrack then currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = string.format("%.2fx", emoteSpeed)
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = string.format("%.2fx", emoteSpeed)
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

PrevPage.MouseButton1Click:Connect(function() if currentPage > 1 then currentPage -= 1 ShowPage(currentPage) end end)
NextPage.MouseButton1Click:Connect(function()
    local total = math.ceil((currentMode == "Emotes" and #Emotes or #Animations) / EMOTES_PER_PAGE)
    if currentPage < total then currentPage += 1 ShowPage(currentPage) end
end)

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBar.Text:lower()
    for _,btn in pairs(Frame:GetChildren()) do
        if btn:IsA("GuiButton") then
            btn.Visible = text == "" or btn:GetAttribute("name"):lower():find(text, 1, true)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function() task.wait(1) ShowPage(1) end)
if LocalPlayer.Character then ShowPage(1) end

StarterGui:SetCore("SendNotification",{Title = "Electric Blue Loaded!", Text = "Press, to toggle", Duration = 5})
