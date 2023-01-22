local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local UseExternalEvent = require(Hoarcekat.Plugin.Hooks.UseExternalEvent)

export type IEventConnectionProps = {
	event: RBXScriptSignal,
	callback: (...any) -> (),
}

local function EventConnection(props: IEventConnectionProps)
	UseExternalEvent(props.event, props.callback)
	return nil
end

return RoactHooked.HookPure(EventConnection, {
	ComponentType = "PureComponent",
	Name = "EventConnection",
})
