local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
   Name = "the premium hotel",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "The hackers premium suite",
   LoadingSubtitle = "by revexire",
   Theme = "AmberGlow", -- Check https://docs.sirius.menu/rayfield/configuration/themes
 
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
 
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "The hub"
    }
})
Rayfield:Notify({
   Title = "Your in",
   Content = "Welcome pureblood",
   Duration = 6.5,
   Image = 4483362458,
})

local Tab = Window:CreateTab("Players Butler", "Pause")
local Slider = Tab:CreateSlider({
   Name = "Speed boot setting",
   Range = {1, 100},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      game.Players.LocalPlayer.Character:SetAttribute("SpeedMultiplier", Value)
   end,
})
local Slider = Tab:CreateSlider({
   Name = "Dash Trainer",
   Range = {10, 1000},
   Increment = 5,
   Suffix = "Distance",
   CurrentValue = 50,
   Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      game.Players.LocalPlayer.Character:SetAttribute("DashLength", Value)
   end,
})
local Toggle = Tab:CreateToggle({
   Name = "Instant teleport",
   CurrentValue = false,
   Flag = "Toggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
		game.Players.LocalPlayer.Character:SetAttribute("FlashstepCooldown", 1)
   end,
})
local Toggle = Tab:CreateToggle({
   Name = "Insta punch",
   CurrentValue = false,
   Flag = "Toggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      game.Players.LocalPlayer.Character:SetAttribute("MeleeCooldown", 1)
      game.Players.LocalPlayer.Character:SetAttribute("SwordCooldown", 1)
      game.Players.LocalPlayer.Character:SetAttribute("GunCooldown", 1)
      game.Players.LocalPlayer.Character:SetAttribute("FruitCooldown", 1)
   end,
})

local Button = Tab:CreateButton({
    Name = "The Npc bringer",
    CurrentValue = false,
    Flag = "NpcB", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
    Callback = function(Value)
      -- Services
      local Players = game:GetService("Players")
      local Workspace = game:GetService("Workspace")

      -- Variables
      local player = Players.LocalPlayer
      local enemiesFolder = Workspace:FindFirstChild("Enemies") -- Folder containing enemies
      local radius = 2000 -- Radius within which enemies are teleported

      -- Function to teleport enemies to the player
      local function teleportEnemiesToPlayer()
         local playerRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart") -- Player's root part

         if not playerRoot then
            warn("Player's HumanoidRootPart is missing.")
            return
         end

         if not enemiesFolder then
            warn("Enemies folder not found in Workspace.")
            return
         end

         for _, enemy in pairs(enemiesFolder:GetChildren()) do
            -- Check if the enemy has a humanoid and root part, and exclude bosses with IsBoss attribute
            local humanoid = enemy:FindFirstChild("Humanoid")
            local rootPart = enemy:FindFirstChild("HumanoidRootPart")
            local isBoss = enemy:GetAttribute("IsBoss") -- Check for IsBoss attribute

            if humanoid and rootPart and not isBoss then
                  -- Calculate distance between the player and the enemy
                  local distance = (playerRoot.Position - rootPart.Position).Magnitude

                  if distance <= radius then
                     -- Teleport the enemy to the player's position with a slight offset
                     rootPart.CFrame = playerRoot.CFrame * CFrame.new(math.random(-3, 3), 0, math.random(-3, 3))
                     print("Teleported enemy:", enemy.Name)
                  end
            end
         end
      end
      teleportEnemiesToPlayer()

   end,
})
local Button = Tab:CreateButton({
   Name = "Goto closest person",
   Callback = function()
   -- Services
	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")

	-- Variables
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:WaitForChild("HumanoidRootPart") -- LocalPlayer's RootPart
	local speed = 250 -- Speed in studs per second

	-- Function to find the closest player
	local function getClosestPlayer()
		local closestPlayer = nil
		local shortestDistance = math.huge

		for _, otherPlayer in pairs(Players:GetPlayers()) do
			if otherPlayer ~= player and otherPlayer.Character then
				local otherRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
				if otherRootPart then
					local distance = (rootPart.Position - otherRootPart.Position).Magnitude
					if distance < shortestDistance then
						closestPlayer = otherRootPart
						shortestDistance = distance
					end
				end
			end
		end

		return closestPlayer, shortestDistance
	end

	-- Function to tween to the closest player
	local function tweenToClosestPlayer()
		local targetPart, distance = getClosestPlayer()
		if not targetPart then
			warn("No valid target found!")
			return
		end

		local duration = distance / speed -- Calculate time based on speed

		-- Tween information
		local tweenInfo = TweenInfo.new(
			duration, -- Time to complete the tween
			Enum.EasingStyle.Linear -- Linear movement for constant speed
		)

		-- Goal position
		local goal = {CFrame = targetPart.CFrame}

		-- Create and play the tween
		local tween = TweenService:Create(rootPart, tweenInfo, goal)
		tween:Play()

		-- Wait for the tween to complete
		tween.Completed:Wait()
		print("Reached closest player!")
	end

	-- Execute the tweening function
	tweenToClosestPlayer()

   end,
})
local Keybind = PlayerTab:CreateKeybind({
   Name = "Buddha Hitbox",
   CurrentKeybind = "P",
   HoldToInteract = false,
   Flag = "Keybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
      local lHand = game.Players.LocalPlayer.Character.LeftHand
      local rHand = game.Players.LocalPlayer.Character.RightHand
      lHand.Size = Vector3.new(100,100,100)
      rHand.Size = Vector3.new(100,100,100)
      lHand.Transparency = 1
      rHand.Transparency = 1
      lHand.CanTouch = false
      rHand.CanTouch = false
   end,
})

local Keybind = PlayerTab:CreateKeybind({
   Name = "Bring Enemies",
   CurrentKeybind = "N",
   HoldToInteract = false,
   Flag = "Keybind2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
      local humRP = game.Players.LocalPlayer.Character.HumanoidRootPart
      for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
         if enemy:FindFirstChild("HumanoidRootPart") then
            enemy.HumanoidRootPart.CFrame = humRP.CFrame
            enemy.Humanoid.WalkSpeed = 0
         end
      end
   end,
})
