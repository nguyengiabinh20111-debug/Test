-- Auto Steal extracted test notes
-- Source: chillihub (1).txt
-- Original Auto Steal region: lines 1880-5505
--
-- Important:
-- This is an extraction of the original code's Auto Steal implementation.
-- It depends on the Chilli Hub globals/modules defined earlier in the source,
-- so it is NOT intended to run as a completely standalone script.
--
-- Core egg-taking path found in the source:
--   1) Read field-egg records / snapshot
--   2) Choose an egg by Uid and filters
--   3) Find the CarryAreaEgg proximity prompt
--   4) Try the game's EggState:CarryFieldEgg(uid) path
--   5) Check tbl4.Steal.Carrying / CarryUid
--   6) Return the carried egg to the home/base and call DropFieldEgg("PlayerRequest")
--
-- The original UI already contains an Auto Steal toggle.
-- The extraction below keeps the original implementation and UI wiring.
--
                local rarity = type(v20) == "table" and v20.Rarity or nil
                local flag3 = type(rarity) == "table"

                if flag3 then
                    local v21 = tonumber
                    local rarityNumber = rarity.RarityNumber or rarity.Rank
                    flag3 = v21(rarityNumber)
                end

                flag3 = flag3 or nil

                if flag3 then
                    local v21 = tbl19[flag3]
                    local v22

                    if v21 then
                        v22 = v21
                    else
                        local v23 = tostring
                        local displayName = rarity.DisplayName or rarity._id or flag3
                        v22 = v23(displayName)
                    end

                    tbl19[flag3] = v22
                end
            end
        end

        if next(tbl19) == nil then
            tbl19 = {
                "Common",
                "Uncommon",
                "Rare",
                "Epic",
                "Legendary",
                "Mythic",
                "Cosmic",
                "Secret",
                "Eternal",
                "Divine",
            }
        end

        local tbl20 = {}

        for k in pairs(tbl19) do
            table.insert(tbl20, k)
        end

        table.sort(tbl20)

        for _, v20 in ipairs(tbl20) do
            table.insert(tbl7, tbl19[v20])
            tbl8[tbl19[v20]] = v20
        end

        tbl9 = { "Best Rarity", "Biggest Weight", "Best Mutation", "Highest Value", "Lowest Value" }
        tbl10 = {}
        n = 0
        tbl15 = {}
        tbl11 = {}
        tbl12 = {}
        tbl13 = {}
        tbl4.Steal.RiftPriority = false
        tbl4.Steal.RiftNeeds = {}
        flag2 = false
        tbl16 = {}
        n6 = 0
        v19 = tbl9[4]
        n2 = 400
        n3 = 27.4
        n4 = 400
        fn11 = nil

        v13 = v5:CreateToggle({
            Name = "Auto Steal",
            Default = false,
            Callback = function()
                if fn11 then
                    fn11()
                end
            end,
        })

        for _, v20 in ipairs(tbl17) do
            tbl10[v20] = true
        end

        fn7(v5:CreateMultiDropdown({
            Name = "Target Areas",
            Options = tbl17,
            Default = tbl17,
            Callback = function(arg)
                local tbl21 = {}

                if type(arg) == "table" then
                    for k, v20 in pairs(arg) do
                        if v20 == true and type(k) == "string" then
                            tbl21[k] = true
                        elseif type(v20) == "string" then
                            tbl21[v20] = true
                        end
                    end
                end

                if next(tbl21) == nil then
                    for _, v20 in ipairs(tbl17) do
                        tbl21[v20] = true
                    end
                end

                tbl10 = tbl21
            end,
        }))
    end

    v5:CreateDropdown({
        Name = "Min Rarity",
        Note = "Steal eggs of the chosen rarity and every rarity above it",
        Options = tbl7,
        Default = tbl7[1],
        Callback = function(arg)
            local n7 = tbl8[arg] or 0
            n = n7
        end,
    })

    do
        local tbl17 = {
            ["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
            ["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
            ["B/s"] = { Min = 0, Max = 100, Mult = 1000000000 },
        }
        local v20 = nil
        local n7 = 0
        local str3 = "M/s"

        local function fn14(arg, arg2)
            if arg ~= nil then
                local max = math.max
                local floor = math.floor
                local num = tonumber(arg) or n7
                n7 = max(0, floor(num))
            end

            if arg2 ~= nil then
                str3 = tostring(arg2)
            end

            local ms = tbl17[str3] or tbl17["M/s"]
            n6 = n7 * ms.Mult
        end

        v20 = v5:CreateSlider({
            Name = "Min Value To Steal",
            Note = "Skip eggs worth less than this (0 = off)",
            Min = 0,
            Max = 1000,
            Default = 0,
            AllowDecimals = false,
            Increment = 1,
            Unit = {
                Default = "M/s",
                Selector = true,
                Options = { "K/s", "M/s", "B/s" },
                ColorEnabled = true,
                Colors = {
                    Number = Color3.fromRGB(255, 255, 255),
                    Suffix = Color3.fromRGB(58, 255, 55),
                },
                Callback = function(arg)
                    local ms = tbl17[arg] or tbl17["M/s"]
                    local setRange = v20

                    if v20 then
                        setRange = v20.SetRange
                    end

                    if setRange then
                        v20:SetRange(ms.Min, ms.Max)
                        local min = tonumber(v20:Get()) or ms.Min
                        local min2 = ms.Min
                        local max = ms.Max
                        local n8 = math.clamp(math.floor(min + 0.5), min2, max)

                        if n8 ~= min then
                            str3 = tostring(arg)
                            v20:Set(n8)
                            return
                        end

                        fn14(n8, arg)
                    else
                        fn14(nil, arg)
                    end
                end,
            },
            Callback = function(arg)
                fn14(arg, nil)
            end,
        })
    end

    do
        local tbl17 = {}
        local tbl18 = {}
        local directory = tbl.Assets and tbl.Assets.Directory
        local tbl19 = {}

        if type(directory) == "table" then
            for k, v20 in pairs(directory) do
                local rarity = type(v20) == "table" and v20.Rarity or nil
                local flag3 = type(rarity) == "table"
                local v21

                if flag3 then
                    local v22 = tonumber
                    local rarityNumber = rarity.RarityNumber or rarity.Rank
                    v21 = v22(rarityNumber)
                else
                    v21 = flag3
                end

                local v22 = v21 or nil

                if v22 then
                    local insert = table.insert
                    local tbl20 = { Category = tostring(k) }
                    local v23 = tostring
                    local displayName = v20.DisplayName or k
                    tbl20.Name = v23(displayName)
                    tbl20.Rarity = v22
                    local v24 = tostring
                    local displayName2 = rarity.DisplayName or rarity._id or v22
                    tbl20.RarityName = v24(displayName2)
                    insert(tbl19, tbl20)
                end
            end
        end

        table.sort(tbl19, function(arg, arg2)
            if arg.Rarity ~= arg2.Rarity then
                return arg.Rarity > arg2.Rarity
            end
            return arg.Name < arg2.Name
        end)

        for _, v20 in ipairs(tbl19) do
            local str3 = string.format("%s [%s]", v20.Name, v20.RarityName)

            if tbl18[str3] then
                str3 = string.format("%s [%s] (%s)", v20.Name, v20.RarityName, v20.Category)
            end

            table.insert(tbl17, str3)
            tbl18[str3] = v20.Category
        end

        fn7(v5:CreateMultiDropdown({
            Name = "Target Specific Eggs",
            Note = "Only steal these eggs (empty = all)",
            Options = tbl17,
            Default = {},
            Callback = function(arg)
                local tbl20 = {}

                if type(arg) == "table" then
                    for k, v20 in pairs(arg) do
                        local flag3 = v20 == true and type(k) == "string"

                        if not flag3 then
                            k = flag3
                        end

                        k = k or type(v20) == "string" and v20
                        k = k or nil

                        if k and tbl18[k] then
                            tbl20[tbl18[k]] = true
                        end
                    end
                end

                tbl15 = tbl20
            end,
        }))
    end

    do
        local n7 = 30
        local v20 = nil
        local flag3 = false
        local n8 = 0

        local function fn14()
            local tbl17 = {}
            local save = tbl.Save

            if type(save) == "table" and type(save.Get) == "function" then
                local ok, result = pcall(save.Get)
                ok = ok and type(result) == "table"

                if ok then
                    local v21 = pairs
                    local inventory = result.Inventory or {}

                    for _, v22 in v21(inventory) do
                        if type(v22) == "table" and v22.Category ~= nil then
                            tbl17[tostring(v22.Category)] = true
                        end
                    end

                    local v22 = pairs
                    local eggInventory = result.EggInventory or {}

                    for _, v23 in v22(eggInventory) do
                        if type(v23) == "table" and v23.AssetCategory ~= nil then
                            tbl17[tostring(v23.AssetCategory)] = true
                        end
                    end
                end
            end

            return tbl17
        end

        local function fn15()
            local rfRiftAskState = networking:FindFirstChild("RF/Rift/AskState")
            if not rfRiftAskState or not rfRiftAskState:IsA("RemoteFunction") then
                return
            end
            local ok, result = pcall(rfRiftAskState.InvokeServer, rfRiftAskState)
            if not ok or type(result) ~= "table" or type(result.Requirements) ~= "table" then
                return
            end
            local v21 = fn14()
            local tbl17 = {}

            for _, v22 in pairs(result.Requirements) do
                if not v21[tostring(v22)] then
                    tbl17[tostring(v22)] = true
                end
            end

            tbl4.Steal.RiftNeeds = tbl17
        end

        tbl2.Add(function()
            if not tbl4.Steal.RiftPriority or flag3 or os.clock() < n8 then
                return false
            end
            flag3 = true
            n8 = os.clock() + n7

            task.spawn(function()
                pcall(fn15)
                flag3 = false
            end)

            return false
        end)

        local function fn16()
            local riftNeeds = tbl4.Steal.RiftNeeds
            if not tbl4.Steal.RiftPriority or next(riftNeeds) == nil then
                return
            end
            local v21 = fn14()
            local flag4 = false

            for k in pairs(riftNeeds) do
                if v21[k] then
                    riftNeeds[k] = nil
                    flag4 = true
                end
            end

            if flag4 then
                tbl2.Wake()
            end
        end

        local save = tbl.Save

        if type(save) == "table" and type(save.FieldSignal) == "function" then
            for _, v21 in ipairs({ "EggInventory", "Inventory" }) do
                local ok, result = pcall(save.FieldSignal, v21)
                ok = ok and type(result) == "table"
                ok = ok and type(result.Connect) == "function"

                if ok then
                    local ok2, result2 = pcall(result.Connect, result, function()
                        task.defer(fn16)
                    end)

                    ok2 = ok2 and result2

                    if ok2 then
                        fn6(function()
                            pcall(function()
                                result2:Disconnect()
                            end)
                        end)
                    end
                end
            end
        end

        v20 = v5:CreateToggle({
            Name = "Steal Missing Rift Eggs",
            Note = "Steal eggs the Rift recipe needs, after your filtered targets",
            Default = false,
            Callback = function()
                tbl4.Steal.RiftPriority = tbl4.Toggle(v20, false) == true
                n8 = 0

                if not tbl4.Steal.RiftPriority then
                    tbl4.Steal.RiftNeeds = {}
                end

                tbl2.Wake()
            end,
        })
    end

    do
        local n7 = 5
        local n8 = 5
        local n9 = 60
        local v20 = nil
        local v21 = nil
        local n10 = 0
        local n11 = 0
        local flag3 = false
        local tbl17 = {}

        local function fn14()
            local save = tbl.Save

            if type(save) == "table" and type(save.Get) == "function" then
                local ok, result = pcall(save.Get)
                ok = ok and type(result) == "table"
                if ok then
                    return result
                end
            end

            return nil
        end

        local function fn15()
            local v22 = fn14()
            local directory = tbl.Areas and tbl.Areas.Directory
            local directory2 = tbl.Assets and tbl.Assets.Directory
            if not v22 or type(directory) ~= "table" or type(directory2) ~= "table" then
                return
            end
            local index = type(v22.Index) == "table" and v22.Index or {}
            local tbl18 = {}
            local v23 = pairs
            local inventory = v22.Inventory or {}

            for _, v24 in v23(inventory) do
                if type(v24) == "table" and v24.Category ~= nil then
                    tbl18[tostring(v24.Category)] = true
                end
            end

            local v24 = pairs
            local eggInventory = v22.EggInventory or {}

            for _, v25 in v24(eggInventory) do
                if type(v25) == "table" and v25.AssetCategory ~= nil then
                    tbl18[tostring(v25.AssetCategory)] = true
                end
            end

            local tbl19 = {}

            for _, v25 in pairs(directory) do
                local flag4 = type(v25) == "table" and type(v25.Rarity) == "table"

                if flag4 then
                    local v26 = tonumber
                    local rarityNumber = v25.Rarity.RarityNumber or v25.Rarity.Rank
                    flag4 = v26(rarityNumber)
                end

                flag4 = flag4 or 0
                local v26 = pairs
                local dropTable = type(v25) == "table" and v25.DropTable or {}

                for _, v27 in v26(dropTable) do
                    local flag5 = type(v27) == "table" and v27[1] or nil
                    local n12 = type(v27) == "table" and tonumber(v27[2]) or 0
                    local flag6 = flag5 ~= nil and directory2[flag5] or nil

                    if type(flag6) == "table" and n12 > 0 and flag6.DontRoll ~= true then
                        local str3 = tostring(flag5)
                        local flag7 = index[flag5] ~= true and not tbl18[str3]
                        local flag8

                        if flag7 then
                            flag8 = tbl19[str3] == nil or flag4 > tbl19[str3]
                        else
                            flag8 = flag7
                        end

                        if flag8 then
                            tbl19[str3] = flag4
                        end
                    end
                end
            end

            tbl16 = tbl19
        end

        local function fn16(arg, ...)
            local v22 = networking:FindFirstChild(arg)
            if not v22 or not v22:IsA("RemoteFunction") then
                return false
            end
            local ok, result = pcall(v22.InvokeServer, v22, ...)
            ok = ok and result ~= false
            return ok
        end

        local function fn17(arg, arg2)
            local tbl18 = {}
            if type(arg) ~= "table" then
                return tbl18
            end

            for _, v22 in ipairs(arg2) do
                local flag4 = arg

                for _, v23 in ipairs(v22) do
                    flag4 = type(flag4) == "table" and flag4[v23]
                    flag4 = flag4 or nil
                end

                local v23 = ipairs
                local flag5 = type(flag4) == "table"

                if not flag5 then
                    flag4 = flag5
                end

                local tbl19 = flag4 or {}

                for _, v24 in v23(tbl19) do
                    if type(v24) == "table" and v24.AssetId ~= nil then
                        table.insert(tbl18, v24.AssetId)
                    end
                end
            end

            return tbl18
        end

        local tbl18 = {
            {
                Id = "LimitedEgg",
                Gear = "GravityDisruptor",
                Module = "LimitedEgg",
                Lists = { { "Entries" }, { "MechaReroll", "Entries" } },
            },
            {
                Id = "BrainrotEgg",
                Gear = "BeeLauncher",
                Module = "BrainrotEgg",
                Lists = { { "Entries" } },
            },
            {
                Id = "MonsterEgg",
                Gear = "BeeLauncher",
                Module = "MonsterEgg",
                Lists = { { "Entries" }, { "MechaEntries" } },
            },
        }

        local function fn18()
            local v22 = fn14()
            if not v22 then
                return
            end
            local index = type(v22.Index) == "table" and v22.Index or {}
            local indexClaimedCategories = type(v22.IndexClaimedCategories) == "table"
                    and v22.IndexClaimedCategories
                or {}

            for k, v23 in pairs(index) do
                if v23 == true and indexClaimedCategories[k] ~= true then
                    fn16("RF/Codex/AskRedeemAll")
                    break
                end
            end

            local gearInventory = type(v22.GearInventory) == "table" and v22.GearInventory or {}

            for _, v23 in ipairs(tbl18) do
                local flag4 = (tonumber(gearInventory[v23.Gear]) or 0) <= 0

                if flag4 then
                    local now = os.clock()
                    local n12 = tbl17[v23.Id] or 0
                    flag4 = now >= n12
                end

                if flag4 then
                    local v24 = fn17(tbl[v23.Module], v23.Lists)
                    local flag5 = #v24 > 0

                    for _, v25 in ipairs(v24) do
                        if index[v25] ~= true then
                            flag5 = false
                            break
                        end
                    end

                    if flag5 then
                        tbl17[v23.Id] = os.clock() + n9
                        fn16("RF/Codex/AskRedeemLimitedEgg", v23.Id)
                    end
                end
            end
        end

        tbl2.Add(function()
            local now = os.clock()
            local flag4 = flag2

            if flag2 then
                flag4 = now >= n10
            end

            if flag4 then
                n10 = now + n7
                pcall(fn15)
            end

            if not flag3 and now >= n11 and tbl4.Toggle(v21, false) then
                flag3 = true
                n11 = now + n8

                task.spawn(function()
                    pcall(fn18)
                    flag3 = false
                end)
            end

            return false
        end)

        v20 = v5:CreateToggle({
            Name = "Steal Missing Index Eggs",
            Note = "Also steal eggs missing from your index, highest area first",
            Default = false,
            Callback = function()
                flag2 = tbl4.Toggle(v20, false) == true
                n10 = 0

                if not flag2 then
                    tbl16 = {}
                end

                tbl2.Wake()
            end,
        })

        v21 = v5:CreateToggle({
            Name = "Auto Claim Index",
            Note = "Claim index rewards as soon as they unlock",
            Default = false,
            Callback = function()
                n11 = 0
                tbl2.Wake()
            end,
        })
    end

    v5:CreateDropdown({
        Name = "Steal Priority",
        Options = tbl9,
        Default = tbl9[4],
        Callback = function(arg)
            if table.find(tbl9, arg) then
                v19 = arg
            end
        end,
    })

    v14 = v5:CreateSlider({
        Name = "Tween Speed",
        Min = 100,
        Max = 1000,
        Default = 400,
        Increment = 10,
        Unit = "studs/s",
        Callback = function(arg)
            local clamp = math.clamp
            local n7 = tonumber(arg) or 400
            local v20 = clamp(n7, 100, 1000)
            n2 = v20
            n4 = v20
        end,
    })

    tbl4.AntiGuard.PanelHandle = v5:CreateToggle({
        Name = "Anti Guard V1",
        Note = "Not recommended to use with Auto Steal",
        Default = false,
        Callback = function(arg)
            if type(arg) ~= "boolean" then
                arg = tbl4.Toggle(tbl4.AntiGuard.PanelHandle, false)
            end

            tbl4.AntiGuard.PanelShown = arg

            if tbl4.AntiGuard.ShowPanel then
                pcall(tbl4.AntiGuard.ShowPanel, arg)
            end
        end,
    })

    v15 = nil
    v16 = nil
    v17 = nil
    str = "None"
    str2 = "Idle"
    flag = false
    n5 = 0
    tbl14 = {}
    local n7
    n7 = 20
    v18 = nil

    fn12 = function(arg)
        local flag3 = arg ~= n5 or not tbl4.Toggle(v15, false)
        return flag3
    end

    local fn14

    do
        local tbl17 = {}

        local function fn15(arg)
            if type(arg) ~= "number" or tbl17[arg] then
                return
            end
            tbl17[arg] = true

            task.delay(math.max(0, arg - workspace:GetServerTimeNow()) + 0.05, function()
                tbl17[arg] = nil
                tbl2.Wake()
            end)
        end

        local n8 = 0

        fn14 = function()
            local areaEggCycle = tbl.AreaEggCycle
            if type(areaEggCycle) ~= "table" then
                return nil
            end

            local ok, result, result2, result3, result4 = pcall(function()
                local serverTimeNow = workspace:GetServerTimeNow()
                local nextResetTime = areaEggCycle.NextResetTime
                return serverTimeNow,
                    areaEggCycle.IsNightPhase(serverTimeNow),
                    areaEggCycle.NextNightTime(serverTimeNow),
                    nextResetTime(serverTimeNow)
            end)

            if not ok or type(result4) ~= "number" then
                return nil
            end

            if result2 == true then
                n8 = result4 + tbl4.WallOpenDelay()
                fn15(n8)
                return n8, "night", result
            end

            if tbl4.WallSealed() then
                fn15(result + 0.3)
                return math.max(n8, result), "wall", result
            end

            if type(result3) == "number" and result3 > result then
                fn15(result3)
            end

            return nil
        end
    end

    do
        local areaEggResetWall = tbl.AreaEggResetWall
        local changed = type(areaEggResetWall) == "table" and areaEggResetWall.Changed or nil

        if changed and type(changed.Connect) == "function" then
            local ok, result = pcall(function()
                return changed:Connect(function()
                    tbl2.Wake()
                end)
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

    local n8
    n8 = 8
    local v20
    v20 = nil
    local n9
    n9 = 0
    local fn15, fn16

    local function fn17(arg)
        local tbl17 = {}
        local str3 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
        local eggState = tbl.EggState

        if type(eggState) == "table" and type(eggState.ReadFieldEggs) == "function" then
            task.spawn(function()
                local ok, result = pcall(eggState.ReadFieldEggs)

                if ok and type(result) == "table" and type(result.Records) == "table" then
                    for _, v21 in pairs(result.Records) do
                        local flag3 = type(v21) == "table" and type(v21.Uid) == "string"

                        if flag3 then
                            local flag4 = arg

                            if arg then
                                flag4 = string.sub(v21.Uid, 1, #str3) == str3
                            end

                            flag3 = not flag4
                        end

                        if flag3 then
                            tbl17[v21.Uid] = true
                        end
                    end
                end
            end)
        end

        return tbl17
    end

    fn13 = function()
        local flag3 = v20 ~= nil and os.clock() < n9
        return flag3
    end

    fn15 = function()
        local flag3 = v20

        if v20 then
            flag3 = n9 == math.huge
        end

        if flag3 then
            return
        end
        v20 = fn17(true)
        n9 = math.huge
        table.clear(tbl11)
        table.clear(tbl13)
        table.clear(tbl12)
        table.clear(tbl14)
        v18 = nil
    end

    fn16 = function()
        if not v20 then
            return false
        end

        if n9 <= os.clock() then
            v20 = nil
            return false
        end
        local v21 = fn17()
        if next(v21) == nil then
            return true
        end
        local flag3 = false
        local flag4 = false

        for k in pairs(v21) do
            if v20[k] then
                flag3 = true
            else
                flag4 = true
            end
        end

        if not flag3 then
            v20 = nil
            return false
        end
        return not flag4
    end

    local fn18

    do
        local function fn19(arg)
            local directory = tbl.Assets and tbl.Assets.Directory
            local flag3 = type(directory) == "table" and directory[tostring(arg)] or nil
            local rarity = type(flag3) == "table" and type(flag3.Rarity) == "table" and flag3.Rarity
                or nil
            local tbl17 = {}
            local v21

            if rarity then
                local v22 = tonumber
                local rarityNumber = rarity.RarityNumber or rarity.Rank
                v21 = v22(rarityNumber)
            else
                v21 = rarity
            end

            tbl17.RarityNumber = v21 or 0
            tbl17.EarningRate = type(flag3) == "table" and tonumber(flag3.EarningRate) or 0
            return tbl17
        end

        local function fn20(arg)
            local mutations = tbl.Mutations

            if type(mutations) == "table" and type(mutations.EarningsFor) == "function" then
                local v21 = pcall
                local earningsFor = mutations.EarningsFor
                local flag3 = type(arg) == "table"

                if not flag3 then
                    arg = flag3
                end

                arg = arg or {}
                local flag4, v22 = v21(earningsFor, arg)
                flag4 = flag4 and type(v22) == "number"
                if flag4 then
                    return v22
                end
            end

            return 1
        end

        local function fn21(arg, arg2)
            local eggRecords = tbl.EggRecords

            if type(eggRecords) == "table" and type(eggRecords.WeightKgForScale) == "function" then
                local ok, result = pcall(eggRecords.WeightKgForScale, arg, arg2)
                ok = ok and type(result) == "number"
                if ok then
                    return result
                end
            end

            return 0
        end

        fn18 = function(arg, arg2)
            local records = nil
            local eggState = tbl.EggState

            if type(eggState) == "table" and type(eggState.ReadFieldEggs) == "function" then
                task.spawn(function()
                    local ok, result = pcall(eggState.ReadFieldEggs)
                    ok = ok and type(result) == "table"
                    ok = ok and type(result.Records) == "table"
                    ok = ok and next(result.Records) ~= nil

                    if ok then
                        records = result.Records
                    end
                end)
            end

            if not records then
                local rfEggWorldAskFieldEggSnapshot =
                    networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
                if
                    not rfEggWorldAskFieldEggSnapshot
                    or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction")
                then
                    return {}
                end
                local ok, result =
                    pcall(rfEggWorldAskFieldEggSnapshot.InvokeServer, rfEggWorldAskFieldEggSnapshot)
                ok = ok and type(result) == "table"
                ok = ok and result.Records
                records = ok or nil
            end

            if type(records) ~= "table" then
                return {}
            end
            local tbl17 = {}
            local tbl18 = {}

            for _, record in pairs(records) do
                local uid = type(record) == "table" and record.Uid or nil

                if uid and record.State ~= "Claimed" then
                    tbl18[uid] = true
                end

                local flag3 = tbl4.Steal.Carrying and uid == tbl4.Steal.CarryUid
                local flag4 = record.State == "Carried"
                    and arg2 == true
                    and arg ~= true
                    and not flag3
                local flag5

                if uid then
                    flag5 = record.State == "Slot" or record.State == "Dropped" or flag4
                else
                    flag5 = uid
                end

                local v21 = uid and tbl11[uid] or nil
                local flag6 = uid and tbl12[uid] == true or false
                local flag7 = arg ~= true
                        and flag2
                        and uid
                        and tbl16[tostring(record.AssetCategory)]
                    or nil
                local flag8 = arg ~= true
                    and tbl4.Steal.RiftPriority == true
                    and uid ~= nil
                    and tbl4.Steal.RiftNeeds[tostring(record.AssetCategory)] == true
                local flag9 = arg == true
                    or v21 ~= nil
                    or flag6
                    or flag8
                    or flag7 ~= nil
                    or tbl10[tostring(record.AreaId)] == true
                local flag10 = arg ~= true and v21 == nil and tbl13[uid] == true
                local flag11 = v20 ~= nil and v20[uid] == true
                flag5 = flag5 and typeof(record.BottomCFrame) == "CFrame"

                if flag5 then
                    flag5 = (tbl14[uid] or 0) <= os.clock()
                end

                if not flag5 then
                    flag9 = flag5
                end

                flag9 = flag9 and not flag10

                if flag9 and not flag11 then
                    local v22 = fn19(record.AssetCategory)
                    local str3 = tostring(record.AssetCategory)
                    local flag12 = v22.RarityNumber >= n
                    local flag13 = next(tbl15) == nil or tbl15[str3] == true
                    local n10 = tonumber(record.AssetScale) or 1
                    local v23 = fn20(record.Mutations)
                    local n11 = n10 > 5 and (n10 / 5) ^ 1.2 * 19.637875755794113 or n10 ^ 1.85
                    local flag14 = n6 <= 0 or v22.EarningRate * n11 * v23 >= n6

                    if not flag12 then
                        flag13 = flag12
                    end

                    if not flag13 then
                        flag14 = flag13
                    end

                    local flag15 = flag8
                        and not flag14
                        and not flag6
                        and v21 == nil
                        and flag7 == nil

                    if arg == true or v21 or flag6 or flag8 or flag7 ~= nil or flag14 then
                        local insert = table.insert
                        local tbl19 = {
                            Uid = uid,
                            Category = str3,
                            Scale = n10,
                            State = record.State,
                            Rarity = v22.RarityNumber,
                            Weight = fn21(record.AssetCategory, n10),
                            Mutation = v23,
                            Value = v22.EarningRate * n11 * v23,
                            CFrame = record.BottomCFrame,
                            AreaId = tostring(record.AreaId),
                        }
                        local flag16 = arg ~= true

                        if not flag16 then
                            flag8 = flag16
                        end

                        tbl19.Rift = flag8
                        local flag17 = arg ~= true

                        if not flag17 then
                            flag15 = flag17
                        end

                        tbl19.RiftOnly = flag15
                        tbl19.Index = flag7
                        tbl19.Forced = arg ~= true and v21 and v21.At or nil
                        local flag18 = arg ~= true

                        if not flag18 then
                            flag6 = flag18
                        end

                        tbl19.Priority = flag6
                        insert(tbl17, tbl19)
                    end
                end
            end

            if next(tbl18) ~= nil then
                for k in pairs(tbl11) do
                    if not tbl18[k] then
                        tbl11[k] = nil
                    end
                end

                for k in pairs(tbl12) do
                    if not tbl18[k] then
                        tbl12[k] = nil
                    end
                end

                for k in pairs(tbl13) do
                    if not tbl18[k] then
                        tbl13[k] = nil
                    end
                end
            end

            table.sort(tbl17, function(arg3, arg4)
                if arg3.Forced ~= nil ~= arg4.Forced ~= nil then
                    return arg3.Forced ~= nil
                end

                if arg3.Forced and arg4.Forced and arg3.Forced ~= arg4.Forced then
                    return arg3.Forced < arg4.Forced
                end

                if arg3.Priority ~= arg4.Priority then
                    return arg3.Priority == true
                end

                if arg3.RiftOnly ~= arg4.RiftOnly then
                    return arg4.RiftOnly == true
                end

                if arg3.Index ~= nil ~= arg4.Index ~= nil then
                    return arg3.Index ~= nil
                end

                if arg3.Index and arg4.Index and arg3.Index ~= arg4.Index then
                    return arg3.Index > arg4.Index
                end

                if v19 == tbl9[2] and arg3.Weight ~= arg4.Weight then
                    return arg3.Weight > arg4.Weight
                end

                if v19 == tbl9[3] and arg3.Mutation ~= arg4.Mutation then
                    return arg3.Mutation > arg4.Mutation
                end

                if v19 == tbl9[4] and arg3.Value ~= arg4.Value then
                    return arg3.Value > arg4.Value
                end

                if v19 == tbl9[5] and arg3.Value ~= arg4.Value then
                    return arg3.Value < arg4.Value
                end

                if arg3.Rarity ~= arg4.Rarity then
                    return arg3.Rarity > arg4.Rarity
                end

                if arg3.Value ~= arg4.Value then
                    return arg3.Value > arg4.Value
                end
                return tostring(arg3.Uid) < tostring(arg4.Uid)
            end)

            return tbl17
        end
    end

    local n10
    n10 = 6
    local fn19, fn20, fn21, fn22, fn23

    do
        local v21 = nil
        local connection = nil

        fn19 = function(arg, arg2, arg3, arg4, arg5)
            local n11 = arg2 - arg.Position
            local magnitude = n11.Magnitude
            local n12 = math.max(arg4, 0.004166666666666667)
            local vector = Vector3.new(0, 0, 0)

            if magnitude > 0.01 then
                vector = n11.Unit * math.min(arg3, magnitude / n12)
            end

            local n13 = vector + Vector3.new(0, workspace.Gravity * n12 * 0.5, 0)

            if 2 < magnitude then
                if not arg5.mark then
                    arg5.mark = magnitude
                    arg5.clock = 0
                end

                arg5.clock = arg5.clock + arg4

                if 0.4 <= arg5.clock then
                    if arg5.mark - magnitude < arg3 * 0.1 then
                        pcall(function()
                            arg.CFrame = arg.CFrame + n11.Unit * math.min(magnitude, arg3 * n12)
                        end)
                    end

                    arg5.mark = magnitude
                    arg5.clock = 0
                end
            else
                arg5.mark = nil
            end

            pcall(function()
                arg.AssemblyLinearVelocity = n13
                arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            end)

            return magnitude <= 0.5
        end

        fn20 = function()
            local v22 = tbl4.Root()

            if v22 then
                pcall(function()
                    v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
        end

        local connection2 = nil
        local tbl17 = {}

        fn21 = function()
            v21 = nil

            if connection then
                connection:Disconnect()
                connection = nil
            end

            if connection2 then
                connection2:Disconnect()
                connection2 = nil
            end
        end

        fn22 = function()
            local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
            local flag3 = num ~= nil and num > workspace:GetServerTimeNow()
            return flag3
        end

        local flag3 = false

        local function fn24()
            if flag3 then
                return true
            end
            return true
        end

        fn23 = function(arg, arg2)
            v21 = arg
            flag3 = arg2 == true
            local v22 = connection
            local flag4

            if connection then
                flag4 = v22
            else
                flag4 = not arg
            end

            if flag4 then
                return
            end
            tbl17 = {}

            connection = RunService.Heartbeat:Connect(function()
                if not v21 or fn24() or fn22() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = tbl4.Root()
                if not v23 then
                    return
                end

                pcall(function()
                    local rotation = v23.CFrame.Rotation
                    v23.CFrame = CFrame.new(v21) * rotation
                    v23.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v23.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            connection2 = RunService.PreSimulation:Connect(function(arg3)
                if not v21 or not fn24() or fn22() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = tbl4.Root()

                if v23 then
                    fn19(v23, v21, n4, arg3, tbl17)
                end
            end)
        end
    end

    fn6(fn21)
    local fn24

    fn24 = function()
        fn21()
        tbl4.EndFlight()
        tbl4.GodMode(false)
        local character = localPlayer.Character
        character = character and character:FindFirstChildOfClass("Humanoid")

        if character then
            character.PlatformStand = false
        end
    end

    local n11, fn25, fn26

    do
        local n12 = 1.5
        n11 = 0.6

        local function fn27(arg, arg2)
            local x = arg2.X
            return (Vector3.new(arg.X, 0, arg.Z) - Vector3.new(x, 0, arg2.Z)).Magnitude
        end

        local function fn28(arg)
            local ok, result = pcall(function()
                return arg:GetPivot().Position
            end)

            if not ok then
                result = ok
            end

            local v21 = result or nil
            return v21
        end

        fn25 = function(arg, arg2, arg3)
            local v21 = fn27(arg.Position, arg3)
            local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
            if not areaEggSlotsClient then
                return true
            end

            for _, child in ipairs(areaEggSlotsClient:GetChildren()) do
                if child:IsA("Model") and child.Name ~= arg2 then
                    local flag3 = fn28(child)
                    flag3 = flag3 and fn27(flag3, arg.Position) + n12 < v21
                    if flag3 then
                        return false
                    end
                    continue
                end
            end

            return true
        end

        fn26 = function(arg, arg2, arg3)
            local n13 = arg3 or 14
            local v21 = nil
            local v22

            for _, child in ipairs(workspace:GetChildren()) do
                if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
                    local carryAreaEgg = child:FindFirstChild("CarryAreaEgg")

                    if carryAreaEgg and carryAreaEgg:IsA("ProximityPrompt") then
                        local v23 = fn27(child.Position, arg2)

                        if v23 < n13 then
                            n13 = v23
                            v21 = carryAreaEgg
                            v22 = child
                        end
                    end
                end
            end

            if not v21 or not v22 then
                return nil
            end

            if type(arg) == "string" and not fn25(v22, arg, arg2) then
                return nil
            end
            return v21, v22
        end
    end

    local fn27

    fn27 = function(arg)
        local eggState = tbl.EggState

        if
            type(arg) == "string"
            and type(eggState) == "table"
            and type(eggState.CarryFieldEgg) == "function"
        then
            pcall(eggState.CarryFieldEgg, arg)
        end
    end

    local fn28

    do
        local function fn29()
            local carryUid = tbl4.Steal.CarryUid
            local flag3 = type(carryUid) == "string"

            if not flag3 then
                carryUid = flag3
            end

            local v21 = carryUid or nil
            return v21
        end

        local function fn30(arg)
            local v21 = fn29()
            if not v21 or type(arg) ~= "string" then
                return true
            end
            return v21 == arg
        end

        local function fn31(arg)
            if type(arg) ~= "string" then
                return false
            end
            local v21 = fn18(false, true)
            if #v21 == 0 then
                return true
            end

            for _, v22 in ipairs(v21) do
                if v22.Uid == arg then
                    return true
                end
            end

            return false
        end

        local function fn32(arg)
            local eggState = tbl.EggState

            if type(eggState) == "table" and type(eggState.DropFieldEgg) == "function" then
                pcall(eggState.DropFieldEgg, "PlayerRequest")
            end

            local n12 = 0

            while tbl4.Steal.Carrying and n12 < 1 and not fn12(arg) do
                n12 = n12 + RunService.Heartbeat:Wait()
            end
        end

        fn28 = function(arg, arg2)
            local n12 = 0

            while not tbl4.Steal.Carrying and n12 < n11 and not fn12(arg2) do
                n12 = n12 + RunService.Heartbeat:Wait()
            end

            if not tbl4.Steal.Carrying then
                str2 = "The egg never reached the hand"
                return false
            end

            if fn30(arg) then
                return true
            end

            if fn31((fn29())) then
                str2 = "Holding another egg that still matches, delivering it"
                return true
            end
            str2 = "Wrong egg in hand, dropping it"
            fn32(arg2)
            return false
        end
    end

    local fn29

    fn29 = function(arg, arg2)
        local eggState = tbl.EggState
        local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
        if not position then
            return false
        end
        local n12 = 0
        local huge = math.huge
        local n13 = 0

        while n12 < 1.5 do
            if fn12(arg2) then
                return false
            end

            if tbl4.Steal.Carrying then
                return true
            end

            if 0.06 <= huge then
                local v21 = fn26(arg.Uid, position)

                if v21 then
                    pcall(function()
                        v21.HoldDuration = 0
                    end)

                    n13 = 0

                    if typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, v21)
                        n13 = 0
                    end
                else
                    n13 = n13 + 1
                    if 4 <= n13 then
                        return false
                    end

                    if type(eggState) == "table" and type(eggState.CarryFieldEgg) == "function" then
                        pcall(eggState.CarryFieldEgg, arg.Uid)
                    end
                end

                huge = 0
            end

            local result = RunService.Heartbeat:Wait()
            n12 = n12 + result
            huge = huge + result
        end

        return tbl4.Steal.Carrying == true
    end

    local fn30, fn31, n12, n13

    do
        local v21 = fn3(function()
            return ReplicatedStorage.Shared.Modules.Ragdoll
        end)

        local function fn32()
            local character = localPlayer.Character

            if type(v21) == "table" and type(v21.IsRagdolled) == "function" then
                local ok, result = pcall(v21.IsRagdolled, character)
                ok = ok and result == true
                if ok then
                    return true
                end
            end

            local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
            num = num and num > workspace:GetServerTimeNow()
            if num then
                return true
            end
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                local state = humanoid:GetState()
                local flag3 = state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown
                return flag3
            end

            return false
        end

        fn30 = function(arg, arg2)
            if tbl4.Steal.Carrying then
                return true
            end
            local rfEggWorldAskFieldEggSnapshot =
                networking:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot")
            if
                not rfEggWorldAskFieldEggSnapshot
                or not rfEggWorldAskFieldEggSnapshot:IsA("RemoteFunction")
            then
                return false
            end
            local n14 = 0

            while n14 < 1 do
                if fn12(arg2) or tbl4.Steal.Carrying then
                    return tbl4.Steal.Carrying == true
                end
                local ok, result =
                    pcall(rfEggWorldAskFieldEggSnapshot.InvokeServer, rfEggWorldAskFieldEggSnapshot)
                ok = ok and type(result) == "table"
                ok = ok and result.Records
                local v22 = ok or nil

                if type(v22) == "table" then
                    local flag3 = false

                    for _, v23 in pairs(v22) do
                        local flag4 = type(v23) == "table" and v23.Uid == arg
                        local flag5

                        if flag4 then
                            flag5 = v23.State == "Slot" or v23.State == "Dropped"
                        else
                            flag5 = flag4
                        end

                        if flag5 then
                            flag3 = true
                            break
                        else
                            flag3 = false
                        end
                    end

                    if not flag3 then
                        return tbl4.Steal.Carrying == true
                    end
                end

                n14 = n14 + task.wait(0.3)
            end

            return tbl4.Steal.Carrying == true
        end

        local function fn33(arg)
            local v22 = tbl4.Root()
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not v22 or not position then
                return math.huge
            end
            return (v22.Position - position).Magnitude
        end

        fn31 = function(arg)
            local huge = math.huge
            local v22 = nil

            for _, v23 in ipairs(arg) do
                local v24 = fn33(v23)

                if v24 < huge then
                    huge = v24
                    v22 = v23
                end
            end

            return v22, huge
        end

        n12 = 20
        n13 = 90
        local n14 = 6

        local function fn34(arg, arg2, arg3, arg4, arg5, arg6)
            fn21()
            local v22 = tbl4.Root()
            if not v22 then
                return false
            end
            local character = localPlayer.Character
            local position = v22.Position
            local tbl17 = {}
            local position2 = nil
            local flag3 = nil
            local str3 = nil
            local n15 = 0

            local function fn34()
                if arg4 ~= nil then
                    return true
                end
                return true
            end

            local function fn35(arg7)
                n15 = n15 + arg7
                if fn12(arg2) then
                    flag3 = false
                    return nil
                end
                local flag4 = arg3

                if arg3 then
                    flag4 = not tbl4.Steal.Carrying
                end

                if flag4 then
                    flag3 = false
                    str3 = "dropped"
                    return nil
                end

                if arg6 then
                    local v23 = arg6()

                    if v23 then
                        flag3 = false
                        str3 = v23
                        return nil
                    end
                end

                local v23 = tbl4.Root()

                if not v23 or n15 >= 25 or localPlayer.Character ~= character then
                    flag3 = false
                    str3 = "respawned"
                    return nil
                end

                return v23
            end

            local connection = RunService.Heartbeat:Connect(function(arg7)
                if flag3 ~= nil or fn34() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = fn35(arg7)
                if not v23 then
                    return
                end

                if (v23.Position - position).Magnitude > n10 then
                    if arg5 then
                        flag3 = false
                        str3 = "displaced"
                        return
                    end

                    position = v23.Position
                end

                local v24 = arg4
                local v25

                if arg4 then
                    v25 = v24
                else
                    v25 = n2
                end

                local n16 = arg - position
                local n17 = v25 * arg7
                local flag4 = n16.Magnitude <= math.max(n17, 0.05)
                local n18 = flag4 and arg or position + n16.Unit * n17
                position = n18
                local vector = Vector3.new(n16.X, 0, n16.Z)
                local cframe = vector.Magnitude > 0.05
                        and CFrame.lookAt(Vector3.new(0, 0, 0), vector.Unit)
                    or v23.CFrame.Rotation

                pcall(function()
                    v23.CFrame = CFrame.new(position) * cframe
                    v23.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    v23.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)

                if flag4 then
                    flag3 = true
                end
            end)

            local connection2 = RunService.PreSimulation:Connect(function(arg7)
                if flag3 ~= nil or not fn34() or tbl4.AntiGuard.Busy then
                    return
                end
                local v23 = fn35(arg7)
                if not v23 then
                    return
                end
                local v24 = arg4

                if not arg4 then
                    v24 = n2
                end

                local flag4 = arg5

                if arg5 then
                    flag4 = position2
                end

                flag4 = flag4 and (v23.Position - position2).Magnitude > n10 + v24 * arg7

                if flag4 then
                    flag3 = false
                    str3 = "displaced"
                    return
                end

                if fn19(v23, arg, v24, arg7, tbl17) then
                    flag3 = true
                end

                position2 = v23.Position
                position = v23.Position
            end)

            while flag3 == nil do
                RunService.Heartbeat:Wait()
            end

            connection:Disconnect()
            connection2:Disconnect()

            if fn34() and not flag3 then
                fn20()
            end

            if flag3 then
                fn23(arg, arg4 ~= nil)
            end

            return flag3, str3
        end

        local tbl17 = {
            {
                Path = { "GearGiver_Slap", "Podium" },
                Offset = Vector3.new(-16.415000915527344, 21.07200050354004, -6.105999946594238),
            },
            {
                Path = { "World", "Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003" },
                Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
            },
            {
                Path = {
                    "__OBJECTS",
                    "Machines",
                    "RiftMachine",
                    "Rift",
                    "Meshes/VoidPortal_Cube.003",
                },
                Offset = Vector3.new(-26.775999069213867, 1.75, 18.665000915527344),
            },
        }

        local function fn35()
            for _, v22 in ipairs(tbl17) do
                local v23 = workspace

                for _, v24 in ipairs(v22.Path) do
                    v23 = v23 and v23:FindFirstChild(v24)
                    v23 = v23 or nil
                end

                if v23 and v23:IsA("BasePart") then
                    local cFrame = v23.CFrame
                    return cFrame:PointToWorldSpace(v22.Offset)
                end
            end

            return Vector3.new(528.7000122070313, 70.56999969482422, -364.1099853515625)
        end

        tbl4.StealHome = fn35

        tbl4.InsideBase = function(arg)
            if not arg then
                arg = tbl4.Root()
                arg = arg and arg.Position
            end

            if arg == nil then
                return false
            end
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            world = world and world:FindFirstChild("SeparationLine")
            local x = world and world:IsA("BasePart") and world.Position.X or 552
            return arg.X < x
        end

        local function fn36(arg)
            if tbl4.AntiGuard.Busy then
                return false
            end
            local character = localPlayer.Character
            local v22 = tbl4.Root()
            if not character or not v22 then
                return false
            end
            local rotation = v22.CFrame.Rotation
            local n15 = CFrame.new(arg) * rotation

            pcall(function()
                character:PivotTo(n15)
            end)

            if 3 < (v22.Position - arg).Magnitude then
                pcall(function()
                    v22.CFrame = n15
                end)
            end

            for _, descendant in ipairs(character:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    pcall(function()
                        descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end

            return true
        end

        local function fn37(arg)
            if tbl4.AntiGuard.Busy then
                return
            end
            local character = localPlayer.Character
            local v22 = tbl4.Root()
            if not character or not v22 or not arg then
                return
            end

            if 6 < (v22.Position - arg).Magnitude then
                fn36(arg)
                return
            end

            for _, descendant in ipairs(character:GetDescendants()) do
                if
                    descendant:IsA("BasePart")
                    and descendant ~= v22
                    and (descendant.Position - v22.Position).Magnitude > 12
                then
                    pcall(function()
                        descendant.CFrame = v22.CFrame
                        descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
        end

        local function fn38(arg, arg2)
            local n15 = 0

            while true do
                if not (n15 < n14) then
                    return not fn12(arg)
                else
                    if fn12(arg) then
                        break
                    end
                    local character = localPlayer.Character
                    local flag3 = fn32()
                    local v22

                    if not flag3 and character then
                        for _, descendant in ipairs(character:GetDescendants()) do
                            if
                                descendant:IsA("Constraint")
                                and string.find(descendant.Name, "RagdollConstraint", 1, true)
                            then
                                flag3 = true
                                break
                            end
                        end

                        v22 = flag3
                    else
                        v22 = flag3
                    end

                    if not v22 then
                        return not fn12(arg)
                    end
                    fn37(arg2)
                    n15 = n15 + RunService.Heartbeat:Wait()
                end
            end

            return false
        end

        local function fn39(arg)
            local world = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
            world = world and world:FindFirstChild("Areas")
            world = world and world:FindFirstChild("GuardAreas")
            local areaId = world and arg and arg.AreaId and world:FindFirstChild(arg.AreaId)
            local guard = areaId and areaId:FindFirstChild("Guard") or nil
            return guard
        end

        local function fn40(arg)
            local v22 = fn39(arg)
            local flag3 = v22 ~= nil and v22:GetAttribute("GuardState") == "Sleeping"
            return flag3
        end

        local n15 = 3

        local function fn41(arg)
            local v22 = fn39(arg)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not v22 or not position then
                return nil, nil
            end

            local ok, result = pcall(function()
                return v22:GetPivot().Position
            end)

            if not ok then
                return nil, nil
            end
            local vector = Vector3.new(position.X - result.X, 0, position.Z - result.Z)
            if vector.Magnitude < 0.1 then
                return nil, nil
            end
            local n16 = result + vector.Unit * n15
            return Vector3.new(n16.X, position.Y + 3, n16.Z), result
        end

        local function fn42(arg, arg2)
            local tbl18 = { Landed = false, Destination = arg2 }
            local antiGuard = tbl4.AntiGuard
            antiGuard.HitArms = antiGuard.HitArms + 1
            tbl4.AntiGuard.HitArmedAt = os.clock()

            tbl18.Link = localPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
                if tbl18.Landed or fn12(arg) then
                    return
                end
                local num = tonumber(localPlayer:GetAttribute("RagdollEndTime"))
                if not num or num <= workspace:GetServerTimeNow() then
                    return
                end
                local v22 = tbl4.Root()
                if not v22 then
                    return
                end
                tbl18.Landed = true
                fn21()

                pcall(function()
                    v22.CFrame = CFrame.new(tbl18.Destination)
                    v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end)
            end)

            tbl18.Stop = function()
                if tbl18.Link then
                    tbl18.Link:Disconnect()
                    tbl18.Link = nil
                    tbl4.AntiGuard.HitArms = math.max(0, tbl4.AntiGuard.HitArms - 1)
                end
            end

            return tbl18
        end

        local function fn43(arg, arg2, arg3)
            local character = localPlayer.Character
            character = character and character:FindFirstChildOfClass("Humanoid")

            if character then
                character.PlatformStand = false
            end

            local n16 = 0
            local v22 = nil

            while true do
                if not arg2.Landed and n16 < n12 then
                    if not fn12(arg) then
                        if arg3 then
                            arg3(arg2)
                        end

                        if not tbl4.Steal.Carrying then
                            local v23 = v22 or n16

                            if 1 < n16 - v23 then
                                break
                            else
                                v22 = v23
                                n16 = n16 + RunService.Heartbeat:Wait()
                                continue
                            end
                        else
                            n16 = n16 + RunService.Heartbeat:Wait()
                            continue
                        end
                    end
                end

                break
            end

            arg2.Stop()
            return arg2.Landed
        end

        local n16 = 20

        local function fn44(arg, arg2, arg3, arg4)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end
            local n17 = 0
            local huge = math.huge

            while n17 < arg3 do
                if fn12(arg2) then
                    return false
                end

                if tbl4.Steal.Carrying then
                    return true
                end

                if 0.1 <= huge then
                    local v22 = fn26(arg.Uid, position)

                    if v22 then
                        pcall(function()
                            v22.HoldDuration = 0
                        end)

                        if typeof(fireproximityprompt) == "function" then
                            pcall(fireproximityprompt, v22)
                        end
                    else
                        fn27(arg.Uid)
                    end

                    huge = 0
                end

                if arg4 then
                    fn37(arg4)
                end

                local result = RunService.Heartbeat:Wait()
                n17 = n17 + result
                huge = huge + result
            end

            return tbl4.Steal.Carrying == true
        end

        local function fn45(arg, arg2, arg3, arg4)
            local position = typeof(arg.CFrame) == "CFrame" and arg.CFrame.Position or nil
            if not position then
                return false
            end
            local n17 = position + Vector3.new(0, 3, 0)
            local character = localPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid and character:FindFirstChildWhichIsA("Tool") then
                pcall(function()
                    humanoid:UnequipTools()
                end)
            end

            if arg3 then
                fn23(n17, true)
                str2 = "Waiting to stand up"
                if not fn38(arg2, n17) then
                    return false
                end
            else
                str2 = "Jumping to the egg"
                local v22 = tbl4.Root()

                if v22 and (n17 - v22.Position).Magnitude <= n13 then
                    pcall(function()
                        local rotation = v22.CFrame.Rotation
                        v22.CFrame = CFrame.new(n17) * rotation
                        v22.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        v22.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                elseif not fn34(n17, arg2, nil, n4) then
                    return false
                end
            end

            if fn12(arg2) then
                return false
            end
            local flag3 = arg4 and typeof(arg4.CFrame) == "CFrame"
            local v22 = nil

            if flag3 then
                v22 = fn42(arg2, arg4.CFrame.Position + Vector3.new(0, 3, 0))
            end

            local str3 = "FirstAreaEgg_" .. tostring(localPlayer.UserId)
            local flag4 = type(arg.Uid) == "string"
                    and string.sub(arg.Uid, 1, #str3) == str3
                    and string.match(arg.Uid, "_([%w ]+:Slot_%d+)$")
                or nil
            arg4 = arg4 and flag4
            local flag5 = false

            if arg4 then
                local eggState = tbl.EggState
                local flag6 = type(eggState) == "table"
                    and type(eggState.CarryFieldEgg) == "function"
                flag5 = false

                if flag6 then
                    str2 = "Taking the starter egg"

                    task.spawn(function()
                        pcall(eggState.CarryFieldEgg, arg.Uid, flag4)
                    end)

                    local n18 = 0

                    while not tbl4.Steal.Carrying and n18 < 0.8 do
                        if fn12(arg2) then
                            return false
                        end
                        n18 = n18 + RunService.Heartbeat:Wait()
                    end

                    flag5 = tbl4.Steal.Carrying == true
                end
            end

            if not flag5 then
                str2 = "Taking the egg"
                flag5 = fn29(arg, arg2)

                if not flag5 and not fn12(arg2) then
                    fn34(n17, arg2, nil, n4)
                    flag5 = fn29(arg, arg2)
                end
            end

            if not flag5 and not fn30(arg.Uid, arg2) then
                if v22 then
                    v22.Stop()
                end

                tbl14[arg.Uid] = os.clock() + n7
                str2 = "That egg would not come free"
                return false
            end

            if v22 then
                local reGuardPatrolForestStrike =
                    networking:FindFirstChild("RE/GuardPatrol/ForestStrike")
                local v23 = fn39(arg) or fn39({ AreaId = "Forest" })
                local humanoidRootPart = v23 and v23:FindFirstChild("HumanoidRootPart")

                if
                    reGuardPatrolForestStrike
                    and reGuardPatrolForestStrike:IsA("RemoteEvent")
                    and humanoidRootPart
                then
                    str2 = "Calling the guard strike"

                    pcall(function()
                        reGuardPatrolForestStrike:FireServer({
                            EggUid = arg.Uid,
                            GuardCFrame = humanoidRootPart.CFrame,
                        })
                    end)
                end
            end

            tbl4.Steal.LastFinishedAt = os.clock()
            return true, v22
        end

        local n17 = 3
        local n18 = 30

        local function fn46(arg, arg2, arg3)
            local v22 = nil
            local v23 = nil

            for _, child in ipairs(workspace:GetChildren()) do
                if child.Name == "SmartPromptPart" and child:IsA("BasePart") then
                    local carryAreaEgg = child:FindFirstChild("CarryAreaEgg")

                    if carryAreaEgg and carryAreaEgg:IsA("ProximityPrompt") then
                        local magnitude = (child.Position - arg).Magnitude

                        if magnitude < arg2 then
                            arg2 = magnitude
                            v22 = carryAreaEgg
                            v23 = child
                        end
                    end
                end
            end

            if v22 and v23 and type(arg3) == "string" and not fn25(v23, arg3, arg) then
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

            if not tbl4.Toggle(v15, false) then
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

    v15 = v13

    fn11 = function()
        n5 = n5 + 1
        table.clear(tbl14)
        tbl4.Steal.Active = false
        tbl4.Steal.Wanted = false
        local v21 = tbl4.Toggle(v15, false)
        tbl4.Shield("steal", v21)

        if not v21 then
            tbl4.Movement.StealFirst = false
            table.clear(tbl11)
            table.clear(tbl12)
            table.clear(tbl13)
        end

        fn24()
        tbl4.StopWalking()
        tbl2.Wake()
    end

    do
        local function fn32()
            n5 = n5 + 1
            tbl4.Steal.Active = false
            fn24()
            tbl4.StopWalking()
        end

        local function fn33()
            if tbl4.Toggle(v15, false) then
                return true
            end
            local flag3 = v15

            if v15 then
                flag3 = type(v15.Set) == "function"
            end

            if flag3 then
                pcall(v15.Set, v15, true)
            end

            return false
        end

        tbl4.CancelSteal = function(arg)
            if type(arg) ~= "string" then
                return
            end
            tbl11[arg] = nil
            tbl12[arg] = nil
            tbl13[arg] = true
            local flag3 = flag

            if flag then
                flag3 = v18 == arg
            end

            if flag3 then
                fn32()
            end

            tbl2.Wake()
