--!strict
--!optimize 2
--!native
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local FunctionScheduler = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local RunService = game:GetService("RunService")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Types
type Func = (...any) -> (...any)
export type ScheduledFunc = {Func: Func, Args: {any}, Delay: number, Once: boolean, LastRan: number}

-- Defines
local scheduledFuncs: {ScheduledFunc} = {}
local callsPerSecond = 0

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function updateCallsPerSecond(): ()
	callsPerSecond = 0
	for _, scheduledFunc in scheduledFuncs do
		callsPerSecond += 1 / scheduledFunc.Delay
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- @todo
function FunctionScheduler:AddOnce(delay: number, func: Func, ...: any): ScheduledFunc
	local scheduledFunc: ScheduledFunc = {Func = func, Args = {...}, Delay = delay, Once = true, LastRan = 0}
	table.insert(scheduledFuncs, scheduledFunc)
	updateCallsPerSecond()

	return scheduledFunc
end

--- @todo
function FunctionScheduler:AddWithFrequency(frequencyHz: number, func: Func, ...: any): ScheduledFunc
	local scheduledFunc: ScheduledFunc = {Func = func, Args = {...}, Delay = 1 / frequencyHz, Once = false, LastRan = 0}
	table.insert(scheduledFuncs, scheduledFunc)
	updateCallsPerSecond()

	return scheduledFunc
end

--- @todo
function FunctionScheduler:Remove(scheduledFunc: ScheduledFunc): ()
	local index = table.find(scheduledFuncs, scheduledFunc)
	if index then
		table.remove(scheduledFuncs, index)
		updateCallsPerSecond()
	end
end

--- @ignore
function FunctionScheduler:Init(): ()
	local stepEvent: RBXScriptSignal = if RunService:IsClient() then RunService.RenderStepped else RunService.Heartbeat

	stepEvent:Connect(function(dt: number): ()
		if #scheduledFuncs == 0 then return end
		
		local currentTime = os.clock()
		local hz = 1 / dt
		local maxCallsPerFrame = math.ceil(callsPerSecond / hz)

		for _ = 1, maxCallsPerFrame do
			local removeOffset = 0
			for index, scheduledFunc in scheduledFuncs do
				if scheduledFunc.LastRan + scheduledFunc.Delay > currentTime then continue end

				scheduledFunc.LastRan = currentTime
				task.spawn(scheduledFunc.Func, table.unpack(scheduledFunc.Args))

				if scheduledFunc.Once then
					table.remove(scheduledFuncs, index - removeOffset)
					removeOffset += 1
				end

				break
			end
		end

		table.sort(scheduledFuncs, function(a: ScheduledFunc, b: ScheduledFunc)
			return a.LastRan + a.Delay < b.LastRan + b.Delay
		end)
	end)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return FunctionScheduler
