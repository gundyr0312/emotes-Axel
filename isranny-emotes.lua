-- EMOTE PANEL V1 - Replica Exacta
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- GUI PRINCIPAL
local EmoteGui = Instance.new("ScreenGui")
EmoteGui.Name = "EmotePanel"
EmoteGui.ResetOnSpawn = false
EmoteGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 420)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = EmoteGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 4)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 65, 1, 0)
KillBtn.Position = UDim2.new(0, 0, 0, 0)
KillBtn.BackgroundTransparency = 1
KillBtn.Text = "Kill Gui"
KillBtn.TextColor3 = Color3.fromRGB(255, 60, 60)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 14
KillBtn.Parent = TopBar

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(0, 55, 1, 0)
StopBtn.Position = UDim2.new(0, 65, 0, 0)
StopBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StopBtn.BorderSizePixel = 0
StopBtn.Text = "Stop"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.Font = Enum.Font.Gotham
StopBtn.TextSize = 14
StopBtn.Parent = TopBar

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(0, 300, 1, -6)
SearchBox.Position = UDim2.new(0, 125, 0, 3)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search"
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = TopBar
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 3)

local SortBtn = Instance.new("TextButton")
SortBtn.Size = UDim2.new(0, 60, 1, -6)
SortBtn.Position = UDim2.new(1, -65, 0, 3)
SortBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SortBtn.BorderSizePixel = 0
SortBtn.Text = "Sort"
SortBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SortBtn.Font = Enum.Font.Gotham
SortBtn.TextSize = 14
SortBtn.Parent = TopBar
Instance.new("UICorner", SortBtn).CornerRadius = UDim.new(0, 3)

-- CONTENEDOR DE EMOTES
local EmoteContainer = Instance.new("ScrollingFrame")
EmoteContainer.Size = UDim2.new(1, -10, 1, -42)
EmoteContainer.Position = UDim2.new(0, 5, 0, 37)
EmoteContainer.BackgroundTransparency = 1
EmoteContainer.BorderSizePixel = 0
EmoteContainer.ScrollBarThickness = 4
EmoteContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
EmoteContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
EmoteContainer.Parent = MainFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 78, 0, 78)
Grid.CellPadding = UDim2.new(0, 6, 0, 6)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = EmoteContainer

-- LISTA DE EMOTES (60 ejemplos - 2 páginas)
local Emotes = {
    {name = "Wave", id = 507770239},
    {name = "Point", id = 507770453},
    {name = "Dance1", id = 507771019},
    {name = "Dance2", id = 507771955},
    {name = "Dance3", id = 507772104},
    {name = "Laugh", id = 507770818},
    {name = "Cheer", id = 507770677},
    {name = "Agree", id = 507770392},
    {name = "Disagree", id = 507770713},
    {name = "Sleep", id = 507777826},
    {name = "Facepalm", id = 507770768},
    {name = "Strong", id = 4841406616},
    {name = "Parker", id = 782841498},
    {name = "Stylish", id = 4719617025},
    {name = "Tilt", id = 4686926665},
    {name = "Worm", id = 301961592},
    {name = "Penguin", id = 4574115042},
    {name = "Monkey", id = 3333499508},
    {name = "Zombie", id = 4212455378},
    {name = "Ninja", id = 656118852},
    {name = "Hero", id = 538058422},
    {name = "Robot", id = 507771699},
    {name = "Shrug", id = 507770405},
    {name = "Bow", id = 5121890188},
    {name = "Salute", id = 5121865535},
    {name = "Hype", id = 5121885290},
    {name = "Floss", id = 5937560566},
    {name = "Griddy", id = 3360689775},
    {name = "Stadium", id = 3360692915},
    {name = "Jacks", id = 5474732645},
    -- PÁGINA 2
    {name = "Headless", id = 35154961},
    {name = "Toy", id = 2510238627},
    {name = "Confused", id = 4842107428},
    {name = "Thinker", id = 5121869155},
    {name = "Annoyed", id = 5121856893},
    {name = "Scared", id = 5121871068},
    {name = "Cry", id = 5121864702},
    {name = "Faint", id = 5121870961},
    {name = "Idle", id = 782841498},
    {name = "Walk", id = 507777826},
    {name = "Run", id = 507767714},
    {name = "Jump", id = 507765000},
    {name = "Fall", id = 507767968},
    {name = "Swim", id = 507784897},
    {name = "Climb", id = 507765644},
    {name = "Sit", id = 2506281703},
    {name = "Lay", id = 4483362458},
    {name = "Spin", id = 188632011},
    {name = "Cartwheel", id = 389832450},
    {name = "Backflip", id = 35154961},
    {name = "Frontflip", id = 150627520},
    {name = "Handstand", id = 383893880},
    {name = "Breakdance", id = 4647443676},
    {name = "Capoeira", id = 5937444584},
    {name = "Charleston", id = 4296812341},
    {name = "Shuffle", id = 4296820571},
    {name = "Sneak", id = 1132466604},
    {name = "Stroll", id = 3333432454},
    {name = "Swagger", id = 3333171782},
    {name = "Toilet", id = 4415132405},
}

local currentEmotes = {}
local currentPage = 1
local EMOTES_PER_PAGE = 30

-- FUNCIÓN PARA CREAR BOTÓN DE EMOTE
local function CreateEmoteButton(emote, index)
    local btn = Instance.new("ImageButton")
    btn.Name = emote.name
    btn.Size = UDim2.new(0, 78, 0, 78)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.Image = "rbxassetid://".. emote.id
    btn.ImageColor3 = Color3.fromRGB(220, 220, 220)
    btn.ScaleType = Enum.ScaleType.Fit
    btn.LayoutOrder = index
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        stroke.Color = Color3.fromRGB(0, 255, 120)
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        stroke.Color = Color3.fromRGB(60, 60, 60)
    end)

    btn.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://".. emote.id
            local track = humanoid:LoadAnimation(anim)
            track:Play()
        end
    end)

    return btn
end

-- FUNCIÓN PARA MOSTRAR PÁGINA
local function ShowPage(page)
    for _, child in pairs(EmoteContainer:GetChildren()) do
        if child:IsA("ImageButton") then child:Destroy() end
    end

    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #currentEmotes)

    for i = startIdx, endIdx do
        local emote = currentEmotes[i]
        if emote then
            local btn = CreateEmoteButton(emote, i)
            btn.Parent = EmoteContainer
        end
    end

    local rows = math.ceil((endIdx - startIdx + 1) / 6)
    EmoteContainer.CanvasSize = UDim2.new(0, 0, 0, rows * 84)
end

-- BÚSQUEDA
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = SearchBox.Text:lower()
    if query == "" then
        currentEmotes = Emotes
    else
        currentEmotes = {}
        for _, emote in ipairs(Emotes) do
            if emote.name:lower():find(query) then
                table.insert(currentEmotes, emote)
            end
        end
    end
    currentPage = 1
    ShowPage(1)
end)

-- SORT
local sortAZ = true
SortBtn.MouseButton1Click:Connect(function()
    sortAZ = not sortAZ
    table.sort(currentEmotes, function(a, b)
        if sortAZ then
            return a.name < b.name
        else
            return a.name > b.name
        end
    end)
    ShowPage(currentPage)
    SortBtn.Text = sortAZ and "Sort A-Z" or "Sort Z-A"
end)

-- STOP
StopBtn.MouseButton1Click:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
end)

-- KILL GUI
KillBtn.MouseButton1Click:Connect(function()
    EmoteGui:Destroy()
end)

-- PAGINACIÓN CON SCROLL
EmoteContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if EmoteContainer.CanvasPosition.Y > EmoteContainer.CanvasSize.Y.Offset - 400 then
        local totalPages = math.ceil(#currentEmotes / EMOTES_PER_PAGE)
        if currentPage < totalPages then
            currentPage = currentPage + 1
            local startIdx = (currentPage - 1) * EMOTES_PER_PAGE + 1
            local endIdx = math.min(currentPage * EMOTES_PER_PAGE, #currentEmotes)

            for i = startIdx, endIdx do
                local emote = currentEmotes[i]
                if emote then
                    local btn = CreateEmoteButton(emote, i)
                    btn.Parent = EmoteContainer
                end
            end
        end
    end
end)

-- INICIALIZAR
currentEmotes = Emotes
ShowPage(1)

-- FUNCIÓN PARA AGREGAR MÁS EMOTES (crea páginas automáticamente)
function AddEmote(name, id)
    table.insert(Emotes, {name = name, id = id})
    if SearchBox.Text == "" then
        currentEmotes = Emotes
        ShowPage(1)
    end
end

-- Ejemplo: AddEmote("NuevoBaile", 123456789)
