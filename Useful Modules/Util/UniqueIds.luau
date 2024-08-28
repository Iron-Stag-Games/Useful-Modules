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
	GetNewId: (UniqueIds) -> string;
	FreeId: (UniqueIds, string) -> ();
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
			numUniqueIds = math.max(numUniqueIds, UniqueIds:GetIndexFromId(bytes, id, b93) + 1)
		end

		for index = 1, numUniqueIds do
			local id = UniqueIds:GetIdFromIndex(bytes, index - 1, b93)
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
				local id = UniqueIds:GetIdFromIndex(bytes, numUniqueIds, b93)
				numUniqueIds += 1
				return id
			end
		end;

		FreeId = function(self: UniqueIds, id: string): ()
			local index = UniqueIds:GetIndexFromId(bytes, id, b93)
			assert(index < numUniqueIds and not table.find(unusedIds, id), "ID not in use")
			table.insert(unusedIds, id)
			numUnusedIds += 1
		end;
	}
end

--- Returns the index of a unique ID string.
--- @param bytes -- The length of the string.
--- @param id -- The unique ID string.
--- @param b93 -- Whether or not to use the Base93 format.
--- @return number -- The index of the unique ID string.
function UniqueIds:GetIndexFromId(bytes: number, id: string, b93: boolean?): number
	return if b93 then Base93.B93ToInt(id) else string.unpack("I" .. bytes, id)
end

--- Returns the unique ID string of an index.
--- @param bytes -- The length of the string.
--- @param index -- The index of the unique ID string.
--- @param b93 -- Whether or not to use the Base93 format.
--- @return string -- The unique ID string.
function UniqueIds:GetIdFromIndex(bytes: number, index: number, b93: boolean?): string
	return if b93 then Base93.IntToB93(index, bytes) else string.pack("I" .. bytes, index)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return UniqueIds
