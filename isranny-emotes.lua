--- Keybind "," - Emotes PAGINADO 20x [FIXED]
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification",{Title="Loading",Text="Emotes v4 Paginado",Duration=3})

if game.CoreGui:FindFirstChild("Emotes") then game.CoreGui.Emotes:Destroy() end
task.wait(0.5)

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local CurrentSort = "recentfirst"
local FavoriteOff = "rbxassetid://10651060677"
local FavoriteOn = "rbxassetid://10651061109"
local FavoritedEmotes = {}
local CurrentPage = 1
local EMOTES_PER_PAGE = 20

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.8,0.6,0)
BackFrame.Position = UDim2.new(0.5,0,0.5,0)
BackFrame.AnchorPoint = Vector2.new(0.5,0.5)
BackFrame.BackgroundColor3 = Color3.fromRGB(20,20)
BackFrame.BackgroundTransparency = 0.1
BackFrame.Visible = false
BackFrame.Parent = ScreenGui
Instance.new("UICorner", BackFrame).CornerRadius = UDim.new(0,8)
Instance.new("UIStroke", BackFrame).Color = Color3.fromRGB(0,200,255)

local Open = Instance.new("TextButton")
Open.Parent = ScreenGui
Open.Size = UDim2.new(0,60,0,60)
Open.Position = UDim2.new(0,20,0.3,0)
Open.Text = "Open"
Open.BackgroundColor3 = Color3.new(0,0,0)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true
Open.BackgroundTransparency = 0.3
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)
Open.MouseButton1Click:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
end)

ContextActionService:BindAction("EmoteMenu", function(_,s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, false, Enum.KeyCode.Comma)

local EmoteName = Instance.new("TextLabel")
EmoteName.Parent = BackFrame
EmoteName.Size = UDim2.new(1,0,30)
EmoteName.Position = UDim2.new(0,0,1,5)
EmoteName.BackgroundColor3 = Color3.fromRGB(30,30,30)
EmoteName.TextColor3 = Color3.new(1,1,1)
EmoteName.Text = "Select an Emote"
EmoteName.TextScaled = true
Instance.new("UICorner", EmoteName)

local Frame = Instance.new("ScrollingFrame")
Frame.Parent = BackFrame
Frame.Size = UDim2.new(1,-20,1,-60)
Frame.Position = UDim2.new(0,10,0,50)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 6
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Grid = Instance.new("UIGridLayout")
Grid.Parent = Frame
Grid.CellSize = UDim2.new(0,100,0,100)
Grid.CellPadding = UDim2.new(0,8,0,8)
Grid.SortOrder = Enum.SortOrder.LayoutOrder

-- PAGINACION UI
local Prev = Instance.new("TextButton", BackFrame)
Prev.Size = UDim2.new(0,80,0,30)
Prev.Position = UDim2.new(0,10,0,10)
Prev.Text = "< Prev"
Prev.BackgroundColor3 = Color3.new(0,0)
Prev.TextColor3 = Color3.new(1,1,1)
Prev.TextScaled = true
Instance.new("UICorner", Prev)

local Next = Instance.new("TextButton", BackFrame)
Next.Size = UDim2.new(0,80,0,30)
Next.Position = UDim2.new(1,-90,0,10)
Next.Text = "Next >"
Next.BackgroundColor3 = Color3.new(0,0,0)
Next.TextColor3 = Color3.new(1,1,1)
Next.TextScaled = true
Instance.new("UICorner", Next)

local PageLabel = Instance.new("TextLabel", BackFrame)
PageLabel.Size = UDim2.new(0,100,0,30)
PageLabel.Position = UDim2.new(0.5,-50,0,10)
PageLabel.BackgroundTransparency = 1
PageLabel.TextColor3 = Color3.fromRGB(0,255,0)
PageLabel.TextScaled = true
PageLabel.Text = "1/1"

-- TU LISTA COMPLETA (copiada de tu script)
local Emotes = {
{name="Around Town",id=3576747102,price=1000},{name="TWICE TAKEDOWN DANCE 2",id=85623000473425,price=100},
{name="Fashionable",id=3576745472,price=750},{name="Swish",id=3821527813,price=750},
{name="Top Rock",id=3570535774,price=750},{name="Fancy Feet",id=3934988903,price=500},
{name="Idol",id=4102317848,price=500},{name="Sneaky",id=3576754235,price=500},
{name="Elton John - Piano Jump",id=11453096488,price=500},{name="Cartwheel - George Ezra",id=10370929905,price=450},
{name="Super Charge",id=10478368365,price=450},{name="Rise Above - The Chainsmokers",id=13071993910,price=400},
{name="Elton John - Elevate",id=11394056822,price=400},{name="Sturdy Dance - Ice Spice",id=17746270218,price=300},
{name="YUNGBLUD – HIGH KICK",id=14022978026,price=300},{name="Robot",id=3576721660,price=250},
{name="Louder",id=3576751796,price=250},{name="Twirl",id=3716633898,price=250},
{name="Bodybuilder",id=3994130516,price=200},{name="NBA Monster Dunk",id=117511481049460,price=200},
-- [... AÑADE AQUÍ EL RESTO DE TUS 300 EMOTES, SOLO NECESITAS name e id...]
{name="Shrug",id=3576968026,price=0},
}

-- añade icon automáticamente
for _,e in ipairs(Emotes) do
    e.icon = "rbxthumb://type=Asset&id="..e.id.."&w=150&h=150"
    e.sort = {}
end

-- cargar favoritos
pcall(function()
    if isfile("FavoritedEmotes.txt") then
        FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt"))
    end
end)

local function PlayEmote(name,id)
    BackFrame.Visible = false
    Open.Text = "Open"
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local desc = hum:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", hum)
    pcall(function()
        hum:PlayEmoteAndGetAnimTrackById(id)
    end)
    if not pcall(function() hum:PlayEmoteAndGetAnimTrackById(id) end) then
        desc:AddEmote(name, id)
        hum:PlayEmoteAndGetAnimTrackById(id)
    end
end

local function ShowPage(page)
    for _,v in pairs(Frame:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end end

    local total = math.ceil(#Emotes / EMOTES_PER_PAGE)
    CurrentPage = math.clamp(page,1,total)
    PageLabel.Text = CurrentPage.."/"..total
    Prev.Visible = CurrentPage > 1
    Next.Visible = CurrentPage < total

    local start = (CurrentPage-1)*EMOTES_PER_PAGE + 1
    local finish = math.min(start + EMOTES_PER_PAGE - 1, #Emotes)

    for i=start,finish do
        local e = Emotes[i]
        local btn = Instance.new("ImageButton")
        btn.Parent = Frame
        btn.Size = UDim2.new(0,100,0,100)
        btn.Image = e.icon
        btn.BackgroundColor3 = Color3.new(0,0,0)
        btn.BackgroundTransparency = 0.3
        Instance.new("UICorner", btn)
        btn.LayoutOrder = i

        btn.MouseButton1Click:Connect(function() PlayEmote(e.name, e.id) end)
        btn.MouseEnter:Connect(function() EmoteName.Text = e.name end)
        btn.MouseLeave:Connect(function() EmoteName.Text = "Select an Emote" end)

        -- favorito
        local fav = Instance.new("ImageButton", btn)
        fav.Size = UDim2.new(0,20,0,20)
        fav.Position = UDim2.new(1,-22,1,-22)
        fav.BackgroundTransparency = 1
        fav.Image = table.find(FavoritedEmotes, e.id) and FavoriteOn or FavoriteOff
        fav.MouseButton1Click:Connect(function()
            local idx = table.find(FavoritedEmotes, e.id)
            if idx then table.remove(FavoritedEmotes, idx) fav.Image = FavoriteOff
            else table.insert(FavoritedEmotes, e.id) fav.Image = FavoriteOn end
            pcall(function() writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes)) end)
        end)
    end
end

Prev.MouseButton1Click:Connect(function() ShowPage(CurrentPage-1) end)
Next.MouseButton1Click:Connect(function() ShowPage(CurrentPage+1) end)

ShowPage(1)
StarterGui:SetCore("SendNotification",{Title="Listo",Text=#Emotes.." emotes cargados",Duration=3})
