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
	local errorMsg: string?
	local thread = task.spawn(xpcall, function(): ()
		result = {func(table.unpack(args))}
	end, function(err: string): ()
		errorMsg = err
	end)
	if errorMsg then
		error(errorMsg, 0)
	end
	if coroutine.status(thread) ~= "dead" then
		task.cancel(thread)
		error("Function cannot yield", 0)
	end
	if result then
		return table.unpack(result)
	end
	return nil
end
