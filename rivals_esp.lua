local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- --- SETTINGS & VARIABLES ---
-- Persistent settings across executions using global variables (_G)
_G.Aimbot = _G.Aimbot or false
_G.AimbotFOV = _G.AimbotFOV or 150
_G.AimbotSmoothness = _G.AimbotSmoothness or 0.5
_G.ESP_Box = _G.ESP_Box or false
_G.ESP_Name = _G.ESP_Name or false
_G.ESP_Health = _G.ESP_Health or false

-- Colors from premium UI concept
local Color_PremiumGreen = Color3.fromRGB(0, 255, 127)
local Color_Background = Color3.fromRGB(15, 15, 15)
local Color_Sidebar = Color3.fromRGB(20, 20, 20)
local Color_ButtonOff = Color3.fromRGB(30, 30, 30)
local Color_ButtonOn = Color3.fromRGB(0, 170, 100) -- A slightly dimmer green for 'ON' button background
local Color_Text = Color3.fromRGB(255, 255, 255)

-- --- 1. UI ROOT & PARENTING ---
-- Use CoreGui to prevent standard deletion on character reset
local अभिषेकModRoot = Instance.new("ScreenGui", CoreGui)
अभिषेकModRoot.Name = "AbhishekMod_v2_PremiumTabbed"
अभिषेकModRoot.IgnoreGuiInset = true -- Better full-screen control

-- --- 2. FLOATING LOGO (MINI-BUTTON FOR SHOWING MENU) ---
local LogoButton = Instance.new("TextButton", अभिषेकModRoot)
LogoButton.Name = "FloatingLogo"
LogoButton.Size = UDim2.new(0, 60, 0, 60)
LogoButton.Position = UDim2.new(0.02, 0, 0.2, 0) -- Top-left corner
LogoButton.BackgroundColor3 = Color_Background
LogoButton.Text = "AM"
LogoButton.TextColor3 = Color_PremiumGreen
LogoButton.Font = Enum.Font.GothamBold
LogoButton.TextSize = 24
LogoButton.Active = true
LogoButton.Draggable = true -- Logo draggable for mobile
LogoButton.Visible = false -- Initially hidden, MainMenu is shown by default

Instance.new("UICorner", LogoButton).CornerRadius = UDim.new(1, 0) -- Perfect Circle
local logoStroke = Instance.new("UIStroke", LogoButton)
logoStroke.Color = Color_PremiumGreen
logoStroke.Thickness = 2
logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- --- 3. MAIN MENU FRAME CREATION ---
local MainMenu = Instance.new("Frame", अभिषेकModRoot)
MainMenu.Name = "MainMenuFrame"
MainMenu.Size = UDim2.new(0, 450, 0, 320) -- Slightly wider to accommodate full elements
MainMenu.Position = UDim2.new(0.5, -225, 0.5, -160) -- Screen Center
MainMenu.BackgroundColor3 = Color_Background
MainMenu.Active = true
MainMenu.Draggable = true -- Main menu draggable
MainMenu.Visible = true -- Big menu visible by default

Instance.new("UICorner", MainMenu).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", MainMenu)
mainStroke.Color = Color_PremiumGreen
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- --- 4. TOGGLE LOGIC FUNCTION ---
local function ToggleUI()
    if MainMenu.Visible then
        MainMenu.Visible = false
        LogoButton.Visible = true
    else
        MainMenu.Visible = true
        LogoButton.Visible = false
        -- Reset big menu to center screen on reshow
        MainMenu.Position = UDim2.new(0.5, -225, 0.5, -160)
    end
end

LogoButton.MouseButton1Click:Connect(ToggleUI) -- Open menu when logo clicked

-- --- 5. UI COMPONENTS & TAB SYSTEM ---

-- Title Header
local title = Instance.new("TextLabel", MainMenu)
title.Size = UDim2.new(1, -50, 0, 50) -- Adjusted for red close button
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "ABHISHEK MOD v2"
title.TextColor3 = Color_PremiumGreen
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1
title.ZIndex = 2 -- Header should be above pages

-- Red Close Button
local closeBtn = Instance.new("TextButton", MainMenu)
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5) -- Adjusted for header size and padding
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- Red
closeBtn.Text = "X"
closeBtn.TextColor3 = Color_Text
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.ZIndex = 3 -- Top-most element
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(ToggleUI) -- Click to hide/toggle UI

-- Sidebar for Tabs
local sidebar = Instance.new("Frame", MainMenu)
sidebar.Size = UDim2.new(0, 100, 1, -50) -- Fits below header
sidebar.Position = UDim2.new(0, 0, 0, 50)
sidebar.BackgroundColor3 = Color_Sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 10)

-- Tab Container
local container = Instance.new("Frame", MainMenu)
container.Size = UDim2.new(1, -110, 1, -60) -- Adjusted for header, sidebar, and padding
container.Position = UDim2.new(0, 105, 0, 55)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ZIndex = 1

local pageLayout = Instance.new("UIPageLayout", container)
pageLayout.Padding = UDim.new(0, 10)
pageLayout.ScrollWheelInputEnabled = false -- Use tabs, not scrolling
pageLayout.TweenTime = 0.3 -- Smooth tab switching

-- --- TAB & PAGE CREATORS ---

local function CreateTab(name, order)
    local tabBtn = Instance.new("TextButton", sidebar)
    tabBtn.Size = UDim2.new(0.9, 0, 0, 40)
    tabBtn.Position = UDim2.new(0.05, 0, 0, (order-1)*45 + 10) -- Adjusted positioning with padding
    tabBtn.Text = name
    tabBtn.BackgroundColor3 = Color_Sidebar -- Initial matching background
    tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200) -- Semi-greyed
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.ZIndex = 3
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)
    
    local page = Instance.new("ScrollingFrame", container)
    page.Name = name .. "_Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 2 -- Thin scrollbar
    page.ScrollBarImageColor3 = Color_PremiumGreen
    page.ZIndex = 1
    
    local list = Instance.new("UIListLayout", page)
    list.Padding = UDim.new(0, 8)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center
    list.SortOrder = Enum.SortOrder.LayoutOrder

    tabBtn.MouseButton1Click:Connect(function()
        pageLayout:JumpTo(page)
        
        -- Update tab button visuals on click
        for _, btn in pairs(sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color_Sidebar
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end
        tabBtn.BackgroundColor3 = Color_ButtonOn -- Change clicked tab button visual
        tabBtn.TextColor3 = Color_PremiumGreen
    end)
    return page
end

local function AddToggle(parent, text, varName, layoutOrder, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.95, 0, 0, 38)
    btn.LayoutOrder = layoutOrder
    
    -- Function to update button state visuals
    local function updateVisuals()
        local isOn = _G[varName]
        btn.Text = text .. (isOn and ": ON" or ": OFF")
        btn.BackgroundColor3 = isOn and Color_ButtonOn or Color_ButtonOff
        btn.TextColor3 = isOn and Color_PremiumGreen or Color_Text
    end
    updateVisuals() -- Initial set

    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.ZIndex = 1
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName] -- Toggle variable
        updateVisuals() -- Update visuals
        if callback then callback() end -- Optional callback
    end)
end

local function AddSlider(parent, text, min, max, varName, layoutOrder, callback)
    local sliderFrame = Instance.new("Frame", parent)
    sliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
    sliderFrame.LayoutOrder = layoutOrder
    sliderFrame.BackgroundColor3 = Color_ButtonOff
    sliderFrame.BorderSizePixel = 0
    sliderFrame.ZIndex = 1
    Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 6)
    
    local titleLabel = Instance.new("TextLabel", sliderFrame)
    titleLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    titleLabel.Position = UDim2.new(0.05, 0, 0, 5)
    titleLabel.Text = text .. ": " .. tostring(_G[varName])
    titleLabel.TextColor3 = Color_Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 12
    titleLabel.BackgroundTransparency = 1
    titleLabel.ZIndex = 1
    
    local fillBar = Instance.new("Frame", sliderFrame)
    fillBar.Size = UDim2.new((_G[varName] - min) / (max - min), 0, 1, 0)
    fillBar.Position = UDim2.new(0, 0, 0.6, 0)
    fillBar.BackgroundColor3 = Color_PremiumGreen
    fillBar.BorderSizePixel = 0
    fillBar.ZIndex = 1
    Instance.new("UICorner", fillBar).CornerRadius = UDim.new(0, 6)
    
    local inputFrame = Instance.new("TextButton", sliderFrame) -- Clicking on this frame triggers sliding
    inputFrame.Size = UDim2.new(0.9, 0, 1, -20)
    inputFrame.Position = UDim2.new(0.05, 0, 0, 10)
    inputFrame.BackgroundTransparency = 1
    inputFrame.ZIndex = 2 -- On top of everything to catch input
    inputFrame.Text = "" -- Important to remove default text, ZIndex ensures clicks are registered

    local function updateSlider(input)
        local inputPosition = input.Position.X
        local inputDelta = inputPosition - inputFrame.AbsolutePosition.X
        local percentage = math.clamp(inputDelta / inputFrame.AbsoluteSize.X, 0, 1)
        
        fillBar.Size = UDim2.new(percentage, 0, 1, 0)
        _G[varName] = math.floor(min + (max - min) * percentage)
        titleLabel.Text = text .. ": " .. tostring(_G[varName])
        
        if callback then callback() end
    end

    local connection -- Persistent connection while sliding
    
    inputFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            connection = RunService.RenderStepped:Connect(function() -- Continuously update while dragging
                updateSlider(UserInputService:GetMouseLocation())
            end)
        end
    end)
    
    inputFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if connection then connection:Disconnect(); connection = nil end -- Stop update when sliding ends
        end
    end)
end

-- --- 6. PAGE CONTENT GENERATION ---

-- TAB 1: MAIN (AIMBOT)
local mainPage = CreateTab("MAIN", 1)
AddToggle(mainPage, "Enable Aimbot", "Aimbot", 1)
AddSlider(mainPage, "Aimbot FOV", 50, 400, "AimbotFOV", 2, function()
    -- FOV logic callback, e.g., redraw the FOV circle on change
    -- (This logic will go into standard Roblox drawing function later)
end)

-- TAB 2: VISUALS (ESP)
local visualPage = CreateTab("VISUALS", 2)
AddToggle(visualPage, "Box ESP", "ESP_Box", 1)
AddToggle(visualPage, "Name ESP", "ESP_Name", 2)
AddToggle(visualPage, "Health ESP", "ESP_Health", 3)

-- Ensure elements stay neatly within scrolling frame by adjusting ContentSize
local function adjustContentSize(page, list)
    local totalHeight = list.AbsoluteContentSize.Y + list.Padding.Offset * (#page:GetChildren() - 1)
    page.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

adjustContentSize(mainPage, mainPage.UIListLayout)
adjustContentSize(visualPage, visualPage.UIListLayout)

-- Event connections to update sizes dynamically
mainPage.ChildAdded:Connect(function() adjustContentSize(mainPage, mainPage.UIListLayout) end)
visualPage.ChildAdded:Connect(function() adjustContentSize(visualPage, visualPage.UIListLayout) end)

-- Initial set clicked tab on Main Page
for _, btn in pairs(sidebar:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "MAIN" then
        btn.BackgroundColor3 = Color_ButtonOn -- Set MAIN tab active by default
        btn.TextColor3 = Color_PremiumGreen
        pageLayout:JumpTo(mainPage) -- Jump to corresponding page
    end
end

-- --- 7. BACKEND PLACEHOLDER GAME LOGIC ---
-- Replace these with actual functions to affect gameplay
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Visible = false; FOV_Circle.Thickness = 1; FOV_Circle.Color = Color_PremiumGreen; FOV_Circle.Filled = false; FOV_Circle.Transparency = 1

local function AimbotLogic()
    if _G.Aimbot then
        -- Placeholder for standard Roblox aimbot logic using FOV, Smoothness, Dynamic Target Switching, and Visibility Checks
        FOV_Circle.Radius = _G.AimbotFOV
        FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOV_Circle.Visible = true
        
        -- ... Complex Aimbot Target Locking Logic ...
        
    else
        FOV_Circle.Visible = false -- Ensure hidden if Aimbot off
    end
end

local function ESPLogic(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local char = player.Character
        local hum = char.Humanoid
        
        -- Box/Highlight ESP Logic
        local highlight = char:FindFirstChild("HighlightESP") or Instance.new("Highlight", char)
        highlight.Name = "HighlightESP"; highlight.Enabled = _G.ESP_Box; highlight.FillTransparency = 1; highlight.OutlineColor = Color_PremiumGreen

        -- Info Billboard ESP Logic (Name & HP)
        local head = char:FindFirstChild("Head")
        if head then
            local bill = head:FindFirstChild("InfoESP") or Instance.new("BillboardGui", head)
            bill.Name = "InfoESP"; bill.AlwaysOnTop = true; bill.Size = UDim2.new(0, 100, 0, 40); bill.ExtentsOffset = Vector3.new(0, 2, 0)
            
            local l = bill:FindFirstChild("TextLabel") or Instance.new("TextLabel", bill)
            l.Name = "TextLabel"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1, 0, 1, 0); l.TextColor3 = Color_Text; l.Font = Enum.Font.GothamBold; l.TextSize = 10
            
            local txt = ""
            if _G.ESP_Name then txt = txt .. player.Name .. "\n" end
            if _G.ESP_Health then txt = txt .. math.floor(hum.Health) .. " HP" end
            l.Text = txt; l.Visible = (_G.ESP_Name or _G.ESP_Health) -- Ensure visibility only if settings on
        end
    end
end

-- --- 8. MAIN RENDER LOOP ---
RunService.RenderStepped:Connect(function()
    AimbotLogic() -- Run Aimbot related rendering
    
    -- Run ESP related rendering for standard Roblox structure in complex games
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then ESPLogic(player) end
    end
end)
