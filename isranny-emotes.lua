--- Keybind to open for pc is "comma" -> ", "
-- Made by Gi#7331 - PAGINADO 20x
local env=getgenv()
if env.LastExecuted and tick()-env.LastExecuted<30 then return end
env.LastExecuted=tick()

print("Script executed!")

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Wait!",
    Text = "Loading fast paginated GUI",
    Duration = 5
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
Loading.Text = "Loading..."
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
PrevPage.Parent = BackFrame
PrevPage.AnchorPoint = Vector2.new(0.5, 0.5)
PrevPage.Position = UDim2.new(0.25, 0, -0.075, 0)
PrevPage.Size = UDim2.new(0.08, 0, 0.1, 0)
PrevPage.Text = "<"
PrevPage.TextScaled = true
PrevPage.BackgroundColor3 = Color3.new(0,0,0)
PrevPage.TextColor3 = Color3.new(1,1)
PrevPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = PrevPage

local NextPage = Instance.new("TextButton")
NextPage.Parent = BackFrame
NextPage.AnchorPoint = Vector2.new(0.5, 0.5)
NextPage.Position = UDim2.new(0.75, 0, -0.075, 0)
NextPage.Size = UDim2.new(0.08, 0, 0.1, 0)
NextPage.Text = ">"
NextPage.TextScaled = true
NextPage.BackgroundColor3 = Color3.new(0,0,0)
NextPage.TextColor3 = Color3.new(1,1)
NextPage.BackgroundTransparency = 0.3
Corner:Clone().Parent = NextPage

local PageLabel = Instance.new("TextLabel")
PageLabel.Parent = BackFrame
PageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
PageLabel.Position = UDim2.new(0.5, 0, -0.075, 0)
PageLabel.Size = UDim2.new(0.15, 0, 0.1, 0)
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
SearchBar.Position = UDim2.new(0.5, 0, 1.08, 0)
SearchBar.Size = UDim2.new(0.55, 0, 0.1, 0)
SearchBar.TextScaled = true
SearchBar.PlaceholderText = "Search current page"
SearchBar.TextColor3 = Color3.new(1, 1)
SearchBar.BackgroundColor3 = Color3.new(0, 0, 0)
SearchBar.BackgroundTransparency = 0.3
SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
	local text = SearchBar.Text:lower()
	for _,button in pairs(Frame:GetChildren()) do
		if button:IsA("GuiButton") then
			local name = button:GetAttribute("name")
			if name then
				button.Visible = text=="" or string.find(name:lower(), text, 1, true)
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

-- TU LISTA COMPLETA DE EMOTES (la dejé igual)
local Emotes = {
	{ name = "Around Town", id = 3576747102, icon = "rbxthumb://type=Asset&id=3576747102&w=150&h=150", price = 1000, lastupdated = 1663264200, sort = {} },
	{ name = "TWICE TAKEDOWN DANCE 2", id = 85623000473425, icon = "rbxthumb://type=Asset&id=85623000473425&w=150&h=150", price = 100, lastupdated = 1752192000, sort = {} },
	{ name = "Fashionable", id = 3576745472, icon = "rbxthumb://type=Asset&id=3576745472&w=150&h=150", price = 750, lastupdated = 1663281649, sort = {} },
	{ name = "Swish", id = 3821527813, icon = "rbxthumb://type=Asset&id=3821527813&w=150&h=150", price = 750, lastupdated = 1663281651, sort = {} },
	{ name = "Top Rock", id = 3570535774, icon = "rbxthumb://type=Asset&id=3570535774&w=150&h=150", price = 750, lastupdated = 1663281651, sort = {} },
	-- [... PEGA AQUÍ TODOS TUS EMOTES, NO LOS BORRÉ...]
	{ name = "Shrug", id = 3576968026, icon = "rbxthumb://type=Asset&id=3576968026&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },
}

-- tus addEmote() de abajo siguen igual
local function addEmote(name, id, price, date)
    local months = {Jan=1,Feb=2,Mar=3,Apr=4,May=5,Jun=6,Jul=7,Aug=8,Sep=9,Oct=10,Nov=11,Dec=12}
    local function dateToUnix(d)
        local mon, day, year = d:match("(%a+)%s+(%d+),%s*(%d+)")
        return os.time({year=tonumber(year), month=months[mon], day=tonumber(day)})
    end
    table.insert(Emotes, {name=name, id=id, icon="rbxthumb://type=Asset&id="..id.."&w=150&h=150", price=price, lastupdated=dateToUnix(date), sort={}})
end

-- [... todos tus addEmote()...]
addEmote("PARROT PARTY DANCE", 121067808279598, 39, "Aug 08, 2025")
-- [... resto de addEmote...]

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
	for i,v in pairs(Frame:GetChildren()) do
		if not v:IsA("UIGridLayout") then v:Destroy() end
	end
	local Humanoid = WaitForChildOfClass(Character, "Humanoid")
	local Description = Humanoid:WaitForChild("HumanoidDescription", 5) or Instance.new("HumanoidDescription", Humanoid)
	for _,Emote in pairs(Emotes) do Description:AddEmote(Emote.name, Emote.id) end

	local function ShowPage(page)
		for _,v in pairs(Frame:GetChildren()) do if v:IsA("GuiButton") then v:Destroy() end
		local totalPages = math.ceil(#Emotes / EMOTES_PER_PAGE)
	CurrentPage = math.clamp(page, 1, totalPages)
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
			random.TextColor3 = Color3.new(1,1)
			random.BackgroundTransparency = 0.5
			random.BackgroundColor3 = Color3.new(0,0,0)
			random.TextScaled = true
			random.Text = "Random"
			random:SetAttribute("name", "")
			Corner:Clone().Parent = random
			random.MouseButton1Click:Connect(function()
				local e = Emotes[math.random(1,#Emotes)]
				PlayEmote(e.name, e.id)
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
			Favorite.Size = UDim2.new(0.2,0.2,0)
			Favorite.Position = UDim2.new(0.9,0.9,0)
			Favorite.BackgroundTransparency = 1
			Favorite.Parent = EmoteButton
			Favorite.MouseButton1Click:Connect(function()
				local idx = table.find(FavoritedEmotes, Emote.id)
				if idx then table.remove(FavoritedEmotes, idx) Favorite.Image = FavoriteOff
				else table.insert(FavoritedEmotes, Emote.id) Favorite.Image = FavoriteOn end
				pcall(function() writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes)) end)
				ShowPage(CurrentPage)
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
game:GetService("StarterGui"):SetCore("SendNotification",{Title="Done!",Text=#Emotes.." emotes loaded - paginated!",Duration=5})
