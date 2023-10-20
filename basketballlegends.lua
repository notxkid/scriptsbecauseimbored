
-- script
getgenv().greenNumber = getgenv().greenNumber/100
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local shootConnection = nil
local loopConnection = nil
local isShootGui = false

repeat
    wait()
until game:IsLoaded() and player.Character ~= nil

local CanGreen = false

local initialVisibilityStates = {}

local function checkVisibilityChanges(guiObject)
    local currentVisibility = guiObject.Visible
    local previousVisibility = initialVisibilityStates[guiObject]

    if currentVisibility ~= previousVisibility then
        initialVisibilityStates[guiObject] = currentVisibility
        if guiObject:GetFullName():find(".Visual.Shooting") and guiObject.Visible == true then
            for i, v in pairs(guiObject:GetDescendants()) do
                if v.Name ~= "Overlay" then
                    shootConnection = v.Changed:connect(function()                    	
                    	if v.Size.Y.Scale >= getfenv().greenNumber and CanGreen == false then
                            CanGreen = true
                    	end
                    end)
                end
            end
        elseif guiObject:GetFullName():find(".Visual.Shooting") and guiObject.Visible == false then
        	CanGreen = false
            if shootConnection then
                shootConnection:Disconnect()
            end
        end
    end
end

for _, guiObject in pairs(playerGui:GetDescendants()) do
    if guiObject:IsA("GuiObject") then
        initialVisibilityStates[guiObject] = guiObject.Visible
        guiObject.Changed:Connect(
            function()
                checkVisibilityChanges(guiObject)
            end
        )
    end
end

local function onKeyPress(input)
	if input.KeyCode == getgenv().customautogreen then
		vim:SendKeyEvent(true, keytoclick, false, game)
	end
end
userInputService.InputBegan:Connect(onKeyPress)

RunService.RenderStepped:Connect(function()
	if CanGreen == true then
		vim:SendKeyEvent(false, keytoclick, false, game)
	end
end)

if getgenv().unlockfps == true then
	setfpscap(999)
end

game.StarterGui:SetCore("SendNotification", {
    Title = "xkid's legit auto-green";
    Text = "100% legit";
    Duration = "5";
})
