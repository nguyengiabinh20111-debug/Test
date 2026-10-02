-- Auto Steal UI
-- Chỉ là giao diện bật/tắt + callback

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "AutoStealUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 100)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Chilli Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 40)
toggle.Position = UDim2.fromOffset(10, 45)
toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
toggle.Text = "Auto Steal: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 15
toggle.Font = Enum.Font.Gotham
toggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

local enabled = false

local function AutoStealStart()
    -- Đặt phần khởi động Auto Steal của bạn vào đây
    print("Auto Steal started")
end

local function AutoStealStop()
    -- Đặt phần dừng Auto Steal của bạn vào đây
    print("Auto Steal stopped")
end

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled

    if enabled then
        toggle.Text = "Auto Steal: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(40, 130, 70)
        AutoStealStart()
    else
        toggle.Text = "Auto Steal: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        AutoStealStop()
    end
end)
