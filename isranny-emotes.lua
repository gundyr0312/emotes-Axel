--- Keybind "," - Emotes INSTANT LOAD + 20 per page
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Loading...",
    Text = "Instant load - 20 per page",
    Duration = 3
})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local CurrentSort = "recentfirst"
local FavoriteOff = "rbxassetid://10651060677"
local FavoriteOn = "rbxassetid://10651061109"
local FavoritedEmotes = {}
local CurrentPage = 1
local EMOTES_PER_PAGE = 20

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.7, 0, 0.5, 0)
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.BackgroundColor3 = Color3.fromRGB(20,20)
BackFrame.BackgroundTransparency = 0.1
BackFrame.Visible = false
BackFrame.Parent = ScreenGui

local Open = Instance.new("TextButton")
Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0.05,0,0.1,0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Open"
Open.BackgroundColor3 = Color3.fromRGB(0,0,0)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true
Open.BackgroundTransparency =.5
Open.MouseButton1Click:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
end)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)

local Corner = Instance.new("UICorner")

local EmoteName = Instance.new("TextLabel")
EmoteName.Name = "EmoteName"
EmoteName.TextScaled = true
EmoteName.AnchorPoint = Vector2.new(0.5, 0.5)
EmoteName.Position = UDim2.new(0.5, 0, 1.05, 0)
EmoteName.Size = UDim2.new(1, 0, 0.15, 0)
EmoteName.BackgroundColor3 = Color3.fromRGB(30,30,30)
EmoteName.TextColor3 = Color3.new(1,1,1)
EmoteName.Text = "Select an Emote"
EmoteName.Parent = BackFrame
Corner:Clone().Parent = EmoteName

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.18, 0, 0, 100)
Grid.CellPadding = UDim2.new(0.01, 0, 0.01, 0)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

-- PAGINACIÓN
local PrevPage = Instance.new("TextButton", BackFrame)
PrevPage.Position = UDim2.new(0.2, 0, -0.12, 0)
PrevPage.Size = UDim2.new(0.1, 0, 0.1, 0)
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1,1)
PrevPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = PrevPage

local NextPage = Instance.new("TextButton", BackFrame)
NextPage.Position = UDim2.new(0.8, 0, -0.12, 0)
NextPage.Size = UDim2.new(0.1, 0, 0.1, 0)
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1)
NextPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = NextPage

local PageLabel = Instance.new("TextLabel", BackFrame)
PageLabel.Position = UDim2.new(0.5, 0, -0.12, 0)
PageLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
PageLabel.AnchorPoint = Vector2.new(0.5,0.5)
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.BackgroundColor3 = Color3.new(0,0,0)
PageLabel.TextColor3 = Color3.new(0,1,0)
PageLabel.BackgroundTransparency = 0.3
Corner:Clone().Parent = PageLabel

ContextActionService:BindActionAtPriority("Emote Menu", function(_, state)
    if state == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, false, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

local function PlayEmote(name, id)
    BackFrame.Visible = false
    Open.Text = "Open"
    local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    local Description = Humanoid:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", Humanoid)
    if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        pcall(function()
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end)
        if not pcall(function() Humanoid:PlayEmoteAndGetAnimTrackById(id) end) then
            Description:AddEmote(name, id)
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end
    end
end

-- ✅ TU LISTA DE EMOTES (copia toda tu tabla aquí)
local Emotes = {
    { name = "Around Town", id = 3576747102, icon = "rbxthumb://type=Asset&id=3576747102&w=150&h=150", price = 1000, lastupdated = 1663264200, sort = {} },
    { name = "TWICE TAKEDOWN DANCE 2", id = 85623000473425, icon = "rbxthumb://type=Asset&id=85623000473425&w=150&h=150", price = 100, lastupdated = 1752192000, sort = {} },
    --... PEGA TODOS TUS EMOTES AQUÍ (los 300+)...
    { name = "Shrug", id = 3576968026, icon = "rbxthumb://type=Asset&id=3576968026&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },
}

-- Cargar favoritos
if isfile and isfile("FavoritedEmotes.txt") then
    pcall(function()
        FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt"))
    end)
end

-- Ordenar
table.sort(Emotes, function(a,b) return a.name:lower() < b.name:lower() end)
for i,v in ipairs(Emotes) do v.sort.recentfirst = i end

local function ShowPage(page)
    for _,v in pairs(Frame:GetChildren()) do
        if v:IsA("GuiButton") then v:Destroy() end
    end

    local totalPages = math.ceil(#Emotes / EMOTES_PER_PAGE)
    CurrentPage = math.clamp(page, 1, totalPages)
    PageLabel.Text = CurrentPage.."/"..totalPages
    PrevPage.Visible = CurrentPage > 1
    NextPage.Visible = CurrentPage < totalPages

    local startIdx = (CurrentPage-1)*EMOTES_PER_PAGE + 1
    local endIdx = math.min(CurrentPage*EMOTES_PER_PAGE, #Emotes)

    for i = startIdx, endIdx do
        local Emote = Emotes[i]
        local btn = Instance.new("ImageButton")
        btn.Name = tostring(Emote.id)
        btn.Image = Emote.icon
        btn.BackgroundTransparency = 0.5
        btn.BackgroundColor3 = Color3.new(0,0,0)
        btn.LayoutOrder = i
        Corner:Clone().Parent = btn
        btn.Parent = Frame

        btn.MouseButton1Click:Connect(function()
            PlayEmote(Emote.name, Emote.id)
        end)
        btn.MouseEnter:Connect(function()
            EmoteName.Text = Emote.name
        end)
    end
end

PrevPage.MouseButton1Click:Connect(function() ShowPage(CurrentPage-1) end)
NextPage.MouseButton1Click:Connect(function() ShowPage(CurrentPage+1) end)

ShowPage(1)

StarterGui:SetCore("SendNotification",{
    Title = "Done!",
    Text = #Emotes.." emotes loaded instantly!",
    Duration = 5
})
