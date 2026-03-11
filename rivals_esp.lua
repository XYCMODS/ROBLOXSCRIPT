local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Variables
_G.Aimbot = false
_G.ESP = false
_G.FOV = 150

-- UI Creation
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local UICorner = Instance.new("UICorner", MainFrame)
local UIStroke = Instance.new("UIStroke", MainFrame)
local ImageLabel = Instance.new("ImageLabel", MainFrame)
local Title = Instance.new("TextLabel", MainFrame)

-- Window Design
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.CornerRadius = UDim.new(0, 15)
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 2

-- User Image
ImageLabel.Size = UDim2.new(0, 60, 0, 60)
ImageLabel.Position = UDim2.new(0.5, -30, 0.05, 0)
ImageLabel.Image = "rbxassetid://18635887222" -- Default ID or direct link support needs special handling in Roblox, using proxy
ImageLabel.BackgroundTransparency = 1
-- Note: Direct external URLs sometimes need a proxy, setting up the layout first

Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0.25, 0)
Title.Text = "ABHISHEK MOD"
Title.TextColor3 = Color3.fromRGB(0, 255, 150)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- Button Generator Function
local function CreateButton(name, pos, callback)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = pos
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(0, 255, 150)
FOVCircle.Visible = false
FOVCircle.NumSides = 64

-- Features
CreateButton("ESP: OFF", UDim2.new(0.1, 0, 0.4, 0), function(btn)
    _G.ESP = not _G.ESP
    btn.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
    btn.BackgroundColor3 = _G.ESP and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(35, 35, 35)
end)

CreateButton("AIMBOT: OFF", UDim2.new(0.1, 0, 0.55, 0), function(btn)
    _G.Aimbot = not _G.Aimbot
    FOVCircle.Visible = _G.Aimbot
    btn.Text = _G.Aimbot and "AIMBOT: ON" or "AIMBOT: OFF"
    btn.BackgroundColor3 = _G.Aimbot and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(35, 35, 35)
end)

CreateButton("CLOSE MENU", UDim2.new(0.1, 0, 0.85, 0), function()
    ScreenGui:Destroy()
    FOVCircle:Remove()
end)

-- Aimbot Logic
local function GetTarget()
    local closest = nil
    local dist = _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then
                    dist = mag
                    closest = v
                end
            end
        end
    end
    return closest
end

-- ESP logic
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    FOVCircle.Radius = _G.FOV
    
    if _G.Aimbot then
        local target = GetTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            local char = p.Character
            local h = char:FindFirstChild("AB_High") or Instance.new("Highlight", char)
            h.Name = "AB_High"
            h.Enabled = _G.ESP
            h.FillColor = Color3.fromRGB(0, 255, 150)
            
            local head = char:FindFirstChild("Head")
            if head then
                local bill = head:FindFirstChild("AB_Label") or Instance.new("BillboardGui", head)
                bill.Name = "AB_Label"
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                bill.ExtentsOffset = Vector3.new(0, 2, 0)
                
                local txt = bill:FindFirstChild("Txt") or Instance.new("TextLabel", bill)
                txt.Name = "Txt"
                txt.BackgroundTransparency = 1
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                txt.TextSize = 10
                txt.Font = Enum.Font.GothamBold
                txt.Visible = _G.ESP
                
                local dist = math.floor((head.Position - Camera.CFrame.Position).Magnitude)
                txt.Text = p.Name .. " | " .. math.floor(char.Humanoid.Health) .. "HP\n" .. dist .. "m"
            end
        end
    end
end)
