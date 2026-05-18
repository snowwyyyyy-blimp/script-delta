-- Fisch Script for Delta Executor | Optimized for 2026
-- Features: Auto-Fish, Auto-Shake, Auto-Minigame, Rarity Notifiers, and more.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Fisch | Delta Edition",
   LoadingTitle = "Preparing Fishing Gear...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "FischDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
   Callback = function(Value)
      AutoFish = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto-Shake",
   CurrentValue = false,
   Flag = "AutoShake",
   Callback = function(Value)
      AutoShake = Value
   end,
})

MainTab:CreateToggle({
   Name = "Auto-Minigame (100% Perfect)",
   CurrentValue = false,
   Flag = "AutoMinigame",
   Callback = function(Value)
      AutoMinigame = Value
   end,
})

-- --- UTILITY ---

UtilityTab:CreateToggle({
   Name = "Rarity Notifier",
   CurrentValue = false,
   Flag = "Notifier",
   Callback = function(Value)
      RarityNotifier = Value
   end,
})

UtilityTab:CreateToggle({
   Name = "Infinite Oxygen",
   CurrentValue = false,
   Flag = "InfOxygen",
   Callback = function(Value)
      InfiniteOxygen = Value
   end,
})

UtilityTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      WalkSpeedValue = Value
   end,
})

-- --- LOGIC LOOPS ---

-- Auto Cast Logic
task.spawn(function()
    while task.wait(1) do
        if AutoFish then
            local Character = Player.Character
            if Character then
                local Tool = Character:FindFirstChildOfClass("Tool")
                if Tool and Tool:FindFirstChild("Events") and Tool.Events:FindFirstChild("Cast") then
                    -- Trigger cast if not already fishing
                    if not Character:FindFirstChild("FishingLine") then
                        Tool.Events.Cast:FireServer(100) -- Full power cast
                    end
                end
            end
        end
    end
end)

-- Auto Shake Logic
task.spawn(function()
    while task.wait() do
        if AutoShake then
            local PlayerGui = Player:WaitForChild("PlayerGui")
            local shakeUI = PlayerGui:FindFirstChild("ShakeUI", true)
            if shakeUI and shakeUI:FindFirstChild("SafeZone") then
                local button = shakeUI.SafeZone:FindFirstChild("Button")
                if button and button.Visible then
                    -- Simulate click/touch on the shake button
                    local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 1)
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- Auto Minigame Logic
task.spawn(function()
    while task.wait() do
        if AutoMinigame then
            local PlayerGui = Player:WaitForChild("PlayerGui")
            local minigameUI = PlayerGui:FindFirstChild("Minigame", true)
            if minigameUI and minigameUI:FindFirstChild("Bar") then
                -- In Fisch, the minigame usually involves keeping a bar inside a zone
                -- We manipulate the 'Position' or trigger the RemoteEvent directly
                local reelEvent = ReplicatedStorage:FindFirstChild("Reel", true)
                if reelEvent and reelEvent:IsA("RemoteEvent") then
                    reelEvent:FireServer(100) -- Force 100% progress
                end
            end
        end
    end
end)

-- Rarity Notifier Logic
task.spawn(function()
    -- Listen for fish caught events
    local catchRemote = ReplicatedStorage:FindFirstChild("CatchFish", true)
    if catchRemote then
        catchRemote.OnClientEvent:Connect(function(fishData)
            if RarityNotifier and fishData and fishData.Rarity then
                Rayfield:Notify({
                    Title = "🐟 FISH CAUGHT!",
                    Content = "You caught a " .. fishData.Rarity .. " " .. (fishData.Name or "Fish") .. "!",
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end)
    end
end)

-- Movement & Oxygen Loop
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
   Title = "Fisch Script Loaded!",
   Content = "Happy Fishing! Remember to equip your rod first.",
   Duration = 5,
})
