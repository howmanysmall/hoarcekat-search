--!native
--!optimize 2
--!strict

local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local function GetCanvasSize(size: Vector2)
	return UDim2.fromOffset(size.X, size.Y)
end

local function AutomatedScrollingFrame(properties)
	local canvasSize, updateCanvasSize = RoactHooked.UseBinding(Vector2.zero)
	local function resize(rbx: UIGridStyleLayout)
		updateCanvasSize(rbx.AbsoluteContentSize)
	end

	local layoutProps = {
		[Roact.Change.AbsoluteContentSize] = resize,
	}

	for propName, propValue in properties.LayoutProps or {} do
		layoutProps[propName] = propValue
	end

	local nativeProps = {
		CanvasSize = canvasSize:map(GetCanvasSize),
	}

	for propName, propValue in properties.Native or {} do
		nativeProps[propName] = propValue
	end

	return Roact.createElement("ScrollingFrame", nativeProps, {
		Layout = Roact.createElement(properties.LayoutClass, layoutProps),
		Children = Roact.createFragment(properties[Roact.Children]),
	})
end

return RoactHooked.HookPure(AutomatedScrollingFrame, {
	ComponentType = "PureComponent",
	Name = "AutomatedScrollingFrame",
})
