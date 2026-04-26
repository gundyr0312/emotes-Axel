-- // ISRANNY EMOTES GUI - SYSTEM BROKEN EXACT EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Asegurar persistencia y limpieza
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannyEmotesGUI") then
    player.PlayerGui.IsrannyEmotesGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IsrannyEmotesGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA FLOTANTE "E" (Diseño solicitado)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "MainBubble"
bubble.Size = UDim2.new(0, 40, 0, 40)
bubble.Position = UDim2.new(0.05, 0, 0.4, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bubble.Text = "E"
bubble.TextSize = 20
bubble.Font = Enum.Font.GothamBold
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.ZIndex = 10

local bubbleCorner = Instance.new("UICorner", bubble)
bubbleCorner.CornerRadius = UDim.new(1, 0)

local bubbleStroke = Instance.new("UIStroke", bubble)
bubbleStroke.Color = Color3.fromRGB(60, 60, 60)
bubbleStroke.Thickness = 1.5

-- // PANEL DE EMOTES (Diseño Default de System Broken)
local frame = Instance.new("Frame", gui)
frame.Name = "EmotePanel"
frame.Size = UDim2.new(0, 230, 0, 310)
frame.Position = UDim2.new(0.5, -115, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 38)
title.Text = "ISRANNY EMOTES (SB)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 4, 0) -- Canvas grande para todos los emotes
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // LÓGICA DE EMOTES (Extraída de System Broken)
local function PlayEmote(name)
    pcall(function()
        game:GetService("GuiService"):PlayEmote(name)
    end)
end

-- Lista Exacta de Emotes de System Broken
local emotesList = {
    "Old Town Road", "Rekt", "Monkey", "Smooth Criminal", "Hype", "Orange Justice",
    "Default Dance", "Billy Bounce", "Dab", "Floss", "Take The L", "Best Mates",
    "Robot", "Fresh", "Groove Jam", "Tidy", "Running Man", "Confused", "Hot Marat",
    "Bust A Move", "Electro Shuffle", "Hula", "Infinite Dab", "Laugh It Up",
    "Dance", "Joyful", "Shrug", "Tilt", "Stadium", "Salute", "Point", "Wave", 
    "Laugh", "Cheer", "Applaud"
}

-- Crear Botones Estilo Default
for _, emote in pairs(emotesList) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 32)
    btn.Text = emote
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        PlayEmote(emote)
    end)
end

-- // INTERACCIONES (Abrir y Arrastrar)
bubble.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Movimiento de la Burbuja
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

print("✅ ISRANNY EMOTES GUI: Diseño System Broken cargado con burbuja negra 'E'.")
