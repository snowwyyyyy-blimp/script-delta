-- Slime RNG Script for Delta Executor | V1 OP Hub
-- Features: Auto-Roll, Auto-Farm Mobs, Auto-Collect, Auto-Rebirth, and more.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slime RNG | Delta Edition",
   LoadingTitle = "Gooping Up the Server...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "SlimeRNGDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local AutoRoll = false
local AutoFarm = false
local AutoCollect = false
local AutoEquip = false
local AutoRebirth = false
local AutoUpgrade = false
local RarityNotifier = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local NoClip = false
local InfiniteJump = false

-- Tabs
local MainTab = Window:CreateTab("Automation", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

-- --- AUTOMATION ---

MainTab:CreateToggle({
   Name = "Auto Roll Slimes",
   CurrentValue = false,
   Flag = "AutoRoll",
   Callback = function(Value) AutoRoll = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value) AutoRebirth = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Buy Upgrades",
   CurrentValue = false,
   Flag = "AutoUpgrade",
   Callback = function(Value) AutoUpgrade = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Equip Best Slimes",
   CurrentValue = false,
   Flag = "AutoEquip",
   Callback = function(Value) AutoEquip = Value end,
})

-- --- COMBAT ---

CombatTab:CreateToggle({
   Name = "Auto Farm Mobs (Kills All)",
   CurrentValue = false,
   Flag = "AutoFarm",
   Callback = function(Value) AutoFarm = Value end,
})

CombatTab:CreateToggle({
   Name = "Auto Collect Loot (Goop/Coins)",
   CurrentValue = false,
   Flag = "AutoCollect",
   Callback = function(Value) AutoCollect = Value end,
})

-- --- MOVEMENT ---

MovementTab:CreateInput({
   Name = "WalkSpeed",
   PlaceholderText = "16",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      WalkSpeedValue = tonumber(Text) or 16
   end,
})

MovementTab:CreateToggle({
   Name = "No Clip",
   CurrentValue = false,
   Flag = "NoClip",
   Callback = function(Value) NoClip = Value end,
})

MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value) InfiniteJump = Value end,
})

-- --- VISUALS ---

VisualsTab:CreateToggle({
   Name = "Rarity Notifier (1/10k+)",
   CurrentValue = false,
   Flag = "Notifier",
   Callback = function(Value) RarityNotifier = Value end,
})

VisualsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      if Value then
          game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
          game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      else
          game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
          game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(0, 0, 0)
      end
   end,
})

-- --- LOGIC LOOPS ---

-- Main Action Loop
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            -- Auto Roll Logic
            if AutoRoll then
                local rollRemote = ReplicatedStorage:FindFirstChild("Roll", true) or ReplicatedStorage:FindFirstChild("RollEvent", true)
                if rollRemote and rollRemote:IsA("RemoteEvent") then
                    rollRemote:FireServer()
                end
            end

            -- Auto Rebirth Logic
            if AutoRebirth then
                local rebirthRemote = ReplicatedStorage:FindFirstChild("Rebirth", true)
                if rebirthRemote and rebirthRemote:IsA("RemoteEvent") then
                    rebirthRemote:FireServer()
                end
            end

            -- Auto Upgrade Logic
            if AutoUpgrade then
                local upgradeRemote = ReplicatedStorage:FindFirstChild("Upgrade", true) or ReplicatedStorage:FindFirstChild("BuyUpgrade", true)
                if upgradeRemote and upgradeRemote:IsA("RemoteEvent") then
                    -- Cycle through common upgrade IDs
                    for i = 1, 10 do
                        upgradeRemote:FireServer(i)
                    end
                end
            end

            -- Auto Equip Best
            if AutoEquip then
                local equipRemote = ReplicatedStorage:FindFirstChild("EquipBest", true)
                if equipRemote and equipRemote:IsA("RemoteEvent") then
                    equipRemote:FireServer()
                end
            end
        end)
    end
end)

-- Combat & Loot Loop
task.spawn(function()
    while task.wait(0.1) do
        if AutoFarm then
            pcall(function()
                local mobs = workspace:FindFirstChild("Mobs") or workspace:FindFirstChild("Enemies")
                if mobs then
                    for _, mob in pairs(mobs:GetChildren()) do
                        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            -- Teleport near mob or fire attack remote
                            local attackRemote = ReplicatedStorage:FindFirstChild("Attack", true) or ReplicatedStorage:FindFirstChild("DamageMob", true)
                            if attackRemote then
                                attackRemote:FireServer(mob)
                            end
                        end
                    end
                end
            end)
        end

        if AutoCollect then
            pcall(function()
                local drops = workspace:FindFirstChild("Drops") or workspace:FindFirstChild("Loot") or workspace:FindFirstChild("Coins")
                if drops then
                    for _, drop in pairs(drops:GetChildren()) do
                        if drop:IsA("BasePart") or drop:IsA("Model") then
                            local dropRoot = drop:IsA("Model") and drop:FindFirstChildOfClass("BasePart") or drop
                            if dropRoot then
                                dropRoot.CFrame = Player.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Character & Movement Loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            hum.WalkSpeed = WalkSpeedValue
            
            if NoClip then
                for _, v in pairs(Player.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end)

-- Input Listeners
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Space and InfiniteJump then
        Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Rarity Notifier Listener
task.spawn(function()
    local rollResult = ReplicatedStorage:FindFirstChild("RollResult", true) or ReplicatedStorage:FindFirstChild("NewSlime", true)
    if rollResult then
        rollResult.OnClientEvent:Connect(function(data)
            if RarityNotifier and data and data.Chance and data.Chance >= 10000 then
                Rayfield:Notify({
                    Title = "🌟 INSANE LUCK!",
                    Content = "You just rolled a " .. (data.Name or "Slime") .. " (1 in " .. data.Chance .. ")!",
                    Duration = 7
                })
            end
        end)
    end
end)

Rayfield:Notify({
   Title = "Slime RNG Hub Loaded!",
   Content = "Good luck on your 1-in-Trillion rolls!",
   Duration = 5,
})
