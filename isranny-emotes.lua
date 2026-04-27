--- Keybind to open for pc is "comma" -> ", "
-- Made by Gi#7331 - MOD PAGINADO 20x
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

print("Script executed!")

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Wait!",
    Text = "Please Wait, it just loading the button",
    Duration = 15
})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end

wait(1)

local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")
local Open = Instance.new("TextButton")
UICorner = Instance.new("UICorner")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local LoadedEmotes, Emotes = {}, {}
local CurrentPage = 1
local EMOTES_PER_PAGE = 20 -- ✅ NUEVO

-- [tu función AddEmote igual...]

local function AddEmote(name: string, id: number, price: number?)
    LoadedEmotes[id] = false
    task.spawn(function()
        if not (name and id) then return end
        local success, date = pcall(function()
            local info = MarketplaceService:GetProductInfo(id)
            local updated = info.Updated
            return DateTime.fromIsoDate(updated):ToUniversalTime()
        end)
        if not success or not date then
            task.wait(10)
            AddEmote(name, id, price)
            return
        end
        local unix = os.time({
            year = date.Year,
            month = date.Month,
            day = date.Day,
            hour = date.Hour,
            min = date.Minute,
            sec = date.Second
        })
        LoadedEmotes[id] = true
        local emoteData = {
            name = name,
            id = id,
            icon = "rbxthumb://type=Asset&id=".. id.."&w=150&h=150",
            price = price or 0,
            lastupdated = unix,
            sort = {}
        }
        table.insert(Emotes, emoteData)
    end)
end

local CurrentSort = "recentfirst"
local FavoriteOff = "rbxassetid://10651060677"
local FavoriteOn = "rbxassetid://10651061109"
local FavoritedEmotes = {}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Enabled = true

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.9, 0, 0.5, 0)
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
BackFrame.BackgroundTransparency = 1
BackFrame.BorderSizePixel = 0
BackFrame.Parent = ScreenGui

Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0.05,0,0.114,0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Close"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.fromRGB(255, 255)
Open.TextScaled = true
Open.TextSize = 20
Open.Visible = true
Open.BackgroundTransparency =.5
Open.MouseButton1Up:Connect(function()
    if Open.Text == "Open" then
        Open.Text = "Close"
        BackFrame.Visible = true
    else
        Open.Text = "Open"
        BackFrame.Visible = false
    end
end)

UICorner.Name = "UICorner"
UICorner.Parent = Open
UICorner.CornerRadius = UDim.new(1, 0)

local EmoteName = Instance.new("TextLabel")
EmoteName.Name = "EmoteName"
EmoteName.TextScaled = true
EmoteName.AnchorPoint = Vector2.new(0.5, 0.5)
EmoteName.Position = UDim2.new(-0.1, 0, 0.5, 0)
EmoteName.Size = UDim2.new(0.2, 0, 0.2, 0)
EmoteName.SizeConstraint = Enum.SizeConstraint.RelativeYY
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30)
EmoteName.TextColor3 = Color3.new(1, 1, 1)
EmoteName.BorderSizePixel = 0
EmoteName.Parent = BackFrame

local Corner = Instance.new("UICorner")
Corner.Parent = EmoteName

local Loading = Instance.new("TextLabel", BackFrame)
Loading.AnchorPoint = Vector2.new(0.5, 0.5)
Loading.Text = "Fixing.."
Loading.TextColor3 = Color3.new(1, 1, 1)
Loading.BackgroundColor3 = Color3.new(0, 0, 0)
Loading.TextScaled = true
Loading.BackgroundTransparency = 0.5
Loading.Size = UDim2.fromScale(0.2, 0.1)
Loading.Position = UDim2.fromScale(0.5, 0.2)
Corner:Clone().Parent = Loading

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.CanvasSize = UDim2.new(0, 0, 0, 0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.ScrollingDirection = Enum.ScrollingDirection.Y
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.BorderSizePixel = 0
Frame.MouseLeave:Connect(function()
    EmoteName.Text = "Select an Emote"
end)
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.105, 0, 0, 0)
Grid.CellPadding = UDim2.new(0.006, 0, 0.006, 0)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

-- ✅ NUEVO - BOTONES DE PÁGINA
local PrevPage = Instance.new("TextButton")
PrevPage.Position = UDim2.new(0.3, 0, -0.075, 0)
PrevPage.Size = UDim2.new(0.08, 0, 0.1, 0)
PrevPage.AnchorPoint = Vector2.new(0.5, 0.5)
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1,1)
PrevPage.BackgroundTransparency = 0.3
PrevPage.Parent = BackFrame
Corner:Clone().Parent = PrevPage

local NextPage = Instance.new("TextButton")
NextPage.Position = UDim2.new(0.7, 0, -0.075, 0)
NextPage.Size = UDim2.new(0.08, 0, 0.1, 0)
NextPage.AnchorPoint = Vector2.new(0.5, 0.5)
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1,1)
NextPage.BackgroundTransparency = 0.3
NextPage.Parent = BackFrame
Corner:Clone().Parent = NextPage

local PageLabel = Instance.new("TextLabel")
PageLabel.Position = UDim2.new(0.5, 0, -0.075, 0)
PageLabel.Size = UDim2.new(0.2, 0, 0.1, 0)
PageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.BackgroundColor3 = Color3.new(0,0,0)
PageLabel.TextColor3 = Color3.new(0,1,0)
PageLabel.BackgroundTransparency = 0.3
PageLabel.Parent = BackFrame
Corner:Clone().Parent = PageLabel

-- [todo tu código de SortFrame, SearchBar, etc. queda igual...]
--... (copia todo desde SortFrame hasta antes de CharacterAdded)

local function SendNotification(title, text)
    if syn and syn.toast_notification then
        syn.toast_notification({Type = ToastType.Error, Title = title, Content = text})
    else
        StarterGui:SetCore("SendNotification", {Title = title, Text = text})
    end
end

local LocalPlayer = Players.LocalPlayer

local function PlayEmote(name: string, id: number)
    BackFrame.Visible = false
    Open.Text = "Open"
    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local Description = Humanoid and Humanoid:FindFirstChildOfClass("HumanoidDescription")
    if not Description then return end
    if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        local succ, err = pcall(function()
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end)
        if not succ then
            Description:AddEmote(name, id)
            Humanoid:PlayEmoteAndGetAnimTrackById(id)
        end
    else
        SendNotification("r6? lol", "you gotta be r15 dude")
    end
end

-- [tu lista enorme de Emotes = {... } va aquí igual]

-- ✅ FUNCIÓN MODIFICADA CON PAGINACIÓN
local function CharacterAdded(Character)
    for i,v in pairs(Frame:GetChildren()) do
        if not v:IsA("UIGridLayout") then
            v:Destroy()
        end
    end

    local Humanoid = Character:WaitForChild("Humanoid")
    local Description = Humanoid:WaitForChild("HumanoidDescription", 5) or Instance.new("HumanoidDescription", Humanoid)

    local function ShowPage(page)
        -- limpiar
        for i,v in pairs(Frame:GetChildren()) do
            if v:IsA("GuiButton") or v.Name == "filler" then
                v:Destroy()
            end
        end

        local totalPages = math.ceil(#Emotes / EMOTES_PER_PAGE)
        CurrentPage = math.clamp(page, 1, totalPages)
        PageLabel.Text = CurrentPage.. "/".. totalPages

        PrevPage.Visible = CurrentPage > 1
        NextPage.Visible = CurrentPage < totalPages

        local startIdx = (CurrentPage - 1) * EMOTES_PER_PAGE + 1
        local endIdx = math.min(CurrentPage * EMOTES_PER_PAGE, #Emotes)

        -- botón random solo en página 1
        if CurrentPage == 1 then
            local random = Instance.new("TextButton")
            random.LayoutOrder = 0
            random.TextColor3 = Color3.new(1, 1, 1)
            random.BorderSizePixel = 0
            random.BackgroundTransparency = 0.5
            random.BackgroundColor3 = Color3.new(0, 0, 0)
            random.TextScaled = true
            random.Text = "Random"
            random:SetAttribute("name", "")
            Corner:Clone().Parent = random
            random.MouseButton1Click:Connect(function()
                local randomemote = Emotes[math.random(1, #Emotes)]
                PlayEmote(randomemote.name, randomemote.id)
            end)
            random.MouseEnter:Connect(function()
                EmoteName.Text = "Random"
            end)
            random.Parent = Frame
            Instance.new("UIAspectRatioConstraint", random).AspectType = Enum.AspectType.ScaleWithParentSize
        end

        for i = startIdx, endIdx do
            local Emote = Emotes[i]
            if Emote then
                Description:AddEmote(Emote.name, Emote.id)
                local EmoteButton = Instance.new("ImageButton")
                local IsFavorited = table.find(FavoritedEmotes, Emote.id)
                EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)
                EmoteButton.Name = Emote.id
                EmoteButton:SetAttribute("name", Emote.name)
                Corner:Clone().Parent = EmoteButton
                EmoteButton.Image = Emote.icon
                EmoteButton.BackgroundTransparency = 0.5
                EmoteButton.BackgroundColor3 = Color3.new(0, 0, 0)
                EmoteButton.BorderSizePixel = 0
                Instance.new("UIAspectRatioConstraint", EmoteButton).AspectType = Enum.AspectType.ScaleWithParentSize
                EmoteButton.Parent = Frame
                EmoteButton.MouseButton1Click:Connect(function()
                    PlayEmote(Emote.name, Emote.id)
                end)
                EmoteButton.MouseEnter:Connect(function()
                    EmoteName.Text = Emote.name
                end)

                -- favorito
                local Favorite = Instance.new("ImageButton")
                Favorite.Name = "favorite"
                Favorite.Image = table.find(FavoritedEmotes, Emote.id) and FavoriteOn or FavoriteOff
                Favorite.AnchorPoint = Vector2.new(0.5, 0.5)
                Favorite.Size = UDim2.new(0.2, 0, 0.2, 0)
                Favorite.Position = UDim2.new(0.9, 0, 0.9, 0)
                Favorite.BorderSizePixel = 0
                Favorite.BackgroundTransparency = 1
                Favorite.Parent = EmoteButton
                Favorite.MouseButton1Click:Connect(function()
                    local index = table.find(FavoritedEmotes, Emote.id)
                    if index then
                        table.remove(FavoritedEmotes, index)
                        Favorite.Image = FavoriteOff
                    else
                        table.insert(FavoritedEmotes, Emote.id)
                        Favorite.Image = FavoriteOn
                    end
                    writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
                end)
            end
        end
    end

    PrevPage.MouseButton1Click:Connect(function()
        ShowPage(CurrentPage - 1)
    end)

    NextPage.MouseButton1Click:Connect(function()
        ShowPage(CurrentPage + 1)
    end)

    ShowPage(1)
end

if LocalPlayer.Character then
    CharacterAdded(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(CharacterAdded)

-- [resto de tu código igual: wait(1), notificaciones, etc.]
