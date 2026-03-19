--[[
╔══════════════════════════════════════════════════╗
║   SIMPLE WORKING SCRIPT - WINDOW GUARANTEED      ║
║   Created by HERO CONFIG                          ║
╚══════════════════════════════════════════════════╝
]]

-- ScreenGui directly banaya (bina library ke)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HeroConfigGUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Border glow
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSize = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -80, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🔥 HERO CONFIG ULTIMATE"
TitleText.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextScaled = true
TitleText.Font = Enum.Font.GothamBold

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0.5, -15)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
MinimizeBtn.BackgroundTransparency = 0.3
MinimizeBtn.Text = "🔽"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextScaled = true
MinimizeBtn.Font = Enum.Font.GothamBold

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Tabs Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Parent = MainFrame
TabsFrame.Size = UDim2.new(1, -20, 0, 40)
TabsFrame.Position = UDim2.new(0, 10, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TabsFrame.BackgroundTransparency = 0.2

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 10)
TabsCorner.Parent = TabsFrame

-- Tab Buttons
local tabs = {"👤 PLAYER", "🕊️ FLY", "📦 ITEMS", "⚙️ SETTINGS"}
local tabButtons = {}
local activeTab = 1

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = TabsFrame
    btn.Size = UDim2.new(0.25, -5, 0, 30)
    btn.Position = UDim2.new((i-1) * 0.25, (i-1) * 5 + 5, 0.5, -15)
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 70)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    tabButtons[i] = btn
end

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Parent = MainFrame
ContentFrame.Size = UDim2.new(1, -20, 0, 350)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ContentFrame.BackgroundTransparency = 0.2

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentFrame

-- PLAYER TAB CONTENT
local PlayerContent = Instance.new("Frame")
PlayerContent.Parent = ContentFrame
PlayerContent.Size = UDim2.new(1, -20, 1, -20)
PlayerContent.Position = UDim2.new(0, 10, 0, 10)
PlayerContent.BackgroundTransparency = 1
PlayerContent.Visible = true  -- Default visible

-- WalkSpeed Slider
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Parent = PlayerContent
SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0, 0, 0, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "🏃 WalkSpeed: 16"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextScaled = true
SpeedLabel.Font = Enum.Font.Gotham

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Parent = PlayerContent
SpeedSlider.Size = UDim2.new(1, 0, 0, 30)
SpeedSlider.Position = UDim2.new(0, 0, 0, 35)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
SpeedSlider.Text = ""

local SpeedFill = Instance.new("Frame")
SpeedFill.Parent = SpeedSlider
SpeedFill.Size = UDim2.new(0.1, 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)

local SpeedValue = 16

SpeedSlider.MouseButton1Down:Connect(function()
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local sliderPos = SpeedSlider.AbsolutePosition.X
        local sliderSize = SpeedSlider.AbsoluteSize.X
        local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
        SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
        SpeedValue = math.floor(16 + percent * 484)
        SpeedLabel.Text = "🏃 WalkSpeed: " .. SpeedValue
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end)
    
    SpeedSlider.MouseButton1Up:Connect(function()
        conn:Disconnect()
    end)
end)

-- God Mode Toggle
local GodFrame = Instance.new("Frame")
GodFrame.Parent = PlayerContent
GodFrame.Size = UDim2.new(1, 0, 0, 40)
GodFrame.Position = UDim2.new(0, 0, 0, 80)
GodFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)

local GodCorner = Instance.new("UICorner")
GodCorner.CornerRadius = UDim.new(0, 8)
GodCorner.Parent = GodFrame

local GodLabel = Instance.new("TextLabel")
GodLabel.Parent = GodFrame
GodLabel.Size = UDim2.new(0.6, 0, 1, 0)
GodLabel.Position = UDim2.new(0, 10, 0, 0)
GodLabel.BackgroundTransparency = 1
GodLabel.Text = "🛡️ God Mode"
GodLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
GodLabel.TextXAlignment = Enum.TextXAlignment.Left
GodLabel.TextScaled = true
GodLabel.Font = Enum.Font.Gotham

local GodToggle = Instance.new("TextButton")
GodToggle.Parent = GodFrame
GodToggle.Size = UDim2.new(0, 70, 0, 30)
GodToggle.Position = UDim2.new(1, -80, 0.5, -15)
GodToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
GodToggle.Text = "OFF"
GodToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
GodToggle.TextScaled = true
GodToggle.Font = Enum.Font.GothamBold

local GodToggleCorner = Instance.new("UICorner")
GodToggleCorner.CornerRadius = UDim.new(0, 8)
GodToggleCorner.Parent = GodToggle

-- FLY TAB CONTENT
local FlyContent = Instance.new("Frame")
FlyContent.Parent = ContentFrame
FlyContent.Size = UDim2.new(1, -20, 1, -20)
FlyContent.Position = UDim2.new(0, 10, 0, 10)
FlyContent.BackgroundTransparency = 1
FlyContent.Visible = false

local FlyLabel = Instance.new("TextLabel")
FlyLabel.Parent = FlyContent
FlyLabel.Size = UDim2.new(1, 0, 0, 30)
FlyLabel.Position = UDim2.new(0, 0, 0, 0)
FlyLabel.BackgroundTransparency = 1
FlyLabel.Text = "🕊️ Fly Mode"
FlyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyLabel.TextScaled = true
FlyLabel.Font = Enum.Font.GothamBold

-- FLY Toggle
local FlyToggle = Instance.new("TextButton")
FlyToggle.Parent = FlyContent
FlyToggle.Size = UDim2.new(1, 0, 0, 40)
FlyToggle.Position = UDim2.new(0, 0, 0, 40)
FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
FlyToggle.Text = "🕊️ Fly Mode OFF"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextScaled = true
FlyToggle.Font = Enum.Font.GothamBold

local FlyToggleCorner = Instance.new("UICorner")
FlyToggleCorner.CornerRadius = UDim.new(0, 8)
FlyToggleCorner.Parent = FlyToggle

-- ITEMS TAB CONTENT
local ItemsContent = Instance.new("Frame")
ItemsContent.Parent = ContentFrame
ItemsContent.Size = UDim2.new(1, -20, 1, -20)
ItemsContent.Position = UDim2.new(0, 10, 0, 10)
ItemsContent.BackgroundTransparency = 1
ItemsContent.Visible = false

local SpawnCoin = Instance.new("TextButton")
SpawnCoin.Parent = ItemsContent
SpawnCoin.Size = UDim2.new(1, 0, 0, 40)
SpawnCoin.Position = UDim2.new(0, 0, 0, 0)
SpawnCoin.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
SpawnCoin.Text = "💰 Spawn Coin"
SpawnCoin.TextColor3 = Color3.fromRGB(0, 0, 0)
SpawnCoin.TextScaled = true
SpawnCoin.Font = Enum.Font.GothamBold

local SpawnCorner = Instance.new("UICorner")
SpawnCorner.CornerRadius = UDim.new(0, 8)
SpawnCorner.Parent = SpawnCoin

local SpawnGem = Instance.new("TextButton")
SpawnGem.Parent = ItemsContent
SpawnGem.Size = UDim2.new(1, 0, 0, 40)
SpawnGem.Position = UDim2.new(0, 0, 0, 50)
SpawnGem.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
SpawnGem.Text = "💎 Spawn Gem"
SpawnGem.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnGem.TextScaled = true
SpawnGem.Font = Enum.Font.GothamBold

local SpawnGemCorner = Instance.new("UICorner")
SpawnGemCorner.CornerRadius = UDim.new(0, 8)
SpawnGemCorner.Parent = SpawnGem

-- SETTINGS TAB CONTENT
local SettingsContent = Instance.new("Frame")
SettingsContent.Parent = ContentFrame
SettingsContent.Size = UDim2.new(1, -20, 1, -20)
SettingsContent.Position = UDim2.new(0, 10, 0, 10)
SettingsContent.BackgroundTransparency = 1
SettingsContent.Visible = false

-- Tab switching functionality
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Update tab colors
        for j, b in ipairs(tabButtons) do
            b.BackgroundColor3 = j == i and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 70)
        end
        
        -- Show/hide content
        PlayerContent.Visible = (i == 1)
        FlyContent.Visible = (i == 2)
        ItemsContent.Visible = (i == 3)
        SettingsContent.Visible = (i == 4)
    end)
end

-- Minimize functionality
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 400, 0, 90)  -- Only title bar + tabs visible
        MinimizeBtn.Text = "🔼"
        ContentFrame.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 400, 0, 500)
        MinimizeBtn.Text = "🔽"
        ContentFrame.Visible = true
    end
end)

-- Close button
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- God Mode functionality
local godModeActive = false
GodToggle.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        GodToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        GodToggle.Text = "ON"
        
        local player = game.Players.LocalPlayer
        spawn(function()
            while godModeActive do
                wait(0.1)
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.MaxHealth = math.huge
                    player.Character.Humanoid.Health = math.huge
                end
            end
        end)
    else
        GodToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        GodToggle.Text = "OFF"
    end
end)

-- Fly Mode functionality
local flyModeActive = false
local flyConnection = nil

FlyToggle.MouseButton1Click:Connect(function()
    flyModeActive = not flyModeActive
    if flyModeActive then
        FlyToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        FlyToggle.Text = "🕊️ Fly Mode ON"
        
        local player = game.Players.LocalPlayer
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            local bodyGyro = Instance.new("BodyGyro")
            local bodyVelocity = Instance.new("BodyVelocity")
            
            bodyGyro.Parent = root
            bodyVelocity.Parent = root
            
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.cframe = root.CFrame
            
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            
            flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
                local moveDirection = Vector3.new(0, 0, 0)
                local input = game:GetService("UserInputService")
                
                if input:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
                end
                if input:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
                end
                if input:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
                end
                if input:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
                end
                if input:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if input:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDirection * 100
            end)
        end
    else
        FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        FlyToggle.Text = "🕊️ Fly Mode OFF"
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        local player = game.Players.LocalPlayer
        if player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if root:FindFirstChild("BodyGyro") then
                    root.BodyGyro:Destroy()
                end
                if root:FindFirstChild("BodyVelocity") then
                    root.BodyVelocity:Destroy()
                end
            end
        end
    end
end)

-- Spawn Coin functionality
SpawnCoin.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if root then
        local coin = Instance.new("Part")
        coin.Name = "Coin"
        coin.Size = Vector3.new(1, 0.3, 1)
        coin.BrickColor = BrickColor.new("Bright yellow")
        coin.Material = Enum.Material.Neon
        coin.CFrame = root.CFrame * CFrame.new(3, 5, 3)
        coin.Parent = workspace
        
        spawn(function()
            local t = 0
            while coin and coin.Parent do
                t = t + 0.05
                coin.CFrame = coin.CFrame * CFrame.new(0, math.sin(t) * 0.2, 0)
                wait(0.05)
            end
        end)
    end
end)

-- Spawn Gem functionality
SpawnGem.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if root then
        local gem = Instance.new("Part")
        gem.Name = "Gem"
        gem.Size = Vector3.new(1, 1, 1)
        gem.BrickColor = BrickColor.new("Bright blue")
        gem.Material = Enum.Material.Diamond
        gem.CFrame = root.CFrame * CFrame.new(-3, 5, -3)
        gem.Parent = workspace
        
        spawn(function()
            local t = 0
            while gem and gem.Parent do
                t = t + 0.05
                gem.CFrame = gem.CFrame * CFrame.new(0, math.sin(t) * 0.2, 0)
                wait(0.05)
            end
        end)
    end
end)

-- Floating notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ HERO CONFIG",
    Text = "Window Loaded! Drag the window anywhere!",
    Icon = "rbxassetid://3926305904",
    Duration = 3
})

print("✅ WINDOW LOADED - LOOK FOR IT ON SCREEN!")
