-- // ISRANNY EMOTES GUI - V3 (SYSTEM BROKEN EDITION)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Limpieza de versiones anteriores
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannyEmotesGUI") then
    player.PlayerGui.IsrannyEmotesGUI:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IsrannyEmotesGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA FLOTANTE (Negra, pequeña, con una "E")
local bubble = Instance.new("TextButton", gui)
bubble.Name = "MainBubble"
bubble.Size = UDim2.new(0, 40, 0, 40) -- Más pequeña
bubble.Position = UDim2.new(0.1, 0, 0.5, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Negro
bubble.Text = "E"
bubble.TextSize = 20
bubble.Font = Enum.Font.GothamBold
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.ZIndex = 10

local bubbleCorner = Instance.new("UICorner", bubble)
bubbleCorner.CornerRadius = UDim.new(1, 0)

local bubbleStroke = Instance.new("UIStroke", bubble)
bubbleStroke.Color = Color3.fromRGB(50, 50, 50)
bubbleStroke.Thickness = 1.5

-- // PANEL DE EMOTES (Estilo System Broken)
local frame = Instance.new("Frame", gui)
frame.Name = "EmotePanel"
frame.Size = UDim2.new(0, 220, 0, 280)
frame.Position = UDim2.new(0.5, -110, 0.5, -140)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Visible = false
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "ISR-EMOTES (SB)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Font = Enum.Font.GothamBlack
title.TextSize = 14

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -15, 1, -50)
scroll.Position = UDim2.new(0, 7.5, 0, 42)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 3.5, 0) -- Espacio para muchos emotes
scroll.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // LISTA DE EMOTES EXTRAÍDA DE SYSTEM BROKEN
local sbEmotes = {
    "Old Town Road", "Rekt", "Monkey", "Smooth Criminal", "Hype", "Orange Justice",
    "Default Dance", "Billy Bounce", "Dab", "Floss", "Take The L", "Best Mates",
    "Robot", "Fresh", "Groove Jam", "Tidy", "Running Man", "Confused", "Hot Marat",
    "Bust A Move", "Electro Shuffle", "Hula", "Infinite Dab", "Laugh It Up"
}

local function PlayEmote(name)
    pcall(function()
        game:GetService("GuiService"):PlayEmote(name)
    end)
end

-- Abrir/Cerrar y Arrastrar
bubble.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

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

-- Generar botones con el estilo de SB
for _, name in pairs(sbEmotes) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function() PlayEmote(name) end)
end

print("🔥 Isranny Emotes (SB Version) Cargado. Burbuja 'E' activa.")
