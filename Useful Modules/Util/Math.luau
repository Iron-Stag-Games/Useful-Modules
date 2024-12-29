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
function Math.Lerp(a: number, b: number, alpha: number): number
	return a + (b - a) * alpha
end

--- @todo
function Math.InverseLerp(a: number, b: number, alpha: number): number
	return (alpha - a) / (b - a)
end

--- @todo
function Math.Damp(value: number, smoothing: number, dt: number): number
	return value * smoothing ^ dt
end

--- @todo
function Math.DampInverse(value: number, smoothing: number, dt: number): number
	return value * (1 - smoothing ^ dt)
end

--- @todo
function Math.DampTo(a: number, b: number, smoothing: number, dt: number): number
	return Math.Lerp(a, b, 1 - smoothing ^ dt)
end

--- @todo
function Math.DampVector2(value: Vector2, smoothing: number, dt: number): Vector2
	return value * smoothing ^ dt
end

--- @todo
function Math.DampVector2Inverse(value: Vector2, smoothing: number, dt: number): Vector2
	return value * (1 - smoothing ^ dt)
end

--- @todo
function Math.DampVector2To(a: Vector2, b: Vector2, smoothing: number, dt: number): Vector2
	return a:Lerp(b, 1 - smoothing ^ dt)
end

--- @todo
function Math.DampVector3(value: Vector3, smoothing: number, dt: number): Vector3
	return value * smoothing ^ dt
end

--- @todo
function Math.DampVector3Inverse(value: Vector3, smoothing: number, dt: number): Vector3
	return value * (1 - smoothing ^ dt)
end

--- @todo
function Math.DampVector3To(a: Vector3, b: Vector3, smoothing: number, dt: number): Vector3
	return a:Lerp(b, 1 - smoothing ^ dt)
end

--- @todo
function Math.IsReal(value: number): boolean
	return value * 0 ~= 0
end

--- @todo
function Math.Vector3ToTable(vector: Vector3): {X: number, Y: number, Z: number}
	return {X = vector.X, Y = vector.Y, Z = vector.Z}
end

--- @todo
function Math.TableToVector3(t: {X: number, Y: number, Z: number}): Vector3
	return Vector3.new(t.X, t.Y, t.Z)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Math
