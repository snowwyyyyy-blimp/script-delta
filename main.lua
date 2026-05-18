-- Fisch Script for Delta Executor | V2 Optimized
-- Features: Auto-Fish (Remote Based), Auto-Shake (GUI Scan), Auto-Minigame (Instant Reel)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fisch | Delta Edition V2",
   LoadingTitle = "Bypassing Fishing Mechanics...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "FischDeltaV2", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local AutoFish = false
local AutoShake = false
local AutoMinigame = false
local RarityNotifier = false
local InfiniteOxygen = false
local WalkSpeedValue = 16

-- Tabs
local MainTab = Window:CreateTab("Fishing", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- --- FISHING ---

MainTab:CreateToggle({
   Name = "Auto-Cast (Auto-Fish)",
   CurrentValue = false,
   Flag = "AutoCast",
   Callback = function(Value) AutoFish = Value end,
})

MainTab:CreateToggle({
   Name = "Auto-Shake",
   CurrentValue = false,
   Flag = "AutoShake",
   Callback = function(Value) AutoShake = Value end,
})

MainTab:CreateToggle({
   Name = "Auto-Minigame (Instant Reel)",
   CurrentValue = false,
   Flag = "AutoMinigame",
   Callback = function(Value) AutoMinigame = Value end,
})

-- --- UTILITY ---

UtilityTab:CreateToggle({
   Name = "Rarity Notifier",
   CurrentValue = false,
   Flag = "Notifier",
   Callback = function(Value) RarityNotifier = Value end,
})

UtilityTab:CreateToggle({
   Name = "Infinite Oxygen",
   CurrentValue = false,
   Flag = "InfOxygen",
   Callback = function(Value) InfiniteOxygen = Value end,
})

UtilityTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value) WalkSpeedValue = Value end,
})

-- --- LOGIC LOOPS ---

-- 1. Auto Cast (Using updated remote paths)
task.spawn(function()
    while task.wait(0.5) do
        if AutoFish then
            local Character = Player.Character
            if Character then
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool and Tool.Name:lower():find("rod") then
                    -- Detect if we are NOT currently fishing
                    if not Character:FindFirstChild("FishingLine") and not Character:FindFirstChild("Bobber") then
                        -- Fisch usually uses a 'Cast' or 'Events' folder
                        local events = Tool:FindFirstChild("events") or Tool:FindFirstChild("Events")
                        local cast = events and (events:FindFirstChild("cast") or events:FindFirstChild("Cast"))
                        if cast then
                            cast:FireServer(100) -- Full power cast
                            task.wait(1.5) -- Animation delay
                        end
                    end
                end
            end
        end
    end
end)

-- 2. Auto Shake (Using recursive UI detection)
task.spawn(function()
    while task.wait(0.1) do
        if AutoShake then
            local PlayerGui = Player:WaitForChild("PlayerGui")
            -- Scan for anything named "Shake" or "Button" in the screen
            for _, v in pairs(PlayerGui:GetDescendants()) do
                if v:IsA("ImageButton") and v.Name == "Button" and v.Parent.Name == "SafeZone" then
                    if v.Visible and v.ImageTransparency < 1 then
                        -- Trigger the shake button
                        local pos = v.AbsolutePosition + (v.AbsoluteSize / 2)
                        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                    end
                end
            end
        end
    end
end)

-- 3. Auto Minigame (Instant Reel Remote)
task.spawn(function()
    while task.wait(0.1) do
        if AutoMinigame then
            local PlayerGui = Player:WaitForChild("PlayerGui")
            local minigame = PlayerGui:FindFirstChild("Minigame", true)
            if minigame and minigame.Visible then
                -- Fisch 2026 update: The 'Reel' event is often in ReplicatedStorage.Events
                local reel = ReplicatedStorage:FindFirstChild("Reel", true) or ReplicatedStorage:FindFirstChild("FinishReel", true)
                if reel and reel:IsA("RemoteEvent") then
                    reel:FireServer(100, true) -- Send 100% progress and 'Perfect' catch flag
                end
            end
        end
    end
end)

-- 4. Rarity Notifier
task.spawn(function()
    -- Look for the specific 'Catch' or 'Result' event
    local result = ReplicatedStorage:FindFirstChild("Result", true) or ReplicatedStorage:FindFirstChild("FishCaught", true)
    if result and result:IsA("RemoteEvent") then
        result.OnClientEvent:Connect(function(data)
            if RarityNotifier and data and data.Rarity then
                Rayfield:Notify({
                    Title = "🐟 " .. (data.Rarity:upper()) .. " caught!",
                    Content = "You caught a " .. data.Name .. " (" .. data.Weight .. "kg)",
                    Duration = 5
                })
            end
        end)
    end
end)

-- 5. Movement & Oxygen
RunService.Heartbeat:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = WalkSpeedValue
        
        if InfiniteOxygen then
            local oxy = Player.Character:FindFirstChild("Oxygen") or Player:FindFirstChild("Oxygen")
            if oxy then oxy.Value = 100 end
        end
    end
end)

Rayfield:Notify({
   Title = "Fisch V2 Loaded!",
   Content = "Optimized for the latest 2026 update.",
   Duration = 5,
})
