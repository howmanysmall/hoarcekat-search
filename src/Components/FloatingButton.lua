local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)

local Assets = require(Hoarcekat.Plugin.Assets)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

export type IFloatingButtonProps = {
	Activated: (...any) -> (),
	Image: string,
	ImageSize: UDim,
	Size: UDim,
}

local function FloatingButton(props: IFloatingButtonProps)
	local hovered, setHovered = RoactHooked.UseBinding(false)
	local pressed, setPressed = RoactHooked.UseBinding(false)
	local theme = UseTheme()

	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Image = Assets.button_fill,
		ImageColor3 = Roact.joinBindings({
			hovered = hovered,
			pressed = pressed,
		}):map(function(state)
			return theme.MainButton[state.pressed and "Pressed" or (state.hovered and "Hover" or "Default")]
		end),

		Size = UDim2.new(props.Size, props.Size),

		[Roact.Event.Activated] = props.Activated,
		[Roact.Event.InputBegan] = function(_, inputObject: InputObject)
			local userInputType = inputObject.UserInputType
			if userInputType == Enum.UserInputType.MouseButton1 then
				setPressed(true)
			elseif userInputType == Enum.UserInputType.MouseMovement then
				setHovered(true)
			end
		end,

		[Roact.Event.InputEnded] = function(_, inputObject: InputObject)
			local userInputType = inputObject.UserInputType
			if userInputType == Enum.UserInputType.MouseButton1 then
				setPressed(false)
			elseif userInputType == Enum.UserInputType.MouseMovement then
				setHovered(false)
			end
		end,
	}, {
		Image = Roact.createElement("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = props.Image,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(props.ImageSize, props.ImageSize),
		}),
	})
end

return RoactHooked.HookPure(FloatingButton, {
	ComponentType = "PureComponent",
	Name = "FloatingButton",
})
