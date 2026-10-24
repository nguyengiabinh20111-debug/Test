-- ----------------------------------------------------
-- Prometheus Deobf / by RT4O
-- Discord: https://discord.gg/uqhEpzXy9q
-- Deobf at 2026-10-03 11:17:16 UTC
-- ----------------------------------------------------

local proximityPromptService = game:GetService("ProximityPromptService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")
local coreGui = game:GetService("CoreGui")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local v1 = gethui and gethui() or playerGui

if v1:FindFirstChild("AtrasGui") then
  v1.AtrasGui:Destroy()
end

local v2 = false
local v3 = false
local v5 = false
local v6 = false
local v7 = {}

local v9 = {
  Vector3.new(500.62, 241.28, -366.64), Vector3.new(504.45, 155.8, -366.35),
  Vector3.new(508.3, 70.28, -366.03), Vector3.new(513.86, 70.28, -366.25),
  Vector3.new(519.43, 70.28, -366.47), Vector3.new(524.32, 70.28, -366.59),
  Vector3.new(529.22, 70.28, -366.71), Vector3.new(538.01, 70.28, -365.55),
  Vector3.new(546.8, 70.28, -364.4),
}

local sourcesHubGui = Instance.new("ScreenGui")
sourcesHubGui.Name = "AtrasGui"
sourcesHubGui.ResetOnSpawn = false
sourcesHubGui.IgnoreGuiInset = true
sourcesHubGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
sourcesHubGui.DisplayOrder = 1000
sourcesHubGui.Parent = v1

local openBtn = Instance.new("ImageButton")
openBtn.Name = "OpenBtn"
openBtn.Size = UDim2.fromOffset(45, 45)
openBtn.Position = UDim2.new(0, 15, 0.34, -22)
openBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
openBtn.BorderSizePixel = 0
openBtn.Image = "rbxassetid://97608172188347"
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Parent = sourcesHubGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(1, 0)
uiCorner.Parent = openBtn

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(200, 30, 30)
uiStroke.Thickness = 1.5
uiStroke.Parent = openBtn

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 270)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -135)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
mainFrame.BackgroundTransparency = 0.42
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = sourcesHubGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainFrame

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 10)
uiCorner2.Parent = mainFrame

local uiStroke2 = Instance.new("UIStroke")
uiStroke2.Color = Color3.fromRGB(200, 30, 30)
uiStroke2.Thickness = 1.5
uiStroke2.Parent = mainFrame



local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -95, 0, 18)
titleLabel.Position = UDim2.new(0, 46, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ATRAS"
titleLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local discordSubLabel = Instance.new("TextLabel")
discordSubLabel.Name = "DiscordSubLabel"
discordSubLabel.Size = UDim2.new(1, -95, 0, 14)
discordSubLabel.Position = UDim2.new(0, 46, 0, 20)
discordSubLabel.BackgroundTransparency = 1
discordSubLabel.Text = "discord.gg/uqhEpzXy9q"
discordSubLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
discordSubLabel.TextSize = 10
discordSubLabel.Font = Enum.Font.Gotham
discordSubLabel.TextXAlignment = Enum.TextXAlignment.Left
discordSubLabel.Parent = mainFrame

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 22, 0, 22)
textButton.Position = UDim2.new(1, -52, 0, 6)
textButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
textButton.Text = "_"
textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton.TextSize = 13
textButton.Font = Enum.Font.GothamBold
textButton.Parent = mainFrame

local uiCorner4 = Instance.new("UICorner")
uiCorner4.CornerRadius = UDim.new(0, 5)
uiCorner4.Parent = textButton

local uiStroke3 = Instance.new("UIStroke")
uiStroke3.Color = Color3.fromRGB(200, 30, 30)
uiStroke3.Thickness = 1
uiStroke3.Parent = textButton

local textButton2 = Instance.new("TextButton")
textButton2.Size = UDim2.new(0, 22, 0, 22)
textButton2.Position = UDim2.new(1, -26, 0, 6)
textButton2.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
textButton2.Text = "×"
textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton2.TextSize = 15
textButton2.Font = Enum.Font.GothamBold
textButton2.Parent = mainFrame

local uiCorner5 = Instance.new("UICorner")
uiCorner5.CornerRadius = UDim.new(0, 5)
uiCorner5.Parent = textButton2

textButton.MouseButton1Click:Connect(function()
  mainFrame.Visible = false
  openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
  mainFrame.Visible = true
  openBtn.Visible = false
end)

local connect

textButton2.MouseButton1Click:Connect(function()
  if connect then
    connect:Disconnect()
  end

  sourcesHubGui:Destroy()
end)

local textButton3 = Instance.new("TextButton")
textButton3.Size = UDim2.new(0.5, -12, 0, 22)
textButton3.Position = UDim2.new(0, 8, 0, 38)
textButton3.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
textButton3.Text = "Main"
textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
textButton3.TextSize = 12
textButton3.Font = Enum.Font.GothamBold
textButton3.Parent = mainFrame

local uiCorner6 = Instance.new("UICorner")
uiCorner6.CornerRadius = UDim.new(0, 5)
uiCorner6.Parent = textButton3

local textButton4 = Instance.new("TextButton")
textButton4.Size = UDim2.new(0.5, -12, 0, 22)
textButton4.Position = UDim2.new(0.5, 4, 0, 38)
textButton4.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
textButton4.Text = "Misc"
textButton4.TextColor3 = Color3.fromRGB(180, 150, 150)
textButton4.TextSize = 12
textButton4.Font = Enum.Font.GothamSemibold
textButton4.Parent = mainFrame

local uiCorner7 = Instance.new("UICorner")
uiCorner7.CornerRadius = UDim.new(0, 5)
uiCorner7.Parent = textButton4

local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, -68)
frame.Position = UDim2.new(0, 0, 0, 66)
frame.BackgroundTransparency = 1
frame.Visible = true
frame.Parent = mainFrame

local frame2 = Instance.new("Frame")
frame2.Size = UDim2.new(1, 0, 1, -68)
frame2.Position = UDim2.new(0, 0, 0, 66)
frame2.BackgroundTransparency = 1
frame2.Visible = false
frame2.Parent = mainFrame

textButton3.MouseButton1Click:Connect(function()
  frame.Visible = true
  frame2.Visible = false

  textButton3.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
  textButton3.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton3.Font = Enum.Font.GothamBold

  textButton4.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
  textButton4.TextColor3 = Color3.fromRGB(180, 150, 150)
  textButton4.Font = Enum.Font.GothamSemibold
end)

textButton4.MouseButton1Click:Connect(function()
  frame.Visible = false
  frame2.Visible = true

  textButton4.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
  textButton4.TextColor3 = Color3.fromRGB(255, 255, 255)
  textButton4.Font = Enum.Font.GothamBold

  textButton3.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
  textButton3.TextColor3 = Color3.fromRGB(180, 150, 150)
  textButton3.Font = Enum.Font.GothamSemibold
end)

local antiHitBtn = Instance.new("TextButton")
antiHitBtn.Name = "AntiHitBtn"
antiHitBtn.Size = UDim2.new(1, -20, 0, 32)
antiHitBtn.Position = UDim2.new(0, 10, 0, 6)
antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
antiHitBtn.BackgroundTransparency = 0.2
antiHitBtn.Text = "Anti-Hit: OFF"
antiHitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitBtn.TextSize = 12
antiHitBtn.Font = Enum.Font.GothamSemibold
antiHitBtn.Parent = frame
local antiHitStroke = Instance.new("UIStroke")
antiHitStroke.Color = Color3.fromRGB(220, 65, 55)
antiHitStroke.Thickness = 1
antiHitStroke.Transparency = 0.25
antiHitStroke.Parent = antiHitBtn

local uiCorner8 = Instance.new("UICorner")
uiCorner8.CornerRadius = UDim.new(0, 6)
uiCorner8.Parent = antiHitBtn

local instantGrabBtn = Instance.new("TextButton")
instantGrabBtn.Name = "InstantGrabBtn"
instantGrabBtn.Size = UDim2.new(1, -20, 0, 32)
instantGrabBtn.Position = UDim2.new(0, 10, 0, 44)
instantGrabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
instantGrabBtn.BackgroundTransparency = 0.2
instantGrabBtn.Text = "Instant Grab: OFF"
instantGrabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
instantGrabBtn.TextSize = 12
instantGrabBtn.Font = Enum.Font.GothamSemibold
instantGrabBtn.Parent = frame
local instantGrabStroke = Instance.new("UIStroke")
instantGrabStroke.Color = Color3.fromRGB(220, 65, 55)
instantGrabStroke.Thickness = 1
instantGrabStroke.Transparency = 0.25
instantGrabStroke.Parent = instantGrabBtn

local uiCorner9 = Instance.new("UICorner")
uiCorner9.CornerRadius = UDim.new(0, 6)
uiCorner9.Parent = instantGrabBtn


local antiRagdollBtn = Instance.new("TextButton")
antiRagdollBtn.Name = "AntiRagdollBtn"
antiRagdollBtn.Size = UDim2.new(1, -20, 0, 32)
antiRagdollBtn.Position = UDim2.new(0, 10, 0, 82)
antiRagdollBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
antiRagdollBtn.BackgroundTransparency = 0.2
antiRagdollBtn.Text = "Anti-Ragdoll: OFF"
antiRagdollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiRagdollBtn.TextSize = 12
antiRagdollBtn.Font = Enum.Font.GothamSemibold
antiRagdollBtn.Parent = frame
local antiRagdollStroke = Instance.new("UIStroke")
antiRagdollStroke.Color = Color3.fromRGB(220, 65, 55)
antiRagdollStroke.Thickness = 1
antiRagdollStroke.Transparency = 0.25
antiRagdollStroke.Parent = antiRagdollBtn

local uiCorner11 = Instance.new("UICorner")
uiCorner11.CornerRadius = UDim.new(0, 6)
uiCorner11.Parent = antiRagdollBtn

local function f1(p1)
  if not p1 then
    return
  end

  pcall(function()
    p1:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not v5)
    p1:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not v5)
  end)
end
local function f2()
  if connect then
    return
  end

  connect = runService.Heartbeat:Connect(function()
    if not v5 then
      return
    end

    local character2 = localPlayer.Character

    if not character2 then
      return
    end

    local humanoid2 = character2:FindFirstChildOfClass("Humanoid")

    if humanoid2 then
      pcall(function()
        local getState = humanoid2:GetState()

        if getState == Enum.HumanoidStateType.Physics
          or getState == Enum.HumanoidStateType.Ragdoll
          or getState == Enum.HumanoidStateType.FallingDown then
          for index, value in ipairs(character2:GetDescendants()) do
            if value:IsA("BasePart") then
              value.AssemblyLinearVelocity = Vector3.zero
              value.AssemblyAngularVelocity = Vector3.zero
            end
          end

          humanoid2:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
      end)
    end
  end)
end

antiRagdollBtn.MouseButton1Click:Connect(function()
  v5 = not v5
  local character3 = localPlayer.Character

  if character3 then
    f1(character3:FindFirstChildOfClass("Humanoid"))
  end

  if v5 then
    antiRagdollBtn.Text = "Anti-Ragdoll: ON"
    antiRagdollBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
    f2()
  else
    antiRagdollBtn.Text = "Anti-Ragdoll: OFF"
    antiRagdollBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
  end
end)

localPlayer.CharacterAdded:Connect(function(character4)
  task.wait(0.5)

  if v5 then
    f1(character4:FindFirstChildOfClass("Humanoid"))
  end
end)

local function f3(p2)
  if p2:IsA("ProximityPrompt") then
    if v3 then
      if v7[p2] == nil then
        v7[p2] = p2.HoldDuration
      end

      p2.HoldDuration = 0.01
    elseif v7[p2] ~= nil then
      p2.HoldDuration = v7[p2]
      v7[p2] = nil
    end
  end
end

proximityPromptService.PromptShown:Connect(function(p3)
  if v3 then
    f3(p3)
  end
end)

workspace.DescendantAdded:Connect(function(descendant)
  if v3 and descendant:IsA("ProximityPrompt") then
    f3(descendant)
  end
end)

instantGrabBtn.MouseButton1Click:Connect(function()
  v3 = not v3

  if v3 then
    instantGrabBtn.Text = "Instant Grab: ON"
    instantGrabBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)

    for index2, value2 in ipairs(workspace:GetDescendants()) do
      f3(value2)
    end
  else
    instantGrabBtn.Text = "Instant Grab: OFF"
    instantGrabBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)

    for key, value3 in pairs(v7) do
      if key and key.Parent then
        key.HoldDuration = value3
      end
    end

    table.clear(v7)
  end
end)


local scaleBtn = Instance.new("TextButton")
scaleBtn.Name = "ScaleBtn"
scaleBtn.Size = UDim2.new(1, -20, 0, 30)
scaleBtn.Position = UDim2.new(0, 10, 0, 38)
scaleBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
scaleBtn.BackgroundTransparency = 0.2
scaleBtn.Text = "GUI Scale: 1.0x"
scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleBtn.TextSize = 11
scaleBtn.Font = Enum.Font.GothamSemibold
scaleBtn.Parent = frame2

local uiCorner14 = Instance.new("UICorner")
uiCorner14.CornerRadius = UDim.new(0, 6)
uiCorner14.Parent = scaleBtn

local v12 = { 0.8, 1, 1.2, 1.4 }
local v13 = 2

scaleBtn.MouseButton1Click:Connect(function()
  v13 = v13 + 1

  if v13 > #v12 then
    v13 = 1
  end

  local v14 = v12[v13]
  uiScale.Scale = v14
  scaleBtn.Text = "GUI Scale: " .. v14 .. "x"
end)

local discordBtn = Instance.new("TextButton")
discordBtn.Name = "DiscordBtn"
discordBtn.Size = UDim2.new(1, -20, 0, 30)
discordBtn.Position = UDim2.new(0, 10, 0, 72)
discordBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
discordBtn.BackgroundTransparency = 0.2
discordBtn.Text = "Discord: Copy Link"
discordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
discordBtn.TextSize = 11
discordBtn.Font = Enum.Font.GothamSemibold
discordBtn.Parent = frame2

local uiCorner15 = Instance.new("UICorner")
uiCorner15.CornerRadius = UDim.new(0, 6)
uiCorner15.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
  if setclipboard then
    setclipboard("https://discord.gg/uqhEpzXy9q")
  end

  discordBtn.Text = "COPIED DISCORD LINK!"
  task.wait(1.2)
  discordBtn.Text = "Discord: Copy Link"
end)

local function f4(p4)
  if not v2 or not p4 or not p4.Parent then
    return
  end

  for index3, value4 in ipairs(v9) do
    if not v2 then
      return
    end
    p4:PivotTo(CFrame.new(value4))
    if index3 < #v9 then
      runService.Heartbeat:Wait()
    end
  end
end

antiHitBtn.MouseButton1Click:Connect(function()
  v2 = not v2

  if v2 then
    antiHitBtn.Text = "Anti-Hit: ON"
    antiHitBtn.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
  else
    antiHitBtn.Text = "Anti-Hit: OFF"
    antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
  end
end)

proximityPromptService.PromptTriggered:Connect(function(p5, p6)
  if p6 ~= localPlayer then
    return
  end

  if not v2 or v6 then
    return
  else
    local character6 = localPlayer.Character

    if not character6 then
      return
    end

    f4(character6)
    v6 = false
    return
  end
end)

-- Discord: https://discord.gg/uqhEpzXy9q