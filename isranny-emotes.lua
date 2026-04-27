--- Emotes Minimal - Solo Bordes Azules
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end

local CAS = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local currentPage, PER_PAGE = 1, 200
local currentMode = "Emotes"
local speed = 1
local canWalk = false
local track = nil

local BLUE = Color3.fromRGB(0, 200, 255)

local Gui = Instance.new("ScreenGui")
Gui.Name = "Emotes"
Gui.Parent = CoreGui

-- VENTANA PRINCIPAL (SIN FONDO)
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 700, 0, 450)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.BackgroundTransparency = 1
Main.Parent = Gui

local MainBorder = Instance.new("UIStroke", Main)
MainBorder.Color = BLUE
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.2

-- BOTÓN TOGGLE
local Toggle = Instance.new("TextButton", Gui)
Toggle.Size = UDim2.new(0, 60, 0, 30)
Toggle.Position = UDim2.new(0, 20, 0, 100)
Toggle.Text = "EMOTES"
Toggle.TextSize = 12
Toggle.Font = Enum.Font.Gotham
Toggle.BackgroundTransparency = 1
Toggle.TextColor3 = BLUE
Toggle.Draggable = true
Instance.new("UIStroke", Toggle).Color = BLUE
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 4)

Toggle.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- BARRA SUPERIOR
local Top = Instance.new("Frame", Main)
Top.Size = UDim2.new(1, 0, 0, 30)
Top.BackgroundTransparency = 1

local function smallBtn(parent, text, x, w)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, w, 0, 22)
    b.Position = UDim2.new(0, x, 0, 4)
    b.Text = text
    b.TextSize = 11
    b.Font = Enum.Font.Gotham
    b.BackgroundTransparency = 1
    b.TextColor3 = BLUE
    Instance.new("UIStroke", b).Color = BLUE
    Instance.new("UIStroke", b).Thickness = 1
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    return b
end

local ModeBtn = smallBtn(Top, "EMOTES", 5, 70)
local Prev = smallBtn(Top, "<", 80, 22)
local Page = Instance.new("TextLabel", Top)
Page.Size = UDim2.new(0, 50, 0, 22)
Page.Position = UDim2.new(0, 107, 0, 4)
Page.Text = "1/1"
Page.TextSize = 11
Page.Font = Enum.Font.Gotham
Page.BackgroundTransparency = 1
Page.TextColor3 = BLUE
Instance.new("UIStroke", Page).Color = BLUE
Instance.new("UICorner", Page).CornerRadius = UDim.new(0, 3)

local Next = smallBtn(Top, ">", 162, 22)
local WalkBtn = smallBtn(Top, "WALK", 195, 50)
local SpeedDown = smallBtn(Top, "-", 250, 22)
local SpeedLbl = Instance.new("TextLabel", Top)
SpeedLbl.Size = UDim2.new(0, 40, 0, 22)
SpeedLbl.Position = UDim2.new(0, 277, 0, 4)
SpeedLbl.Text = "1x"
SpeedLbl.TextSize = 11
SpeedLbl.Font = Enum.Font.Gotham
SpeedLbl.BackgroundTransparency = 1
SpeedLbl.TextColor3 = BLUE
Instance.new("UIStroke", SpeedLbl).Color = BLUE
Instance.new("UICorner", SpeedLbl).CornerRadius = UDim.new(0, 3)
local SpeedUp = smallBtn(Top, "+", 322, 22)

local Search = Instance.new("TextBox", Top)
Search.Size = UDim2.new(0, 120, 0, 22)
Search.Position = UDim2.new(1, -125, 0, 4)
Search.PlaceholderText = "search"
Search.Text = ""
Search.TextSize = 11
Search.Font = Enum.Font.Gotham
Search.BackgroundTransparency = 1
Search.TextColor3 = Color3.new(1,1,1)
Search.PlaceholderColor3 = Color3.fromRGB(100,100,100)
Instance.new("UIStroke", Search).Color = BLUE
Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 3)

local Close = smallBtn(Top, "X", 685, 22)
Close.Position = UDim2.new(1, -27, 0, 4)
Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

-- GRID DE EMOTES
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = BLUE
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Grid = Instance.new("UIGridLayout", Scroll)
Grid.CellSize = UDim2.new(0, 65, 0, 65)
Grid.CellPadding = UDim2.new(0, 6, 0, 6)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

-- NOMBRE (flotante)
local NameTag = Instance.new("TextLabel", Main)
NameTag.Size = UDim2.new(0, 200, 0, 20)
NameTag.Position = UDim2.new(0, 5, 1, -25)
NameTag.BackgroundTransparency = 1
NameTag.Text = ""
NameTag.TextSize = 11
NameTag.Font = Enum.Font.Gotham
NameTag.TextColor3 = BLUE
NameTag.TextXAlignment = Enum.TextXAlignment.Left

-- DATA
local Emotes = {
    {name="Salute",id=3360689775,icon="rbxthumb://type=Asset&id=3360689775&w=150&h=150"},
    -- PEGA AQUÍ TUS EMOTES
}

local Anims = {
    {name="Zombie",id=616158929,icon="rbxthumb://type=Asset&id=616158929&w=150&h=150"},
}

local LP = Players.LocalPlayer

local function play(name, id, isAnim)
    local c = LP.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    if not h then return end
    if track then track:Stop() end

    if isAnim then
        local a = Instance.new("Animation")
        a.AnimationId = "rbxassetid://"..id
        track = h:LoadAnimation(a)
        track.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
        track:AdjustSpeed(speed)
        track.Looped = true
        track:Play()
    else
        local d = h:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", h)
        local s,t = pcall(function() return h:PlayEmoteAndGetAnimTrackById(id) end)
        if not s then pcall(function() d:AddEmote(name,id) end) s,t = pcall(function() return h:PlayEmoteAndGetAnimTrackById(id) end) end
        if s and t then track = t t:AdjustSpeed(speed) if canWalk then t.Priority = Enum.AnimationPriority.Action end end
    end
    Main.Visible = false
end

local function show(page)
    for _,v in pairs(Scroll:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end end
    local list = currentMode == "Emotes" and Emotes or Anims
    local start = (page-1)*PER_PAGE+1
    local finish = math.min(page*PER_PAGE, #list)
    local total = math.max(1, math.ceil(#list/PER_PAGE))
    Page.Text = page.."/"..total

    for i=start,finish do
        local item = list[i]
        local b = Instance.new("ImageButton", Scroll)
        b.Size = UDim2.new(0, 65, 0, 65)
        b.Image = item.icon
        b.BackgroundTransparency = 1
        b:SetAttribute("name", item.name)

        local stroke = Instance.new("UIStroke", b)
        stroke.Color = BLUE
        stroke.Thickness = 1
        stroke.Transparency = 0.7
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)

        b.MouseEnter:Connect(function()
            NameTag.Text = item.name
            stroke.Transparency = 0
            stroke.Thickness = 1.5
        end)
        b.MouseLeave:Connect(function()
            stroke.Transparency = 0.7
            stroke.Thickness = 1
        end)
        b.MouseButton1Click:Connect(function() play(item.name, item.id, currentMode=="Animations") end)
    end
end

ModeBtn.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeBtn.Text = currentMode:upper()
    currentPage = 1
    show(1)
end)

WalkBtn.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkBtn.TextColor3 = canWalk and Color3.fromRGB(0,255,100) or BLUE
end)

SpeedUp.MouseButton1Click:Connect(function() speed=math.min(speed+0.25,3) SpeedLbl.Text=speed.."x" if track then track:AdjustSpeed(speed) end end)
SpeedDown.MouseButton1Click:Connect(function() speed=math.max(speed-0.25,0.25) SpeedLbl.Text=speed.."x" if track then track:AdjustSpeed(speed) end end)
Prev.MouseButton1Click:Connect(function() if currentPage>1 then currentPage-=1 show(currentPage) end end)
Next.MouseButton1Click:Connect(function() local t=math.ceil((currentMode=="Emotes" and #Emotes or #Anims)/PER_PAGE) if currentPage<t then currentPage+=1 show(currentPage) end end)

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local txt = Search.Text:lower()
    for _,b in pairs(Scroll:GetChildren()) do
        if b:IsA("GuiButton") then
            b.Visible = txt=="" or b:GetAttribute("name"):lower():find(txt,1,true)
        end
    end
end)

CAS:BindCoreActionAtPriority("Menu", function(_,s) if s==Enum.UserInputState.Begin then Main.Visible=not Main.Visible end end, true, 2001, Enum.KeyCode.Comma)

show(1)
