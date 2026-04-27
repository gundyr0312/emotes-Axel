-- 🔥 DESACTIVAR RUEDA
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local emotesFolder = player:WaitForChild("Emotes")

-- 💾 FAVORITOS (guardado)
local favorites = {}

-- 🧱 GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local main = Instance.new("Frame", gui)

main.Size = UDim2.new(0.6,0,0.65,0)
main.Position = UDim2.new(0.2,0,0.18,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = false
Instance.new("UICorner", main)

-- 🔍 BUSCADOR
local search = Instance.new("TextBox", main)
search.Size = UDim2.new(1,-20,0,35)
search.Position = UDim2.new(0,10,0,10)
search.PlaceholderText = "Buscar..."
search.BackgroundColor3 = Color3.fromRGB(35,35,35)
search.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", search)

-- ❌ CERRAR
local close = Instance.new("TextButton", main)
close.Text = "X"
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-40,0,10)
close.BackgroundColor3 = Color3.fromRGB(200,50,50)
Instance.new("UICorner", close)

-- 📦 CONTENEDOR
local container = Instance.new("Frame", main)
container.Size = UDim2.new(1,-20,1,-100)
container.Position = UDim2.new(0,10,0,55)
container.BackgroundTransparency = 1

local grid = Instance.new("UIGridLayout", container)
grid.CellSize = UDim2.new(0,70,0,70)
grid.CellPadding = UDim2.new(0,6,0,6)

-- 🔁 PAGINAS
local ITEMS_PER_PAGE = 100
local currentPage = 1

local nextBtn = Instance.new("TextButton", main)
nextBtn.Text = ">"
nextBtn.Size = UDim2.new(0,40,0,40)
nextBtn.Position = UDim2.new(1,-50,1,-50)

local prevBtn = Instance.new("TextButton", main)
prevBtn.Text = "<"
prevBtn.Size = UDim2.new(0,40,0,40)
prevBtn.Position = UDim2.new(0,10,1,-50)

local pageLabel = Instance.new("TextLabel", main)
pageLabel.Size = UDim2.new(0,150,0,40)
pageLabel.Position = UDim2.new(0.5,-75,1,-50)
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.new(1,1,1)

-- 🎯 OBTENER EMOTES
local function getEmotes()
    local list = {}

    for _,emote in pairs(emotesFolder:GetChildren()) do
        if emote:IsA("Animation") then
            table.insert(list, {
                Name = emote.Name,
                Id = emote.AnimationId:match("%d+"),
                Fav = favorites[emote.AnimationId] == true
            })
        end
    end

    -- ⭐ ORDENAR: favoritos primero
    table.sort(list, function(a,b)
        if a.Fav == b.Fav then
            return a.Name < b.Name
        else
            return a.Fav and true or false
        end
    end)

    return list
end

-- 🔍 FILTRO
local function getFiltered()
    local text = string.lower(search.Text)
    local all = getEmotes()
    local filtered = {}

    for _,e in ipairs(all) do
        if text == "" or string.lower(e.Name):find(text) then
            table.insert(filtered, e)
        end
    end

    return filtered
end

-- ▶️ REPRODUCIR
local function playEmote(id)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://"..id

    local track = humanoid:LoadAnimation(anim)
    track:Play()
end

-- 🔄 CARGAR
local function loadPage()
    container:ClearAllChildren()
    grid.Parent = container

    local list = getFiltered()

    local totalPages = math.max(1, math.ceil(#list / ITEMS_PER_PAGE))
    if currentPage > totalPages then currentPage = totalPages end

    pageLabel.Text = "Página "..currentPage.." / "..totalPages

    local startIndex = (currentPage-1)*ITEMS_PER_PAGE+1
    local endIndex = math.min(startIndex+ITEMS_PER_PAGE-1,#list)

    for i=startIndex,endIndex do
        local e = list[i]

        local item = Instance.new("Frame")
        item.Size = UDim2.new(0,70,0,70)
        item.BackgroundColor3 = Color3.fromRGB(40,40,40)
        item.Parent = container
        Instance.new("UICorner", item)

        -- 🖼️ BOTÓN EMOTE
        local btn = Instance.new("ImageButton", item)
        btn.Size = UDim2.new(1,0,1,0)
        btn.Image = "rbxthumb://type=Asset&id="..e.Id.."&w=150&h=150"
        btn.BackgroundTransparency = 1

        -- ⭐ FAVORITO
        local star = Instance.new("TextButton", item)
        star.Size = UDim2.new(0,20,0,20)
        star.Position = UDim2.new(1,-22,1,-22)
        star.Text = e.Fav and "★" or "☆"
        star.TextScaled = true
        star.BackgroundColor3 = Color3.fromRGB(255,215,0)

        Instance.new("UICorner", star)

        -- ▶️ CLICK EMOTE
        btn.MouseButton1Click:Connect(function()
            playEmote(e.Id)
        end)

        -- ⭐ TOGGLE FAVORITO
        star.MouseButton1Click:Connect(function()
            local key = "rbxassetid://"..e.Id

            if favorites[key] then
                favorites[key] = nil
            else
                favorites[key] = true
            end

            loadPage()
        end)
    end
end

-- 🔘 EVENTOS
nextBtn.MouseButton1Click:Connect(function()
    currentPage += 1
    loadPage()
end)

prevBtn.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage -= 1
        loadPage()
    end
end)

search:GetPropertyChangedSignal("Text"):Connect(function()
    currentPage = 1
    loadPage()
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- ⌨️ ABRIR
local open = false
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Period then
        open = not open
        main.Visible = open
        if open then loadPage() end
    end
end)

-- 🔄 ACTUALIZAR
emotesFolder.ChildAdded:Connect(loadPage)
emotesFolder.ChildRemoved:Connect(loadPage)
