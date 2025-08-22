-- Painel Atualizado
-- Atualizado Esp & Aimbot
-- Discord.gg/EcoHub
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

if not LocalPlayer then
    Players.PlayerAdded:Wait()
    LocalPlayer = Players.LocalPlayer
end

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    LocalPlayer:Kick("Falha ao carregar Rayfield")
    return
end

local CustomTheme = {
    TextColor = Color3.fromRGB(240, 240, 240),
    Background = Color3.fromRGB(25, 25, 25),
    Topbar = Color3.fromRGB(34, 34, 34),
    Shadow = Color3.fromRGB(20, 20, 20),
    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
    TabBackground = Color3.fromRGB(80, 80, 80),
    TabStroke = Color3.fromRGB(85, 85, 85),
    TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
    TabTextColor = Color3.fromRGB(240, 240, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
    ElementStroke = Color3.fromRGB(50, 50, 50),
    SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
    SliderBackground = Color3.fromRGB(50, 138, 220),
    SliderProgress = Color3.fromRGB(50, 138, 220),
    SliderStroke = Color3.fromRGB(58, 163, 255),
    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(0, 146, 214),
    ToggleDisabled = Color3.fromRGB(100, 100, 100),
    ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
    ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
    ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),
    DropdownSelected = Color3.fromRGB(40, 40, 40),
    DropdownUnselected = Color3.fromRGB(30, 30, 30),
    InputBackground = Color3.fromRGB(30, 30, 30),
    InputStroke = Color3.fromRGB(65, 65, 65),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
}

local Window = Rayfield:CreateWindow({
   Name = "Eco Hub",
   LoadingTitle = "Carregando EcoHub...",
   LoadingSubtitle = "Aguarde...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false,
   ThemeIdentifier = CustomTheme,
   ScrollEnabled = true
})

local CounterBloxLegitTab = Window:CreateTab("Counter Blox Legit")

CounterBloxLegitTab:CreateParagraph({
    Title = "Sistema ESP Counter Blox",
    Content = "ESP automático que destaca inimigos e objetos importantes no mapa. Funciona apenas para inimigos de times diferentes, mostrando posição e informações de forma clara."
})

local ESPEnabled = false
local EnemyColor = Color3.fromRGB(255, 50, 50)

local Highlights = {}

local function IsSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    if player1.Team and player2.Team then
        return player1.Team == player2.Team
    end
    return false
end

local function CreateESP(player)
    if not player.Character or player == game.Players.LocalPlayer then return end
    if IsSameTeam(player, game.Players.LocalPlayer) then return end

    if Highlights[player] then Highlights[player]:Destroy() end

    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0
    highlight.FillColor = EnemyColor
    highlight.OutlineColor = EnemyColor

    Highlights[player] = highlight
end

local function UpdateESP()
    for player, highlight in pairs(Highlights) do
        if highlight then highlight:Destroy() end
    end
    Highlights = {}

    if not ESPEnabled then return end
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            CreateESP(player)
        end
    end
end

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then task.wait(1) CreateESP(player) end
    end)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then task.wait(0.5) UpdateESP() end
    end)
end)

for _, player in ipairs(game.Players:GetPlayers()) do
    if player.Character then
        player.CharacterAdded:Connect(function()
            if ESPEnabled then task.wait(1) CreateESP(player) end
        end)
    end
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then task.wait(0.5) UpdateESP() end
    end)
end

game.Players.LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if ESPEnabled then task.wait(0.5) UpdateESP() end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if ESPEnabled then UpdateESP() end
end)

CounterBloxLegitTab:CreateToggle({
    Name = "ESP Counter-Strike",
    CurrentValue = false,
    Flag = "ESP_CS",
    Callback = function(Value)
        ESPEnabled = Value
        UpdateESP()
    end,
})

CounterBloxLegitTab:CreateColorPicker({
    Name = "Cor dos Inimigos",
    Color = EnemyColor,
    Flag = "EnemyColor_CS",
    Callback = function(Value)
        EnemyColor = Value
        UpdateESP()
        Rayfield:Notify({
           Title = "ESP Atualizado",
           Content = "Cor dos inimigos alterada!",
           Duration = 3,
           Image = 4483362458,
        })
    end,
})

CounterBloxLegitTab:CreateParagraph({
	Title = "Aimbot Counter Blox",
	Content = "Aimbot automático que gruda nos inimigos quando você olha para eles. Funciona apenas com inimigos de times diferentes."
})

local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local AimbotAtivo = false
local FOVSize = 300
local SmoothnessFactor = 0.25
local MaxWorldDistance = 2000
local HeadBias = Vector3.new(0, 0.1, 0)

local LockedTarget = nil

local function IsTargetValid(plr)
    if not plr or plr == LocalPlayer then return false end
    local char = plr.Character
    if not char then return false end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local head = char:FindFirstChild("Head")
    if not hum or hum.Health <= 0 or not head then return false end

    if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
        return false
    end

    local origin = Camera.CFrame.Position
    local direction = (head.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}

    local rayResult = Workspace:Raycast(origin, direction, rayParams)
    if rayResult and rayResult.Instance and not head:IsDescendantOf(rayResult.Instance.Parent) then
        return false
    end

    return true
end

local function GetClosestEnemy()
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local closest, shortestDist = nil, math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if IsTargetValid(plr) then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                local worldDist = (Camera.CFrame.Position - head.Position).Magnitude
                if dist < shortestDist and dist <= FOVSize and worldDist <= MaxWorldDistance then
                    shortestDist = dist
                    closest = plr
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
    if not AimbotAtivo then
        LockedTarget = nil
        return
    end

    if not LockedTarget or not IsTargetValid(LockedTarget) then
        LockedTarget = GetClosestEnemy()
    end

    if LockedTarget and IsTargetValid(LockedTarget) then
        local headPos = LockedTarget.Character.Head.Position + HeadBias
        local desired = CFrame.new(Camera.CFrame.Position, headPos)

        Camera.CFrame = Camera.CFrame:Lerp(desired, SmoothnessFactor)
    end
end)

CounterBloxLegitTab:CreateToggle({
    Name = "Aimbot (Cabeça)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(v)
        AimbotAtivo = v
        Rayfield:Notify({
            Title = "Aimbot",
            Content = v and "Ativado (somente inimigos visíveis)" or "Desativado",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

CounterBloxLegitTab:CreateSlider({
    Name = "FOV (px)",
    Range = {100, 500},
    Increment = 10,
    CurrentValue = FOVSize,
    Flag = "AimbotFOV",
    Callback = function(v) FOVSize = v end,
})

CounterBloxLegitTab:CreateSlider({
    Name = "Suavidade",
    Range = {0, 0.6},
    Increment = 0.01,
    CurrentValue = SmoothnessFactor,
    Flag = "AimbotSmoothness",
    Callback = function(v) SmoothnessFactor = v end,
})

CounterBloxLegitTab:CreateSlider({
    Name = "Alcance (studs)",
    Range = {500, 3000},
    Increment = 50,
    CurrentValue = MaxWorldDistance,
    Flag = "AimbotWorldRange",
    Callback = function(v) MaxWorldDistance = v end,
})

local ConfigTab = Window:CreateTab("Configuração")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local OriginalSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    ShadowSoftness = Lighting.ShadowSoftness,
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    Outlines = true
}

local OptimizationEnabled = false

local function EnableOptimization()
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
    Lighting.FogEnd = 100000
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(200,200,200)
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion") then
            obj.Enabled = false
        end
    end
end

local function DisableOptimization()
    Lighting.GlobalShadows = OriginalSettings.GlobalShadows
    Lighting.ShadowSoftness = OriginalSettings.ShadowSoftness
    Lighting.FogEnd = OriginalSettings.FogEnd
    Lighting.Brightness = OriginalSettings.Brightness
    Lighting.Ambient = OriginalSettings.Ambient
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Explosion") then
            obj.Enabled = true
        end
    end
end

ConfigTab:CreateToggle({
    Name = "Otimização Gráfica",
    CurrentValue = false,
    Flag = "OptimizationToggle",
    Callback = function(Value)
        OptimizationEnabled = Value
        if Value then
            EnableOptimization()
        else
            DisableOptimization()
        end
    end,
})

ConfigTab:CreateButton({
    Name = "Copiar link do Discord Eco Hub",
    Callback = function()
        setclipboard("https://discord.gg/abygGhvRCG")
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link do Discord copiado para a área de transferência!",
            Duration = 3
        })
    end
})

Rayfield:Notify({
    Title = "Eco Hub - Counter Blox",
    Content = "by rip_sheldoohz - Aimbot automático e ESP personalizado carregados!",
    Duration = 6
})
