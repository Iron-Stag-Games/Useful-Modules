--!strict
--!optimize 2
--!native
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local SpatialCheck = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local PART_POINTS: {[Enum.PartType]: {Vector3}?} = {
	[Enum.PartType.Block] = {
		Vector3.new(0.5, 0.5, 0.5);
		Vector3.new(0.5, 0.5, -0.5);
		Vector3.new(0.5, -0.5, 0.5);
		Vector3.new(0.5, -0.5, -0.5);
		Vector3.new(-0.5, 0.5, 0.5);
		Vector3.new(-0.5, 0.5, -0.5);
		Vector3.new(-0.5, -0.5, 0.5);
		Vector3.new(-0.5, -0.5, -0.5);
	};
	[Enum.PartType.CornerWedge] = {
		Vector3.new(0.5, 0.5, -0.5);
		Vector3.new(0.5, -0.5, 0.5);
		Vector3.new(0.5, -0.5, -0.5);
		Vector3.new(-0.5, -0.5, 0.5);
		Vector3.new(-0.5, -0.5, -0.5);
	};
	[Enum.PartType.Wedge] = {
		Vector3.new(0.5, 0.5, 0.5);
		Vector3.new(0.5, -0.5, 0.5);
		Vector3.new(0.5, -0.5, -0.5);
		Vector3.new(-0.5, 0.5, 0.5);
		Vector3.new(-0.5, -0.5, 0.5);
		Vector3.new(-0.5, -0.5, -0.5);
	};
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function pointsFromPartIterator(part: BasePart): () -> Vector3?
	assert(part, "Part cannot be nil")

	local points = if part:IsA("Part") then assert(PART_POINTS[part.Shape], `PartType.{part.Shape} is unimplemented`) else assert(PART_POINTS[Enum.PartType.Block])
	local partSize = part.Size
	local pointIndex = 0

	return function(): Vector3?
		pointIndex += 1
		local point = points[pointIndex]
		return if point then (part.CFrame * CFrame.new(point * partSize)).Position else nil
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Threshold

--- @todo
function SpatialCheck.PointInThreshold(point: Vector3, cFrame: CFrame): boolean
	return cFrame:PointToObjectSpace(point).Z <= 0
end

--- @todo
function SpatialCheck.SphereInThreshold(sphereCenter: Vector3, sphereRadius: number, cFrame: CFrame): boolean
	return SpatialCheck.PointInThreshold(sphereCenter, cFrame * CFrame.new(0, 0, -sphereRadius))
end

--- @todo
function SpatialCheck.PartInThreshold(part: BasePart, cFrame: CFrame): boolean
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball then
		local sphereCenter = part.CFrame.Position
		local sphereRadius = math.min(part.Size.X, part.Size.Y, part.Size.Z) / 2

		return SpatialCheck.SphereInThreshold(sphereCenter, sphereRadius, cFrame)

	else
		for point in pointsFromPartIterator(part) do
			if not SpatialCheck.PointInThreshold(point, cFrame) then
				return false
			end
		end

		return true
	end
end

-- Sphere

--- @todo
function SpatialCheck.PointInSphere(point: Vector3, spherePosition: Vector3, sphereRadius: number): boolean
	return (point - spherePosition).Magnitude <= sphereRadius
end

--- @todo
function SpatialCheck.SphereInSphere(innerSphereCenter: Vector3, innerSphereRadius: number, outerSphereCenter: Vector3, outerSphereRadius: number): boolean
	return SpatialCheck.PointInSphere(innerSphereCenter, outerSphereCenter, outerSphereRadius - innerSphereRadius)
end

--- @todo
function SpatialCheck.PartInSphere(part: BasePart, spherePosition: Vector3, sphereRadius: number): boolean
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball then
		local innerSphereCenter = part.CFrame.Position
		local innerSphereRadius = math.min(part.Size.X, part.Size.Y, part.Size.Z) / 2

		return SpatialCheck.SphereInSphere(innerSphereCenter, innerSphereRadius, spherePosition, sphereRadius)

	else
		for point in pointsFromPartIterator(part) do
			if not SpatialCheck.PointInSphere(point, spherePosition, sphereRadius) then
				return false
			end
		end

		return true
	end
end

-- Box

--- @todo
function SpatialCheck.PointInBox(point: Vector3, boxCFrame: CFrame, boxSize: Vector3): boolean
	local objectSpacePoint = boxCFrame:PointToObjectSpace(point)
	boxSize /= 2

    return objectSpacePoint.X >= - boxSize.X
        and objectSpacePoint.X <= boxSize.X
        and objectSpacePoint.Y >= - boxSize.Y
        and objectSpacePoint.Y <= boxSize.Y
        and objectSpacePoint.Z >= - boxSize.Z
        and objectSpacePoint.Z <= boxSize.Z
end

--- @todo
function SpatialCheck.SphereInBox(sphereCenter: Vector3, sphereRadius: number, boxCFrame: CFrame, boxSize: Vector3): boolean
	return SpatialCheck.PointInBox(sphereCenter, boxCFrame, boxSize - Vector3.one * sphereRadius * 2)
end

--- @todo
function SpatialCheck.PartInBox(part: BasePart, boxCFrame: CFrame, boxSize: Vector3): boolean
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball then
		local sphereCenter = part.CFrame.Position
		local sphereRadius = math.min(part.Size.X, part.Size.Y, part.Size.Z) / 2

		return SpatialCheck.SphereInBox(sphereCenter, sphereRadius, boxCFrame, boxSize)

	else
		for point in pointsFromPartIterator(part) do
			if not SpatialCheck.PointInBox(point, boxCFrame, boxSize) then
				return false
			end
		end

		return true
	end
end

-- Cylinder

--- @todo
function SpatialCheck.PointInCylinder(point: Vector3, cylinderCFrame: CFrame, cylinderLength: number, cylinderRadius: number): boolean
	local cylinderPosition = cylinderCFrame.Position
	local cylinderDir = cylinderCFrame.LookVector
	local pointDist = (point - cylinderPosition):Dot(cylinderDir)

	if pointDist < 0 or pointDist > cylinderLength then
		return false
	end

	local orthDistance = ((point - cylinderPosition) - cylinderDir * pointDist).Magnitude

	return orthDistance <= cylinderRadius
end

--- @todo
function SpatialCheck.SphereInCylinder(sphereCenter: Vector3, sphereRadius: number, cylinderCFrame: CFrame, cylinderLength: number, cylinderRadius: number): boolean
	return SpatialCheck.PointInCylinder(sphereCenter, cylinderCFrame * CFrame.new(0, 0, -sphereRadius), cylinderLength - sphereRadius * 2, cylinderRadius - sphereRadius)
end

--- @todo
function SpatialCheck.PartInCylinder(part: BasePart, cylinderCFrame: CFrame, cylinderLength: number, cylinderRadius: number): boolean
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball then
		local sphereCenter = part.CFrame.Position
		local sphereRadius = math.min(part.Size.X, part.Size.Y, part.Size.Z) / 2

		return SpatialCheck.SphereInCylinder(sphereCenter, sphereRadius, cylinderCFrame, cylinderLength, cylinderRadius)

	else
		for point in pointsFromPartIterator(part) do
			if not SpatialCheck.PointInCylinder(point, cylinderCFrame, cylinderLength, cylinderRadius) then
				return false
			end
		end

		return true
	end
end

-- Cone

--- @todo
function SpatialCheck.PointInCone(point: Vector3, coneOriginCFrame: CFrame, coneLength: number, coneAngle: number): boolean
	if coneLength <= 0 or coneAngle <= 0 or coneAngle >= math.pi then return false end

	local coneRadius = coneLength * math.tan(coneAngle)
	local conePosition = coneOriginCFrame.Position
	local coneDir = coneOriginCFrame.LookVector
	local pointDist = (point - conePosition):Dot(coneDir)

	if pointDist < 0 or pointDist > coneLength then
		return false
	end

	local sectionRadius = (pointDist / coneLength) * coneRadius
	local orthDistance = ((point - conePosition) - coneDir * pointDist).Magnitude

	return orthDistance <= sectionRadius
end

--- @todo
function SpatialCheck.SphereInCone(sphereCenter: Vector3, sphereRadius: number, coneOriginCFrame: CFrame, coneLength: number, coneAngle: number): boolean
	local coneRadius = coneLength * math.tan(coneAngle) - sphereRadius
	local offset = coneLength - coneRadius * math.sin(coneAngle)
	return SpatialCheck.PointInCone(sphereCenter, coneOriginCFrame * CFrame.new(0, 0, -offset), coneLength - offset - sphereRadius, coneAngle)
end

--- @todo
function SpatialCheck.PartInCone(part: BasePart, coneOriginCFrame: CFrame, coneLength: number, coneAngle: number): boolean
	if part:IsA("Part") and part.Shape == Enum.PartType.Ball then
		local sphereCenter = part.CFrame.Position
		local sphereRadius = math.min(part.Size.X, part.Size.Y, part.Size.Z) / 2

		return SpatialCheck.SphereInCone(sphereCenter, sphereRadius, coneOriginCFrame, coneLength, coneAngle)

	else
		for point in pointsFromPartIterator(part) do
			if not SpatialCheck.PointInCone(point, coneOriginCFrame, coneLength, coneAngle) then
				return false
			end
		end

		return true
	end
end

-- Capsule

--- @todo
function SpatialCheck.PointInCapsule(point: Vector3, capsuleCFrame: CFrame, capsuleLength: number, capsuleRadius: number): boolean
	return
		SpatialCheck.PointInSphere(point, capsuleCFrame.Position, capsuleRadius)
		or SpatialCheck.PointInSphere(point, (capsuleCFrame * CFrame.new(0, 0, -capsuleLength)).Position, capsuleRadius)
		or SpatialCheck.PointInCylinder(point, capsuleCFrame, capsuleLength, capsuleRadius)
end

--- @todo
function SpatialCheck.SphereInCapsule(sphereCenter: Vector3, sphereRadius: number, capsuleCFrame: CFrame, capsuleLength: number, capsuleRadius: number): boolean
	return
		SpatialCheck.SphereInSphere(sphereCenter, sphereRadius, capsuleCFrame.Position, capsuleRadius)
		or SpatialCheck.SphereInSphere(sphereCenter, sphereRadius, (capsuleCFrame * CFrame.new(0, 0, -capsuleLength)).Position, capsuleRadius)
		or SpatialCheck.SphereInCylinder(sphereCenter, sphereRadius, capsuleCFrame, capsuleLength, capsuleRadius)
end

--- @todo
function SpatialCheck.PartInCapsule(part: BasePart, capsuleCFrame: CFrame, capsuleLength: number, capsuleRadius: number): boolean
	return
		SpatialCheck.PartInSphere(part, capsuleCFrame.Position, capsuleRadius)
		or SpatialCheck.PartInSphere(part, (capsuleCFrame * CFrame.new(0, 0, -capsuleLength)).Position, capsuleRadius)
		or SpatialCheck.PartInCylinder(part, capsuleCFrame, capsuleLength, capsuleRadius)
end

-- Spherical Sector

--- @todo
function SpatialCheck.PointInSphericalSector(point: Vector3, sectorCFrame: CFrame, sectorRadius: number, sectorAngle: number): boolean
	return
		SpatialCheck.PointInSphere(point, sectorCFrame.Position, sectorRadius)
		and SpatialCheck.PointInCone(point, sectorCFrame, sectorRadius, sectorAngle)
end

--- @todo
function SpatialCheck.SphereInSphericalSector(sphereCenter: Vector3, sphereRadius: number, sectorCFrame: CFrame, sectorRadius: number, sectorAngle: number): boolean
	return
		SpatialCheck.SphereInSphere(sphereCenter, sphereRadius, sectorCFrame.Position, sectorRadius)
		and SpatialCheck.SphereInCone(sphereCenter, sphereRadius, sectorCFrame, sectorRadius, sectorAngle)
end

--- @todo
function SpatialCheck.PartInSphericalSector(part: BasePart, sectorCFrame: CFrame, sectorRadius: number, sectorAngle: number): boolean
	return
		SpatialCheck.PartInSphere(part, sectorCFrame.Position, sectorRadius)
		and SpatialCheck.PartInCone(part, sectorCFrame, sectorRadius, sectorAngle)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return SpatialCheck
