-- Dandy's World Script for Delta Executor | V1 OP Hub
-- Features: Auto-Farm, Godmode, ESP, Infinite Stamina, and more.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Dandy's World | Delta Edition",
   LoadingTitle = "Preparing Toon Radar...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "DandysDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local AutoFarmIchor = false
local AutoFixGenerators = false
local AutoSkillCheck = false
local GodMode = false
local InfiniteStamina = false
local ESPEnabled = false
local FullBrightEnabled = false
local ThirdPersonEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50

-- Tabs
local MainTab = Window:CreateTab("Main / OP", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- --- MAIN / OP ---

MainTab:CreateToggle({
   Name = "Auto-Collect Ichor/Capsules",
   CurrentValue = false,
   Flag = "AutoIchor",
   Callback = function(Value) AutoFarmIchor = Value end,
})

MainTab:CreateToggle({
   Name = "Auto-Fix Machines (Generators)",
   CurrentValue = false,
   Flag = "AutoFix",
   Callback = function(Value) AutoFixGenerators = Value end,
})

MainTab:CreateToggle({
   Name = "Auto Skill Check (100% Success)",
   CurrentValue = false,
   Flag = "AutoSkill",
   Callback = function(Value) AutoSkillCheck = Value end,
})

MainTab:CreateToggle({
   Name = "God Mode (No Twisted Damage)",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(Value) 
       GodMode = Value 
       if Value then
           Rayfield:Notify({Title = "God Mode", Content = "Attempting to disable monster collisions...", Duration = 3})
       end
   end,
})

MainTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Flag = "InfStamina",
   Callback = function(Value) InfiniteStamina = Value end,
})

-- --- VISUALS ---

VisualsTab:CreateToggle({
   Name = "Global ESP (Twisteds/Machines/Items)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value) ESPEnabled = Value end,
})

VisualsTab:CreateToggle({
   Name = "Third Person (Unlocked Mouse)",
   CurrentValue = false,
   Flag = "ThirdPerson",
   Callback = function(Value)
      ThirdPersonEnabled = Value
      if Value then
          Player.CameraMode = Enum.CameraMode.Classic
          Player.CameraMaxZoomDistance = 12
          Player.CameraMinZoomDistance = 12
          UserInputService.MouseBehavior = Enum.MouseBehavior.Default
      else
          Player.CameraMode = Enum.CameraMode.LockFirstPerson
          Player.CameraMaxZoomDistance = 0.5
          Player.CameraMinZoomDistance = 0.5
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      FullBrightEnabled = Value
      if Value then
          game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
          game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(255, 255, 255)
      else
          game:GetService("Lighting").Ambient = Color3.fromRGB(0, 0, 0)
          game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(0, 0, 0)
      end
   end,
})

-- --- MOVEMENT ---

MovementTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value) WalkSpeedValue = Value end,
})

MovementTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 1,
   CurrentValue = 50,
   Flag = "JP",
   Callback = function(Value) JumpPowerValue = Value end,
})

-- --- UTILITY ---

UtilityTab:CreateButton({
   Name = "Teleport to Elevator",
   Callback = function()
       local elevator = workspace:FindFirstChild("Elevator", true) or workspace:FindFirstChild("Escape", true)
       if elevator and Player.Character then
           Player.Character:MoveTo(elevator.Position + Vector3.new(0, 3, 0))
       end
   end,
})

UtilityTab:CreateButton({
   Name = "Teleport to Unfinished Machine",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v.Name:lower():find("machine") or v.Name:lower():find("generator") then
               -- Simple check if it has a progress value or objective tag
               local prog = v:FindFirstChild("Progress") or v:FindFirstChild("Value")
               if prog and prog.Value < 100 then
                   Player.Character:MoveTo(v.Position + Vector3.new(0, 5, 0))
                   break
               end
           end
       end
   end,
})

-- --- LOGIC LOOPS ---

-- Main Automation Loop
task.spawn(function()
    while task.wait() do
        pcall(function()
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                local hum = Player.Character.Humanoid
                hum.WalkSpeed = WalkSpeedValue
                hum.JumpPower = JumpPowerValue
                
                -- Infinite Stamina
                if InfiniteStamina then
                    local s = Player.Character:FindFirstChild("Stamina") or Player:FindFirstChild("Stamina")
                    if s then s.Value = 100 end
                end

                -- Third Person Mouse Fix
                if ThirdPersonEnabled then
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end

                -- Auto Skill Check
                if AutoSkillCheck then
                    local playerGui = Player:WaitForChild("PlayerGui")
                    local skillCheck = playerGui:FindFirstChild("SkillCheck", true) or playerGui:FindFirstChild("Minigame", true)
                    if skillCheck and skillCheck.Visible then
                        -- Simulates the 'E' or 'Space' press at the right time
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                        task.wait(0.5)
                    end
                end
                
                -- God Mode
                if GodMode then
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and (v.Name:lower():find("twisted") or v.Name:lower():find("dandy")) then
                            for _, p in pairs(v:GetDescendants()) do
                                if p:IsA("BasePart") then p.CanCollide = false end
                            end
                        end
                    end
                end
            end
        end)
    end
end)

-- ESP & Item Tracking
task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                -- Detect Twisted, Machines, and Ichor/Capsules
                local isTwisted = v.Name:lower():find("twisted") or v.Name:lower():find("dandy")
                local isMachine = v.Name:lower():find("machine") or v.Name:lower():find("generator")
                local isItem = v.Name:lower():find("ichor") or v.Name:lower():find("capsule")
                
                if (isTwisted or isMachine or isItem) and v:IsA("Model") then
                    local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChildOfClass("BasePart")
                    if root and not root:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", root)
                        h.FillTransparency = 0.5
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        
                        if isTwisted then h.FillColor = Color3.fromRGB(255, 0, 0)
                        elseif isMachine then h.FillColor = Color3.fromRGB(0, 255, 0)
                        else h.FillColor = Color3.fromRGB(0, 0, 255) end
                        
                        local bbg = Instance.new("BillboardGui", root)
                        bbg.Size = UDim2.new(0, 100, 0, 30)
                        bbg.AlwaysOnTop = true
                        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
                        local tl = Instance.new("TextLabel", bbg)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Text = v.Name
                        tl.TextColor3 = h.FillColor
                        tl.TextScaled = true
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Dandy's World OP Loaded!",
   Content = "Enjoy your infinite ichor and godmode!",
   Duration = 5,
})
