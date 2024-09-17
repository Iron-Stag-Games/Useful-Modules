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
function Math.Damp(source: number, smoothing: number, dt: number): number
    return source * smoothing ^ dt
end

--- @todo
function Math.DampVector2(source: Vector2, smoothing: number, dt: number): Vector2
    return source * smoothing ^ dt
end

--- @todo
function Math.DampVector3(source: Vector3, smoothing: number, dt: number): Vector3
    return source * smoothing ^ dt
end

--- @todo
function Math.DampTo(source: number, target: number, smoothing: number, dt: number): number
    return Math.Lerp(source, target, 1 - smoothing ^ dt)
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
