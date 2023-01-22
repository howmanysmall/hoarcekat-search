local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

local BAR_HEIGHT = 24
local ICON_SIZE = 16

local function IconListItem(props)
	local theme = UseTheme()
	return Roact.createElement("TextButton", {
		BackgroundColor3 = theme.CurrentMarker.Selected,
		BackgroundTransparency = props.Selected and 0.5 or 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
		Text = "",

		[Roact.Event.Activated] = props.Activated,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		IconFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(BAR_HEIGHT, BAR_HEIGHT),
		}, {
			IconImage = Roact.createElement("ImageLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Image = props.Icon,
				ImageColor3 = theme.BrightText.Default,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(ICON_SIZE, ICON_SIZE),
			}),
		}),

		Title = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 2,
			Size = UDim2.new(1, -BAR_HEIGHT, 0, BAR_HEIGHT),
			Text = props.Text,
			TextColor3 = theme.BrightText.Default,
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
	})
end

return RoactHooked.HookPure(IconListItem, {
	ComponentType = "PureComponent",
	Name = "IconListItem",
})
