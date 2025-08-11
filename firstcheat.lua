repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TweenInfo = TweenInfo.new
local Workspace = game:GetService("Workspace")

-- Enhanced Notification (Higher position)
local function notify(title, text, duration, color)
    duration = duration or 3
    color = color or Color3.fromRGB(255, 255, 255)
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    gui.IgnoreGuiInset = true
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 70)
    frame.Position = UDim2.new(1, -310, 1, -200)  -- Even higher
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0
    frame.Transparency = 1
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(0, 150, 255)
    stroke.Transparency = 0.4

    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 15, 0.5, -5)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14

    TweenService:Create(frame, TweenInfo(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0, Position = UDim2.new(1, -310, 1, -210)}):Play()
    wait(duration)
    TweenService:Create(frame, TweenInfo(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1, Position = UDim2.new(1, 0, 1, -210)}):Play()
    wait(0.5)
    gui:Destroy()
end

notify("Neverloose.cc", "Скрипт загружен! Нажми 'Delete' для меню.", 5, Color3.fromRGB(0, 200, 255))

-- Toggles and Settings
local toggles = {
    esp = false,
    godmode = false,
    autoFarmCoins = false,
    autoGrabGun = false,
    killAll = false,
    revealRoles = false,
    speedHack = false,
    aimbot = false,
    fly = false,
    infJump = false,
    xray = false,
    tpToMurderer = false,
    tpToSheriff = false,
    noClip = false,
    autoThrowKnife = false,
    silentAim = false,
    coinESP = false,
    unlockCrates = false,
    antiAFK = true
}

local settings = {
    speed = 50,
    flySpeed = 100,
    theme = "Dark"
}

local selectedPlayer = nil  -- For TP to Player

-- Ultimate ESP System (Completely Rewritten for Maximum Beauty and Functionality)
local espObjects = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local char = player.Character
    local head = char:WaitForChild("Head", 5)
    local root = char:WaitForChild("HumanoidRootPart", 5)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not head or not root or not humanoid then return end

    -- Billboard for Name, Role, Distance, Health Bar
    local billboard = Instance.new("BillboardGui", head)
    billboard.Size = UDim2.new(0, 250, 0, 100)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    
    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    
    local nameLabel = Instance.new("TextLabel", frame)
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local roleLabel = Instance.new("TextLabel", frame)
    roleLabel.Size = UDim2.new(1, 0, 0.25, 0)
    roleLabel.Position = UDim2.new(0, 0, 0.3, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    roleLabel.Font = Enum.Font.Gotham
    roleLabel.TextSize = 14
    roleLabel.TextStrokeTransparency = 0.5
    roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local distLabel = Instance.new("TextLabel", frame)
    distLabel.Size = UDim2.new(1, 0, 0.2, 0)
    distLabel.Position = UDim2.new(0, 0, 0.55, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    local healthBarFrame = Instance.new("Frame", frame)
    healthBarFrame.Size = UDim2.new(1, 0, 0.15, 0)
    healthBarFrame.Position = UDim2.new(0, 0, 0.75, 0)
    healthBarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBarFrame.BorderSizePixel = 0
    local healthCorner = Instance.new("UICorner", healthBarFrame)
    healthCorner.CornerRadius = UDim.new(0, 4)
    
    local healthFill = Instance.new("Frame", healthBarFrame)
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    local fillCorner = Instance.new("UICorner", healthFill)
    fillCorner.CornerRadius = UDim.new(0, 4)
    local healthGradient = Instance.new("UIGradient", healthFill)
    healthGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 200, 0))
    }
    
    -- 3D Box with Chams Effect
    local box = Instance.new("BoxHandleAdornment", char)
    box.Size = Vector3.new(4, 6, 2)
    box.Adornee = char
    box.AlwaysOnTop = true
    box.Transparency = 0.6
    box.ZIndex = 5
    box.Color3 = Color3.fromRGB(255, 255, 255)
    
    local chams = Instance.new("Highlight", char)
    chams.FillTransparency = 0.8
    chams.OutlineTransparency = 0
    chams.FillColor = Color3.fromRGB(255, 255, 255)
    chams.OutlineColor = Color3.fromRGB(255, 255, 255)
    
    -- Tracer Line (Using Beam for Beauty)
    local tracerAttachment0 = Instance.new("Attachment", Workspace.CurrentCamera)
    tracerAttachment0.Name = "TracerAttach0_" .. player.Name
    tracerAttachment0.Position = Vector3.new(0, -Workspace.CurrentCamera.ViewportSize.Y / 2, 0)  -- Bottom of screen
    
    local tracerAttachment1 = Instance.new("Attachment", root)
    tracerAttachment1.Name = "TracerAttach1_" .. player.Name
    
    local tracerBeam = Instance.new("Beam", Workspace.CurrentCamera)
    tracerBeam.Attachment0 = tracerAttachment0
    tracerBeam.Attachment1 = tracerAttachment1
    tracerBeam.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    tracerBeam.Transparency = NumberSequence.new(0.5)
    tracerBeam.Width0 = 0.2
    tracerBeam.Width1 = 0.2
    tracerBeam.LightEmission = 1
    tracerBeam.LightInfluence = 0
    tracerBeam.FaceCamera = true
    tracerBeam.Enabled = false
    
    espObjects[player] = {
        billboard = billboard,
        nameLabel = nameLabel,
        roleLabel = roleLabel,
        distLabel = distLabel,
        healthFill = healthFill,
        box = box,
        chams = chams,
        tracerBeam = tracerBeam,
        tracerAttach0 = tracerAttachment0,
        tracerAttach1 = tracerAttachment1
    }
end

local function updateESP()
    for player, objs in pairs(espObjects) do
        if toggles.esp and player.Character and LocalPlayer.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            local root = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChild("Humanoid")
            if not head or not root or not humanoid then continue end
            
            local role = "Innocent"
            local color = Color3.fromRGB(0, 255, 0)
            if player.Backpack:FindFirstChild("Knife") or char:FindFirstChild("Knife") then 
                role = "Murderer" 
                color = Color3.fromRGB(255, 0, 0) 
            end
            if player.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Gun") then 
                role = "Sheriff" 
                color = Color3.fromRGB(0, 0, 255) 
            end
            
            local dist = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            
            objs.nameLabel.Text = player.Name
            objs.nameLabel.TextColor3 = color
            
            objs.roleLabel.Text = "[" .. role .. "]"
            objs.roleLabel.TextColor3 = color
            
            objs.distLabel.Text = "Dist: " .. math.floor(dist)
            
            objs.healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
            objs.healthFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
            
            objs.box.Color3 = color
            objs.box.Visible = true
            
            objs.chams.FillColor = color
            objs.chams.OutlineColor = color
            objs.chams.Enabled = true
            
            objs.tracerBeam.Color = ColorSequence.new(color)
            objs.tracerBeam.Enabled = true
            
            objs.billboard.Enabled = true
        else
            objs.billboard.Enabled = false
            objs.box.Visible = false
            objs.chams.Enabled = false
            objs.tracerBeam.Enabled = false
        end
    end
end

local godmodeConnection
local function godmode()
    if toggles.godmode and LocalPlayer.Character then
        if godmodeConnection then godmodeConnection:Disconnect() end
        godmodeConnection = LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(health)
            if health < LocalPlayer.Character.Humanoid.MaxHealth then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
        LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
    elseif godmodeConnection then
        godmodeConnection:Disconnect()
        godmodeConnection = nil
    end
end

local function autoFarmCoins()
    while toggles.autoFarmCoins do
        local coins = {}
        for _, coin in ipairs(Workspace:GetChildren()) do
            if coin.Name == "Coin_Server" then
                table.insert(coins, coin)
            end
        end
        if #coins == 0 then break end
        table.sort(coins, function(a, b)
            return (a.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (b.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        end)
        for _, coin in ipairs(coins) do
            if LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                wait(0.05)
            end
        end
        wait(0.1)
    end
end

local function autoGrabGun()
    if toggles.autoGrabGun then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "GunDrop" and LocalPlayer.Character and not LocalPlayer.Backpack:FindFirstChild("Gun") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                wait(0.3)
                local prompt = obj:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                end
            end
        end
    end
end

local function killAll()
    if toggles.killAll and (LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife")) then
        local knife = LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack.Knife
        if knife.Parent ~= LocalPlayer.Character then
            knife.Parent = LocalPlayer.Character
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 and (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
                knife:Activate()
                wait(0.1)
            end
        end
    end
end

local function revealRoles()
    if toggles.revealRoles then
        for _, player in ipairs(Players:GetPlayers()) do
            local role = "Innocent"
            if player.Backpack:FindFirstChild("Knife") then role = "Murderer" end
            if player.Backpack:FindFirstChild("Gun") then role = "Sheriff" end
            if ReplicatedStorage.DefaultChatSystemChatEvents and ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest then
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(player.Name .. " is " .. role, "All")
            end
        end
        toggles.revealRoles = false
    end
end

local function speedHack()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = toggles.speedHack and settings.speed or 16
    end
end

local aimbotConnection
local function aimbot()
    if toggles.aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local mouse = LocalPlayer:GetMouse()
        mouse.Icon = "rbxasset://textures\\GunCursor.png"
        if aimbotConnection then aimbotConnection:Disconnect() end
        aimbotConnection = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= LocalPlayer.Character then
                local gun = LocalPlayer.Character.Gun
                if gun and gun:FindFirstChild("RemoteEvent") then
                    local args = { [1] = target.Parent.HumanoidRootPart.Position }
                    gun.RemoteEvent:FireServer(unpack(args))
                end
            end
        end)
    elseif aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

local flyConnection
local function fly()
    if toggles.fly and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        local bodyVelocity = Instance.new("BodyVelocity", root)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = RunService.RenderStepped:Connect(function()
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            local cam = Workspace.CurrentCamera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then bodyVelocity.Velocity += cam.LookVector * settings.flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then bodyVelocity.Velocity -= cam.LookVector * settings.flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then bodyVelocity.Velocity -= cam.RightVector * settings.flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then bodyVelocity.Velocity += cam.RightVector * settings.flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bodyVelocity.Velocity += Vector3.new(0, settings.flySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bodyVelocity.Velocity -= Vector3.new(0, settings.flySpeed, 0) end
        end)
    elseif flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
        if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity") then
            LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
    end
end

local infJumpConnection
local function infJump()
    if toggles.infJump then
        if infJumpConnection then infJumpConnection:Disconnect() end
        infJumpConnection = UserInputService.JumpRequest:Connect(function()
            if LocalPlayer.Character then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    elseif infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end

local highlights = {}
local function xray()
    if toggles.xray then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if (obj.Name == "Coin_Server" or obj.Name == "GunDrop") and not highlights[obj] then
                local highlight = Instance.new("Highlight", obj)
                highlight.FillColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlights[obj] = highlight
            end
        end
    else
        for obj, hl in pairs(highlights) do
            hl:Destroy()
        end
        highlights = {}
    end
end

local function tpToMurderer()
    if toggles.tpToMurderer then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Backpack:FindFirstChild("Knife") and player.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                toggles.tpToMurderer = false
                break
            end
        end
    end
end

local coinEspObjects = {}
local function updateCoinESP()
    if toggles.coinESP then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "Coin_Server" and not coinEspObjects[obj] then
                local billboard = Instance.new("BillboardGui", obj)
                billboard.Size = UDim2.new(0, 100, 0, 30)
                billboard.AlwaysOnTop = true
                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255, 215, 0)
                text.Text = "Coin"
                coinEspObjects[obj] = {billboard = billboard, text = text}
            end
            if coinEspObjects[obj] and LocalPlayer.Character then
                local dist = (obj.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                coinEspObjects[obj].text.Text = string.format("Coin | Dist: %.1f", dist)
                coinEspObjects[obj].billboard.Enabled = true
            end
        end
    else
        for _, data in pairs(coinEspObjects) do
            data.billboard:Destroy()
        end
        coinEspObjects = {}
    end
end

local noClipConnection
local function noClip()
    if toggles.noClip and LocalPlayer.Character then
        if noClipConnection then noClipConnection:Disconnect() end
        noClipConnection = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    elseif noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function tpToSheriff()
    if toggles.tpToSheriff then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Backpack:FindFirstChild("Gun") and player.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                toggles.tpToSheriff = false
                break
            end
        end
    end
end

local function autoThrowKnife()
    if toggles.autoThrowKnife and LocalPlayer.Character:FindFirstChild("Knife") then
        local knife = LocalPlayer.Character.Knife
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                if knife:FindFirstChild("RemoteEvent") then
                    knife.RemoteEvent:FireServer(player.Character.Head.Position)
                end
                wait(0.2)
            end
        end
    end
end

local silentAimConnection
local function silentAim()
    if toggles.silentAim and LocalPlayer.Character:FindFirstChild("Gun") then
        if silentAimConnection then silentAimConnection:Disconnect() end
        silentAimConnection = RunService.RenderStepped:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= LocalPlayer.Character then
                local gun = LocalPlayer.Character.Gun
                if gun and gun:FindFirstChild("RemoteEvent") then
                    local args = { [1] = target.Parent.Head.Position + Vector3.new(math.random(-1,1), math.random(-1,1), math.random(-1,1)) }
                    gun.RemoteEvent:FireServer(unpack(args))
                end
            end
        end)
    elseif silentAimConnection then
        silentAimConnection:Disconnect()
        silentAimConnection = nil
    end
end

local function unlockCrates()
    if toggles.unlockCrates then
        for _, crate in ipairs(Workspace:GetChildren()) do
            if crate:IsA("Model") and crate.Name:match("Crate") then
                if ReplicatedStorage.Remotes and ReplicatedStorage.Remotes.OpenCrate then
                    ReplicatedStorage.Remotes.OpenCrate:FireServer(crate)
                end
            end
        end
        toggles.unlockCrates = false
    end
end

local antiAFKConnection
local function antiAFK()
    if toggles.antiAFK then
        if antiAFKConnection then antiAFKConnection:Disconnect() end
        antiAFKConnection = LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    elseif antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
    end
end

local function tpToPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        notify("TP", "Телепортирован к " .. targetPlayer.Name, 3, Color3.fromRGB(0, 255, 0))
    end
end

-- Persistence
local mainLoopConnection
local function initializeFeatures()
    -- Clear previous connections
    if mainLoopConnection then mainLoopConnection:Disconnect() end
    if godmodeConnection then godmodeConnection:Disconnect() end
    if aimbotConnection then aimbotConnection:Disconnect() end
    if flyConnection then flyConnection:Disconnect() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    if noClipConnection then noClipConnection:Disconnect() end
    if silentAimConnection then silentAimConnection:Disconnect() end
    if antiAFKConnection then antiAFKConnection:Disconnect() end
    espObjects = {}
    highlights = {}
    coinEspObjects = {}
    
    -- Re-setup ESP with CharacterAdded
    local function setupESP()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(char)
                    addESP(player)
                end)
                player.CharacterRemoving:Connect(function()
                    if espObjects[player] then
                        espObjects[player].billboard:Destroy()
                        espObjects[player].box:Destroy()
                        espObjects[player].chams:Destroy()
                        espObjects[player].tracerBeam:Destroy()
                        espObjects[player].tracerAttach0:Destroy()
                        espObjects[player].tracerAttach1:Destroy()
                        espObjects[player] = nil
                    end
                end)
                if player.Character then
                    addESP(player)
                end
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                player.CharacterAdded:Connect(function(char)
                    addESP(player)
                end)
                player.CharacterRemoving:Connect(function()
                    if espObjects[player] then
                        espObjects[player].billboard:Destroy()
                        espObjects[player].box:Destroy()
                        espObjects[player].chams:Destroy()
                        espObjects[player].tracerBeam:Destroy()
                        espObjects[player].tracerAttach0:Destroy()
                        espObjects[player].tracerAttach1:Destroy()
                        espObjects[player] = nil
                    end
                end)
                if player.Character then
                    addESP(player)
                end
            end
        end)
        Players.PlayerRemoving:Connect(function(player)
            if espObjects[player] then
                espObjects[player].billboard:Destroy()
                espObjects[player].box:Destroy()
                espObjects[player].chams:Destroy()
                espObjects[player].tracerBeam:Destroy()
                espObjects[player].tracerAttach0:Destroy()
                espObjects[player].tracerAttach1:Destroy()
                espObjects[player] = nil
            end
        end)
    end
    setupESP()

    -- Main Loop
    mainLoopConnection = RunService.RenderStepped:Connect(function()
        updateESP()
        godmode()
        speedHack()
        aimbot()
        killAll()
        autoGrabGun()
        revealRoles()
        fly()
        infJump()
        xray()
        tpToMurderer()
        tpToSheriff()
        noClip()
        autoThrowKnife()
        silentAim()
        updateCoinESP()
        unlockCrates()
        antiAFK()
    end)

    spawn(autoFarmCoins)
end

LocalPlayer.CharacterAdded:Connect(function(character)
    repeat wait() until character and character:FindFirstChild("HumanoidRootPart")
    initializeFeatures()
    notify("Neverloose.cc", "Скрипт перезапущен после респавна!", 3, Color3.fromRGB(0, 255, 0))
end)

if LocalPlayer.Character then
    initializeFeatures()
end

-- Menu
local menuGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
menuGui.IgnoreGuiInset = true
menuGui.ResetOnSpawn = false  -- Preserve GUI on respawn
local mainFrame = Instance.new("Frame", menuGui)
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
mainFrame.Transparency = 1
mainFrame.Active = true

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(0, 100, 255)
stroke.Transparency = 0.5

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 10))
}
gradient.Rotation = 90  -- Vertical gradient

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
titleBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", titleBar)
title.Text = "Neverloose.cc"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 150, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local devLabel = Instance.new("TextLabel", titleBar)
devLabel.Text = "Developers: cry_alone001"
devLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
devLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
devLabel.BackgroundTransparency = 1
devLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
devLabel.Font = Enum.Font.Gotham
devLabel.TextSize = 12
devLabel.TextXAlignment = Enum.TextXAlignment.Left

local minButton = Instance.new("TextButton", titleBar)
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(0.85, 0, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
minButton.Text = "-"
minButton.TextColor3 = Color3.fromRGB(200, 200, 200)
local minCorner = Instance.new("UICorner", minButton)
minCorner.CornerRadius = UDim.new(0, 5)
minButton.MouseButton1Click:Connect(function()
    local targetSize = (mainFrame.Size.Y.Offset > 40) and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 450)
    TweenService:Create(mainFrame, TweenInfo(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = targetSize}):Play()
end)

local closeButton = Instance.new("TextButton", titleBar)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.93, 0, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local closeCorner = Instance.new("UICorner", closeButton)
closeCorner.CornerRadius = UDim.new(0, 5)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    notify("Меню", "Закрыто. Нажми Delete для открытия.", 3, Color3.fromRGB(255, 50, 50))
end)

local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 100, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
sidebar.BorderSizePixel = 0

local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 5)

local tabs = {"Combat", "Movement", "Visuals", "Misc"}
local tabFrames = {}
local currentTabFrame = nil

for _, tabName in ipairs(tabs) do
    local tabButton = Instance.new("TextButton", sidebar)
    tabButton.Size = UDim2.new(1, 0, 0, 40)
    tabButton.Text = tabName
    tabButton.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    tabButton.TextColor3 = Color3.fromRGB(150, 150, 255)
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextSize = 16
    local tabCorner = Instance.new("UICorner", tabButton)
    tabCorner.CornerRadius = UDim.new(0, 8)
    local tabStroke = Instance.new("UIStroke", tabButton)
    tabStroke.Transparency = 0.8

    local contentFrame = Instance.new("ScrollingFrame", mainFrame)
    contentFrame.Size = UDim2.new(1, -100, 1, -40)
    contentFrame.Position = UDim2.new(0, 100, 0, 40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    contentFrame.BackgroundTransparency = 0.9
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    contentFrame.ScrollBarThickness = 4
    contentFrame.Visible = false
    contentFrame.Transparency = 0

    local contentLayout = Instance.new("UIListLayout", contentFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    tabFrames[tabName] = contentFrame

    tabButton.MouseButton1Click:Connect(function()
        if currentTabFrame then
            local oldTween = TweenService:Create(currentTabFrame, TweenInfo(0.3, Enum.EasingStyle.Quad), {Transparency = 1, Position = UDim2.new(0, 120, 0, 40)})
            oldTween:Play()
            oldTween.Completed:Wait()  -- Correct wait for completion
            currentTabFrame.Visible = false
        end
        contentFrame.Position = UDim2.new(0, 80, 0, 40)
        contentFrame.Transparency = 1
        contentFrame.Visible = true
        local newTween = TweenService:Create(contentFrame, TweenInfo(0.3, Enum.EasingStyle.Quad), {Transparency = 0, Position = UDim2.new(0, 100, 0, 40)})
        newTween:Play()
        currentTabFrame = contentFrame
    end)
end

-- Custom Switch (Fixed toggle issue by ensuring updateSwitch is called correctly)
local function addSwitchToTab(tabName, name, key)
    local holder = Instance.new("Frame", tabFrames[tabName])
    holder.Size = UDim2.new(1, 0, 0, 40)
    holder.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextTruncate = Enum.TextTruncate.SplitWord

    local switchFrame = Instance.new("Frame", holder)
    switchFrame.Size = UDim2.new(0, 60, 0, 30)
    switchFrame.Position = UDim2.new(1, -70, 0, 5)
    switchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    local switchCorner = Instance.new("UICorner", switchFrame)
    switchCorner.CornerRadius = UDim.new(1, 0)
    local switchStroke = Instance.new("UIStroke", switchFrame)
    switchStroke.Transparency = 0.7

    local knob = Instance.new("Frame", switchFrame)
    knob.Size = UDim2.new(0.5, -2, 1, -2)
    knob.Position = UDim2.new(toggles[key] and 0.5 or 0, 1, 0, 1)  -- Initial position based on toggle
    knob.BackgroundColor3 = toggles[key] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    local knobShadow = Instance.new("UIStroke", knob)
    knobShadow.Color = Color3.fromRGB(0, 0, 0)
    knobShadow.Transparency = 0.5

    local function updateSwitch()
        local targetPos = UDim2.new(toggles[key] and 0.5 or 0, 1, 0, 1)
        local targetColor = toggles[key] and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        TweenService:Create(knob, TweenInfo(0.2, Enum.EasingStyle.Quad), {Position = targetPos, BackgroundColor3 = targetColor}):Play()
    end

    switchFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggles[key] = not toggles[key]
            updateSwitch()
            notify("Тоггл", name .. " " .. (toggles[key] and "включён" or "выключен"), 3, toggles[key] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
        end
    end)
end

addSwitchToTab("Combat", "Godmode", "godmode")
addSwitchToTab("Combat", "Kill All", "killAll")
addSwitchToTab("Combat", "Aimbot", "aimbot")
addSwitchToTab("Combat", "Silent Aim", "silentAim")
addSwitchToTab("Combat", "Auto Throw Knife", "autoThrowKnife")
addSwitchToTab("Combat", "Reveal Roles", "revealRoles")

addSwitchToTab("Movement", "Speed Hack", "speedHack")
addSwitchToTab("Movement", "Fly", "fly")
addSwitchToTab("Movement", "Infinite Jump", "infJump")
addSwitchToTab("Movement", "NoClip", "noClip")

addSwitchToTab("Visuals", "ESP", "esp")
addSwitchToTab("Visuals", "X-Ray", "xray")
addSwitchToTab("Visuals", "Coin ESP", "coinESP")

addSwitchToTab("Misc", "Auto Farm Coins", "autoFarmCoins")
addSwitchToTab("Misc", "Auto Grab Gun", "autoGrabGun")
addSwitchToTab("Misc", "TP to Murderer", "tpToMurderer")
addSwitchToTab("Misc", "TP to Sheriff", "tpToSheriff")
addSwitchToTab("Misc", "Unlock Crates", "unlockCrates")
addSwitchToTab("Misc", "Anti-AFK", "antiAFK")

local function addSliderToTab(tabName, name, settingKey, min, max, default)
    local holder = Instance.new("Frame", tabFrames[tabName])
    holder.Size = UDim2.new(1, 0, 0, 50)
    holder.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", holder)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = name .. ": " .. settings[settingKey]
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local sliderFrame = Instance.new("Frame", holder)
    sliderFrame.Size = UDim2.new(1, -20, 0.3, 0)
    sliderFrame.Position = UDim2.new(0, 10, 0.5, 0)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    local sliderCorner = Instance.new("UICorner", sliderFrame)
    sliderCorner.CornerRadius = UDim.new(0, 5)
    
    local fill = Instance.new("Frame", sliderFrame)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    local fillCorner = Instance.new("UICorner", fill)
    
    local dragging = false
    sliderFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    sliderFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relative = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            settings[settingKey] = math.floor(min + relative * (max - min))
            fill.Size = UDim2.new(relative, 0, 1, 0)
            label.Text = name .. ": " .. settings[settingKey]
        end
    end)
end

addSliderToTab("Movement", "Speed", "speed", 16, 200, 50)
addSliderToTab("Movement", "Fly Speed", "flySpeed", 50, 300, 100)

local themeHolder = Instance.new("Frame", tabFrames["Misc"])
themeHolder.Size = UDim2.new(1, 0, 0, 40)
themeHolder.BackgroundTransparency = 1

local themeLabel = Instance.new("TextLabel", themeHolder)
themeLabel.Size = UDim2.new(0.7, 0, 1, 0)
themeLabel.Position = UDim2.new(0, 10, 0, 0)
themeLabel.Text = "Тема"
themeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
themeLabel.BackgroundTransparency = 1
themeLabel.Font = Enum.Font.Gotham
themeLabel.TextSize = 14

local themeButton = Instance.new("TextButton", themeHolder)
themeButton.Size = UDim2.new(0, 60, 0, 30)
themeButton.Position = UDim2.new(1, -70, 0, 5)
themeButton.Text = settings.theme
themeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
themeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local themeCorner = Instance.new("UICorner", themeButton)
themeCorner.CornerRadius = UDim.new(0, 5)

themeButton.MouseButton1Click:Connect(function()
    settings.theme = (settings.theme == "Dark") and "Light" or "Dark"
    themeButton.Text = settings.theme
    local bgColor = (settings.theme == "Dark") and Color3.fromRGB(10, 10, 15) or Color3.fromRGB(220, 220, 220)
    local textColor = (settings.theme == "Dark") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundColor3 = bgColor
    title.TextColor3 = textColor
    sidebar.BackgroundColor3 = (settings.theme == "Dark") and Color3.fromRGB(5, 5, 10) or Color3.fromRGB(200, 200, 200)
    titleBar.BackgroundColor3 = (settings.theme == "Dark") and Color3.fromRGB(5, 5, 10) or Color3.fromRGB(180, 180, 180)
end)

-- TP to Player (New)
local tpPlayerHolder = Instance.new("Frame", tabFrames["Misc"])
tpPlayerHolder.Size = UDim2.new(1, 0, 0, 150)
tpPlayerHolder.BackgroundTransparency = 1

local tpLabel = Instance.new("TextLabel", tpPlayerHolder)
tpLabel.Size = UDim2.new(1, 0, 0, 30)
tpLabel.Position = UDim2.new(0, 0, 0, 0)
tpLabel.Text = "TP to Player"
tpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
tpLabel.BackgroundTransparency = 1
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 16

local playerListFrame = Instance.new("ScrollingFrame", tpPlayerHolder)
playerListFrame.Size = UDim2.new(1, -20, 0, 80)
playerListFrame.Position = UDim2.new(0, 10, 0, 30)
playerListFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
playerListFrame.BorderSizePixel = 0
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListFrame.ScrollBarThickness = 4

local playerListLayout = Instance.new("UIListLayout", playerListFrame)
playerListLayout.SortOrder = Enum.SortOrder.Name
playerListLayout.Padding = UDim.new(0, 5)

local function updatePlayerList()
    playerListFrame:ClearAllChildren()
    playerListLayout = Instance.new("UIListLayout", playerListFrame)
    playerListLayout.SortOrder = Enum.SortOrder.Name
    playerListLayout.Padding = UDim.new(0, 5)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerButton = Instance.new("TextButton", playerListFrame)
            playerButton.Size = UDim2.new(1, 0, 0, 30)
            playerButton.Text = player.Name
            playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.Font = Enum.Font.Gotham
            playerButton.TextSize = 14
            local btnCorner = Instance.new("UICorner", playerButton)
            btnCorner.CornerRadius = UDim.new(0, 6)
            
            playerButton.MouseButton1Click:Connect(function()
                selectedPlayer = player
                notify("TP", "Выбран игрок: " .. player.Name, 3, Color3.fromRGB(0, 255, 0))
            end)
        end
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

local tpButton = Instance.new("TextButton", tpPlayerHolder)
tpButton.Size = UDim2.new(1, -20, 0, 30)
tpButton.Position = UDim2.new(0, 10, 0, 120)
tpButton.Text = "TP to Selected Player"
tpButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
local tpCorner = Instance.new("UICorner", tpButton)
tpCorner.CornerRadius = UDim.new(0, 6)

tpButton.MouseButton1Click:Connect(function()
    if selectedPlayer then
        tpToPlayer(selectedPlayer)
    else
        notify("TP", "Выберите игрока сначала!", 3, Color3.fromRGB(255, 0, 0))
    end
end)

-- Draggable (same)
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Menu Toggle (same)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        if mainFrame.Visible then
            TweenService:Create(mainFrame, TweenInfo(0.4, Enum.EasingStyle.Quad), {Transparency = 1, Size = UDim2.new(0, 400*0.8, 0, 450*0.8)}):Play()
            wait(0.4)
            mainFrame.Visible = false
        else
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 400*0.8, 0, 450*0.8)
            mainFrame.Transparency = 1
            TweenService:Create(mainFrame, TweenInfo(0.4, Enum.EasingStyle.Quad), {Transparency = 0, Size = UDim2.new(0, 400, 0, 450)}):Play()
            sidebar:FindFirstChild("Combat").MouseButton1Click:Invoke()
        end
    end
end)
