local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS (FULL REPAIRED) ---
_G.Aimbot = false
_G.AutoFire = false
_G.AimbotFOV = 150
_G.ShowFOV = true -- FOV hamesha dikhega
_G.ESP_Box = false
_G.ESP_Lines = false
_G.TeamCheck = true
_G.ESP_ColorIndex = 1
_G.FOV_ColorIndex = 1

local ColorPresets = {
    {Name = "Premium Green", Color = Color3.fromRGB(0, 255, 127)},
    {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "White", Color = Color3.fromRGB(255, 255, 255)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)}
}

local function GetESPColor() return ColorPresets[_G.ESP_ColorIndex].Color end
local function GetFOVColor() return ColorPresets[_G.FOV_ColorIndex].Color end

-- --- DRAWING FOV CIRCLE (FIXED VISIBILITY) ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Transparency = 1 -- Poora dikhega
FOVCircle.Visible = true

-- --- WALL CHECK FUNCTION ---
local function IsVisible(part)
    local char = LocalPlayer.Character
    if not char then return false end
    local origin = Camera.CFrame.Position
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {char, part.Parent}
    local result = workspace:Raycast(origin, part.Position - origin, rayParams)
    return result == nil
end

-- --- UI CREATION (OLD PREMIUM STYLE) ---
local GUI = Instance.new("ScreenGui", CoreGui)
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 400, 0, 320); Main.Position = UDim2.new(0.5, -200, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Draggable = true; Main.Active = true
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 127); MainStroke.Thickness = 2

-- Floating Logo
local LogoBtn = Instance.new("ImageButton", GUI)
LogoBtn.Size = UDim2.new(0, 60, 0, 60); LogoBtn.Position = UDim2.new(0, 20, 0, 20)
LogoBtn.Image = "rbxassetid://6031082975"; LogoBtn.Visible = false; LogoBtn.Draggable = true
Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1, 0)
LogoBtn.MouseButton1Click:Connect(function() Main.Visible = true; LogoBtn.Visible = false end)

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.Text = "X"; Close.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
Close.MouseButton1Click:Connect(function() Main.Visible = false; LogoBtn.Visible = true end)

-- Tabs (Sidebar)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Sidebar)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -115, 1, -50); Pages.Position = UDim2.new(0, 110, 0, 45); Pages.BackgroundTransparency = 1

local P_Main = Instance.new("ScrollingFrame", Pages); P_Main.Size = UDim2.new(1,0,1,0); P_Main.BackgroundTransparency = 1; P_Main.ScrollBarThickness = 0
local P_Vis = Instance.new("ScrollingFrame", Pages); P_Vis.Size = UDim2.new(1,0,1,0); P_Vis.Visible = false; P_Vis.BackgroundTransparency = 1; P_Vis.ScrollBarThickness = 0

Instance.new("UIListLayout", P_Main).Padding = UDim.new(0, 5)
Instance.new("UIListLayout", P_Vis).Padding = UDim.new(0, 5)

local function CreateTab(name, pos, page)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamBold"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function() P_Main.Visible = false; P_Vis.Visible = false; page.Visible = true end)
end
CreateTab("MAIN", 10, P_Main); CreateTab("VISUALS", 50, P_Vis)

local function Toggle(parent, text, var)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.Text = text .. (_G[var] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(30, 30, 30)
    end)
end

Toggle(P_Main, "Aimbot", "Aimbot")
Toggle(P_Main, "Auto Fire", "AutoFire")
Toggle(P_Main, "Team Check", "TeamCheck")
Toggle(P_Main, "Show FOV Circle", "ShowFOV")
Toggle(P_Vis, "Box ESP", "ESP_Box")
Toggle(P_Vis, "Line ESP", "ESP_Lines")

-- --- MAIN LOOP ---
local Tracers = {}
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Color = GetFOVColor()
    FOVCircle.Position = UserInputService:GetMouseLocation()

    if _G.Aimbot or _G.AutoFire then
        local target = nil; local dist = _G.AimbotFOV
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
                if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
                
                -- Wall Check Logic
                if IsVisible(v.Character.Head) then
                    local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                    if screen then
                        local mDist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if mDist < dist then dist = mDist; target = v end
                    end
                end
            end
        end

        if target then
            if _G.Aimbot then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), 0.2) end
            if _G.AutoFire then mouse1press(); task.wait(); mouse1release() end
        end
    end

    -- ESP Fix
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local rootPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            
            if _G.ESP_Box and isEnemy and onScreen then
                local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
                h.Name = "AB_H"; h.Enabled = true; h.FillTransparency = 1; h.OutlineColor = GetESPColor()
            elseif p.Character:FindFirstChild("AB_H") then p.Character.AB_H.Enabled = false end
            
            if _G.ESP_Lines and isEnemy and onScreen then
                if not Tracers[p] then Tracers[p] = Drawing.new("Line") end
                Tracers[p].Visible = true; Tracers[p].To = Vector2.new(rootPos.X, rootPos.Y)
                Tracers[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracers[p].Color = GetESPColor()
            elseif Tracers[p] then Tracers[p].Visible = false end
        end
    end
end)
