-- Function to get environment and check for existing script instance
function getenv()
    local player = game:GetService("Players").LocalPlayer
    local existingScript = player:FindFirstChild("SprintScript")
    local existingGui = player:FindFirstChild("SprintGui")
 
    if existingScript then
        existingScript:Destroy()
    end
 
    if existingGui then
        existingGui:Destroy()
    end
end
 
-- Call the function to check and destroy old script and UI
getenv()
 
-- Create the new script instance and name it
local newScript = Instance.new("LocalScript")
newScript.Name = "SprintScript"
newScript.Parent = game:GetService("Players").LocalPlayer
 
-- Create the UI elements
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SprintGui"
local sprintButton = Instance.new("TextButton")
local dragButton = Instance.new("TextButton")
local staminaBox = Instance.new("Frame")
local staminaBar = Instance.new("Frame")
local staminaDragButton = Instance.new("TextButton")
local uiCorner = Instance.new("UICorner")
local dragCorner = Instance.new("UICorner")
local staminaBoxCorner = Instance.new("UICorner")
local staminaBarCorner = Instance.new("UICorner")
local staminaDragCorner = Instance.new("UICorner")
 
-- Set up the ScreenGui
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
 
-- Set up the Sprint Button
sprintButton.Size = UDim2.new(0, 300, 0, 60)  -- Increased width
sprintButton.Position = UDim2.new(0.5, -150, 0.5, -30)  -- Center of the screen
sprintButton.Text = "Sprint"
sprintButton.Parent = screenGui
 
-- Ensure the button is responsive for both PC and mobile
sprintButton.SizeConstraint = Enum.SizeConstraint.RelativeXX
sprintButton.Size = UDim2.new(0.15, 0, 0.05, 0)  -- Adjusted size
 
-- Apply professional UI styling
sprintButton.BackgroundColor3 = Color3.fromRGB(30, 144, 255)  -- Dodger blue background
sprintButton.TextColor3 = Color3.fromRGB(255, 255, 255)  -- White text
sprintButton.Font = Enum.Font.LuckiestGuy
sprintButton.TextSize = 24
 
-- Make the button rounded
uiCorner.CornerRadius = UDim.new(0.5, 0)  -- Rounded corners
uiCorner.Parent = sprintButton
 
-- Set up the Drag Button
dragButton.Size = UDim2.new(0, 30, 0, 30)
dragButton.Position = UDim2.new(1, -40, 1, -40)  -- Bottom-right corner of the Sprint button with padding
dragButton.Text = ""
dragButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red background
dragButton.Parent = sprintButton
 
-- Make the drag button rounded
dragCorner.CornerRadius = UDim.new(0.5, 0)  -- Rounded corners
dragCorner.Parent = dragButton
 
-- Set up the Stamina Box
staminaBox.Size = UDim2.new(0, 300, 0, 50)  -- Big box for stamina
staminaBox.Position = UDim2.new(0.5, -150, 0.4, -25)  -- Center of the screen
staminaBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)  -- Dark gray background
staminaBox.Parent = screenGui
 
-- Make the stamina box rounded
staminaBoxCorner.CornerRadius = UDim.new(0.2, 0)  -- Rounded corners
staminaBoxCorner.Parent = staminaBox
 
-- Set up the Stamina Bar
staminaBar.Size = UDim2.new(1, 0, 1, 0)  -- Full size initially
staminaBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green background
staminaBar.Parent = staminaBox
 
-- Make the stamina bar rounded
staminaBarCorner.CornerRadius = UDim.new(0.2, 0)  -- Rounded corners
staminaBarCorner.Parent = staminaBar
 
-- Set up the Stamina Drag Button
staminaDragButton.Size = UDim2.new(0, 30, 0, 30)
staminaDragButton.Position = UDim2.new(1, -40, 1, -40)  -- Bottom-right corner of the Stamina box with padding
staminaDragButton.Text = ""
staminaDragButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red background
staminaDragButton.Parent = staminaBox
 
-- Make the stamina drag button rounded
staminaDragCorner.CornerRadius = UDim.new(0.5, 0)  -- Rounded corners
staminaDragCorner.Parent = staminaDragButton
 
-- Function to set speed while sprint button is held or left shift is held
local userInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = game.Workspace.CurrentCamera
local normalWalkSpeed = humanoid.WalkSpeed
local sprintSpeed = 24
local normalFOV = camera.FieldOfView
local sprintFOV = normalFOV + 20
local stamina = 100
local maxStamina = 100
local isSprinting = false
 
local function startSprinting()
    if stamina > 0 then
        humanoid.WalkSpeed = sprintSpeed
        camera.FieldOfView = sprintFOV
        isSprinting = true
    end
end
 
local function stopSprinting()
    humanoid.WalkSpeed = normalWalkSpeed
    camera.FieldOfView = normalFOV
    isSprinting = false
end
 
-- Handle sprint button press and release
sprintButton.MouseButton1Down:Connect(startSprinting)
sprintButton.MouseButton1Up:Connect(stopSprinting)
 
-- Handle left shift key press and release
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        startSprinting()
    end
end)
 
userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift then
        stopSprinting()
    end
end)
 
-- Ensure sprint stops when the player dies or respawns
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    stopSprinting()
end)
 
-- Stamina logic
game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
    if isSprinting and stamina > 0 then
        stamina = stamina - 40 * deltaTime  -- Decrease stamina while sprinting
        if stamina <= 0 then
            stopSprinting()
            stamina = 0
        end
    elseif not isSprinting and stamina < maxStamina then
        stamina = stamina + 20 * deltaTime  -- Regenerate stamina when not sprinting
        if stamina > maxStamina then
            stamina = maxStamina
        end
    end
    staminaBar.Size = UDim2.new(stamina / maxStamina, 0, 1, 0)  -- Update stamina bar size
end)
 
-- Handle dragging of the sprint button
local function setupDrag(dragButton, target)
    local dragging = false
    local dragInput, mousePos, framePos
 
    local function update(input)
        local delta = input.Position - mousePos
        target.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
 
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = target.Position
 
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
 
    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
 
    userInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end
 
setupDrag(dragButton, sprintButton)
setupDrag(staminaDragButton, staminaBox)
 
