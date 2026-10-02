                return nil
            end
            return v22, v23
        end

        local function fn47(arg)
            local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
            local v22 = workspace:FindFirstChild(arg)
                or areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(arg)
            if not v22 then
                return nil
            end

            local ok, result = pcall(function()
                return v22:GetPivot().Position
            end)

            if not ok then
                result = ok
            end

            local v23 = result or nil
            return v23
        end

        local function fn48(arg)
            local rfEggWorldAskFieldEggSnapshot =
                networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
            if
                not rfEggWorldAskFieldEggSnapshot
                or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction")
            then
                return nil
            end
            local ok, result =
                pcall(rfEggWorldAskFieldEggSnapshot.InvokeServer, rfEggWorldAskFieldEggSnapshot)
            local records = ok and type(result) == "table" and result.Records or nil
            if type(records) ~= "table" then
                return nil
            end

            for _, record in pairs(records) do
                if
                    type(record) == "table"
                    and record.Uid == arg
                    and typeof(record.BottomCFrame) == "CFrame"
                then
                    return record.BottomCFrame.Position
                end
            end

            return nil
        end

        local function fn49(arg)
            local v22 = workspace:FindFirstChild(arg)
            if not v22 then
                return false
            end

            for _, descendant in ipairs(v22:GetDescendants()) do
                if
                    descendant:IsA("JointInstance")
                    or descendant:IsA("WeldConstraint")
                    or descendant:IsA("RigidConstraint")
                then
                    local ok, result, result2 = pcall(function()
                        return descendant.Part0, descendant.Part1
                    end)

                    if ok then
                        for _, v23 in ipairs({ result, result2 }) do
                            if typeof(v23) == "Instance" and not v23:IsDescendantOf(v22) then
                                local model = v23:FindFirstAncestorOfClass("Model")
                                if
                                    model
                                    and model ~= localPlayer.Character
                                    and Players:GetPlayerFromCharacter(model)
                                then
                                    return true
                                end
                                continue
                            end
                        end
                    end
                end
            end

            return false
        end

        local function fn50(arg, arg2)
            local carryUid = arg2 or tbl4.Steal.CarryUid
            if type(carryUid) ~= "string" then
                return false
            end
            fn21()
            str2 = "Following the egg"
            local n19 = nil
            local vector = Vector3.new(0, 0, 0)

            local connection = RunService.PreSimulation:Connect(function(arg3)
                local v22 = tbl4.Root()
                if not v22 or not n19 or tbl4.Steal.Carrying or fn12(arg) then
                    return
                end

                if fn22() then
                    if 2 < (v22.Position - n19).Magnitude then
                        fn36(n19)
                    end

                    return
                end

                local n20 = math.max(arg3, 0.004166666666666667)
                local n21 = vector + (n19 - v22.Position) / math.max(0.08, n20)
                local n22 = n4 + vector.Magnitude

                if n22 < n21.Magnitude then
                    n21 = n21.Unit * n22
                end

                local n23 = n21 + Vector3.new(0, workspace.Gravity * n20 * 0.5, 0)

                pcall(function()
                    v22.AssemblyLinearVelocity = n23
                    v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            local n20 = 0
            local huge = math.huge
            local v22 = nil
            local v23 = nil
            local n21 = 0
            local huge2 = math.huge
            local n22 = 0
            local flag3

            while true do
                flag3 = false

                if not (n20 < n18) then
                    break
                else
                    flag3 = false

                    if not fn12(arg) then
                        if tbl4.Steal.Carrying then
                            flag3 = true
                            break
                        else
                            local v24 = tbl4.Root()
                            flag3 = false

                            if v24 then
                                local v25 = fn47(carryUid)
                                local now, flag4, n23, flag5, v26, result

                                if not v25 and huge >= 0.5 then
                                    v25 = fn48(carryUid)
                                    flag3 = false
                                    local n24 = 0

                                    if v25 then
                                        huge = n24

                                        if v25 then
                                            now = os.clock()
                                            flag4 = v22 and v23 and now > v23

                                            if flag4 then
                                                n23 = (v25 - v22)
                                                    / math.max(now - v23, 0.004166666666666667)

                                                if n23.Magnitude < 3000 then
                                                    vector = vector:Lerp(n23, 0.3)
                                                end
                                            end

                                            n19 = v25 + Vector3.new(0, 3, 0)
                                            v22 = v25
                                            v23 = now
                                        end

                                        if n21 >= 0.4 then
                                            n21 = 0

                                            if fn49(carryUid) then
                                                str2 = "Another player took the egg"
                                                flag3 = false
                                                break
                                            else
                                                flag5 = n19
                                                    and (n19 - v24.Position).Magnitude <= n16
                                                    and huge2 >= 0.1

                                                if flag5 then
                                                    v26 = fn46(
                                                        n19 - Vector3.new(0, 3, 0),
                                                        6,
                                                        carryUid
                                                    )

                                                    if v26 then
                                                        pcall(function()
                                                            v26.HoldDuration = 0
                                                        end)

                                                        huge2 = 0
                                                        n22 = 0

                                                        if
                                                            typeof(fireproximityprompt)
                                                            == "function"
                                                        then
                                                            pcall(fireproximityprompt, v26)
                                                            huge2 = 0
                                                            n22 = 0
                                                        end

                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        n22 = n22 + 1
                                                        huge2 = 0

                                                        if not (20 <= n22) then
                                                            result = RunService.Heartbeat:Wait()
                                                            n20 = n20 + result
                                                            huge2 = huge2 + result
                                                            huge = huge + result
                                                            n21 = n21 + result
                                                            continue
                                                        else
                                                            flag3 = false
                                                            break
                                                        end
                                                    end
                                                else
                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                end
                                            end
                                        else
                                            flag5 = n19
                                                and (n19 - v24.Position).Magnitude <= n16
                                                and huge2 >= 0.1

                                            if flag5 then
                                                v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                                if v26 then
                                                    pcall(function()
                                                        v26.HoldDuration = 0
                                                    end)

                                                    huge2 = 0
                                                    n22 = 0

                                                    if
                                                        typeof(fireproximityprompt) == "function"
                                                    then
                                                        pcall(fireproximityprompt, v26)
                                                        huge2 = 0
                                                        n22 = 0
                                                    end

                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    n22 = n22 + 1
                                                    huge2 = 0

                                                    if not (20 <= n22) then
                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        flag3 = false
                                                        break
                                                    end
                                                end
                                            else
                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            end
                                        end
                                    end
                                else
                                    if v25 then
                                        now = os.clock()
                                        flag4 = v22 and v23 and now > v23

                                        if flag4 then
                                            n23 = (v25 - v22)
                                                / math.max(now - v23, 0.004166666666666667)

                                            if n23.Magnitude < 3000 then
                                                vector = vector:Lerp(n23, 0.3)
                                            end
                                        end

                                        n19 = v25 + Vector3.new(0, 3, 0)
                                        v22 = v25
                                        v23 = now
                                    end

                                    if n21 >= 0.4 then
                                        n21 = 0

                                        if fn49(carryUid) then
                                            str2 = "Another player took the egg"
                                            flag3 = false
                                            break
                                        else
                                            flag5 = n19
                                                and (n19 - v24.Position).Magnitude <= n16
                                                and huge2 >= 0.1

                                            if flag5 then
                                                v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                                if v26 then
                                                    pcall(function()
                                                        v26.HoldDuration = 0
                                                    end)

                                                    huge2 = 0
                                                    n22 = 0

                                                    if
                                                        typeof(fireproximityprompt) == "function"
                                                    then
                                                        pcall(fireproximityprompt, v26)
                                                        huge2 = 0
                                                        n22 = 0
                                                    end

                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    n22 = n22 + 1
                                                    huge2 = 0

                                                    if not (20 <= n22) then
                                                        result = RunService.Heartbeat:Wait()
                                                        n20 = n20 + result
                                                        huge2 = huge2 + result
                                                        huge = huge + result
                                                        n21 = n21 + result
                                                        continue
                                                    else
                                                        flag3 = false
                                                        break
                                                    end
                                                end
                                            else
                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            end
                                        end
                                    else
                                        flag5 = n19
                                            and (n19 - v24.Position).Magnitude <= n16
                                            and huge2 >= 0.1

                                        if flag5 then
                                            v26 = fn46(n19 - Vector3.new(0, 3, 0), 6, carryUid)

                                            if v26 then
                                                pcall(function()
                                                    v26.HoldDuration = 0
                                                end)

                                                huge2 = 0
                                                n22 = 0

                                                if typeof(fireproximityprompt) == "function" then
                                                    pcall(fireproximityprompt, v26)
                                                    huge2 = 0
                                                    n22 = 0
                                                end

                                                result = RunService.Heartbeat:Wait()
                                                n20 = n20 + result
                                                huge2 = huge2 + result
                                                huge = huge + result
                                                n21 = n21 + result
                                                continue
                                            else
                                                n22 = n22 + 1
                                                huge2 = 0

                                                if not (20 <= n22) then
                                                    result = RunService.Heartbeat:Wait()
                                                    n20 = n20 + result
                                                    huge2 = huge2 + result
                                                    huge = huge + result
                                                    n21 = n21 + result
                                                    continue
                                                else
                                                    flag3 = false
                                                    break
                                                end
                                            end
                                        else
                                            result = RunService.Heartbeat:Wait()
                                            n20 = n20 + result
                                            huge2 = huge2 + result
                                            huge = huge + result
                                            n21 = n21 + result
                                            continue
                                        end
                                    end
                                end
                            end
                        end
                    end

                    break
                end
            end

            connection:Disconnect()
            fn20()
            local flag4 = flag3 or tbl4.Steal.Carrying == true
            return flag4
        end

        local function fn51(arg, arg2)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end

            if tbl4.InsideBase() and not tbl4.InsideBase(position) then
                local v22 = fn35()

                if v22 then
                    str2 = "Leaving the base through the safe zone"
                    if not fn34(v22 + Vector3.new(0, 3, 0), arg2, nil, n4) then
                        return false
                    end
                end
            end

            str2 = "Flying to the egg"
            if not fn34(position + Vector3.new(0, 3, 0), arg2, nil, n4) then
                return false
            end
            str2 = "Taking the egg"
            local v22 = fn44(arg, arg2, 0.6, nil)

            if not v22 and not fn12(arg2) then
                v22 = fn29(arg, arg2)
            end

            if not v22 and not fn30(arg.Uid, arg2) then
                tbl14[arg.Uid] = os.clock() + n7
                return false
            end
            tbl4.Steal.LastFinishedAt = os.clock()
            return true
        end

        local tbl18 = { Uid = nil, Freed = nil, Token = nil }
        local n19 = 3

        local function fn52()
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            local guardAreas = world and world:FindFirstChild("GuardAreas")
            local v22 = tbl4.Root()
            if not guardAreas or not v22 then
                return nil
            end
            local str3 = tostring(localPlayer.UserId)
            local carryAreaId = tbl4.Steal.CarryAreaId
                    and fn39({ AreaId = tostring(tbl4.Steal.CarryAreaId) })
                or nil
            local huge = math.huge
            local v23 = nil

            for _, child in ipairs(guardAreas:GetChildren()) do
                local guard = child:FindFirstChild("Guard")

                if guard then
                    if
                        tostring(guard:GetAttribute("TargetPlayer")) == str3
                        or tostring(guard:GetAttribute("WakeTargetPlayer")) == str3
                    then
                        return guard
                    end

                    local ok, result = pcall(function()
                        return guard:GetPivot().Position
                    end)

                    if ok then
                        local magnitude = (result - v22.Position).Magnitude

                        if magnitude < huge then
                            v23 = guard
                            huge = magnitude
                        end
                    end
                end
            end

            carryAreaId = carryAreaId or v23
            return carryAreaId
        end

        local function fn53(arg, arg2, arg3)
            local v22 = fn52()
            if not v22 then
                return false
            end
            local v23 = fn42(arg, arg3 + Vector3.new(0, 3, 0))
            local n20 = 0

            while true do
                if not v23.Landed and n20 < n12 and not fn12(arg) then
                    local ok, result = pcall(function()
                        return v22:GetPivot().Position
                    end)

                    local v24 = tbl4.Root()

                    if not (not ok or not v24) then
                        if n15 + 5 < (result - v24.Position).Magnitude then
                            local vector =
                                Vector3.new(v24.Position.X - result.X, 0, v24.Position.Z - result.Z)
                            local vector2 = vector.Magnitude > 0.1 and vector.Unit * n15
                                or Vector3.new(0, 0, 0)
                            local n21 = result + vector2

                            fn34(
                                Vector3.new(n21.X, result.Y + 3, n21.Z),
                                arg,
                                nil,
                                n4,
                                true,
                                function()
                                    if v23.Landed then
                                        return "hit"
                                    end
                                    return nil
                                end
                            )
                        end

                        n20 = n20 + RunService.Heartbeat:Wait()
                        continue
                    end
                end

                break
            end

            v23.Stop()
            if not v23.Landed then
                return false
            end
            return fn50(arg, arg2)
        end

        local function fn54(arg)
            local n20 = 0

            while tbl4.AntiGuard.Busy and n20 < 4 and not fn12(arg) do
                str2 = "Anti Guard is slipping past the guard"
                n20 = n20 + RunService.Heartbeat:Wait()
            end

            local n21 = 0

            while not tbl4.Steal.Carrying and n21 < n11 and not fn12(arg) do
                str2 = "Checking the egg in hand"
                n21 = n21 + RunService.Heartbeat:Wait()
            end

            if not tbl4.Steal.Carrying then
                str2 = "The egg is gone, staying to look for it"
                if not fn50(arg) then
                    str2 = "The egg is gone"
                    return false
                end
            end

            local v22 = fn35()
            local v23 = tbl4.Root()
            if not v22 or not v23 then
                return false
            end
            local n22 = math.max(v23.Position.Y, v22.Y) + n3

            local function fn54()
                if tbl18.Uid and tbl18.Freed and tbl4.Steal.Carrying then
                    return "priority"
                end
                return nil
            end

            local flag3 = true
            local n23 = 0

            while true do
                local v24 = tbl4.Root()

                if not v24 then
                    return false
                else
                    str2 = "Flying home"
                    local position = v24.Position
                    local n24 = math.max(n22, position.Y)
                    local v25, v26 = fn34(
                        Vector3.new(
                            position.X + (v22.X - position.X) * 0.25,
                            position.Y + (n24 - position.Y) * 0.7,
                            position.Z + (v22.Z - position.Z) * 0.25
                        ),
                        arg,
                        flag3,
                        nil,
                        nil,
                        fn54
                    )

                    if v25 then
                        local v27, v28 =
                            fn34(Vector3.new(v22.X, n24, v22.Z), arg, flag3, nil, nil, fn54)
                        v25 = v27
                        v26 = v28
                    end

                    local v27

                    if v25 then
                        local v28, v29 = fn34(v22, arg, flag3, nil, nil, fn54)
                        v26 = v29
                        v27 = v28
                    else
                        v27 = v25
                    end

                    if v27 then
                        local character = localPlayer.Character
                        character = character and character:FindFirstChildOfClass("Humanoid")

                        if character then
                            character.PlatformStand = false
                        end

                        task.wait(0.2)
                        if not tbl4.Steal.Carrying then
                            str2 = "Arrived without the egg"
                            return false
                        end
                        local eggState = tbl.EggState

                        if
                            type(eggState) == "table"
                            and type(eggState.DropFieldEgg) == "function"
                        then
                            pcall(eggState.DropFieldEgg, "PlayerRequest")
                        end

                        return true
                    end

                    if v26 == "priority" then
                        local uid = tbl18.Uid
                        local freed = tbl18.Freed
                        local v28 = tbl18
                        tbl18.Uid = nil
                        v28.Freed = nil
                        local v29 = tbl4.Root()
                        if not v29 or not uid or not freed then
                            return false
                        end

                        if (freed - v29.Position).Magnitude <= n4 * n19 then
                            str2 = "Best egg fell nearby, swapping eggs"
                            local eggState = tbl.EggState

                            if
                                type(eggState) == "table"
                                and type(eggState.DropFieldEgg) == "function"
                            then
                                pcall(eggState.DropFieldEgg, "PlayerRequest")
                            end

                            local n25 = 0

                            while tbl4.Steal.Carrying and n25 < 1 do
                                n25 = n25 + RunService.Heartbeat:Wait()
                            end

                            if not fn50(arg, uid) then
                                return false
                            end
                        else
                            str2 = "Best egg fell far away, riding a guard hit to it"
                            if not fn53(arg, uid, freed) then
                                return false
                            end
                        end

                        local v30 = tbl4.Root()
                        flag3 = true
                        n23 = 0

                        if v30 then
                            n22 = math.max(v30.Position.Y, v22.Y) + n3
                            flag3 = true
                            n23 = 0
                        end

                        continue
                    end

                    if v26 == "dropped" and n23 < n17 then
                        n23 = n23 + 1
                        if not fn50(arg) then
                            return false
                        end
                        continue
                    end

                    break
                end
            end

            return false
        end

        local function fn55(arg)
            local n20 = tonumber(arg) or 0
            local tbl19 = { "", "K", "M", "B", "T", "Qa", "Qi" }
            local n21 = 1

            while math.abs(n20) >= 1000 and n21 < #tbl19 do
                n20 = n20 / 1000
                n21 = n21 + 1
            end

            local format = string.format
            local str3 = n21 == 1 and "%.0f%s" or "%.2f%s"
            return format(str3, n20, tbl19[n21])
        end

        local function fn56(arg)
            if not arg then
                return "None"
            end
            local format = string.format
            local str3 = tostring(arg.Category)
            local n20 = tonumber(arg.Scale) or 0
            local v22 = tostring
            local areaId = arg.AreaId
            local str4 =
                format("%s  %.2fx  |  value %s  |  %s", str3, n20, fn55(arg.Value), v22(areaId))

            if arg.State == "Dropped" then
                str4 = str4 .. "  |  dropped"
            elseif arg.State == "Carried" then
                str4 = str4 .. "  |  carried by a player"
            end

            return str4
        end

        local flag3 = false

        -- Custom Auto Steal ON/OFF UI
        local AutoStealEnabled = false

        do
            local Players = game:GetService("Players")
            local player = Players.LocalPlayer
            local playerGui = player:WaitForChild("PlayerGui")

            local old = playerGui:FindFirstChild("ChilliAutoStealToggle")
            if old then old:Destroy() end

            local gui = Instance.new("ScreenGui")
            gui.Name = "ChilliAutoStealToggle"
            gui.ResetOnSpawn = false
            gui.Parent = playerGui

            local frame = Instance.new("Frame")
            frame.Size = UDim2.fromOffset(220, 90)
            frame.Position = UDim2.new(0.5, -110, 0.18, 0)
            frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
            frame.BorderSizePixel = 0
            frame.Parent = gui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,10)
            corner.Parent = frame

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, -20, 0, 28)
            title.Position = UDim2.fromOffset(10, 5)
            title.BackgroundTransparency = 1
            title.Text = "Chilli Hub - Auto Steal"
            title.TextColor3 = Color3.new(1,1,1)
            title.TextSize = 15
            title.Font = Enum.Font.GothamBold
            title.Parent = frame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -20, 0, 40)
            button.Position = UDim2.fromOffset(10, 40)
            button.BackgroundColor3 = Color3.fromRGB(65,65,75)
            button.BorderSizePixel = 0
            button.Text = "Auto Steal: OFF"
            button.TextColor3 = Color3.new(1,1,1)
            button.TextSize = 15
            button.Font = Enum.Font.GothamSemibold
            button.Parent = frame

            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0,8)
            bc.Parent = button

            local function refresh()
                button.Text = AutoStealEnabled and "Auto Steal: ON" or "Auto Steal: OFF"
                button.BackgroundColor3 = AutoStealEnabled
                    and Color3.fromRGB(45,145,80)
                    or Color3.fromRGB(65,65,75)
            end

            button.MouseButton1Click:Connect(function()
                AutoStealEnabled = not AutoStealEnabled
                if not AutoStealEnabled then
                    n5 = n5 + 1
                    tbl4.Steal.Active = false
                    tbl4.Steal.Wanted = false
                    pcall(fn24)
                    pcall(tbl4.ReleaseMovement, "steal")
                    pcall(tbl4.ReleaseBelt)
                    pcall(tbl2.Wake)
                else
                    pcall(tbl2.Wake)
                end
                refresh()
            end)

            refresh()
        end

        local function fn57()
            local v22 = n5
            tbl4.Steal.Active = true
            tbl4.Steal.Carrying = tbl4.Steal.Carrying == true

            if not tbl4.Steal.Carrying then
                tbl4.Steal.CarryUid = nil
            end

            local v23 = nil
            local str3 = nil

            for _, v24 in ipairs((fn18(false, true))) do
                if v24.State == "Carried" then
                    str3 = str3 or v24
                else
                    v23 = v24
                    break
                end
            end

            local tbl19 = { v23 }
            local uid = v23 and v23.Uid or nil
            v18 = uid
            tbl4.Steal.Wanted = v23 ~= nil
            str = fn56(v23)

            if str3 then
                str = str .. "  |  watching " .. tostring(str3.Category)
            end

            if not v23 then
                tbl4.Steal.Active = false
                str3 = str3 and "Best egg is carried, waiting for it"
                str3 = str3 or "No egg matches"
                str2 = str3
                return false
            end

            if not tbl4.ClaimMovement("steal") then
                tbl4.Steal.Active = false
                str2 = "Waiting for Auto Place"
                return false
            end

            if tbl4.Treadmill.Riding or tbl4.OnBelt() then
                tbl4.ExitBelt()
            end

            flag3 = true
            tbl4.HoldBelt()

            local function fn57(arg)
                str2 = arg
                local v24 = fn51(v23, v22)
                local flag4 = false
                local v25 = nil

                if v24 then
                    if fn28(v23.Uid, v22) then
                        v25 = nil
                        flag4 = fn54(v22)
                    else
                        v25 = str2
                        flag4 = false
                    end
                end

                fn24()
                tbl4.Steal.Active = false
                tbl4.Steal.LastFinishedAt = os.clock()
                flag4 = flag4 and "Delivered"
                flag4 = flag4 or v25
                flag4 = flag4 or v24 and "Run ended" or "That egg would not come free"
                str2 = flag4
                return true
            end

            local v24 = tbl4.Root()
            local position = typeof(v23.CFrame) == "CFrame" and v23.CFrame.Position or nil

            if v24 and position then
                local flag4 = (position - v24.Position).Magnitude <= n16
                local areaId = v23.AreaId
                local flag5 = localPlayer:GetAttribute("AreaId") == areaId
                if flag4 or flag5 then
                    return (fn57("Target is right here, taking it"))
                end
            end

            local v25 = fn18(true)
            local str4 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
            local tbl20 = {}

            for _, v26 in ipairs(v25) do
                local v27 = fn40(v26)
                local flag4

                if v27 then
                    flag4 = v27
                else
                    flag4 = type(v26.Uid) == "string" and string.sub(v26.Uid, 1, #str4) == str4
                end

                if flag4 then
                    table.insert(tbl20, v26)
                end
            end

            if #tbl20 ~= 0 then
                v25 = tbl20
            end

            local v26, v27 = fn31(v25)
            local v28 = v26
            local v29 = v27

            if not v28 then
                tbl4.Steal.Active = false
                str2 = "No egg matches"
                return false
            end

            if v28.Uid == v23.Uid then
                return (fn57("Target is the closest egg, taking it"))
            end
            local v30, v31 = fn41(v28)
            local v32 = v31
            local v33

            if v32 and v24 then
                local v34, v35, v36 = ipairs(v25)
                local huge = math.huge
                v33 = v28

                for _, v37 in v34, v35, v36 do
                    local position2 = typeof(v37.CFrame) == "CFrame" and v37.CFrame.Position or nil

                    if v37.Uid ~= v23.Uid and v37.AreaId == v28.AreaId and position2 then
                        local magnitude = (position2 - v24.Position).Magnitude

                        if n13 < (position2 - v32).Magnitude then
                            magnitude = magnitude + n13
                        end

                        if magnitude < huge then
                            huge = magnitude
                            v33 = v37
                        end
                    end
                end
            else
                v33 = v28
            end

            str2 = string.format("Sleeping guard egg %d studs away", math.floor(v29 + 0.5))

            if not v33 then
                tbl4.Steal.Active = false
                str2 = "No egg matches"
                return false
            end

            local v34, v35 = fn45(v33, v22, false, tbl19[1])
            if not v34 then
                tbl4.Steal.Active = false
                return false
            end
            local uid2 = nil
            local uid3 = v23.Uid
            local n20 = 0

            while true do
                if v35 and not fn12(v22) then
                    str2 = "Holding for the guard hit"

                    if
                        fn43(v22, v35, function(arg)
                            if not uid2 and tbl18.Uid and tbl18.Freed then
                                uid2 = tbl18.Uid
                                arg.Destination = tbl18.Freed + Vector3.new(0, 3, 0)
                                local v36 = tbl18
                                tbl18.Uid = nil
                                v36.Freed = nil
                                str2 = "Best egg fell, jumping to it instead"
                            end
                        end)
                    then
                        n20 = n20 + 1

                        if uid2 then
                            uid3 = uid2
                            fn50(v22, uid2)
                            break
                        else
                            local v36 = tbl19[n20]
                            local v37
                            v37, v35 = fn45(v36, v22, true, tbl19[n20 + 1])

                            if v37 then
                                if v36 and type(v36.Uid) == "string" then
                                    uid3 = v36.Uid
                                end

                                continue
                            end
                        end
                    end
                end

                break
            end

            if not fn28(uid3, v22) then
                local v36 = str2
                fn24()
                tbl4.Steal.Active = false
                tbl4.Steal.LastFinishedAt = os.clock()
                str2 = v36
                return true
            end

            local str5 = fn54(v22)
            fn24()
            tbl4.Steal.Active = false
            tbl4.Steal.LastFinishedAt = os.clock()
            str5 = str5 and "Delivered"
            str5 = str5 or "Run ended"
            str2 = str5
            return true
        end

        local eggState = tbl.EggState

        if type(eggState) == "table" then
            for _, v22 in ipairs({
                "FieldRefreshed",
                "FieldShifted",
                "FieldGone",
                "SnapshotRefreshed",
            }) do
                local v23 = eggState[v22]

                if type(v23) == "table" and type(v23.Connect) == "function" then
                    local ok, result = pcall(v23.Connect, v23, function()
                        tbl2.Wake()
                    end)

                    ok = ok and result

                    if ok then
                        fn6(function()
                            pcall(function()
                                result:Disconnect()
                            end)
                        end)
                    end
                end
            end
        end

        tbl2.Add(function()
            local flag4 = nil

            if v16 then
                flag4 = type(v16.Set) == "function"
            end

            if flag4 then
                pcall(v16.Set, nil, str2)
            end

            local flag5 = nil

            if v17 then
                flag5 = type(v17.Set) == "function"
            end

            if flag5 then
                pcall(v17.Set, nil, str)
            end

            if not AutoStealEnabled then
                return false
            end
            local v22, v23, v24 = fn14()
            local v25 = v23

            if v22 then
                if v25 == "night" then
                    fn15()
                end

                tbl4.Movement.StealFirst = true
                tbl4.Steal.Wanted = false

                if flag then
                    n5 = n5 + 1
                    tbl4.Steal.Active = false
                    fn24()
                    tbl4.StopWalking()
                end

                local n20 = math.max(0, math.ceil(v22 - v24))

                if v25 == "wall" then
                    str2 = string.format("Field wall up, %ds", n20)
                else
                    str2 = string.format("Night, going again in %ds", n20)
                end

                return false
            end

            local flag6 = v20

            if v20 then
                flag6 = n9 == math.huge
            end

            if flag6 then
                n9 = os.clock() + n8
            end

            if flag then
                return true
            end

            if fn16() then
                str2 = "Night over, waiting for the field to reset"
                tbl2.Wake()
                return false
            end

            local stealFirst = tbl4.Movement.StealFirst
            local owner = tbl4.Movement.Owner

            if
                tbl4.Movement.PlaceWanted and not stealFirst
                or owner ~= nil
                    and owner ~= "steal"
                    and owner ~= "treadmill"
                    and owner ~= "scramble"
            then
                str2 = "Waiting for Auto Place"

                if stealFirst then
                    tbl2.Wake()
                end

                return true
            end

            tbl4.Movement.StealFirst = false
            flag = true

            task.spawn(function()
                local ok = pcall(fn57)

                if flag3 then
                    flag3 = false
                    tbl4.ReleaseBelt()
                end

                if not ok then
                    fn24()
                    tbl4.Steal.Active = false
                end

                local v26 = v18
                v18 = nil
                local once = v26 and tbl11[v26]
                once = once and once.Once

                if once then
                    tbl11[v26] = nil
                end

                local v27 = tbl18
                local v28 = tbl18
                tbl18.Uid = nil
                v27.Freed = nil
                v28.Token = nil

                if str2 == "Delivered" and not tbl4.IsNight() then
                    tbl4.Movement.StealFirst = true
                end

                tbl4.ReleaseMovement("steal")
                flag = false
                tbl2.Wake()
            end)

            return false
        end)
    end

