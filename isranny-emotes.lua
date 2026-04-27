--- Emotes v3 Electric Blue - PEGA TUS EMOTES
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end

local CAS = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local currentPage, EMOTES_PER_PAGE = 1, 300
local currentMode = "Emotes"
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil

local BLUE = Color3.fromRGB(0, 200, 255)
local DARK = Color3.fromRGB(15, 15, 25)
local PANEL = Color3.fromRGB(25, 25, 35)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.Parent = CoreGui

-- MAIN CON BORDE AZUL
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0.9, 0, 0.6, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.SizeConstraint = Enum.SizeConstraint.RelativeYY
Main.BackgroundColor3 = DARK
Main.Parent = ScreenGui
Instance.new("UIStroke", Main).Color = BLUE
Instance.new("UIStroke", Main).Thickness = 3
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- HEADER
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = PANEL
Instance.new("UIStroke", Header).Color = BLUE
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)
local fix = Instance.new("Frame", Header)
fix.Size = UDim2.new(1,0,0,12)
fix.Position = UDim2.new(0,0,1,-12)
fix.BackgroundColor3 = PANEL
fix.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0,200,1,0)
Title.Position = UDim2.new(0,15,0,0)
Title.BackgroundTransparency = 1
Title.Text = "EMOTE DASHBOARD"
Title.TextColor3 = BLUE
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÓN TOGGLE
local Open = Instance.new("TextButton", ScreenGui)
Open.Draggable = true
Open.Size = UDim2.new(0,80,0,80)
Open.Position = UDim2.new(0.02,0,0.25,0)
Open.Text = "CLOSE"
Open.BackgroundColor3 = DARK
Open.TextColor3 = BLUE
Open.TextScaled = true
Open.Font = Enum.Font.GothamBold
Open.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    Open.Text = Main.Visible and "CLOSE" or "OPEN"
end)
Instance.new("UIStroke", Open).Color = BLUE
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)

-- CONTROLES
local Controls = Instance.new("Frame", Header)
Controls.Size = UDim2.new(1,-220,1,-10)
Controls.Position = UDim2.new(0,210,0,5)
Controls.BackgroundTransparency = 1
local list = Instance.new("UIListLayout", Controls)
list.FillDirection = Enum.FillDirection.Horizontal
list.Padding = UDim.new(0,8)
list.VerticalAlignment = Enum.VerticalAlignment.Center

local function btn(parent, txt, size)
    local b = Instance.new("TextButton", parent)
    b.Size = size
    b.Text = txt
    b.TextScaled = true
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = PANEL
    b.TextColor3 = BLUE
    Instance.new("UIStroke", b).Color = BLUE
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local ModeBtn = btn(Controls, "EMOTES", UDim2.new(0,110,0,35))
local Prev = btn(Controls, "<", UDim2.new(0,35,0,35))
local Page = Instance.new("TextLabel", Controls)
Page.Size = UDim2.new(0,70,0,35)
Page.Text = "1/1"
Page.TextScaled = true
Page.Font = Enum.Font.GothamBold
Page.BackgroundColor3 = DARK
Page.TextColor3 = BLUE
Instance.new("UIStroke", Page).Color = BLUE
Instance.new("UICorner", Page).CornerRadius = UDim.new(0,8)
local Next = btn(Controls, ">", UDim2.new(0,35,0,35))

local Search = Instance.new("TextBox", Controls)
Search.Size = UDim2.new(0,180,0,35)
Search.PlaceholderText = "Search..."
Search.TextScaled = true
Search.Font = Enum.Font.Gotham
Search.BackgroundColor3 = DARK
Search.TextColor3 = Color3.new(1,1,1)
Instance.new("UIStroke", Search).Color = BLUE
Instance.new("UICorner", Search).CornerRadius = UDim.new(0,8)

-- PANEL IZQUIERDO
local Side = Instance.new("Frame", Main)
Side.Size = UDim2.new(0,180,1,-60)
Side.Position = UDim2.new(0,10,0,55)
Side.BackgroundColor3 = PANEL
Instance.new("UIStroke", Side).Color = BLUE
Instance.new("UICorner", Side).CornerRadius = UDim.new(0,10)

local sList = Instance.new("UIListLayout", Side)
sList.Padding = UDim.new(0,10)
sList.HorizontalAlignment = Enum.HorizontalAlignment.Center
local pad = Instance.new("UIPadding", Side)
pad.PaddingTop = UDim.new(0,15)
pad.PaddingLeft = UDim.new(0,10)
pad.PaddingRight = UDim.new(0,10)

local NameLbl = Instance.new("TextLabel", Side)
NameLbl.Size = UDim2.new(1,0,0,60)
NameLbl.BackgroundColor3 = DARK
NameLbl.TextColor3 = BLUE
NameLbl.Text = "Select"
NameLbl.TextScaled = true
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextWrapped = true
Instance.new("UIStroke", NameLbl).Color = BLUE
Instance.new("UICorner", NameLbl).CornerRadius = UDim.new(0,8)

local WalkBtn = btn(Side, "WALK: OFF", UDim2.new(1,0,0,40))
WalkBtn.BackgroundColor3 = Color3.fromRGB(80,0,0)
WalkBtn.TextColor3 = Color3.new(1,1,1)

local SpeedF = Instance.new("Frame", Side)
SpeedF.Size = UDim2.new(1,0,0,40)
SpeedF.BackgroundTransparency = 1
local Down = btn(SpeedF, "-", UDim2.new(0,40,1,0))
local SpeedLbl = Instance.new("TextLabel", SpeedF)
SpeedLbl.Size = UDim2.new(1,-90,1,0)
SpeedLbl.Position = UDim2.new(0,45,0,0)
SpeedLbl.Text = "1.0x"
SpeedLbl.TextScaled = true
SpeedLbl.Font = Enum.Font.GothamBold
SpeedLbl.BackgroundColor3 = DARK
SpeedLbl.TextColor3 = BLUE
Instance.new("UIStroke", SpeedLbl).Color = BLUE
Instance.new("UICorner", SpeedLbl).CornerRadius = UDim.new(0,8)
local Up = btn(SpeedF, "+", UDim2.new(0,40,1,0))
Up.Position = UDim2.new(1,-40,0,0)

local Kill = btn(Side, "CLOSE", UDim2.new(1,0,0,35))
Kill.BackgroundColor3 = Color3.fromRGB(120,0,0)
Kill.TextColor3 = Color3.new(1,1,1)
Kill.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CONTENT
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-200,1,-60)
Content.Position = UDim2.new(0,195,0,55)
Content.BackgroundColor3 = PANEL
Instance.new("UIStroke", Content).Color = BLUE
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,10)

local Scroll = Instance.new("ScrollingFrame", Content)
Scroll.Size = UDim2.new(1,-10,1,-10)
Scroll.Position = UDim2.new(0,5,0,5)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = BLUE
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0,90,0,90)
Grid.CellPadding = UDim2.new(0,8,0,8)

-- ============================================
-- PEGA AQUÍ TUS 38,565 EMOTES
-- ============================================
local Emotes = {
    { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" },
    { name = "Applaud", id = 5915779043, icon = "rbxthumb://type=Asset&id=5915779043&w=150&h=150" },
    -- PEGA TODOS AQUÍ
}
-- ============================================

-- ============================================
-- PEGA AQUÍ TUS ANIMACIONES
-- ============================================
local Animations = {
    { name = "Zombie", id = 616158929, icon = "rbxthumb://type=Asset&id=616158929&w=150&h=150" },
    { name = "Ninja", id = 656118852, icon = "rbxthumb://type=Asset&id=656118852&w=150&h=150" },
}
-- ============================================

local LP = Players.LocalPlayer

local function Play(name, id, isAnim)
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if currentTrack then currentTrack:Stop() end

    if isAnim then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://"..id
        currentTrack = h:LoadAnimation(a)
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
        currentTrack:AdjustSpeed(emoteSpeed)
        currentTrack.Looped = true
        currentTrack:Play()
    else
        local d = h:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", h)
        local s,t = pcall(function() return h:PlayEmoteAndGetAnimTrackById(id) end)
        if not s then pcall(function() d:AddEmote(name,id) end) s,t = pcall(function() return h:PlayEmoteAndGetAnimTrackById(id) end) end
        if s and t then currentTrack = t t:AdjustSpeed(emoteSpeed) if canWalk then t.Priority = Enum.AnimationPriority.Action end end
    end
    Main.Visible = false
    Open.Text = "OPEN"
end

local function Show(page)
    for _,v in pairs(Scroll:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end end
    local list = currentMode == "Emotes" and Emotes or Animations
    local start = (page-1)*EMOTES_PER_PAGE+1
    local finish = math.min(page*EMOTES_PER_PAGE, #list)
    local total = math.max(1, math.ceil(#list/EMOTES_PER_PAGE))
    Page.Text = page.."/"..total

    for i=start,finish do
        local item = list[i]
        local b = Instance.new("ImageButton", Scroll)
        b.Size = UDim2.new(0,90,0,90)
        b.Image = item.icon
        b.BackgroundColor3 = DARK
        b:SetAttribute("name", item.name)
        local s = Instance.new("UIStroke", b)
        s.Color = BLUE
        s.Thickness = 2
        s.Transparency = 0.5
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
        b.MouseEnter:Connect(function() NameLbl.Text=item.name s.Transparency=0 s.Thickness=3 end)
        b.MouseLeave:Connect(function() s.Transparency=0.5 s.Thickness=2 end)
        b.MouseButton1Click:Connect(function() Play(item.name,item.id,currentMode=="Animations") end)
    end
end

ModeBtn.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeBtn.Text = currentMode:upper()
    currentPage = 1
    Show(1)
end)

WalkBtn.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkBtn.Text = "WALK: "..(canWalk and "ON" or "OFF")
    WalkBtn.BackgroundColor3 = canWalk and Color3.fromRGB(0,80,0) or Color3.fromRGB(80,0,0)
end)

Up.MouseButton1Click:Connect(function() emoteSpeed=math.min(emoteSpeed+0.25,3) SpeedLbl.Text=string.format("%.2fx",emoteSpeed) if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end end)
Down.MouseButton1Click:Connect(function() emoteSpeed=math.max(emoteSpeed-0.25,0.25) SpeedLbl.Text=string.format("%.2fx",emoteSpeed) if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end end)
Prev.MouseButton1Click:Connect(function() if currentPage>1 then currentPage-=1 Show(currentPage) end end)
Next.MouseButton1Click:Connect(function() local t=math.ceil((currentMode=="Emotes" and #Emotes or #Animations)/EMOTES_PER_PAGE) if currentPage<t then currentPage+=1 Show(currentPage) end end)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = Search.Text:lower()
    for _,b in pairs(Scroll:GetChildren()) do if b:IsA("GuiButton") then b.Visible = txt=="" or b:GetAttribute("name"):lower():find(txt,1,true) end end
end)

CAS:BindCoreActionAtPriority("Menu", function(_,s) if s==Enum.UserInputState.Begin then Main.Visible=not Main.Visible Open.Text=Main.Visible and "CLOSE" or "OPEN" end end, true, 2001, Enum.KeyCode.Comma)

LP.CharacterAdded:Connect(function() task.wait(1) Show(1) end)
Show(1)
StarterGui:SetCore("SendNotification",{Title="Electric Blue!",Text="Loaded "..#Emotes.." emotes",Duration=5})
