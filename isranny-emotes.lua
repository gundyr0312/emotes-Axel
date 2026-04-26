-- // ISRANNY EMOTES - REPLICA TOTAL (DESIGN SYSTEM BROKEN)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Persistencia total
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannySystemBroken") then
    player.PlayerGui.IsrannySystemBroken:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IsrannySystemBroken"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA "E" (Réplica exacta de la esquina superior izquierda)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "Trigger"
bubble.Size = UDim2.new(0, 44, 0, 44)
bubble.Position = UDim2.new(0, 20, 0, 20) -- Posición de la foto
bubble.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 24
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0)

local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(255, 255, 255)
bStroke.Thickness = 1.8

-- // PANEL PRINCIPAL (Diseño exacto de la foto)
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 260, 0, 360)
main.Position = UDim2.new(0.5, -130, 0.5, -180)
main.BackgroundColor3 = Color3.fromRGB(24, 25, 28) -- Gris oscuro de la imagen
main.BorderSizePixel = 0
main.Visible = false
main.Active = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 8)

-- Header (Gris grafito más claro)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(48, 50, 54)
header.BorderSizePixel = 0

local hCorner = Instance.new("UICorner", header)
hCorner.CornerRadius = UDim.new(0, 8)

-- Título con la fuente de la imagen
local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "System Broken | Emotes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Contenedor de lista (ScrollingFrame)
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -12, 1, -100)
scroll.Position = UDim2.new(0, 6, 0, 50)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.CanvasSize = UDim2.new(0, 0, 2.8, 0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón Cyan "Free emotes" (Idéntico a la foto)
local freeBtn = Instance.new("TextButton", main)
freeBtn.Size = UDim2.new(0, 110, 0, 32)
freeBtn.Position = UDim2.new(1, -118, 1, -42)
freeBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 255) -- Cyan eléctrico
freeBtn.Text = "Free emotes"
freeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 14

local fCorner = Instance.new("UICorner", freeBtn)
fCorner.CornerRadius = UDim.new(0, 5)

-- // LISTA DE EMOTES (Nombres exactos de tu captura)
local emotes = {
    "Orange Justice", "Billy Bounce", "Electro Shuffle", "Hype", "Default Dance",
    "Dab", "Best Mates", "Reaf Mane", "Just Mane", "Dab Linde", "Best Wads",
    "Show Lock", "Harat Gant", "Uly Range"
}

for _, name in pairs(emotes) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.96, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(40, 42, 46) -- Botones de la foto
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    
    local bC = Instance.new("UICorner", btn)
    bC.CornerRadius = UDim.new(0, 5)
    
    btn.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):PlayEmote(name) end)
    end)
end

-- // INTERACCIONES
bubble.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

freeBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AllEmotes"))()
end)

-- Sistema de arrastre para la burbuja
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
