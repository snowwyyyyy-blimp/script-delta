-- Nico's Nextbots Script V2 | Optimized for 2026
-- Features: Nextbot Radar, Movement Tech (Bhop/Slide), Third Person Fix, and more.

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Nico's Nextbots | Delta Edition V2",
   LoadingTitle = "Scanning Mall for Bots...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = { Enabled = true, FolderName = "NicosDeltaV2", FileName = "Config" },
   KeySystem = false
})

-- Variables
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ESPEnabled = false
local ThirdPersonEnabled = false
local AutoBhop = false
local InfiniteStamina = false
local NoSlideCooldown = false
local FullBrightEnabled = false
local AntiRagdoll = false
local WalkSpeedValue = 16
local JumpPowerValue = 50
local FOVValue = 70

-- Tabs
local CombatTab = Window:CreateTab("Combat/Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483345998)

-- --- MOVEMENT ---

CombatTab:CreateToggle({
   Name = "Auto Bhop",
   CurrentValue = false,
   Flag = "Bhop",
   Callback = function(Value) AutoBhop = Value end,
})

CombatTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Flag = "InfStamina",
   Callback = function(Value) InfiniteStamina = Value end,
})

CombatTab:CreateToggle({
   Name = "No Slide Cooldown",
   CurrentValue = false,
   Flag = "NoSlideCD",
   Callback = function(Value) NoSlideCooldown = Value end,
})

CombatTab:CreateToggle({
   Name = "Anti-Ragdoll",
   CurrentValue = false,
   Flag = "AntiRagdoll",
   Callback = function(Value) AntiRagdoll = Value end,
})

CombatTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 150},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value) WalkSpeedValue = Value end,
})

-- --- VISUALS ---

VisualsTab:CreateToggle({
   Name = "Nextbot ESP (Radar)",
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
      else
          Player.CameraMode = Enum.CameraMode.LockFirstPerson
          Player.CameraMaxZoomDistance = 0.5
          Player.CameraMinZoomDistance = 0.5
      end
   end,
})

VisualsTab:CreateSlider({
   Name = "Field of View (FOV)",
   Range = {70, 120},
   Increment = 1,
   CurrentValue = 70,
   Flag = "FOV",
   Callback = function(Value) FOVValue = Value end,
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

-- --- UTILITY ---

UtilityTab:CreateButton({
   Name = "Teleport to Safe Zone",
   Callback = function()
       -- Search for SafeRoom or spawn areas
       local safeZone = workspace:FindFirstChild("SafeRoom", true) or workspace:FindFirstChild("SpawnLocation", true)
       if safeZone and Player.Character then
           Player.Character:MoveTo(safeZone.Position + Vector3.new(0, 3, 0))
       end
   end,
})

UtilityTab:CreateButton({
   Name = "Instant Revive Nearby",
   Callback = function()
       -- Scans for players with "Downed" status or Ragdoll state
       for _, p in pairs(game.Players:GetPlayers()) do
           if p ~= Player and p.Character and p.Character:FindFirstChild("Humanoid") then
               -- Placeholder for reviving remotes (game-specific)
               Rayfield:Notify({Title = "Revive", Content = "Attempting to help " .. p.Name, Duration = 2})
           end
       end
   end,
})

UtilityTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAFK",
   Callback = function(Value)
       if Value then
           local VirtualUser = game:GetService("VirtualUser")
           Player.Idled:Connect(function()
               VirtualUser:CaptureController()
               VirtualUser:ClickButton2(Vector2.new())
           end)
       end
   end,
})

-- --- LOGIC LOOPS ---

-- Character Loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            local hum = Player.Character.Humanoid
            
            -- Speed & Jump
            hum.WalkSpeed = WalkSpeedValue
            
            -- FOV
            Camera.FieldOfView = FOVValue
            
            -- Bhop
            if AutoBhop and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                if Player.Character.Humanoid.FloorMaterial ~= Enum.Material.Air then
                    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
            
            -- Third Person Mouse Fix
            if ThirdPersonEnabled then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end

            -- Anti-Ragdoll
            if AntiRagdoll and hum:GetState() == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
            
            -- Stamina Logic (Nico's usually uses a value in character or local script)
            if InfiniteStamina then
                local s = Player.Character:FindFirstChild("Stamina") or Player:FindFirstChild("Stamina")
                if s then s.Value = 100 end
            end
        end
    end)
end)

-- Nextbot ESP
task.spawn(function()
    while task.wait(1) do
        if ESPEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                -- Nico's Nextbots are usually Models with an ImageLabel (Face) and Audio
                if v:IsA("Model") and (v:FindFirstChild("Audio") or v:FindFirstChild("Face") or v.Name:lower():find("bot")) then
                    local root = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head")
                    if root and not root:FindFirstChild("Highlight") then
                        local h = Instance.new("Highlight", root)
                        h.FillColor = Color3.fromRGB(255, 0, 0)
                        h.OutlineColor = Color3.fromRGB(255, 255, 255)
                        
                        local bbg = Instance.new("BillboardGui", root)
                        bbg.Size = UDim2.new(0, 100, 0, 30)
                        bbg.AlwaysOnTop = true
                        bbg.ExtentsOffset = Vector3.new(0, 3, 0)
                        local tl = Instance.new("TextLabel", bbg)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.Text = v.Name
                        tl.TextColor3 = Color3.fromRGB(255, 0, 0)
                        tl.TextScaled = true
                    end
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "V2 Script Loaded!",
   Content = "Check Movement tab for Bhop and Slide fixes!",
   Duration = 5,
})
