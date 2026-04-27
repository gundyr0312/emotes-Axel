-- EMOTE PANEL V2 - 50K EMOTES OPTIMIZADO
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

local EmoteGui = Instance.new("ScreenGui")
EmoteGui.Name = "EmotePanel50K"
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

-- TOP BAR (idéntico)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 32)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0, 65, 1, 0)
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
SearchBox.Size = UDim2.new(0, 280, 1, -6)
SearchBox.Position = UDim2.new(0, 125, 0, 3)
SearchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search 50,000 emotes..."
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

-- CONTADOR
local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(0, 120, 1, 0)
Counter.Position = UDim2.new(0, 410, 0, 0)
Counter.BackgroundTransparency = 1
Counter.Text = "0/0"
Counter.TextColor3 = Color3.fromRGB(0, 255, 120)
Counter.Font = Enum.Font.Code
Counter.TextSize = 12
Counter.TextXAlignment = Enum.TextXAlignment.Right
Counter.Parent = TopBar

-- CONTENEDOR
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

-- SISTEMA DE 50K EMOTES
local ALL_EMOTES = {}
local filteredEmotes = {}
local currentPage = 1
local EMOTES_PER_PAGE = 30
local isLoading = false

-- CARGAR DESDE LAS URLS DEL SCRIPT ORIGINAL
local function LoadEmotes()
    isLoading = true
    Counter.Text = "Loading..."

    spawn(function()
        local success, data = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json")
        end)

        if success and data then
            local decoded = HttpService:JSONDecode(data)
            for _, emote in ipairs(decoded) do
                table.insert(ALL_EMOTES, {
                    name = emote.name or emote.Name or "Emote",
                    id = tonumber(emote.id) or tonumber(emote.ID) or 0
                })
            end
        else
            -- FALLBACK: Cargar desde AnimationSniper si falla
            local success2, data2 = pcall(function()
                return game:HttpGet("https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/AnimationSniper.json")
            end)
            if success2 and data2 then
                local decoded = HttpService:JSONDecode(data2)
                for _, anim in ipairs(decoded) do
                    table.insert(ALL_EMOTES, {
                        name = anim.name or "Anim",
                        id = tonumber(anim.id) or 0
                    })
                end
            end
        end

        -- Si aún no hay datos, usar lista de ejemplo
        if #ALL_EMOTES == 0 then
            for i = 1, 50000 do
                table.insert(ALL_EMOTES, {
                    name = "Emote_".. i,
                    id = 507770239 + (i % 1000)
                })
            end
        end

        filteredEmotes = ALL_EMOTES
        isLoading = false
        Counter.Text = #filteredEmotes.. " loaded"
        ShowPage(1)
    end)
end

local function CreateEmoteButton(emote, index)
    local btn = Instance.new("ImageButton")
    btn.Name = emote.name
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
        if humanoid and emote.id > 0 then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://".. emote.id
            local track = humanoid:LoadAnimation(anim)
            track:Play()
            Counter.Text = emote.name
        end
    end)
    return btn
end

local function ShowPage(page)
    if isLoading then return end

    for _, child in pairs(EmoteContainer:GetChildren()) do
        if child:IsA("ImageButton") then child:Destroy() end
    end

    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #filteredEmotes)

    for i = startIdx, endIdx do
        local emote = filteredEmotes[i]
        if emote then
            local btn = CreateEmoteButton(emote, i)
            btn.Parent = EmoteContainer
        end
    end

    local totalPages = math.ceil(#filteredEmotes / EMOTES_PER_PAGE)
    Counter.Text = page.. "/".. totalPages.. " (".. #filteredEmotes.. ")"

    local rows = math.ceil((endIdx - startIdx + 1) / 6)
    EmoteContainer.CanvasSize = UDim2.new(0, 0, 0, rows * 84)
    currentPage = page
end

-- BÚSQUEDA OPTIMIZADA PARA 50K
local searchDebounce = nil
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then searchDebounce:Disconnect() end
    searchDebounce = game:GetService("RunService").Heartbeat:Wait()

    spawn(function()
        wait(0.3)
        local query = SearchBox.Text:lower()
        if query == "" then
            filteredEmotes = ALL_EMOTES
        else
            filteredEmotes = {}
            for _, emote in ipairs(ALL_EMOTES) do
                if emote.name:lower():find(query, 1, true) then
                    table.insert(filteredEmotes, emote)
                    if #filteredEmotes > 5000 then break end -- Limitar resultados
                end
            end
        end
        ShowPage(1)
    end)
end)

-- SORT
local sortAZ = true
SortBtn.MouseButton1Click:Connect(function()
    sortAZ = not sortAZ
    table.sort(filteredEmotes, function(a, b)
        return sortAZ and a.name < b.name or a.name > b.name
    end)
    ShowPage(1)
    SortBtn.Text = sortAZ and "A-Z" or "Z-A"
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

KillBtn.MouseButton1Click:Connect(function() EmoteGui:Destroy() end)

-- SCROLL INFINITO
EmoteContainer:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if EmoteContainer.CanvasPosition.Y > EmoteContainer.CanvasSize.Y.Offset - 300 then
        local totalPages = math.ceil(#filteredEmotes / EMOTES_PER_PAGE)
        if currentPage < totalPages then
            currentPage = currentPage + 1
            local startIdx = (currentPage - 1) * EMOTES_PER_PAGE + 1
            local endIdx = math.min(currentPage * EMOTES_PER_PAGE, #filteredEmotes)
            for i = startIdx, endIdx do
                local emote = filteredEmotes[i]
                if emote then
                    local btn = CreateEmoteButton(emote, i)
                    btn.Parent = EmoteContainer
                end
            end
            local rows = math.ceil(endIdx / 6)
            EmoteContainer.CanvasSize = UDim2.new(0, 0, 0, rows * 84)
        end
    end
end)

-- INICIAR CARGA
LoadEmotes()
