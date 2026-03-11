--// ================= DEBUG SYSTEM =================
local DEBUG = true
local function log(msg)
    if DEBUG then
        print("[ABHISHEK DEBUG]: "..msg)
    end
end

log("Script Started")

--// ================= LOADER UI =================
local CoreGui = game:GetService("CoreGui")

local Loader = Instance.new("ScreenGui", CoreGui)
Loader.Name = "AbhishekLoader"

local LFrame = Instance.new("Frame", Loader)
LFrame.Size = UDim2.new(0,220,0,80)
LFrame.Position = UDim2.new(0.5,-110,0.5,-40)
LFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", LFrame)

local LStroke = Instance.new("UIStroke", LFrame)
LStroke.Color = Color3.fromRGB(0,255,140)

local LText = Instance.new("TextLabel", LFrame)
LText.Size = UDim2.new(1,0,1,0)
LText.BackgroundTransparency = 1
LText.Font = Enum.Font.GothamBold
LText.TextSize = 16
LText.TextColor3 = Color3.fromRGB(0,255,140)
LText.Text = "Loading Script..."

task.spawn(function()
    while Loader.Parent do
        LText.Text = "Loading Script."
        task.wait(0.4)
        LText.Text = "Loading Script.."
        task.wait(0.4)
        LText.Text = "Loading Script..."
        task.wait(0.4)
    end
end)

--// ================= ERROR CATCH =================
local success, err = pcall(function()

log("Services Loading")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera

log("Services Loaded")

-- SETTINGS
_G.Aimbot = false
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_Health = false
_G.FOV = 150

-- ================= UI =================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AbhishekUltra"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0,300,0,380)
Main.Position = UDim2.new(0.03,-400,0.2,0)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(0,255,140)

local Header = Instance.new("TextLabel", Main)
Header.Size = UDim2.new(1,0,0,45)
Header.Text = "ABHISHEK ULTRA"
Header.Font = Enum.Font.GothamBold
Header.TextSize = 20
Header.TextColor3 = Color3.fromRGB(0,255,140)
Header.BackgroundTransparency = 1

local AimPage = Instance.new("Frame", Main)
AimPage.Size = UDim2.new(1,0,1,-60)
AimPage.Position = UDim2.new(0,0,0,60)
AimPage.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", AimPage)
Layout.Padding = UDim.new(0,8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- TOGGLE
local function Toggle(text,callback)
    local Frame = Instance.new("TextButton", AimPage)
    Frame.Size = UDim2.new(0.9,0,0,40)
    Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Frame.Text = text.." : OFF"
    Frame.TextColor3 = Color3.new(1,1,1)
    Frame.Font = Enum.Font.GothamBold
    Frame.TextSize = 14
    Instance.new("UICorner", Frame)

    local state=false
    Frame.MouseButton1Click:Connect(function()
        state=not state
        callback(state)
        Frame.Text = text.." : "..(state and "ON" or "OFF")
        Frame.BackgroundColor3 = state and Color3.fromRGB(0,170,100) or Color3.fromRGB(30,30,30)
    end)
end

Toggle("Aimbot",function(v) _G.Aimbot=v end)
Toggle("ESP Box",function(v) _G.ESP_Box=v end)
Toggle("ESP Name",function(v) _G.ESP_Name=v end)
Toggle("ESP Health",function(v) _G.ESP_Health=v end)

-- FOV BUTTON
local FovBtn = Instance.new("TextButton", AimPage)
FovBtn.Size = UDim2.new(0.9,0,0,40)
FovBtn.Text = "FOV : ".._G.FOV
FovBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
FovBtn.TextColor3 = Color3.new(1,1,1)
FovBtn.Font = Enum.Font.GothamBold
FovBtn.TextSize = 14
Instance.new("UICorner", FovBtn)

FovBtn.MouseButton1Click:Connect(function()
    if _G.FOV >= 400 then
        _G.FOV = 100
    else
        _G.FOV += 50
    end
    FovBtn.Text = "FOV : ".._G.FOV
end)

TweenService:Create(Main,TweenInfo.new(0.4),{
    Position = UDim2.new(0.03,0,0.2,0)
}):Play()

task.wait(1)
Loader:Destroy()

log("UI Loaded")

-- ================= AIMBOT =================
local function IsVisible(part)
    local char = Players.LocalPlayer.Character
    if not char then return false end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char, part.Parent}

    local origin = Camera.CFrame.Position
    local direction = (part.Position - origin)

    local result = workspace:Raycast(origin,direction,params)
    return result == nil
end

local function GetClosest()
    local target=nil
    local dist=_G.FOV

    for _,v in pairs(Players:GetPlayers()) do
        if v~=Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
            local pos,vis = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if vis then
                local mag = (Vector2.new(pos.X,pos.Y) - Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist and IsVisible(v.Character.Head) then
                    dist=mag
                    target=v
                end
            end
        end
    end

    return target
end

RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local t = GetClosest()
        if t then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position,t.Character.Head.Position)
        end
    end
end)

log("Script Fully Loaded")

end)

if not success then
    warn("SCRIPT ERROR:",err)

    local ErrorGui = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", ErrorGui)
    Frame.Size = UDim2.new(0,300,0,100)
    Frame.Position = UDim2.new(0.5,-150,0.5,-50)
    Frame.BackgroundColor3 = Color3.fromRGB(60,0,0)
    Instance.new("UICorner", Frame)

    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1,0,1,0)
    Text.BackgroundTransparency = 1
    Text.TextColor3 = Color3.new(1,1,1)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 14
    Text.Text = "SCRIPT ERROR\n"..err
end
