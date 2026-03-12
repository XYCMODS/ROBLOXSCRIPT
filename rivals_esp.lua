local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- --- SETTINGS & VARIABLES ---
_G.Aimbot = false
_G.AutoFire = false -- Naya Feature
_G.TeamCheck = true -- Naya Feature
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

-- --- LOAD CUSTOM PICTURE ---
local CustomLogoImage = ""
pcall(function()
    local url = "https://i.supaimg.com/8b0f695c-2b86-4162-bacc-ed123dddbfa7/4ee53c99-1d32-4298-aebd-fea26915d594.png"
    local imageData = game:HttpGet(url)
    writefile("AbhishekMod_Logo.png", imageData)
    CustomLogoImage = (getcustomasset or getsynasset)("AbhishekMod_Logo.png")
end)

-- --- 1. GUI CREATION ---
local GUI = Instance.new("ScreenGui")
GUI.Name = "ABHISHEK MODS"
local success = pcall(function() GUI.Parent = CoreGui end)
if not success then GUI.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- --- 2. MAIN MENU FRAME ---
local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 380, 0, 260)
Main.Position = UDim2.new(0.5, -190, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 255, 127)
Instance.new("UIStroke", Main).Thickness = 2

-- --- 3. FLOATING LOGO ---
local LogoButton = Instance.new("ImageButton", GUI)
LogoButton.Size = UDim2.new(0, 50, 0, 50)
LogoButton.Position = UDim2.new(0.05, 0, 0.15, 0)
LogoButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LogoButton.Image = CustomLogoImage
LogoButton.Visible = false
LogoButton.Active = true
LogoButton.Draggable = true
Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", LogoButton).Color = Color3.fromRGB(0, 255, 127)
LogoButton.MouseButton1Click:Connect(function() Main.Visible = true; LogoButton.Visible = false end)

-- --- HEADER ---
local HeaderPic = Instance.new("ImageLabel", Main)
HeaderPic.Size = UDim2.new(0, 30, 0, 30); HeaderPic.Position = UDim2.new(0, 10, 0, 5); HeaderPic.BackgroundTransparency = 1; HeaderPic.Image = CustomLogoImage
Instance.new("UICorner", HeaderPic).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -90, 0, 40); Title.Position = UDim2.new(0, 45, 0, 0); Title.Text = "ABHISHEK MOD v2"; Title.TextColor3 = Color3.fromRGB(0, 255, 127); Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.BackgroundTransparency = 1; Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Main)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.BackgroundColor3 = Color3.fromRGB(200, 0, 0); Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 255, 255); Close.Font = Enum.Font.GothamBold
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 6)
Close.MouseButton1Click:Connect(function() Main.Visible = false; LogoButton.Visible = true end)

-- --- 4. TABS SETUP ---
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 95, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -105, 1, -40); Pages.Position = UDim2.new(0, 100, 0, 40); Pages.BackgroundTransparency = 1

local PageMain = Instance.new("ScrollingFrame", Pages); PageMain.Size = UDim2.new(1,0,1,0); PageMain.BackgroundTransparency = 1; PageMain.ScrollBarThickness = 0
local PageVis = Instance.new("ScrollingFrame", Pages); PageVis.Size = UDim2.new(1,0,1,0); PageVis.BackgroundTransparency = 1; PageVis.ScrollBarThickness = 0; PageVis.Visible = false
local PageCol = Instance.new("ScrollingFrame", Pages); PageCol.Size = UDim2.new(1,0,1,0); PageCol.BackgroundTransparency = 1; PageCol.ScrollBarThickness = 0; PageCol.Visible = false

local LayoutMain = Instance.new("UIListLayout", PageMain); LayoutMain.Padding = UDim.new(0, 8); LayoutMain.HorizontalAlignment = Enum.HorizontalAlignment.Center
local LayoutVis = Instance.new("UIListLayout", PageVis); LayoutVis.Padding = UDim.new(0, 8); LayoutVis.HorizontalAlignment = Enum.HorizontalAlignment.Center
local LayoutCol = Instance.new("UIListLayout", PageCol); LayoutCol.Padding = UDim.new(0, 8); LayoutCol.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function CreateTabBtn(name, pos, activePage)
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(0.9, 0, 0, 35); btn.Position = UDim2.new(0.05, 0, 0, pos); btn.Text = name; btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); btn.TextColor3 = Color3.fromRGB(180, 180, 180); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        PageMain.Visible = false; PageVis.Visible = false; PageCol.Visible = false
        activePage.Visible = true
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Color3.fromRGB(180, 180, 180); v.BackgroundColor3 = Color3.fromRGB(20, 20, 20) end end
        btn.TextColor3 = Color3.fromRGB(0, 255, 127); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end)
    return btn
end

local TabMain = CreateTabBtn("MAIN", 10, PageMain)
TabMain.TextColor3 = Color3.fromRGB(0, 255, 127); TabMain.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CreateTabBtn("VISUALS", 55, PageVis)
CreateTabBtn("COLORS", 100, PageCol)

-- --- 5. TOGGLES & SLIDERS ---
local function CreateToggle(parent, text, varName)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 35); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.Text = text .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = text .. (_G[varName] and ": ON" or ": OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(30, 30, 30)
    end)
end

-- Populating Tabs (Added Team Check and Auto Fire)
CreateToggle(PageMain, "Enable Aimbot", "Aimbot")
CreateToggle(PageMain, "Enable Auto Fire", "AutoFire")
CreateToggle(PageMain, "Team Check", "TeamCheck")

-- FOV Slider
local sliderFrame = Instance.new("Frame", PageMain); sliderFrame.Size = UDim2.new(0.95, 0, 0, 45); sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
local sliderLabel = Instance.new("TextLabel", sliderFrame); sliderLabel.Size = UDim2.new(1, 0, 0.5, 0); sliderLabel.Text = "Aimbot FOV: " .. _G.AimbotFOV; sliderLabel.TextColor3 = Color3.new(1,1,1); sliderLabel.Font = "GothamBold"; sliderLabel.TextSize = 11; sliderLabel.BackgroundTransparency = 1
local sliderBtn = Instance.new("TextButton", sliderFrame); sliderBtn.Size = UDim2.new(0.9, 0, 0.2, 0); sliderBtn.Position = UDim2.new(0.05, 0, 0.6, 0); sliderBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60); sliderBtn.Text = ""
local sliderFill = Instance.new("Frame", sliderBtn); sliderFill.Size = UDim2.new(0.3, 0, 1, 0); sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
local dragging = false
sliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local percent = math.clamp((UserInputService:GetMouseLocation().X - sliderBtn.AbsolutePosition.X) / sliderBtn.AbsoluteSize.X, 0, 1)
        sliderFill.Size = UDim2.new(percent, 0, 1, 0); _G.AimbotFOV = math.floor(50 + (percent * 350)); sliderLabel.Text = "Aimbot FOV: " .. _G.AimbotFOV
    end
end)

CreateToggle(PageVis, "Box ESP", "ESP_Box")
CreateToggle(PageVis, "Line ESP", "ESP_Lines")
CreateToggle(PageVis, "Name ESP", "ESP_Name")
CreateToggle(PageVis, "Health ESP", "ESP_Health")

-- --- 6. GAME LOGIC ---
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Filled = false
local Tracers = {}

local function IsVisible(part)
    local ray = RaycastParams.new()
    ray.FilterType = Enum.RaycastFilterType.Exclude
    ray.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    return workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, ray) == nil
end

local function GetTarget()
    local target, dist = nil, _G.AimbotFOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            -- Team Check Logic
            if _G.TeamCheck and v.Team == LocalPlayer.Team then continue end
            
            local pos, screen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if screen and IsVisible(v.Character.Head) then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = _G.Aimbot
    FOVCircle.Radius = _G.AimbotFOV
    FOVCircle.Color = GetFOVColor()
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    if _G.Aimbot then
        local t = GetTarget()
        if t then 
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, t.Character.Head.Position), 0.5) 
            if _G.AutoFire then mouse1press(); task.wait(); mouse1release() end
        end
    end

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- Team Check ESP
            local isEnemy = (p.Team ~= LocalPlayer.Team)
            local shouldShow = (_G.TeamCheck and isEnemy) or (not _G.TeamCheck)
            
            local hrp = p.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            local espColor = GetESPColor()

            if shouldShow and onScreen and p.Character.Humanoid.Health > 0 then
                if _G.ESP_Lines then
                    if not Tracers[p] then Tracers[p] = Drawing.new("Line"); Tracers[p].Thickness = 1.5 end
                    Tracers[p].Visible = true; Tracers[p].Color = espColor
                    Tracers[p].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); Tracers[p].To = Vector2.new(pos.X, pos.Y)
                else if Tracers[p] then Tracers[p].Visible = false end end

                local h = p.Character:FindFirstChild("AB_H") or Instance.new("Highlight", p.Character)
                h.Name = "AB_H"; h.Enabled = _G.ESP_Box; h.FillTransparency = 1; h.OutlineColor = espColor
                
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local b = head:FindFirstChild("AB_B") or Instance.new("BillboardGui", head)
                    b.Name = "AB_B"; b.AlwaysOnTop = true; b.Size = UDim2.new(0, 100, 0, 40); b.ExtentsOffset = Vector3.new(0, 2, 0)
                    local l = b:FindFirstChild("L") or Instance.new("TextLabel", b)
                    l.Name = "L"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0); l.TextColor3 = espColor; l.Font = "GothamBold"; l.TextSize = 11
                    local txt = ""
                    if _G.ESP_Name then txt = txt .. p.Name .. "\n" end
                    if _G.ESP_Health and p.Character:FindFirstChild("Humanoid") then txt = txt .. math.floor(p.Character.Humanoid.Health) .. " HP" end
                    l.Text = txt; l.Visible = (_G.ESP_Name or _G.ESP_Health)
                end
            else
                if Tracers[p] then Tracers[p].Visible = false end
                if p.Character:FindFirstChild("AB_H") then p.Character.AB_H.Enabled = false end
            end
        end
    end
end)
