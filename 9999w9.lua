--[[
╔═══════════════════════════════════════════════════════════╗
║         ROBLOX ULTIMATE SCRIPT v12.0 - STYLISH EDITION    ║
║         ✓ Item Spawn Fixed ✓ Draggable Window ✓ Stylish UI║
║         ✓ Floating Button ✓ All Features Working          ║
║         Created by HERO CONFIG                             ║
╚═══════════════════════════════════════════════════════════╝
]]

-- ============================================
-- STYLISH FLOATING BUTTON (Minimize/Maximize)
-- ============================================

-- Create floating button first (before UI loads)
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "HeroConfigFloatingButton"
FloatingButton.Parent = game.CoreGui
FloatingButton.Size = UDim2.new(0, 70, 0, 70)
FloatingButton.Position = UDim2.new(0, 20, 0, 100)  -- Left side
FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
FloatingButton.BackgroundTransparency = 0.2
FloatingButton.BorderSize = 0
FloatingButton.Image = "rbxassetid://3926305904"  -- Roblox icon
FloatingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Draggable = true  -- Make it draggable!
FloatingButton.Active = true
FloatingButton.Selectable = true

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 35)
UICorner.Parent = FloatingButton

-- Glow effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 200, 255)
UIStroke.Transparency = 0.3
UIStroke.Parent = FloatingButton

-- Button text
local ButtonText = Instance.new("TextLabel")
ButtonText.Parent = FloatingButton
ButtonText.Size = UDim2.new(1, 0, 1, 0)
ButtonText.BackgroundTransparency = 1
ButtonText.Text = "⚡"
ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonText.TextScaled = true
ButtonText.Font = Enum.Font.GothamBold

-- ============================================
-- LOAD UI LIBRARY
-- ============================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🔥 HERO CONFIG ULTIMATE", "OceanTheme")

-- Hide main UI initially? No, show it
Window.MainFrame.Visible = true

-- ============================================
-- FLOATING BUTTON FUNCTIONALITY
-- ============================================

FloatingButton.MouseButton1Click:Connect(function()
    if Window.MainFrame.Visible then
        Window.MainFrame.Visible = false
        ButtonText.Text = "🔆"
        FloatingButton.Size = UDim2.new(0, 90, 0, 90)  -- Bigger when minimized
        -- Change color when minimized
        FloatingButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        UIStroke.Color = Color3.fromRGB(255, 100, 100)
    else
        Window.MainFrame.Visible = true
        ButtonText.Text = "⚡"
        FloatingButton.Size = UDim2.new(0, 70, 0, 70)  -- Normal size
        FloatingButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        UIStroke.Color = Color3.fromRGB(0, 200, 255)
    end
end)

-- ============================================
-- MAKE MAIN WINDOW DRAGGABLE
-- ============================================

-- Ensure main window is draggable
if Window.MainFrame then
    Window.MainFrame.Draggable = true
    Window.MainFrame.Active = true
    Window.MainFrame.Selectable = true
    
    -- Add a nice title bar for dragging
    local TitleBar = Instance.new("Frame")
    TitleBar.Parent = Window.MainFrame
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.Position = UDim2.new(0, 0, 0, -35)  -- Above the window
    TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.BorderSize = 0
    TitleBar.ZIndex = 10
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Parent = TitleBar
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = "🔥 HERO CONFIG ULTIMATE"
    TitleText.TextColor3 = Color3.fromRGB(0, 200, 255)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.TextScaled = true
    TitleText.Font = Enum.Font.GothamBold
    TitleText.ZIndex = 11
    
    -- Make title bar draggable too
    TitleBar.Active = true
    TitleBar.Selectable = true
    TitleBar.Draggable = true
end

-- ============================================
-- PLAYER VARIABLES
-- ============================================

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ============================================
-- STYLISH BUTTONS FUNCTION
-- ============================================

function createStylishButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.Position = UDim2.new(0.05, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
    frame.BackgroundTransparency = 0.2
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Parent = frame
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 70, 90)
    button.BackgroundTransparency = 0.3
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = button
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(80, 90, 120)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60, 70, 90)
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return frame
end

-- ============================================
-- ITEM SPAWNER FUNCTIONS (FIXED)
-- ============================================

function spawnItem(position, itemType)
    local item = Instance.new("Part")
    item.Name = itemType or "Item"
    item.Size = Vector3.new(1.5, 1.5, 1.5)
    item.Anchored = false
    item.CanCollide = true
    item.BrickColor = BrickColor.new("Bright yellow")
    item.Material = Enum.Material.Neon
    
    -- Style based on item type
    if itemType == "Coin" or itemType == "coin" then
        item.BrickColor = BrickColor.new("Bright yellow")
        item.Shape = Enum.PartType.Cylinder
        item.Size = Vector3.new(1, 0.3, 1)
    elseif itemType == "Gem" or itemType == "gem" then
        item.BrickColor = BrickColor.new("Bright blue")
        item.Material = Enum.Material.Diamond
    elseif itemType == "Health" or itemType == "health" then
        item.BrickColor = BrickColor.new("Bright red")
        item.Size = Vector3.new(1, 1, 1)
    elseif itemType == "Key" or itemType == "key" then
        item.BrickColor = BrickColor.new("Gold")
        item.Size = Vector3.new(0.5, 1, 0.5)
    end
    
    item.CFrame = CFrame.new(position)
    item.Parent = workspace
    
    -- Add click detector for pickup
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.Parent = item
    clickDetector.MaxActivationDistance = 20
    
    clickDetector.MouseClick:Connect(function(player)
        if player == Player then
            item:Destroy()
            notify("✅", "Collected", itemType or "Item")
        end
    end)
    
    -- Add glow effect
    local selectionBox = Instance.new("SelectionBox")
    selectionBox.Parent = item
    selectionBox.Adornee = item
    selectionBox.LineThickness = 0.05
    selectionBox.Color3 = item.BrickColor.Color
    
    -- Floating animation
    spawn(function()
        local t = 0
        while item and item.Parent do
            t = t + 0.05
            item.CFrame = CFrame.new(position) * CFrame.new(0, math.sin(t) * 0.5, 0)
            wait(0.05)
        end
    end)
    
    return item
end

function notify(icon, title, message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Icon = icon,
        Duration = 3
    })
end

-- ============================================
-- CREATE TABS
-- ============================================

-- MAIN TAB
local MainTab = Window:NewTab("🏠 MAIN")
local MainSection = MainTab:NewSection("Quick Actions")

-- Stylish buttons in main section
local btnFrame = Instance.new("Frame")
btnFrame.Parent = MainSection.Section
btnFrame.Size = UDim2.new(1, -20, 0, 200)
btnFrame.Position = UDim2.new(0, 10, 0, 40)
btnFrame.BackgroundTransparency = 1

local yPos = 0
local buttons = {
    {"✨ SPAWN COIN", function() spawnItem(RootPart.Position + Vector3.new(5, 5, 0), "Coin") end},
    {"💎 SPAWN GEM", function() spawnItem(RootPart.Position + Vector3.new(0, 5, 5), "Gem") end},
    {"❤️ SPAWN HEALTH", function() spawnItem(RootPart.Position + Vector3.new(-5, 5, 0), "Health") end},
    {"🔑 SPAWN KEY", function() spawnItem(RootPart.Position + Vector3.new(0, 5, -5), "Key") end}
}

for _, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Parent = btnFrame
    btn.Size = UDim2.new(0.45, 0, 0, 40)
    btn.Position = UDim2.new(_ % 2 == 0 and 0.02 or 0.52, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(60, 70, 90)
    btn.Text = btnData[1]
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(btnData[2])
    
    if _ % 2 == 0 then
        yPos = yPos + 45
    end
end

-- PLAYER TAB
local PlayerTab = Window:NewTab("👤 PLAYER")
local PlayerSection = PlayerTab:NewSection("Player Controls")

-- WalkSpeed Slider with style
local speedSlider = Instance.new("Frame")
speedSlider.Parent = PlayerSection.Section
speedSlider.Size = UDim2.new(0.9, 0, 0, 60)
speedSlider.Position = UDim2.new(0.05, 0, 0, 10)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
speedSlider.BackgroundTransparency = 0.2

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = speedSlider

local sliderText = Instance.new("TextLabel")
sliderText.Parent = speedSlider
sliderText.Size = UDim2.new(1, -20, 0, 25)
sliderText.Position = UDim2.new(0, 10, 0, 5)
sliderText.BackgroundTransparency = 1
sliderText.Text = "🏃 WalkSpeed: 16"
sliderText.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderText.TextXAlignment = Enum.TextXAlignment.Left
sliderText.TextScaled = true
sliderText.Font = Enum.Font.Gotham

PlayerSection:NewSlider("", "", 500, 16, function(v)
    Humanoid.WalkSpeed = v
    sliderText.Text = "🏃 WalkSpeed: " .. v
end)

-- Jump Power Slider
local jumpSlider = Instance.new("Frame")
jumpSlider.Parent = PlayerSection.Section
jumpSlider.Size = UDim2.new(0.9, 0, 0, 60)
jumpSlider.Position = UDim2.new(0.05, 0, 0, 80)
jumpSlider.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
jumpSlider.BackgroundTransparency = 0.2

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 10)
jumpCorner.Parent = jumpSlider

local jumpText = Instance.new("TextLabel")
jumpText.Parent = jumpSlider
jumpText.Size = UDim2.new(1, -20, 0, 25)
jumpText.Position = UDim2.new(0, 10, 0, 5)
jumpText.BackgroundTransparency = 1
jumpText.Text = "🦘 Jump Power: 50"
jumpText.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpText.TextXAlignment = Enum.TextXAlignment.Left
jumpText.TextScaled = true
jumpText.Font = Enum.Font.Gotham

PlayerSection:NewSlider("", "", 500, 50, function(v)
    Humanoid.JumpPower = v
    jumpText.Text = "🦘 Jump Power: " .. v
end)

-- God Mode Toggle (Stylish)
local godFrame = Instance.new("Frame")
godFrame.Parent = PlayerSection.Section
godFrame.Size = UDim2.new(0.9, 0, 0, 45)
godFrame.Position = UDim2.new(0.05, 0, 0, 150)
godFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
godFrame.BackgroundTransparency = 0.2

local godCorner = Instance.new("UICorner")
godCorner.CornerRadius = UDim.new(0, 10)
godCorner.Parent = godFrame

local godLabel = Instance.new("TextLabel")
godLabel.Parent = godFrame
godLabel.Size = UDim2.new(0.6, 0, 1, 0)
godLabel.Position = UDim2.new(0, 10, 0, 0)
godLabel.BackgroundTransparency = 1
godLabel.Text = "🛡️ God Mode"
godLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
godLabel.TextXAlignment = Enum.TextXAlignment.Left
godLabel.TextScaled = true
godLabel.Font = Enum.Font.Gotham

local godToggle = Instance.new("TextButton")
godToggle.Parent = godFrame
godToggle.Size = UDim2.new(0, 70, 0, 30)
godToggle.Position = UDim2.new(1, -80, 0.5, -15)
godToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
godToggle.Text = "OFF"
godToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
godToggle.TextScaled = true
godToggle.Font = Enum.Font.GothamBold

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = godToggle

local godModeActive = false
godToggle.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    if godModeActive then
        godToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        godToggle.Text = "ON"
        -- Activate God Mode
        spawn(function()
            while godModeActive do
                wait(0.1)
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
            end
        end)
        notify("🛡️", "God Mode", "Activated!")
    else
        godToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        godToggle.Text = "OFF"
        notify("🛡️", "God Mode", "Deactivated")
    end
end)

-- FLY TAB
local FlyTab = Window:NewTab("🕊️ FLY")
local FlySection = FlyTab:NewSection("Flight Controls")

-- Fly Mode Toggle
local flyFrame = Instance.new("Frame")
flyFrame.Parent = FlySection.Section
flyFrame.Size = UDim2.new(0.9, 0, 0, 45)
flyFrame.Position = UDim2.new(0.05, 0, 0, 10)
flyFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
flyFrame.BackgroundTransparency = 0.2

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 10)
flyCorner.Parent = flyFrame

local flyLabel = Instance.new("TextLabel")
flyLabel.Parent = flyFrame
flyLabel.Size = UDim2.new(0.6, 0, 1, 0)
flyLabel.Position = UDim2.new(0, 10, 0, 0)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "🦅 Fly Mode"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.TextXAlignment = Enum.TextXAlignment.Left
flyLabel.TextScaled = true
flyLabel.Font = Enum.Font.Gotham

local flyToggle = Instance.new("TextButton")
flyToggle.Parent = flyFrame
flyToggle.Size = UDim2.new(0, 70, 0, 30)
flyToggle.Position = UDim2.new(1, -80, 0.5, -15)
flyToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
flyToggle.Text = "OFF"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.TextScaled = true
flyToggle.Font = Enum.Font.GothamBold

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 8)
flyToggleCorner.Parent = flyToggle

local FlyMode = false
local FlyConnection = nil

flyToggle.MouseButton1Click:Connect(function()
    FlyMode = not FlyMode
    if FlyMode then
        flyToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        flyToggle.Text = "ON"
        
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.Parent = RootPart
        BodyVelocity.Parent = RootPart
        
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.cframe = RootPart.CFrame
        
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        FlyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            BodyGyro.cframe = RootPart.CFrame
            
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
            
            BodyVelocity.Velocity = moveDirection * 100
        end)
        
        notify("🕊️", "Fly Mode", "Activated!")
    else
        flyToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        flyToggle.Text = "OFF"
        
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        if RootPart:FindFirstChild("BodyGyro") then
            RootPart.BodyGyro:Destroy()
        end
        if RootPart:FindFirstChild("BodyVelocity") then
            RootPart.BodyVelocity:Destroy()
        end
        
        notify("🕊️", "Fly Mode", "Deactivated")
    end
end)

-- ITEM SPAWNER TAB
local ItemTab = Window:NewTab("📦 ITEMS")
local ItemSection = ItemTab:NewSection("Item Spawner")

-- Spawn at Player button
local spawnPlayerBtn = createStylishButton(ItemSection.Section, "📦 Spawn at Player", function()
    spawnItem(RootPart.Position + Vector3.new(0, 5, 5), "Coin")
    notify("✅", "Spawned", "Item at your position")
end)
spawnPlayerBtn.Position = UDim2.new(0.05, 0, 0, 10)

-- Spawn at Mouse button
local spawnMouseBtn = createStylishButton(ItemSection.Section, "🖱️ Spawn at Mouse", function()
    local mouse = Player:GetMouse()
    spawnItem(mouse.Hit.p + Vector3.new(0, 2, 0), "Gem")
    notify("✅", "Spawned", "Item at mouse position")
end)
spawnMouseBtn.Position = UDim2.new(0.05, 0, 0, 60)

-- Spawn Circle button
local spawnCircleBtn = createStylishButton(ItemSection.Section, "⭕ Spawn Circle", function()
    for i = 1, 8 do
        local angle = (i / 8) * math.pi * 2
        local pos = RootPart.Position + Vector3.new(math.cos(angle) * 5, 3, math.sin(angle) * 5)
        spawnItem(pos, "Coin")
    end
    notify("✅", "Spawned", "8 items in a circle")
end)
spawnCircleBtn.Position = UDim2.new(0.05, 0, 0, 110)

-- Spawn Chest button
local spawnChestBtn = createStylishButton(ItemSection.Section, "📦 Spawn Chest", function()
    local chest = Instance.new("Part")
    chest.Name = "Treasure Chest"
    chest.Size = Vector3.new(4, 3, 4)
    chest.BrickColor = BrickColor.new("Brown")
    chest.Material = Enum.Material.Wood
    chest.CFrame = RootPart.CFrame * CFrame.new(0, 2, 10)
    chest.Anchored = false
    chest.Parent = workspace
    
    -- Lid
    local lid = Instance.new("Part")
    lid.Name = "Lid"
    lid.Size = Vector3.new(4, 0.5, 4)
    lid.BrickColor = BrickColor.new("Brown")
    lid.Material = Enum.Material.Wood
    lid.CFrame = chest.CFrame * CFrame.new(0, 1.75, 0)
    lid.Parent = chest
    
    notify("📦", "Chest Spawned", "Open it!")
end)
spawnChestBtn.Position = UDim2.new(0.05, 0, 0, 160)

-- Item Magnet Toggle
local magnetFrame = Instance.new("Frame")
magnetFrame.Parent = ItemSection.Section
magnetFrame.Size = UDim2.new(0.9, 0, 0, 45)
magnetFrame.Position = UDim2.new(0.05, 0, 0, 215)
magnetFrame.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
magnetFrame.BackgroundTransparency = 0.2

local magnetCorner = Instance.new("UICorner")
magnetCorner.CornerRadius = UDim.new(0, 10)
magnetCorner.Parent = magnetFrame

local magnetLabel = Instance.new("TextLabel")
magnetLabel.Parent = magnetFrame
magnetLabel.Size = UDim2.new(0.6, 0, 1, 0)
magnetLabel.Position = UDim2.new(0, 10, 0, 0)
magnetLabel.BackgroundTransparency = 1
magnetLabel.Text = "🧲 Item Magnet"
magnetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
magnetLabel.TextXAlignment = Enum.TextXAlignment.Left
magnetLabel.TextScaled = true
magnetLabel.Font = Enum.Font.Gotham

local magnetToggle = Instance.new("TextButton")
magnetToggle.Parent = magnetFrame
magnetToggle.Size = UDim2.new(0, 70, 0, 30)
magnetToggle.Position = UDim2.new(1, -80, 0.5, -15)
magnetToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
magnetToggle.Text = "OFF"
magnetToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
magnetToggle.TextScaled = true
magnetToggle.Font = Enum.Font.GothamBold

local magnetToggleCorner = Instance.new("UICorner")
magnetToggleCorner.CornerRadius = UDim.new(0, 8)
magnetToggleCorner.Parent = magnetToggle

local ItemMagnet = false
magnetToggle.MouseButton1Click:Connect(function()
    ItemMagnet = not ItemMagnet
    if ItemMagnet then
        magnetToggle.BackgroundColor3 = Color3.fromRGB(80, 255, 80)
        magnetToggle.Text = "ON"
        
        spawn(function()
            while ItemMagnet do
                wait(0.1)
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and v.Name ~= "HumanoidRootPart" and v.Parent ~= Character then
                        if (v.Position - RootPart.Position).Magnitude < 30 then
                            v.CFrame = RootPart.CFrame * CFrame.new(0, 5, 0)
                        end
                    end
                end
            end
        end)
        
        notify("🧲", "Item Magnet", "ON")
    else
        magnetToggle.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        magnetToggle.Text = "OFF"
        notify("🧲", "Item Magnet", "OFF")
    end
end)

-- ============================================
-- FLOATING BUTTON POSITION SAVING
-- ============================================

-- Make floating button always on top
FloatingButton.ZIndex = 1000
FloatingButton.Active = true
FloatingButton.Draggable = true

-- ============================================
-- INITIALIZATION
-- ============================================

notify("🔥", "HERO CONFIG ULTIMATE", "All features loaded!")
print("✅ ULTIMATE SCRIPT LOADED - FLOATING BUTTON ACTIVE")
print("👑 Created by HERO CONFIG")

-- ============================================
-- END OF SCRIPT
-- ============================================
