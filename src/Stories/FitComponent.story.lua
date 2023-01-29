local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local FitComponent = require(Hoarcekat.Plugin.Components.FitComponent)

local function Content(props)
	return Roact.createElement("TextLabel", {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 0.5,
		LayoutOrder = props.Number,
		Size = UDim2.new(1, 0, 0, 30),
		Text = props.Number,
		TextColor3 = Color3.fromRGB(255, 255, 255),
	})
end

local function TestFitComponent()
	return Roact.createElement(FitComponent, {
		ContainerClass = "Frame",
		ContainerProps = {
			BackgroundColor3 = Color3.fromRGB(255, 0, 0), -- We should see red seep through
			ClipsDescendants = true, -- If size doesn't change, we won't see anything
		},

		LayoutClass = "UIListLayout",
		LayoutProps = {
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		Roact.createElement(Content, {Number = 3}),
		Roact.createElement(Content, {Number = 2}),
		Roact.createElement(Content, {Number = 1}),
	})
end

return function(target)
	local handle = Roact.mount(Roact.createElement(TestFitComponent, {}), target, "FitComponent")

	return function()
		Roact.unmount(handle)
	end
end
