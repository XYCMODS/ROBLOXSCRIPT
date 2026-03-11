local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- === KEYAUTH DETAILS ===
-- Yeh aapki KeyAuth app ki details hain jo api ko verify karengi
local app_name = HttpService:UrlEncode("Abhishekkumar16225's Application")
local owner_id = "YHaBEYYmqU"
local version = "1.0"

-- === KEY SYSTEM UI ===
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "AbhishekKeySystem"
local success = pcall(function() KeyGui.Parent = CoreGui end)
if not success then KeyGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0, 320, 0, 160)
KeyFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 127)
Instance.new("UIStroke", KeyFrame).Thickness = 2

local Title = Instance.new("TextLabel", KeyFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "ABHISHEK MOD - LOGIN"
Title.TextColor3 = Color3.fromRGB(0, 255, 127)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.9, 0, 0, 35)
KeyInput.Position = UDim2.new(0.05, 0, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 12
KeyInput.PlaceholderText = "Enter your 1-Day Key here..."
KeyInput.Text = ""
KeyInput.ClearTextOnFocus = false
Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", KeyInput).Color = Color3.fromRGB(0, 255, 127)

local VerifyBtn = Instance.new("TextButton", KeyFrame)
VerifyBtn.Size = UDim2.new(0.9, 0, 0, 40)
VerifyBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
VerifyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
VerifyBtn.Text = "VERIFY KEY"
VerifyBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 14
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

-- === VERIFICATION LOGIC ===
VerifyBtn.MouseButton1Click:Connect(function()
    local key = KeyInput.Text
    if key == "" then
        VerifyBtn.Text = "PLEASE ENTER A KEY!"
        VerifyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
        task.wait(1.5)
        VerifyBtn.Text = "VERIFY KEY"
        VerifyBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        return
    end

    VerifyBtn.Text = "Checking Database..."
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Get HWID (Hardware ID for 1-Device Lock)
    local hwid = ""
    pcall(function() hwid = gethwid() end)
    if hwid == "" then hwid = game:GetService("RbxAnalyticsService"):GetClientId() end

    -- Call KeyAuth API
    pcall(function()
        -- 1. Initialize Session
        local init_url = "https://keyauth.win/api/1.2/?type=init&ver="..version.."&name="..app_name.."&ownerid="..owner_id
        local init_req = game:HttpGet(init_url)
        local init_data = HttpService:JSONDecode(init_req)

        if init_data.success then
            local sessionid = init_data.sessionid
            
            -- 2. Verify Key and HWID
            local verify_url = "https://keyauth.win/api/1.2/?type=license&key="..key.."&hwid="..hwid.."&sessionid="..sessionid.."&name="..app_name.."&ownerid="..owner_id
            local verify_req = game:HttpGet(verify_url)
            local verify_data = HttpService:JSONDecode(verify_req)

            if verify_data.success then
                -- KEY IS CORRECT!
                VerifyBtn.Text = "SUCCESS! LOADING MOD..."
                VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
                VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                task.wait(1)
                KeyGui:Destroy() -- Close UI
                
                -- LOAD MAIN MENU FROM GITHUB
                loadstring(game:HttpGet("https://raw.githubusercontent.com/XYCMODS/ROBLOXSCRIPT/refs/heads/main/rivals_esp.lua"))()
            else
                -- KEY IS WRONG OR HWID MISMATCH
                VerifyBtn.Text = verify_data.message or "INVALID KEY / WRONG DEVICE"
                VerifyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
                task.wait(2)
                VerifyBtn.Text = "VERIFY KEY"
                VerifyBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
            end
        else
            VerifyBtn.Text = "API ERROR!"
            VerifyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(2)
            VerifyBtn.Text = "VERIFY KEY"
            VerifyBtn.TextColor3 = Color3.fromRGB(0, 255, 127)
        end
    end)
end)
