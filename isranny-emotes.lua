--- Keybind to open for pc is "comma" -> ", "
-- Made by Gi#7331
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

-- your script goes here
print("Script executed!")

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Wait!",
    Text = "Please Wait, it just loading the button",
    Duration = 15})

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

local LoadedEmotes = {}

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
BackFrame.Size = UDim2.new(0.9, 0.5, 0)
BackFrame.AnchorPoint = Vector2.new(0.5, 0.5)
BackFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
BackFrame.SizeConstraint = Enum.SizeConstraint.RelativeYY
BackFrame.BackgroundTransparency = 1
BackFrame.BorderSizePixel = 0
BackFrame.Parent = ScreenGui

Open.Name = "Open"
Open.Parent = ScreenGui
Open.Draggable = true
Open.Size = UDim2.new(0.05,0.114,0)
Open.Position = UDim2.new(0.05, 0, 0.25, 0)
Open.Text = "Close"
Open.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Open.TextColor3 = Color3.fromRGB(255, 255, 255)
Open.TextScaled = true
Open.TextSize = 20
Open.Visible = true
Open.BackgroundTransparency =.5
Open.MouseButton1Up:Connect(function()
if Open.Text == "Open" then
	Open.Text = "Close"
	BackFrame.Visible = true
else
	if Open.Text == "Close" then
		Open.Text = "Open"
		BackFrame.Visible = false
	end
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
		EmoteButton.number.Text = Emote.sort[CurrentSort]
	end
end

local function createsort(order, text, sort)
	local CreatedSort = Instance.new("TextButton")
	CreatedSort.SizeConstraint = Enum.SizeConstraint.RelativeXX
	CreatedSort.Size = UDim2.new(1, 0, 0.2, 0)
	CreatedSort.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
SortButton.TextColor3 = Color3.new(1, 1, 1)
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
CloseButton.TextColor3 = Color3.new(1, 1, 1)
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
SearchBar.PlaceholderText = "Search"
SearchBar.TextColor3 = Color3.new(1, 1, 1)
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.BackgroundTransparency = 0.3
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = SearchBar.Text:lower()
	if #text > 50 then SearchBar.Text = text:sub(1,50) text = SearchBar.Text:lower() end
	for _,button in pairs(Frame:GetChildren()) do
		if button:IsA("GuiButton") then
			local name = button:GetAttribute("name"):lower()
			button.Visible = (text == "" or name:match(text))
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
	if isopen then BackFrame.Visible = false Open.Text = "Open" end
end)
GuiService.MenuOpened:Connect(function() BackFrame.Visible = false Open.Text = "Open" end)

if not game:IsLoaded() then game.Loaded:Wait() end

local SynV3 = syn and DrawingImmediate
if (not is_sirhurt_closure) and (not SynV3) and (syn and syn.protect_gui) then
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

local function PlayEmote(name: string, id: number)
	BackFrame.Visible = false
	Open.Text = "Open"
	SearchBar.Text = ""
	local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local Description = Humanoid and Humanoid:FindFirstChildOfClass("HumanoidDescription")
	if not Description then return end
	if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		local succ = pcall(function() Humanoid:PlayEmoteAndGetAnimTrackById(id) end)
		if not succ then Description:AddEmote(name, id) Humanoid:PlayEmoteAndGetAnimTrackById(id) end
	else
		SendNotification("r6? lol", "you gotta be r15 dude")
	end
end

local function WaitForChildOfClass(parent, class)
	local child = parent:FindFirstChildOfClass(class)
	while not child or child.ClassName ~= class do child = parent.ChildAdded:Wait() end
	return child
end

local Emotes = {
	{ name = "Around Town", id = 3576747102, icon = "rbxthumb://type=Asset&id=3576747102&w=150&h=150", price = 1000, lastupdated = 1663264200, sort = {} },	
	{ name = "TWICE TAKEDOWN DANCE 2", id = 85623000473425, icon = "rbxthumb://type=Asset&id=85623000473425&w=150&h=150", price = 100, lastupdated = 1752192000, sort = {} },
	{ name = "Fashionable", id = 3576745472, icon = "rbxthumb://type=Asset&id=3576745472&w=150&h=150", price = 750, lastupdated = 1663281649, sort = {} },
	{ name = "Swish", id = 3821527813, icon = "rbxthumb://type=Asset&id=3821527813&w=150&h=150", price = 750, lastupdated = 1663281651, sort = {} },
	{ name = "Top Rock", id = 3570535774, icon = "rbxthumb://type=Asset&id=3570535774&w=150&h=150", price = 750, lastupdated = 1663281651, sort = {} },
	{ name = "Fancy Feet", id = 3934988903, icon = "rbxthumb://type=Asset&id=3934988903&w=150&h=150", price = 500, lastupdated = 1663281649, sort = {} },
	{ name = "Idol", id = 4102317848, icon = "rbxthumb://type=Asset&id=4102317848&w=150&h=150", price = 500, lastupdated = 1663281650, sort = {} },
	{ name = "Sneaky", id = 3576754235, icon = "rbxthumb://type=Asset&id=3576754235&w=150&h=150", price = 500, lastupdated = 1663281651, sort = {} },
	{ name = "Elton John - Piano Jump", id = 11453096488, icon = "rbxthumb://type=Asset&id=11453096488&w=150&h=150", price = 500, lastupdated = 1668382206, sort = {} },
	{ name = "Cartwheel - George Ezra", id = 10370929905, icon = "rbxthumb://type=Asset&id=10370929905&w=150&h=150", price = 450, lastupdated = 1659650848, sort = {} },
	{ name = "Super Charge", id = 10478368365, icon = "rbxthumb://type=Asset&id=10478368365&w=150&h=150", price = 450, lastupdated = 1659649594, sort = {} },
	{ name = "Rise Above - The Chainsmokers", id = 13071993910, icon = "rbxthumb://type=Asset&id=13071993910&w=150&h=150", price = 400, lastupdated = 1681411386, sort = {} },
	{ name = "Elton John - Elevate", id = 11394056822, icon = "rbxthumb://type=Asset&id=11394056822&w=150&h=150", price = 400, lastupdated = 1667432393, sort = {} },
	{ name = "Sturdy Dance - Ice Spice", id = 17746270218, icon = "rbxthumb://type=Asset&id=17746270218&w=150&h=150", price = 300, lastupdated = 1717619314, sort = {} },
	{ name = "YUNGBLUD – HIGH KICK", id = 14022978026, icon = "rbxthumb://type=Asset&id=14022978026&w=150&h=150", price = 300, lastupdated = 1691769382, sort = {} },
	{ name = "Robot", id = 3576721660, icon = "rbxthumb://type=Asset&id=3576721660&w=150&h=150", price = 250, lastupdated = 1663281650, sort = {} },
	{ name = "Louder", id = 3576751796, icon = "rbxthumb://type=Asset&id=3576751796&w=150&h=150", price = 250, lastupdated = 1663281650, sort = {} },
	{ name = "Twirl", id = 3716633898, icon = "rbxthumb://type=Asset&id=3716633898&w=150&h=150", price = 250, lastupdated = 1663281651, sort = {} },
	{ name = "Bodybuilder", id = 3994130516, icon = "rbxthumb://type=Asset&id=3994130516&w=150&h=150", price = 200, lastupdated = 1663281649, sort = {} },
	{ name = "NBA Monster Dunk", id = 117511481049460, icon = "rbxthumb://type=Asset&id=117511481049460&w=150&h=150", price = 200, lastupdated = 1739396302, sort = {} },
	{ name = "Jacks", id = 3570649048, icon = "rbxthumb://type=Asset&id=3570649048&w=150&h=150", price = 200, lastupdated = 1663281650, sort = {} },
	{ name = "Shuffle", id = 4391208058, icon = "rbxthumb://type=Asset&id=4391208058&w=150&h=150", price = 200, lastupdated = 1663281651, sort = {} },
	{ name = "Elton John - Still Standing", id = 11435177473, icon = "rbxthumb://type=Asset&id=11435177473&w=150&h=150", price = 200, lastupdated = 1667779047, sort = {} },
	{ name = "Elton John - Cat Man", id = 11435175895, icon = "rbxthumb://type=Asset&id=11435175895&w=150&h=150", price = 200, lastupdated = 1667535727, sort = {} },
	{ name = "Shrek Roar", id = 18524331128, icon = "rbxthumb://type=Asset&id=18524331128&w=150&h=150", price = 200, lastupdated = 1721176055, sort = {} },
	{ name = "Dorky Dance", id = 4212499637, icon = "rbxthumb://type=Asset&id=4212499637&w=150&h=150", price = 200, lastupdated = 1663281649, sort = {} },
	-- [TODOS LOS DEMÁS DE TU TABLA ORIGINAL... SIGUE IGUAL HASTA SHRUG]
	{ name = "Shrug", id = 3576968026, icon = "rbxthumb://type=Asset&id=3576968026&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },
}

local function addEmote(name, id, price, date)
    local months = {Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12}
    local mon, day, year = date:match("(%a+)%s+(%d+),%s*(%d+)")
    local unix = os.time({year=tonumber(year), month=months[mon], day=tonumber(day), hour=0, min=0, sec=0})
    table.insert(Emotes, {name=name, id=id, icon="rbxthumb://type=Asset&id="..id.."&w=150&h=150", price=price, lastupdated=unix, sort={}})
end

addEmote("PARROT PARTY DANCE", 121067808279598, 39, "Aug 08, 2025")
-- [TODOS TUS ADDEMOTE VIEJOS HASTA SLICKBACK]
addEmote("Slickback", 103789826265487, 39, "Aug 08, 2025")

-- ============================================
-- PEGA TUS 1700 EMOTES AQUÍ ABAJO
-- ============================================

-- ============================================
-- FIN
-- ============================================

local function EmotesLoaded() for i, loaded in pairs(LoadedEmotes) do if not loaded then return false end return true end
while not EmotesLoaded() do task.wait() end
Loading:Destroy()

--sorting
table.sort(Emotes, function(a,b) return a.lastupdated > b.lastupdated end) for i,v in pairs(Emotes) do v.sort.recentfirst = i end
table.sort(Emotes, function(a,b) return a.lastupdated < b.lastupdated end) for i,v in pairs(Emotes) do v.sort.recentlast = i end
table.sort(Emotes, function(a,b) return a.name:lower() < b.name:lower() end) for i,v in pairs(Emotes) do v.sort.alphabeticfirst = i end
table.sort(Emotes, function(a,b) return a.name:lower() > b.name:lower() end) for i,v in pairs(Emotes) do v.sort.alphabeticlast = i end
table.sort(Emotes, function(a,b) return a.price < b.price end) for i,v in pairs(Emotes) do v.sort.lowestprice = i end
table.sort(Emotes, function(a,b) return a.price > b.price end) for i,v in pairs(Emotes) do v.sort.highestprice = i end

if isfile("FavoritedEmotes.txt") then
	if not pcall(function() FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt")) end) then FavoritedEmotes = {} end
else
	writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
end

local function CharacterAdded(Character)
	for i,v in pairs(Frame:GetChildren()) do if not v:IsA("UIGridLayout") then v:Destroy() end
	local Humanoid = WaitForChildOfClass(Character, "Humanoid")
	local Description = Humanoid:WaitForChild("HumanoidDescription", 5) or Instance.new("HumanoidDescription", Humanoid)
	local random = Instance.new("TextButton")
	local Ratio = Instance.new("UIAspectRatioConstraint")
	Ratio.AspectType = Enum.AspectType.ScaleWithParentSize
	Ratio.Parent = random
	random.LayoutOrder = 0
	random.TextColor3 = Color3.new(1,1,1)
	random.BorderSizePixel = 0
	random.BackgroundTransparency = 0.5
	random.BackgroundColor3 = Color3.new(0,0,0)
	random.TextScaled = true
	random.Text = "Random"
	random:SetAttribute("name", "")
	Corner:Clone().Parent = random
	random.MouseButton1Click:Connect(function() local r=Emotes[math.random(1,#Emotes)] PlayEmote(r.name,r.id) end)
	random.MouseEnter:Connect(function() EmoteName.Text = "Random" end)
	random.Parent = Frame
	
	for i,Emote in pairs(Emotes) do
		Description:AddEmote(Emote.name, Emote.id)
		local EmoteButton = Instance.new("ImageButton")
		if i % 40 == 0 then task.wait() end -- ANTI-FREEZE
		local IsFavorited = table.find(FavoritedEmotes, Emote.id)
		EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)
	EmoteButton.Name = tostring(Emote.id)
	EmoteButton:SetAttribute("name", Emote.name)
	Corner:Clone().Parent = EmoteButton
		EmoteButton.Image = Emote.icon
		EmoteButton.BackgroundTransparency = 0.5
		EmoteButton.BackgroundColor3 = Color3.new(0,0)
		EmoteButton.BorderSizePixel = 0
		Ratio:Clone().Parent = EmoteButton
		local EmoteNumber = Instance.new("TextLabel")
	EmoteNumber.Name = "number"
		EmoteNumber.TextScaled = true
		EmoteNumber.BackgroundTransparency = 1
		EmoteNumber.TextColor3 = Color3.new(1,1,1)
		EmoteNumber.BorderSizePixel = 0
		EmoteNumber.AnchorPoint = Vector2.new(0.5,0.5)
		EmoteNumber.Size = UDim2.new(0.2,0.2,0)
		EmoteNumber.Position = UDim2.new(0.1,0.9,0)
		EmoteNumber.Text = Emote.sort[CurrentSort]
	EmoteNumber.TextXAlignment = Enum.TextXAlignment.Center
		EmoteNumber.TextYAlignment = Enum.TextYAlignment.Center
		local UIStroke = Instance.new("UIStroke") UIStroke.Transparency = 0.5 UIStroke.Parent = EmoteNumber
	EmoteNumber.Parent = EmoteButton
		EmoteButton.Parent = Frame
		EmoteButton.MouseButton1Click:Connect(function() PlayEmote(Emote.name, Emote.id) end)
		EmoteButton.MouseEnter:Connect(function() EmoteName.Text = Emote.name end)
		local Favorite = Instance.new("ImageButton")
		Favorite.Name = "favorite"
		Favorite.Image = table.find(FavoritedEmotes, Emote.id) and FavoriteOn or FavoriteOff
		Favorite.AnchorPoint = Vector2.new(0.5,0.5)
		Favorite.Size = UDim2.new(0.2,0.2,0)
		Favorite.Position = UDim2.new(0.9,0,0.9,0)
		Favorite.BorderSizePixel = 0
		Favorite.BackgroundTransparency = 1
		Favorite.Parent = EmoteButton
		Favorite.MouseButton1Click:Connect(function()
			local index = table.find(FavoritedEmotes, Emote.id)
			if index then table.remove(FavoritedEmotes, index) Favorite.Image = FavoriteOff EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + #Emotes
			else table.insert(FavoritedEmotes, Emote.id) Favorite.Image = FavoriteOn EmoteButton.LayoutOrder = Emote.sort[CurrentSort] end
			writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))
		end)
	end
	for i=1,9 do
		local EmoteButton = Instance.new("Frame")
	EmoteButton.LayoutOrder = 2147483647
		EmoteButton.Name = "filler"
		EmoteButton.BackgroundTransparency = 1
		EmoteButton.BorderSizePixel = 0
		Ratio:Clone().Parent = EmoteButton
		EmoteButton.Visible = true
		EmoteButton.Parent = Frame
		EmoteButton.MouseEnter:Connect(function() EmoteName.Text = "Select an Emote" end)
	end
end

if LocalPlayer.Character then CharacterAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(CharacterAdded)

wait(1)
game.CoreGui.Emotes.Enabled = true
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Done!",Text="Emotes gui is here!",Duration=10})
game.Players.LocalPlayer.PlayerGui.ContextActionGui:Destroy()
