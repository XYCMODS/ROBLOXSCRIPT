local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Variables
_G.Aimbot = false
_G.ESP = false
_G.FOV = 120

-- --- SIMPLE UI ---
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", MainFrame)
local Scroll = Instance.new("ScrollingFrame", MainFrame)
local Layout = Instance.new("UIListLayout", Scroll)

-- Window Style
MainFrame.Size = UDim2.new(0, 180, 0, 220)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Mobile friendly

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 1.5

-- Title
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "ABHISHEK MOD"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

-- Scroll Area
Scroll.Size = UDim2.new(1, -10, 1, -45)
Scroll.Position = UDim2.new(0, 5, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 0
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Button Function
local function AddButton(text, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- FOV Circle Drawing
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 255, 127)
FOVCircle.Visible = false
FOVCircle.Transparency = 0.8

-- --- FEATURES ---

AddButton("ESP: OFF", function(btn)
    _G.ESP = not _G.ESP
    btn.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    btn.TextColor3 = _G.ESP and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
end)

AddButton("AIMBOT: OFF", function(btn)
    _G.Aimbot = not _G.Aimbot
    FOVCircle.Visible = _G.Aimbot
    btn.Text = _G.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    btn.TextColor3 = _G.Aimbot and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
end)

AddButton("CLOSE", function()
    ScreenGui:Destroy()
    FOVCircle:Remove()
end)

-- --- LOGIC ---

local function GetClosest()
    local target = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    if _G.Aimbot then
        local t = GetClosest()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Character.Head.Position)
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            -- Highlight (Wallhack)
            local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
            h.Name = "AB_H"
            h.Enabled = _G.ESP
            h.FillColor = Color3.fromRGB(0, 255, 127)
            
            -- Info (Name/HP/Dist)
            local head = p.Character:FindFirstChild("Head")
            if head then
                local b = head:FindFirstChild("AB_B") or Instance.new("BillboardGui", head)
                b.Name = "AB_B"
                b.AlwaysOnTop = true
                b.Size = UDim2.new(0, 100, 0, 40)
                b.ExtentsOffset = Vector3.new(0, 2, 0)
                
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.Name = "L"
                l.BackgroundTransparency = 1
                l.Size = UDim2.new(1, 0, 1, 0)
                l.TextColor3 = Color3.fromRGB(255, 255, 255)
                l.TextSize = 11
                l.Font = Enum.Font.GothamBold
                l.Visible = _G.ESP
                
                local hp = math.floor(p.Character.Humanoid.Health)
                local d = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                l.Text = p.Name .. "\n" .. hp .. "HP | " .. d .. "m"
            end
        end
    end
end)
