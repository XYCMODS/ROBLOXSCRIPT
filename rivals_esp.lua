local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.Aimbot = false
_G.ESP = false
_G.FOV = 150

-- --- UI CREATION ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", MainFrame)
local ToggleESP = Instance.new("TextButton", MainFrame)
local ToggleAimbot = Instance.new("TextButton", MainFrame)

-- Frame Style
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true -- Mobile friendly drag

local Corner = Instance.new("UICorner", MainFrame)
Corner.CornerRadius = UDim.new(0, 10)

-- Title: ABHISHEK MOD
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ABHISHEK MOD"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- ESP Button
ToggleESP.Size = UDim2.new(0.8, 0, 0, 40)
ToggleESP.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleESP.Text = "ESP: OFF"
ToggleESP.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleESP.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Aimbot Button
ToggleAimbot.Size = UDim2.new(0.8, 0, 0, 40)
ToggleAimbot.Position = UDim2.new(0.1, 0, 0.55, 0)
ToggleAimbot.Text = "AIMBOT: OFF"
ToggleAimbot.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleAimbot.TextColor3 = Color3.fromRGB(255, 255, 255)

-- --- FOV CIRCLE ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Radius = _G.FOV
FOVCircle.Visible = true

-- --- AIMBOT LOGIC ---
local function GetClosestPlayer()
    local closestDist = _G.FOV
    local target = nil
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    target = v
                end
            end
        end
    end
    return target
end

-- --- ESP LOGIC (Highlight + Info) ---
local function ApplyESP(p)
    if p.Character then
        -- Highlight (Walls ke paar dekhne ke liye)
        local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
        h.Enabled = _G.ESP
        h.FillColor = Color3.fromRGB(255, 0, 0)
        
        -- Billboard for Name, Health, Distance
        local b = p.Character:FindFirstChild("Head"):FindFirstChild("Info") or Instance.new("BillboardGui", p.Character:FindFirstChild("Head"))
        b.Name = "Info"
        b.Size = UDim2.new(0, 100, 0, 50)
        b.AlwaysOnTop = true
        b.ExtentsOffset = Vector3.new(0, 2, 0)
        
        local l = b:FindFirstChild("Label") or Instance.new("TextLabel", b)
        l.Name = "Label"
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, 0, 1, 0)
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.TextStrokeTransparency = 0
        l.TextSize = 12
        l.Visible = _G.ESP
        
        local health = math.floor(p.Character.Humanoid.Health)
        local dist = math.floor((p.Character.HumanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        l.Text = string.format("%s\nHP: %s | %s m", p.Name, health, dist)
    end
end

-- --- MAIN LOOP ---
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    if _G.Aimbot then
        local target = GetClosestPlayer()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer then ApplyESP(p) end
    end
end)

-- Buttons Connect
ToggleESP.MouseButton1Click:Connect(function()
    _G.ESP = not _G.ESP
    ToggleESP.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    ToggleESP.BackgroundColor3 = _G.ESP and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(40, 40, 40)
end)

ToggleAimbot.MouseButton1Click:Connect(function()
    _G.Aimbot = not _G.Aimbot
    ToggleAimbot.Text = _G.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    ToggleAimbot.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(40, 40, 40)
end)
