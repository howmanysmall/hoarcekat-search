local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local Assets = require(Hoarcekat.Plugin.Assets)

local FitComponent = require(script.Parent.FitComponent)
local IconListItem = require(script.Parent.IconListItem)

local OFFSET = 8

local function Collapsible(props)
	local open, toggle = RoactHooked.UseToggle(true)

	local content = open and props[Roact.Children]
	return Roact.createElement(FitComponent, {
		ContainerClass = "Frame",
		ContainerProps = {
			BackgroundTransparency = 1,
		},

		LayoutClass = "UIListLayout",
		LayoutProps = {
			Padding = UDim.new(0, 5),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
	}, {
		Topbar = Roact.createElement(IconListItem, {
			Activated = toggle,
			Icon = open and Assets.collapse_down or Assets.collapse_right,
			Text = props.Title,
		}),

		Content = content and Roact.createElement(FitComponent, {
			ContainerClass = "Frame",
			ContainerProps = {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(OFFSET, 0),
			},

			LayoutClass = "UIListLayout",
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, OFFSET),
			}),

			Content = Roact.createFragment(content),
		}),
	})
end

return RoactHooked.HookPure(Collapsible, {
	ComponentType = "PureComponent",
	Name = "Collapsible",
})
