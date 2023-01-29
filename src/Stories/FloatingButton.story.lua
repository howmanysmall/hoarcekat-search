local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local Assets = require(Hoarcekat.Plugin.Assets)
local FloatingButton = require(Hoarcekat.Plugin.Components.FloatingButton)

local function TestFloatingButton()
	return Roact.createElement(FloatingButton, {
		Activated = function()
			print("activated!")
		end,

		Image = Assets.preview,
		ImageSize = UDim.new(0, 24),
		Size = UDim.new(0, 40),
	})
end

return function(target)
	local handle = Roact.mount(Roact.createElement(TestFloatingButton, {}), target, "FloatingButton")

	return function()
		Roact.unmount(handle)
	end
end
