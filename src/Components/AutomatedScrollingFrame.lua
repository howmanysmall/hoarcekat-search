local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local function AutomatedScrollingFrame(props)
	local canvasSize, updateCanvasSize = RoactHooked.UseBinding(UDim2.new())
	local function resize(rbx: UIGridStyleLayout)
		updateCanvasSize(rbx.AbsoluteContentSize)
	end

	local layoutProps = {
		[Roact.Change.AbsoluteContentSize] = resize,
	}

	for propName, propValue in props.LayoutProps or {} do
		layoutProps[propName] = propValue
	end

	local nativeProps = {
		CanvasSize = canvasSize:map(function(size)
			return UDim2.fromOffset(size.X, size.Y)
		end),
	}

	for propName, propValue in props.Native or {} do
		nativeProps[propName] = propValue
	end

	return Roact.createElement("ScrollingFrame", nativeProps, {
		Layout = Roact.createElement(props.LayoutClass, layoutProps),
		Children = Roact.createFragment(props[Roact.Children]),
	})
end

return RoactHooked.HookPure(AutomatedScrollingFrame, {
	ComponentType = "PureComponent",
	Name = "AutomatedScrollingFrame",
})
