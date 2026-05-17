-- DOORS Script for Delta Executor
-- Features: Third Person (Unlocked Mouse), ESP, Notifiers, Speed, and more.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "DOORS | Delta Edition",
   LoadingTitle = "Loading Entity Data...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "DoorsDelta", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local ThirdPersonEnabled = false
local ESPEnabled = false
local EntityNotifier = false
local FullBrightEnabled = false
local WalkSpeedValue = 16

-- Tabs
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483345998)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- --- VISUALS ---

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
          -- Unlock mouse logic for Delta
          game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
      else
          Player.CameraMode = Enum.CameraMode.LockFirstPerson
          Player.CameraMaxZoomDistance = 0.5
          Player.CameraMinZoomDistance = 0.5
      end
   end,
})

VisualsTab:CreateToggle({
   Name = "Item/Entity ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      ESPEnabled = Value
   end,
})

VisualsTab:CreateToggle({
   Name = "Full Bright",
   CurrentValue = false,
   Flag = "FullBright",
   Callback = function(Value)
      FullBrightEnabled = Value
      if Value then
          game:GetService("Lighting").Brightness = 2
          game:GetService("Lighting").ClockTime = 14
          game:GetService("Lighting").FogEnd = 100000
          game:GetService("Lighting").GlobalShadows = false
      else
          game:GetService("Lighting").Brightness = 1
          game:GetService("Lighting").ClockTime = 0
          game:GetService("Lighting").GlobalShadows = true
      end
   end,
})

-- --- MOVEMENT ---

MovementTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 45},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      WalkSpeedValue = Value
   end,
})

-- --- UTILITY ---

UtilityTab:CreateToggle({
   Name = "Entity Notifier",
   CurrentValue = false,
   Flag = "Notifier",
   Callback = function(Value)
      EntityNotifier = Value
   end,
})

UtilityTab:CreateButton({
   Name = "Instant Interaction",
   Callback = function()
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("ProximityPrompt") then
               v.HoldDuration = 0
           end
       end
       Rayfield:Notify({Title = "Applied!", Content = "All interactions are now instant.", Duration = 3})
   end,
})

-- --- LOGIC LOOPS ---

-- Speed Loop
task.spawn(function()
    while task.wait() do
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

-- Third Person / Mouse Loop
task.spawn(function()
    while task.wait() do
        if ThirdPersonEnabled then
            -- Force unlock mouse every frame to prevent game from locking it
            game:GetService("UserInputService").MouseBehavior = Enum.MouseBehavior.Default
        end
    end
end)

-- Notifier & ESP Loop
task.spawn(function()
    workspace.ChildAdded:Connect(function(child)
        if EntityNotifier then
            if child.Name == "RushMoving" or child.Name == "AmbushMoving" then
                Rayfield:Notify({
                    Title = "⚠️ ENTITY DETECTED!",
                    Content = child.Name:gsub("Moving", "") .. " is coming! HIDE!",
                    Duration = 5,
                    Image = 4483362458,
                })
            end
        end
    end)
end)

-- ESP Functionality (Basic implementation)
task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and (v.Name == "RushMoving" or v.Name == "AmbushMoving" or v.Name == "Key") then
                    if not v:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", v)
                        h.FillColor = (v.Name == "Key" and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0))
                        h.OutlineTransparency = 0
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "DOORS Script Loaded",
   Content = "Enjoy your run! Remember to toggle Third Person for easy mouse movement.",
   Duration = 5,
})
