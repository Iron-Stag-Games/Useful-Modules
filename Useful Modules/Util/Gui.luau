--!strict
--[[
╔═══════════════════════════════════════════════╗
║      Compatible With Pronghorn Framework      ║
║  https://iron-stag-games.github.io/Pronghorn  ║
╚═══════════════════════════════════════════════╝
]]

local Gui = {}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Dependencies
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local New = require(script.Parent.Parent.Parent.Pronghorn.New)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Module Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- @todo
function Gui.IsVisible(guiObject: GuiObject): boolean
	local parent: Instance? = guiObject

	while parent do
		if parent:IsA("GuiObject") and not parent.Visible then
			return false
		elseif parent:IsA("LayerCollector") and parent.Enabled then
			return true
		end

		parent = parent.Parent
	end

	return false
end

--- @todo
function Gui.GetVisibilityChangedSignal(guiObject: GuiObject): New.Event<boolean>
	--[[local event = New.Event() :: New.Event<boolean>

	guiObject.AncestryChanged:Connect(function(): ()
		
	end)

	return event]]
	error("GetVisibilityChangedSignal is unimplemented", 0)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return Gui
