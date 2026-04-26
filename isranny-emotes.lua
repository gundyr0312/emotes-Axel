-- // SYSTEM BROKEN | UNIVERSAL EMOTES (50K+ COMPATIBLE)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Asegurar persistencia y limpiar versiones viejas
if player:WaitForChild("PlayerGui"):FindFirstChild("SB_Emotes") then
    player.PlayerGui.SB_Emotes:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SB_Emotes"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA "E" (Draggable & Black)
local bubble = Instance.new("TextButton", gui)
bubble.Size = UDim2.new(0, 45, 0, 45)
bubble.Position = UDim2.new(0, 20, 0.2, 0)
bubble.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 24
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0)
local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(50, 50, 50)
bStroke.Thickness = 2

-- // PANEL PRINCIPAL (Diseño System Broken)
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0.5, -140, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = false
main.Active = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 8)

-- Encabezado
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local hCorner = Instance.new("UICorner", header)
hCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "System Broken | Emotes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

-- BARRA DE BÚSQUEDA (Para manejar los 50k emotes)
local searchBox = Instance.new("TextBox", main)
searchBox.Size = UDim2.new(1, -20, 0, 30)
searchBox.Position = UDim2.new(0, 10, 0, 50)
searchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
searchBox.PlaceholderText = "Search 50,000+ emotes..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14

local sCorner = Instance.new("UICorner", searchBox)
sCorner.CornerRadius = UDim.new(0, 4)

-- Contenedor con Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -10, 1, -135)
scroll.Position = UDim2.new(0, 5, 0, 90)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón Cyan "Free Emotes"
local freeBtn = Instance.new("TextButton", main)
freeBtn.Size = UDim2.new(0, 120, 0, 30)
freeBtn.Position = UDim2.new(1, -130, 1, -35)
freeBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 230)
freeBtn.Text = "Free emotes"
freeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 13

local fCorner = Instance.new("UICorner", freeBtn)
fCorner.CornerRadius = UDim.new(0, 5)

-- // LÓGICA DE DATOS (Basada en 7yd7 / emotes.txt)
local allEmotes = {}

-- Función para cargar la base de datos masiva
local function LoadEmoteDatabase()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/EmoteList.json"))
    end)
    if success and result then
        allEmotes = result
        print("System Broken: " .. #allEmotes .. " emotes cargados.")
    end
end

local function RenderEmotes(filter)
    for _, child in pairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    for name, id in pairs(allEmotes) do
        if count > 100 then break end -- Limite visual para evitar lag
        if not filter or string.find(string.lower(name), string.lower(filter)) then
            count = count + 1
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(0.9, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 13
            
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            btn.MouseButton1Click:Connect(function()
                pcall(function()
                    game:GetService("GuiService"):PlayEmote(name)
                end)
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, count * 40)
end

-- // EVENTOS
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    RenderEmotes(searchBox.Text)
end)

bubble.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

freeBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/7yd7/Hub/refs/heads/Branch/GUIS/Emote.lua"))()
end)

-- Draggable logic
local dragging, dragStart, startPos
bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Iniciar
task.spawn(LoadEmoteDatabase)
RenderEmotes()
