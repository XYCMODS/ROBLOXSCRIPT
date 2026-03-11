--// UI SERVICE
local TweenService = game:GetService("TweenService")

--// MAIN GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AbhishekProMenu"

--// MAIN FRAME
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 360)
MainFrame.Position = UDim2.new(0.03, -300, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,14)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0,255,150)
Stroke.Thickness = 2

local Grad = Instance.new("UIGradient", MainFrame)
Grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25,25,25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10,10,10))
}

--// TITLE BAR
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1,0,0,45)
Title.Text = "ABHISHEK PRO"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(0,255,150)
Title.BackgroundTransparency = 1

--// TAB HOLDER
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(1,0,0,40)
TabHolder.Position = UDim2.new(0,0,0,45)
TabHolder.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", TabHolder)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0,6)

--// PAGES
local AimPage = Instance.new("Frame", MainFrame)
AimPage.Size = UDim2.new(1,0,1,-90)
AimPage.Position = UDim2.new(0,0,0,90)
AimPage.BackgroundTransparency = 1

local EspPage = AimPage:Clone()
EspPage.Parent = MainFrame
EspPage.Visible = false

local PageLayout = Instance.new("UIListLayout", AimPage)
PageLayout.Padding = UDim.new(0,6)
PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local PageLayout2 = PageLayout:Clone()
PageLayout2.Parent = EspPage

--// TAB FUNCTION
local function CreateTab(name, page)
    local btn = Instance.new("TextButton", TabHolder)
    btn.Size = UDim2.new(0,90,0,30)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        AimPage.Visible = false
        EspPage.Visible = false
        page.Visible = true
    end)
end

CreateTab("AIM", AimPage)
CreateTab("ESP", EspPage)

--// TOGGLE BUTTON
local function ToggleButton(text, parent, callback)
    local Holder = Instance.new("Frame", parent)
    Holder.Size = UDim2.new(0.9,0,0,40)
    Holder.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", Holder)

    local Label = Instance.new("TextLabel", Holder)
    Label.Text = text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0.05,0,0,0)
    Label.Size = UDim2.new(0.6,0,1,0)

    local Switch = Instance.new("Frame", Holder)
    Switch.Size = UDim2.new(0,40,0,18)
    Switch.Position = UDim2.new(0.75,0,0.5,-9)
    Switch.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1,0)

    local Knob = Instance.new("Frame", Switch)
    Knob.Size = UDim2.new(0,16,0,16)
    Knob.Position = UDim2.new(0,1,0.5,-8)
    Knob.BackgroundColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1,0)

    local state = false

    Holder.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            callback(state)

            if state then
                TweenService:Create(Knob,TweenInfo.new(0.25),{Position=UDim2.new(1,-17,0.5,-8)}):Play()
                TweenService:Create(Switch,TweenInfo.new(0.25),{BackgroundColor3=Color3.fromRGB(0,255,150)}):Play()
            else
                TweenService:Create(Knob,TweenInfo.new(0.25),{Position=UDim2.new(0,1,0.5,-8)}):Play()
                TweenService:Create(Switch,TweenInfo.new(0.25),{BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
            end
        end
    end)
end

--// AIM TOGGLES
ToggleButton("Aimbot", AimPage, function(v)
    _G.Aimbot = v
end)

--// ESP TOGGLES
ToggleButton("ESP Box", EspPage, function(v)
    _G.ESP_Box = v
end)

ToggleButton("ESP Name", EspPage, function(v)
    _G.ESP_Name = v
end)

ToggleButton("ESP Health", EspPage, function(v)
    _G.ESP_Health = v
end)

--// OPEN ANIMATION
TweenService:Create(
    MainFrame,
    TweenInfo.new(0.4,Enum.EasingStyle.Quint),
    {Position = UDim2.new(0.03,0,0.2,0)}
):Play()
