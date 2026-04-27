local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local ContextActionService = game:GetService("ContextActionService")

if CoreGui:FindFirstChild("Emotes") then CoreGui.Emotes:Destroy() end
wait(0.3)

local currentPage = 1
local EMOTES_PER_PAGE = 300
local currentMode = "Emotes"
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil

local ELECTRIC_BLUE = Color3.fromRGB(0, 200, 255)

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
BackFrame.Parent = ScreenGui

local BackStroke = Instance.new("UIStroke", BackFrame)
BackStroke.Color = ELECTRIC_BLUE
BackStroke.Thickness = 2
BackStroke.Transparency = 0.3

local Open = Instance.new("TextButton")
Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0.05,0,0.114,0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Close"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true
Open.BackgroundTransparency =.5
Open.MouseButton1Up:Connect(function()
    BackFrame.Visible = not BackFrame.Visible
    Open.Text = BackFrame.Visible and "Close" or "Open"
end)
Instance.new("UICorner", Open).CornerRadius = UDim.new(1,0)
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
EmoteName.TextColor3 = Color3.new(1, 1, 1)
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

local ModeButton = Instance.new("TextButton")
ModeButton.Position = UDim2.new(0.075, 0, -0.075, 0)
ModeButton.Size = UDim2.new(0.15, 0, 0.1, 0)
ModeButton.AnchorPoint = Vector2.new(0.5, 0.5)
ModeButton.Text = "EMOTES"
ModeButton.TextScaled = true
ModeButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
ModeButton.TextColor3 = Color3.new(1,1,1)
ModeButton.Parent = BackFrame
Corner:Clone().Parent = ModeButton
local ModeStroke = Instance.new("UIStroke", ModeButton)
ModeStroke.Color = ELECTRIC_BLUE
ModeStroke.Thickness = 2

local WalkButton = Instance.new("TextButton")
WalkButton.Position = UDim2.new(0.925, -5, -0.2, 0)
WalkButton.Size = UDim2.new(0.15, 0, 0.08, 0)
WalkButton.AnchorPoint = Vector2.new(0.5, 0.5)
WalkButton.Text = "Walk: OFF"
WalkButton.TextScaled = true
WalkButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
WalkButton.TextColor3 = Color3.new(1,1,1)
WalkButton.Parent = BackFrame
Corner:Clone().Parent = WalkButton
local WalkStroke = Instance.new("UIStroke", WalkButton)
WalkStroke.Color = ELECTRIC_BLUE
WalkStroke.Thickness = 2

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Position = UDim2.new(0.75, 0, -0.2, 0)
SpeedLabel.Size = UDim2.new(0.12, 0, 0.08, 0)
SpeedLabel.AnchorPoint = Vector2.new(0.5, 0.5)
SpeedLabel.Text = "Speed: 1.00x"
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundColor3 = Color3.new(0,0,0)
SpeedLabel.TextColor3 = Color3.new(1,1,1)
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
SpeedUp.BackgroundColor3 = Color3.fromRGB(0,150,0)
SpeedUp.TextColor3 = Color3.new(1,1,1)
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
SpeedDown.BackgroundColor3 = Color3.fromRGB(150,0,0)
SpeedDown.TextColor3 = Color3.new(1,1,1)
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
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1,1)
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
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
PageLabel.BackgroundColor3 = Color3.new(0,0,0)
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
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1,1)
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
SearchBar.PlaceholderText = "Search"
SearchBar.TextScaled = true
SearchBar.BackgroundColor3 = Color3.new(0,0,0)
SearchBar.TextColor3 = Color3.new(1,1,1)
SearchBar.BackgroundTransparency = 0.3
SearchBar.Parent = BackFrame
Corner:Clone().Parent = SearchBar
local SearchStroke = Instance.new("UIStroke", SearchBar)
SearchStroke.Color = ELECTRIC_BLUE
SearchStroke.Thickness = 2

SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
    local text = SearchBar.Text:lower()
    for _,btn in pairs(Frame:GetChildren()) do
        if btn:IsA("ImageButton") then
            btn.Visible = text == "" or btn:GetAttribute("name"):lower():find(text, 1, true) ~= nil
        end
    end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_,s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, false, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

local Emotes = {
    {name="Salute", id=3360689775, icon="rbxthumb://type=Asset&id=3360689775&w=150&h=150"},
}

local Animations = {
    {name="Astronaut", id=891621366, icon="rbxassetid://891621366", i1=891621366, i2=891633237, w=891667138, r=891636393, j=891627522, c=891609353, f=891617961},
    {name="Bubbly", id=910004836, icon="rbxassetid://910004836", i1=910004836, i2=910009958, w=910034870, r=910025107, j=910016857, f=910001910},
    {name="Cartoony", id=742637544, icon="rbxassetid://742637544", i1=742637544, i2=742638445, w=742640026, r=742638842, j=742637942, c=742636889, f=742637151},
    {name="Elder", id=845397899, icon="rbxassetid://845397899", i1=845397899, i2=845400520, w=845403856, r=845386501, j=845398858, c=845392038, f=845396048},
    {name="Knight", id=657595757, icon="rbxassetid://657595757", i1=657595757, i2=657568135, w=657552124, r=657564596, j=658409194, c=658360781, f=657600338},
    {name="Levitation", id=616006778, icon="rbxassetid://616006778", i1=616006778, i2=616008087, w=616013216, r=616010382, j=616008936, c=616003713, f=616005863},
    {name="Mage", id=707742142, icon="rbxassetid://707742142", i1=707742142, i2=707855907, w=707897309, r=707861613, j=707853694, c=707826056, f=707829716},
    {name="Ninja", id=656117400, icon="rbxassetid://656117400", i1=656117400, i2=656118341, w=656121766, r=656118852, j=656117878, c=656114359, f=656115606},
    {name="Pirate", id=750781874, icon="rbxassetid://750781874", i1=750781874, i2=750782770, w=750785693, r=750783738, j=750782230, c=750779899, f=750780242},
    {name="Robot", id=616088211, icon="rbxassetid://616088211", i1=616088211, i2=616089559, w=616095330, r=616091570, j=616090535, c=616086039, f=616087089},
    {name="Stylish", id=616136790, icon="rbxassetid://616136790", i1=616136790, i2=616138447, w=616146177, r=616140816, j=616139451, c=616133594, f=616134815},
    {name="SuperHero", id=616111295, icon="rbxassetid://616111295", i1=616111295, i2=616113536, w=616122287, r=616117076, j=616115533, c=616104706, f=616108001},
    {name="Toy", id=782841498, icon="rbxassetid://782841498", i1=782841498, i2=782845736, w=782843345, r=782842708, j=782847020, c=782843869, f=782846423},
    {name="Vampire", id=1083445855, icon="rbxassetid://1083445855", i1=1083445855, i2=1083450166, w=1083473930, r=1083462077, j=1083455352, c=1083439238, f=1083443587},
    {name="Werewolf", id=1083195517, icon="rbxassetid://1083195517", i1=1083195517, i2=1083214717, w=1083178339, r=1083216690, j=1083218792, c=1083182000, f=1083189019},
    {name="Zombie", id=616158929, icon="rbxassetid://616158929", i1=616158929, i2=616160636, w=616168032, r=616163682, j=616161997, c=616156119, f=616157476},
    {name="Patrol", id=1149612882, icon="rbxassetid://1149612882", i1=1149612882, i2=1150842221, w=1151231493, r=1150967949, j=1148811837, c=1148811837, f=1148863382},
    {name="Confident", id=1069977950, icon="rbxassetid://1069977950", i1=1069977950, i2=1069987858, w=1070017263, r=1070001516, j=1069984524, c=1069946257, f=1069973677},
    {name="Popstar", id=1212900985, icon="rbxassetid://1212900985", i1=1212900985, i2=1150842221, w=1212980338, r=1212980348, j=1212954642, c=1213044953, f=1212900995},
    {name="Cowboy", id=1014390418, icon="rbxassetid://1014390418", i1=1014390418, i2=1014398616, w=1014421541, r=1014401683, j=1014394726, c=1014380606, f=1014384571},
    {name="Ghost", id=616006778, icon="rbxassetid://616006778", i1=616006778, i2=616008087, w=616013216, r=616013216, j=616008936, f=616005863},
    {name="Sneaky", id=1132473842, icon="rbxassetid://1132473842", i1=1132473842, i2=1132477671, w=1132510133, r=1132494274, j=1132489853, c=1132461372, f=1132469004},
    {name="Princess", id=941003647, icon="rbxassetid://941003647", i1=941003647, i2=941013098, w=941028902, r=941015281, j=941008832, c=940996062, f=941000007},
    {name="Anthro", id=2510196951, icon="rbxassetid://2510196951", i1=2510196951, i2=2510197257, w=2510202577, r=2510198475, j=2510197830, c=2510192778, f=2510195892},
}

table.sort(Emotes, function(a,b) return a.name < b.name end)
table.sort(Animations, function(a,b) return a.name < b.name end)

local function PlayAnimation(item)
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    if currentTrack then currentTrack:Stop() currentTrack = nil end

    pcall(function()
        animate.idle.Animation1.AnimationId = "rbxassetid://"..item.i1
        animate.idle.Animation2.AnimationId = "rbxassetid://"..item.i2
        animate.walk.WalkAnim.AnimationId = "rbxassetid://"..item.w
        animate.run.RunAnim.AnimationId = "rbxassetid://"..item.r
        animate.jump.JumpAnim.AnimationId = "rbxassetid://"..item.j
        if item.c and animate:FindFirstChild("climb") then animate.climb.ClimbAnim.AnimationId = "rbxassetid://"..item.c end
        if item.f and animate:FindFirstChild("fall") then animate.fall.FallAnim.AnimationId = "rbxassetid://"..item.f end
    end)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Jump = true task.wait(0.1) hum.Jump = false end

    BackFrame.Visible = false
    Open.Text = "Open"
end

local function PlayEmote(item)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if hum.RigType ~= Enum.HumanoidRigType.R15 then return end

    if currentTrack then currentTrack:Stop() end

    local success, t = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(item.id) end)
    if success and t then
        currentTrack = t
        t:AdjustSpeed(emoteSpeed)
        t.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
        t.Looped = true
    end

    BackFrame.Visible = false
    Open.Text = "Open"
end

local function ShowPage(page)
    for _,v in ipairs(Frame:GetChildren()) do
        if v:IsA("ImageButton") then v:Destroy() end
    end

    local list = currentMode == "Emotes" and Emotes or Animations
    local totalPages = math.max(1, math.ceil(#list / EMOTES_PER_PAGE))
    currentPage = math.clamp(page, 1, totalPages)

    PageLabel.Text = currentPage.."/"..totalPages
    PrevPage.Visible = currentPage > 1
    NextPage.Visible = currentPage < totalPages

    local startIdx = (currentPage - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(currentPage * EMOTES_PER_PAGE, #list)

    for i = startIdx, endIdx do
        local item = list[i]
        if item then
            local btn = Instance.new("ImageButton")
            btn.Name = item.name
            btn:SetAttribute("name", item.name)
            btn.Image = item.icon
            btn.BackgroundTransparency = 0.5
            btn.BackgroundColor3 = Color3.new(0,0,0)
            btn.LayoutOrder = i
            btn.Parent = Frame
            Corner:Clone().Parent = btn
            Instance.new("UIAspectRatioConstraint", btn).AspectType = Enum.AspectType.ScaleWithParentSize

            local bs = Instance.new("UIStroke", btn)
            bs.Color = ELECTRIC_BLUE
            bs.Thickness = 1.5
            bs.Transparency = 0.6

            btn.MouseButton1Click:Connect(function()
                if currentMode == "Emotes" then
                    PlayEmote(item)
                else
                    PlayAnimation(item)
                end
            end)

            btn.MouseEnter:Connect(function()
                EmoteName.Text = item.name
                bs.Transparency = 0
                bs.Thickness = 2.5
            end)

            btn.MouseLeave:Connect(function()
                bs.Transparency = 0.6
                bs.Thickness = 1.5
            end)
        end
    end
end

ModeButton.MouseButton1Click:Connect(function()
    currentMode = (currentMode == "Emotes") and "Animations" or "Emotes"
    ModeButton.Text = currentMode:upper()
    ModeButton.BackgroundColor3 = (currentMode == "Emotes") and Color3.fromRGB(0,100,200) or Color3.fromRGB(200,100,0)
    currentPage = 1
    ShowPage(1)
end)

WalkButton.MouseButton1Click:Connect(function()
    canWalk = not canWalk
    WalkButton.Text = "Walk: ".. (canWalk and "ON" or "OFF")
    WalkButton.BackgroundColor3 = canWalk and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
    if currentTrack then
        currentTrack.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
    end
end)

SpeedUp.MouseButton1Click:Connect(function()
    emoteSpeed = math.min(emoteSpeed + 0.25, 3)
    SpeedLabel.Text = string.format("Speed: %.2fx", emoteSpeed)
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = string.format("Speed: %.2fx", emoteSpeed)
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

PrevPage.MouseButton1Click:Connect(function() ShowPage(currentPage - 1) end)
NextPage.MouseButton1Click:Connect(function() ShowPage(currentPage + 1) end)

ShowPage(1)
StarterGui:SetCore("SendNotification",{Title="✓ Listo", Text="24 animaciones cargadas - Presiona,", Duration=5})
