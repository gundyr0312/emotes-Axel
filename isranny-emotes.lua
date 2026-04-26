-- // ISRANNY EMOTES GUI - REPLICA EXACTA
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Persistencia y Limpieza
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannyEmotesGUI") then
    player.PlayerGui.IsrannyEmotesGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IsrannyEmotesGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA "E" (ACCESO)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "Trigger"
bubble.Size = UDim2.new(0, 45, 0, 45)
bubble.Position = UDim2.new(0, 20, 0.1, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 22
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0)

local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(60, 60, 60)
bStroke.Thickness = 2

-- // PANEL PRINCIPAL (REPLICA)
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(30, 32, 35)
main.BorderSizePixel = 0
main.Visible = false
main.Active = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 8)

-- Header
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(50, 52, 55)
topBar.BorderSizePixel = 0

local tCorner = Instance.new("UICorner", topBar)
tCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "System Broken | Emotes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Contenedor de Botones
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -95)
scroll.Position = UDim2.new(0, 10, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
scroll.CanvasSize = UDim2.new(0, 0, 5, 0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón Inferior "Free emotes"
local freeBtn = Instance.new("TextButton", main)
freeBtn.Size = UDim2.new(0, 100, 0, 30)
freeBtn.Position = UDim2.new(1, -110, 1, -40)
freeBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 200)
freeBtn.Text = "Free emotes"
freeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 13

local fCorner = Instance.new("UICorner", freeBtn)
fCorner.CornerRadius = UDim.new(0, 4)

-- // LÓGICA DE EMOTES
local function Play(name)
    pcall(function()
        game:GetService("GuiService"):PlayEmote(name)
    end)
end

local emotesList = {
    "Orange Justice", "Billy Bounce", "Electro Shuffle", "Hype", "Default Dance",
    "Dab", "Best Mates", "Old Town Road", "Rekt", "Monkey", "Smooth Criminal",
    "Floss", "Take The L", "Robot", "Fresh", "Groove Jam", "Tidy", "Running Man",
    "Confused", "Hot Marat", "Bust A Move", "Hula", "Infinite Dab", "Laugh It Up"
}

for _, name in pairs(emotesList) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.98, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(45, 47, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    
    local bC = Instance.new("UICorner", btn)
    bC.CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function() Play(name) end)
end

-- // INTERACCIONES
bubble.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

freeBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AllEmotes"))()
end)

-- Arrastrar Burbuja
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
