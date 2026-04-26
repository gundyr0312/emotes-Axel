local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Persistencia total (No se borra al morir)
if player:WaitForChild("PlayerGui"):FindFirstChild("SB_Emotes_Final") then
    player.PlayerGui.SB_Emotes_Final:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SB_Emotes_Final"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- // BURBUJA "E" (Trigger idéntico a la foto)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "Trigger"
bubble.Size = UDim2.new(0, 45, 0, 45)
bubble.Position = UDim2.new(0, 20, 0.1, 0)
bubble.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 25
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0)

local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(255, 255, 255)
bStroke.Thickness = 1.5

-- // PANEL PRINCIPAL (Diseño exacto de la segunda foto)
local main = Instance.new("Frame", gui)
main.Name = "MainFrame"
main.Size = UDim2.new(0, 255, 0, 350)
main.Position = UDim2.new(0.5, -127, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(25, 26, 28) -- Gris fondo
main.BorderSizePixel = 0
main.Visible = false
main.Active = true

local mCorner = Instance.new("UICorner", main)
mCorner.CornerRadius = UDim.new(0, 8)

-- Encabezado Gris
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(52, 54, 58) -- Color barra superior
header.BorderSizePixel = 0

local hCorner = Instance.new("UICorner", header)
hCorner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "System Broken | Emotes"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- Contenedor de Emotes (Área interna negra)
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1, -16, 1, -95)
container.Position = UDim2.new(0, 8, 0, 48)
container.BackgroundColor3 = Color3.fromRGB(15, 16, 18)
container.BorderSizePixel = 0

local cCorner = Instance.new("UICorner", container)
cCorner.CornerRadius = UDim.new(0, 6)

local scroll = Instance.new("ScrollingFrame", container)
scroll.Size = UDim2.new(1, -4, 1, -10)
scroll.Position = UDim2.new(0, 2, 0, 5)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Botón Cyan "Free emotes" (Ubicación exacta)
local freeBtn = Instance.new("TextButton", main)
freeBtn.Size = UDim2.new(0, 105, 0, 28)
freeBtn.Position = UDim2.new(1, -115, 1, -40)
freeBtn.BackgroundColor3 = Color3.fromRGB(80, 215, 240) -- Cyan exacto de la captura
freeBtn.Text = "Free emotes"
freeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
freeBtn.Font = Enum.Font.GothamBold
freeBtn.TextSize = 13

local fCorner = Instance.new("UICorner", freeBtn)
fCorner.CornerRadius = UDim.new(0, 4)

-- // LISTA DE EMOTES (Nombres exactos de la foto)
local visualEmotes = {
    "Orange Justice", "Billy Bounce", "Electro Shuffle", "Hype", "Default Dance",
    "Dab", "Best Mates", "Reaf Mane", "Just Mane", "Dab Linde", "Best Wads",
    "Show Lock", "Harat Gant", "Uly Range"
}

for _, name in pairs(visualEmotes) do
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.98, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(38, 40, 44)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    
    local bC = Instance.new("UICorner", btn)
    bC.CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function()
        pcall(function() game:GetService("GuiService"):PlayEmote(name) end)
    end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, #visualEmotes * 35)

-- // FUNCIONES DE INTERACCIÓN
bubble.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

freeBtn.MouseButton1Click:Connect(function()
    -- Carga el script de 50k emotes que mandaste en el txt
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
