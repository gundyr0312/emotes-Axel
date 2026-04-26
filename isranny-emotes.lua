-- // ISRANNY EMOTES GUI - V2 (Burbuja Flotante y Persistencia)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Eliminar versión previa si existe para evitar duplicados
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannyEmotesGUI") then
    player.PlayerGui.IsrannyEmotesGUI:Destroy()
end

-- // INTERFAZ PRINCIPAL
local gui = Instance.new("ScreenGui")
gui.Name = "IsrannyEmotesGUI"
gui.ResetOnSpawn = false -- CRÍTICO: No se borra al morir
gui.DisplayOrder = 10
gui.Parent = player:WaitForChild("PlayerGui")

-- // BOTÓN FLOTANTE (Círculo)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "MainBubble"
bubble.Size = UDim2.new(0, 50, 0, 50)
bubble.Position = UDim2.new(0.1, 0, 0.5, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 255, 120) -- Color llamativo
bubble.Text = "🕺"
bubble.TextSize = 25
bubble.Font = Enum.Font.GothamBold
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.ZIndex = 10

local bubbleCorner = Instance.new("UICorner", bubble)
bubbleCorner.CornerRadius = UDim.new(1, 0) -- Lo hace un círculo perfecto

local bubbleStroke = Instance.new("UIStroke", bubble)
bubbleStroke.Color = Color3.fromRGB(255, 255, 255)
bubbleStroke.Thickness = 2

-- // PANEL DE EMOTES (Oculto al inicio)
local frame = Instance.new("Frame", gui)
frame.Name = "EmotePanel"
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Visible = false -- Inicia oculto
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ISRANNY EMOTES"
title.TextColor3 = Color3.fromRGB(0, 255, 120)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16

-- // SCROLL DE EMOTES
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón de Minimizar (Dentro del panel)
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.Text = "_"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.BackgroundTransparency = 1
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 20

-- // LÓGICA DE INTERACCIÓN
local function PlayEmote(name)
    pcall(function()
        game:GetService("GuiService"):PlayEmote(name)
    end)
end

-- Abrir/Cerrar
bubble.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

minBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Hacer la burbuja movible (Drag)
local dragging, dragInput, dragStart, startPos
bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = bubble.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Generar Botones de Emotes
local emotes = {"Dance", "Joyful", "Shrug", "Tilt", "Stadium", "Salute", "Point", "Wave", "Laugh", "Cheer", "Applaud"}

for _, name in pairs(emotes) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function() PlayEmote(name) end)
end

print("✅ Isranny Emotes V2: Burbuja flotante activa y persistente.")
