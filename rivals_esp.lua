local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- --- SETTINGS ---
_G.Aimbot = false
_G.ESP_Box = false
_G.ESP_Name = false
_G.ESP_Health = false
_G.FOV = 150 
_G.Smoothness = 0.5

-- --- UI PARENT ---
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AbhishekModPremium"

-- --- MAIN FRAME ---
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 250)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Glowing Border
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 255, 127)
Stroke.Thickness = 2
Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Sidebar (Tabs)
local SideBar = Instance.new("Frame", MainFrame)
SideBar.Size = UDim2.new(0, 80, 1, 0)
SideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)

-- Container for Pages
local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0, 90, 0, 40)
Container.Size = UDim2.new(1, -100, 1, -50)
Container.BackgroundTransparency = 1

local PageLayout = Instance.new("UIPageLayout", Container)
PageLayout.ScrollWheelInputEnabled = false
PageLayout.TweenTime = 0.3

-- Title
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 80, 0, 0)
Title.Text = "ABHISHEK MOD v2"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

-- --- TAB CREATOR ---
local function CreateTab(name, order)
    local TabBtn = Instance.new("TextButton", SideBar)
    TabBtn.Size = UDim2.new(1, 0, 0, 40)
    TabBtn.Position = UDim2.new(0, 0, 0, (order-1)*45 + 10)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 12
    Instance.new("UICorner", TabBtn)
    
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 0
    local List = Instance.new("UIListLayout", Page)
    List.Padding = UDim.new(0, 5)

    TabBtn.MouseButton1Click:Connect(function()
        PageLayout:JumpTo(Page)
    end)
    return Page
end

local MainPage = CreateTab("MAIN", 1)
local VisualPage = CreateTab("VISUALS", 2)

-- --- BUTTON CREATOR ---
local function AddToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35)
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.TextColor3 = _G[varName] and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(255, 255, 255)
    end)
end

-- Add Features to Tabs
AddToggle(MainPage, "Enable Aimbot", "Aimbot")
AddToggle(VisualPage, "Box ESP", "ESP_Box")
AddToggle(VisualPage, "Name ESP", "ESP_Name")
AddToggle(VisualPage, "Health ESP", "ESP_Health")

-- Close Button
local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", Close)
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- --- LOGIC (Fixed Wall Check & Switching) ---
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = {Players.LocalPlayer.Character, part.Parent}
    local res = workspace:Raycast(origin, part.Position - origin, ray)
    return res == nil
end

local function GetClosest()
    local target, dist = nil, _G.FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist and IsVisible(v.Character.Head) then
                    dist = mag; target = v
                end
            end
        end
    end
    return target
end

-- --- RENDER LOOP ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(0, 255, 127); FOVCircle.Filled = false

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.FOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local t = GetClosest()
        if t then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), _G.Smoothness) end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
            h.Enabled = _G.ESP_Box; h.FillColor = Color3.fromRGB(0, 255, 127)
            local head = p.Character:FindFirstChild("Head")
            if head then
                local b = head:FindFirstChild("AB_B") or Instance.new("BillboardGui", head)
                b.AlwaysOnTop = true; b.Size = UDim2.new(0, 100, 0, 40); b.ExtentsOffset = Vector3.new(0, 2, 0)
                local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0); l.TextColor3 = Color3.fromRGB(255, 255, 255); l.Font = Enum.Font.GothamBold; l.TextSize = 10
                local txt = ""
                if _G.ESP_Name then txt = txt .. p.Name .. "\n" end
                if _G.ESP_Health then txt = txt .. math.floor(p.Character.Humanoid.Health) .. " HP" end
                l.Text = txt; l.Visible = (_G.ESP_Name or _G.ESP_Health)
            end
        end
    end
end)
