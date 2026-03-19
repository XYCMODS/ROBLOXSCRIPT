--[[
╔═══════════════════════════════════════════════════════════╗
║                  AIMBOT ULTIMATE UI v2.0                   ║
║         Aimbot | Aim Visible | Aim Kill | Ignore Bot      ║
║                Created by HERO CONFIG                      ║
╚═══════════════════════════════════════════════════════════╝
]]

-- ============================================
-- LOAD UI LIBRARY
-- ============================================

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("🎯 AIMBOT ULTIMATE", "BloodTheme")

-- ============================================
-- MAIN AIMBOT TAB
-- ============================================

local AimbotTab = Window:NewTab("🎯 AIMBOT")
local AimbotSection = AimbotTab:NewSection("Aimbot Controls")

-- ============================================
-- VARIABLES
-- ============================================

local AimbotEnabled = false
local AimVisible = false
local AimKill = false
local IgnoreBot = false

local CurrentTarget = nil
local AimbotConnection = nil

-- ============================================
-- UI ELEMENTS (EXACTLY LIKE YOUR IMAGE)
-- ============================================

-- MAIN AIMBOT TOGGLE
AimbotSection:NewToggle("Aimbot", "Enable/Disable Aimbot", function(state)
    AimbotEnabled = state
    if state then
        startAimbot()
        notify("🎯", "Aimbot", "Enabled")
    else
        stopAimbot()
        notify("🎯", "Aimbot", "Disabled")
    end
end)

-- AIM VISIBLE TOGGLE
AimbotSection:NewToggle("Aim Visible", "Shows aimbot in killcam and replays", function(state)
    AimVisible = state
    if state then
        -- Enable aim visible (visual effect)
        enableAimVisible()
        notify("👁️", "Aim Visible", "Enabled")
    else
        disableAimVisible()
        notify("👁️", "Aim Visible", "Disabled")
    end
end)

-- AIM KILL TOGGLE
AimbotSection:NewToggle("Aim Kill", "Automatically kills enemies when aiming at them", function(state)
    AimKill = state
    if state then
        notify("💀", "Aim Kill", "Enabled - Auto kill active")
    else
        notify("💀", "Aim Kill", "Disabled")
    end
end)

-- IGNORE BOT TOGGLE
AimbotSection:NewToggle("Ignore Bot", "Ignore bot players", function(state)
    IgnoreBot = state
    if state then
        notify("🤖", "Ignore Bot", "Bots will be ignored")
    else
        notify("🤖", "Ignore Bot", "Bots will be targeted")
    end
end)

-- ============================================
-- ADDITIONAL SETTINGS
-- ============================================

local SettingsTab = Window:NewTab("⚙️ SETTINGS")
local SettingsSection = SettingsTab:NewSection("Aimbot Settings")

-- AIMBOT FOV SLIDER
SettingsSection:NewSlider("Aimbot FOV", "Field of view for aimbot", 500, 200, function(v)
    _G.AimbotFOV = v
    notify("📐", "FOV Set", tostring(v))
end)

-- AIMBOT SMOOTHNESS SLIDER
SettingsSection:NewSlider("Smoothness", "How smooth the aimbot moves", 100, 50, function(v)
    _G.AimbotSmoothness = v
end)

-- AIMBOT KEYBIND
SettingsSection:NewKeybind("Aimbot Key", "Key to activate aimbot", Enum.KeyCode.Q, function()
    AimbotEnabled = not AimbotEnabled
    notify("🎯", "Aimbot Toggled", AimbotEnabled and "ON" or "OFF")
end)

-- ============================================
-- TARGET INFO TAB
-- ============================================

local TargetTab = Window:NewTab("🎯 TARGET")
local TargetSection = TargetTab:NewSection("Current Target Info")

-- Target info display
local TargetNameLabel = TargetSection:NewLabel("Target: None")
local TargetHealthLabel = TargetSection:NewLabel("Health: -")
local TargetDistanceLabel = TargetSection:NewLabel("Distance: -")
local TargetTeamLabel = TargetSection:NewLabel("Team: -")

-- ============================================
-- AIMBOT FUNCTIONS
-- ============================================

function getClosestPlayer()
    local closest = nil
    local shortestDistance = _G.AimbotFOV or 200
    local player = game.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Check ignore bot
            if IgnoreBot and v:IsA("Player") and v.Team and v.Team.Name == "Bots" then
                continue
            end
            
            -- Check if visible (if AimVisible is enabled)
            if AimVisible then
                local ray = Ray.new(
                    workspace.CurrentCamera.CFrame.Position,
                    (v.Character.HumanoidRootPart.Position - workspace.CurrentCamera.CFrame.Position).unit * 1000
                )
                local hit, pos = workspace:FindPartOnRay(ray, player.Character)
                if hit and not hit:IsDescendantOf(v.Character) then
                    continue
                end
            end
            
            -- Calculate screen position
            local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(vector.X, vector.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = v
                end
            end
        end
    end
    
    return closest
end

function startAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
    end
    
    AimbotConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not AimbotEnabled then return end
        
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            CurrentTarget = target
            
            -- Update target info
            TargetNameLabel:UpdateText("Target: " .. target.Name)
            if target.Character:FindFirstChild("Humanoid") then
                TargetHealthLabel:UpdateText("Health: " .. math.floor(target.Character.Humanoid.Health))
            end
            TargetDistanceLabel:UpdateText("Distance: " .. math.floor((target.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude))
            
            -- Aim at target
            local targetPos = target.Character.HumanoidRootPart.Position
            local camera = workspace.CurrentCamera
            
            -- Smooth aim
            local smoothness = _G.AimbotSmoothness or 50
            local currentLook = camera.CFrame.LookVector
            local targetLook = (targetPos - camera.CFrame.Position).unit
            local newLook = currentLook:Lerp(targetLook, smoothness / 100)
            
            camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + newLook)
            
            -- Auto kill if enabled
            if AimKill then
                -- Implement kill logic here (game specific)
                -- This is a placeholder
                if target.Character:FindFirstChild("Humanoid") then
                    target.Character.Humanoid.Health = 0
                end
            end
        else
            TargetNameLabel:UpdateText("Target: None")
            TargetHealthLabel:UpdateText("Health: -")
            TargetDistanceLabel:UpdateText("Distance: -")
        end
    end)
end

function stopAimbot()
    if AimbotConnection then
        AimbotConnection:Disconnect()
        AimbotConnection = nil
    end
    TargetNameLabel:UpdateText("Target: None")
    TargetHealthLabel:UpdateText("Health: -")
    TargetDistanceLabel:UpdateText("Distance: -")
end

function enableAimVisible()
    -- Make aimbot visible in killcam/replays
    -- This is a visual effect
    local highlight = Instance.new("Highlight")
    highlight.Name = "AimVisibleHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    
    -- Apply to all players when targeted
    spawn(function()
        while AimVisible do
            wait(0.1)
            if CurrentTarget and CurrentTarget.Character then
                highlight.Parent = CurrentTarget.Character
            end
        end
        highlight:Destroy()
    end)
end

function disableAimVisible()
    -- Remove visual effects
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "AimVisibleHighlight" then
            v:Destroy()
        end
    end
end

-- ============================================
-- NOTIFICATION FUNCTION
-- ============================================

function notify(icon, title, message)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = message,
        Icon = icon,
        Duration = 2
    })
end

-- ============================================
-- VISUAL FEEDBACK (AIM VISIBLE)
-- ============================================

-- Create a FOV circle on screen
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Radius = _G.AimbotFOV or 200
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 2
FOVCircle.NumSides = 60
FOVCircle.Filled = false
FOVCircle.Transparency = 1

-- Toggle FOV circle
local ShowFOV = false
SettingsSection:NewToggle("Show FOV Circle", "Display aimbot field of view", function(state)
    ShowFOV = state
    FOVCircle.Visible = state
end)

-- Update FOV circle position
game:GetService("RunService").RenderStepped:Connect(function()
    if ShowFOV then
        FOVCircle.Position = Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2
        )
        FOVCircle.Radius = _G.AimbotFOV or 200
    end
end)

-- ============================================
-- CROSSHAIR (Optional)
-- ============================================

local CrosshairTab = Window:NewTab("🎯 CROSSHAIR")
local CrosshairSection = CrosshairTab:NewSection("Crosshair Settings")

local CrosshairEnabled = false
CrosshairSection:NewToggle("Enable Crosshair", "Show custom crosshair", function(state)
    CrosshairEnabled = state
end)

-- Create crosshair lines
local CrosshairX = Drawing.new("Line")
CrosshairX.Visible = false
CrosshairX.Color = Color3.fromRGB(255, 255, 255)
CrosshairX.Thickness = 2
CrosshairX.Transparency = 1

local CrosshairY = Drawing.new("Line")
CrosshairY.Visible = false
CrosshairY.Color = Color3.fromRGB(255, 255, 255)
CrosshairY.Thickness = 2
CrosshairY.Transparency = 1

-- Update crosshair
game:GetService("RunService").RenderStepped:Connect(function()
    if CrosshairEnabled then
        local center = workspace.CurrentCamera.ViewportSize / 2
        local size = 10
        
        CrosshairX.From = Vector2.new(center.X - size, center.Y)
        CrosshairX.To = Vector2.new(center.X + size, center.Y)
        CrosshairX.Visible = true
        
        CrosshairY.From = Vector2.new(center.X, center.Y - size)
        CrosshairY.To = Vector2.new(center.X, center.Y + size)
        CrosshairY.Visible = true
    else
        CrosshairX.Visible = false
        CrosshairY.Visible = false
    end
end)

-- ============================================
-- INITIALIZATION
-- ============================================

-- Welcome notification
notify("🎯", "Aimbot Ultimate", "Loaded successfully!")

print("✅ AIMBOT UI LOADED")
print("🎯 Features: Aimbot | Aim Visible | Aim Kill | Ignore Bot")
