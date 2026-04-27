--- Keybind to open for pc is "comma" -> " , "

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

			icon = "rbxthumb://type=Asset&id=".. id .."&w=150&h=150",

			price = price or 0,

			lastupdated = unix,

			sort = {}

		}

		table.insert(Emotes, emoteData)

	end)

end





local function CreateButtonFromEmoteInfo(emote)

	local button = Instance.new("TextButton")

	button.Name = tostring(emote.id)

	button.Text = emote.name .. " - $" .. emote.price

	button.Size = UDim2.new(0, 200, 0, 50)

	button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

	button.TextColor3 = Color3.new(1, 1, 1)

	button.MouseButton1Click:Connect(function()

		print("Selected Emote: " .. emote.name .. ", ID: " .. emote.id)

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

Open.TextColor3 = Color3.fromRGB(255, 255, 255)

Open.TextScaled = true

Open.TextSize = 20

Open.Visible = true

Open.BackgroundTransparency = .5

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

		local EmoteButton = Frame:FindFirstChild(Emote.id)

		if not EmoteButton then

			continue

		end

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

	local buttons = Frame:GetChildren()

	if text ~= text:sub(1,50) then

		SearchBar.Text = SearchBar.Text:sub(1,50)

		text = SearchBar.Text:lower()

	end

	if text ~= ""  then

		for i,button in pairs(buttons) do

			if button:IsA("GuiButton") then

				local name = button:GetAttribute("name"):lower()

				if name:match(text) then

					button.Visible = true

				else

					button.Visible = false

				end

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



ContextActionService:BindCoreActionAtPriority(

	"Emote Menu",

	openemotes,

	true,

	2001,

	Enum.KeyCode.Comma

)



local inputconnect

ScreenGui:GetPropertyChangedSignal("Enabled"):Connect(function()

	if BackFrame.Visible == false then

		EmoteName.Text = "Select an Emote"

		SearchBar.Text = ""

		SortFrame.Visible = false

		GuiService:SetEmotesMenuOpen(false)

		inputconnect = UserInputService.InputBegan:Connect(function(input, processed)

			if not processed then

				if input.UserInputType == Enum.UserInputType.MouseButton1 then

					BackFrame.Visible = false

					Open.Text = "Open"

				end

			end

		end)

	else

		inputconnect:Disconnect()

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



if not game:IsLoaded() then

	game.Loaded:Wait()

end



--thanks inf yield

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

		syn.toast_notification({

			Type = ToastType.Error,

			Title = title,

			Content = text

		})

	else

		StarterGui:SetCore("SendNotification", {

			Title = title,

			Text = text

		})

	end

end



local LocalPlayer = Players.LocalPlayer



local function PlayEmote(name: string, id: IntValue)

	BackFrame.Visible = false

	Open.Text = "Open"

	SearchBar.Text = ""

	local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

	local Description = Humanoid and Humanoid:FindFirstChildOfClass("HumanoidDescription")

	if not Description then

		return

	end

	if LocalPlayer.Character.Humanoid.RigType ~= Enum.HumanoidRigType.R6 then

		local succ, err = pcall(function()

			Humanoid:PlayEmoteAndGetAnimTrackById(id)

		end)

		if not succ then

			Description:AddEmote(name, id)

			Humanoid:PlayEmoteAndGetAnimTrackById(id)

		end

	else

		SendNotification(

			"r6? lol",

			"you gotta be r15 dude"

		)

	end

end



local function WaitForChildOfClass(parent, class)

	local child = parent:FindFirstChildOfClass(class)

	while not child or child.ClassName ~= class do

		child = parent.ChildAdded:Wait()

	end

	return child

end

local Emotes = {

	{ name = "Around Town", id = 3576747102, icon = "rbxthumb://type=Asset&id=3576747102&w=150&h=150", price = 1000, lastupdated = 1663264200, sort = {} },	
{

    name = "TWICE TAKEDOWN DANCE 2",

    id = 85623000473425,

    icon = "rbxthumb://type=Asset&id=85623000473425&w=150&h=150",

    price = 100,

    lastupdated = 1752192000,

    sort = {}

},

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

	{ name = "Show Dem Wrists - KSI", id = 7202898984, icon = "rbxthumb://type=Asset&id=7202898984&w=150&h=150", price = 140, lastupdated = 1663281651, sort = {} },

	{ name = "Dancin' Shoes - Twenty One Pilots", id = 7405123844, icon = "rbxthumb://type=Asset&id=7405123844&w=150&h=150", price = 140, lastupdated = 1663281649, sort = {} },

	{ name = "Arm Twist", id = 9710992846, icon = "rbxthumb://type=Asset&id=9710992846&w=150&h=150", price = 140, lastupdated = 1691019410, sort = {} },

	{ name = "AOK - Tai Verdes", id = 7942960760, icon = "rbxthumb://type=Asset&id=7942960760&w=150&h=150", price = 140, lastupdated = 1663281649, sort = {} },

	{ name = "M3GAN's Dance", id = 127271798262177, icon = "rbxthumb://type=Asset&id=127271798262177&w=150&h=150", price = 140, lastupdated = 1749963148, sort = {} },

	{ name = "High Hands", id = 9710994651, icon = "rbxthumb://type=Asset&id=9710994651&w=150&h=150", price = 140, lastupdated = 1691019393, sort = {} },

	{ name = "Cobra Arms - Tai Verdes", id = 7942964447, icon = "rbxthumb://type=Asset&id=7942964447&w=150&h=150", price = 130, lastupdated = 1663281649, sort = {} },

	{ name = "Lasso Turn - Tai Verdes", id = 7942972744, icon = "rbxthumb://type=Asset&id=7942972744&w=150&h=150", price = 130, lastupdated = 1663281650, sort = {} },

	{ name = "Beauty Touchdown", id = 16303091119, icon = "rbxthumb://type=Asset&id=16303091119&w=150&h=150", price = 125, lastupdated = 1709320484, sort = {} },

	{ name = "Sidekicks - George Ezra", id = 10370922566, icon = "rbxthumb://type=Asset&id=10370922566&w=150&h=150", price = 125, lastupdated = 1659650831, sort = {} },

	{ name = "Boom Boom Clap - George Ezra", id = 10370934040, icon = "rbxthumb://type=Asset&id=10370934040&w=150&h=150", price = 125, lastupdated = 1659650857, sort = {} },

	{ name = "DearALICE - Ariana", id = 133765015173412, icon = "rbxthumb://type=Asset&id=133765015173412&w=150&h=150", price = 125, lastupdated = 1748015544, sort = {} },

	{ name = "Chappell Roan HOT TO GO!", id = 79312439851071, icon = "rbxthumb://type=Asset&id=79312439851071&w=150&h=150", price = 125, lastupdated = 1728072364, sort = {} },

	{ name = "Bone Chillin' Bop", id = 15123050663, icon = "rbxthumb://type=Asset&id=15123050663&w=150&h=150", price = 125, lastupdated = 1698882605, sort = {} },

	{ name = "Power Blast", id = 4849497510, icon = "rbxthumb://type=Asset&id=4849497510&w=150&h=150", price = 120, lastupdated = 1663281650, sort = {} },

	{ name = "Flowing Breeze", id = 7466047578, icon = "rbxthumb://type=Asset&id=7466047578&w=150&h=150", price = 110, lastupdated = 1663281650, sort = {} },

	{ name = "Swan Dance", id = 7466048475, icon = "rbxthumb://type=Asset&id=7466048475&w=150&h=150", price = 110, lastupdated = 1663281651, sort = {} },

	{ name = "Quiet Waves", id = 7466046574, icon = "rbxthumb://type=Asset&id=7466046574&w=150&h=150", price = 110, lastupdated = 1663281650, sort = {} },

	{ name = "Rolling Stones Guitar Strum", id = 18148839527, icon = "rbxthumb://type=Asset&id=18148839527&w=150&h=150", price = 100, lastupdated = 1718999383, sort = {} },

	{ name = "Break Dance", id = 5915773992, icon = "rbxthumb://type=Asset&id=5915773992&w=150&h=150", price = 100, lastupdated = 1663281649, sort = {} },

	{ name = "KATSEYE - Touch", id = 139021427684680, icon = "rbxthumb://type=Asset&id=139021427684680&w=150&h=150", price = 100, lastupdated = 1732569484, sort = {} },

	{ name = "Zombie", id = 4212496830, icon = "rbxthumb://type=Asset&id=4212496830&w=150&h=150", price = 100, lastupdated = 1663281651, sort = {} },

	{ name = "Olivia Rodrigo Head Bop", id = 15554010118, icon = "rbxthumb://type=Asset&id=15554010118&w=150&h=150", price = 100, lastupdated = 1701888912, sort = {} },

	{ name = "Rasputin – Boney M.", id = 133477296392756, icon = "rbxthumb://type=Asset&id=133477296392756&w=150&h=150", price = 100, lastupdated = 1750102356, sort = {} },

	{ name = "Tommy K-Pop Mic Drop", id = 14024722653, icon = "rbxthumb://type=Asset&id=14024722653&w=150&h=150", price = 100, lastupdated = 1691505558, sort = {} },

	{ name = "TWICE Feel Special", id = 14900153406, icon = "rbxthumb://type=Asset&id=14900153406&w=150&h=150", price = 100, lastupdated = 1695849104, sort = {} },

	{ name = "Olivia Rodrigo good 4 u", id = 15554013003, icon = "rbxthumb://type=Asset&id=15554013003&w=150&h=150", price = 100, lastupdated = 1701899524, sort = {} },

	{ name = "Olivia Rodrigo Fall Back to Float", id = 15554016057, icon = "rbxthumb://type=Asset&id=15554016057&w=150&h=150", price = 100, lastupdated = 1704909517, sort = {} },

	{ name = "Air Guitar", id = 15506499986, icon = "rbxthumb://type=Asset&id=15506499986&w=150&h=150", price = 100, lastupdated = 1705451692, sort = {} },

	{ name = "Fashion Klossette - Runway my way", id = 126683684984862, icon = "rbxthumb://type=Asset&id=126683684984862&w=150&h=150", price = 100, lastupdated = 1725032194, sort = {} },

	{ name = "Elton John - Heart Skip", id = 11309263077, icon = "rbxthumb://type=Asset&id=11309263077&w=150&h=150", price = 100, lastupdated = 1667432377, sort = {} },

	{ name = "Baby Dance", id = 4272484885, icon = "rbxthumb://type=Asset&id=4272484885&w=150&h=150", price = 100, lastupdated = 1663264200, sort = {} },

	{ name = "Cha Cha", id = 6865013133, icon = "rbxthumb://type=Asset&id=6865013133&w=150&h=150", price = 100, lastupdated = 1625675362, sort = {} },

	{ name = "Dolphin Dance", id = 5938365243, icon = "rbxthumb://type=Asset&id=5938365243&w=150&h=150", price = 100, lastupdated = 1663281649, sort = {} },

	{ name = "Elton John - Rock Out", id = 11753545334, icon = "rbxthumb://type=Asset&id=11753545334&w=150&h=150", price = 100, lastupdated = 1670628204, sort = {} },

	{ name = "ALTÉGO - Couldn’t Care Less", id = 92859581691366, icon = "rbxthumb://type=Asset&id=92859581691366&w=150&h=150", price = 100, lastupdated = 1726765025, sort = {} },

	{ name = "Fashion Roadkill", id = 73683655527605, icon = "rbxthumb://type=Asset&id=73683655527605&w=150&h=150", price = 100, lastupdated = 1727716460, sort = {} },

	{ name = "Paris Hilton Sanasa", id = 16126526506, icon = "rbxthumb://type=Asset&id=16126526506&w=150&h=150", price = 100, lastupdated = 1706312634, sort = {} },

	{ name = "TWICE I GOT YOU part 1", id = 16215060261, icon = "rbxthumb://type=Asset&id=16215060261&w=150&h=150", price = 100, lastupdated = 1708450164, sort = {} },

	{ name = "The Zabb", id = 71389516735424, icon = "rbxthumb://type=Asset&id=71389516735424&w=150&h=150", price = 100, lastupdated = 1725033197, sort = {} },

	{ name = "Y", id = 4391211308, icon = "rbxthumb://type=Asset&id=4391211308&w=150&h=150", price = 100, lastupdated = 1663281651, sort = {} },

	{ name = "Wanna play?", id = 16646438742, icon = "rbxthumb://type=Asset&id=16646438742&w=150&h=150", price = 100, lastupdated = 1709741603, sort = {} },

	{ name = "TWICE I GOT YOU part 2", id = 16256253954, icon = "rbxthumb://type=Asset&id=16256253954&w=150&h=150", price = 100, lastupdated = 1708450173, sort = {} },

	{ name = "Nicki Minaj Starships", id = 15571540519, icon = "rbxthumb://type=Asset&id=15571540519&w=150&h=150", price = 100, lastupdated = 1704780058, sort = {} },

	{ name = "Mean Girls Dance Break", id = 15963348695, icon = "rbxthumb://type=Asset&id=15963348695&w=150&h=150", price = 100, lastupdated = 1705126454, sort = {} },

	{ name = "TWICE Takedown", id = 94796833553521, icon = "rbxthumb://type=Asset&id=94796833553521&w=150&h=150", price = 100, lastupdated = 1750434081, sort = {} },

	{ name = "Samba", id = 6869813008, icon = "rbxthumb://type=Asset&id=6869813008&w=150&h=150", price = 100, lastupdated = 1663281651, sort = {} },

	{ name = "Rock Out - Bebe Rexha", id = 18225077553, icon = "rbxthumb://type=Asset&id=18225077553&w=150&h=150", price = 100, lastupdated = 1719448619, sort = {} },

	{ name = "TWICE LIKEY", id = 14900151704, icon = "rbxthumb://type=Asset&id=14900151704&w=150&h=150", price = 100, lastupdated = 1695849068, sort = {} },

	{ name = "Sol de Janeiro - Samba", id = 16276506814, icon = "rbxthumb://type=Asset&id=16276506814&w=150&h=150", price = 100, lastupdated = 1707323755, sort = {} },

	{ name = "The Weeknd Opening Night", id = 105098895743105, icon = "rbxthumb://type=Asset&id=105098895743105&w=150&h=150", price = 100, lastupdated = 1747430460, sort = {} },

	{ name = "Paris Hilton - Sliving For The Groove", id = 15392927897, icon = "rbxthumb://type=Asset&id=15392927897&w=150&h=150", price = 100, lastupdated = 1700334418, sort = {} },

	{ name = "Paris Hilton - Checking My Angles", id = 15392937495, icon = "rbxthumb://type=Asset&id=15392937495&w=150&h=150", price = 100, lastupdated = 1700334434, sort = {} },

	{ name = "Nicki Minaj Boom Boom Boom", id = 15571538346, icon = "rbxthumb://type=Asset&id=15571538346&w=150&h=150", price = 100, lastupdated = 1704779662, sort = {} },

	{ name = "Stray Kids Walkin On Water", id = 100773414188482, icon = "rbxthumb://type=Asset&id=100773414188482&w=150&h=150", price = 100, lastupdated = 1738351370, sort = {} },

	{ name = "Team USA Breaking Emote", id = 18526338976, icon = "rbxthumb://type=Asset&id=18526338976&w=150&h=150", price = 100, lastupdated = 1721666622, sort = {} },

	{ name = "Side to Side", id = 3762641826, icon = "rbxthumb://type=Asset&id=3762641826&w=150&h=150", price = 100, lastupdated = 1663281651, sort = {} },

	{ name = "Skibidi Toilet - Titan Speakerman Laser Spin", id = 103102322875221, icon = "rbxthumb://type=Asset&id=103102322875221&w=150&h=150", price = 100, lastupdated = 1727890994, sort = {} },

	{ name = "Paris Hilton - Iconic IT-Grrrl", id = 15392932768, icon = "rbxthumb://type=Asset&id=15392932768&w=150&h=150", price = 100, lastupdated = 1700334426, sort = {} },

	{ name = "Dave's Spin Move - Glass Animals", id = 16276501655, icon = "rbxthumb://type=Asset&id=16276501655&w=150&h=150", price = 95, lastupdated = 1707321025, sort = {} },

	{ name = "HUGO Let's Drive!", id = 17360720445, icon = "rbxthumb://type=Asset&id=17360720445&w=150&h=150", price = 95, lastupdated = 1721145133, sort = {} },

	{ name = "Fast Hands", id = 4272351660, icon = "rbxthumb://type=Asset&id=4272351660&w=150&h=150", price = 80, lastupdated = 1663281649, sort = {} },

	{ name = "Tree", id = 4049634387, icon = "rbxthumb://type=Asset&id=4049634387&w=150&h=150", price = 80, lastupdated = 1663281651, sort = {} },

	{ name = "Godlike", id = 3823158750, icon = "rbxthumb://type=Asset&id=3823158750&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Keeping Time", id = 4646306072, icon = "rbxthumb://type=Asset&id=4646306072&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Elton John - Heart Shuffle", id = 17748346932, icon = "rbxthumb://type=Asset&id=17748346932&w=150&h=150", price = 80, lastupdated = 1720191180, sort = {} },

	{ name = "Tantrum", id = 5104374556, icon = "rbxthumb://type=Asset&id=5104374556&w=150&h=150", price = 80, lastupdated = 1663281651, sort = {} },

	{ name = "Rock On", id = 5915782672, icon = "rbxthumb://type=Asset&id=5915782672&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Hero Landing", id = 5104377791, icon = "rbxthumb://type=Asset&id=5104377791&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Fishing", id = 3994129128, icon = "rbxthumb://type=Asset&id=3994129128&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Floss Dance", id = 5917570207, icon = "rbxthumb://type=Asset&id=5917570207&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Get Out", id = 3934984583, icon = "rbxthumb://type=Asset&id=3934984583&w=150&h=150", price = 80, lastupdated = 1663281650, sort = {} },

	{ name = "Victory Dance", id = 15506503658, icon = "rbxthumb://type=Asset&id=15506503658&w=150&h=150", price = 75, lastupdated = 1705451709, sort = {} },

	{ name = "d4vd - Backflip", id = 15694504637, icon = "rbxthumb://type=Asset&id=15694504637&w=150&h=150", price = 50, lastupdated = 1703220450, sort = {} },

	{ name = "GloRilla - \"Tomorrow\" Dance", id = 15689315657, icon = "rbxthumb://type=Asset&id=15689315657&w=150&h=150", price = 50, lastupdated = 1703220424, sort = {} },

	{ name = "Monkey", id = 3716636630, icon = "rbxthumb://type=Asset&id=3716636630&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "Imagine Dragons - “Bones” Dance", id = 15689314578, icon = "rbxthumb://type=Asset&id=15689314578&w=150&h=150", price = 50, lastupdated = 1703220437, sort = {} },

	{ name = "Greatest", id = 3762654854, icon = "rbxthumb://type=Asset&id=3762654854&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "Jawny - Stomp", id = 16392120020, icon = "rbxthumb://type=Asset&id=16392120020&w=150&h=150", price = 50, lastupdated = 1708707354, sort = {} },

	{ name = "Jumping Wave", id = 4940602656, icon = "rbxthumb://type=Asset&id=4940602656&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "HIPMOTION - Amaarae", id = 16572756230, icon = "rbxthumb://type=Asset&id=16572756230&w=150&h=150", price = 50, lastupdated = 1709321680, sort = {} },

	{ name = "Haha", id = 4102315500, icon = "rbxthumb://type=Asset&id=4102315500&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "Agree", id = 4849487550, icon = "rbxthumb://type=Asset&id=4849487550&w=150&h=150", price = 50, lastupdated = 1663264200, sort = {} },

	{ name = "Mae Stephens - Piano Hands", id = 16553249658, icon = "rbxthumb://type=Asset&id=16553249658&w=150&h=150", price = 50, lastupdated = 1713462132, sort = {} },

	{ name = "Mini Kong", id = 17000058939, icon = "rbxthumb://type=Asset&id=17000058939&w=150&h=150", price = 50, lastupdated = 1712176275, sort = {} },

	{ name = "Mae Stephens – Arm Wave", id = 16584496781, icon = "rbxthumb://type=Asset&id=16584496781&w=150&h=150", price = 50, lastupdated = 1713462122, sort = {} },

	{ name = "Festive Dance", id = 15679955281, icon = "rbxthumb://type=Asset&id=15679955281&w=150&h=150", price = 50, lastupdated = 1703018450, sort = {} },

	{ name = "Jumping Cheer", id = 5895009708, icon = "rbxthumb://type=Asset&id=5895009708&w=150&h=150", price = 50, lastupdated = 1604988014, sort = {} },

	{ name = "Sleep", id = 4689362868, icon = "rbxthumb://type=Asset&id=4689362868&w=150&h=150", price = 50, lastupdated = 1663281651, sort = {} },

	{ name = "ericdoa - dance", id = 15698510244, icon = "rbxthumb://type=Asset&id=15698510244&w=150&h=150", price = 50, lastupdated = 1703220462, sort = {} },

	{ name = "Disagree", id = 4849495710, icon = "rbxthumb://type=Asset&id=4849495710&w=150&h=150", price = 50, lastupdated = 1663281649, sort = {} },

	{ name = "Happy", id = 4849499887, icon = "rbxthumb://type=Asset&id=4849499887&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "Bored", id = 5230661597, icon = "rbxthumb://type=Asset&id=5230661597&w=150&h=150", price = 50, lastupdated = 1663281649, sort = {} },

	{ name = "High Wave", id = 5915776835, icon = "rbxthumb://type=Asset&id=5915776835&w=150&h=150", price = 50, lastupdated = 1663281650, sort = {} },

	{ name = "Alo Yoga Pose - Warrior II", id = 12507106431, icon = "rbxthumb://type=Asset&id=12507106431&w=150&h=150", price = 50, lastupdated = 1677711229, sort = {} },

	{ name = "Cower", id = 4940597758, icon = "rbxthumb://type=Asset&id=4940597758&w=150&h=150", price = 50, lastupdated = 1591404331, sort = {} },

	{ name = "Wisp - air guitar", id = 17370797454, icon = "rbxthumb://type=Asset&id=17370797454&w=150&h=150", price = 50, lastupdated = 1714753031, sort = {} },

	{ name = "Alo Yoga Pose - Triangle", id = 12507120275, icon = "rbxthumb://type=Asset&id=12507120275&w=150&h=150", price = 50, lastupdated = 1677711156, sort = {} },

	{ name = "Cuco - Levitate", id = 15698511500, icon = "rbxthumb://type=Asset&id=15698511500&w=150&h=150", price = 50, lastupdated = 1708707329, sort = {} },

	{ name = "Rock n Roll", id = 15506496093, icon = "rbxthumb://type=Asset&id=15506496093&w=150&h=150", price = 50, lastupdated = 1705451701, sort = {} },

	{ name = "Shy", id = 3576717965, icon = "rbxthumb://type=Asset&id=3576717965&w=150&h=150", price = 50, lastupdated = 1663281651, sort = {} },

	{ name = "Alo Yoga Pose - Lotus Position", id = 12507097350, icon = "rbxthumb://type=Asset&id=12507097350&w=150&h=150", price = 50, lastupdated = 1677711092, sort = {} },

	{ name = "Curtsy", id = 4646306583, icon = "rbxthumb://type=Asset&id=4646306583&w=150&h=150", price = 50, lastupdated = 1663281649, sort = {} },

	{ name = "Celebrate", id = 3994127840, icon = "rbxthumb://type=Asset&id=3994127840&w=150&h=150", price = 50, lastupdated = 1663281649, sort = {} },

	{ name = "Yungblud Happier Jump", id = 15610015346, icon = "rbxthumb://type=Asset&id=15610015346&w=150&h=150", price = 50, lastupdated = 1702326238, sort = {} },

	{ name = "Baby Queen - Face Frame", id = 14353421343, icon = "rbxthumb://type=Asset&id=14353421343&w=150&h=150", price = 50, lastupdated = 1692371043, sort = {} },

	{ name = "Confused", id = 4940592718, icon = "rbxthumb://type=Asset&id=4940592718&w=150&h=150", price = 50, lastupdated = 1590791657, sort = {} },

	{ name = "Beckon", id = 5230615437, icon = "rbxthumb://type=Asset&id=5230615437&w=150&h=150", price = 50, lastupdated = 1663281649, sort = {} },

	{ name = "Secret Handshake Dance", id = 120642514156293, icon = "rbxthumb://type=Asset&id=120642514156293&w=150&h=150", price = 50, lastupdated = 1733254849, sort = {} },

	{ name = "Baby Queen - Air Guitar & Knee Slide", id = 14353417553, icon = "rbxthumb://type=Asset&id=14353417553&w=150&h=150", price = 50, lastupdated = 1692371054, sort = {} },

	{ name = "Baby Queen - Bouncy Twirl", id = 14353423348, icon = "rbxthumb://type=Asset&id=14353423348&w=150&h=150", price = 50, lastupdated = 1692371037, sort = {} },

	{ name = "Baby Queen - Strut", id = 14353425085, icon = "rbxthumb://type=Asset&id=14353425085&w=150&h=150", price = 50, lastupdated = 1692371026, sort = {} },

	{ name = "Baby Queen - Dramatic Bow", id = 14353419229, icon = "rbxthumb://type=Asset&id=14353419229&w=150&h=150", price = 50, lastupdated = 1692371048, sort = {} },

	{ name = "Sad", id = 4849502101, icon = "rbxthumb://type=Asset&id=4849502101&w=150&h=150", price = 50, lastupdated = 1663281651, sort = {} },

	{ name = "Robot M3GAN", id = 90569436057900, icon = "rbxthumb://type=Asset&id=90569436057900&w=150&h=150", price = 1, lastupdated = 1749316525, sort = {} },

	{ name = "Nicki Minaj Anaconda", id = 15571539403, icon = "rbxthumb://type=Asset&id=15571539403&w=150&h=150", price = 0, lastupdated = 1702052956, sort = {} },

	{ name = "Cha-Cha", id = 3696764866, icon = "rbxthumb://type=Asset&id=3696764866&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "BURBERRY LOLA ATTITUDE - BLOOM", id = 10147919199, icon = "rbxthumb://type=Asset&id=10147919199&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "Skadoosh Emote - Kung Fu Panda 4", id = 16371235025, icon = "rbxthumb://type=Asset&id=16371235025&w=150&h=150", price = 0, lastupdated = 1708496660, sort = {} },

	{ name = "Chicken Dance", id = 4849493309, icon = "rbxthumb://type=Asset&id=4849493309&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "BLACKPINK Don't know what to do", id = 18855609889, icon = "rbxthumb://type=Asset&id=18855609889&w=150&h=150", price = 0, lastupdated = 1723090163, sort = {} },

	{ name = "Man City Scorpion Kick", id = 13694139364, icon = "rbxthumb://type=Asset&id=13694139364&w=150&h=150", price = 0, lastupdated = 1688061827, sort = {} },

	{ name = "Gashina - SUNMI", id = 9528294735, icon = "rbxthumb://type=Asset&id=9528294735&w=150&h=150", price = 0, lastupdated = 1651539455, sort = {} },

	{ name = "Fashion Spin", id = 130046968468383, icon = "rbxthumb://type=Asset&id=130046968468383&w=150&h=150", price = 0, lastupdated = 1732653968, sort = {} },

	{ name = "Country Line Dance - Lil Nas X (LNX)", id = 5915780563, icon = "rbxthumb://type=Asset&id=5915780563&w=150&h=150", price = 0, lastupdated = 1605561299, sort = {} },

	{ name = "Sandwich Dance", id = 4390121879, icon = "rbxthumb://type=Asset&id=4390121879&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "BLACKPINK LISA Money", id = 15679957363, icon = "rbxthumb://type=Asset&id=15679957363&w=150&h=150", price = 0, lastupdated = 1703004397, sort = {} },

	{ name = "Nicki Minaj That's That Super Bass Emote", id = 15571536896, icon = "rbxthumb://type=Asset&id=15571536896&w=150&h=150", price = 0, lastupdated = 1702052899, sort = {} },

	{ name = "Salute", id = 3360689775, icon = "rbxthumb://type=Asset&id=3360689775&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "Olympic Dismount", id = 18666650035, icon = "rbxthumb://type=Asset&id=18666650035&w=150&h=150", price = 0, lastupdated = 1722014387, sort = {} },

	{ name = "MANIAC - Stray Kids", id = 11309309359, icon = "rbxthumb://type=Asset&id=11309309359&w=150&h=150", price = 0, lastupdated = 1668458448, sort = {} },

	{ name = "BLACKPINK JISOO Flower", id = 15439454888, icon = "rbxthumb://type=Asset&id=15439454888&w=150&h=150", price = 0, lastupdated = 1701124495, sort = {} },

	{ name = "Man City Bicycle Kick", id = 13422286833, icon = "rbxthumb://type=Asset&id=13422286833&w=150&h=150", price = 0, lastupdated = 1684429651, sort = {} },

	{ name = "Man City Backflip", id = 13694140956, icon = "rbxthumb://type=Asset&id=13694140956&w=150&h=150", price = 0, lastupdated = 1688061856, sort = {} },

	{ name = "BLACKPINK Pink Venom - Straight to Ya Dome", id = 14548711723, icon = "rbxthumb://type=Asset&id=14548711723&w=150&h=150", price = 0, lastupdated = 1732579764, sort = {} },

	{ name = "BLACKPINK Pink Venom - I Bring the Pain Like…", id = 14548710952, icon = "rbxthumb://type=Asset&id=14548710952&w=150&h=150", price = 0, lastupdated = 1732579780, sort = {} },

	{ name = "Stadium", id = 3360686498, icon = "rbxthumb://type=Asset&id=3360686498&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "BLACKPINK ROSÉ On The Ground", id = 15679958535, icon = "rbxthumb://type=Asset&id=15679958535&w=150&h=150", price = 0, lastupdated = 1703004441, sort = {} },

	{ name = "Bunny Hop", id = 4646296016, icon = "rbxthumb://type=Asset&id=4646296016&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "BLACKPINK Shut Down - Part 1", id = 14901369589, icon = "rbxthumb://type=Asset&id=14901369589&w=150&h=150", price = 0, lastupdated = 1732579788, sort = {} },

	{ name = "BLACKPINK Kill This Love", id = 16181843366, icon = "rbxthumb://type=Asset&id=16181843366&w=150&h=150", price = 0, lastupdated = 1706724495, sort = {} },

	{ name = "SpongeBob Dance", id = 18443271885, icon = "rbxthumb://type=Asset&id=18443271885&w=150&h=150", price = 0, lastupdated = 1720722377, sort = {} },

	{ name = "Borock's Rage", id = 3236848555, icon = "rbxthumb://type=Asset&id=3236848555&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "The Conductor - George Ezra", id = 10370926562, icon = "rbxthumb://type=Asset&id=10370926562&w=150&h=150", price = 0, lastupdated = 1658879306, sort = {} },

	{ name = "Swag Walk", id = 10478377385, icon = "rbxthumb://type=Asset&id=10478377385&w=150&h=150", price = 0, lastupdated = 1659642405, sort = {} },

	{ name = "BLACKPINK Shut Down - Part 2", id = 14901371589, icon = "rbxthumb://type=Asset&id=14901371589&w=150&h=150", price = 0, lastupdated = 1732579772, sort = {} },

	{ name = "BLACKPINK Ice Cream", id = 16181840356, icon = "rbxthumb://type=Asset&id=16181840356&w=150&h=150", price = 0, lastupdated = 1706724478, sort = {} },

	{ name = "Superhero Reveal", id = 3696759798, icon = "rbxthumb://type=Asset&id=3696759798&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "BLACKPINK Pink Venom - Get em Get em Get em", id = 14548709888, icon = "rbxthumb://type=Asset&id=14548709888&w=150&h=150", price = 0, lastupdated = 1732579749, sort = {} },

	{ name = "NBA Monster Dunk", id = 82163305721376, icon = "rbxthumb://type=Asset&id=82163305721376&w=150&h=150", price = 0, lastupdated = 1739396236, sort = {} },

	{ name = "TWICE ABCD by Nayeon", id = 18933761755, icon = "rbxthumb://type=Asset&id=18933761755&w=150&h=150", price = 0, lastupdated = 1723561480, sort = {} },

	{ name = "BURBERRY LOLA ATTITUDE - NIMBUS", id = 10147924028, icon = "rbxthumb://type=Asset&id=10147924028&w=150&h=150", price = 0, lastupdated = 1657728069, sort = {} },

	{ name = "Ud'zal's Summoning", id = 3307604888, icon = "rbxthumb://type=Asset&id=3307604888&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "TWICE Pop by Nayeon", id = 13768975574, icon = "rbxthumb://type=Asset&id=13768975574&w=150&h=150", price = 0, lastupdated = 1687549777, sort = {} },

	{ name = "TWICE Set Me Free - Dance 1", id = 12715395038, icon = "rbxthumb://type=Asset&id=12715395038&w=150&h=150", price = 0, lastupdated = 1678474186, sort = {} },

	{ name = "TWICE Set Me Free - Dance 2", id = 12715397488, icon = "rbxthumb://type=Asset&id=12715397488&w=150&h=150", price = 0, lastupdated = 1678474350, sort = {} },

	{ name = "Hyperfast 5G Dance Move", id = 9408642191, icon = "rbxthumb://type=Asset&id=9408642191&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "You can't sit with us - Sunmi", id = 9983549160, icon = "rbxthumb://type=Asset&id=9983549160&w=150&h=150", price = 0, lastupdated = 1657679637, sort = {} },

	{ name = "Hype Dance", id = 3696757129, icon = "rbxthumb://type=Asset&id=3696757129&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "BLACKPINK - How You Like That", id = 16874596971, icon = "rbxthumb://type=Asset&id=16874596971&w=150&h=150", price = 0, lastupdated = 1711414303, sort = {} },

	{ name = "BLACKPINK - Lovesick Girls", id = 16874600526, icon = "rbxthumb://type=Asset&id=16874600526&w=150&h=150", price = 0, lastupdated = 1711414329, sort = {} },

	{ name = "TWICE Like Ooh-Ahh", id = 14124050904, icon = "rbxthumb://type=Asset&id=14124050904&w=150&h=150", price = 0, lastupdated = 1689868872, sort = {} },

	{ name = "Heisman Pose", id = 3696763549, icon = "rbxthumb://type=Asset&id=3696763549&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "BLACKPINK As If It's Your Last", id = 18855603653, icon = "rbxthumb://type=Asset&id=18855603653&w=150&h=150", price = 0, lastupdated = 1723090177, sort = {} },

	{ name = "TWICE Moonlight Sunrise ", id = 12715393154, icon = "rbxthumb://type=Asset&id=12715393154&w=150&h=150", price = 0, lastupdated = 1678474249, sort = {} },

	{ name = "TWICE Fancy", id = 13520623514, icon = "rbxthumb://type=Asset&id=13520623514&w=150&h=150", price = 0, lastupdated = 1685112803, sort = {} },

	{ name = "Point2", id = 3576823880, icon = "rbxthumb://type=Asset&id=3576823880&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "BURBERRY LOLA ATTITUDE - GEM", id = 10147916560, icon = "rbxthumb://type=Asset&id=10147916560&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "Vroom Vroom", id = 18526410572, icon = "rbxthumb://type=Asset&id=18526410572&w=150&h=150", price = 0, lastupdated = 1721931643, sort = {} },

	{ name = "Hwaiting (화이팅)", id = 9528291779, icon = "rbxthumb://type=Asset&id=9528291779&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "BLACKPINK JENNIE You and Me", id = 15439457146, icon = "rbxthumb://type=Asset&id=15439457146&w=150&h=150", price = 0, lastupdated = 1701124471, sort = {} },

	{ name = "Tilt", id = 3360692915, icon = "rbxthumb://type=Asset&id=3360692915&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "Applaud", id = 5915779043, icon = "rbxthumb://type=Asset&id=5915779043&w=150&h=150", price = 0, lastupdated = 1663264200, sort = {} },

	{ name = "BLACKPINK DDU-DU DDU-DU", id = 16553262614, icon = "rbxthumb://type=Asset&id=16553262614&w=150&h=150", price = 0, lastupdated = 1709100790, sort = {} },

	{ name = "BURBERRY LOLA ATTITUDE - HYDRO", id = 10147926081, icon = "rbxthumb://type=Asset&id=10147926081&w=150&h=150", price = 0, lastupdated = 1657814503, sort = {} },

	{ name = "BURBERRY LOLA ATTITUDE - REFLEX", id = 10147921916, icon = "rbxthumb://type=Asset&id=10147921916&w=150&h=150", price = 0, lastupdated = 1663281649, sort = {} },

	{ name = "Air Guitar", id = 3696761354, icon = "rbxthumb://type=Asset&id=3696761354&w=150&h=150", price = 0, lastupdated = 1663264200, sort = {} },

	{ name = "Annyeong (안녕)", id = 9528286240, icon = "rbxthumb://type=Asset&id=9528286240&w=150&h=150", price = 0, lastupdated = 1651539455, sort = {} },

	{ name = "BLACKPINK Boombayah Emote", id = 16553259683, icon = "rbxthumb://type=Asset&id=16553259683&w=150&h=150", price = 0, lastupdated = 1709339907, sort = {} },

	{ name = "Victory - 24kGoldn", id = 9178397781, icon = "rbxthumb://type=Asset&id=9178397781&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

	{ name = "Hello", id = 3576686446, icon = "rbxthumb://type=Asset&id=3576686446&w=150&h=150", price = 0, lastupdated = 1663281650, sort = {} },

	{ name = "Vans Ollie", id = 18305539673, icon = "rbxthumb://type=Asset&id=18305539673&w=150&h=150", price = 0, lastupdated = 1719938530, sort = {} },

	{ name = "TWICE Strategy", id = 106862678450011, icon = "rbxthumb://type=Asset&id=106862678450011&w=150&h=150", price = 0, lastupdated = 1734540744, sort = {} },

	{ name = "TWICE The Feels", id = 12874468267, icon = "rbxthumb://type=Asset&id=12874468267&w=150&h=150", price = 0, lastupdated = 1679673336, sort = {} },

	{ name = "TWICE What Is Love", id = 13344121112, icon = "rbxthumb://type=Asset&id=13344121112&w=150&h=150", price = 0, lastupdated = 1683906913, sort = {} },

	{ name = "Shrug", id = 3576968026, icon = "rbxthumb://type=Asset&id=3576968026&w=150&h=150", price = 0, lastupdated = 1663281651, sort = {} },

}





local function addEmote(name, id, price, date)
    local months = {
        Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6,
        Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12
    }
    local function dateToUnix(d)
        local mon, day, year = d:match("(%a+)%s+(%d+),%s*(%d+)")
        return os.time({
            year = tonumber(year),
            month = months[mon],
            day = tonumber(day),
            hour = 0,
            min = 0,
            sec = 0
        })
    end
    
    table.insert(Emotes, {
        name = name,
        id = id,
        icon = "rbxthumb://type=Asset&id=" .. id .. "&w=150&h=150",
        price = price,
        lastupdated = dateToUnix(date),
        sort = {}
    })
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
addEmote("Addendum Dance [R6]", 134442882516163, 39, "Aug 09, 2025")
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
addEmote("Yapping Yap Yap Gesture",119870339321091, 39, "Aug 16, 2025")
addEmote("Luxurious / Springtrap",132151459316300 , 39, "Aug 16, 2025")
addEmote("Hand Drill",103882178542598 , 39, "Aug 16, 2025")
addEmote("exclamation",82714556886471 , 39, "Aug 16, 2025")
addEmote("Mewing / Mogging",135493514352956 , 39, "Aug 16, 2025")
addEmote("lemon melon cookie - Miku",79874689836683 , 39, "Aug 16, 2025")
addEmote("Cute Jump",80556794144838, 39, "Aug 16, 2025")
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
addEmote("Rambunctious", 108128682361404, 0, "Jan 01, 2024")
addEmote("Moon Walk", 79127989560307, 0, "Jan 01, 2024")
addEmote("[Original] It's Gangnam Style!", 104142334418357, 0, "Jan 01, 2024")
addEmote("/e fly", 93511411593120, 0, "Jan 01, 2024")
addEmote("Onion", 123015710605336, 0, "Jan 01, 2024")
addEmote("Caramell", 85936805522788, 0, "Jan 01, 2024")
addEmote("Deltarune - Tenna Dance", 102492229412911, 0, "Jan 01, 2024")
addEmote("Cute crouch ", 120224229260879, 0, "Jan 01, 2024")
addEmote("Garry's Dance", 92853367837757, 0, "Jan 01, 2024")
addEmote("Make You Mine", 104485625389237, 0, "Jan 01, 2024")
addEmote("Phut On", 139830733782518, 0, "Jan 01, 2024")
addEmote("Tank Transformation", 132382355371060, 0, "Jan 01, 2024")
addEmote("Scenario - LOVE SCENARIO", 103046131635200, 0, "Jan 01, 2024")
addEmote("Shattered", 124305244640379, 0, "Jan 01, 2024")
addEmote("Caramell Dansen", 96557878503341, 0, "Jan 01, 2024")
addEmote("Dead", 139859849852362, 0, "Jan 01, 2024")
addEmote("Gangnam Style", 130998336536045, 0, "Jan 01, 2024")
addEmote("Popular", 71302743123422, 0, "Jan 01, 2024")
addEmote("2 Phut Hon Dance", 115319301809339, 0, "Jan 01, 2024")
addEmote("griddy", 129149402922241, 0, "Jan 01, 2024")
addEmote("Gangnam Style", 113547795536875, 0, "Jan 01, 2024")
addEmote("Sit", 126614732606871, 0, "Jan 01, 2024")
addEmote("Teto Territory", 97263450325496, 0, "Jan 01, 2024")
addEmote("Electro Swing", 105851216004006, 0, "Jan 01, 2024")
addEmote("Floating", 70615023659736, 0, "Jan 01, 2024")
addEmote("/e hidden animation", 136740085081295, 0, "Jan 01, 2024")
addEmote("No-Clip/Speed Glitch", 87141651594092, 0, "Jan 01, 2024")
addEmote("rolling crybaby", 130726889233022, 0, "Jan 01, 2024")
addEmote("peter griffin death pose", 120437019363089, 0, "Jan 01, 2024")
addEmote("Proud to be Expendable - Pressure", 90608224567833, 0, "Jan 01, 2024")
addEmote("Default Dance", 99818263438846, 0, "Jan 01, 2024")
addEmote("Dani's Gangnam Style", 103197720369544, 0, "Jan 01, 2024")
addEmote("TV Time Dance", 75017857395637, 0, "Jan 01, 2024")
addEmote("Possessed", 102610758906338, 0, "Jan 01, 2024")
addEmote("Rat Dance", 95323795166399, 0, "Jan 01, 2024")
addEmote("Gangnam Style ", 127562607220778, 0, "Jan 01, 2024")
addEmote("Helicopter", 129132611803602, 0, "Jan 01, 2024")
addEmote("Dia Delicia Dance", 82345302788133, 0, "Jan 01, 2024")
addEmote("⌛ Best Mates EMOTE [LIMITED]", 113016438012253, 0, "Jan 01, 2024")
addEmote("[Aura Farm] Wall Lean Idle", 110537281410647, 0, "Jan 01, 2024")
addEmote("ILLIT - Magnetic", 92903522317071, 0, "Jan 01, 2024")
addEmote("It's TV Time!", 122899100558551, 0, "Jan 01, 2024")
addEmote("Rambunctious", 75528418031928, 0, "Jan 01, 2024")
addEmote("Gojo Floating", 103040723950430, 0, "Jan 01, 2024")
addEmote("Kickn around", 70788193750089, 0, "Jan 01, 2024")
addEmote("Jojo", 84195923658292, 0, "Jan 01, 2024")
addEmote("[⌛ Limited]  HEADLESS EMOTE ", 110731335896907, 0, "Jan 01, 2024")
addEmote("Hip Bounce", 139271706064778, 0, "Jan 01, 2024")
addEmote("ONCE HOP HOP!", 104304182344567, 0, "Jan 01, 2024")
addEmote("Pickle Rick Dance", 84067050907557, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 86982022610765, 0, "Jan 01, 2024")
addEmote("Im Talm Bout Innit", 117301403779781, 0, "Jan 01, 2024")
addEmote("Maraschino Step", 84822284410814, 0, "Jan 01, 2024")
addEmote("[NEW !] Caramelldansen Kawaii Dance", 97847706148165, 0, "Jan 01, 2024")
addEmote("Laying Down - Daydreaming", 89174456614428, 0, "Jan 01, 2024")
addEmote("OH WHO IS YOU", 91023138078288, 0, "Jan 01, 2024")
addEmote("Prince Of Egypt Dance / What You Want", 107978036345855, 0, "Jan 01, 2024")
addEmote("Golden Freddy Pose", 71363859760586, 0, "Jan 01, 2024")
addEmote("HEADLESS HOOPER", 80436375269036, 0, "Jan 01, 2024")
addEmote("Sit", 93262662842394, 0, "Jan 01, 2024")
addEmote("6 7 Transformation", 75703899901487, 0, "Jan 01, 2024")
addEmote("Death Pose", 99005087791705, 0, "Jan 01, 2024")
addEmote("💀MM2 Fake Dead", 132384701706046, 0, "Jan 01, 2024")
addEmote("Discombobulated", 129916107176034, 0, "Jan 01, 2024")
addEmote("Angry Stomp ", 88598010609888, 0, "Jan 01, 2024")
addEmote("xavier so based emote", 132508867759412, 0, "Jan 01, 2024")
addEmote("Hide", 121167704249654, 0, "Jan 01, 2024")
addEmote("Floating Human Spinner (LIMITED) ", 137873580964093, 0, "Jan 01, 2024")
addEmote("Belly Dance", 76700167742736, 0, "Jan 01, 2024")
addEmote("levitate", 87826892596287, 0, "Jan 01, 2024")
addEmote("Fake Dead (Troll Emote)", 70972410468289, 0, "Jan 01, 2024")
addEmote("IShowSpeed Dance", 109755476052324, 0, "Jan 01, 2024")
addEmote("Weird Spin", 89633087256727, 0, "Jan 01, 2024")
addEmote("Fake Death (BEST)", 125032357496729, 0, "Jan 01, 2024")
addEmote("Hug", 81177294287826, 0, "Jan 01, 2024")
addEmote("P.B.J.T.", 88721672617892, 0, "Jan 01, 2024")
addEmote("Xaviersobased Jig", 121259524934987, 0, "Jan 01, 2024")
addEmote("Macarena", 120377619472998, 0, "Jan 01, 2024")
addEmote("Torture Dance", 94663026124741, 0, "Jan 01, 2024")
addEmote("Get Sturdy", 120896030393583, 0, "Jan 01, 2024")
addEmote("Sponge Dance", 137261874619072, 0, "Jan 01, 2024")
addEmote("Plane", 119746055344304, 0, "Jan 01, 2024")
addEmote("Cute Laying Down", 78620443286892, 0, "Jan 01, 2024")
addEmote("📸 Pose for the Pic ", 108922782921118, 0, "Jan 01, 2024")
addEmote("Heart Hands Pose 3.0", 131221550165951, 0, "Jan 01, 2024")
addEmote("Caramel Hip Sway", 119454955259757, 0, "Jan 01, 2024")
addEmote("Griddy", 79752538807060, 0, "Jan 01, 2024")
addEmote("head spin", 140466682449054, 0, "Jan 01, 2024")
addEmote("Cute Sit", 96405718067779, 0, "Jan 01, 2024")
addEmote("Blue Shirt Guy Dancing", 89413575288931, 0, "Jan 01, 2024")
addEmote("Aura Farm", 112924687333965, 0, "Jan 01, 2024")
addEmote("Car Transformation", 100782362883099, 0, "Jan 01, 2024")
addEmote("Space Dance", 102323907950469, 0, "Jan 01, 2024")
addEmote("The Old Jitterbug", 110521067391235, 0, "Jan 01, 2024")
addEmote("Druski Shuffle", 111304332281521, 0, "Jan 01, 2024")
addEmote("🥤 Soda Pop - Saja Boys", 133600250245899, 0, "Jan 01, 2024")
addEmote("[Aura Farm] Sit Idle", 122949892043249, 0, "Jan 01, 2024")
addEmote("Jackpot Groove", 82739386299071, 0, "Jan 01, 2024")
addEmote("Dreamer", 80422524668416, 0, "Jan 01, 2024")
addEmote("Subject Three / AI Cat Chinese Dance", 97968838104258, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 85361710130557, 0, "Jan 01, 2024")
addEmote("Ishowspeed shake ", 74646784680842, 0, "Jan 01, 2024")
addEmote("Rat Dance", 98603994713783, 0, "Jan 01, 2024")
addEmote("Floating", 84052327668385, 0, "Jan 01, 2024")
addEmote("Spin my Head", 97999370392804, 0, "Jan 01, 2024")
addEmote("Rat Dance", 94319114655768, 0, "Jan 01, 2024")
addEmote("Mr. Ant Tennas Dance - DELTARUNE", 86849720336961, 0, "Jan 01, 2024")
addEmote("Die Lit!", 124754178569693, 0, "Jan 01, 2024")
addEmote("Helicopter", 80544397800234, 0, "Jan 01, 2024")
addEmote("MONSTER MASH", 100532972764499, 0, "Jan 01, 2024")
addEmote("What You Want", 88922397617835, 0, "Jan 01, 2024")
addEmote("Garry's Dance", 115810068374896, 0, "Jan 01, 2024")
addEmote("Human Snake", 75842745124834, 0, "Jan 01, 2024")
addEmote("Hakari Dance", 94451497143711, 0, "Jan 01, 2024")
addEmote("Fortnite Default Dance", 128972617664804, 0, "Jan 01, 2024")
addEmote("Saja Boy Pose - Jinu", 73556976257737, 0, "Jan 01, 2024")
addEmote("Griddy", 112949099442762, 0, "Jan 01, 2024")
addEmote(" Jinu Pose - Saja Boys", 130641944883645, 0, "Jan 01, 2024")
addEmote("Dep", 108474079699304, 0, "Jan 01, 2024")
addEmote("criss cross sit", 91423783304464, 0, "Jan 01, 2024")
addEmote("[⏳] Chill Sit", 90524692306889, 0, "Jan 01, 2024")
addEmote("GAG IT DEATH DROP", 134737246939931, 0, "Jan 01, 2024")
addEmote("Worm Dance", 71787387963141, 0, "Jan 01, 2024")
addEmote("I'm Going To Die Here - Pressure", 128658037413893, 0, "Jan 01, 2024")
addEmote("Relaxed Sit", 99568437064777, 0, "Jan 01, 2024")
addEmote("Stargazing", 83018514370428, 0, "Jan 01, 2024")
addEmote("Casual Sit", 94534169345613, 0, "Jan 01, 2024")
addEmote("Caramel dance", 140037329261678, 0, "Jan 01, 2024")
addEmote("Go Mufasa", 94118707925458, 0, "Jan 01, 2024")
addEmote("Koto Nai Meme Dance", 91927498467600, 0, "Jan 01, 2024")
addEmote("Hide Hidden Box Invisible Camo Emote Small tiny", 117450501566142, 0, "Jan 01, 2024")
addEmote("Oppa Gangnam Style", 88024974500195, 0, "Jan 01, 2024")
addEmote("Watching silly videos (Or texting)", 128792127841374, 0, "Jan 01, 2024")
addEmote("xavier so based dance", 87756443172440, 0, "Jan 01, 2024")
addEmote("BirdBrain Teto", 116770268279002, 0, "Jan 01, 2024")
addEmote("Kicking Feet And Blushing", 94121796810251, 0, "Jan 01, 2024")
addEmote("Hood Dance", 91945243106968, 0, "Jan 01, 2024")
addEmote("JUMP K-POP Dance Choreo", 111481711726876, 0, "Jan 01, 2024")
addEmote("Big Papa Squat", 114443541753616, 0, "Jan 01, 2024")
addEmote("Cursed Floating Rotating Head", 96927087453178, 0, "Jan 01, 2024")
addEmote("Cute Lie", 114695623925996, 0, "Jan 01, 2024")
addEmote("24 Hour Cinderella", 82407315928589, 0, "Jan 01, 2024")
addEmote("What You Want", 100576647621125, 0, "Jan 01, 2024")
addEmote("cute sit", 131875333242836, 0, "Jan 01, 2024")
addEmote("Otsukare Summer Dance", 79681561839536, 0, "Jan 01, 2024")
addEmote("[BEST] Orange Justice", 133160900449608, 0, "Jan 01, 2024")
addEmote("Cute Feet Kicks", 131643212415034, 0, "Jan 01, 2024")
addEmote("おつかれSUMMER DANCE", 138929851868463, 0, "Jan 01, 2024")
addEmote("[🎀CUTE] Kayah's Pose", 124031351335869, 0, "Jan 01, 2024")
addEmote("what happened bro", 137987340488409, 0, "Jan 01, 2024")
addEmote("[HOT] Caramelldansen", 119868674917432, 0, "Jan 01, 2024")
addEmote("Macarena", 101037410151868, 0, "Jan 01, 2024")
addEmote("Tenna's Cabbage Dance", 140406175549428, 0, "Jan 01, 2024")
addEmote("head walks away", 109664116234926, 0, "Jan 01, 2024")
addEmote("MM2 Sit Emote", 103323241937359, 0, "Jan 01, 2024")
addEmote("Head Banger", 81621254772462, 0, "Jan 01, 2024")
addEmote("Take The L Emote ✅", 98318652597666, 0, "Jan 01, 2024")
addEmote("Shy Cute Pose", 133999268647970, 0, "Jan 01, 2024")
addEmote("Im a mystery", 110833764398565, 0, "Jan 01, 2024")
addEmote("ISHOWSPEED DANCE", 82664964457620, 0, "Jan 01, 2024")
addEmote("♡ kawaii magical girl kpop idle pose", 126228947948058, 0, "Jan 01, 2024")
addEmote("Playing Dead", 131499177714385, 0, "Jan 01, 2024")
addEmote("🥤｡˚○ | Soda Pop Dance", 91749862405391, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii girly idle pose 2", 90831367043789, 0, "Jan 01, 2024")
addEmote("Griffin Fall", 82749804870046, 0, "Jan 01, 2024")
addEmote("Floating Relaxation ", 78085025505710, 0, "Jan 01, 2024")
addEmote("The Worm", 99563207397301, 0, "Jan 01, 2024")
addEmote("Cute Kpop Poses", 90929823390861, 0, "Jan 01, 2024")
addEmote("Candy Emote", 75773776265985, 0, "Jan 01, 2024")
addEmote("Snow angels", 135922662345048, 0, "Jan 01, 2024")
addEmote("Folding, Hide [Animated]", 124481227791432, 0, "Jan 01, 2024")
addEmote("Default Dance", 78792474294700, 0, "Jan 01, 2024")
addEmote("Take The L", 95926628409657, 0, "Jan 01, 2024")
addEmote("Elevation", 134928834792631, 0, "Jan 01, 2024")
addEmote("L Dance", 140333668677501, 0, "Jan 01, 2024")
addEmote("cat loaf", 70978791982917, 0, "Jan 01, 2024")
addEmote("Peter Griffin Pose (Family Guy Death Pose)", 134521545276284, 0, "Jan 01, 2024")
addEmote("Beat Da Koto Nai", 130655908439646, 0, "Jan 01, 2024")
addEmote("Proxima Creatura", 76503754262527, 0, "Jan 01, 2024")
addEmote("talmbout INNIT", 78164771288203, 0, "Jan 01, 2024")
addEmote("Torture Dance", 81780730637211, 0, "Jan 01, 2024")
addEmote("Falling back Death", 99565933541178, 0, "Jan 01, 2024")
addEmote("Popular", 76080208205057, 0, "Jan 01, 2024")
addEmote("Wall Lean", 88969192102242, 0, "Jan 01, 2024")
addEmote("Company Dance", 84061944625677, 0, "Jan 01, 2024")
addEmote("Skinwalker", 82761302670038, 0, "Jan 01, 2024")
addEmote("Macarena", 73946479113094, 0, "Jan 01, 2024")
addEmote("Bring it around", 77975534812454, 0, "Jan 01, 2024")
addEmote("Jackpot Dance", 81005824258133, 0, "Jan 01, 2024")
addEmote("Shimmer (ORIGINAL)", 114092281019046, 0, "Jan 01, 2024")
addEmote("Cat Dance", 85051384683771, 0, "Jan 01, 2024")
addEmote("Mr. Skier", 124664935927071, 0, "Jan 01, 2024")
addEmote("Honored One", 128800625861321, 0, "Jan 01, 2024")
addEmote("Caffeinated", 99453823712550, 0, "Jan 01, 2024")
addEmote("Snoop Dance", 107012521566800, 0, "Jan 01, 2024")
addEmote("Unemployment Dance", 96847244958186, 0, "Jan 01, 2024")
addEmote("Do That Thang", 98064631733787, 0, "Jan 01, 2024")
addEmote("Classic R6 Dance Potion", 90334065717691, 0, "Jan 01, 2024")
addEmote("Speed Try not to laugh", 101425980133974, 0, "Jan 01, 2024")
addEmote("[BEST] Caramell Dansen", 84306405425879, 0, "Jan 01, 2024")
addEmote("Rin", 78107150834426, 0, "Jan 01, 2024")
addEmote("Hide And Seek", 110932994930898, 0, "Jan 01, 2024")
addEmote("OOF", 89721517985713, 0, "Jan 01, 2024")
addEmote("Rat dance", 121838903053629, 0, "Jan 01, 2024")
addEmote("Whimsical Laying Down", 123282496097076, 0, "Jan 01, 2024")
addEmote("Classic Retro Jump", 119095524735341, 0, "Jan 01, 2024")
addEmote("Take The L", 110179881906079, 0, "Jan 01, 2024")
addEmote("Firework", 108099880348985, 0, "Jan 01, 2024")
addEmote("Arsenal: Parker Pride", 107300313701198, 0, "Jan 01, 2024")
addEmote("Head toss", 116838897398428, 0, "Jan 01, 2024")
addEmote("Monster mash emote R15", 76250099012024, 0, "Jan 01, 2024")
addEmote("JUMP - BP (KPOP)", 122404842843791, 0, "Jan 01, 2024")
addEmote("E Girl", 84932726570047, 0, "Jan 01, 2024")
addEmote("Dance If You're Peak", 138171891850624, 0, "Jan 01, 2024")
addEmote("Sturdy NYC Dance ", 122687759897103, 0, "Jan 01, 2024")
addEmote("chinese dance", 108408215437382, 0, "Jan 01, 2024")
addEmote("Macarena", 94618867444235, 0, "Jan 01, 2024")
addEmote("Mr \"ant\" Tenna's Kick - Deltarune", 71912700800803, 0, "Jan 01, 2024")
addEmote("Sit", 86588737455577, 0, "Jan 01, 2024")
addEmote("Rampage (Lonely Lonely)", 101397505086633, 0, "Jan 01, 2024")
addEmote("Girly Outfit-Check ", 115584191221260, 0, "Jan 01, 2024")
addEmote("Infinite R6 Backflips", 124970376117840, 0, "Jan 01, 2024")
addEmote("Push Up", 109763881381610, 0, "Jan 01, 2024")
addEmote("AI Cat Dance", 131987997650304, 0, "Jan 01, 2024")
addEmote("Gojo Honored One Floating Flying Toji Itadori Yuji", 85347533889715, 0, "Jan 01, 2024")
addEmote("Horror Slow Turn", 131873902790140, 0, "Jan 01, 2024")
addEmote("Miku Beam Emote", 135545153917736, 0, "Jan 01, 2024")
addEmote("Hugging Idle", 76904955984085, 0, "Jan 01, 2024")
addEmote("Play Dead Troll Trick Emote mm2", 89115363544461, 0, "Jan 01, 2024")
addEmote("Whip Nae Nae", 123955691598090, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 96045408942158, 0, "Jan 01, 2024")
addEmote("Scenario - Roblox", 128771561752851, 0, "Jan 01, 2024")
addEmote("Deactivated Sit", 125478215073174, 0, "Jan 01, 2024")
addEmote("Shuffling", 115925652377890, 0, "Jan 01, 2024")
addEmote("67 Transformation [NEW]", 96251764572550, 0, "Jan 01, 2024")
addEmote("Dougie Meme Dance", 119256963154827, 0, "Jan 01, 2024")
addEmote("sinking", 89227290900829, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 102348999290457, 0, "Jan 01, 2024")
addEmote("float", 104491001585941, 0, "Jan 01, 2024")
addEmote("/e dance2", 124072098165199, 0, "Jan 01, 2024")
addEmote("TENNA", 84624658497647, 0, "Jan 01, 2024")
addEmote("I Wanna Run Away", 129128109582733, 0, "Jan 01, 2024")
addEmote("Spongebob Shuffle", 115919902019037, 0, "Jan 01, 2024")
addEmote("Superman Emote", 85748580511408, 0, "Jan 01, 2024")
addEmote("Rat Dance", 124783960722552, 0, "Jan 01, 2024")
addEmote("Hug 🤗❤️", 102822553233176, 0, "Jan 01, 2024")
addEmote("[BEST] Caramell Dansen", 87275228219621, 0, "Jan 01, 2024")
addEmote("Jumpstyle Dance", 89614983665331, 0, "Jan 01, 2024")
addEmote("Worm", 127882676467351, 0, "Jan 01, 2024")
addEmote("Everybody Loves Me (Dougie)", 114756515400742, 0, "Jan 01, 2024")
addEmote("Penguin dance", 84881027922455, 0, "Jan 01, 2024")
addEmote("Folding", 79314952379576, 0, "Jan 01, 2024")
addEmote("Shadow DIO Jojo Pose", 119673857864183, 0, "Jan 01, 2024")
addEmote("2013 Dance", 110226648097430, 0, "Jan 01, 2024")
addEmote("Play Dead", 135564949884122, 0, "Jan 01, 2024")
addEmote("Levitating", 107585922448809, 0, "Jan 01, 2024")
addEmote("Animatronic Jumpscare 🐻🐰🐔🦊", 126485791512520, 0, "Jan 01, 2024")
addEmote("Jelly Dance!", 131421601916582, 0, "Jan 01, 2024")
addEmote("Druski Dance", 92376846011129, 0, "Jan 01, 2024")
addEmote("Family Guy Death", 108515849894347, 0, "Jan 01, 2024")
addEmote("♡ Cute Wave Pose ♡", 102370555981017, 0, "Jan 01, 2024")
addEmote("JELLYOUS Step Dance", 75036900568119, 0, "Jan 01, 2024")
addEmote("Hug", 113455609109484, 0, "Jan 01, 2024")
addEmote("Monster Mash", 122241742551119, 0, "Jan 01, 2024")
addEmote("Alone Sad Sit ", 122738273085390, 0, "Jan 01, 2024")
addEmote("Invisible", 97102348463163, 0, "Jan 01, 2024")
addEmote("Takedown", 118729994124535, 0, "Jan 01, 2024")
addEmote("STURDY", 120302905807132, 0, "Jan 01, 2024")
addEmote("Contort", 101655341443738, 0, "Jan 01, 2024")
addEmote("headpet", 89968618726000, 0, "Jan 01, 2024")
addEmote("Car Animation", 134912081679730, 0, "Jan 01, 2024")
addEmote("Saja Boys - Soda Pop", 125650734535029, 0, "Jan 01, 2024")
addEmote("Friendly Crouch Emote", 131724539637653, 0, "Jan 01, 2024")
addEmote("Druski Dance", 137271629569769, 0, "Jan 01, 2024")
addEmote("Silly Rest Animation", 130199646045694, 0, "Jan 01, 2024")
addEmote("Kawaii Dance", 136227069460494, 0, "Jan 01, 2024")
addEmote("Pushup", 93738573538058, 0, "Jan 01, 2024")
addEmote("Tail Wag", 111458350944165, 0, "Jan 01, 2024")
addEmote("Silly Cat AI Dance", 103463979134756, 0, "Jan 01, 2024")
addEmote("Lord X - I Miss The Quiet", 133152734782309, 0, "Jan 01, 2024")
addEmote("The Worm Emote", 102075861555461, 0, "Jan 01, 2024")
addEmote("Confess Dance", 81671884508244, 0, "Jan 01, 2024")
addEmote("Dance if You're Peak🕺", 114715429199895, 0, "Jan 01, 2024")
addEmote("/e dance1", 122117255044047, 0, "Jan 01, 2024")
addEmote("Tell Me Dance - Wonder Girls ", 128802284955903, 0, "Jan 01, 2024")
addEmote("Jellyous - Illit | Kpop Dance", 107082340537189, 0, "Jan 01, 2024")
addEmote("Deltarune Hip Shop", 123525328389185, 0, "Jan 01, 2024")
addEmote("sit", 78432587555168, 0, "Jan 01, 2024")
addEmote("Kawaii Kicking Legs", 124284624810032, 0, "Jan 01, 2024")
addEmote("Touhou Chirumiru", 100113161020168, 0, "Jan 01, 2024")
addEmote("Take The L", 73593666217037, 0, "Jan 01, 2024")
addEmote("Lonely Dance", 120536224720146, 0, "Jan 01, 2024")
addEmote("Gojo Levitate", 109572304000648, 0, "Jan 01, 2024")
addEmote("Locked In", 132031811973422, 0, "Jan 01, 2024")
addEmote("Blaze Spin", 104206611396634, 0, "Jan 01, 2024")
addEmote("drone", 110526195609302, 0, "Jan 01, 2024")
addEmote("Hair Toss", 90638843981281, 0, "Jan 01, 2024")
addEmote("Rat Dance!", 106873371348612, 0, "Jan 01, 2024")
addEmote("Sleeping", 111220691268309, 0, "Jan 01, 2024")
addEmote("Circus Head Balance", 126987957251462, 0, "Jan 01, 2024")
addEmote("MM2 Headless Emote", 125608243857862, 0, "Jan 01, 2024")
addEmote("Model Waiting Idle", 104063186482642, 0, "Jan 01, 2024")
addEmote("Andy's Coming!", 77935599895175, 0, "Jan 01, 2024")
addEmote("Curled Up Sit", 128304380307036, 0, "Jan 01, 2024")
addEmote("Headlock", 132414237338543, 0, "Jan 01, 2024")
addEmote("/e dance 2013 ", 105957314997150, 0, "Jan 01, 2024")
addEmote("Zen (MM2)", 76095183942765, 0, "Jan 01, 2024")
addEmote("Griddy", 70380575572008, 0, "Jan 01, 2024")
addEmote("Packaged", 100708682907084, 0, "Jan 01, 2024")
addEmote("Flying Helicopter", 115411666488357, 0, "Jan 01, 2024")
addEmote("Griddy", 101706709936834, 0, "Jan 01, 2024")
addEmote("Saja Boys - Soda Pop", 88398357963696, 0, "Jan 01, 2024")
addEmote("Walter's Reaction", 123098778062901, 0, "Jan 01, 2024")
addEmote("Andy's Blue Shirt Dance", 92258642491902, 0, "Jan 01, 2024")
addEmote("Around the World", 114945252132705, 0, "Jan 01, 2024")
addEmote("HAKARI DANCE", 132593821491008, 0, "Jan 01, 2024")
addEmote("Iconic Lay", 140160851481660, 0, "Jan 01, 2024")
addEmote("67", 78009699867177, 0, "Jan 01, 2024")
addEmote("MM2 Zen Emote", 102596825732373, 0, "Jan 01, 2024")
addEmote("Default Dance", 81958729909618, 0, "Jan 01, 2024")
addEmote("got me kicking my feet in the air chill sit", 111530990006064, 0, "Jan 01, 2024")
addEmote("Fake Death Pose 1", 88125174734309, 0, "Jan 01, 2024")
addEmote("Chill Sit", 105370785868536, 0, "Jan 01, 2024")
addEmote("Family Guy \"oof\" Pose", 95732629932363, 0, "Jan 01, 2024")
addEmote("Fake Dead", 105033930313087, 0, "Jan 01, 2024")
addEmote("Sturdy Dance", 85608190427964, 0, "Jan 01, 2024")
addEmote("Thriller", 85169458046509, 0, "Jan 01, 2024")
addEmote("Aura Farming", 133113167814737, 0, "Jan 01, 2024")
addEmote("Pose 28", 95838285527052, 0, "Jan 01, 2024")
addEmote("Basketball Head Spin", 107299223712510, 0, "Jan 01, 2024")
addEmote("R15 run (Fake lag)", 100297498958164, 0, "Jan 01, 2024")
addEmote("Fake Death (Troll)", 108759049195603, 0, "Jan 01, 2024")
addEmote("⌛ [Limited] Headless Emote ", 134071732994313, 0, "Jan 01, 2024")
addEmote("🍃 Relax Sitting", 76798144984399, 0, "Jan 01, 2024")
addEmote("Headspin", 109747189853899, 0, "Jan 01, 2024")
addEmote("Human Gun", 102531713386788, 0, "Jan 01, 2024")
addEmote("Electro Swing", 92016245582796, 0, "Jan 01, 2024")
addEmote("Aura Sit", 136914725915863, 0, "Jan 01, 2024")
addEmote("Cute", 90960391618876, 0, "Jan 01, 2024")
addEmote("Vegetable Dance", 80659943987339, 0, "Jan 01, 2024")
addEmote("Corrupted Entity", 104321872987170, 0, "Jan 01, 2024")
addEmote("Flying Head Glitch", 99033587367752, 0, "Jan 01, 2024")
addEmote("Kicking Feet Emote", 129365081834801, 0, "Jan 01, 2024")
addEmote("⛄😇Snow angel", 130341818591295, 0, "Jan 01, 2024")
addEmote("Spinning", 93777414456517, 0, "Jan 01, 2024")
addEmote("Explosive Bark", 134898183859788, 0, "Jan 01, 2024")
addEmote("Floating", 139058906415119, 0, "Jan 01, 2024")
addEmote("Orange Justice", 87629170042137, 0, "Jan 01, 2024")
addEmote("Upside Down Hanging", 121303504693693, 0, "Jan 01, 2024")
addEmote("Sit", 101743582461626, 0, "Jan 01, 2024")
addEmote("cat cleaning", 95300714212921, 0, "Jan 01, 2024")
addEmote("Laying Down", 86676584790347, 0, "Jan 01, 2024")
addEmote("Menacing Vampire", 116665722283847, 0, "Jan 01, 2024")
addEmote("Static Hatsune Miku", 120694986087334, 0, "Jan 01, 2024")
addEmote("Floating Relaxed", 121066336114466, 0, "Jan 01, 2024")
addEmote("Side Step", 90928199211879, 0, "Jan 01, 2024")
addEmote("Caramell Dance", 133290706719218, 0, "Jan 01, 2024")
addEmote("How You Like That KPop", 107123910784384, 0, "Jan 01, 2024")
addEmote("hmph! pouting", 98261665240055, 0, "Jan 01, 2024")
addEmote("Basketball Head Dribble", 95938106134169, 0, "Jan 01, 2024")
addEmote("Popular Vibe", 84439193655671, 0, "Jan 01, 2024")
addEmote("Popularity", 122211769878169, 0, "Jan 01, 2024")
addEmote("Super Sonic ", 132602449607962, 0, "Jan 01, 2024")
addEmote("Druski Dance", 124361134174082, 0, "Jan 01, 2024")
addEmote("lie down levitation", 81752296152717, 0, "Jan 01, 2024")
addEmote("Salsa Shuffle", 100319995972885, 0, "Jan 01, 2024")
addEmote("Jabba Switchway", 130772845072136, 0, "Jan 01, 2024")
addEmote("Red Flavor Kpop Choreo", 102134421623467, 0, "Jan 01, 2024")
addEmote("The Run Around", 88834614877886, 0, "Jan 01, 2024")
addEmote("Building Back Up", 114829405776021, 0, "Jan 01, 2024")
addEmote("Shy sit", 90418369153054, 0, "Jan 01, 2024")
addEmote("Animated Fake Death", 108709786297341, 0, "Jan 01, 2024")
addEmote("Cute Ostukare Summer", 97680948715657, 0, "Jan 01, 2024")
addEmote("Say So", 85599022914880, 0, "Jan 01, 2024")
addEmote("Levitating", 74525507319582, 0, "Jan 01, 2024")
addEmote("hide", 79907707913769, 0, "Jan 01, 2024")
addEmote("Feelin' Cute ", 120616295001236, 0, "Jan 01, 2024")
addEmote("Friday Funk", 110568614907294, 0, "Jan 01, 2024")
addEmote("/e dance3", 112820395289785, 0, "Jan 01, 2024")
addEmote(" Blue Shirt Guy", 81045684456123, 0, "Jan 01, 2024")
addEmote("Sad Sit", 80144240019571, 0, "Jan 01, 2024")
addEmote("R6 Sitting Classic", 112121068852761, 0, "Jan 01, 2024")
addEmote("Cute Feet Kicking", 78993833641127, 0, "Jan 01, 2024")
addEmote("/e epic dance [⏳]", 114129849164140, 0, "Jan 01, 2024")
addEmote("Floating sitting ", 83186041767510, 0, "Jan 01, 2024")
addEmote("Take The L", 136991458173691, 0, "Jan 01, 2024")
addEmote("Han Solo", 129518041239052, 0, "Jan 01, 2024")
addEmote("Snow Angel", 136245370202570, 0, "Jan 01, 2024")
addEmote("Helicopter", 123275002792718, 0, "Jan 01, 2024")
addEmote("Hot Backflip ", 128779579295748, 0, "Jan 01, 2024")
addEmote("Japanese greeting bow", 88738094720907, 0, "Jan 01, 2024")
addEmote("Billy Bouncin", 112708855940282, 0, "Jan 01, 2024")
addEmote("MM2 Sit", 93870759476993, 0, "Jan 01, 2024")
addEmote("Fairy Fly Animation", 87111382267514, 0, "Jan 01, 2024")
addEmote("Yamcha Defeat", 98815823529140, 0, "Jan 01, 2024")
addEmote("Chill Sit", 132668925457202, 0, "Jan 01, 2024")
addEmote("DayDreaming", 95287623772532, 0, "Jan 01, 2024")
addEmote("Cute Pose - Profile Pose", 71709151401273, 0, "Jan 01, 2024")
addEmote("Korean Chicken Dance", 90774237362669, 0, "Jan 01, 2024")
addEmote("Interdimensional Breakdancing", 77123035565474, 0, "Jan 01, 2024")
addEmote("China dance emote", 108510354615694, 0, "Jan 01, 2024")
addEmote("Hood Dance 2", 82424654082141, 0, "Jan 01, 2024")
addEmote("PushUp", 104390496874805, 0, "Jan 01, 2024")
addEmote("griddy", 108776997290935, 0, "Jan 01, 2024")
addEmote("Zen MM2 Emote", 71136284141200, 0, "Jan 01, 2024")
addEmote("the walk", 117738851054326, 0, "Jan 01, 2024")
addEmote("Take The L", 106711371603182, 0, "Jan 01, 2024")
addEmote("Fighting Stance", 136162554289402, 0, "Jan 01, 2024")
addEmote(" Sad Depressed Crying Sit / Sitting", 95339652051393, 0, "Jan 01, 2024")
addEmote("Dougie", 93675237485386, 0, "Jan 01, 2024")
addEmote("Crossarms", 81119661589122, 0, "Jan 01, 2024")
addEmote("Lay on Face", 134984552283077, 0, "Jan 01, 2024")
addEmote("Cute Sit", 72054495779747, 0, "Jan 01, 2024")
addEmote("Hidden Invisible Body Glitched Emote ✅", 76668656027928, 0, "Jan 01, 2024")
addEmote(":spin me", 80829371325436, 0, "Jan 01, 2024")
addEmote("Depressed Sit", 117145961689749, 0, "Jan 01, 2024")
addEmote("Crip Walk", 82345000649867, 0, "Jan 01, 2024")
addEmote("Roaring Knight DELTARUNE", 121345281331429, 0, "Jan 01, 2024")
addEmote("Garrys Dance", 70960148440574, 0, "Jan 01, 2024")
addEmote("[🎀CUTE] Toesies", 103544183787174, 0, "Jan 01, 2024")
addEmote("Minaj Stiletto Challenge", 110962488186848, 0, "Jan 01, 2024")
addEmote("Relaxed Sit", 93903979507056, 0, "Jan 01, 2024")
addEmote("Cutesy Profile Pose", 118913521478652, 0, "Jan 01, 2024")
addEmote("Cutesy Lay Down", 105263617496688, 0, "Jan 01, 2024")
addEmote("Lose Your Head", 71738794486531, 0, "Jan 01, 2024")
addEmote("Ride The Pony (ORIGINAL)", 133417254179183, 0, "Jan 01, 2024")
addEmote("Pats & Pets", 109300073879832, 0, "Jan 01, 2024")
addEmote("L Dance", 93829686572194, 0, "Jan 01, 2024")
addEmote("Levitated Lounge", 100081021028089, 0, "Jan 01, 2024")
addEmote("Cute Pose", 73998106231134, 0, "Jan 01, 2024")
addEmote("Relaxed Sit", 129884292496413, 0, "Jan 01, 2024")
addEmote("Scenario", 111901279618983, 0, "Jan 01, 2024")
addEmote("♡ ~ vampire princess idle", 78949019843685, 0, "Jan 01, 2024")
addEmote("Play Dead", 119905031885664, 0, "Jan 01, 2024")
addEmote("Pose for the Camera !!!", 127439660946486, 0, "Jan 01, 2024")
addEmote("/e sit", 92120288726557, 0, "Jan 01, 2024")
addEmote("02 Dance trend", 94341051549220, 0, "Jan 01, 2024")
addEmote("Sit", 120622104297893, 0, "Jan 01, 2024")
addEmote("Soda Pop Demon Dance", 136419441438548, 0, "Jan 01, 2024")
addEmote("Tweaker", 109297343168114, 0, "Jan 01, 2024")
addEmote("Cute Laid Legs Kicking", 77399834026056, 0, "Jan 01, 2024")
addEmote("Ride the Pony", 83733151910269, 0, "Jan 01, 2024")
addEmote("Bhangra Dance", 93968837624319, 0, "Jan 01, 2024")
addEmote("Floating Item", 117609375743036, 0, "Jan 01, 2024")
addEmote("Immortality Cultivator Meditation", 119030831418253, 0, "Jan 01, 2024")
addEmote("Cute Heart Pose", 107473897055619, 0, "Jan 01, 2024")
addEmote("Fantasy Feet", 120645783243861, 0, "Jan 01, 2024")
addEmote("Billy Bounce", 115444596282608, 0, "Jan 01, 2024")
addEmote("Levitating Sit", 86704411577730, 0, "Jan 01, 2024")
addEmote("Default Dance", 116946092067772, 0, "Jan 01, 2024")
addEmote("Macarena", 109417173715464, 0, "Jan 01, 2024")
addEmote("Classic R6 Sit", 129110288248645, 0, "Jan 01, 2024")
addEmote("Default Dance", 91817821197452, 0, "Jan 01, 2024")
addEmote("PB & J", 93471342782066, 0, "Jan 01, 2024")
addEmote("Floating Head Spinning Portal", 114560694139962, 0, "Jan 01, 2024")
addEmote("Spongebob Shuffle 🧽", 74374155705537, 0, "Jan 01, 2024")
addEmote("Silly Sit Spin", 129646368643979, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii girly idle pose 1", 109019084680469, 0, "Jan 01, 2024")
addEmote("Rat Dance Meme", 79460913196046, 0, "Jan 01, 2024")
addEmote("Phut Hon Hip Dance", 123509995733480, 0, "Jan 01, 2024")
addEmote("Thanos Mingle Dance - Squid Game", 118244276616379, 0, "Jan 01, 2024")
addEmote("dance2 R6", 134859909130355, 0, "Jan 01, 2024")
addEmote("Andy's Oh Who Is You", 79017838826757, 0, "Jan 01, 2024")
addEmote("Wally West Pose", 73394913763818, 0, "Jan 01, 2024")
addEmote("Woo Walk", 81046473188216, 0, "Jan 01, 2024")
addEmote("Pose 28", 96713654903032, 0, "Jan 01, 2024")
addEmote("Bird", 124636504502331, 0, "Jan 01, 2024")
addEmote("rollie ", 124522011862575, 0, "Jan 01, 2024")
addEmote("Sit Depressed", 91695115886964, 0, "Jan 01, 2024")
addEmote("CIRCUS IN THE SKY", 131726032766729, 0, "Jan 01, 2024")
addEmote("Get Sturdy Revamp", 114539386088263, 0, "Jan 01, 2024")
addEmote("R6 Sit", 82003739769858, 0, "Jan 01, 2024")
addEmote("One Hand Push Up", 86106484612825, 0, "Jan 01, 2024")
addEmote("Jabba Switchaway", 81074563419184, 0, "Jan 01, 2024")
addEmote("Flying Superhero ", 134861929761233, 0, "Jan 01, 2024")
addEmote("Instant 180° Flip", 128011595312625, 0, "Jan 01, 2024")
addEmote("Cute Anime Dance", 137672653673059, 0, "Jan 01, 2024")
addEmote("Haunted Spare Parts", 98221876584229, 0, "Jan 01, 2024")
addEmote("Sitting Down", 80384978884234, 0, "Jan 01, 2024")
addEmote("Druski Dance", 118388524393240, 0, "Jan 01, 2024")
addEmote("Aura emote", 108690398745615, 0, "Jan 01, 2024")
addEmote("Classic Car", 103662526275016, 0, "Jan 01, 2024")
addEmote("Creature", 120147525269613, 0, "Jan 01, 2024")
addEmote("Penguin Iceberg Shuffle", 94177618177661, 0, "Jan 01, 2024")
addEmote("Peanut Butter Jelly Time (R15)", 128893142111054, 0, "Jan 01, 2024")
addEmote("Get Griddy", 94826765103324, 0, "Jan 01, 2024")
addEmote("Fashion Model Pose Spin", 89014870839642, 0, "Jan 01, 2024")
addEmote("Scenario", 116390341517359, 0, "Jan 01, 2024")
addEmote("Sunflower - Zombies On Your Lawn", 74206806848577, 0, "Jan 01, 2024")
addEmote("Speedy", 125623825085795, 0, "Jan 01, 2024")
addEmote("Slip N' Slide", 113571015109107, 0, "Jan 01, 2024")
addEmote("Silent Anger", 112671387660656, 0, "Jan 01, 2024")
addEmote("Gangnam Style", 77780996762045, 0, "Jan 01, 2024")
addEmote("Zero Gravity Shattering", 111679706035551, 0, "Jan 01, 2024")
addEmote("Diva Runway Catwalk", 93829190507289, 0, "Jan 01, 2024")
addEmote("Snoop's Walk", 112458012124991, 0, "Jan 01, 2024")
addEmote("intimidating slide", 102282575857491, 0, "Jan 01, 2024")
addEmote("Flying Bird", 89543481489067, 0, "Jan 01, 2024")
addEmote("Beat Da Kotonai", 103547741685910, 0, "Jan 01, 2024")
addEmote("Griddy", 106715239721951, 0, "Jan 01, 2024")
addEmote("Sans UNDERTALE (Sprite Accurate)", 81021771707988, 0, "Jan 01, 2024")
addEmote("Squat Kick Dance", 131278934948544, 0, "Jan 01, 2024")
addEmote("Phut Hon ZeroTwo", 110835051438795, 0, "Jan 01, 2024")
addEmote("Discombobulated Wiggle", 123084211047054, 0, "Jan 01, 2024")
addEmote("AURA Wall Lean Idle", 125981188999661, 0, "Jan 01, 2024")
addEmote("Push Up 💪", 98401523334482, 0, "Jan 01, 2024")
addEmote("Flippin McCool", 139657570966300, 0, "Jan 01, 2024")
addEmote("Low bow Emote (Limited!)", 88633941508826, 0, "Jan 01, 2024")
addEmote("Cutesy Sitting Pose", 85845857592424, 0, "Jan 01, 2024")
addEmote("Head Gift - Animation", 78248081330604, 0, "Jan 01, 2024")
addEmote("Wally West", 123105264683590, 0, "Jan 01, 2024")
addEmote("[20% OFF!] Diva Trend Dance - EMOVA", 113235959868929, 0, "Jan 01, 2024")
addEmote("F1 Racecar", 90647613676431, 0, "Jan 01, 2024")
addEmote("Saiyan Walk", 98120534063281, 0, "Jan 01, 2024")
addEmote("Boo Thing", 104891288225055, 0, "Jan 01, 2024")
addEmote("Do It Left Do It Right", 135763292953782, 0, "Jan 01, 2024")
addEmote("Miss The Quiet [BEST]", 136936175263593, 0, "Jan 01, 2024")
addEmote("Orange Justice", 97045997772923, 0, "Jan 01, 2024")
addEmote("Head Roll", 87458964172227, 0, "Jan 01, 2024")
addEmote("Chilling", 76754578230348, 0, "Jan 01, 2024")
addEmote("Classic Sit ", 104165684983914, 0, "Jan 01, 2024")
addEmote("Play Dead", 95905660853535, 0, "Jan 01, 2024")
addEmote("Exorcism", 132635230507772, 0, "Jan 01, 2024")
addEmote("Wave", 93620702247417, 0, "Jan 01, 2024")
addEmote("Roaring Knight Deltarune IDLE (BETTER VERSION)", 107225120695886, 0, "Jan 01, 2024")
addEmote("💀 Fake Death MM2 Trolling ", 127058223933069, 0, "Jan 01, 2024")
addEmote("Love Hate Dance", 105959744896663, 0, "Jan 01, 2024")
addEmote("griddy", 100031612342600, 0, "Jan 01, 2024")
addEmote("Odyssey", 126069437165634, 0, "Jan 01, 2024")
addEmote("hiding", 83465000189935, 0, "Jan 01, 2024")
addEmote("Vilan Idle", 71166489923890, 0, "Jan 01, 2024")
addEmote("Aura Farming", 132569947289841, 0, "Jan 01, 2024")
addEmote("Smug", 78773506370628, 0, "Jan 01, 2024")
addEmote("I'm sat.", 87440858620113, 0, "Jan 01, 2024")
addEmote("Get Jiggy", 81298983417869, 0, "Jan 01, 2024")
addEmote("Assumptions Blue Shirt", 110535588920489, 0, "Jan 01, 2024")
addEmote("⏳[LIMITED] Hi Pose", 77847525794065, 0, "Jan 01, 2024")
addEmote("Spin", 89120984307039, 0, "Jan 01, 2024")
addEmote("Sitting", 140435963895367, 0, "Jan 01, 2024")
addEmote("The Crip Walk", 135644510792196, 0, "Jan 01, 2024")
addEmote("Fish Animation", 139403183178750, 0, "Jan 01, 2024")
addEmote("Chill Leg Cross Sit", 84684551359155, 0, "Jan 01, 2024")
addEmote("Stuck In Place", 123407495927344, 0, "Jan 01, 2024")
addEmote("Robloxian Helicopter! (FUNNY)", 108381529878396, 0, "Jan 01, 2024")
addEmote("Bouncing DVD Screensaver Classic", 138744663844242, 0, "Jan 01, 2024")
addEmote("Classic /e dance 2013", 88443724456532, 0, "Jan 01, 2024")
addEmote("Japanese Sit ", 112150504089416, 0, "Jan 01, 2024")
addEmote("ERROR", 85891978889580, 0, "Jan 01, 2024")
addEmote("Peter Pain", 123268767568740, 0, "Jan 01, 2024")
addEmote("💖 Cute Sit 💖 ", 96406780440488, 0, "Jan 01, 2024")
addEmote("Rat Dance", 112553206572593, 0, "Jan 01, 2024")
addEmote("Trendy Nicki Leg Pose", 92846015938931, 0, "Jan 01, 2024")
addEmote("Caramelldansen dance", 128185840424518, 0, "Jan 01, 2024")
addEmote("Lay", 133847045910443, 0, "Jan 01, 2024")
addEmote("LOL", 78199122665975, 0, "Jan 01, 2024")
addEmote("(Aura Farm) Handstand Pushup", 111918469246503, 0, "Jan 01, 2024")
addEmote("Otsukare Summer Dance", 127297129390567, 0, "Jan 01, 2024")
addEmote("Spongebob", 113036186850286, 0, "Jan 01, 2024")
addEmote("✅ Take The L Emote Sped Up ✅", 131821033642603, 0, "Jan 01, 2024")
addEmote("Magical Girl v1 [Flying]", 109777105517178, 0, "Jan 01, 2024")
addEmote("Everybody Loves Me (Dougie)", 113841393102239, 0, "Jan 01, 2024")
addEmote("Jumpstyle", 98754040888252, 0, "Jan 01, 2024")
addEmote("Floating In Space", 107923895478370, 0, "Jan 01, 2024")
addEmote("Touhou Hina Spin", 140168097524408, 0, "Jan 01, 2024")
addEmote("Warm hug", 102688787055697, 0, "Jan 01, 2024")
addEmote("Take The L ", 134825580538672, 0, "Jan 01, 2024")
addEmote("Crazy Air Spin", 136030942777883, 0, "Jan 01, 2024")
addEmote("Retro /e Dance", 80157450897510, 0, "Jan 01, 2024")
addEmote("Weird Spin 2", 139675183645978, 0, "Jan 01, 2024")
addEmote("Macarena Emote ✅", 122416394696289, 0, "Jan 01, 2024")
addEmote("Gon", 117043806735297, 0, "Jan 01, 2024")
addEmote("Retro Spin/Dance Tool", 138213548155901, 0, "Jan 01, 2024")
addEmote("The Worm", 87955697811902, 0, "Jan 01, 2024")
addEmote("Snow Angel", 82004281891216, 0, "Jan 01, 2024")
addEmote("Go Mufasa ", 102969703404968, 0, "Jan 01, 2024")
addEmote("Skipping", 78155330696606, 0, "Jan 01, 2024")
addEmote("Outfit View", 114915444133199, 0, "Jan 01, 2024")
addEmote("SIUU", 137282858118997, 0, "Jan 01, 2024")
addEmote("Classy", 123241974228701, 0, "Jan 01, 2024")
addEmote("Getting jiggy", 129702304069841, 0, "Jan 01, 2024")
addEmote("Sit", 72191221096013, 0, "Jan 01, 2024")
addEmote("Gun Transformation + Shooting", 135253072333106, 0, "Jan 01, 2024")
addEmote("Rambunctious", 100231701240052, 0, "Jan 01, 2024")
addEmote("Popular Vibe Dance", 104934807111638, 0, "Jan 01, 2024")
addEmote("⭐️ HELICOPTER", 107476481439242, 0, "Jan 01, 2024")
addEmote("OH YEA!", 115769285345982, 0, "Jan 01, 2024")
addEmote("Love Sign", 122623026395755, 0, "Jan 01, 2024")
addEmote("🔫 Gun Morph", 138946866858913, 0, "Jan 01, 2024")
addEmote("Roll", 99245053698139, 0, "Jan 01, 2024")
addEmote("Conquest", 73332973606418, 0, "Jan 01, 2024")
addEmote("Blow Kiss", 73990846892571, 0, "Jan 01, 2024")
addEmote("Nicki Minaj Pose", 104916602460299, 0, "Jan 01, 2024")
addEmote("Sit (MM2)", 116909481264292, 0, "Jan 01, 2024")
addEmote("Druski Crank Dat", 112349735441889, 0, "Jan 01, 2024")
addEmote("Silent Hill Nurse", 97560315899262, 0, "Jan 01, 2024")
addEmote("Sit", 127998433031434, 0, "Jan 01, 2024")
addEmote("Boy's a Liar", 118115683204335, 0, "Jan 01, 2024")
addEmote("Kazotsky Kick Dance", 75954155820284, 0, "Jan 01, 2024")
addEmote("Rizz Pose", 107890403470280, 0, "Jan 01, 2024")
addEmote("♡ [LOOP] cute sitting kicking feet emote", 92676668301699, 0, "Jan 01, 2024")
addEmote("Jackhammer", 133156019892327, 0, "Jan 01, 2024")
addEmote("GANGNAM STYLE", 128719021861443, 0, "Jan 01, 2024")
addEmote("Headflip", 140185130376422, 0, "Jan 01, 2024")
addEmote("kick n giggle", 96632355269853, 0, "Jan 01, 2024")
addEmote("I aint got no pants on dance", 118304558494693, 0, "Jan 01, 2024")
addEmote("Helicopter", 140547238892659, 0, "Jan 01, 2024")
addEmote("Dead", 116728536568950, 0, "Jan 01, 2024")
addEmote("Take The L", 109639716887832, 0, "Jan 01, 2024")
addEmote("praying", 128004594505261, 0, "Jan 01, 2024")
addEmote("Box Swing", 140509014658063, 0, "Jan 01, 2024")
addEmote("Rat Dance", 116416703003358, 0, "Jan 01, 2024")
addEmote("Jabba Switchaway", 97502008524120, 0, "Jan 01, 2024")
addEmote("Birdbrain Emote🐔", 132899021100548, 0, "Jan 01, 2024")
addEmote("Static Outmanic!", 130815556553873, 0, "Jan 01, 2024")
addEmote("Rollie Dance", 110827382619943, 0, "Jan 01, 2024")
addEmote("Dab", 121469443662693, 0, "Jan 01, 2024")
addEmote("giraffe", 140143347648362, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii hold my plushie... ! idle pose", 132352706877382, 0, "Jan 01, 2024")
addEmote("Take The L", 116522367399217, 0, "Jan 01, 2024")
addEmote("Crying", 90425743502387, 0, "Jan 01, 2024")
addEmote("Smug Dance", 110067764106480, 0, "Jan 01, 2024")
addEmote("Otsukare Summer ☀️", 93796458163488, 0, "Jan 01, 2024")
addEmote("Lay", 99766711630226, 0, "Jan 01, 2024")
addEmote("The Griddy", 138779856593589, 0, "Jan 01, 2024")
addEmote("aespa - Whiplash", 95861380714385, 0, "Jan 01, 2024")
addEmote("Fragmented", 123516013924276, 0, "Jan 01, 2024")
addEmote("The Chicken Nugget Dance", 118679993855133, 0, "Jan 01, 2024")
addEmote("Ride The Pony!", 137865090089996, 0, "Jan 01, 2024")
addEmote("Sit", 74435375782890, 0, "Jan 01, 2024")
addEmote("Admire", 118410457961703, 0, "Jan 01, 2024")
addEmote("Helicopter Meme spin 🚁", 92300395650613, 0, "Jan 01, 2024")
addEmote("Get Jiggy", 138030172409402, 0, "Jan 01, 2024")
addEmote("I Have The Power", 97955437622500, 0, "Jan 01, 2024")
addEmote("Pooping", 120426139200972, 0, "Jan 01, 2024")
addEmote("Astro Dance", 102814839657347, 0, "Jan 01, 2024")
addEmote("Get Griddy", 122740887243484, 0, "Jan 01, 2024")
addEmote("DJ Khaled Dance", 132885029786945, 0, "Jan 01, 2024")
addEmote("Crossed Legs Vibin Sit", 96573402798618, 0, "Jan 01, 2024")
addEmote("Jojo Pose Test", 140536066847994, 0, "Jan 01, 2024")
addEmote("Supermodel Fantasy (LOOP)", 73470392753674, 0, "Jan 01, 2024")
addEmote("my head gone bruh (headless)", 98193399505416, 0, "Jan 01, 2024")
addEmote("FREAKY FLOPPY WORM", 113312808145333, 0, "Jan 01, 2024")
addEmote("Joe Pose", 119266290026621, 0, "Jan 01, 2024")
addEmote("Luffy Second Gear", 90478640060356, 0, "Jan 01, 2024")
addEmote("Bike ", 77488869538841, 0, "Jan 01, 2024")
addEmote("Freaky Jumpscare", 97159207958280, 0, "Jan 01, 2024")
addEmote("Tuff [itoshi Rin]", 126068021063465, 0, "Jan 01, 2024")
addEmote("Spinning", 87587450444673, 0, "Jan 01, 2024")
addEmote("gwiddy", 135969054380167, 0, "Jan 01, 2024")
addEmote("Demonic Possession", 137646250335504, 0, "Jan 01, 2024")
addEmote("Neko Scratch", 74022705210142, 0, "Jan 01, 2024")
addEmote("Little Demon Exorcism", 91325819213930, 0, "Jan 01, 2024")
addEmote("Levitate Shatter Rotate", 74318414570029, 0, "Jan 01, 2024")
addEmote("Six Seven! (67)", 104649607521292, 0, "Jan 01, 2024")
addEmote("Engineer Dance", 118365750845245, 0, "Jan 01, 2024")
addEmote("Knightly Stance", 100700616516922, 0, "Jan 01, 2024")
addEmote("Mr. Ant Tennas Battle - DELTARUNE", 87084947602260, 0, "Jan 01, 2024")
addEmote("Basketball Head Dribble (left&right)", 118447146432576, 0, "Jan 01, 2024")
addEmote("Lay down glitch emote🤑", 139121423735400, 0, "Jan 01, 2024")
addEmote("smug dancin", 115306436976323, 0, "Jan 01, 2024")
addEmote("Head Shake", 129579733620258, 0, "Jan 01, 2024")
addEmote("Fake Run Lag", 104552918224011, 0, "Jan 01, 2024")
addEmote("Take the L", 114380999425365, 0, "Jan 01, 2024")
addEmote("Boogie Down", 123125237932854, 0, "Jan 01, 2024")
addEmote("Jojo Dio Pose", 76545568367601, 0, "Jan 01, 2024")
addEmote("HeadSpin", 102076956367441, 0, "Jan 01, 2024")
addEmote("Take The L", 133005847117851, 0, "Jan 01, 2024")
addEmote("The Honoured One (Gojo)", 129934497203769, 0, "Jan 01, 2024")
addEmote("Griddy [✅] ", 115502757897723, 0, "Jan 01, 2024")
addEmote("Rampage", 91811231498287, 0, "Jan 01, 2024")
addEmote("Default Dance", 83559276301867, 0, "Jan 01, 2024")
addEmote("Worm Dance", 132950274861655, 0, "Jan 01, 2024")
addEmote("Dying", 110009750068352, 0, "Jan 01, 2024")
addEmote("MM2 Headless Emote", 79928863970461, 0, "Jan 01, 2024")
addEmote("Princess kiss under the moonlight ♡", 139681015298158, 0, "Jan 01, 2024")
addEmote("Fake Dead Troll", 126302138178332, 0, "Jan 01, 2024")
addEmote("Hip Hop - Bop", 96183325107876, 0, "Jan 01, 2024")
addEmote("/e float", 77234582148139, 0, "Jan 01, 2024")
addEmote("Bizarre Dance", 138904082598629, 0, "Jan 01, 2024")
addEmote("Spinning Zen Yoga Pose", 127643942754639, 0, "Jan 01, 2024")
addEmote("Toprock Dance", 75670006412707, 0, "Jan 01, 2024")
addEmote("Da Hood Macro", 97888577750809, 0, "Jan 01, 2024")
addEmote("Migu", 123374576841498, 0, "Jan 01, 2024")
addEmote("Caffeinated", 114001572163832, 0, "Jan 01, 2024")
addEmote("Just Vibin' Dance", 135740020061537, 0, "Jan 01, 2024")
addEmote("Kitty Cat", 110407203358363, 0, "Jan 01, 2024")
addEmote("Dinnerbone", 126404410751441, 0, "Jan 01, 2024")
addEmote("Goat Dance", 94376665318956, 0, "Jan 01, 2024")
addEmote("Observant Sitting", 89420560138060, 0, "Jan 01, 2024")
addEmote("Mingle Dance [ Squid Game ]", 116376650217945, 0, "Jan 01, 2024")
addEmote("Take the W", 98751825568530, 0, "Jan 01, 2024")
addEmote("Rewrite Idle", 93292747769457, 0, "Jan 01, 2024")
addEmote("Cool Spin", 85362492536029, 0, "Jan 01, 2024")
addEmote("OFFICIAL HONORED ONE", 115141808329063, 0, "Jan 01, 2024")
addEmote("Take The L", 91280162000203, 0, "Jan 01, 2024")
addEmote("Bouncing Headless", 72059847540792, 0, "Jan 01, 2024")
addEmote("Fake Death", 120359706938440, 0, "Jan 01, 2024")
addEmote("Cute Girl Squat", 82151370935308, 0, "Jan 01, 2024")
addEmote("Blocky Crouch Jump", 119438952396414, 0, "Jan 01, 2024")
addEmote("Helicopter", 115080543751957, 0, "Jan 01, 2024")
addEmote("R6 Backflip", 73475641337651, 0, "Jan 01, 2024")
addEmote("L Dance", 130260688519268, 0, "Jan 01, 2024")
addEmote("Super Earth Salute", 80973196392401, 0, "Jan 01, 2024")
addEmote("Spiderman's Evil Dance", 96968555068754, 0, "Jan 01, 2024")
addEmote("Boogie Emote", 98205207941430, 0, "Jan 01, 2024")
addEmote("The Honored One", 97996450818876, 0, "Jan 01, 2024")
addEmote("Futebol de Cabeça", 103709181489605, 0, "Jan 01, 2024")
addEmote("Admin Dance", 132322435157678, 0, "Jan 01, 2024")
addEmote("Player 456 Fall", 119216965926731, 0, "Jan 01, 2024")
addEmote("Electric Angel", 77166149654675, 0, "Jan 01, 2024")
addEmote("Kita dance / Doodle Dance", 107330941192204, 0, "Jan 01, 2024")
addEmote("Helicopter Helicopter", 83809559049428, 0, "Jan 01, 2024")
addEmote("Hakari Dance Remastered R15", 88202198147922, 0, "Jan 01, 2024")
addEmote("Jugglehead", 139708452356331, 0, "Jan 01, 2024")
addEmote("2010 Classic Dance", 83356347458061, 0, "Jan 01, 2024")
addEmote("Wonderful Day for Pie", 97151170886466, 0, "Jan 01, 2024")
addEmote("Push Up", 130055095963705, 0, "Jan 01, 2024")
addEmote("I Just Wanna Rock / Get Sturdy", 131242989055598, 0, "Jan 01, 2024")
addEmote("Chill Floor Sit", 104555342633439, 0, "Jan 01, 2024")
addEmote("Spicy Life Dance", 106381695975693, 0, "Jan 01, 2024")
addEmote("Spongebob Shuffle🧽", 70811858807338, 0, "Jan 01, 2024")
addEmote("Im going crazy", 97161625230640, 0, "Jan 01, 2024")
addEmote("Boxify (Troll)", 109500204688576, 0, "Jan 01, 2024")
addEmote("Peanut Butter Jelly Time", 115883628797443, 0, "Jan 01, 2024")
addEmote("Rat Dance", 82285837400526, 0, "Jan 01, 2024")
addEmote("Rat dance", 102917457169467, 0, "Jan 01, 2024")
addEmote("Compressed", 130846510021578, 0, "Jan 01, 2024")
addEmote("Spinning", 74435627155065, 0, "Jan 01, 2024")
addEmote("Billy Bounce", 114790274109603, 0, "Jan 01, 2024")
addEmote("Joyful Jump", 122756345628791, 0, "Jan 01, 2024")
addEmote("Macarena", 86408375048761, 0, "Jan 01, 2024")
addEmote("Head Pat [Bundle/Matching/Duo]", 136489093136465, 0, "Jan 01, 2024")
addEmote("Peter Parker", 128589766828505, 0, "Jan 01, 2024")
addEmote("Mu Profile Pose", 75817748922762, 0, "Jan 01, 2024")
addEmote("Popular Vibe", 99782749331888, 0, "Jan 01, 2024")
addEmote("cool sit", 108668045601612, 0, "Jan 01, 2024")
addEmote("Breakdance", 76332513040721, 0, "Jan 01, 2024")
addEmote("Getting pats [Bundle/Matching/Duo]", 113236164765359, 0, "Jan 01, 2024")
addEmote("Goofy Sway", 122763219460340, 0, "Jan 01, 2024")
addEmote("Goofy Chicken Dance", 88705764492034, 0, "Jan 01, 2024")
addEmote("Mischievous Function", 108010590407956, 0, "Jan 01, 2024")
addEmote("Burn and ice", 91037041171855, 0, "Jan 01, 2024")
addEmote("Freddy Fazbear Stage Performance", 109304407588214, 0, "Jan 01, 2024")
addEmote("OH A RAT ", 88437776322553, 0, "Jan 01, 2024")
addEmote("Never Gonna - (Rick Roll)", 94960135681008, 0, "Jan 01, 2024")
addEmote("Vibey", 107557715852038, 0, "Jan 01, 2024")
addEmote("Capoeira", 120617840401424, 0, "Jan 01, 2024")
addEmote("Ragdoll Death Pose", 139351413969659, 0, "Jan 01, 2024")
addEmote("floating stare", 78957942093953, 0, "Jan 01, 2024")
addEmote("Joyful Jump", 130654870902211, 0, "Jan 01, 2024")
addEmote("TF2 Laughing (Demoman)", 98943918958782, 0, "Jan 01, 2024")
addEmote("ROLLIE", 124605833322882, 0, "Jan 01, 2024")
addEmote("I wanna Rollie", 97537006592057, 0, "Jan 01, 2024")
addEmote("Flip", 138120364313393, 0, "Jan 01, 2024")
addEmote("WoW", 110720144495202, 0, "Jan 01, 2024")
addEmote("Gojo Run", 80564851360892, 0, "Jan 01, 2024")
addEmote("Crybaby Tantrum Sit", 123756721005460, 0, "Jan 01, 2024")
addEmote("Play Dead", 137515797332664, 0, "Jan 01, 2024")
addEmote("Headless Horseman Head Toss", 124029773563065, 0, "Jan 01, 2024")
addEmote("Andy's Hakari (Lonely Lonely)", 72473645937395, 0, "Jan 01, 2024")
addEmote("SODA POP! - KPOP Demon Hunters", 117552763704832, 0, "Jan 01, 2024")
addEmote("Andy's DELICIA DANCE (DANCE IF YOU'RE PEAK)", 121231858727693, 0, "Jan 01, 2024")
addEmote("Spinning Top", 124778241398875, 0, "Jan 01, 2024")
addEmote("Smelly / You're Stinky!", 118214278778249, 0, "Jan 01, 2024")
addEmote("Deltarune Spin Action", 129953639906823, 0, "Jan 01, 2024")
addEmote("Classic Celebration", 83362515790472, 0, "Jan 01, 2024")
addEmote("Baby Tu Eres MALA dance", 88504681684408, 0, "Jan 01, 2024")
addEmote("no u", 112534953476344, 0, "Jan 01, 2024")
addEmote("Gon's Rage", 73561648394427, 0, "Jan 01, 2024")
addEmote("WIGGLE", 116288930106470, 0, "Jan 01, 2024")
addEmote("Kawaii Caramelldansen Dance", 87319540808191, 0, "Jan 01, 2024")
addEmote("Bring it around", 72779337007744, 0, "Jan 01, 2024")
addEmote("Gojo Hollow Purple", 89623728108712, 0, "Jan 01, 2024")
addEmote("Bizarre Jojo Pose", 88799212885495, 0, "Jan 01, 2024")
addEmote("Meditating", 106587392229504, 0, "Jan 01, 2024")
addEmote("HELLO Transformation", 74931167859088, 0, "Jan 01, 2024")
addEmote("Korean Greeting", 109969619039056, 0, "Jan 01, 2024")
addEmote("Classic Penguin Dance", 72323852254395, 0, "Jan 01, 2024")
addEmote("Chinese Cat Dance !", 104796070065311, 0, "Jan 01, 2024")
addEmote("Tenna seeing Spamton crashout", 124660959977138, 0, "Jan 01, 2024")
addEmote("[ R6 ] Floating Chilling", 85997349806865, 0, "Jan 01, 2024")
addEmote("Cute Sit", 71176955262462, 0, "Jan 01, 2024")
addEmote("SpiderMan Hanging Pose", 110511723808460, 0, "Jan 01, 2024")
addEmote("Plane Transformation", 80963031817715, 0, "Jan 01, 2024")
addEmote("Phut Hon Dance", 82566336345109, 0, "Jan 01, 2024")
addEmote("Clouds", 82395078099296, 0, "Jan 01, 2024")
addEmote("Fancy Man In Suit", 102708060056165, 0, "Jan 01, 2024")
addEmote("Hype Dance", 116713028797359, 0, "Jan 01, 2024")
addEmote("Chopper Dance", 118870859905794, 0, "Jan 01, 2024")
addEmote("Everybody do the Flop", 112768599000894, 0, "Jan 01, 2024")
addEmote("Goofy Spin", 76005751608819, 0, "Jan 01, 2024")
addEmote("Sitting", 85875089814466, 0, "Jan 01, 2024")
addEmote("spikes dance", 127206686429639, 0, "Jan 01, 2024")
addEmote("Marashin Dance", 78010827974170, 0, "Jan 01, 2024")
addEmote("Friendly Wave", 106530036522183, 0, "Jan 01, 2024")
addEmote("Dionela Pose", 118351352716855, 0, "Jan 01, 2024")
addEmote("R6 Sit", 127620425336765, 0, "Jan 01, 2024")
addEmote("Snoop Mlg Dance", 75208907352465, 0, "Jan 01, 2024")
addEmote("HJD Noli's Jig", 90223032116721, 0, "Jan 01, 2024")
addEmote("Arrow Pointing", 76597096771848, 0, "Jan 01, 2024")
addEmote("Rage Quit", 110742001792116, 0, "Jan 01, 2024")
addEmote("T-Pose", 117806601707511, 0, "Jan 01, 2024")
addEmote("ILLIT - Do The Dance", 105521105736256, 0, "Jan 01, 2024")
addEmote("Caramell", 91940234209800, 0, "Jan 01, 2024")
addEmote("aura farming floating idle", 118514887798938, 0, "Jan 01, 2024")
addEmote("Head Popper", 136471291052562, 0, "Jan 01, 2024")
addEmote("The Pong Experience", 97200111573641, 0, "Jan 01, 2024")
addEmote("thumbs up morph", 105945487653158, 0, "Jan 01, 2024")
addEmote("Crazy Punches", 82350905087103, 0, "Jan 01, 2024")
addEmote("Victorious", 110267630715989, 0, "Jan 01, 2024")
addEmote("Dramatic Death", 85063452403538, 0, "Jan 01, 2024")
addEmote("ACELERADA", 84204365810397, 0, "Jan 01, 2024")
addEmote("BLACKPINK - Jump (뛰어)", 129312862861744, 0, "Jan 01, 2024")
addEmote("Clapping", 97626677881731, 0, "Jan 01, 2024")
addEmote("Richard - The Hero Dance", 107252151888809, 0, "Jan 01, 2024")
addEmote("Casual Sit II", 129268515686173, 0, "Jan 01, 2024")
addEmote("Stinky", 114552148774753, 0, "Jan 01, 2024")
addEmote("Best Mates", 92626243564699, 0, "Jan 01, 2024")
addEmote("Doodle", 82202556089770, 0, "Jan 01, 2024")
addEmote("Helicopter", 81271977220099, 0, "Jan 01, 2024")
addEmote("Cute Girl Pose", 124965295116997, 0, "Jan 01, 2024")
addEmote("Orihime Laugh (Bohahaha)", 82134235309527, 0, "Jan 01, 2024")
addEmote("mewing", 138877010789541, 0, "Jan 01, 2024")
addEmote("baddie dance main character", 114139198525884, 0, "Jan 01, 2024")
addEmote("Happy Steps", 108684621854440, 0, "Jan 01, 2024")
addEmote("Gojo (GOMEN AMANAI)", 114304708078521, 0, "Jan 01, 2024")
addEmote("Zombie Dance", 106157515427895, 0, "Jan 01, 2024")
addEmote("A Porcelain Pause ", 88513808513582, 0, "Jan 01, 2024")
addEmote("Football Head Kick", 83300929762142, 0, "Jan 01, 2024")
addEmote("Glory Float ✨", 72753105015394, 0, "Jan 01, 2024")
addEmote("Reset - OOF", 136413905965775, 0, "Jan 01, 2024")
addEmote("Gmod - Crowbar Looking Around", 102223494758433, 0, "Jan 01, 2024")
addEmote("8 Mile", 87530688629074, 0, "Jan 01, 2024")
addEmote("Aura Farming with Tuff Nod", 130809594285808, 0, "Jan 01, 2024")
addEmote("Classic Dance", 98592327746875, 0, "Jan 01, 2024")
addEmote("Boneless Wiggle", 103995817836442, 0, "Jan 01, 2024")
addEmote("Shimmer", 119450098152909, 0, "Jan 01, 2024")
addEmote("Lonely Dance", 127011373448205, 0, "Jan 01, 2024")
addEmote("💢😡 Valid Crashout", 78640547707912, 0, "Jan 01, 2024")
addEmote("Disassamble", 97431531315592, 0, "Jan 01, 2024")
addEmote("Silly Leg Kicking", 101267242314568, 0, "Jan 01, 2024")
addEmote("Spinning Cat", 75739251269771, 0, "Jan 01, 2024")
addEmote("Hoppity", 137976064236530, 0, "Jan 01, 2024")
addEmote("Maxwell the Cat", 113769062145411, 0, "Jan 01, 2024")
addEmote("Head Kicks", 129356399615633, 0, "Jan 01, 2024")
addEmote("It's TV Time! (FAST)", 128944902226654, 0, "Jan 01, 2024")
addEmote("Cutsey Picnic Sit", 126764047945546, 0, "Jan 01, 2024")
addEmote("Space Chill", 99226001299522, 0, "Jan 01, 2024")
addEmote("Jersey Joe", 108854740914429, 0, "Jan 01, 2024")
addEmote("Npc Dance Moves", 129716960168732, 0, "Jan 01, 2024")
addEmote("Best Mates Emote", 130492931581945, 0, "Jan 01, 2024")
addEmote("Nonchalant Sit", 85092320680319, 0, "Jan 01, 2024")
addEmote("MM2 Fake Death (troll murder)", 135240930198371, 0, "Jan 01, 2024")
addEmote("Hot Marat", 95386047948166, 0, "Jan 01, 2024")
addEmote("Crazy Laugh", 86760710155841, 0, "Jan 01, 2024")
addEmote("CPR - Heart Pump - Revive", 120299409218240, 0, "Jan 01, 2024")
addEmote("Rubberband Teleport", 131129825948865, 0, "Jan 01, 2024")
addEmote("Yamcha Pose", 121224535966082, 0, "Jan 01, 2024")
addEmote("Twist", 114887818688790, 0, "Jan 01, 2024")
addEmote("Sleeping ZZZ", 97853216529214, 0, "Jan 01, 2024")
addEmote("Hula Dance ", 92195405464418, 0, "Jan 01, 2024")
addEmote("Avatar Creation", 132130218309191, 0, "Jan 01, 2024")
addEmote("Loose Head", 83379177824773, 0, "Jan 01, 2024")
addEmote("Sue Heck Celebration", 82607256416132, 0, "Jan 01, 2024")
addEmote("Popular Vibe", 138358668562200, 0, "Jan 01, 2024")
addEmote("Wiggle Ragdoll", 123750365300358, 0, "Jan 01, 2024")
addEmote("Cross Legged Sit", 117594622635041, 0, "Jan 01, 2024")
addEmote("Monk Meditation", 107646176660347, 0, "Jan 01, 2024")
addEmote("Swing your Arms", 119722281141882, 0, "Jan 01, 2024")
addEmote("Headless Soccer Kick [Fortnite]", 74646499757361, 0, "Jan 01, 2024")
addEmote("L Dance", 130128791035467, 0, "Jan 01, 2024")
addEmote("Curl Up Crying", 100753722354167, 0, "Jan 01, 2024")
addEmote("CREEPER", 72355507074510, 0, "Jan 01, 2024")
addEmote("Dramatic Sad Floor Collapse", 116935723718747, 0, "Jan 01, 2024")
addEmote("Whiplash", 83146700303098, 0, "Jan 01, 2024")
addEmote("Penguin dance", 108403688448892, 0, "Jan 01, 2024")
addEmote("[HOT] Soda Pop - Demon Hunters", 76251597134704, 0, "Jan 01, 2024")
addEmote("Basketball Head", 86360413653755, 0, "Jan 01, 2024")
addEmote("CoryxKenshin Dance", 129610741067162, 0, "Jan 01, 2024")
addEmote("This Is For You Dance", 72769171576255, 0, "Jan 01, 2024")
addEmote("Jayguapo pink cardigan dance", 105332085917875, 0, "Jan 01, 2024")
addEmote("Feelin' Cute 2", 90885686290037, 0, "Jan 01, 2024")
addEmote("Um- Girl dont (NEW!)", 75008032742551, 0, "Jan 01, 2024")
addEmote("Floating Asleep", 119383023322408, 0, "Jan 01, 2024")
addEmote("⏳[LIMITED] LOL pose", 76498186497788, 0, "Jan 01, 2024")
addEmote("Head Juggle", 122430864477945, 0, "Jan 01, 2024")
addEmote("Ascending", 80361960287550, 0, "Jan 01, 2024")
addEmote("Superhero flying pose", 72700114258457, 0, "Jan 01, 2024")
addEmote("Drill Dance", 91785046585302, 0, "Jan 01, 2024")
addEmote("Kick", 128523357933954, 0, "Jan 01, 2024")
addEmote("Sit and Chill, Leaning Back", 125285869416532, 0, "Jan 01, 2024")
addEmote("Dragon's Dance", 104911634703668, 0, "Jan 01, 2024")
addEmote("AMOGUS", 136752820912437, 0, "Jan 01, 2024")
addEmote("Slow Motion Backflip", 93087341629870, 0, "Jan 01, 2024")
addEmote("Among Us Impostor", 126498048679878, 0, "Jan 01, 2024")
addEmote("Circus Balance Head Act", 134408410578995, 0, "Jan 01, 2024")
addEmote("Sitting Laughing", 89394846197228, 0, "Jan 01, 2024")
addEmote("Matrix Bullet Dodge Emote", 79815262729215, 0, "Jan 01, 2024")
addEmote("Chill Laid Back Sit", 125310315283000, 0, "Jan 01, 2024")
addEmote("Sitting Cry", 125786964481999, 0, "Jan 01, 2024")
addEmote("Zesty Troll Pose 🌈", 89366990216572, 0, "Jan 01, 2024")
addEmote("carpet [player]", 114849893262076, 0, "Jan 01, 2024")
addEmote("Da Baby : Go Mufasa", 114705842276357, 0, "Jan 01, 2024")
addEmote("R6 Classic Death / Reset", 130778814035282, 0, "Jan 01, 2024")
addEmote("Anime Girl Dance", 91600943778879, 0, "Jan 01, 2024")
addEmote("Aura Farm Kid", 108330506883747, 0, "Jan 01, 2024")
addEmote("Take The L!", 80635854458066, 0, "Jan 01, 2024")
addEmote("Birdie", 126409694127199, 0, "Jan 01, 2024")
addEmote("Heart Pose L", 101095056216703, 0, "Jan 01, 2024")
addEmote("Rat Shuffle", 111826070659187, 0, "Jan 01, 2024")
addEmote("Table Transform", 101208492437501, 0, "Jan 01, 2024")
addEmote("Weird Tower", 138011624189361, 0, "Jan 01, 2024")
addEmote("The Giver", 100135446186821, 0, "Jan 01, 2024")
addEmote("Geto Walk", 130087079195536, 0, "Jan 01, 2024")
addEmote("Osaka Sway", 73246860946914, 0, "Jan 01, 2024")
addEmote("Sleeping", 113546798537900, 0, "Jan 01, 2024")
addEmote("Tenna Swing Dance - Deltarune", 128531660091821, 0, "Jan 01, 2024")
addEmote("Mannrobics", 137083371348264, 0, "Jan 01, 2024")
addEmote("Head in a Cage", 107979768237727, 0, "Jan 01, 2024")
addEmote("Party Hips", 93888621530836, 0, "Jan 01, 2024")
addEmote("Infinite dab", 133713772106150, 0, "Jan 01, 2024")
addEmote("Aura Farming Emote [HIGH QUALITY!]", 136093628983587, 0, "Jan 01, 2024")
addEmote("Birdbrain", 120486252224195, 0, "Jan 01, 2024")
addEmote("Alibibi Emote", 95384182809051, 0, "Jan 01, 2024")
addEmote("Adventurer's Dance", 131971655391540, 0, "Jan 01, 2024")
addEmote("Dark crawling", 105455896616445, 0, "Jan 01, 2024")
addEmote("Muscle Flex", 97315229160141, 0, "Jan 01, 2024")
addEmote("REALLY REALLY HAPPY", 71916886741139, 0, "Jan 01, 2024")
addEmote("Pretty Princess Dance", 90279651314389, 0, "Jan 01, 2024")
addEmote("Wheel", 112138124902525, 0, "Jan 01, 2024")
addEmote("Springtrap Pose", 98392612303417, 0, "Jan 01, 2024")
addEmote("Feeling Cute ", 119344837237578, 0, "Jan 01, 2024")
addEmote("Spiderman Idle", 131008122226947, 0, "Jan 01, 2024")
addEmote("Talking", 94450465728680, 0, "Jan 01, 2024")
addEmote("Ledge/Railing Sit", 129389629031100, 0, "Jan 01, 2024")
addEmote("cute", 124279994256240, 0, "Jan 01, 2024")
addEmote("KPOP Saja Boys Star-Boy Dance!", 109908036037107, 0, "Jan 01, 2024")
addEmote("Roller vibes", 96967166885387, 0, "Jan 01, 2024")
addEmote("Fashion Profile Pose", 121793481870760, 0, "Jan 01, 2024")
addEmote("cat scratching", 93910188107955, 0, "Jan 01, 2024")
addEmote("MTE Dance Loop", 77199191268685, 0, "Jan 01, 2024")
addEmote("Jabba switchway", 76182615311022, 0, "Jan 01, 2024")
addEmote("MTE DANCE [only hand]", 139471291538006, 0, "Jan 01, 2024")
addEmote("Geto Walk", 107362908536329, 0, "Jan 01, 2024")
addEmote("BIRDBRAIN", 116046241429974, 0, "Jan 01, 2024")
addEmote("/e spin head", 79763687324961, 0, "Jan 01, 2024")
addEmote("Meditating", 108792231473421, 0, "Jan 01, 2024")
addEmote("(DELTARUNE) Catswing", 80772618602944, 0, "Jan 01, 2024")
addEmote("I DON'T NEED THIS ARM", 118140637696935, 0, "Jan 01, 2024")
addEmote("Im a Mystery", 106292420778623, 0, "Jan 01, 2024")
addEmote("Rotate", 135752921567159, 0, "Jan 01, 2024")
addEmote("squat idle pose ", 113960239878969, 0, "Jan 01, 2024")
addEmote("Everybody do the FLOP", 73598480415363, 0, "Jan 01, 2024")
addEmote("Trip Out", 135599476494116, 0, "Jan 01, 2024")
addEmote("Don't do it!", 124117017486140, 0, "Jan 01, 2024")
addEmote("I Be Tripping - DDG", 123110581577098, 0, "Jan 01, 2024")
addEmote("The Roaring Knight", 71344633443114, 0, "Jan 01, 2024")
addEmote("Honored One", 90035478909211, 0, "Jan 01, 2024")
addEmote("Finger Snap", 78513369738881, 0, "Jan 01, 2024")
addEmote("[NEW] ✨️ Soda Pop", 91180012190248, 0, "Jan 01, 2024")
addEmote("Headpats", 104835445269864, 0, "Jan 01, 2024")
addEmote("Mafioso Finger Snap", 73226406384553, 0, "Jan 01, 2024")
addEmote("Maxwell Cat Dance", 107003903474273, 0, "Jan 01, 2024")
addEmote("Extended Spin", 123821472330376, 0, "Jan 01, 2024")
addEmote("John Black Ops", 96380114122886, 0, "Jan 01, 2024")
addEmote("Helicopter Emote", 94057474101013, 0, "Jan 01, 2024")
addEmote("evil mastermind", 73348814672443, 0, "Jan 01, 2024")
addEmote("Panic SCP 096", 91328405614070, 0, "Jan 01, 2024")
addEmote("Wally West", 126189114863512, 0, "Jan 01, 2024")
addEmote("Mineblox shift ⛏️", 78113188170410, 0, "Jan 01, 2024")
addEmote("Falling Apart Fake Death", 100532253368054, 0, "Jan 01, 2024")
addEmote("Spinning Floating", 116682885200128, 0, "Jan 01, 2024")
addEmote("Desirable - Lil Uzi Vert - Fortnite", 127106217722707, 0, "Jan 01, 2024")
addEmote("Bully Maguire Dance Meme", 85272832296757, 0, "Jan 01, 2024")
addEmote("Penguin Dance", 127346586341492, 0, "Jan 01, 2024")
addEmote("[BEST VERSION] Aura Farm Boat Dance", 135697847643539, 0, "Jan 01, 2024")
addEmote("Curtsy", 134908223911606, 0, "Jan 01, 2024")
addEmote("falling backwards", 134743709414658, 0, "Jan 01, 2024")
addEmote("Taekwondo Combo ", 110286823388069, 0, "Jan 01, 2024")
addEmote("Iconic Chika Anime Dance", 71099972642834, 0, "Jan 01, 2024")
addEmote("Wait!", 97200492951547, 0, "Jan 01, 2024")
addEmote("Aura Magical Float Idle Emote Animation", 127260900197753, 0, "Jan 01, 2024")
addEmote("Crazy Sit emote ", 112953571236954, 0, "Jan 01, 2024")
addEmote("Cool pose", 115307869111917, 0, "Jan 01, 2024")
addEmote("DUN DA DUN", 89587346022811, 0, "Jan 01, 2024")
addEmote("Firing Tank", 103381122634423, 0, "Jan 01, 2024")
addEmote("Party Swim", 77273905738371, 0, "Jan 01, 2024")
addEmote("Calling the Cops with Attitude", 106570939958141, 0, "Jan 01, 2024")
addEmote("Noggin Toss", 120490865867440, 0, "Jan 01, 2024")
addEmote("ChargeTest", 125773167785667, 0, "Jan 01, 2024")
addEmote("Universal sign of peace! (minecraft dance)", 132796759181140, 0, "Jan 01, 2024")
addEmote("Sat down on knees v1", 115743974689073, 0, "Jan 01, 2024")
addEmote("2011X Taunt", 98217051276567, 0, "Jan 01, 2024")
addEmote("Sitting Drum Solo", 104176588781581, 0, "Jan 01, 2024")
addEmote("Head Pat", 127202051947907, 0, "Jan 01, 2024")
addEmote("Miku", 91404098460527, 0, "Jan 01, 2024")
addEmote("Good Boy", 115189617797825, 0, "Jan 01, 2024")
addEmote("Cactus Cross", 131043513262279, 0, "Jan 01, 2024")
addEmote("Squid Game Dance", 108021476427643, 0, "Jan 01, 2024")
addEmote("Graceful Sitting Pose", 103380859165274, 0, "Jan 01, 2024")
addEmote("Sad Sit", 111061988978180, 0, "Jan 01, 2024")
addEmote("Criss Cross Sit", 133663782649992, 0, "Jan 01, 2024")
addEmote("Smug Dance", 136079923684452, 0, "Jan 01, 2024")
addEmote("Sitting Cutely MM2", 73791153309603, 0, "Jan 01, 2024")
addEmote("Druski dance", 112419348198903, 0, "Jan 01, 2024")
addEmote("Stretch", 72735859399440, 0, "Jan 01, 2024")
addEmote("MENACING (Kars' Pose)", 121541230731768, 0, "Jan 01, 2024")
addEmote("Lonely dance Tiktok ", 91595319803633, 0, "Jan 01, 2024")
addEmote("Kaiju Victory Dance", 139649611578688, 0, "Jan 01, 2024")
addEmote("Akaza Hakuji Fighting Stance", 126168053681827, 0, "Jan 01, 2024")
addEmote("Tokai Teio Step", 120429251624791, 0, "Jan 01, 2024")
addEmote("The fly in my house before eating my food", 119613212507525, 0, "Jan 01, 2024")
addEmote("Imma dive in it", 140043938154848, 0, "Jan 01, 2024")
addEmote("Smooth Moves", 113473810158309, 0, "Jan 01, 2024")
addEmote("Kazotsky Dance", 75442498302027, 0, "Jan 01, 2024")
addEmote("Soda Pop", 102308094913065, 0, "Jan 01, 2024")
addEmote("Menacingly Levitating", 136345064545028, 0, "Jan 01, 2024")
addEmote("Sad Cat Dance", 115314495324334, 0, "Jan 01, 2024")
addEmote("Anime sitting down", 103415660479536, 0, "Jan 01, 2024")
addEmote("Hip Sway", 95406698449021, 0, "Jan 01, 2024")
addEmote("Kneeling Knight", 119700478735658, 0, "Jan 01, 2024")
addEmote("Shy ", 139124221076119, 0, "Jan 01, 2024")
addEmote("Cute Stylish Thinking Pose", 128252171563564, 0, "Jan 01, 2024")
addEmote("Spider Torment - Profile Pose", 132191542256190, 0, "Jan 01, 2024")
addEmote("By the nine", 117572676349416, 0, "Jan 01, 2024")
addEmote("Ultimate Lifeforms Annoyance", 112428321591820, 0, "Jan 01, 2024")
addEmote("JoJo Torture Dance", 107722612397632, 0, "Jan 01, 2024")
addEmote("Shikanoko Dance", 79414560195746, 0, "Jan 01, 2024")
addEmote("Pitbull Terrier ", 110587762486697, 0, "Jan 01, 2024")
addEmote("Cute Flying ✨", 107181106234347, 0, "Jan 01, 2024")
addEmote("Sun God Nika Luffy Zoro JoyBoy Shanks", 132795932335191, 0, "Jan 01, 2024")
addEmote("Not My Problem", 112706989937784, 0, "Jan 01, 2024")
addEmote("Traditional Bow Chinese Tang Dynasty Feminine v2", 138561940961995, 0, "Jan 01, 2024")
addEmote("Get Jiggy", 73702310439368, 0, "Jan 01, 2024")
addEmote("Piano Tiles", 116380561148643, 0, "Jan 01, 2024")
addEmote("BOW BOW", 98282768748816, 0, "Jan 01, 2024")
addEmote("True heart ♥ ", 108395872939049, 0, "Jan 01, 2024")
addEmote("Wednesday Dance", 129705512553490, 0, "Jan 01, 2024")
addEmote("Scared Sit", 117068792163899, 0, "Jan 01, 2024")
addEmote("Accurate R15 Death (No Collision Version)", 136613840114038, 0, "Jan 01, 2024")
addEmote("Knife Slash", 82407225122935, 0, "Jan 01, 2024")
addEmote("Ballerina Spin", 78021354556767, 0, "Jan 01, 2024")
addEmote("Sit", 132738611207490, 0, "Jan 01, 2024")
addEmote("Gojo Rage Pose", 122149220407815, 0, "Jan 01, 2024")
addEmote("Zaya Shuffle", 101874945758666, 0, "Jan 01, 2024")
addEmote("Whiplash", 88041229769760, 0, "Jan 01, 2024")
addEmote("Island Two Step 🌴", 79340082893365, 0, "Jan 01, 2024")
addEmote("bop (gimme he... TOP)", 124207929206048, 0, "Jan 01, 2024")
addEmote("Meditate", 103722824645347, 0, "Jan 01, 2024")
addEmote("Iconic Forward Lean", 111769513948832, 0, "Jan 01, 2024")
addEmote("Shimmer", 112161040647611, 0, "Jan 01, 2024")
addEmote("OsamaWalk 😎", 100934292579274, 0, "Jan 01, 2024")
addEmote("What you want ", 124367226978030, 0, "Jan 01, 2024")
addEmote("Levitate", 127341047900130, 0, "Jan 01, 2024")
addEmote("Tiktok Dance", 130988089200640, 0, "Jan 01, 2024")
addEmote("Preppy Kiss Dance", 132900362924399, 0, "Jan 01, 2024")
addEmote("Cute Cat Sit Idle", 110757655806288, 0, "Jan 01, 2024")
addEmote("RUNAWAY", 131371560604908, 0, "Jan 01, 2024")
addEmote("🕷️ Wednesday ", 129800172862369, 0, "Jan 01, 2024")
addEmote("Powering Up", 129201492887233, 0, "Jan 01, 2024")
addEmote("Squatting Crab Dance", 78669969633489, 0, "Jan 01, 2024")
addEmote("Soda Pop - KPop Demon Hunters", 71880688042369, 0, "Jan 01, 2024")
addEmote("Badass Head Spin Breakdancing Move", 89699073957350, 0, "Jan 01, 2024")
addEmote("Levitate", 105491566513571, 0, "Jan 01, 2024")
addEmote("rollout", 106461997639966, 0, "Jan 01, 2024")
addEmote("Bhop", 74800544807006, 0, "Jan 01, 2024")
addEmote("Out West", 94928097937878, 0, "Jan 01, 2024")
addEmote("Chicken Dance", 126236414340245, 0, "Jan 01, 2024")
addEmote("Domain Expansion", 81323477823492, 0, "Jan 01, 2024")
addEmote("Smug Dance", 78514839375893, 0, "Jan 01, 2024")
addEmote("OBJECTION", 133989139128337, 0, "Jan 01, 2024")
addEmote("Gear5 Laugh", 93965005969845, 0, "Jan 01, 2024")
addEmote("I WANNA I WANNA I WANNA", 83993474365911, 0, "Jan 01, 2024")
addEmote("Bunny Hopping", 71027284203894, 0, "Jan 01, 2024")
addEmote("It Should Have Been Me!", 97470802984547, 0, "Jan 01, 2024")
addEmote("Siuuu Celebration", 107447321843426, 0, "Jan 01, 2024")
addEmote("The Look", 116937628942407, 0, "Jan 01, 2024")
addEmote("Slow Walk", 97207843851925, 0, "Jan 01, 2024")
addEmote("Rat Dance!", 119946756951420, 0, "Jan 01, 2024")
addEmote("Gwenchana Dance", 79403262965744, 0, "Jan 01, 2024")
addEmote("Rubiks Cube", 125588746280720, 0, "Jan 01, 2024")
addEmote("Head juggle", 122305118103096, 0, "Jan 01, 2024")
addEmote("pole", 75947162094897, 0, "Jan 01, 2024")
addEmote("police emote (aura farm)", 92523044189244, 0, "Jan 01, 2024")
addEmote("Lias cute girly pose 🐰", 121983944928764, 0, "Jan 01, 2024")
addEmote("W sitting pose cute ", 95696528969361, 0, "Jan 01, 2024")
addEmote("Head scratches / Head pats", 123663633846435, 0, "Jan 01, 2024")
addEmote("shy waiting walk cute", 128490139735689, 0, "Jan 01, 2024")
addEmote("Taking head off", 113880595469437, 0, "Jan 01, 2024")
addEmote("It's a Vibe!", 139021660429848, 0, "Jan 01, 2024")
addEmote("Mime", 121558490761409, 0, "Jan 01, 2024")
addEmote("The Robot", 104690865816900, 0, "Jan 01, 2024")
addEmote("Crouch", 83083414104031, 0, "Jan 01, 2024")
addEmote("Shock Trauma Panic Attack Crying Scene Animation", 94986177495951, 0, "Jan 01, 2024")
addEmote("⏳[BEST] Druski Dance", 112048991058519, 0, "Jan 01, 2024")
addEmote("Thought I was Dead", 107321664529882, 0, "Jan 01, 2024")
addEmote("Coryxkenshin dance", 123154654149012, 0, "Jan 01, 2024")
addEmote("Dead Meat", 103606300220798, 0, "Jan 01, 2024")
addEmote("Happy Tail Wag Dance", 80498507846920, 0, "Jan 01, 2024")
addEmote("Jabba Switchway", 138869989521659, 0, "Jan 01, 2024")
addEmote("Wacky Inflatable Tube Man", 140153243424588, 0, "Jan 01, 2024")
addEmote("Sad sit", 99619702024667, 0, "Jan 01, 2024")
addEmote("Exciting Shoulder Dance", 110465718832561, 0, "Jan 01, 2024")
addEmote("Strike A Pose!", 81219142745618, 0, "Jan 01, 2024")
addEmote("Get a Load of this Guy", 76321196848937, 0, "Jan 01, 2024")
addEmote("Slow-Mo Backflip | IShowSpeed Flip [NEW]", 86617727183442, 0, "Jan 01, 2024")
addEmote("Victory Shake", 123494725459112, 0, "Jan 01, 2024")
addEmote("Monochrome Step", 104388361458478, 0, "Jan 01, 2024")
addEmote("Fit Check Idle", 90042616187559, 0, "Jan 01, 2024")
addEmote("Super Saiyan Goku Vegeta", 89436862011211, 0, "Jan 01, 2024")
addEmote("Thank You Bow Ladies and Gentlemen ", 132566708912466, 0, "Jan 01, 2024")
addEmote("Salute Of The Rings", 97355202947632, 0, "Jan 01, 2024")
addEmote("Just Jump!", 123482363857727, 0, "Jan 01, 2024")
addEmote("Vanish", 76341709466308, 0, "Jan 01, 2024")
addEmote("Image", 140427800045298, 0, "Jan 01, 2024")
addEmote("Yuji Itadori vs Mahito Skyfall Walk Sukuna Gojo", 107775678918392, 0, "Jan 01, 2024")
addEmote("Cute Sit", 107111906052821, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii reading my book... idle pose", 132509804632364, 0, "Jan 01, 2024")
addEmote("Light Yagami - Kira Laugh", 90041324169502, 0, "Jan 01, 2024")
addEmote("Tenna Dance Deltarune", 103562566992270, 0, "Jan 01, 2024")
addEmote("Relaxed Sit", 84311043660298, 0, "Jan 01, 2024")
addEmote("Yamcha Defeat Pose", 96324424641851, 0, "Jan 01, 2024")
addEmote("Ballet Music Box Spin", 92190700028269, 0, "Jan 01, 2024")
addEmote("Wait", 122018799359396, 0, "Jan 01, 2024")
addEmote("Smoldering Awesomeness", 139398558161516, 0, "Jan 01, 2024")
addEmote("Doodle Dance meme ����‍♀️", 104682399216691, 0, "Jan 01, 2024")
addEmote("Griddy Meme Dance", 91696126503142, 0, "Jan 01, 2024")
addEmote("Raise The Roof", 82168248767491, 0, "Jan 01, 2024")
addEmote("More Pets Than Pats", 76445477486506, 0, "Jan 01, 2024")
addEmote("Swag Walk", 123813392497621, 0, "Jan 01, 2024")
addEmote("[🌪���] Tornado", 74251182734456, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii side hug ... pose !", 88509051532516, 0, "Jan 01, 2024")
addEmote("Backward Push Up", 116598620477397, 0, "Jan 01, 2024")
addEmote("Rodeo Dance", 75735779317568, 0, "Jan 01, 2024")
addEmote("Gold Ship Radar Alert", 134175400700281, 0, "Jan 01, 2024")
addEmote("⏳MM2 Speed and Clip Glitch!", 82201126622013, 0, "Jan 01, 2024")
addEmote("Front Walk", 116940798506421, 0, "Jan 01, 2024")
addEmote("Cute Over The Shoulder Pose", 137282259215755, 0, "Jan 01, 2024")
addEmote("Soda Pop Dance - Kpop Trendy Saja Boys ", 85717743142918, 0, "Jan 01, 2024")
addEmote("Holding my Head", 112562880950292, 0, "Jan 01, 2024")
addEmote("The World // Jojo's Bizarre Adventure", 120220827329610, 0, "Jan 01, 2024")
addEmote("Laying on belly", 91527757925277, 0, "Jan 01, 2024")
addEmote("Mine sit", 111850449158420, 0, "Jan 01, 2024")
addEmote("Ella Mai - Dance", 103948740090967, 0, "Jan 01, 2024")
addEmote("Rat Dance", 126123959691270, 0, "Jan 01, 2024")
addEmote("┊♡꒱ cute lean back sit ꒰emote꒱", 124219544007159, 0, "Jan 01, 2024")
addEmote("Cute Kitty Cat Dance", 84683704176695, 0, "Jan 01, 2024")
addEmote("LagTrain [ Animated By MondyArtizt ]", 81231120125258, 0, "Jan 01, 2024")
addEmote("Halloween Funk (Spooky Scary Skeletons) Dance", 121427955316618, 0, "Jan 01, 2024")
addEmote("Lay down", 135254107850063, 0, "Jan 01, 2024")
addEmote("Mellstroy", 137546557108624, 0, "Jan 01, 2024")
addEmote("baragge", 129844356814165, 0, "Jan 01, 2024")
addEmote("⏳ [BEST] Default Dance | OG", 121094705979021, 0, "Jan 01, 2024")
addEmote("Praise the Sun", 129230467344996, 0, "Jan 01, 2024")
addEmote("Retro Goodness", 114107076646032, 0, "Jan 01, 2024")
addEmote("Desirable Lil Uzi", 86667947350283, 0, "Jan 01, 2024")
addEmote("IShowSpeed's Shake Dance", 79608214368144, 0, "Jan 01, 2024")
addEmote("Poki Dance", 71491470719155, 0, "Jan 01, 2024")
addEmote("Sinister mark day 3 pose", 115305110740952, 0, "Jan 01, 2024")
addEmote("Horror Head Turn", 125928732780921, 0, "Jan 01, 2024")
addEmote("Head Roll", 92285497536838, 0, "Jan 01, 2024")
addEmote("Manchild Dance", 87411196812283, 0, "Jan 01, 2024")
addEmote("Hood Dance", 104391254837964, 0, "Jan 01, 2024")
addEmote("Meditating", 93607593234484, 0, "Jan 01, 2024")
addEmote("Bring it Around!!", 73954107469097, 0, "Jan 01, 2024")
addEmote("Piano Tiles", 125226241806041, 0, "Jan 01, 2024")
addEmote("Round and Round Squid Game", 76159810131201, 0, "Jan 01, 2024")
addEmote("I'm dead bruh", 93774022902459, 0, "Jan 01, 2024")
addEmote("Fit Check Edit", 113513335423607, 0, "Jan 01, 2024")
addEmote("Tenna Battle Clap Attack - DELTARUNE", 110835227650748, 0, "Jan 01, 2024")
addEmote("DARLING in the FRANXX Zero Two Groove", 78276416047037, 0, "Jan 01, 2024")
addEmote("Freddy Back Alley Glitch Meme", 130837164078078, 0, "Jan 01, 2024")
addEmote("Teto territory (Testing)", 129421840073554, 0, "Jan 01, 2024")
addEmote("Yawning", 105639920471008, 0, "Jan 01, 2024")
addEmote("Plane", 130371611259719, 0, "Jan 01, 2024")
addEmote("Peace Out", 86524364349291, 0, "Jan 01, 2024")
addEmote("Arsenal: Showtime Swing", 121709513302849, 0, "Jan 01, 2024")
addEmote("Arsenal: Groovy Grill", 81774337551737, 0, "Jan 01, 2024")
addEmote("Cute Shy Emote", 79674523865825, 0, "Jan 01, 2024")
addEmote("Smile", 97600663931647, 0, "Jan 01, 2024")
addEmote("Konosuba Intro Dance", 133013912804830, 0, "Jan 01, 2024")
addEmote("Skibidi Dance", 122728718394460, 0, "Jan 01, 2024")
addEmote("♡ cute kawaii holding my umbrella ... idle pose ", 125962003071474, 0, "Jan 01, 2024")
addEmote("Sturdy", 92194348934609, 0, "Jan 01, 2024")
addEmote("Waving Arms Celebration", 93997701229004, 0, "Jan 01, 2024")
addEmote("Rolling Robloxian", 129218299879370, 0, "Jan 01, 2024")
addEmote("Cute Anime Girl 🌸 - Profile Pose", 99962431556547, 0, "Jan 01, 2024")
addEmote("Jotaro Timestop", 80390911550036, 0, "Jan 01, 2024")
addEmote("PONPONポン", 117735778942394, 0, "Jan 01, 2024")
addEmote("MWAH!", 72786691697637, 0, "Jan 01, 2024")
addEmote("squid game salesman", 109828171502788, 0, "Jan 01, 2024")
addEmote("Casual Sit", 140523664797025, 0, "Jan 01, 2024")
addEmote("Ronaldo siuu", 128899721517220, 0, "Jan 01, 2024")
addEmote("Hat Tip", 95435129523125, 0, "Jan 01, 2024")
addEmote("Parade Rest", 129265350189637, 0, "Jan 01, 2024")
addEmote("Broken Bones", 74448179935277, 0, "Jan 01, 2024")
addEmote("Fixing Hair (Female)", 114127637762074, 0, "Jan 01, 2024")
addEmote("Justice dance", 122991665286888, 0, "Jan 01, 2024")
addEmote("Rah Tah Tah (Chromakopia Dance)", 84928370121154, 0, "Jan 01, 2024")
addEmote("Adorable", 74449749954854, 0, "Jan 01, 2024")
addEmote("Sturdy", 78517396437808, 0, "Jan 01, 2024")
addEmote("Jumping Jacks", 84982411523319, 0, "Jan 01, 2024")
addEmote("Wait... They Dont <3 You Like I <3 You", 114345976871574, 0, "Jan 01, 2024")
addEmote("Dramatic Death", 106234367494562, 0, "Jan 01, 2024")
addEmote("Zany", 125402965490502, 0, "Jan 01, 2024")
addEmote("Fortnite Boneless [✨]", 121138965006099, 0, "Jan 01, 2024")
addEmote("[🎀CUTE] Kayah's Pose 3", 123661901861552, 0, "Jan 01, 2024")
addEmote("pink pantheress - tonight", 89467977141876, 0, "Jan 01, 2024")
addEmote("how did he hit every beat", 101909458450600, 0, "Jan 01, 2024")
addEmote("Kick", 139593983390391, 0, "Jan 01, 2024")
addEmote("Cute Sit", 114676271219287, 0, "Jan 01, 2024")
addEmote("Cat Swing", 125837556862280, 0, "Jan 01, 2024")
addEmote("Facepalm", 78172931951547, 0, "Jan 01, 2024")
addEmote("Evil Plan", 106706934942969, 0, "Jan 01, 2024")
addEmote("Egyptian Prince", 127078884221308, 0, "Jan 01, 2024")
addEmote("Rouxls Kaard Dance - DELTARUNE", 133222612752249, 0, "Jan 01, 2024")
addEmote("[FACE EMOTE] Crazy Eyes", 126836044574895, 0, "Jan 01, 2024")
addEmote("Pushups", 120213698666424, 0, "Jan 01, 2024")
addEmote("X", 110192230323379, 0, "Jan 01, 2024")
addEmote("It's a weird one.. 🤫", 124517201875424, 0, "Jan 01, 2024")
addEmote("Kewer Kewer", 119321170159991, 0, "Jan 01, 2024")
addEmote("LE SSERAFIM - Crazy", 131088613499583, 0, "Jan 01, 2024")
addEmote("Core Laser Animation", 126501029907686, 0, "Jan 01, 2024")
addEmote("Ritmo Solto ", 107225592032188, 0, "Jan 01, 2024")
addEmote("Sit", 133575464542327, 0, "Jan 01, 2024")
addEmote("nsync bye bye bye dance", 78120833463698, 0, "Jan 01, 2024")
addEmote("Become a Tank! [FUNNY TRANSFORMATION]", 114232844630004, 0, "Jan 01, 2024")
addEmote("Rick roll / Never gonna", 100682015010923, 0, "Jan 01, 2024")
addEmote("Falling Head", 100399609466271, 0, "Jan 01, 2024")
addEmote("John's \"Can't Cena Me\" Hand Waving Wrestling Emote", 125774700901649, 0, "Jan 01, 2024")
addEmote("BASKETBALL HEAD", 119202375799204, 0, "Jan 01, 2024")
addEmote("Conga", 73804352345258, 0, "Jan 01, 2024")
addEmote("Sans UNDERTALE Battle ", 107427894732449, 0, "Jan 01, 2024")
addEmote("Become a Wrecking Ball!", 108215882971702, 0, "Jan 01, 2024")
addEmote("The Jig ", 135431806396928, 0, "Jan 01, 2024")
addEmote("Wiggle Wiggle", 86520127496722, 0, "Jan 01, 2024")
addEmote("Roaring Knight - DELTARUNE", 119629761363752, 0, "Jan 01, 2024")
addEmote("Your Idol - Saja Boys", 124101196485213, 0, "Jan 01, 2024")
addEmote("Mochi Mochi", 84010517692081, 0, "Jan 01, 2024")
addEmote("Boogie down", 120142429611939, 0, "Jan 01, 2024")
addEmote("Floating / Levitating Aura Farming God", 73192575347714, 0, "Jan 01, 2024")
addEmote("popipo miku dance", 77558353467820, 0, "Jan 01, 2024")
addEmote("Weird Body", 86051753477299, 0, "Jan 01, 2024")
addEmote("Saja Boys Soda Pop", 97614587826828, 0, "Jan 01, 2024")
addEmote("Idol - Saja Boys", 93669846092172, 0, "Jan 01, 2024")
addEmote("Planks", 117367669653012, 0, "Jan 01, 2024")
addEmote("Caramel dance", 121484778471874, 0, "Jan 01, 2024")
addEmote("Michael Jackson Emote", 72023919210999, 0, "Jan 01, 2024")
addEmote("Push 2 Start", 71019859419523, 0, "Jan 01, 2024")
addEmote("Silver The Hedgehog", 116693779372146, 0, "Jan 01, 2024")
addEmote("Meltdown", 115847833953408, 0, "Jan 01, 2024")
addEmote("Boneless", 87321597549196, 0, "Jan 01, 2024")
addEmote("I WANNA RUN AWAY", 96361347184349, 0, "Jan 01, 2024")
addEmote("Swim", 80434484854185, 0, "Jan 01, 2024")
addEmote("toilet", 78769204344237, 0, "Jan 01, 2024")
addEmote("creeper", 115641240480817, 0, "Jan 01, 2024")
addEmote("Gold Ship Hurt - UmaMusume", 95452210019370, 0, "Jan 01, 2024")
addEmote("Disco Surf Curse", 127684814682936, 0, "Jan 01, 2024")
addEmote("ZEN☯️", 132065974506317, 0, "Jan 01, 2024")
addEmote("Among Us Transformation", 99871998967855, 0, "Jan 01, 2024")
addEmote("Out West", 127558476877623, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 134461027154007, 0, "Jan 01, 2024")
addEmote("Baki Push Ups", 116671514323556, 0, "Jan 01, 2024")
addEmote("90 Degree Aura Stance", 85358830072480, 0, "Jan 01, 2024")
addEmote("Gerson Hammer of Justice - DELTARUNE", 83983219131518, 0, "Jan 01, 2024")
addEmote("Rollie", 132560977819872, 0, "Jan 01, 2024")
addEmote("Super Retro Plumber", 83952037243841, 0, "Jan 01, 2024")
addEmote("Boogie Down", 123124011300432, 0, "Jan 01, 2024")
addEmote("Lie Down", 97058120469317, 0, "Jan 01, 2024")
addEmote("Rollie", 116813695147834, 0, "Jan 01, 2024")
addEmote("Stickbug", 124478946993434, 0, "Jan 01, 2024")
addEmote("Kazotsky Kick", 76572727084815, 0, "Jan 01, 2024")
addEmote("Everybody Do The Flop!", 96519395928399, 0, "Jan 01, 2024")
addEmote("Funky Funk halloween dance", 84227618929552, 0, "Jan 01, 2024")
addEmote("Shout", 84561787247775, 0, "Jan 01, 2024")
addEmote("24 Hour Cinderella", 89924411981508, 0, "Jan 01, 2024")
addEmote("Shuba Duck Dance", 72101889501039, 0, "Jan 01, 2024")
addEmote("On top of cars ", 71801109135244, 0, "Jan 01, 2024")
addEmote("Aura Farming", 121829767001539, 0, "Jan 01, 2024")
addEmote("Goku's Warmup", 80371625135365, 0, "Jan 01, 2024")
addEmote("Brick Falling", 103911902724807, 0, "Jan 01, 2024")
addEmote("Soda Pop", 92233436300466, 0, "Jan 01, 2024")
addEmote("Jubi Slide", 119701068949532, 0, "Jan 01, 2024")
addEmote("Jotaro", 87407868851018, 0, "Jan 01, 2024")
addEmote("Miku's Static Sway (FLAVOR FOLEY)", 101024412525457, 0, "Jan 01, 2024")
addEmote("Show Off Outfit", 82226408349348, 0, "Jan 01, 2024")
addEmote("Dangling Feet Sit", 139640690511252, 0, "Jan 01, 2024")
addEmote("POKEDANCE Emote", 84935708603179, 0, "Jan 01, 2024")
addEmote("Chinese Iconic Trend Dance", 103375721004399, 0, "Jan 01, 2024")
addEmote("Jotaro Pose", 127608716727872, 0, "Jan 01, 2024")
addEmote("Dio Pose Standing", 128072086424961, 0, "Jan 01, 2024")
addEmote("✅ Airplane Superhero Flight Emote ✅", 94839021364946, 0, "Jan 01, 2024")
addEmote("Bird", 79693504152880, 0, "Jan 01, 2024")
addEmote("Whiplash", 104476703756567, 0, "Jan 01, 2024")
addEmote("Tea Time ☕", 76367124843529, 0, "Jan 01, 2024")
addEmote("Blue Lock Itoshi Rin ", 80231345582058, 0, "Jan 01, 2024")
addEmote("Doggy Sit", 128194733790579, 0, "Jan 01, 2024")
addEmote("Jabba Switchway Dance", 119233847175693, 0, "Jan 01, 2024")
addEmote("LOSER!", 109243818643182, 0, "Jan 01, 2024")
addEmote("Renegade Dance", 89610087314805, 0, "Jan 01, 2024")
addEmote("Itoshi Rin Flow State", 140454600782824, 0, "Jan 01, 2024")
addEmote("Headless Glass Raise", 115624123669022, 0, "Jan 01, 2024")
addEmote("Blow A Kiss", 135048112967328, 0, "Jan 01, 2024")
addEmote("OMG - NEWJEANS KPOP DANCE", 99010839544790, 0, "Jan 01, 2024")
addEmote("Do The Flop!", 75823457051737, 0, "Jan 01, 2024")
addEmote("Shade Shuffle - Pressure", 103077650577453, 0, "Jan 01, 2024")
addEmote("Become A Bombardino Crocodilo!", 111241542410926, 0, "Jan 01, 2024")
addEmote("Russian Roulette KPOP Dance Choreo", 88638305704851, 0, "Jan 01, 2024")
addEmote("Submarine Animation!", 108853004148357, 0, "Jan 01, 2024")
addEmote("Default Dance", 90025891324199, 0, "Jan 01, 2024")
addEmote("Sabrina Carpenter - Please Please Please", 116417685464176, 0, "Jan 01, 2024")
addEmote("Ghostly float", 129559735499940, 0, "Jan 01, 2024")
addEmote("Lunar party", 140098923000716, 0, "Jan 01, 2024")
addEmote("Heart, Allegiance, Strength", 81380090117699, 0, "Jan 01, 2024")
addEmote("HUNTRIX - GOLDEN K-POP Dance Choreo", 92575033091391, 0, "Jan 01, 2024")
addEmote("YIPPPEEE!!!", 106290242577819, 0, "Jan 01, 2024")
addEmote("Basketball AirBall", 130755356019972, 0, "Jan 01, 2024")
addEmote("Hop", 125073268896019, 0, "Jan 01, 2024")
addEmote("Chicken Dance", 115257539316062, 0, "Jan 01, 2024")
addEmote("Crip Walk (Smooth/Loops)", 81109418287736, 0, "Jan 01, 2024")
addEmote("Hide Animations", 134554633161672, 0, "Jan 01, 2024")
addEmote("Cute Rushed Wave", 125637658725850, 0, "Jan 01, 2024")
addEmote("NewJeans Dance", 104961931583875, 0, "Jan 01, 2024")
addEmote("Helldiver Salute", 75733530218532, 0, "Jan 01, 2024")
addEmote("Angel Save", 91651648947106, 0, "Jan 01, 2024")
addEmote("jt coming", 113605842562129, 0, "Jan 01, 2024")
addEmote("Fake Death Troll ", 96859323475519, 0, "Jan 01, 2024")
addEmote("Ninja Handstand [MM2]", 123410805552514, 0, "Jan 01, 2024")
addEmote("Dancing with your eyes closed", 129637389787927, 0, "Jan 01, 2024")
addEmote("Shamar Dance - I Got On Bape", 81004018983464, 0, "Jan 01, 2024")
addEmote("Gold Ship Radar Alert", 83774607048921, 0, "Jan 01, 2024")
addEmote("Strike a Pose", 135753282852637, 0, "Jan 01, 2024")
addEmote("Salute", 135931155753335, 0, "Jan 01, 2024")
addEmote("Stomach Laying Down", 137303223971382, 0, "Jan 01, 2024")
addEmote("Happy Silly Jump", 79175444590588, 0, "Jan 01, 2024")
addEmote("Chill Lay", 126983830920167, 0, "Jan 01, 2024")
addEmote("Head Shooter", 83077359513645, 0, "Jan 01, 2024")
addEmote("On The Dance Floor", 75284842644437, 0, "Jan 01, 2024")
addEmote("SuperHero Aura", 123795999754966, 0, "Jan 01, 2024")
addEmote("Everybody do the Flop", 102903656809457, 0, "Jan 01, 2024")
addEmote("Ride The Pony!", 129879792931650, 0, "Jan 01, 2024")
addEmote("Fancy  Feet", 95444610139706, 0, "Jan 01, 2024")
addEmote("Cute Twirl Hand Wave", 123782808805965, 0, "Jan 01, 2024")
addEmote("Egg Rolled 2", 136719220000230, 0, "Jan 01, 2024")
addEmote("Renaissance Cozy Robotic Dance - Bey", 118044975756463, 0, "Jan 01, 2024")
addEmote("Baki Push Up", 113135544892938, 0, "Jan 01, 2024")
addEmote("Internet Yamero", 89350854702315, 0, "Jan 01, 2024")
addEmote("Pray", 120754278085861, 0, "Jan 01, 2024")
addEmote("Coffin Walkout", 117302755748327, 0, "Jan 01, 2024")
addEmote("cute tumbling front walkover", 110654031458583, 0, "Jan 01, 2024")
addEmote("Monkey Spin", 70667168235687, 0, "Jan 01, 2024")
addEmote("♡ 1-UP", 103903130794522, 0, "Jan 01, 2024")
addEmote("Omni hero floating fly idle (look at preview)", 105777026842201, 0, "Jan 01, 2024")
addEmote("Koichi (JoJo Pose)", 134376190538320, 0, "Jan 01, 2024")
addEmote("CHILL SIT POSE", 71176345393603, 0, "Jan 01, 2024")
addEmote("Crying Emote", 82218484353408, 0, "Jan 01, 2024")
addEmote("Haii Nani Ga Suki", 98049708926453, 0, "Jan 01, 2024")
addEmote("Jay Guapo Emote", 99796495204285, 0, "Jan 01, 2024")
addEmote("Headless (MM2)", 70396352755636, 0, "Jan 01, 2024")
addEmote("Pixel Pal", 74177070065809, 0, "Jan 01, 2024")
addEmote("Floating Sit Sway", 112951942181617, 0, "Jan 01, 2024")
addEmote("Best Mate", 82696942521504, 0, "Jan 01, 2024")
addEmote("Avatar Pose - Thanos Picture Pose", 105011663274521, 0, "Jan 01, 2024")
addEmote("Dolly Sit", 140247970413909, 0, "Jan 01, 2024")
addEmote("Headtop Dance", 87338280328293, 0, "Jan 01, 2024")
addEmote("Pew pew, headshot!", 111379130876920, 0, "Jan 01, 2024")
addEmote("Distraction Dance", 134166954873369, 0, "Jan 01, 2024")
addEmote("Beat Da Kotonai (Lunar Dance)", 116504856481188, 0, "Jan 01, 2024")
addEmote("Hypnosis", 76804210490828, 0, "Jan 01, 2024")
addEmote("Coffin Walk Out - Lil Yachty", 97400349315961, 0, "Jan 01, 2024")
addEmote("Cody's \"WOAH\" Entrance Pyro Emote (Wrestling)", 135690281546602, 0, "Jan 01, 2024")
addEmote("Royale Goblin Boohoo", 82944821310124, 0, "Jan 01, 2024")
addEmote("Domain Expansion Gojo", 90085716100071, 0, "Jan 01, 2024")
addEmote("KSI Boxing Starjumps", 111352060050622, 0, "Jan 01, 2024")
addEmote("MM2 Headless Emote", 101119815969594, 0, "Jan 01, 2024")
addEmote("Beach Dance", 132709120554465, 0, "Jan 01, 2024")
addEmote("Love Island Ace's Dance", 133809494032638, 0, "Jan 01, 2024")
addEmote("Mr Clip Man", 106368402112494, 0, "Jan 01, 2024")
addEmote("Catwalk Walk Emote", 138140141577966, 0, "Jan 01, 2024")
addEmote("Funny Swing Dance", 76084854609830, 0, "Jan 01, 2024")
addEmote("ksuuvii stomp", 112923083487493, 0, "Jan 01, 2024")
addEmote("Tung Tung Sahur Dance", 95976013105001, 0, "Jan 01, 2024")
addEmote("dancey", 119165996226834, 0, "Jan 01, 2024")
addEmote("Ksuuvi Stomp", 113897299199810, 0, "Jan 01, 2024")
addEmote("Gravity Fall", 94097731532284, 0, "Jan 01, 2024")
addEmote("On The Floor!", 115194781501572, 0, "Jan 01, 2024")
addEmote("Ksuuvi Stomp", 76450279794933, 0, "Jan 01, 2024")
addEmote("Indigo Dance", 91949378726276, 0, "Jan 01, 2024")
addEmote("Gentle bow", 96044082127686, 0, "Jan 01, 2024")
addEmote("Everybody do the flop!", 109827173024588, 0, "Jan 01, 2024")
addEmote("Kawaii Cutesy Idle Stance", 118216877189739, 0, "Jan 01, 2024")
addEmote("Infinite Dab 🌌 (Loop)", 97468643012863, 0, "Jan 01, 2024")
addEmote("Devastation", 91773742002237, 0, "Jan 01, 2024")
addEmote("Ominously Floating", 120316401070725, 0, "Jan 01, 2024")
addEmote("kneel", 71088535340669, 0, "Jan 01, 2024")
addEmote("Forward Roll", 80604058872509, 0, "Jan 01, 2024")
addEmote("Ojosama Good Night Dance", 91280266755826, 0, "Jan 01, 2024")
addEmote("Shigure Ui Dance", 110780377889625, 0, "Jan 01, 2024")
addEmote("qinghai dance", 102125311424077, 0, "Jan 01, 2024")
addEmote("Oh who is you?", 81901231102965, 0, "Jan 01, 2024")
addEmote("Sit up ", 119535620422925, 0, "Jan 01, 2024")
addEmote("Play with your head", 108842562359823, 0, "Jan 01, 2024")
addEmote("Soft Headpats", 94014354724971, 0, "Jan 01, 2024")
addEmote("Heart Attack - Chuu Loona Kpop", 115666208034955, 0, "Jan 01, 2024")
addEmote("True Hearts Dance", 120599884212855, 0, "Jan 01, 2024")
addEmote("Box Transformation", 90877411599410, 0, "Jan 01, 2024")
addEmote("Billy Bounce - Trendy Game Dance", 104152009793753, 0, "Jan 01, 2024")
addEmote("Casual Sit", 101935805910670, 0, "Jan 01, 2024")
addEmote("Punch", 115991266516712, 0, "Jan 01, 2024")
addEmote("Cute Side Dance", 133675220586490, 0, "Jan 01, 2024")
addEmote("Ronaldo Running Suii + Flex", 87242794900326, 0, "Jan 01, 2024")
addEmote("Blow A Kiss", 136154192060455, 0, "Jan 01, 2024")
addEmote("Pogo Bounce", 92735097181162, 0, "Jan 01, 2024")
addEmote("Salsa Dance", 89377279527008, 0, "Jan 01, 2024")
addEmote("Tetoris", 82388619925452, 0, "Jan 01, 2024")
addEmote("Passo Bem Solto", 125608141255004, 0, "Jan 01, 2024")
addEmote("Makima Bang", 118277311545839, 0, "Jan 01, 2024")
addEmote("throwing da fours", 117116915106850, 0, "Jan 01, 2024")
addEmote("Mog", 106703002847605, 0, "Jan 01, 2024")
addEmote("Take a Bow - Head Pop Emote", 73589956406097, 0, "Jan 01, 2024")
addEmote("Apple Bottom", 136284095182210, 0, "Jan 01, 2024")
addEmote("Gojo", 117712669263778, 0, "Jan 01, 2024")
addEmote("Gold Ship Victory", 119167339057637, 0, "Jan 01, 2024")
addEmote("Trip Out", 137844868756845, 0, "Jan 01, 2024")
addEmote("Swing My Way", 106493966569540, 0, "Jan 01, 2024")
addEmote("Nino Paid Tang", 109859335187827, 0, "Jan 01, 2024")
addEmote("Bye Bye Bye", 118847796707360, 0, "Jan 01, 2024")
addEmote("touhou reisen overdrive dance", 127605015276307, 0, "Jan 01, 2024")
addEmote("Beat Da Koto Nai", 138876870600783, 0, "Jan 01, 2024")
addEmote("Goku Dance", 127578911872281, 0, "Jan 01, 2024")
addEmote("cruisin", 125423878887489, 0, "Jan 01, 2024")
addEmote("Pondering Sway", 81056473300058, 0, "Jan 01, 2024")
addEmote("Peeking around a wall", 88084183667457, 0, "Jan 01, 2024")
addEmote("Tell Me - Wonder Girls Emote", 71333538714612, 0, "Jan 01, 2024")
addEmote("Jay Guapo - Pink Cardigan Dance", 123099916894500, 0, "Jan 01, 2024")
addEmote("Pop Lock - Fortnite", 139450909659697, 0, "Jan 01, 2024")
addEmote("STATIC MIKU DANCE", 75131070738017, 0, "Jan 01, 2024")
addEmote("Airplane ✈️", 90519335037874, 0, "Jan 01, 2024")
addEmote("Head Pats", 85446776108314, 0, "Jan 01, 2024")
addEmote("Wavedash (Looped)", 95658424553737, 0, "Jan 01, 2024")
addEmote("Laugh", 131716439598402, 0, "Jan 01, 2024")
addEmote("Trump Dance", 79047426820642, 0, "Jan 01, 2024")
addEmote("Shrink", 103459372349309, 0, "Jan 01, 2024")
addEmote("IKUN铁山靠", 110070734801203, 0, "Jan 01, 2024")
addEmote("model pose", 124216474053602, 0, "Jan 01, 2024")
addEmote("Tung Sahur Meme Dance", 104336586165864, 0, "Jan 01, 2024")
addEmote("Pimp In Distress", 103133041192034, 0, "Jan 01, 2024")
addEmote("my head and legs gone D: (/e headless & korblox)", 85919650174858, 0, "Jan 01, 2024")
addEmote("Zombie (MM2)", 92687069941477, 0, "Jan 01, 2024")
addEmote("Zen", 106827384557894, 0, "Jan 01, 2024")
addEmote("Rolling Around", 106799957075671, 0, "Jan 01, 2024")
addEmote("Japanese Apology Bow", 85143829531506, 0, "Jan 01, 2024")
addEmote("Holding My Head, Idle Pose", 81963846624100, 0, "Jan 01, 2024")
addEmote("Ksuuvi Stomp", 93081915374913, 0, "Jan 01, 2024")
addEmote("I AM - IVE KPOP DANCE ", 119155413700869, 0, "Jan 01, 2024")
addEmote("Curious", 121184052355738, 0, "Jan 01, 2024")
addEmote("Nut", 118570422536620, 0, "Jan 01, 2024")
addEmote("Laugh It Up", 90599528248903, 0, "Jan 01, 2024")
addEmote("Philly Tanging", 121876788148794, 0, "Jan 01, 2024")
addEmote("Oh No! A Rat! 🐭", 102732450342492, 0, "Jan 01, 2024")
addEmote("Jewelry On The Belt", 80353785595785, 0, "Jan 01, 2024")
addEmote("Whisk", 93380426431815, 0, "Jan 01, 2024")
addEmote("Sit ", 70592831573365, 0, "Jan 01, 2024")
addEmote("Evil Levitation 😈", 80255482709987, 0, "Jan 01, 2024")
addEmote("sad laying sit", 72080895764849, 0, "Jan 01, 2024")
addEmote("Head Trickshot", 87830166153356, 0, "Jan 01, 2024")
addEmote("Epic Jumpscare Fail", 75886940708994, 0, "Jan 01, 2024")
addEmote("Soda Pop - Jinu Saja ", 131303292594150, 0, "Jan 01, 2024")
addEmote("Sitting Pretty", 84701030496267, 0, "Jan 01, 2024")
addEmote("⭐️ HELICOPTER", 94750615782066, 0, "Jan 01, 2024")
addEmote("GoAnimate Crying Dance", 110093424799298, 0, "Jan 01, 2024")
addEmote("💃 Smooth Dougie Dance Animation", 89629935776708, 0, "Jan 01, 2024")
addEmote("🤘 Rock star HeadBang Vibes Animation", 131663233812312, 0, "Jan 01, 2024")
addEmote("fist salute", 134904220873631, 0, "Jan 01, 2024")
addEmote("The Tycoon Experience", 119415899897014, 0, "Jan 01, 2024")
addEmote("Passinho Vibes", 72943359907902, 0, "Jan 01, 2024")
addEmote("hands up zombie dance", 104979558518020, 0, "Jan 01, 2024")
addEmote("Aura Floating Invicible Emote", 120161631085207, 0, "Jan 01, 2024")
addEmote("Yawn", 110187141653782, 0, "Jan 01, 2024")
addEmote("Thinking", 114831372643646, 0, "Jan 01, 2024")
addEmote("Dance If You're Peak", 134234875396315, 0, "Jan 01, 2024")
addEmote("Boat Aura Farm Dance", 125893066630866, 0, "Jan 01, 2024")
addEmote("Soccer Freak", 110605022973035, 0, "Jan 01, 2024")
addEmote("Planche Pose", 99863038389957, 0, "Jan 01, 2024")
addEmote("Say No!", 70685826349120, 0, "Jan 01, 2024")
addEmote("Twist Battle Royale Dance", 75062525194489, 0, "Jan 01, 2024")
addEmote("Trip Out", 85549933733036, 0, "Jan 01, 2024")
addEmote("Good Boy", 94808634393022, 0, "Jan 01, 2024")
addEmote("shhhhhh! quiet !", 112972796101717, 0, "Jan 01, 2024")
addEmote("Back It Up Dance", 77675456932873, 0, "Jan 01, 2024")
addEmote("Iconic Fashion Pose", 101171635782678, 0, "Jan 01, 2024")
addEmote("Haidilao Dance", 80694151999768, 0, "Jan 01, 2024")
addEmote("Dio - Jojo Pose", 80070292483347, 0, "Jan 01, 2024")
addEmote("Goku's Warm Up", 86300607690797, 0, "Jan 01, 2024")
addEmote("Restless Laying Relaxation", 88226485720370, 0, "Jan 01, 2024")
addEmote("Bicycle Kick", 88115324914988, 0, "Jan 01, 2024")
addEmote("Billy Bounce Battle Royale Dance", 129208547957108, 0, "Jan 01, 2024")
addEmote("test ☠️", 119000621743505, 0, "Jan 01, 2024")
addEmote("FREE 4 ME", 140669064422617, 0, "Jan 01, 2024")
addEmote("Ikun Basketball (鸡你太美)", 97367583729012, 0, "Jan 01, 2024")
addEmote("Golden Wind Torture Dance Animation", 93628260449595, 0, "Jan 01, 2024")
addEmote("Letter A", 124946008845063, 0, "Jan 01, 2024")
addEmote("Haidilao dance", 137589750725325, 0, "Jan 01, 2024")
addEmote("Super Shy Pose", 87584320387966, 0, "Jan 01, 2024")
addEmote("CR7 Calma Celebration", 94692231173912, 0, "Jan 01, 2024")
addEmote("Right Foot Left foot Slide", 131440218346109, 0, "Jan 01, 2024")
addEmote("MTE Dance", 138337675303354, 0, "Jan 01, 2024")
addEmote("nani daisuki", 83083793625826, 0, "Jan 01, 2024")
addEmote("Peter's Surfin Bird", 75081493219348, 0, "Jan 01, 2024")
addEmote("Cha Cha Slide", 120212822342205, 0, "Jan 01, 2024")
addEmote("Skirmish Technique", 107021970403836, 0, "Jan 01, 2024")
addEmote("Crab Walk", 131376314244364, 0, "Jan 01, 2024")
addEmote("Bowl Dance", 125299476604871, 0, "Jan 01, 2024")
addEmote("Stay Focus!", 95802865014232, 0, "Jan 01, 2024")
addEmote("Jevil Dance", 107997151513818, 0, "Jan 01, 2024")
addEmote("Tricep Flex", 105626567136590, 0, "Jan 01, 2024")
addEmote("On Sight", 99681814742635, 0, "Jan 01, 2024")
addEmote("Helicopter Helicopter", 89809225105730, 0, "Jan 01, 2024")
addEmote("Letter R", 137935492635719, 0, "Jan 01, 2024")
addEmote("Doki Doki Pose", 107583129005210, 0, "Jan 01, 2024")
addEmote("Wiggle Toes", 113157181055820, 0, "Jan 01, 2024")
addEmote("Spooky Month Dance", 92741647346340, 0, "Jan 01, 2024")
addEmote("Letter N", 90567775628137, 0, "Jan 01, 2024")
addEmote("Prince of egypt", 115279662672603, 0, "Jan 01, 2024")
addEmote("♡ i’m such a babydoll", 121784677396587, 0, "Jan 01, 2024")
addEmote("need to pee", 119777436036189, 0, "Jan 01, 2024")
addEmote("DIO Aura Farm Pose", 113770307959083, 0, "Jan 01, 2024")
addEmote("'Shimmer' Emote TT Dance", 137252092504330, 0, "Jan 01, 2024")
addEmote("Social Climber", 127279663836340, 0, "Jan 01, 2024")
addEmote("Sore Loser ", 73488657150830, 0, "Jan 01, 2024")
addEmote("Zombie Emote", 128071469092981, 0, "Jan 01, 2024")
addEmote("360° Walk", 83510784123037, 0, "Jan 01, 2024")
addEmote("Spin and Dab", 96351954577924, 0, "Jan 01, 2024")
addEmote("Noclip", 77348014194310, 0, "Jan 01, 2024")
addEmote("Shake Your Dreads", 128048762096194, 0, "Jan 01, 2024")
addEmote("Turtle Mode", 85424817784684, 0, "Jan 01, 2024")
addEmote("Flex", 85460352877967, 0, "Jan 01, 2024")
addEmote("GPO Type Dance", 125355196317343, 0, "Jan 01, 2024")
addEmote("Killua Pose", 134509903607756, 0, "Jan 01, 2024")
addEmote("Head Pats!", 72965754387238, 0, "Jan 01, 2024")
addEmote("Swerve Dance", 84835086898654, 0, "Jan 01, 2024")
addEmote("Greet", 77040161881896, 0, "Jan 01, 2024")
addEmote("Freaky Creature", 84410301387830, 0, "Jan 01, 2024")
addEmote("AURA Boat Farming", 95778953155838, 0, "Jan 01, 2024")
addEmote("wait they don't love you like i love you - dance e", 89062249850435, 0, "Jan 01, 2024")
addEmote("CT Shimmy", 140432834386745, 0, "Jan 01, 2024")
addEmote("Touhou Orin Dance", 77617925946896, 0, "Jan 01, 2024")
addEmote(" Show Off", 75014362722327, 0, "Jan 01, 2024")
addEmote("Oh... It don’t work...", 128120617110183, 0, "Jan 01, 2024")
addEmote("Yawning", 134136515482353, 0, "Jan 01, 2024")
addEmote("NPC Clapping", 116926255794575, 0, "Jan 01, 2024")
addEmote("Baki Pose", 78845845163712, 0, "Jan 01, 2024")
addEmote("The Dance", 128151308322595, 0, "Jan 01, 2024")
addEmote("Vecna Stranger Things Fly Animation Emote Bone", 90555063826230, 0, "Jan 01, 2024")
addEmote("I've Played These Game Before", 135398292850081, 0, "Jan 01, 2024")
addEmote("Running Man Challenge 🕺", 134715278725664, 0, "Jan 01, 2024")
addEmote("Fake Death", 126681799362179, 0, "Jan 01, 2024")
addEmote("Anime Shy Nervous Finger Point", 134613444849467, 0, "Jan 01, 2024")
addEmote("chicken nugget dance", 119839090121583, 0, "Jan 01, 2024")
addEmote("Point", 130697779113271, 0, "Jan 01, 2024")
addEmote("Bobby Bounce", 106586292365266, 0, "Jan 01, 2024")
addEmote("Sypher Strut", 138438681240594, 0, "Jan 01, 2024")
addEmote("Hand Slap", 124431758412178, 0, "Jan 01, 2024")
addEmote("Sturdy", 96003501928197, 0, "Jan 01, 2024")
addEmote("L Dance", 73039500693145, 0, "Jan 01, 2024")
addEmote("Wait", 90506725746533, 0, "Jan 01, 2024")
addEmote("go worm", 130549293453304, 0, "Jan 01, 2024")
addEmote("Body Party X Nani Haski", 116832166576495, 0, "Jan 01, 2024")
addEmote("Blue Lock - Rin Aura Farm", 97006162210691, 0, "Jan 01, 2024")
addEmote("Goofy Run", 102162365907728, 0, "Jan 01, 2024")
addEmote("Head Spinner", 134676902908856, 0, "Jan 01, 2024")
addEmote("Motorcycle Dance", 124842237987026, 0, "Jan 01, 2024")
addEmote("The Real Slim Shady", 132675336225043, 0, "Jan 01, 2024")
addEmote("Ashton Hall Run!", 84893826817799, 0, "Jan 01, 2024")
addEmote("sit kick!", 89620666331816, 0, "Jan 01, 2024")
addEmote("I'm Going to Turn into a Truck Now", 108323230076036, 0, "Jan 01, 2024")
addEmote("Front Flip", 116728799092339, 0, "Jan 01, 2024")
addEmote("Floor Gazing", 139797221207451, 0, "Jan 01, 2024")
addEmote(" Ay we want ay we want some (ZEDDY)", 83955931533501, 0, "Jan 01, 2024")
addEmote("Gravitational Pull", 128356155229811, 0, "Jan 01, 2024")
addEmote("Do The Plumber", 107813079733633, 0, "Jan 01, 2024")
addEmote("Aura Farming ", 122068746143600, 0, "Jan 01, 2024")
addEmote("Robotic Head Twitch", 101122983307723, 0, "Jan 01, 2024")
addEmote("Mandatory tiktok dance", 104977035088082, 0, "Jan 01, 2024")
addEmote("Getting hit by Bullet", 121290000278494, 0, "Jan 01, 2024")
addEmote("Silencer ", 86331309972512, 0, "Jan 01, 2024")
addEmote("I’m Talm Bout Innit", 104481790156047, 0, "Jan 01, 2024")
addEmote("Blockify", 132513739682404, 0, "Jan 01, 2024")
addEmote("Hug Emote", 84644749931631, 0, "Jan 01, 2024")
addEmote("Silly cutesy spinning emote", 118515230373845, 0, "Jan 01, 2024")
addEmote("📦 Cute Blocky Bounce", 94556460499025, 0, "Jan 01, 2024")
addEmote("What.", 91330698401026, 0, "Jan 01, 2024")
addEmote("Knee Bounce", 90143155263723, 0, "Jan 01, 2024")
addEmote("bumble bee dance emote ", 131053255275257, 0, "Jan 01, 2024")
addEmote("Jotaro JoJo", 82799669287329, 0, "Jan 01, 2024")
addEmote("Jolly Walking", 108909280323688, 0, "Jan 01, 2024")
addEmote("Star Gazin", 128587788881198, 0, "Jan 01, 2024")
addEmote("Lady Gaga - Just Dance Emote", 109940239665469, 0, "Jan 01, 2024")
addEmote("PIANO TILES TREND (LIMITED TIME) ", 102077049561224, 0, "Jan 01, 2024")
addEmote("Tornado Emote", 82995540773684, 0, "Jan 01, 2024")
addEmote("Human Tornado", 95466351204687, 0, "Jan 01, 2024")
addEmote("Xaviersobased", 78477078204699, 0, "Jan 01, 2024")
addEmote("Invisible", 114216612738251, 0, "Jan 01, 2024")
addEmote("6-7", 106367055475970, 0, "Jan 01, 2024")
addEmote("Hide and Seek Emote (WORKS)", 82762227768002, 0, "Jan 01, 2024")
addEmote("Take the L", 125661832645257, 0, "Jan 01, 2024")
addEmote("Feeling Cute", 112540347880956, 0, "Jan 01, 2024")
addEmote("67", 73117048169324, 0, "Jan 01, 2024")
addEmote("⏳ [LIMITED] Headless Archer", 114844947920958, 0, "Jan 01, 2024")
addEmote("kawaii cat doll neko pose (3.0)", 82071921576283, 0, "Jan 01, 2024")
addEmote("No Clip ", 82596051258096, 0, "Jan 01, 2024")
addEmote("Take The L", 104021865187479, 0, "Jan 01, 2024")
addEmote("6 7 67", 132003818719121, 0, "Jan 01, 2024")
addEmote("Hai Phut Hon (Zero Two Dance)", 120600912309171, 0, "Jan 01, 2024")
addEmote("Cute Roblox Profile Pose", 129838364671769, 0, "Jan 01, 2024")
addEmote("MOSH", 118307905798773, 0, "Jan 01, 2024")
addEmote("L Dance", 114846964045392, 0, "Jan 01, 2024")
addEmote("PhutHon", 124487350993833, 0, "Jan 01, 2024")
addEmote("Princess Sit", 85370173309996, 0, "Jan 01, 2024")
addEmote("Soda Pop", 105669765010094, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 129335360250500, 0, "Jan 01, 2024")
addEmote("Zen", 84943987730610, 0, "Jan 01, 2024")
addEmote("Caramelldansen [ORIGINAL]", 74526731193623, 0, "Jan 01, 2024")
addEmote("Seizure", 100707837513848, 0, "Jan 01, 2024")
addEmote("Take The L", 127153885318069, 0, "Jan 01, 2024")
addEmote("Spin", 109911619869564, 0, "Jan 01, 2024")
addEmote("2 Phut Hon (Zero Two)", 76692572319000, 0, "Jan 01, 2024")
addEmote("Box", 101661958586425, 0, "Jan 01, 2024")
addEmote("Helicopter (Admin Command)", 110553756436163, 0, "Jan 01, 2024")
addEmote("[Become A Car] Vroom Vroom", 133231268007096, 0, "Jan 01, 2024")
addEmote("Nightmare Emote", 131626648386859, 0, "Jan 01, 2024")
addEmote("Torture Dance JoJo", 76119197893969, 0, "Jan 01, 2024")
addEmote("Caramelldansen", 132830117265471, 0, "Jan 01, 2024")
addEmote("Kuv Me Nplooj Siab", 140448052390909, 0, "Jan 01, 2024")
addEmote("꒰ Laying On The Floorsies :3 ꒱", 130821790972251, 0, "Jan 01, 2024")
addEmote("Miku Live", 99038386766744, 0, "Jan 01, 2024")
addEmote("Where did my head go?", 73339853458294, 0, "Jan 01, 2024")
addEmote("Take The L", 108288688454843, 0, "Jan 01, 2024")
addEmote("[R15] Miku Idle Pose Emose", 74402735640939, 0, "Jan 01, 2024")
addEmote("kicking feet laying down happily", 130019111597730, 0, "Jan 01, 2024")
addEmote("Thinking (Isagi)", 103162956032198, 0, "Jan 01, 2024")
addEmote("Groovy Hip Sway", 122761960526769, 0, "Jan 01, 2024")
addEmote("Crouch Dance", 135432046959698, 0, "Jan 01, 2024")
addEmote("Pointing", 94877813328389, 0, "Jan 01, 2024")
addEmote("ExtraL", 75889186598577, 0, "Jan 01, 2024")
addEmote("Be a Wheel", 104135557075237, 0, "Jan 01, 2024")
addEmote("NOOB ", 137578025357411, 0, "Jan 01, 2024")
addEmote("Funny Rocket", 86138967571122, 0, "Jan 01, 2024")
addEmote("Windmill arms", 127809954406100, 0, "Jan 01, 2024")
addEmote("Nonchalant Aura Filled Dance", 80035199697503, 0, "Jan 01, 2024")
addEmote("Airplane Animation", 134130303174519, 0, "Jan 01, 2024")
addEmote("Building Blocks", 131112588471825, 0, "Jan 01, 2024")
addEmote("Low Gravity", 77316188156864, 0, "Jan 01, 2024")
addEmote("Adorable Sit", 75351140540467, 0, "Jan 01, 2024")
addEmote("Cha Cha Dance", 115618663169342, 0, "Jan 01, 2024")
addEmote("Mamushi", 119618861452009, 0, "Jan 01, 2024")
addEmote("Jojo WRYYYYYY", 140379944739378, 0, "Jan 01, 2024")
addEmote("Classic dance potion anim", 109337167828971, 0, "Jan 01, 2024")
addEmote("Kawaii Cutie Pose", 73927005883840, 0, "Jan 01, 2024")
addEmote("Leg Kick Dance", 128229084108072, 0, "Jan 01, 2024")
addEmote("Peter hurting knee ", 79293310206765, 0, "Jan 01, 2024")
addEmote("Become a Shark", 84393817902488, 0, "Jan 01, 2024")
addEmote("Aura Sit [KING BALDWIN]", 130945705946614, 0, "Jan 01, 2024")
addEmote("Smile :)", 73625046629347, 0, "Jan 01, 2024")
addEmote("Booger Picker", 128233047687518, 0, "Jan 01, 2024")
addEmote("Satoru Gojo Aura Farming", 125929212309800, 0, "Jan 01, 2024")
addEmote("Direct Celebration", 95823510562051, 0, "Jan 01, 2024")
addEmote("Zen Float Sit", 125863233934366, 0, "Jan 01, 2024")
addEmote("Girly Pop Sway", 132821805289579, 0, "Jan 01, 2024")
addEmote("Facepalm", 116894206473799, 0, "Jan 01, 2024")
addEmote("im talking bout INNIT", 80196552451270, 0, "Jan 01, 2024")
addEmote("Saiyan Saga Vegeta’s Fighting Stance", 94418839263748, 0, "Jan 01, 2024")
addEmote("Popular Vibe", 101173103368962, 0, "Jan 01, 2024")
addEmote("Sit/Chill Emote", 110223989203265, 0, "Jan 01, 2024")
addEmote("Slip and fall", 84807803301024, 0, "Jan 01, 2024")
addEmote("This dance goes hard", 109910154206713, 0, "Jan 01, 2024")
addEmote("[ORIGINAL] SIX SEVEN - 67 EMOTE", 132746944328336, 0, "Jan 01, 2024")
addEmote("Robotic Wave", 109708652740041, 0, "Jan 01, 2024")
addEmote("Toy Jumpscare", 132490580443941, 0, "Jan 01, 2024")
addEmote("meme / AI Cat Dance", 138365808904537, 0, "Jan 01, 2024")
addEmote("Runaway", 85944829468832, 0, "Jan 01, 2024")
addEmote("Slippin' Face Plant", 82987055875430, 0, "Jan 01, 2024")
addEmote("voltereta hacia delante", 77530544872701, 0, "Jan 01, 2024")
addEmote("Rick Roll", 136988673134455, 0, "Jan 01, 2024")
addEmote("SuperHero Flying Pose", 110793654858495, 0, "Jan 01, 2024")
addEmote("Cow Boy Dance", 113810464386346, 0, "Jan 01, 2024")
addEmote("Deo WRY", 134101863752554, 0, "Jan 01, 2024")
addEmote("Woah Woah Woah Dance (Slow Mo)", 140250466408749, 0, "Jan 01, 2024")
addEmote("Louisiana Jig Dance", 91161452334444, 0, "Jan 01, 2024")
addEmote("Default Dance", 119589267646701, 0, "Jan 01, 2024")
addEmote("Chinese Dance", 96509082352508, 0, "Jan 01, 2024")
addEmote("Anime Sit (Madara)", 126756161169779, 0, "Jan 01, 2024")
addEmote("Levitate", 76363444114652, 0, "Jan 01, 2024")
addEmote("Dani's Tyla", 109467605081216, 0, "Jan 01, 2024")
addEmote("Swinging In Air", 126920396044171, 0, "Jan 01, 2024")
addEmote("Side Shuffle", 131780079773405, 0, "Jan 01, 2024")
addEmote("♡ cutesy jumpy jump in the air", 115234415933099, 0, "Jan 01, 2024")
addEmote("Hold Something", 118723659557999, 0, "Jan 01, 2024")
addEmote("Universal Toad Dance", 110964800504038, 0, "Jan 01, 2024")
addEmote("Tell Me, Tell Me! - Wonder Girls", 112118419325053, 0, "Jan 01, 2024")







--wait for emotes to finish loading



local function EmotesLoaded()

	for i, loaded in pairs(LoadedEmotes) do

		if not loaded then

			return false

		end

	end

	return true

end

while not EmotesLoaded() do

	task.wait()

end

Loading:Destroy()



--sorting options setup

table.sort(Emotes, function(a, b)

	return a.lastupdated > b.lastupdated

end)

for i,v in pairs(Emotes) do

	v.sort.recentfirst = i

end



table.sort(Emotes, function(a, b)

	return a.lastupdated < b.lastupdated

end)

for i,v in pairs(Emotes) do

	v.sort.recentlast = i

end



table.sort(Emotes, function(a, b)

	return a.name:lower() < b.name:lower()

end)

for i,v in pairs(Emotes) do

	v.sort.alphabeticfirst = i

end



table.sort(Emotes, function(a, b)

	return a.name:lower() > b.name:lower()

end)

for i,v in pairs(Emotes) do

	v.sort.alphabeticlast = i

end



table.sort(Emotes, function(a, b)

	return a.price < b.price

end)

for i,v in pairs(Emotes) do

	v.sort.lowestprice = i

end



table.sort(Emotes, function(a, b)

	return a.price > b.price

end)

for i,v in pairs(Emotes) do

	v.sort.highestprice = i

end



if isfile("FavoritedEmotes.txt") then

	if not pcall(function()

		FavoritedEmotes = HttpService:JSONDecode(readfile("FavoritedEmotes.txt"))

	end) then

		FavoritedEmotes = {}

	end

else

	writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))

end



local UpdatedFavorites = {}

for i,name in pairs(FavoritedEmotes) do

	if typeof(name) == "string" then

		for i,emote in pairs(Emotes) do

			if emote.name == name then

				table.insert(UpdatedFavorites, emote.id)

				break

			end

		end

	end

end

if #UpdatedFavorites ~= 0 then

	FavoritedEmotes = UpdatedFavorites

	writefile("FavoritedEmotes.txt", HttpService:JSONEncode(FavoritedEmotes))

end



local function CharacterAdded(Character)

	for i,v in pairs(Frame:GetChildren()) do

		if not v:IsA("UIGridLayout") then

			v:Destroy()

		end

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

	random.MouseEnter:Connect(function()

		EmoteName.Text = "Random"

	end)

	random.Parent = Frame

	for i,Emote in pairs(Emotes) do

		Description:AddEmote(Emote.name, Emote.id)

		local EmoteButton = Instance.new("ImageButton")

		local IsFavorited = table.find(FavoritedEmotes, Emote.id)

		EmoteButton.LayoutOrder = Emote.sort[CurrentSort] + ((IsFavorited and 0) or #Emotes)

		EmoteButton.Name = Emote.id

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

		if table.find(FavoritedEmotes, Emote.id) then

			Favorite.Image = FavoriteOn

		else

			Favorite.Image = FavoriteOff

		end

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



if LocalPlayer.Character then

	CharacterAdded(LocalPlayer.Character)

end

LocalPlayer.CharacterAdded:Connect(CharacterAdded)



wait(1)





game.CoreGui.Emotes.Enabled = true



game:GetService("StarterGui"):SetCore("SendNotification",{

                Title = "Done!",

                Text = "Emotes gui is here!",

                 Duration = 10})



game.Players.LocalPlayer.PlayerGui.ContextActionGui:Destroy()
