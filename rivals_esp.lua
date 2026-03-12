-- [[ ABHISHEK MOD v2 - UPDATED WITH AUTO FIRE ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS & VARIABLES ---
_G.Aimbot = false
_G.AutoFire = false -- Naya Feature
_G.AimbotFOV = 150
_G.ESP_Box = false
_G.ESP_Lines = false
_G.ESP_Name = false
_G.ESP_Health = false

-- Color Presets
local ColorPresets = {
    {Name = "Premium Green", Color = Color3.fromRGB(0, 255, 127)},
    {Name = "Red", Color = Color3.fromRGB(255, 0, 0)},
    {Name = "Blue", Color = Color3.fromRGB(0, 100, 255)},
    {Name = "Pink", Color = Color3.fromRGB(255, 105, 180)},
    {Name = "Yellow", Color = Color3.fromRGB(255, 255, 0)},
    {Name = "White", Color = Color3.fromRGB(255, 255, 255)}
}
_G.ESP_ColorIndex = 1
_G.FOV_ColorIndex = 1

local function GetESPColor() return ColorPresets[_G.ESP_ColorIndex].Color end
local function GetFOVColor() return ColorPresets[_G.FOV_ColorIndex].Color end

-- --- 1. GUI CREATION ---
local GUI = Instance.new("ScreenGui")
GUI.Name = "AbhishekPremium_Final"
local success = pcall(function() GUI.Parent = CoreGui end)
if not success then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 380, 0, 300) -- Size thoda badhaya naye button ke liye
Main.Position = UDim2.new(0.5, -190, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)

-- --- TABS SETUP ---
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 95, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -105, 1, -40); Pages.Position = UDim2.new(0, 100, 0, 40); Pages.BackgroundTransparency = 1

local PageMain = Instance.new("ScrollingFrame", Pages); PageMain.Size = UDim2.new(1,0,1,0); PageMain.BackgroundTransparency = 1; PageMain.ScrollBarThickness = 0
local LayoutMain = Instance.new("UIListLayout", PageMain); LayoutMain.Padding = UDim.new(0, 8); LayoutMain.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- --- TOGGLE HELPER ---
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = _G[varName] and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    end)
end

-- MAIN TAB FUNCTIONS
CreateToggle(PageMain, "Enable Aimbot", "Aimbot")
CreateToggle(PageMain, "Enable Auto Fire", "AutoFire") -- AUTO FIRE BUTTON ADDED

-- --- GAME LOGIC ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Filled = false

local function GetTarget()
    local target, dist = nil, _G.AimbotFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if screen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end

-- AUTO FIRE LOGIC
local function CheckAndFire()
    if not _G.AutoFire then return end
    
    -- Mouse ke neeche player check karna
    local mousePos = UserInputService:GetMouseLocation()
    local unitRay = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if result and result.Instance then
        local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
        if hitModel and hitModel:FindFirstChild("Humanoid") then
            -- Click Simulation
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Color = GetFOVColor()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local t = GetTarget()
        if t then 
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), 0.3) 
            -- Agar aimbot ON hai aur target lock hai, toh bhi fire karo
            if _G.AutoFire then CheckAndFire() end
        end
    end
    
    -- Alag se check karo agar aimbot OFF hai toh bhi (Trigger Bot mode)
    if _G.AutoFire and not _G.Aimbot then
        CheckAndFire()
    end
end)
