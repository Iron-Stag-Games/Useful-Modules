--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local UniqueIds = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Base93 = require(script.Parent.Base93)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

export type UniqueIds = {
	GetNewId: (UniqueIds) -> (string);
	FreeId: (UniqueIds, string) -> (boolean);
	GetIdIndex: (UniqueIds, string) -> (number);
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- @ignore
function UniqueIds.new(bytes: number, b93: boolean?, idsInUse: {string}?): UniqueIds
	local unusedIds = {}
	local numUniqueIds = 0
	local numUnusedIds = 0

	if idsInUse then
		for _, id in idsInUse do
			numUniqueIds = math.max(numUniqueIds, (if b93 then Base93.B93ToInt(id) else string.unpack("I" .. bytes, id)) + 1)
		end

		for index = 1, numUniqueIds do
			local id = if b93 then Base93.IntToB93(index - 1, bytes) else string.pack("I" .. bytes, index - 1)
			if not table.find(idsInUse, id) then
				table.insert(unusedIds, id)
				numUnusedIds += 1
			end
		end
	end

	return {
		GetNewId = function(self: UniqueIds): string
			if numUnusedIds > 0 then
				local id = table.remove(unusedIds, numUnusedIds) :: string
				numUnusedIds -= 1
				return id
			else
				local id = if b93 then Base93.IntToB93(numUniqueIds, bytes) else string.pack("I" .. bytes, numUniqueIds)
				numUniqueIds += 1
				return id
			end
		end;

		FreeId = function(self: UniqueIds, id: string): boolean
			local index = self:GetIdIndex(id)
			if index + 1 <= numUniqueIds then
				table.insert(unusedIds, id)
				numUnusedIds += 1
				return true
			end
			return false
		end;

		GetIdIndex = function(self: UniqueIds, id: string): number
			return if b93 then Base93.B93ToInt(id) else string.unpack("I" .. bytes, id)
		end;
	}
end

--- Returns the index of a unique ID string.
--- @param bytes -- The length of the string.
--- @param id -- The unique ID string.
--- @param b93 -- Whether or not to use the Base93 format.
--- @return number -- The index of the unique ID string.
function UniqueIds:GetIdIndex(bytes: number, id: string, b93: boolean?): number
	return if b93 then Base93.B93ToInt(id) else string.unpack("I" .. bytes, id)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return UniqueIds
