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

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Constants
local PART_EXPIRATION_TIME = 10

-- Objects
local tempFolder = Instance.new("Folder")
tempFolder.Name = `__{if RunService:IsServer() then "Server" else "Client"}_Temp`
tempFolder.Parent = SoundService

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
	for property, value in Sound.Defaults do
		(source :: any)[property] = value
	end
	if newProperties then
		for property, value in newProperties do
			(source :: any)[property] = value
		end
	end
	source.Parent = tempFolder
	source:Play()
	if expiration ~= false then
		task.delay(expiration or PART_EXPIRATION_TIME, source.Destroy, source)
	end
	return source
end

--- Clones, plays, and returns a Sound in a BasePart.
--- @param source -- The Sound to clone and play.
--- @param parent -- The Parent for the cloned Sound after creation.
--- @param newProperties -- A table of properties to apply to the cloned Sound.
--- @param expiration -- The time it takes before the Sound is destroyed.
--- @return Sound -- The cloned Sound.
function Sound:PlayIn(source: Sound, parent: BasePart | Attachment, newProperties: {[string]: any}?, expiration: (number | false)?): Sound
	for property, value in Sound.Defaults do
		(source :: any)[property] = value
	end
	if newProperties then
		for property, value in newProperties do
			(source :: any)[property] = value
		end
	end
	source.Parent = parent
	source:Play()
	if expiration ~= false then
		task.delay(expiration or PART_EXPIRATION_TIME, source.Destroy, source)
	end
	return source
end

--- Clones, plays, and returns a Sound at a Position in Workspace.
--- @param source -- The Sound to clone and play.
--- @param position -- The Position for the cloned Sound after creation.
--- @param newProperties -- A table of properties to apply to the cloned Sound.
--- @param expiration -- The time it takes before the Sound is destroyed.
--- @return Sound -- The cloned Sound.
function Sound:PlayAt(source: Sound, position: Vector3, newProperties: {[string]: any}?, expiration: (number | false)?): Sound
	local part = Instance.new("Part")
	part.Name = "SoundPart"
	part.Transparency = 1
	part.Locked = true
	part.Size = Vector3.new()
	part.CFrame = CFrame.new(position)
	part.CanCollide = false
	part.CanQuery = false
	part.CanTouch = false
	part.Anchored = true
	part.Parent = tempFolder
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
