--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

--- @todo
return function(func: (...any) -> (...any), ...: any): ...any
	local args = {...}
	local result: {any}?;
	local thread = task.spawn(function(): ()
		result = {func(table.unpack(args))}
	end)
	if coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
		error("Function cannot yield", 0)
	end
	if result then
		return table.unpack(result)
	end
	return nil
end
