--- Keybind to open for pc is "comma" -> ", "
-- Made by Gi#7331 - PAGINADO 20x
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
local CurrentPage = 1
local EMOTES_PER_PAGE = 20

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
EmoteName.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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
Frame.CanvasSize = UDim2.new(0, 0)
Frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
Frame.ScrollingDirection = Enum.ScrollingDirection.Y
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0.5, 0)
Frame.BackgroundTransparency = 1
Frame.ScrollBarThickness = 5
Frame.BorderSizePixel = 0
Frame.MouseLeave:Connect(function()
	EmoteName.Text = "Select an Emote"
end)
Frame.Parent = BackFrame

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0.105, 0, 0)
Grid.CellPadding = UDim2.new(0.006, 0, 0.006, 0)
Grid.SortOrder = Enum.SortOrder.LayoutOrder
Grid.Parent = Frame

local SortFrame = Instance.new("Frame")
SortFrame.Visible = false
SortFrame.BorderSizePixel = 0
SortFrame.Position = UDim2.new(1, 5, -0.125, 0)
SortFrame.Size = UDim2.new(0.2, 0, 0)
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

-- PAGINACION
local PrevPage = Instance.new("TextButton")
PrevPage.Name = "PrevPage"
PrevPage.Parent = BackFrame
PrevPage.AnchorPoint = Vector2.new(0.5,0.5)
PrevPage.Position = UDim2.new(0.3,0,-0.075,0)
PrevPage.Size = UDim2.new(0.08,0.1,0)
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1,1)
PrevPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = PrevPage

local NextPage = Instance.new("TextButton")
NextPage.Name = "NextPage"
NextPage.Parent = BackFrame
NextPage.AnchorPoint = Vector2.new(0.5,0.5)
NextPage.Position = UDim2.new(0.7,0,-0.075,0)
NextPage.Size = UDim2.new(0.08,0,0.1,0)
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1,1)
NextPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = NextPage

local PageLabel = Instance.new("TextLabel")
PageLabel.Name = "PageLabel"
PageLabel.Parent = BackFrame
PageLabel.AnchorPoint = Vector2.new(0.5,0.5)
PageLabel.Position = UDim2.new(0.5,0,-0.075,0)
PageLabel.Size = UDim2.new(0.15,0.1,0)
PageLabel.Text = "1/1"
PageLabel.TextScaled = true
PageLabel.BackgroundColor3 = Color3.new(0,0,0)
PageLabel.TextColor3 = Color3.fromRGB(0,255,0)
PageLabel.BackgroundTransparency = 0.3
Corner:Clone().Parent = PageLabel

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
	if #text > 50 then SearchBar.Text = SearchBar.Text:sub(1,50) text = SearchBar.Text:lower() end
	for _,button in pairs(Frame:GetChildren()) do
		if button:IsA("GuiButton") then
			local name = button:GetAttribute("name")
			if name then
				button.Visible = text == "" or string.find(name:lower(), text, 1, true)
			end
		end
	end
end)
Corner:Clone().Parent = SearchBar
SearchBar.Parent = BackFrame

local function openemotes(name, state, input)
	if state == Enum.UserInputState.Begin then
		BackFrame.Visible = not BackFrame.Visible
		Open.Text = BackFrame.Visible and "Close" or "Open"
	end
end

ContextActionService:BindCoreActionAtPriority("Emote Menu", openemotes, true, 2001, Enum.KeyCode.Comma)

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

local function PlayEmote(name: string, id)
	BackFrame.Visible = false
	Open.Text = "Open"
	SearchBar.Text = ""
	local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	local Description = Humanoid and Humanoid:FindFirstChildOfClass("HumanoidDescription")
	if not Description then return end
	if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
		local succ = pcall(function() Humanoid:PlayEmoteAndGetAnimTrackById(id) end)
		if not succ then
			Description:AddEmote(name, id)
			Humanoid:PlayEmoteAndGetAnimTrackById(id)
		end
	else
		SendNotification("r6? lol", "you gotta be r15 dude")
	end
end

local function WaitForChildOfClass(parent, class)
	local child = parent:FindFirstChildOfClass(class)
	while not child or child.ClassName ~= class do
		child = parent.ChildAdded:Wait()
	end
	return child
end

-- TU LISTA COMPLETA DE EMOTES (SIN TOCAR)
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
	{ name = "HOLIDAY Dance - Lil Nas X (LNX)", id = 5938396308, icon = "rbxthumb://type=Asset&id=5938396308&w=150&h=150", price = 190, lastupdated = 1663281650, sort = {} },
	{ name = "Old Town Road Dance - Lil Nas X (LNX)", id = 5938394742, icon = "rbxthumb://type=Asset&id=5938394742&w=150&h=150", price = 190, lastupdated = 1663281650, sort = {} },
	{ name = "Panini Dance - Lil Nas X (LNX)", id = 5915781665, icon = "rbxthumb://type=Asset&id=5915781665&w=150&h=150", price = 190, lastupdated = 1663281650, sort = {} },
	{ name = "Rodeo Dance - Lil Nas X (LNX)", id = 5938397555, icon = "rbxthumb://type=Asset&id=5938397555&w=150&h=150", price = 190, lastupdated = 1663281651, sort = {} },
	{ name = "Drum Master - Royal Blood", id = 6531538868, icon = "rbxthumb://type=Asset&id=6531538868&w=150&h=150", price = 190, lastupdated = 1663281649, sort = {} },
	{ name = "It Ain't My Fault - Zara Larsson", id = 6797948622, icon = "rbxthumb://type=Asset&id=6797948622&w=150&h=150", price = 190, lastupdated = 1663281650, sort = {} },
	{ name = "Flex Walk", id = 15506506103, icon = "rbxthumb://type=Asset&id=15506506103&w=150&h=150", price = 175, lastupdated = 1705451683, sort = {} },
	{ name = "Dizzy", id = 3934986896, icon = "rbxthumb://type=Asset&id=3934986896&w=150&h=150", price = 175, lastupdated = 1663281649, sort = {} },
	{ name = "Uprise - Tommy Hilfiger", id = 10275057230, icon = "rbxthumb://type=Asset&id=10275057230&w=150&h=150", price = 170, lastupdated = 1660240736, sort = {} },
	{ name = "Tommy - Archer", id = 13823339506, icon = "rbxthumb://type=Asset&id=13823339506&w=150&h=150", price = 170, lastupdated = 1687980934, sort = {} },
	{ name = "Mean Mug - Tommy Hilfiger", id = 10214415687, icon = "rbxthumb://type=Asset&id=10214415687&w=150&h=150", price = 170, lastupdated = 1660240753, sort = {} },
	{ name = "Rock Star - Royal Blood", id = 6533100850, icon = "rbxthumb://type=Asset&id=6533100850&w=150&h=150", price = 170, lastupdated = 1663281651, sort = {} },
	{ name = "Floor Rock Freeze - Tommy Hilfiger", id = 10214411646, icon = "rbxthumb://type=Asset&id=10214411646&w=150&h=150", price = 170, lastupdated = 1658271615, sort = {} },
	{ name = "Saturday Dance - Twenty One Pilots", id = 7422833723, icon = "rbxthumb://type=Asset&id=7422833723&w=150&h=150", price = 170, lastupdated = 1663281651, sort = {} },
	{ name = "V Pose - Tommy Hilfiger", id = 10214418283, icon = "rbxthumb://type=Asset&id=10214418283&w=150&h=150", price = 170, lastupdated = 1660240743, sort = {} },
	{ name = "Boxing Punch - KSI", id = 7202896732, icon = "rbxthumb://type=Asset&id=7202896732&w=150&h=150", price = 170, lastupdated = 1663281649, sort = {} },
	{ name = "Drum Solo - Royal Blood", id = 6532844183, icon = "rbxthumb://type=Asset&id=6532844183&w=150&h=150", price = 170, lastupdated = 1663281649, sort = {} },
	{ name = "Frosty Flair - Tommy Hilfiger", id = 10214406616, icon = "rbxthumb://type=Asset&id=10214406616&w=150&h=150", price = 170, lastupdated = 1658271594, sort = {} },
	{ name = "Hips Poppin' - Zara Larsson", id = 6797919579, icon = "rbxthumb://type=Asset&id=6797919579&w=150&h=150", price = 170, lastupdated = 1663281650, sort = {} },
	{ name = "Drummer Moves - Twenty One Pilots", id = 7422838770, icon = "rbxthumb://type=Asset&id=7422838770&w=150&h=150", price = 160, lastupdated = 1663281649, sort = {} },
	{ name = "On The Outside - Twenty One Pilots", id = 7422841700, icon = "rbxthumb://type=Asset&id=7422841700&w=150&h=150", price = 160, lastupdated = 1663281650, sort = {} },
	{ name = "Thanos Happy Jump - Squid Game", id = 82217023310738, icon = "rbxthumb://type=Asset&id=82217023310738&w=150&h=150", price = 150, lastupdated = 1750314239, sort = {} },
	{ name = "Block Partier", id = 6865011755, icon = "rbxthumb://type=Asset&id=6865011755&w=150&h=150", price = 150, lastupdated = 1663281649, sort = {} },
	{ name = "Up and Down - Twenty One Pilots", id = 7422843994, icon = "rbxthumb://type=Asset&id=7422843994&w=150&h=150", price = 150, lastupdated = 1663281651, sort = {} },
	{ name = "Ay-Yo Dance Move - NCT 127", id = 12804173616, icon = "rbxthumb://type=Asset&id=12804173616&w=150&h=150", price = 150, lastupdated = 1679554914, sort = {} },
	{ name = "Young-hee Head Spin - Squid Game", id = 134615135651900, icon = "rbxthumb://type=Asset&id=134615135651900&w=150&h=150", price = 150, lastupdated = 1750314256, sort = {} },
	{ name = "T", id = 3576719440, icon = "rbxthumb://type=Asset&id=3576719440&w=150&h=150", price = 150, lastupdated = 1663281651, sort = {} },
	{ name = "Air Dance", id = 4646302011, icon = "rbxthumb://type=Asset&id=4646302011&w=150&h=150", price = 150, lastupdated = 1663264200, sort = {} },
	{ name = "TMNT Dance", id = 18665886405, icon = "rbxthumb://type=Asset&id=18665886405&w=150&h=150", price = 150, lastupdated = 1722010678, sort = {} },
	{ name = "Take Me Under - Zara Larsson", id = 6797938823, icon = "rbxthumb://type=Asset&id=6797938823&w=150&h=150", price = 150, lastupdated = 1663281651, sort = {} },
	{ name = "Sticker Dance Move - NCT 127", id = 12259885838, icon = "rbxthumb://type=Asset&id=12259885838&w=150&h=150", price = 150, lastupdated = 1675067049, sort = {} },
	{ name = "Line Dance", id = 4049646104, icon = "rbxthumb://type=Asset&id=4049646104&w=150&h=150", price = 150, lastupdated = 1663281650, sort = {} },
	{ name = "NBA WNBA Fadeaway", id = 18526373545, icon = "rbxthumb://type=Asset&id=18526373545&w=150&h=150", price = 150, lastupdated = 1721396854, sort = {} },
	{ name = "SpongeBob Imaginaaation 🌈", id = 18443268949, icon = "rbxthumb://type=Asset&id=18443268949&w=150&h=150", price = 150, lastupdated = 1720822244, sort = {} },
	{ name = "Chill Vibes - George Ezra", id = 10370918044, icon = "rbxthumb://type=Asset&id=10370918044&w=150&h=150", price = 150, lastupdated = 1659650823, sort = {} },
	{ name = "Wake Up Call - KSI", id = 7202900159, icon = "rbxthumb://type=Asset&id=7202900159&w=150&h=150", price = 150, lastupdated = 1663281651, sort = {} },
	{ name = "Kick It Dance Move - NCT 127", id = 12259888240, icon = "rbxthumb://type=Asset&id=12259888240&w=150&h=150", price = 150, lastupdated = 1674794102, sort = {} },
	{ name = "The Weeknd Starboy Strut", id = 130245358716273, icon = "rbxthumb://type=Asset&id=130245358716273&w=150&h=150", price = 150, lastupdated = 1747429898, sort = {} },
	{ name = "2 Baddies Dance Move - NCT 127", id = 12259890638, icon = "rbxthumb://type=Asset&id=12259890638&w=150&h=150", price = 150, lastupdated = 1674793873, sort = {} },
	{ name = "Rock Guitar - Royal Blood", id = 6532155086, icon = "rbxthumb://type=Asset&id=6532155086&w=150&h=150", price = 150, lastupdated = 1663281650, sort = {} },
	{ name = "Shrug", id = 3576968026, icon = "rbxthumb://type=Asset&id=3576968026&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },
}

-- tus addEmote de abajo
local function addEmote(name, id, price, date)
    local months = {Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12}
    local function dateToUnix(d)
        local mon, day, year = d:match("(%a+)%s+(%d+),%s*(%d+)")
        return os.time({year=tonumber(year), month=months[mon], day=tonumber(day)})
    end
    table.insert(Emotes, {name=name, id=id, icon="rbxthumb://type=Asset&id="..id.."&w=150&h=150", price=price, lastupdated=dateToUnix(date), sort={}})
end

addEmote("PARROT PARTY DANCE", 121067808279598, 39, "Aug 08, 2025")
addEmote("Dance n' Prance", 99031916674986, 39, "Aug 08, 2025")
addEmote("R15 Death (Accurate)", 114899970878842, 39, "Aug 08, 2025")
addEmote("Wally West", 133948663586698, 39, "Aug 08, 2025")
addEmote("Take The L", 123159156696507, 39, "Aug 08, 2025")
addEmote("Xaviersobased", 131763631172236, 39, "Aug 09, 2025")
addEmote("Belly Dancing", 131939729732240, 39, "Aug 08, 2025")
addEmote("RAT DANCE", 133461102795137, 78, "Aug 08, 2025")
addEmote("CaramellDansen", 93105950995997, 39, "Aug 08, 2025")
addEmote("Biblically Accurate", 133596366979822, 39, "Aug 08, 2025")
addEmote("Rambunctious", 134311528115559, 39, "Aug 08, 2025")
addEmote("Ballin", 96293409369770, 39, "Aug 17, 2025")
addEmote("Die Lit", 121001502815813, 39, "Aug 08, 2025")
addEmote("Nyan Nyan!", 73796726960568, 39, "Aug 08, 2025")
addEmote("Teto Territory", 114428584463004, 39, "Aug 08, 2025")
addEmote("Skibidi", 124828909173982, 39, "Aug 08, 2025")
addEmote("Chronoshift", 92600655160976, 39, "Aug 08, 2025")
addEmote("Floating on Clouds", 111426928948833, 39, "Aug 08, 2025")
addEmote("Jersey Joe", 134149640725489, 39, "Aug 08, 2025")
addEmote("Virtual Insanity", 83261816934732, 39, "Aug 09, 2025")
addEmote("Doodle Dance", 107091254142209, 39, "Aug 08, 2025")
addEmote("Subject 3", 83732367439808, 39, "Aug 08, 2025")
addEmote("Club Penguin", 98099211500155, 39, "Aug 09, 2025")
addEmote("Kazotsky", 97629500912487, 39, "Aug 08, 2025")
addEmote("Miku Dance", 117734400993750, 39, "Aug 08, 2025")
addEmote("Deltarune - Tenna Swing", 103139492736941, 39, "Aug 08, 2025")
addEmote("Hakari Dance", 80270168146449, 39, "Aug 08, 2025")
addEmote("Addendum Dance ", 134442882516163, 39, "Aug 09, 2025")
addEmote("Gangnam Style", 77205409178702, 39, "Aug 08, 2025")
addEmote("Push-Up", 117922227854118, 39, "Aug 09, 2025")
addEmote("Split", 98522218962476, 39, "Aug 08, 2025")
addEmote("PROXIMA", 81390693780805, 39, "Aug 08, 2025")
addEmote("HeadBanging", 87447252507832, 39, "Aug 08, 2025")
addEmote("Assumptions", 127507691649322, 39, "Aug 08, 2025")
addEmote("Jumpstyle", 99563839802389, 39, "Aug 08, 2025")
addEmote("Flopping Fish", 133142324349281, 39, "Aug 08, 2025")
addEmote("Kicking Feet Sit", 78758922757947, 39, "Aug 08, 2025")
addEmote("Fancy Feets", 124512151372711, 39, "Aug 08, 2025")
addEmote("Cute Sit", 90244178386698, 39, "Aug 08, 2025")
addEmote("Absolute Cinema", 97258018304125, 39, "Aug 08, 2025")
addEmote("Bubbly Sit", 112758073578333, 39, "Aug 08, 2025")
addEmote("Become A Car", 131544122623505, 39, "Aug 08, 2025")
addEmote("Hiding Human Box", 124935873390035, 39, "Aug 08, 2025")
addEmote("Magical Pose", 135489824748823, 39, "Aug 08, 2025")
addEmote("Griddy", 116065653184749, 39, "Aug 08, 2025")
addEmote("Gon Rage", 139639173024927, 39, "Aug 10, 2025")
addEmote("Become Couch", 93335594132613, 39, "Aug 10, 2025")
addEmote("Spare Change", 126749574427431, 39, "Aug 10, 2025")
addEmote("Paranoid", 123407922818447, 39, "Aug 10, 2025")
addEmote("Kawaii Groove", 77152953688098, 39, "Aug 18, 2025")
addEmote("Ai Cat dance", 136593170936320, 39, "Aug 18, 2025")
addEmote("Smeeze", 131683926643291, 39, "Aug 18, 2025")
addEmote("Onion", 113890289455724, 39, "Aug 18, 2025")
addEmote("Thinking", 124584711308900, 39, "Aug 18, 2025")
addEmote("Little Obbyist", 134584040095037, 39, "Aug 10, 2025")
addEmote("Aura Fly", 78755795767408, 39, "Aug 10, 2025")
addEmote("Invisible", 109899950448992, 39, "Aug 10, 2025")
addEmote("Slenderman", 81926508907412, 39, "Aug 10, 2025")
addEmote("Chill pose", 77058107325712, 39, "Aug 10, 2025")
addEmote("house", 93552301087938, 39, "Aug 10, 2025")
addEmote("baby", 82824758023484, 39, "Aug 10, 2025")
addEmote("zenitsu", 92750276568993, 39, "Aug 10, 2025")
addEmote("gun", 73562814360939, 39, "Aug 10, 2025")
addEmote("Spy Laugh tf2", 137720205462499, 39, "Aug 10, 2025")
addEmote("Head Juggling", 82224981519682, 39, "Aug 09, 2025")
addEmote("Omniman Think", 70560694892323, 39, "Aug 09, 2025")
addEmote("Ishowspeed Shake Dancing", 138386881919239, 39, "Aug 09, 2025")
addEmote("Wait", 106569806588657, 39, "Aug 09, 2025")
addEmote("Shinji Pose", 97629500912487, 39, "Aug 09, 2025")
addEmote("Come At Me [ R6 ]", 107758370940834, 39, "Aug 09, 2025")
addEmote("Oscillating Fan", 71493999860590, 39, "Aug 09, 2025")
addEmote("Locked In", 110145155419199, 39, "Aug 10, 2025")
addEmote("BirdBrain", 105730788757021, 39, "Aug 10, 2025")
addEmote("Hakari (FULL)", 71056659089869, 39, "Aug 09, 2025")
addEmote("How A Creeper Walk", 108714986908463, 39, "Aug 10, 2025")
addEmote("Hakari (R6)", 127103118569243, 39, "Aug 10, 2025")
addEmote("Strongest Stance", 80146495484274, 39, "Aug 09, 2025")
addEmote("Cat Things", 131193808160056, 39, "Aug 09, 2025")
addEmote("Doggy Things", 105206768873249, 39, "Aug 09, 2025")
addEmote("Wally West Edit", 72247161810866, 39, "Aug 09, 2025")
addEmote("24 Hour Cinderella", 122972776209997, 39, "Aug 09, 2025")
addEmote("Mesmerizer", 92707348383277, 39, "Aug 15, 2025")
addEmote("Stylish Float", 97497383284399, 39, "Aug 15, 2025")
addEmote("SpongeBob Shuffle", 107899954696611, 39, "Aug 15, 2025")
addEmote("Electro Shuffle", 96426537876059, 39, "Aug 13, 2025")
addEmote("Foreign Shuffle", 101507732056031, 39, "Aug 13, 2025")
addEmote("Caipirinha", 100165303717371, 39, "Aug 15, 2025")
addEmote("Squidward Yell", 109244554368414, 39, "Aug 15, 2025")
addEmote("Hakari (Forsaken)", 73271793399763, 39, "Aug 15, 2025")
addEmote("Teto Dance", 93031502567721, 39, "Aug 15, 2025")
addEmote("Michael Myers", 88229016850146, 39, "Aug 15, 2025")
addEmote("Gun Shoot", 105055412595333, 39, "Aug 15, 2025")
addEmote("Torture Dance", 116099356619436, 39, "Aug 16, 2025")
addEmote("Yapping Yap Gesture", 119870339321091, 39, "Aug 16, 2025")
addEmote("Luxurious / Springtrap", 132151459316300, 39, "Aug 16, 2025")
addEmote("Hand Drill", 103882178542598, 39, "Aug 16, 2025")
addEmote("exclamation", 82714556886471, 39, "Aug 16, 2025")
addEmote("Mewing / Mogging", 135493514352956, 39, "Aug 16, 2025")
addEmote("lemon melon cookie - Miku", 79874689836683, 39, "Aug 16, 2025")
addEmote("Cute Jump", 80556794144838, 39, "Aug 16, 2025")
addEmote("Billy Bounce", 126516908191316, 39, "Aug 15, 2025")
addEmote("What U Want / Prince Egypt", 133751526608969, 39, "Aug 15, 2025")
addEmote("Rabbit Hole - Miku", 133481721436918, 39, "Aug 15, 2025")
addEmote("Garou", 86200585395371, 39, "Aug 09, 2025")
addEmote("Dio Pose", 76736978166708, 39, "Aug 09, 2025")
addEmote("Golden Freddy", 122463450997235, 39, "Aug 09, 2025")
addEmote("Noclip, Speed", 137006085779408, 39, "Aug 09, 2025")
addEmote("Static [Hatsune Miku]", 84534006084837, 39, "Aug 09, 2025")
addEmote("GOALL", 78830825254717, 39, "Aug 09, 2025")
addEmote("Lethal Dance", 77108921633993, 39, "Aug 09, 2025")
addEmote("Plug Walk", 100359724990859, 39, "Aug 09, 2025")
addEmote("At Ease", 76993139936388, 39, "Aug 09, 2025")
addEmote("Conga", 97547955535086, 39, "Aug 09, 2025")
addEmote("Barrel", 84511772437190, 39, "Aug 08, 2025")
addEmote("Helicopter", 84555218084038, 39, "Aug 08, 2025")
addEmote("Aura Farm Boat", 88042995626011, 39, "Aug 09, 2025")
addEmote("Prince Of Egypt", 134063402217274, 39, "Aug 08, 2025")
addEmote("Jersey Joe2", 115782117564871, 39, "Aug 09, 2025")
addEmote("Deltarune - Tenna Dance", 73715378215546, 39, "Aug 08, 2025")
addEmote("California Girl", 132074413582912, 39, "Aug 08, 2025")
addEmote("Default Dance", 80877772569772, 39, "Aug 08, 2025")
addEmote("Shocked meme", 129501229484294, 39, "Aug 08, 2025")
addEmote("Family Guy", 78459263478161, 39, "Aug 08, 2025")
addEmote("Car Transformation", 96887377943085, 39, "Aug 08, 2025")
addEmote("Insanity", 129843344424281, 39, "Aug 08, 2025")
addEmote("Honored One", 121643381580730, 39, "Aug 08, 2025")
addEmote("Sukuna", 91839607010745, 39, "Aug 08, 2025")
addEmote("Dropper", 130358790702800, 39, "Aug 08, 2025")
addEmote("Be Not Afraid", 70635223083942, 39, "Aug 08, 2025")
addEmote("Macarena", 91274761264433, 39, "Aug 08, 2025")
addEmote("Helicopter2", 119431985170060, 39, "Aug 08, 2025")
addEmote("RONALDO", 97547486465713, 39, "Aug 08, 2025")
addEmote("Nya Anime Dance", 126647057611522, 39, "Aug 08, 2025")
addEmote("Do that thang", 113772829398170, 39, "Aug 08, 2025")
addEmote("Squat?", 95441477641149, 39, "Aug 08, 2025")
addEmote("Slickback", 103789826265487, 39, "Aug 08, 2025")

Loading:Destroy()

-- sorting
table.sort(Emotes, function(a,b) return a.lastupdated > b.lastupdated end)
for i,v in pairs(Emotes) do v.sort.recentfirst = i end
table.sort(Emotes, function(a,b) return a.lastupdated < b.lastupdated end)
for i,v in pairs(Emotes) do v.sort.recentlast = i end
table.sort(Emotes, function(a,b) return a.name:lower() < b.name:lower() end)
for i,v in pairs(Emotes) do v.sort.alphabeticfirst = i end
table.sort(Emotes, function(a,b) return a.name:lower() > b.name:lower() end)
for i,v in pairs(Emotes) do v.sort.alphabeticlast = i end
table.sort(Emotes, function(a,b) return a.price < b.price end)
for i,v in pairs(Emotes) do v.sort.lowestprice = i end
table.sort(Emotes, function(a,b) return a.price > b.price end)
for i,v in pairs(Emotes) do v.sort.highestprice = i end

if isfile and isfile("FavoritedEmotes.txt") then
	pcall(function() FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt")) end)
end

local function CharacterAdded(Character)
	for i,v in pairs(Frame:GetChildren()) do if not v:IsA("UIGridLayout") then v:Destroy() end
	local Humanoid = WaitForChildOfClass(Character, "Humanoid")
	local Description = Humanoid:WaitForChild("HumanoidDescription",5) or Instance.new("HumanoidDescription",Humanoid)
	for _,e in pairs(Emotes) do Description:AddEmote(e.name, e.id) end

	local function ShowPage(page)
		for _,v in pairs(Frame:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end
		local totalPages = math.ceil(#Emotes / EMOTES_PER_PAGE)
	CurrentPage = math.clamp(page,1,totalPages)
		PageLabel.Text = CurrentPage.."/"..totalPages
		PrevPage.Visible = CurrentPage > 1
	NextPage.Visible = CurrentPage < totalPages

		local startIdx = (CurrentPage-1)*EMOTES_PER_PAGE + 1
		local endIdx = math.min(startIdx + EMOTES_PER_PAGE - 1, #Emotes)
		local Ratio = Instance.new("UIAspectRatioConstraint")
		Ratio.AspectType = Enum.AspectType.ScaleWithParentSize

		if CurrentPage == 1 then
			local random = Instance.new("TextButton")
			Ratio:Clone().Parent = random
			random.LayoutOrder = 0
			random.TextColor3 = Color3.new(1,1,1)
			random.BackgroundTransparency = 0.5
			random.BackgroundColor3 = Color3.new(0,0,0)
			random.TextScaled = true
			random.Text = "Random"
			random:SetAttribute("name","")
			Corner:Clone().Parent = random
			random.MouseButton1Click:Connect(function()
				local r = Emotes[math.random(1,#Emotes)]
				PlayEmote(r.name, r.id)
			end)
			random.Parent = Frame
		end

		for i = startIdx, endIdx do
			local Emote = Emotes[i]
			local EmoteButton = Instance.new("ImageButton")
			local IsFavorited = table.find(FavoritedEmotes, Emote.id)
			EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)
			EmoteButton.Name = tostring(Emote.id)
			EmoteButton:SetAttribute("name", Emote.name)
			Corner:Clone().Parent = EmoteButton
			EmoteButton.Image = Emote.icon
			EmoteButton.BackgroundTransparency = 0.5
			EmoteButton.BackgroundColor3 = Color3.new(0,0,0)
			EmoteButton.BorderSizePixel = 0
			Ratio:Clone().Parent = EmoteButton
			EmoteButton.Parent = Frame
			EmoteButton.MouseButton1Click:Connect(function() PlayEmote(Emote.name, Emote.id) end)
			EmoteButton.MouseEnter:Connect(function() EmoteName.Text = Emote.name end)

			local Favorite = Instance.new("ImageButton")
			Favorite.Name = "favorite"
			Favorite.Image = table.find(FavoritedEmotes, Emote.id) and FavoriteOn or FavoriteOff
			Favorite.AnchorPoint = Vector2.new(0.5,0.5)
			Favorite.Size = UDim2.new(0.2,0,0.2,0)
			Favorite.Position = UDim2.new(0.9,0.9,0)
			Favorite.BackgroundTransparency = 1
			Favorite.Parent = EmoteButton
			Favorite.MouseButton1Click:Connect(function()
				local idx = table.find(FavoritedEmotes, Emote.id)
				if idx then table.remove(FavoritedEmotes, idx) Favorite.Image = FavoriteOff
				else table.insert(FavoritedEmotes, Emote.id) Favorite.Image = FavoriteOn end
				pcall(function() writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes)) end)
			end)
		end
	end

	PrevPage.MouseButton1Click:Connect(function() ShowPage(CurrentPage-1) end)
	NextPage.MouseButton1Click:Connect(function() ShowPage(CurrentPage+1) end)
	ShowPage(1)
end

if LocalPlayer.Character then CharacterAdded(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(CharacterAdded)

wait(1)
game.CoreGui.Emotes.Enabled = true
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Done!",Text=#Emotes.." emotes - paginado!",Duration=5})
game.Players.LocalPlayer.PlayerGui:FindFirstChild("ContextActionGui")?.Destroy()
