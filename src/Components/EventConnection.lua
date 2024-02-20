--!native
--!optimize 2
--!strict

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local UseExternalEvent = require(Hoarcekat.Plugin.Hooks.UseExternalEvent)

export type EventConnectionProperties = {
	event: RBXScriptSignal,
	callback: (...any) -> (),
}

local function EventConnection(properties: EventConnectionProperties)
	UseExternalEvent(properties.event, properties.callback)
	return nil
end

return RoactHooked.HookPure(EventConnection, {
	ComponentType = "PureComponent";
	Name = "EventConnection";
})
