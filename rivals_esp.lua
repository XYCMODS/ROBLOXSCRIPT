local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7Lib/UI-Library/main/Source.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Variables
_G.AimbotEnabled = false
_G.ESPEnabled = false
_G.FOV = 150
_G.Smoothness = 0.2

-- UI Setup
local Window = Library:CreateWindow("ABHISHEK MOD", "Rivals Pro", "https://i.supaimg.com/8b0f695c-2b86-4162-bacc-ed123dddbfa7/4ee53c99-1d32-4298-aebd-fea26915d594.png")

local MainTab = Window:CreateTab("Main Features")

-- Aimbot Section
MainTab:CreateToggle("Enable Aimbot", function(state)
    _G.AimbotEnabled = state
end)

MainTab:CreateSlider("FOV Size", 50, 500, 150, function(value)
    _G.FOV = value
end)

-- ESP Section
MainTab:CreateToggle("Enable Full ESP", function(state)
    _G.ESPEnabled = state
end)

-- FOV Circle Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false

-- Aimbot Logic (Smooth Lock)
local function GetClosestPlayer()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local pos, screen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if screen then
                local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mouseDist < dist then
                    dist = mouseDist
                    target = v
                end
            end
        end
    end
    return target
end

-- ESP Rendering (Box, Name, Health, Line)
local function ApplyESP(p)
    if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local char = p.Character
    local hrp = char.HumanoidRootPart
    
    -- Highlight for Wallhack
    local highlight = char:FindFirstChild("AB_Highlight") or Instance.new("Highlight", char)
    highlight.Name = "AB_Highlight"
    highlight.Enabled = _G.ESPEnabled
    highlight.FillColor = Color3.fromRGB(255, 0, 50)
    
    -- Info Billboard (Name, Health, Distance)
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("AB_Info") or Instance.new("BillboardGui", head)
        billboard.Name = "AB_Info"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        
        local label = billboard:FindFirstChild("Label") or Instance.new("TextLabel", billboard)
        label.Name = "Label"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1,0,1,0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.Visible = _G.ESPEnabled
        
        local hp = math.floor(char.Humanoid.Health)
        local d = math.floor((hrp.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        label.Text = string.format("%s\nHP: %d | %s m", p.Name, hp, d)
    end
end

-- Render Loop
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    FOVCircle.Visible = _G.AimbotEnabled

    if _G.AimbotEnabled then
        local target = GetClosestPlayer()
        if target then
            local targetPos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            mousemoverel((targetPos.X - Camera.ViewportSize.X/2) * _G.Smoothness, (targetPos.Y - Camera.ViewportSize.Y/2) * _G.Smoothness)
        end
    end

    if _G.ESPEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then ApplyESP(p) end
        end
    end
end)

-- Hide/Close Button (Right Control or UI Button)
MainTab:CreateButton("Destroy Menu", function()
    ScreenGui:Destroy()
    FOVCircle:Remove()
end)

Library:Notify("ABHISHEK MOD Loaded", "Happy Cheating!", 3)
