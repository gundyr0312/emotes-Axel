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
