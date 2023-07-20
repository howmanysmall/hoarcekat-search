--!strict
local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

local Reduction = require(script.Reduction)

local HANDLE_WIDTH = 4

export type IVerticalSplitterProps = {
	AnchorPoint: Vector2,
	LayoutOrder: number?,
	Position: UDim2,
	Size: UDim2,
	ZIndex: number?,
	Mouse: PluginMouse,
}

local function VerticalSplitter(props: IVerticalSplitterProps)
	local containerRef = RoactHooked.UseRef()
	local state, dispatch = RoactHooked.UseReducer(Reduction.Reducer, Reduction.InitialState)
	local theme = UseTheme()

	local alpha = state.Alpha
	local dragging = state.Dragging
	local hovering = state.Hovering

	local mouse = props.Mouse

	local onInputBegan = RoactHooked.UseCallback(function(_, inputObject: InputObject)
		local userInputType = inputObject.UserInputType
		if userInputType == Enum.UserInputType.MouseMovement then
			dispatch(Reduction.SetHovering(true))
		elseif userInputType == Enum.UserInputType.MouseButton1 then
			dispatch(Reduction.SetDragging(true))
		end
	end, RoactHooked.GetDependencies(dispatch))

	local onInputChanged = RoactHooked.UseCallback(function(_, inputObject: InputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement and dragging then
			local rbx: Frame = containerRef:getValue()
			local width = rbx.AbsoluteSize.X
			local offset = inputObject.Position.X - rbx.AbsolutePosition.X
			offset = math.clamp(offset, HANDLE_WIDTH, width - HANDLE_WIDTH)
			dispatch(Reduction.SetAlpha(offset / width))
		end
	end, RoactHooked.GetDependencies(dispatch, dragging))

	local onInputEnded = RoactHooked.UseCallback(function(_, inputObject: InputObject)
		local userInputType = inputObject.UserInputType
		if userInputType == Enum.UserInputType.MouseMovement then
			dispatch(Reduction.SetHovering(false))
		elseif userInputType == Enum.UserInputType.MouseButton1 then
			dispatch(Reduction.SetDragging(false))
		end
	end, RoactHooked.GetDependencies(dispatch))

	local updateMouseIcon = RoactHooked.UseCallback(function()
		mouse.Icon = if hovering or dragging then "rbxasset://SystemCursors/SplitEW" else ""
	end, RoactHooked.GetDependencies(dragging, hovering, mouse))

	RoactHooked.UseEffect(function()
		updateMouseIcon()
	end, {})

	RoactHooked.UseEffect(function()
		return function()
			updateMouseIcon()
		end
	end, {})

	return Roact.createElement("Frame", {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size,
		ZIndex = props.ZIndex,
		[Roact.Ref] = containerRef,
		[Roact.Event.InputChanged] = onInputChanged,
	}, {
		Left = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(),
			Size = UDim2.new(alpha, -HANDLE_WIDTH / 2, 1, 0),
			ZIndex = 0,
		}, {props[Roact.Children].Left}),

		Right = Roact.createElement("Frame", {
			AnchorPoint = Vector2.xAxis,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(1 - alpha, -HANDLE_WIDTH / 2, 1, 0),
			ZIndex = 0,
		}, {props[Roact.Children].Right}),

		Grabber = Roact.createElement("TextButton", {
			AnchorPoint = Vector2.new(0.5, 0),
			AutoButtonColor = false,
			BackgroundColor3 = theme.DialogButtonBorder.Default,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(alpha, 0),
			Size = UDim2.new(0, HANDLE_WIDTH, 1, 0),
			Text = "",
			ZIndex = 1,
			[Roact.Event.InputBegan] = onInputBegan,
			[Roact.Event.InputEnded] = onInputEnded,
		}, {
			BorderLeft = Roact.createElement("Frame", {
				BackgroundColor3 = theme.ScriptRuler.Default,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(-1, 0),
				Size = UDim2.new(0, 1, 1, 0),
				Visible = hovering or dragging,
			}),

			BorderRight = Roact.createElement("Frame", {
				BackgroundColor3 = theme.ScriptRuler.Default,
				BorderSizePixel = 0,
				Position = UDim2.fromScale(1, 0),
				Size = UDim2.new(0, 1, 1, 0),
				Visible = hovering or dragging,
			}),
		}),
	})
end

return RoactHooked.HookPure(VerticalSplitter, {
	ComponentType = "PureComponent",
	DefaultProps = {
		AnchorPoint = Vector2.zero,
		Position = UDim2.new(),
		Size = UDim2.fromScale(1, 1),
	} :: any,

	Name = "VerticalSplitter",
})
