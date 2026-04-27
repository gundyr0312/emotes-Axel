--- Keybind: "," - Emotes v4 OPTIMIZED [7yd7/sniper-Emote]
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then
    return
end
env.LastExecuted = tick()

-- ============================================
-- 🔥 CONFIG + CACHE
-- ============================================
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local EMOTES_URL = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json"

local Emotes = {}
local totalPages = 1
local currentPage, EMOTES_PER_PAGE = 1, 300
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil
local currentTrackId = nil

-- 🔥 CACHES PARA OPTIMIZACIÓN
local animatorCache = {}
local animCache = {}
local buttonPool = {}
local renderingPage = false
local searchDebounce = false

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)

-- 🔥 FUNCIÓN NOTIFY SIN SPAM
local function notify(t, txt, d)
    task.spawn(function()
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = t,
                Text = txt,
                Duration = d or 2
            })
        end)
    end)
end

notify("Cargando...", "Descargando 38k emotes", 10)

local success, result = pcall(function()
    local data = game:HttpGet(EMOTES_URL)
    return HttpService:JSONDecode(data)
end)

if success and result then
    Emotes = result.data or result
    totalPages = math.max(1, math.ceil(#Emotes / EMOTES_PER_PAGE)) -- 🔥 CACHE TOTAL PAGES
    notify("✓ Emotes cargados", #Emotes.. " emotes listos", 3)
else
    warn("Error cargando emotes: ".. tostring(result))
    Emotes = {{ name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" }}
    totalPages = 1
end

-- ============================================
-- GUI SETUP
-- ============================================
if CoreGui:FindFirstChild("Emotes") then
    CoreGui:FindFirstChild("Emotes"):Destroy()
end
wait(0.5)

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
Open.TextColor3 = Color3.new(1, 1)
Open.TextScaled = true
Open.BackgroundTransparency = 0.5
Open.MouseButton1Up:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
    EmoteName.Text = "Select"
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
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30)
EmoteName.TextColor3 = Color3.new(1, 1)
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
WalkButton.TextColor3 = Color3.new(1, 1)
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
SpeedLabel.TextColor3 = Color3.new(1, 1)
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
SpeedUp.TextColor3 = Color3.new(1, 1)
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
SpeedDown.TextColor3 = Color3.new(1, 1)
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
PrevPage.TextColor3 = Color3.new(1, 1)
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
PageLabel.Text = "1/".. totalPages
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
NextPage.TextColor3 = Color3.new(1, 1)
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
SearchBar.PlaceholderText = "Search 38k emotes..."
SearchBar.TextScaled = true
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.TextColor3 = Color3.new(1, 1)
SearchBar.BackgroundTransparency = 0.3
SearchBar.Parent = BackFrame
Corner:Clone().Parent = SearchBar
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = ELECTRIC_BLUE
SearchStroke.Thickness = 2

-- 🔥 SEARCH CON DEBOUNCE (OPTIMIZACIÓN #3)
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then return end
    searchDebounce = true

    task.delay(0.15, function()
        local lowerText = SearchBar.Text:lower() -- 🔥 OPTIMIZACIÓN #9

        for _, btn in pairs(Frame:GetChildren()) do
            if btn:IsA("GuiButton") then
                local name = btn:GetAttribute("name") or ""
                local lowerName = name:lower() -- 🔥 OPTIMIZACIÓN #9
                btn.Visible = lowerText == "" or lowerName:find(lowerText)
            end
        end

        searchDebounce = false
    end)
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_, s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
        EmoteName.Text = "Select"
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

-- 🔥 FUNCIÓN OPTIMIZADA CON CACHE DE ANIMATOR (#5) Y ANIMATION (#7)
local function PlayEmote(name, id)
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- 🔥 CACHE DE ANIMATOR (OPTIMIZACIÓN #5)
    local animator = animatorCache[hum]
    if not animator then
        animator = hum:FindFirstChildOfClass("Animator")
        animatorCache[hum] = animator
    end
    if not animator then return end

    local animationId = "rbxassetid://".. id

    -- 🔥 SI ES EL MISMO EMOTE -> REINICIAR
    if currentTrack and currentTrackId == id then
        pcall(function()
            currentTrack:Stop(0)
            currentTrack.TimePosition = 0
            currentTrack:Play()
        end)
        notify("✓ ".. name, "Reiniciado", 1)
        BackFrame.Visible = false
        Open.Text = "Open"
        return
    end

    -- 🔥 LIMPIAR OTROS EMOTES (USANDO CACHE DE ANIMATOR)
    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
        pcall(function()
            track:Stop(0)
            track:Destroy()
        end)
    end

    currentTrack = nil
    currentTrackId = nil
    task.wait(0.03)

    -- 🔥 CACHE DE ANIMATION OBJECT (OPTIMIZACIÓN #7)
    local anim = animCache[id]
    if not anim then
        anim = Instance.new("Animation")
        anim.AnimationId = animationId
        animCache[id] = anim
    end

    local track = animator:LoadAnimation(anim)
    currentTrack = track
    currentTrackId = id

    -- 🔥 CONFIG
    track.Priority = canWalk and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action
    track.Looped = canWalk
    track:AdjustSpeed(emoteSpeed)

    track:Play(0)

    -- 🔥 LIMPIEZA SEGURA CON DISCONNECT (OPTIMIZACIÓN #8)
    local conn
    conn = track.Stopped:Connect(function()
        conn:Disconnect() -- 🔥 PREVIENE LEAKS
        if currentTrack == track then
            currentTrack = nil
            currentTrackId = nil
        end
        pcall(function()
            track:Destroy()
            -- NO destruir anim porque está cacheado
        end)
    end)

    notify("✓ "..name, "Emote reproducido", 2)

    BackFrame.Visible = false
    Open.Text = "Open"
end

-- 🔥 POOL DE BOTONES PARA NO DESTRUIR (OPTIMIZACIÓN #1)
local function getOrCreateButton(index)
    local btn = buttonPool[index]
    if not btn then
        btn = Instance.new("ImageButton")
        btn.BackgroundTransparency = 0.3
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.LayoutOrder = index
        btn.Parent = Frame

        local aspect = Instance.new("UIAspectRatioConstraint", btn)
        aspect.AspectType = Enum.AspectType.ScaleWithParentSize

        Corner:Clone().Parent = btn

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = ELECTRIC_BLUE
        btnStroke.Thickness = 1
        btnStroke.Transparency = 0.6

        local tooltip = Instance.new("TextLabel")
        tooltip.TextScaled = true
        tooltip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tooltip.BackgroundTransparency = 0.2
        tooltip.TextColor3 = Color3.new(1, 1)
        tooltip.Size = UDim2.new(1, 0, 0.3, 0)
        tooltip.Position = UDim2.new(0, 0, 1, 0)
        tooltip.Visible = false
        tooltip.Parent = btn
        Corner:Clone().Parent = tooltip

        buttonPool[index] = btn
    end
    return btn
end

-- 🔥 SHOWPAGE OPTIMIZADO (OPTIMIZACIÓN #1, #2, #10)
local function ShowPage(page)
    if renderingPage then return end -- 🔥 OPTIMIZACIÓN #10
    renderingPage = true

    -- 🔥 OCULTAR TODOS EN VEZ DE DESTRUIR (OPTIMIZACIÓN #1)
    for _, v in pairs(Frame:GetChildren()) do
        if v:IsA("GuiButton") then
            v.Visible = false
        end
    end

    if #Emotes == 0 then
        local emptyLabel = getOrCreateButton(1)
        emptyLabel.Image = ""
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Visible = true
        PageLabel.Text = "0/0"
        PrevPage.Visible = false
        NextPage.Visible = false
        renderingPage = false
        return
    end

    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #Emotes)

    PageLabel.Text = page.. "/".. totalPages -- 🔥 USA CACHE (OPTIMIZACIÓN #2)
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages

    local btnIndex = 1
    for i = startIdx, endIdx do
        local item = Emotes[i]
        if item then
            local btn = getOrCreateButton(btnIndex)
            btn.Name = tostring(item.id)
            btn:SetAttribute("name", item.name)
            btn.Image = item.icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
            btn.Visible = true
            btn.LayoutOrder = i

            local btnStroke = btn:FindFirstChildOfClass("UIStroke")
            local tooltip = btn:FindFirstChild("TextLabel")

            -- 🔥 LIMPIAR CONEXIONES VIEJAS
            for _, conn in pairs(btn:GetConnections("MouseEnter")) do conn:Disconnect() end
            for _, conn in pairs(btn:GetConnections("MouseLeave")) do conn:Disconnect() end
            for _, conn in pairs(btn:GetConnections("MouseButton1Click")) do conn:Disconnect() end

            btn.MouseEnter:Connect(function()
                EmoteName.Text = item.name
                if btnStroke then
                    btnStroke.Transparency = 0
                    btnStroke.Thickness = 2
                end
                if tooltip then tooltip.Visible = true end
            end)

            btn.MouseLeave:Connect(function()
                if btnStroke then
                    btnStroke.Transparency = 0.6
                    btnStroke.Thickness = 1
                end
                if tooltip then tooltip.Visible = false end
            end)

            btn.MouseButton1Click:Connect(function()
                PlayEmote(item.name, item.id)
            end)

            btnIndex = btnIndex + 1
        end
    end

    renderingPage = false -- 🔥 OPTIMIZACIÓN #10
end

-- Eventos de botones
WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: ".. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)

    if currentTrack and currentTrack.IsPlaying then
        if canWalk then
            currentTrack.Priority = Enum.AnimationPriority.Movement
            currentTrack.Looped = true
        else
            currentTrack.Priority = Enum.AnimationPriority.Action
            currentTrack.Looped = false
        end
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
    if currentTrack then
        pcall(function() currentTrack:AdjustSpeed(emoteSpeed) end)
    end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
    if currentTrack then
        pcall(function() currentTrack:AdjustSpeed(emoteSpeed) end)
    end
end)

PrevPage.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        ShowPage(currentPage)
    end
end)

NextPage.MouseButton1Click:Connect(function()
    if currentPage < totalPages then
        currentPage = currentPage + 1
        ShowPage(currentPage)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    currentTrack = nil
    currentTrackId = nil
    animatorCache = {} -- 🔥 LIMPIAR CACHE AL RESPAWNEAR
    currentPage = 1
    ShowPage(1)
end)

if LocalPlayer.Character then
    ShowPage(1)
end

notify("Ready!", "Press, to open - ".. #Emotes.. " emotes loaded", 5)
