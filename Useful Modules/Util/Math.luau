--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local Math = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- @todo
function Math.InverseLerp(a: number, b: number, value: number): number
	return (value - a) / (b - a)
end

--- @todo
function Math.IsReal(...: number): boolean
	for _, num in {...} do
		if num * 0 ~= 0 then
			return false
		end
	end
	return true
end

--- @todo
function Math.TableToVector3(t: {X: number, Y: number, Z: number}): Vector3
	return Vector3.new(t.X, t.Y, t.Z)
end

--- @todo
function Math.Vector3ToTable(vector: Vector3): {X: number, Y: number, Z: number}
	return {X = vector.X, Y = vector.Y, Z = vector.Z}
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Math
