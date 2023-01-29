local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local function MapSize(y: number)
	return UDim2.new(1, 0, 0, y)
end

local function FitComponent(props)
	local size, updateSize = RoactHooked.UseBinding(0)
	local function sizeChanged(rbx: UIGridStyleLayout)
		updateSize(rbx.AbsoluteContentSize.Y)
	end

	local containerProps = table.clone(props.ContainerProps or {})
	local roactChildren = assert(props[Roact.Children], "No children given to FitComponent")
	local children = table.clone(roactChildren)

	assert(children.Layout == nil, "No children named Layout should exist!")

	local layoutProps = table.clone(props.LayoutProps or {})

	layoutProps[Roact.Change.AbsoluteContentSize] = sizeChanged
	children.Layout = Roact.createElement(props.LayoutClass, layoutProps)
	containerProps.Size = size:map(MapSize)

	containerProps[Roact.Children] = children
	return Roact.createElement(props.ContainerClass, containerProps)
end

return RoactHooked.HookPure(FitComponent, {
	ComponentType = "PureComponent",
	Name = "FitComponent",
})
