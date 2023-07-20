local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local Tooltip = require(Hoarcekat.Plugin.Components.Tooltip)

local function TooltipStory()
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		Button = Roact.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutoButtonColor = false,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(200, 40),
			Text = "Example",
			TextColor3 = Color3.fromRGB(0, 0, 0),
			TextSize = 24,
		}, {
			Tooltip = Roact.createElement(Tooltip, {
				Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
			}),
		}),
	})
end

return function(target)
	local tree = Roact.mount(Roact.createElement(TooltipStory, {}), target, "TooltipStory")
	return function()
		Roact.unmount(tree)
	end
end
