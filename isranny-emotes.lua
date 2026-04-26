-- // REPLICA EXACTA DE GUI "SYSTEM BROKEN | EMOTES" (SB DESIGN)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Asegurar persistencia (No se borra al morir)
if player:WaitForChild("PlayerGui"):FindFirstChild("SB_Emotes_Replica") then
    player.PlayerGui.SB_Emotes_Replica:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SB_Emotes_Replica"
gui.ResetOnSpawn = false -- Crítico para que no desaparezca
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA "E" DE ACCESO (Diseño de la foto)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "Trigger"
bubble.Size = UDim2.new(0, 42, 0, 42)
bubble.Position = UDim2.new(0, 15, 0.15, 0) -- Top left, como en la foto
bubble.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Negro profundo
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 22
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0) -- Círculo perfecto

local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(255, 255, 255) -- Borde blanco
bStroke.Thickness = 1.5

-- // PANEL PRINCIPAL (Réplica exacta de la imagen)
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 240, 0, 330) -- Tamaño proporcional a la foto
main.Position = UDim2.new(0.5, -120, 0.5, -165) -- Centrado
main.BackgroundColor3 = Color3.fromRGB(28, 28, 32) -- Gris carbón oscuro de la imagen
main.BorderSizePixel = 0
main.Visible = false
main.Active = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 6)

-- Header (Gris SB, más claro que el fondo)
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 36)
header.BackgroundColor3 = Color3.fromRGB(48, 48, 52) -- Color de la barra superior
header.BorderSizePixel = 0

local hCorner = Instance.new("UICorner", header)
hCorner.CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "System Broken | Emotes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15

-- Contenedor de Emotes con Scroll
local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -12, 1, -85)
scroll.Position = UDim2.new(0, 6, 0, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
scroll.CanvasSize = UDim2.new(0, 0, 2.5, 0) -- Espacio para la lista

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 4)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón Cyan "Free emotes" (Exacto a la foto)
local freeBtn = Instance.new("TextButton", main)
freeBtn.Size = UDim2.new(0, 95, 0, 26)
freeBtn.Position = UDim2.new(1, -105, 1, -35) -- Bottom right, como en la foto
freeBtn.BackgroundColor3 = Color3.fromRGB(0, 210, 230) -- Color Cyan exacto
freeBtn.Text = "Free emotes"
freeBtn.TextColor3 = Color3.fromRGB(0, 0, 0) -- Texto negro en el cyan
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 12

local fCorner = Instance.new("UICorner", freeBtn)
fCorner.CornerRadius = UDim.new(0, 4)

-- // LISTA DE EMOTES (Lista EXACTA de la imagen)
local emotes = {
    "Orange Justice", "Billy Bounce", "Electro Shuffle", "Hype", "Default Dance",
    "Dab", "Best Mates", "Reaf Mane", "Just Mane", "Dab LInde", "Best Wads",
    "Show Lock", "Harat Gant", "Uly Range"
}

for _, name in pairs(emotes) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.98, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(38, 38, 42) -- Color de los botones de emote
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    
    local bC = Instance.new("UICorner", btn)
    bC.CornerRadius = UDim.new(0, 4)
    
    -- Funcionalidad de Play Emote
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            game:GetService("GuiService"):PlayEmote(name)
        end)
    end)
end

-- // INTERACCIONES (Abrir y Arrastrar)
bubble.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Cargador del Free Emotes oficial de SB
freeBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AllEmotes"))()
end)

-- Lógica para arrastrar la burbuja (Mobile & PC compatible)
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

print("✅ System Broken Emotes Réplica Cargada. Burbuja 'E' activa y persistente.")
