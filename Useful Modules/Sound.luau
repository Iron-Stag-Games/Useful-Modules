--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local Sound = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Services
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

-- Core
local New = require(script.Parent.Parent.Pronghorn.New)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Constants
local PART_EXPIRATION_TIME = 10

-- Objects
local tempFolder = New.Instance("Folder", SoundService, `__{if RunService:IsServer() then "Server" else "Client"}_Temp`)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Sound.Defaults = {} :: {[string]: any}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Clones, plays, and returns a Sound.
--- @param source -- The Sound to clone and play.
--- @param newProperties -- A table of properties to apply to the cloned Sound.
--- @param expiration -- The time it takes before the Sound is destroyed.
--- @return Sound -- The cloned Sound.
function Sound:Play2D(source: Sound, newProperties: {[string]: any}?, expiration: (number | false)?): Sound
	local newSound = source:Clone()
	for property, value in Sound.Defaults do
		(newSound :: any)[property] = value
	end
	if newProperties then
		for property, value in newProperties do
			(newSound :: any)[property] = value
		end
	end
	newSound.Parent = tempFolder
	newSound:Play()
	if expiration ~= false then
		task.delay(expiration or PART_EXPIRATION_TIME, newSound.Destroy, newSound)
	end
	return newSound
end

--- Clones, plays, and returns a Sound in a BasePart.
--- @param source -- The Sound to clone and play.
--- @param parent -- The Parent for the cloned Sound after creation.
--- @param newProperties -- A table of properties to apply to the cloned Sound.
--- @param expiration -- The time it takes before the Sound is destroyed.
--- @return Sound -- The cloned Sound.
function Sound:PlayIn(source: Sound, parent: BasePart | Attachment, newProperties: {[string]: any}?, expiration: (number | false)?): Sound
	local newSound = source:Clone()
	for property, value in Sound.Defaults do
		(newSound :: any)[property] = value
	end
	if newProperties then
		for property, value in newProperties do
			(newSound :: any)[property] = value
		end
	end
	newSound.Parent = parent
	newSound:Play()
	if expiration ~= false then
		task.delay(expiration or PART_EXPIRATION_TIME, newSound.Destroy, newSound)
	end
	return newSound
end

--- Clones, plays, and returns a Sound at a Position in Workspace.
--- @param source -- The Sound to clone and play.
--- @param position -- The Position for the cloned Sound after creation.
--- @param newProperties -- A table of properties to apply to the cloned Sound.
--- @param expiration -- The time it takes before the Sound is destroyed.
--- @return Sound -- The cloned Sound.
function Sound:PlayAt(source: Sound, position: Vector3, newProperties: {[string]: any}?, expiration: (number | false)?): Sound
	local part = New.Instance("Part", tempFolder, "SoundPart", {
		Transparency = 1;
		Locked = true;
		Size = Vector3.new();
		CFrame = CFrame.new(position);
		CanCollide = false;
		CanQuery = false;
		CanTouch = false;
		Anchored = true;
	})
	if expiration ~= false then
		task.delay(expiration or PART_EXPIRATION_TIME, part.Destroy, part)
	end
	return Sound:PlayIn(source, part, newProperties)
end

--- @ignore
function Sound:Init(): ()
	for _, object in SoundService.Master:GetChildren() do
		if type(Sound[object.Name]) == "function" then error(`Indexing '{object.Name}' would overwrite a function`) end
		Sound[object.Name] = object
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Sound
