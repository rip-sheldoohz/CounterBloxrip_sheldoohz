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

--Pagina Counter Blox Legit
local CounterBloxLegitTab = Window:CreateTab("Counter Blox Legit")

local ESPEnabled = false
local EnemyColor = Color3.fromRGB(255, 50, 50) -- Cor dos inimigos (personalizável)
local AllyColor = Color3.fromRGB(0, 255, 0)    -- Cor dos aliados (sempre verde)
local Highlights = {}

-- Função simples para verificar time
local function GetPlayerTeam(player)
    if not player then return "Unknown" end
    
    -- Usa o sistema básico do Roblox
    if player.Team then
        return player.Team
    elseif player.TeamColor then
        return player.TeamColor
    end
    
    return "Unknown"
end

-- Função simples para verificar se é mesmo time
local function IsSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    
    -- Compara Team primeiro
    if player1.Team and player2.Team then
        return player1.Team == player2.Team
    end
    
    -- Compara TeamColor se não tem Team
    if player1.TeamColor and player2.TeamColor then
        return player1.TeamColor == player2.TeamColor
    end
    
    return false
end

-- Criar ESP simplificado
local function CreateESP(player)
    if not player.Character or player == LocalPlayer then return end

    -- Limpar highlight antigo
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0

    -- Sistema simples: Verde para aliados, cor personalizada para inimigos
    if IsSameTeam(player, LocalPlayer) then
        -- Mesmo time - sempre verde
        highlight.FillColor = AllyColor
        highlight.OutlineColor = AllyColor
    else
        -- Time inimigo - cor personalizada
        highlight.FillColor = EnemyColor
        highlight.OutlineColor = EnemyColor
    end

    Highlights[player] = highlight
end

-- Atualizar ESP de todos
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if ESPEnabled then
            if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                CreateESP(player)
            end
        else
            if Highlights[player] then
                Highlights[player]:Destroy()
                Highlights[player] = nil
            end
        end
    end
end

-- Monitorar players entrando/renascendo
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            CreateESP(player)
        end
    end)
    
    player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        if ESPEnabled then
            task.wait(0.5)
            CreateESP(player)
        end
    end)
    
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then
            task.wait(0.5)
            CreateESP(player)
        end
    end)
end)

for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            task.wait(1)
            CreateESP(player)
        end
    end)
    
    player:GetPropertyChangedSignal("TeamColor"):Connect(function()
        if ESPEnabled then
            task.wait(0.5)
            CreateESP(player)
        end
    end)
    
    player:GetPropertyChangedSignal("Team"):Connect(function()
        if ESPEnabled then
            task.wait(0.5)
            CreateESP(player)
        end
    end)
end

-- Monitora mudanças no próprio jogador
LocalPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
    if ESPEnabled then
        task.wait(0.5)
        UpdateESP()
    end
end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    if ESPEnabled then
        task.wait(0.5)
        UpdateESP()
    end
end)

-- UI Toggle ESP
CounterBloxLegitTab:CreateToggle({
	Name = "ESP Counter Blox",
	CurrentValue = false,
	Flag = "ESP_CB",
	Callback = function(Value)
		ESPEnabled = Value
		UpdateESP()
	end,
})

-- UI ColorPicker apenas para inimigos
CounterBloxLegitTab:CreateColorPicker({
	Name = "Cor dos Inimigos",
	Color = EnemyColor,
	Flag = "EnemyColor_CB",
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

-- Aimbot Melhorado - AUTOMÁTICO
local AimbotAtivo = false
local Mouse = LocalPlayer:GetMouse()
local FOVSize = 200 -- Campo de visão do aimbot
local SmoothnessFactor = 0.25 -- Suavidade do movimento
local AutoLockDistance = 300 -- Distância para lock automático

-- Função para verificar se o inimigo é alvo válido
local function IsValidTarget(player)
    return player and 
           player ~= LocalPlayer and 
           player.Character and 
           player.Character:FindFirstChild("Head") and 
           player.Character:FindFirstChild("Humanoid") and 
           player.Character.Humanoid.Health > 0 and
           not IsSameTeam(player, LocalPlayer) -- Só mira em inimigos
end

-- Função para pegar inimigo mais próximo da mira
local function GetClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)

    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local headPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            
            if onScreen then
                local targetPos = Vector2.new(headPos.X, headPos.Y)
                local distance = (mousePos - targetPos).magnitude

                if distance < shortestDistance and distance < FOVSize then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer, shortestDistance
end

-- Função para verificar linha de visão
local function HasClearLineOfSight(targetPosition)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local raycastResult = workspace:Raycast(Camera.CFrame.Position, targetPosition - Camera.CFrame.Position, raycastParams)
    
    if raycastResult then
        local hitCharacter = raycastResult.Instance.Parent
        if hitCharacter and hitCharacter:FindFirstChild("Humanoid") then
            return true
        end
        return false
    end
    return true
end

-- Loop do Aimbot AUTOMÁTICO (gruda só de olhar)
RunService.RenderStepped:Connect(function()
    if AimbotAtivo then
        local target, distance = GetClosestEnemy()
        
        if target and IsValidTarget(target) and distance < AutoLockDistance then
            local head = target.Character.Head
            local headPosition = head.Position + Vector3.new(0, 0.1, 0)
            
            -- Verifica linha de visão
            if HasClearLineOfSight(headPosition) then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, headPosition)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, SmoothnessFactor)
            end
        end
    end
end)

------------------------------------------------------------
-- UI Aimbot
------------------------------------------------------------

CounterBloxLegitTab:CreateToggle({
	Name = "Aimbot Automático",
	CurrentValue = false,
	Flag = "AimbotToggle",
	Callback = function(Value)
		AimbotAtivo = Value
		if Value then
			Rayfield:Notify({
			   Title = "Aimbot",
			   Content = "🎯 Aimbot automático ativado! Olhe para inimigos para grudar automaticamente",
			   Duration = 5,
			   Image = 4483362458,
			})
		else
			Rayfield:Notify({
			   Title = "Aimbot",
			   Content = "❌ Aimbot desativado",
			   Duration = 4,
			   Image = 4483362458,
			})
		end
	end,
})

-- Slider para ajustar FOV do aimbot
CounterBloxLegitTab:CreateSlider({
	Name = "FOV do Aimbot",
	Range = {100, 400},
	Increment = 25,
	CurrentValue = FOVSize,
	Flag = "AimbotFOV",
	Callback = function(Value)
		FOVSize = Value
		Rayfield:Notify({
		   Title = "Aimbot FOV",
		   Content = "FOV ajustado para: " .. Value .. " pixels",
		   Duration = 3,
		   Image = 4483362458,
		})
	end,
})

-- Slider para distância de lock automático
CounterBloxLegitTab:CreateSlider({
	Name = "Distância Auto-Lock",
	Range = {150, 500},
	Increment = 25,
	CurrentValue = AutoLockDistance,
	Flag = "AimbotDistance",
	Callback = function(Value)
		AutoLockDistance = Value
		Rayfield:Notify({
		   Title = "Aimbot Distância",
		   Content = "Distância de lock: " .. Value .. " pixels",
		   Duration = 3,
		   Image = 4483362458,
		})
	end,
})

-- Slider para ajustar suavidade do aimbot
CounterBloxLegitTab:CreateSlider({
	Name = "Suavidade do Aimbot",
	Range = {0.10, 0.60},
	Increment = 0.05,
	CurrentValue = SmoothnessFactor,
	Flag = "AimbotSmoothness",
	Callback = function(Value)
		SmoothnessFactor = Value
		local smoothnessText = Value < 0.2 and "Muito Legit" or Value < 0.4 and "Normal" or "Rápido"
		Rayfield:Notify({
		   Title = "Aimbot Suavidade",
		   Content = "Suavidade: " .. smoothnessText .. " (" .. Value .. ")",
		   Duration = 3,
		   Image = 4483362458,
		})
	end,
})

-- Aba Counter Blox Auto Kill
local CounterBloxTab = Window:CreateTab("Counter Blox Teleporte")

-- Parágrafo de Informações Principais
local InfoParagraph = CounterBloxTab:CreateParagraph({
    Title = "Em Breve: Counter Blox Teleporte",
    Content = "Sistema de teleporte e auto killer será adicionado em breve. Fique ligado!"
})

CounterBloxTab:CreateButton({
    Name = "Copiar link do Discord Eco Hub",
    Callback = function()
        setclipboard("https://discord.gg/abygGhvRCG") -- Copia o link para o clipboard
        Rayfield:Notify({
            Title = "Discord",
            Content = "Link do Discord copiado para a área de transferência!",
            Duration = 3
        })
    end
})

-- Aba de Configuração/Otimização
local ConfiguracaoTab = Window:CreateTab("Otimização")

-- Serviços necessários
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

-- Variáveis de controle
local optimizationActive = false
local processedObjects = {}
local connections = {}
local estados = {
    otimizacaoAtiva = false,
    texturaMinecraft = false,
    reduzirLag = false,
    limparEfeitos = false
}

-- Função segura para evitar erros
local function safeCall(func)
    local success, err = pcall(func)
    if not success then
        print("Erro de otimização:", err)
    end
    return success
end

-- Aplicar textura minecraft e otimizar
local function aplicarTexturaMinecraft(obj)
    safeCall(function()
        if obj:IsA("BasePart") then
            -- Textura minecraft (baixa resolução) + otimizações
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.Reflectance = 0
            obj.TopSurface = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
        elseif obj:IsA("MeshPart") then
            -- Baixa qualidade para reduzir lag
            obj.Material = Enum.Material.Plastic
            obj.CastShadow = false
            obj.RenderFidelity = Enum.RenderFidelity.Performance
            obj.Reflectance = 0
        elseif obj:IsA("UnionOperation") then
            obj.Material = Enum.Material.Plastic
            obj.UsePartColor = true
            obj.CastShadow = false
        end
    end)
end

-- Reduzir input lag e melhorar performance
local function reduzirInputLag()
    safeCall(function()
        -- Configurações de qualidade baixa
        local settings = UserSettings():GetService("UserGameSettings")
        settings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

        -- Lighting otimizado para menos lag
        Lighting.Technology = Enum.Technology.Compatibility
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 0
        Lighting.Brightness = 2

        -- Som otimizado
        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        SoundService.DistanceFactor = 0.1
    end)
end

-- Limpar apenas efeitos que causam lag (mantém nomes e UI)
local function limparEfeitosLag(obj)
    safeCall(function()
        -- Remove apenas partículas pesadas
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj:Destroy()
        elseif obj:IsA("Explosion") then
            obj.Visible = false
        end
        
        -- NÃO remove nametags, GUIs de jogadores, ou textos importantes
        -- Mantém: BillboardGui, SurfaceGui com nomes, etc.
    end)
end

-- Otimização completa sem afetar nomes
local function otimizarObjeto(obj)
    if not obj or not obj.Parent or processedObjects[obj] then return end
    
    -- NÃO processar objetos importantes
    if obj.Name == "Head" or obj.Parent.Name == "Head" then return end
    if obj:IsA("BillboardGui") or obj:IsA("TextLabel") or obj:IsA("TextBox") then return end
    if obj.Parent and obj.Parent:IsA("Player") then return end
    
    processedObjects[obj] = true

    -- Aplicar otimizações
    if estados.texturaMinecraft then
        aplicarTexturaMinecraft(obj)
    end
    
    if estados.limparEfeitos then
        limparEfeitosLag(obj)
    end
end

-- Otimização em lote
local function executarOtimizacao()
    if optimizationActive then return end
    optimizationActive = true

    task.spawn(function()
        local objetos = workspace:GetDescendants()
        local total = #objetos
        
        for i, obj in ipairs(objetos) do
            otimizarObjeto(obj)
            
            -- Yield a cada 50 objetos para não travar
            if i % 50 == 0 then
                RunService.Heartbeat:Wait()
            end
        end
        
        optimizationActive = false
        print("Otimização concluída -", total, "objetos processados")
    end)
end

-- Monitorar novos objetos
local function monitorarNovos()
    connections.childAdded = workspace.ChildAdded:Connect(function(child)
        if estados.otimizacaoAtiva then
            task.defer(function()
                wait(0.1) -- Espera carregar
                for _, obj in pairs(child:GetDescendants()) do
                    otimizarObjeto(obj)
                end
            end)
        end
    end)
end

-- Parar sistema
local function pararSistema()
    for _, connection in pairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    connections = {}
    optimizationActive = false
end

-------------------------------------------------
-- UI CONTROLES
-------------------------------------------------

ConfiguracaoTab:CreateParagraph({
    Title = "Sistema de Otimização Inteligente",
    Content = "Remove lag e input lag mantendo nomes de jogadores e elementos importantes do jogo visíveis."
})

ConfiguracaoTab:CreateToggle({
    Name = "Ativar Sistema de Otimização",
    CurrentValue = false,
    Flag = "SistemaOtimizacao",
    Callback = function(Value)
        estados.otimizacaoAtiva = Value
        if Value then
            reduzirInputLag()
            executarOtimizacao()
            monitorarNovos()
            print("Sistema de otimização ativado!")
        else
            pararSistema()
            print("Sistema de otimização desativado")
        end
    end,
})

ConfiguracaoTab:CreateToggle({
    Name = "Textura Minecraft (Anti-Lag)",
    CurrentValue = false,
    Flag = "TexturaMinecraft",
    Callback = function(Value)
        estados.texturaMinecraft = Value
        if Value then
            print("Textura minecraft ativada - reduz lag visual")
            if estados.otimizacaoAtiva then
                executarOtimizacao()
            end
        end
    end,
})

ConfiguracaoTab:CreateToggle({
    Name = "Reduzir Input Lag",
    CurrentValue = false,
    Flag = "ReduzirInputLag",
    Callback = function(Value)
        if Value then
            reduzirInputLag()
            print("Input lag reduzido - configurações otimizadas")
        end
    end,
})

ConfiguracaoTab:CreateToggle({
    Name = "Limpar Efeitos Pesados",
    CurrentValue = false,
    Flag = "LimparEfeitos",
    Callback = function(Value)
        estados.limparEfeitos = Value
        if Value then
            print("Limpeza de efeitos ativada")
            if estados.otimizacaoAtiva then
                executarOtimizacao()
            end
        end
    end,
})

ConfiguracaoTab:CreateButton({
    Name = "Executar Otimização Completa",
    Callback = function()
        reduzirInputLag()
        executarOtimizacao()
        print("Otimização completa executada!")
    end,
})

ConfiguracaoTab:CreateSlider({
    Name = "Limite de FPS",
    Range = {30, 240},
    Increment = 10,
    CurrentValue = 60,
    Flag = "LimiteFPS",
    Callback = function(Value)
        safeCall(function()
            if setfpscap then
                setfpscap(Value)
                print("FPS limitado a:", Value)
            end
        end)
    end,
})

ConfiguracaoTab:CreateParagraph({
    Title = "O que o sistema faz",
    Content = "✓ Mantém nomes de jogadores\n✓ Preserva elementos do jogo\n✓ Aplica textura minecraft\n✓ Reduz input lag\n✓ Remove efeitos pesados\n✓ Otimiza performance"
})

ConfiguracaoTab:CreateParagraph({
    Title = "Status de Proteção",
    Content = "🛡️ Protegido: Nomes de jogadores, Interfaces importantes, Textos do jogo\n🗑️ Removido: Partículas pesadas, Efeitos visuais, Sombras desnecessárias"
})

-- Final Codigo 

Rayfield:Notify({
    Title = "Eco Hub - Counter Blox Melhorado",
    Content = "by rip_sheldoohz - Aimbot automático e ESP personalizado carregados!",
    Duration = 6
})
