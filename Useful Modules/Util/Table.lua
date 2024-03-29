--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local Table = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Copies and returns a Table and all of its descendants.
--- @param tableToCopy -- The Table to copy.
--- @return {[any]: any} -- The copied Table.
function Table.DeepCopy(tableToCopy: {[any]: any}): {[any]: any}
	local copy = {}
	for key, value in tableToCopy do
		copy[key] = if type(value) == "table" then Table.DeepCopy(value) else value
	end
	return copy
end

--- Returns the number of keys in a Table.
--- @param tab -- The Table to measure.
--- @return number -- The number of keys in the Table.
function Table.SizeOf(tab: {[any]: any}): number
	local size = 0
	for _ in tab do
		size += 1
	end
	return size
end

--- Returns the combined values of a series of Tables.
--- @param ... -- The Tables to combine.
--- @return {[any]: any} -- The combined Table.
function Table.Combine(...: {[any]: any}): {[any]: any}
	local combined = {}
	for _, tab in {...} do
		for _, item in tab do
			table.insert(combined, item)
		end
	end
	return combined
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Table
