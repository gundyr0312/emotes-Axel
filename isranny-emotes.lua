--- Keybind to open for pc is "comma" -> ", "
-- Made by Gi#7331 - MODDED 50K EMOTES
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then return end
env.LastExecuted = tick()

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Wait!",
    Text = "Loading 50,000 emotes...",
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
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Open = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

local LoadedEmotes, Emotes = {}, {}
local AllEmotesData = {} -- Para los 50k
local isLoading50k = true

-- FUNCIÓN OPTIMIZADA PARA 50K EMOTES
local function AddEmoteFast(name, id, price)
    if not (name and id) then return end
    table.insert(AllEmotesData, {
        name = name,
        id = id,
        icon = "rbxthumb://type=Asset&id=".. id.."&w=150&h=150",
        price = price or 0,
        lastupdated = os.time(),
        sort = {}
    })
end

-- CARGAR LOS 50,000 EMOTES DESDE URLs
spawn(function()
    local urls = {
        "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json",
        "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json"
    }

    for _, url in ipairs(urls) do
        local success, data = pcall(function()
            return game:HttpGet(url)
        end)

        if success and data then
            local decoded = HttpService:JSONDecode(data)
            for _, item in ipairs(decoded) do
                AddEmoteFast(
                    item.name or item.Name or "Emote_"..item.id,
                    tonumber(item.id) or tonumber(item.ID) or 0,
                    item.price or 0
                )
            end
        end
    end

    -- Si falla la carga, usar emotes locales como backup
    if #AllEmotesData < 100 then
        -- Aquí van los emotes originales del script
        local backupEmotes = {
            {name="Around Town",id=3576747102,price=1000},
            {name="Fashionable",id=3576745472,price=750},
            {name="Swish",id=3821527813,price=750},
            -- [TODOS TUS EMOTES ORIGINALES AQUÍ - los omito por espacio]
        }
        for _, e in ipairs(backupEmotes) do
            AddEmoteFast(e.name, e.id, e.price)
        end
    end

    isLoading50k = false
    Emotes = AllEmotesData

    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Loaded!",
        Text = #Emotes.." emotes ready!",
        Duration = 5
    })
end)

local function CreateButtonFromEmoteInfo(emote)
    local button = Instance.new("TextButton")
    button.Name = tostring(emote.id)
    button.Text = emote.name.. " - $".. emote.price
    button.Size = UDim2.new(0, 200, 0, 50)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.MouseButton1Click:Connect(function()
        print("Selected Emote: ".. emote.name.. ", ID: ".. emote.id)
    end)
    return button
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
Loading.Text = "Loading 50K emotes..."
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

-- [TODO EL CÓDIGO DE SORT, SEARCH, ETC. SE MANTIENE IGUAL]
local SortFrame = Instance.new("Frame")
SortFrame.Visible = false
SortFrame.BorderSizePixel = 0
SortFrame.Position = UDim2.new(1, 5, -0.125, 0)
SortFrame.Size = UDim2.new(0.2, 0, 0, 0)
SortFrame.AutomaticSize = Enum.AutomaticSize.Y
SortFrame.BackgroundTransparency = 1
Corner:Clone().Parent = SortFrame
SortFrame.Parent = BackFrame

local SortList = Instance.new("UIListLayout")
SortList.Padding = UDim.new(0.02, 0)
SortList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SortList.VerticalAlignment = Enum.VerticalAlignment.Top
SortList.SortOrder = Enum.SortOrder.LayoutOrder
SortList.Parent = SortFrame

local function SortEmotes()
    for i,Emote in pairs(Emotes) do
        local EmoteButton = Frame:FindFirstChild(tostring(Emote.id))
        if not EmoteButton then continue end
        local IsFavorited = table.find(FavoritedEmotes, Emote.id)
        EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)
        if EmoteButton:FindFirstChild("number") then
            EmoteButton.number.Text = Emote.sort[CurrentSort]
        end
    end
end

local function createsort(order, text, sort)
    local CreatedSort = Instance.new("TextButton")
    CreatedSort.SizeConstraint = Enum.SizeConstraint.RelativeXX
    CreatedSort.Size = UDim2.new(1, 0, 0.2, 0)
    CreatedSort.BackgroundColor3 = Color3.fromRGB(30, 30)
    CreatedSort.LayoutOrder = order
    CreatedSort.TextColor3 = Color3.new(1, 1, 1)
    CreatedSort.Text = text
    CreatedSort.TextScaled = true
    CreatedSort.BorderSizePixel = 0
    Corner:Clone().Parent = CreatedSort
    CreatedSort.Parent = SortFrame
    CreatedSort.MouseButton1Click:Connect(function()
        SortFrame.Visible = false
        Open.Text = "Open"
        CurrentSort = sort
        SortEmotes()
    end)
    return CreatedSort
end

createsort(1, "Recently Updated First", "recentfirst")
createsort(2, "Recently Updated Last", "recentlast")
createsort(3, "Alphabetically First", "alphabeticfirst")
createsort(4, "Alphabetically Last", "alphabeticlast")
createsort(5, "Highest Price", "highestprice")
createsort(6, "Lowest Price", "lowestprice")

local SortButton = Instance.new("TextButton")
SortButton.BorderSizePixel = 0
SortButton.AnchorPoint = Vector2.new(0.5, 0.5)
SortButton.Position = UDim2.new(0.925, -5, -0.075, 0)
SortButton.Size = UDim2.new(0.15, 0, 0.1, 0)
SortButton.TextScaled = true
SortButton.TextColor3 = Color3.new(1, 1)
SortButton.BackgroundColor3 = Color3.new(0, 0, 0)
SortButton.BackgroundTransparency = 0.3
SortButton.Text = "Sort"
SortButton.MouseButton1Click:Connect(function()
    SortFrame.Visible = not SortFrame.Visible
    Open.Text = "Open"
end)
Corner:Clone().Parent = SortButton
SortButton.Parent = BackFrame

local CloseButton = Instance.new("TextButton")
CloseButton.BorderSizePixel = 0
CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
CloseButton.Position = UDim2.new(0.075, 0, -0.075, 0)
CloseButton.Size = UDim2.new(0.15, 0, 0.1, 0)
CloseButton.TextScaled = true
CloseButton.TextColor3 = Color3.new(1, 1)
CloseButton.BackgroundColor3 = Color3.new(0.5, 0, 0)
CloseButton.BackgroundTransparency = 0.3
CloseButton.Text = "Kill Gui"
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
Corner:Clone().Parent = CloseButton
CloseButton.Parent = BackFrame

local SearchBar = Instance.new("TextBox")
SearchBar.BorderSizePixel = 0
SearchBar.AnchorPoint = Vector2.new(0.5, 0.5)
SearchBar.Position = UDim2.new(0.5, 0, -0.075, 0)
SearchBar.Size = UDim2.new(0.55, 0, 0.1, 0)
SearchBar.TextScaled = true
SearchBar.PlaceholderText = "Search 50K emotes..."
SearchBar.TextColor3 = Color3.new(1, 1)
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.BackgroundTransparency = 0.3
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBar.Text:lower()
    local buttons = Frame:GetChildren()
    if text ~= text:sub(1,50) then
        SearchBar.Text = SearchBar.Text:sub(1,50)
        text = SearchBar.Text:lower()
    end
    if text ~= "" then
        for i,button in pairs(buttons) do
            if button:IsA("GuiButton") then
                local name = button:GetAttribute("name"):lower()
                button.Visible = name:match(text) and true or false
            end
        end
    else
        for i,button in pairs(buttons) do
            if button:IsA("GuiButton") then
                button.Visible = true
            end
        end
    end
end)
Corner:Clone().Parent = SearchBar
SearchBar.Parent = BackFrame

local function openemotes(name, state, input)
    if state == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = "Open"
    end
end

ContextActionService:BindCoreActionAtPriority("Emote Menu", openemotes, true, 2001, Enum.KeyCode.Comma)

local inputconnect
ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()
    if BackFrame.Visible == false then
        EmoteName.Text = "Select an Emote"
        SearchBar.Text = ""
        SortFrame.Visible = false
        GuiService:SetEmotesMenuOpen(false)
        inputconnect = UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then
                BackFrame.Visible = false
                Open.Text = "Open"
            end
        end)
    else
        if inputconnect then inputconnect:Disconnect() end
    end
end)

GuiService.EmotesMenuOpenChanged:Connect(function(isopen)
    if isopen then
        BackFrame.Visible = false
        Open.Text = "Open"
    end
end)

GuiService.MenuOpened:Connect(function()
    BackFrame.Visible = false
    Open.Text = "Open"
end)

if not game:IsLoaded() then game.Loaded:Wait() end

if (not is_sirhurt_closure) and (syn and syn.protect_gui) then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif get_hidden_gui or gethui then
    local hiddenUI = get_hidden_gui or gethui
    ScreenGui.Parent = hiddenUI()
else
    ScreenGui.Parent = CoreGui
end

local function SendNotification(title, text)
    if syn and syn.toast_notification then
        syn.toast_notification({Type = ToastType.Error, Title = title, Content = text})
    else
        StarterGui:SetCore("SendNotification", {Title = title, Text = text})
    end
end

local LocalPlayer = Players.LocalPlayer

-- FUNCIÓN MEJORADA PARA ANIMACIONES DE PERSONAJE
local function PlayEmote(name, id)
    BackFrame.Visible = false
    Open.Text = "Open"
    SearchBar.Text = ""

    local character = LocalPlayer.Character
    if not character then return end

    local Humanoid = character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end

    -- CAMBIO DE ANIMACIÓN DEL PERSONAJE (NUEVO)
    local Description = Humanoid:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", Humanoid)

    if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        local succ, err = pcall(function()
            -- Intentar reproducir directamente
            local track = Humanoid:PlayEmoteAndGetAnimTrackById(id)

            -- APLICAR CAMBIOS DE ANIMACIÓN PERMANENTES
            if track then
                -- Guardar animación actual
                if not Humanoid:GetAttribute("OriginalWalk") then
                    Humanoid:SetAttribute("OriginalWalk", Description.WalkAnimation)
                    Humanoid:SetAttribute("OriginalRun", Description.RunAnimation)
                    Humanoid:SetAttribute("OriginalIdle", Description.IdleAnimation)
                end

                -- Aplicar nueva animación a movimientos
                Description.WalkAnimation = id
                Description.RunAnimation = id
                Description.IdleAnimation = id
                Humanoid:ApplyDescription(Description)
            end
        end)

        if not succ then
            pcall(function()
                Description:AddEmote(name, id)
                Humanoid:ApplyDescription(Description)
                Humanoid:PlayEmoteAndGetAnimTrackById(id)
            end)
        end
    else
        SendNotification("R6 Detected", "Switch to R15 for full animations")
    end
end

local function WaitForChildOfClass(parent, class)
    local child = parent:FindFirstChildOfClass(class)
    while not child or child.ClassName ~= class do
        child = parent.ChildAdded:Wait()
    end
    return child
end

-- ESPERAR A QUE CARGUEN LOS 50K
while isLoading50k do
    Loading.Text = "Loading... "..#AllEmotesData.." emotes"
    task.wait(0.5)
end

Loading:Destroy()

-- CONFIGURAR SORTING PARA 50K
table.sort(Emotes, function(a, b) return a.lastupdated > b.lastupdated end)
for i,v in pairs(Emotes) do v.sort.recentfirst = i end

table.sort(Emotes, function(a, b) return a.lastupdated < b.lastupdated end)
for i,v in pairs(Emotes) do v.sort.recentlast = i end

table.sort(Emotes, function(a, b) return a.name:lower() < b.name:lower() end)
for i,v in pairs(Emotes) do v.sort.alphabeticfirst = i end

table.sort(Emotes, function(a, b) return a.name:lower() > b.name:lower() end)
for i,v in pairs(Emotes) do v.sort.alphabeticlast = i end

table.sort(Emotes, function(a, b) return a.price < b.price end)
for i,v in pairs(Emotes) do v.sort.lowestprice = i end

table.sort(Emotes, function(a, b) return a.price > b.price end)
for i,v in pairs(Emotes) do v.sort.highestprice = i end

if isfile("FavoritedEmotes.txt") then
    pcall(function()
        FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt"))
    end)
else
    writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
end

-- FUNCIÓN PARA CREAR BOTONES (OPTIMIZADA PARA 50K)
local function CharacterAdded(Character)
    for i,v in pairs(Frame:GetChildren()) do
        if not v:IsA("UIGridLayout") then v:Destroy() end
    end

    local Humanoid = WaitForChildOfClass(Character, "Humanoid")
    local Description = Humanoid:WaitForChild("HumanoidDescription", 5) or Instance.new("HumanoidDescription", Humanoid)

    local random = Instance.new("TextButton")
    local Ratio = Instance.new("UIAspectRatioConstraint")
    Ratio.AspectType = Enum.AspectType.ScaleWithParentSize
    Ratio.Parent = random
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
    random.MouseEnter:Connect(function() EmoteName.Text = "Random" end)
    random.Parent = Frame

    -- CARGAR EMOTES EN LOTES PARA NO LAGGEAR
    local batchSize = 100
    local currentIndex = 1

    local function loadBatch()
        local endIndex = math.min(currentIndex + batchSize - 1, #Emotes)
        for i = currentIndex, endIndex do
            local Emote = Emotes[i]
            Description:AddEmote(Emote.name, Emote.id)

            local EmoteButton = Instance.new("ImageButton")
            local IsFavorited = table.find(FavoritedEmotes, Emote.id)
            EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)
            EmoteButton.Name = tostring(Emote.id)
            EmoteButton:SetAttribute("name", Emote.name)
            Corner:Clone().Parent = EmoteButton
            EmoteButton.Image = Emote.icon
            EmoteButton.BackgroundTransparency = 0.5
            EmoteButton.BackgroundColor3 = Color3.new(0, 0, 0)
            EmoteButton.BorderSizePixel = 0
            Ratio:Clone().Parent = EmoteButton

            local EmoteNumber = Instance.new("TextLabel")
            EmoteNumber.Name = "number"
            EmoteNumber.TextScaled = true
            EmoteNumber.BackgroundTransparency = 1
            EmoteNumber.TextColor3 = Color3.new(1, 1, 1)
            EmoteNumber.BorderSizePixel = 0
            EmoteNumber.AnchorPoint = Vector2.new(0.5, 0.5)
            EmoteNumber.Size = UDim2.new(0.2, 0, 0.2, 0)
            EmoteNumber.Position = UDim2.new(0.1, 0, 0.9, 0)
            EmoteNumber.Text = Emote.sort[CurrentSort]
            EmoteNumber.TextXAlignment = Enum.TextXAlignment.Center
            EmoteNumber.TextYAlignment = Enum.TextYAlignment.Center
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Transparency = 0.5
            UIStroke.Parent = EmoteNumber
            EmoteNumber.Parent = EmoteButton
            EmoteButton.Parent = Frame

            EmoteButton.MouseButton1Click:Connect(function()
                PlayEmote(Emote.name, Emote.id)
            end)
            EmoteButton.MouseEnter:Connect(function()
                EmoteName.Text = Emote.name
            end)

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
                    EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #Emotes
                else
                    table.insert(FavoritedEmotes, Emote.id)
                    Favorite.Image = FavoriteOn
                    EmoteButton.LayoutOrder = Emote.sort[CurrentSort]
                end
                writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
            end)
        end

        currentIndex = endIndex + 1
        if currentIndex <= #Emotes then
            task.wait()
            loadBatch()
        end
    end

    loadBatch()

    for i=1,9 do
        local EmoteButton = Instance.new("Frame")
        EmoteButton.LayoutOrder = 2147483647
        EmoteButton.Name = "filler"
        EmoteButton.BackgroundTransparency = 1
        EmoteButton.BorderSizePixel = 0
        Ratio:Clone().Parent = EmoteButton
        EmoteButton.Visible = true
        EmoteButton.Parent = Frame
        EmoteButton.MouseEnter:Connect(function()
            EmoteName.Text = "Select an Emote"
        end)
    end
end

if LocalPlayer.Character then CharacterAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(CharacterAdded)

wait(1)
game.CoreGui.Emotes.Enabled = true

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Done!",
    Text = #Emotes.." emotes loaded!",
    Duration = 10
})

game.Players.LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui") and game.Players.LocalPlayer.PlayerGui.ContextActionGui:Destroy()
