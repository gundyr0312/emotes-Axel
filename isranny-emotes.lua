-- 🔥 PANEL NUEVO (NO ROMPE EL SCRIPT ORIGINAL)

task.wait(2) -- esperar a que cargue todo

if not State or not State.emotesData then return end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- 🧱 GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.6,0,0.6,0)
frame.Position = UDim2.new(0.2,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false

Instance.new("UICorner", frame)

-- GRID
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1,-20,1,-20)
container.Position = UDim2.new(0,10,0,10)
container.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", container)
grid.CellSize = UDim2.new(0,70,0,70)
grid.CellPadding = UDim2.new(0,6,0,6)

-- 🔥 FUNCIÓN REAL DE EMOTE (USA EL SCRIPT ORIGINAL)
local function playEmote(emote)
    if not emote or not emote.id then return end

    -- usa el mismo sistema del script
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return end

    if State.currentEmoteTrack then
        State.currentEmoteTrack:Stop()
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://"..emote.id

    local track = humanoid:LoadAnimation(anim)
    State.currentEmoteTrack = track
    track:Play()
end

-- 🔄 CARGAR EMOTES (USANDO TU SCRIPT)
local function loadEmotes()
    container:ClearAllChildren()
    grid.Parent = container

    for _,emote in ipairs(State.emotesData) do
        local item = Instance.new("Frame", container)
        item.BackgroundColor3 = Color3.fromRGB(40,40,40)
        item.Size = UDim2.new(0,70,0,70)
        Instance.new("UICorner", item)

        local btn = Instance.new("ImageButton", item)
        btn.Size = UDim2.new(1,0,1,0)
        btn.BackgroundTransparency = 1
        btn.Image = "rbxthumb://type=Asset&id="..emote.id.."&w=150&h=150"

        btn.MouseButton1Click:Connect(function()
            playEmote(emote)
        end)
    end
end

-- ⌨️ ABRIR (misma tecla del script)
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Period then
        frame.Visible = not frame.Visible
        if frame.Visible then
            loadEmotes()
        end
    end
end)
