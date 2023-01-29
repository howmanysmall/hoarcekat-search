local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local AutomatedScrollingFrame = require(Hoarcekat.Plugin.Components.AutomatedScrollingFrame)

local function Cruft()
	return Roact.createElement("Frame", {
		BackgroundColor3 = Color3.new(math.random(), math.random(), math.random()),
		Size = UDim2.new(1, 0, 0, 150),
	})
end

local function TestScrollingFrame()
	return Roact.createElement(AutomatedScrollingFrame, {
		LayoutClass = "UIListLayout",
		Native = {
			Size = UDim2.fromScale(0.8, 0.8),
		},
	}, {
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
		Roact.createElement(Cruft, {}),
	})
end

return function(target)
	local handle = Roact.mount(Roact.createElement(TestScrollingFrame, {}), target, "AutomatedScrollingFrame")

	return function()
		Roact.unmount(handle)
	end
end
