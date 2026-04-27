--- Keybind: "," - FIXED v6
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Loading...", Text = "Emotes & Anims", Duration = 5})

if game:GetService("CoreGui"):FindFirstChild("Emotes") then
    game:GetService("CoreGui"):FindFirstChild("Emotes"):Destroy()
end
wait(0.5)

local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local currentPage, EMOTES_PER_PAGE = 1, 300
local currentMode = "Emotes"
local emoteSpeed = 1
local canWalk = false
local currentTrack = nil
local currentAnimData = nil

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
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30)
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
SpeedLabel.Text = "Speed: 1x"
SpeedLabel.TextScaled = true
SpeedLabel.BackgroundColor3 = Color3.new(0,0,0)
SpeedLabel.TextColor3 = Color3.new(1,1)
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
SpeedUp.TextColor3 = Color3.new(1,1)
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
        if btn:IsA("GuiButton") then
            btn.Visible = text == "" or btn:GetAttribute("name"):lower():find(text)
        end
    end
end)

ContextActionService:BindCoreActionAtPriority("Emote Menu", function(_,s)
    if s == Enum.UserInputState.Begin then
        BackFrame.Visible = not BackFrame.Visible
        Open.Text = BackFrame.Visible and "Close" or "Open"
    end
end, true, 2001, Enum.KeyCode.Comma)

local LocalPlayer = Players.LocalPlayer

local Emotes = {
    { name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150" },
}

local Animations = {
    { name = "Astronaut", id = 891621366, icon = "rbxassetid://891621366", data = {idle1=891621366, idle2=891633237, walk=891667138, run=891636393, jump=891627522, climb=891609353, fall=891617961} },
    { name = "Bubbly", id = 910004836, icon = "rbxassetid://910004836", data = {idle1=910004836, idle2=910009958, walk=910034870, run=910025107, jump=910016857, fall=910001910} },
    { name = "Cartoony", id = 742637544, icon = "rbxassetid://742637544", data = {idle1=742637544, idle2=742638445, walk=742640026, run=742638842, jump=742637942, climb=742636889, fall=742637151} },
    { name = "Elder", id = 845397899, icon = "rbxassetid://845397899", data = {idle1=845397899, idle2=845400520, walk=845403856, run=845386501, jump=845398858, climb=845392038, fall=845396048} },
    { name = "Knight", id = 657595757, icon = "rbxassetid://657595757", data = {idle1=657595757, idle2=657568135, walk=657552124, run=657564596, jump=658409194, climb=658360781, fall=657600338} },
    { name = "Levitation", id = 616006778, icon = "rbxassetid://616006778", data = {idle1=616006778, idle2=616008087, walk=616013216, run=616010382, jump=616008936, climb=616003713, fall=616005863} },
    { name = "Mage", id = 707742142, icon = "rbxassetid://707742142", data = {idle1=707742142, idle2=707855907, walk=707897309, run=707861613, jump=707853694, climb=707826056, fall=707829716} },
    { name = "Ninja", id = 656117400, icon = "rbxassetid://656117400", data = {idle1=656117400, idle2=656118341, walk=656121766, run=656118852, jump=656117878, climb=656114359, fall=656115606} },
    { name = "Pirate", id = 750781874, icon = "rbxassetid://750781874", data = {idle1=750781874, idle2=750782770, walk=750785693, run=750783738, jump=750782230, climb=750779899, fall=750780242} },
    { name = "Robot", id = 616088211, icon = "rbxassetid://616088211", data = {idle1=616088211, idle2=616089559, walk=616095330, run=616091570, jump=616090535, climb=616086039, fall=616087089} },
    { name = "Stylish", id = 616136790, icon = "rbxassetid://616136790", data = {idle1=616136790, idle2=616138447, walk=616146177, run=616140816, jump=616139451, climb=616133594, fall=616134815} },
    { name = "SuperHero", id = 616111295, icon = "rbxassetid://616111295", data = {idle1=616111295, idle2=616113536, walk=616122287, run=616117076, jump=616115533, climb=616104706, fall=616108001} },
    { name = "Toy", id = 782841498, icon = "rbxassetid://782841498", data = {idle1=782841498, idle2=782845736, walk=782843345, run=782842708, jump=782847020, climb=782843869, fall=782846423} },
    { name = "Vampire", id = 1083445855, icon = "rbxassetid://1083445855", data = {idle1=1083445855, idle2=1083450166, walk=1083473930, run=1083462077, jump=1083455352, climb=1083439238, fall=1083443587} },
    { name = "Werewolf", id = 1083195517, icon = "rbxassetid://1083195517", data = {idle1=1083195517, idle2=1083214717, walk=1083178339, run=1083216690, jump=1083218792, climb=1083182000, fall=1083189019} },
    { name = "Zombie", id = 616158929, icon = "rbxassetid://616158929", data = {idle1=616158929, idle2=616160636, walk=616168032, run=616163682, jump=616161997, climb=616156119, fall=616157476} },
    { name = "Patrol", id = 1149612882, icon = "rbxassetid://1149612882", data = {idle1=1149612882, idle2=1150842221, walk=1151231493, run=1150967949, jump=1148811837, climb=1148811837, fall=1148863382} },
    { name = "Confident", id = 1069977950, icon = "rbxassetid://1069977950", data = {idle1=1069977950, idle2=1069987858, walk=1070017263, run=1070001516, jump=1069984524, climb=1069946257, fall=1069973677} },
    { name = "Popstar", id = 1212900985, icon = "rbxassetid://1212900985", data = {idle1=1212900985, idle2=1150842221, walk=1212980338, run=1212980348, jump=1212954642, climb=1213044953, fall=1212900995} },
    { name = "Cowboy", id = 1014390418, icon = "rbxassetid://1014390418", data = {idle1=1014390418, idle2=1014398616, walk=1014421541, run=1014401683, jump=1014394726, climb=1014380606, fall=1014384571} },
    { name = "Ghost", id = 616006778, icon = "rbxassetid://616006778", data = {idle1=616006778, idle2=616008087, walk=616013216, run=616013216, jump=616008936, fall=616005863} },
    { name = "Sneaky", id = 1132473842, icon = "rbxassetid://1132473842", data = {idle1=1132473842, idle2=1132477671, walk=1132510133, run=1132494274, jump=1132489853, climb=1132461372, fall=1132469004} },
    { name = "Princess", id = 941003647, icon = "rbxassetid://941003647", data = {idle1=941003647, idle2=941013098, walk=941028902, run=941015281, jump=941008832, climb=940996062, fall=941000007} },
    { name = "Anthro", id = 2510196951, icon = "rbxassetid://2510196951", data = {idle1=2510196951, idle2=2510197257, walk=2510202577, run=2510198475, jump=2510197830, climb=2510192778, fall=2510195892} },
}

for _,list in pairs({Emotes, Animations}) do
    table.sort(list, function(a,b) return a.name < b.name end)
end

local function PlayAnimation(name, data)
    local char = LocalPlayer.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    if currentTrack then currentTrack:Stop() end
    currentAnimData = data

    pcall(function()
        animate.idle.Animation1.AnimationId = "rbxassetid://"..data.idle1
        animate.idle.Animation2.AnimationId = "rbxassetid://"..data.idle2
        animate.walk.WalkAnim.AnimationId = "rbxassetid://"..data.walk
        animate.run.RunAnim.AnimationId = "rbxassetid://"..data.run
        animate.jump.JumpAnim.AnimationId = "rbxassetid://"..data.jump
        if data.climb and animate.climb then animate.climb.ClimbAnim.AnimationId = "rbxassetid://"..data.climb end
        if data.fall and animate.fall then animate.fall.FallAnim.AnimationId = "rbxassetid://"..data.fall end
    end)

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.Jump = true task.wait() hum.Jump = false end

    BackFrame.Visible = false
    Open.Text = "Open"
    StarterGui:SetCore("SendNotification", {Title = "✓ "..name, Text = "Animación aplicada", Duration = 2})
end

local function PlayEmote(name, id)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if currentTrack then currentTrack:Stop() currentTrack = nil end

    if hum.RigType == Enum.HumanoidRigType.R15 then
        local success, track = pcall(function() return hum:PlayEmoteAndGetAnimTrackById(id) end)
        if success and track then
            currentTrack = track
            track:AdjustSpeed(emoteSpeed)
            track.Priority = canWalk and Enum.AnimationPriority.Action or Enum.AnimationPriority.Movement
            track.Looped = true
        end
    end
    BackFrame.Visible = false
    Open.Text = "Open"
end

local function ShowPage(page)
    for _,v in pairs(Frame:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end end
    local list = currentMode == "Emotes" and Emotes or Animations
    local startIdx = (page - 1) * EMOTES_PER_PAGE + 1
    local endIdx = math.min(page * EMOTES_PER_PAGE, #list)
    local totalPages = math.max(1, math.ceil(#list / EMOTES_PER_PAGE))
    PageLabel.Text = page.."/"..totalPages
    PrevPage.Visible = page > 1
    NextPage.Visible = page < totalPages
    for i = startIdx, endIdx do
        local item = list[i]
        if item then
            local btn = Instance.new("ImageButton")
            btn.Name = tostring(item.id)
            btn:SetAttribute("name", item.name)
            btn.Image = item.icon
            btn.BackgroundTransparency = 0.5
            btn.BackgroundColor3 = Color3.new(0,0,0)
            btn.LayoutOrder = i
            btn.Parent = Frame
            Corner:Clone().Parent = btn
            Instance.new("UIAspectRatioConstraint", btn).AspectType = Enum.AspectType.ScaleWithParentSize
            local btnStroke = Instance.new("UIStroke", btn)
            btnStroke.Color = ELECTRIC_BLUE
            btnStroke.Thickness = 1.5
            btnStroke.Transparency = 0.6
            btn.MouseButton1Click:Connect(function()
                if currentMode == "Emotes" then PlayEmote(item.name, item.id) else PlayAnimation(item.name, item.data) end
            end)
            btn.MouseEnter:Connect(function() EmoteName.Text = item.name btnStroke.Transparency = 0 btnStroke.Thickness = 2.5 end)
            btn.MouseLeave:Connect(function() btnStroke.Transparency = 0.6 btnStroke.Thickness = 1.5 end)
        end
    end
end

ModeButton.MouseButton1Click:Connect(function()
    currentMode = currentMode == "Emotes" and "Animations" or "Emotes"
    ModeButton.Text = currentMode:upper()
    ModeButton.BackgroundColor3 = currentMode == "Emotes" and Color3.fromRGB(0,100,200) or Color3.fromRGB(200,100,0)
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
    SpeedLabel.Text = "Speed: "..string.format("%.2f", emoteSpeed).."x"
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

SpeedDown.MouseButton1Click:Connect(function()
    emoteSpeed = math.max(emoteSpeed - 0.25, 0.25)
    SpeedLabel.Text = "Speed: "..string.format("%.2f", emoteSpeed).."x"
    if currentTrack then currentTrack:AdjustSpeed(emoteSpeed) end
end)

PrevPage.MouseButton1Click:Connect(function() if currentPage > 1 then currentPage = currentPage - 1 ShowPage(currentPage) end end)
NextPage.MouseButton1Click:Connect(function() local total = math.ceil((currentMode == "Emotes" and #Emotes or #Animations) / EMOTES_PER_PAGE) if currentPage < total then currentPage = currentPage + 1 ShowPage(currentPage) end end)

ShowPage(1)
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) ShowPage(1) end)

StarterGui:SetCore("SendNotification",{Title = "Ready!", Text = "24 animaciones + emotes", Duration = 5})
