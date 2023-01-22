local RoactHooked = require(script.Parent.Parent.Parent.Vendor.RoactHooked)

local function UseExternalEvent(Event: RBXScriptSignal, Function: (...any) -> ())
	RoactHooked.UseEffect(function()
		local Connection = Event:Connect(Function)
		return function()
			Connection:Disconnect()
		end
	end, RoactHooked.GetDependencies(Event, Function))
end

return UseExternalEvent
