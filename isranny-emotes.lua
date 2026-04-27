--- Keybind: "," - Emotes v4 [BUG-FIXED FINAL]
local env = getgenv()
if env.LastExecuted and tick() - env.LastExecuted < 30 then
    return
end
env.LastExecuted = tick()

-- ============================================
-- 🔥 SERVICES + CONFIG
-- ============================================
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local EMOTES_URL = "https://raw.githubusercontent.com/7yd7/sniper-Emote/refs/heads/test/EmoteSniper.json"

local Emotes = {}
local currentPage, EMOTES_PER_PAGE = 1, 20
local totalPages = 1

local emoteSpeed = 1
local canWalk = false
local currentTrack, currentTrackId = nil, nil

-- 🔥 OPTIMIZATION CACHE
local animatorCache = {}
local animCache = {}
local buttonPool = {}
local connectionCache = {}
local fallbackCache = {}
local renderingPage = false
local searchDebounce = false
local showDebounce = false
local lastSearch = ""

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)

-- ============================================
-- 🔔 NOTIFY OPTIMIZED
-- ============================================
local function notify(t, txt, d)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = t,
            Text = txt,
            Duration = d or 2
        })
    end)
end

notify("Cargando...", "Descargando 38k emotes", 8)

-- ============================================
-- 📦 LOAD EMOTES
-- ============================================
local success, result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(EMOTES_URL))
end)

if success and result then
    Emotes = result.data or result
else
    Emotes = {
        { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" }
    }
end

totalPages = math.max(1, math.ceil(#Emotes / EMOTES_PER_PAGE))

-- ============================================
-- 🧹 RESET GUI
-- ============================================
if CoreGui:FindFirstChild("Emotes") then
    CoreGui.Emotes:Destroy()
end

task.wait(0.3)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Emotes"
ScreenGui.DisplayOrder = 2
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local BackFrame = Instance.new("Frame")
BackFrame.Size = UDim2.new(0.9, 0, 0.55, 0)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
BackFrame.AnchorPoint = Vector2.new(0.5,0.5)
BackFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
BackFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
BackFrame.BackgroundTransparency = 0.2 
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
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EmoteName.TextColor3 = Color3.new(1, 1)
EmoteName.Text = "Select"
EmoteName.Parent = BackFrame
Corner:Clone().Parent = EmoteName
local NameStroke = Instance.new("UIStroke", EmoteName)
NameStroke.Color = ELECTRIC_BLUE
NameStroke.Thickness = 2

local Frame = Instance.new("ScrollingFrame")
Frame.Size = UDim2.new(1,0,1,0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.ScrollBarImageColor3 = ELECTRIC_BLUE
Frame.Position = UDim2.new(0.5,0,0.5,0)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.105,0,0,0)
Grid.CellPadding = UDim2.new(0.006,0,0.006,0)
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

-- ============================================
-- 🔥 HELPER: CLEAR CONNECTIONS (FIX #1)
-- ============================================
local function clearConnections(btn)
    if not connectionCache[btn] then return end
    for _, c in ipairs(connectionCache[btn]) do
        pcall(function() c:Disconnect() end)
    end
    connectionCache[btn] = {}
end

-- 🔥 HELPER: GET STROKE (FIX #4)
local function getStroke(btn)
    return btn:FindFirstChildOfClass("UIStroke")
end

-- ============================================
-- 🧠 PLAY EMOTE OPTIMIZED
-- ============================================
local function PlayEmote(name, id)
    local char = Players.LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = animatorCache[hum]
    if not animator or not animator.Parent then
        animator = hum:FindFirstChildOfClass("Animator")
        animatorCache[hum] = animator
    end
    if not animator then return end

    if currentTrack and currentTrackId == id then
        pcall(function()
            currentTrack:Stop(0)
            currentTrack.TimePosition = 0
            currentTrack:Play()
        end)
        notify("Reiniciado", name)
        return
    end

    if currentTrack then
        pcall(function()
            currentTrack:Stop(0)
            task.wait()
            currentTrack:Destroy()
        end)
    end

    local anim = animCache[id]
    if not anim then
        anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..id
        animCache[id] = anim
    end

    local track = animator:LoadAnimation(anim)
    currentTrack, currentTrackId = track, id

    track.Priority = canWalk and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action
    track.Looped = canWalk
    track:AdjustSpeed(emoteSpeed)
    track:Play(0)

    local conn
    conn = track.Stopped:Connect(function()
        conn:Disconnect()
        if currentTrack == track then
            currentTrack = nil
            currentTrackId = nil
        end
        pcall(function() track:Destroy() end)
    end)

    notify("Emote", name)
end

-- ============================================
-- 🎮 BUTTON POOL
-- ============================================
local function getButton(i)
    local btn = buttonPool[i]
    if not btn then
        btn = Instance.new("ImageButton")
        btn.BackgroundTransparency = 0.3
        btn.BackgroundColor3 = Color3.fromRGB(20, 20)
        btn.Parent = Frame
        Instance.new("UIAspectRatioConstraint", btn)
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
        buttonPool[i] = btn
    end
    return btn
end

-- ============================================
-- 📄 SHOW PAGE OPTIMIZED
-- ============================================
local function ShowPage(page)
    if renderingPage then return end
    renderingPage = true
    showDebounce = true
    currentPage = page

    for _, v in pairs(Frame:GetChildren()) do
        if v:IsA("GuiButton") then
            v.Visible = false
        end
    end

    local start = (page-1)*EMOTES_PER_PAGE + 1
    local finish = math.min(page*EMOTES_PER_PAGE, #Emotes)

    PageLabel.Text = page.."/"..totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages

    local index = 1
    for i = start, finish do
        local data = Emotes[i]
        if data then
            local btn = getButton(index)
            index += 1
            btn.Visible = true
            btn.LayoutOrder = i

            -- 🔥 FIX #6: IMAGE FALLBACK CACHE
            local img = fallbackCache[data.id]
            if not img then
                img = data.icon or ("rbxthumb://type=Asset&id="..data.id.."&w=150&h=150")
                fallbackCache[data.id] = img
            end
            btn.Image = img

            btn:SetAttribute("name", data.name)
            btn:SetAttribute("lowername", string.lower(data.name))

            local btnStroke = getStroke(btn)
            local tooltip = btn:FindFirstChild("TextLabel")
            if tooltip then tooltip.Text = data.name end

            clearConnections(btn)
            connectionCache[btn] = {}

            table.insert(connectionCache[btn],
                btn.MouseEnter:Connect(function()
                    EmoteName.Text = data.name
                    if btnStroke then
                        btnStroke.Transparency = 0
                        btnStroke.Thickness = 2
                    end
                    if tooltip then tooltip.Visible = true end
                end)
            )
            table.insert(connectionCache[btn],
                btn.MouseLeave:Connect(function()
                    if btnStroke then
                        btnStroke.Transparency = 0.6
                        btnStroke.Thickness = 1
                    end
                    if tooltip then tooltip.Visible = false end
                end)
            )
            table.insert(connectionCache[btn],
                btn.MouseButton1Click:Connect(function()
                    PlayEmote(data.name, data.id)
                end)
            )
        end
    end

    task.defer(function()
        renderingPage = false
        showDebounce = false
    end)
end

-- ============================================
-- 🔍 SEARCH OPTIMIZED (FIX #2)
-- ============================================
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then return end
    searchDebounce = true
    task.delay(0.15, function()
        local text = string.lower(SearchBar.Text)
        if text == lastSearch then
            searchDebounce = false
            return
        end
        lastSearch = text
        for _, btn in pairs(Frame:GetChildren()) do
            if btn:IsA("GuiButton") then
                local name = btn:GetAttribute("lowername")
                btn.Visible = (text == "" or (name and string.find(name, text, 1, true)))
            end
        end
        searchDebounce = false
    end)
end)

-- ============================================
-- 🔘 BUTTON EVENTS
-- ============================================
WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: ".. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    if currentTrack and currentTrack.IsPlaying then
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Movement or Enum.AnimationPriority.Action
        currentTrack.Looped = canWalk
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
    if currentTrack then pcall(function() currentTrack:AdjustSpeed(emoteSpeed) end) end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = "Speed: ".. emoteSpeed.. "x"
    if currentTrack then pcall(function() currentTrack:AdjustSpeed(emoteSpeed) end) end
end)

PrevPage.MouseButton1Click:Connect(function()
    if currentPage > 1 then ShowPage(currentPage - 1) end
end)

NextPage.MouseButton1Click:Connect(function()
    if currentPage < totalPages then ShowPage(currentPage + 1) end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_, s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
        EmoteName.Text = "Select"
    end
end, true, 2001, Enum.KeyCode.Comma)

Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    currentTrack = nil
    currentTrackId = nil
    -- 🔥 FIX #3: table.clear en vez de = {}
    for k in pairs(animatorCache) do animatorCache[k] = nil end
    ShowPage(1)
end)

-- ============================================
-- 📄 INIT
-- ============================================
ShowPage(1)
notify("Ready", #Emotes.." emotes loaded")
