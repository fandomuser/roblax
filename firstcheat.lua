repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TweenInfo = TweenInfo.new

-- Simple Notification Function (Enhanced with colors)
local function notify(title, text, duration, color)
    duration = duration or 3
    color = color or Color3.fromRGB(255, 255, 255)
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 250, 0, 60)
    frame.Position = UDim2.new(1, -260, 1, -70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    
    local titleLabel = Instance.new("TextLabel", frame)
    titleLabel.Text = title
    titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = color
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Text = text
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 10, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    
    TweenService:Create(frame, TweenInfo(duration, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 1, -70)}):Play()
    wait(duration + 0.5)
    gui:Destroy()
end

notify("Custom MM2 Hack", "Loaded successfully! Press 'RightShift' for menu.", 5, Color3.fromRGB(0, 255, 0))

-- Features Toggles
local toggles = {
    esp = false,
    godmode = false,
    autoFarmCoins = false,
    autoGrabGun = false,
    killAll = false,
    revealRoles = false,
    speedHack = false,
    aimbot = false,
    fly = false,  -- New: Fly
    infJump = false,  -- New: Infinite Jump
    xray = false,  -- New: X-Ray (Highlight coins/guns through walls)
    tpToMurderer = false,  -- New: Teleport to Murderer
    antiAFK = true  -- Always on
}

-- ESP (Player Names, Roles, Boxes)
local espObjects = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local char = player.Character
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local billboard = Instance.new("BillboardGui", head)
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    local box = Instance.new("BoxHandleAdornment", char)
    box.Size = char:GetExtentsSize()
    box.Adornee = char
    box.AlwaysOnTop = true
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    
    espObjects[player] = {billboard = billboard, box = box}
end

local function updateESP()
    for player, objs in pairs(espObjects) do
        if toggles.esp and player.Character then
            local role = "Innocent"
            if player.Backpack:FindFirstChild("Knife") then role = "Murderer" end
            if player.Backpack:FindFirstChild("Gun") then role = "Sheriff" end
            objs.billboard.TextLabel.Text = player.Name .. " [" .. role .. "]"
            objs.billboard.Enabled = true
            objs.box.Visible = true
        else
            objs.billboard.Enabled = false
            objs.box.Visible = false
        end
    end
end

-- Godmode
local function godmode()
    if LocalPlayer.Character and toggles.godmode then
        LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(health)
            if health < LocalPlayer.Character.Humanoid.MaxHealth then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end

-- Auto Farm Coins
local function autoFarmCoins()
    while toggles.autoFarmCoins do
        for _, coin in ipairs(workspace:GetChildren()) do
            if coin.Name == "Coin_Server" and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = coin.CFrame
                wait(0.1)
            end
        end
        wait(1)
    end
end

-- Auto Grab Gun
local function autoGrabGun()
    if toggles.autoGrabGun then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "GunDrop" and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
                wait(0.5)
                fireproximityprompt(obj:FindFirstChildOfClass("ProximityPrompt"))
            end
        end
    end
end

-- Kill All
local function killAll()
    if toggles.killAll and LocalPlayer.Backpack:FindFirstChild("Knife") then
        local knife = LocalPlayer.Backpack.Knife
        knife.Parent = LocalPlayer.Character
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -1)
                knife:Activate()
                wait(0.2)
            end
        end
    end
end

-- Reveal Roles
local function revealRoles()
    if toggles.revealRoles then
        for _, player in ipairs(Players:GetPlayers()) do
            local role = "Innocent"
            if player.Backpack:FindFirstChild("Knife") then role = "Murderer" end
            if player.Backpack:FindFirstChild("Gun") then role = "Sheriff" end
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(player.Name .. " is " .. role, "All")
        end
        toggles.revealRoles = false
    end
end

-- Speed Hack
local function speedHack()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.WalkSpeed = toggles.speedHack and 50 or 16
    end
end

-- Aimbot
local aimbotConnection
local function aimbot()
    if toggles.aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local mouse = LocalPlayer:GetMouse()
        mouse.Icon = "rbxasset://textures\\GunCursor.png"
        aimbotConnection = mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= LocalPlayer.Character then
                local args = { [1] = target.Parent.HumanoidRootPart.Position }
                LocalPlayer.Character.Gun.RemoteEvent:FireServer(unpack(args))
            end
        end)
    elseif aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

-- New: Fly
local flySpeed = 50
local flyConnection
local function fly()
    if toggles.fly and LocalPlayer.Character then
        local root = LocalPlayer.Character.HumanoidRootPart
        local bodyVelocity = Instance.new("BodyVelocity", root)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        flyConnection = RunService.RenderStepped:Connect(function()
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then bodyVelocity.Velocity += game.Workspace.CurrentCamera.CFrame.LookVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then bodyVelocity.Velocity -= game.Workspace.CurrentCamera.CFrame.LookVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then bodyVelocity.Velocity -= game.Workspace.CurrentCamera.CFrame.RightVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then bodyVelocity.Velocity += game.Workspace.CurrentCamera.CFrame.RightVector * flySpeed end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then bodyVelocity.Velocity += Vector3.new(0, flySpeed, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then bodyVelocity.Velocity -= Vector3.new(0, flySpeed, 0) end
        end)
    elseif flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
        if LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        end
    end
end

-- New: Infinite Jump
local infJumpConnection
local function infJump()
    if toggles.infJump then
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

-- New: X-Ray (Highlight coins and guns)
local highlights = {}
local function xray()
    if toggles.xray then
        for _, obj in ipairs(workspace:GetChildren()) do
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

-- New: Teleport to Murderer
local function tpToMurderer()
    if toggles.tpToMurderer then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Backpack:FindFirstChild("Knife") and player.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                toggles.tpToMurderer = false  -- One-time TP
                break
            end
        end
    end
end

-- Anti-AFK
RunService.Heartbeat:Connect(function()
    if toggles.antiAFK then
        LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
    end
end)

-- Add ESP to All Players
for _, player in ipairs(Players:GetPlayers()) do
    addESP(player)
end
Players.PlayerAdded:Connect(addESP)

-- Main Loop
RunService.RenderStepped:Connect(function()
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
end)

spawn(autoFarmCoins)

-- Beautiful GUI (Draggable, with Title, Corners, Gradients)
local menuGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local mainFrame = Instance.new("Frame", menuGui)
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(100, 100, 100)
stroke.Transparency = 0.8

local gradient = Instance.new("UIGradient", mainFrame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}

local title = Instance.new("TextLabel", mainFrame)
title.Text = "MM2 Custom Hack"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local scrollingFrame = Instance.new("ScrollingFrame", mainFrame)
scrollingFrame.Size = UDim2.new(1, 0, 1, -40)
scrollingFrame.Position = UDim2.new(0, 0, 0, 40)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollingFrame.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", scrollingFrame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function addToggle(name, key)
    local holder = Instance.new("Frame", scrollingFrame)
    holder.Size = UDim2.new(1, 0, 0, 30)
    holder.BackgroundTransparency = 1
    
    local button = Instance.new("TextButton", holder)
    button.Size = UDim2.new(1, -10, 1, 0)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.Text = name .. ": " .. (toggles[key] and "ON" or "OFF")
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    
    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 6)
    
    button.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        button.Text = name .. ": " .. (toggles[key] and "ON" or "OFF")
        notify("Toggle", name .. " " .. (toggles[key] and "enabled" or "disabled"), 3, toggles[key] and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0))
    end)
end

addToggle("ESP", "esp")
addToggle("Godmode", "godmode")
addToggle("Auto Farm Coins", "autoFarmCoins")
addToggle("Auto Grab Gun", "autoGrabGun")
addToggle("Kill All", "killAll")
addToggle("Reveal Roles", "revealRoles")
addToggle("Speed Hack", "speedHack")
addToggle("Aimbot", "aimbot")
addToggle("Fly (WASD/Space/Ctrl)", "fly")
addToggle("Infinite Jump", "infJump")
addToggle("X-Ray (Coins/Guns)", "xray")
addToggle("TP to Murderer", "tpToMurderer")

-- Make GUI Draggable
local dragging, dragInput, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Toggle Menu Keybind (Changed to RightShift for convenience)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

