repeat wait() until game:IsLoaded()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Simple Notification Function
local function notify(title, text, duration)
    duration = duration or 3
    local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(1, -210, 1, -60)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    local label = Instance.new("TextLabel", frame)
    label.Text = title .. ": " .. text
    label.Size = UDim2.new(1, 0, 1, 0)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    TweenService:Create(frame, TweenInfo.new(duration), {Position = UDim2.new(1, 0, 1, -60)}):Play()
    wait(duration + 0.5)
    gui:Destroy()
end

notify("Custom MM2 Hack", "Loaded successfully! Press 'E' for menu.", 5)

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
    antiAFK = true  -- Always on by default
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
            local role = "Innocent"  -- Detect role (simplified)
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

-- Godmode (Prevent Damage)
local function godmode()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.HealthChanged:Connect(function(health)
            if health < LocalPlayer.Character.Humanoid.MaxHealth and toggles.godmode then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end

-- Auto Farm Coins (Teleport to Coins)
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

-- Kill All (As Murderer)
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

-- Reveal Roles (Chat or GUI)
local function revealRoles()
    if toggles.revealRoles then
        for _, player in ipairs(Players:GetPlayers()) do
            local role = "Innocent"
            if player.Backpack:FindFirstChild("Knife") then role = "Murderer" end
            if player.Backpack:FindFirstChild("Gun") then role = "Sheriff" end
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(player.Name .. " is " .. role, "All")
        end
        toggles.revealRoles = false  -- One-time
    end
end

-- Speed Hack
local function speedHack()
    if LocalPlayer.Character and toggles.speedHack then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50  -- Adjust as needed
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end

-- Aimbot (Silent Aim for Sheriff Gun)
local function aimbot()
    if toggles.aimbot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
        local mouse = LocalPlayer:GetMouse()
        mouse.Icon = "rbxasset://textures\\GunCursor.png"
        mouse.Button1Down:Connect(function()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") and target.Parent ~= LocalPlayer.Character then
                -- Fire gun at target (simplified raycast)
                local args = { [1] = target.Parent.HumanoidRootPart.Position }
                LocalPlayer.Character.Gun.RemoteEvent:FireServer(unpack(args))
            end
        end)
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
end)

spawn(autoFarmCoins)  -- Separate thread for farming

-- Simple Menu (Toggle with E)
local menuGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local frame = Instance.new("Frame", menuGui)
frame.Size = UDim2.new(0, 200, 0, 300)
frame.Position = UDim2.new(0.5, -100, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Visible = false

-- Add UIListLayout to stack buttons
local layout = Instance.new("UIListLayout", frame)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)

local function addToggle(name, key)
    local button = Instance.new("TextButton", frame)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Text = name .. ": " .. (toggles[key] and "ON" or "OFF")
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.MouseButton1Click:Connect(function()
        toggles[key] = not toggles[key]
        button.Text = name .. ": " .. (toggles[key] and "ON" or "OFF")
        notify("Toggle", name .. " " .. (toggles[key] and "enabled" or "disabled"))
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


UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        frame.Visible = not frame.Visible
    end
end)