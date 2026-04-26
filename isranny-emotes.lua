-- // ISRANNY EMOTES - SYSTEM BROKEN LOADER EDITION
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Asegurar que no se duplique
if player:WaitForChild("PlayerGui"):FindFirstChild("IsrannyEmoteLoader") then
    player.PlayerGui.IsrannyEmoteLoader:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "IsrannyEmoteLoader"
gui.ResetOnSpawn = false -- No se borra al morir
gui.Parent = player:WaitForChild("PlayerGui")

-- // LA BURBUJA "E" (El gatillo)
local bubble = Instance.new("TextButton", gui)
bubble.Name = "E_Trigger"
bubble.Size = UDim2.new(0, 40, 0, 40)
bubble.Position = UDim2.new(0, 15, 0.5, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bubble.Text = "E"
bubble.TextColor3 = Color3.fromRGB(255, 255, 255)
bubble.Font = Enum.Font.GothamBold
bubble.TextSize = 20
bubble.ZIndex = 100

local bCorner = Instance.new("UICorner", bubble)
bCorner.CornerRadius = UDim.new(1, 0)

local bStroke = Instance.new("UIStroke", bubble)
bStroke.Color = Color3.fromRGB(60, 60, 60)
bStroke.Thickness = 2

-- // LÓGICA DE CARGA ORIGINAL
local FreeEmotesEnabled = false

local function LoadSystemBrokenEmotes()
    if not FreeEmotesEnabled then
        FreeEmotesEnabled = true
        -- Notificación original
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "System Broken",
            Text = "Loading free emotes.\nCredits: Gi#7331",
            Duration = 5
        })
        -- Carga del script oficial de System Broken
        loadstring(game:HttpGet("https://raw.githubusercontent.com/H20CalibreYT/SystemBroken/main/AllEmotes"))()
    else
        -- Si ya está cargado, intentamos abrir la GUI de SB que se crea
        local sbGui = game.CoreGui:FindFirstChild("FreeEmotes") or player.PlayerGui:FindFirstChild("FreeEmotes")
        if sbGui then
            sbGui.Enabled = not sbGui.Enabled
        end
    end
end

-- Al hacer click en la "E", carga o alterna el panel original
bubble.MouseButton1Click:Connect(function()
    LoadSystemBrokenEmotes()
end)

-- // HACER LA BURBUJA MOVIBLE
local dragging, dragInput, dragStart, startPos
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

print("✅ Isranny Emotes: Cargador de System Broken con burbuja 'E' activo.")
