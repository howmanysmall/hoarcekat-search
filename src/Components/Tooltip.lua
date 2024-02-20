--!native
--!optimize 2
--!strict

local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

local PromiseTextSize = require(Hoarcekat.Plugin.Promises.PromiseTextSize)
local Shadow = require(script.Parent.Shadow)

local BUFFER = 3
local FONT = Font.fromName("SourceSansPro")
local TEXT_SIZE = 14
local TEXT_PADDING_SIDES = 3
local TEXT_PADDING_TOP = 1
local TEXT_PADDING_BOTTOM = 2

local OFFSET_RIGHT = 3
local OFFSET_DOWN = 18
local OFFSET_LEFT = 2
local OFFSET_UP = 2

local FOR_FULL_SIZE = Vector2.new(TEXT_PADDING_SIDES * 2, TEXT_PADDING_BOTTOM + TEXT_PADDING_TOP)

local function GetFullSize(value: Vector2)
	return value + FOR_FULL_SIZE
end

local function OffsetFromVector2(value: Vector2)
	return UDim2.fromOffset(value.X, value.Y)
end

export type TooltipProperties = {
	Disabled: boolean,
	HoverDelay: number,
	MaxWidth: number,
	Text: string,
}

local function Tooltip(properties: TooltipProperties)
	local display, setDisplay = RoactHooked.UseState(false)
	local textSize, setTextSize = RoactHooked.UseBinding(Vector2.zero)

	local displayPosition = RoactHooked.UseMutable(nil :: Vector2?)
	local displayThread = RoactHooked.UseMutable(nil :: thread?)

	local reference = RoactHooked.UseRef()
	local theme = UseTheme()

	local backgroundColor3 = theme.Tooltip.Default
	local borderColor3 = theme.Border.Default
	local textColor3 = theme.MainText.Default

	local disabled = properties.Disabled
	local hoverDelay = properties.HoverDelay
	local maxWidth = properties.MaxWidth
	local text = properties.Text

	local cancel = RoactHooked.UseCallback(function()
		if display then
			setDisplay(false)
		end

		if displayThread.Current then
			task.cancel(displayThread.Current)
			displayThread.Current = nil
			displayPosition.Current = nil
		end
	end, RoactHooked.GetDependencies(display))

	local onInputBeganChanged = RoactHooked.UseCallback(function(_, inputObject: InputObject)
		if not disabled and inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			cancel()
			displayPosition.Current = Vector2.new(inputObject.Position.X, inputObject.Position.Y)
			displayThread.Current = task.delay(hoverDelay, function()
				setDisplay(true)
			end)
		end
	end, RoactHooked.GetDependencies(cancel, disabled, hoverDelay))

	local onInputEnded = RoactHooked.UseCallback(function(_, inputObject: InputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
			cancel()
		end
	end, RoactHooked.GetDependencies(cancel))

	RoactHooked.UseEffect(function()
		if displayThread.Current then
			task.cancel(displayThread.Current)
		end
	end, {})

	RoactHooked.UseEffect(function()
		local frameSize = Vector2.new(maxWidth - TEXT_PADDING_SIDES * 2, math.huge)
		local promise = PromiseTextSize(text, TEXT_SIZE, FONT, frameSize):andThen(setTextSize):catch(function(exception)
			warn(`PromiseTextSize call failed - {exception}`)
		end)

		return function()
			promise:cancel()
		end
	end, RoactHooked.GetDependencies(maxWidth, setTextSize, text, theme))

	local fullSize = textSize:map(GetFullSize)
	local anchorPoint = fullSize:map(function(value)
		local localAnchorPoint = Vector2.zero
		if display then
			local target = if reference:getValue()
				then reference:getValue():FindFirstAncestorWhichIsA("LayerCollector")
				else nil

			if target then
				local mousePosition = displayPosition.Current
				if mousePosition then
					local spaceRight = target.AbsoluteSize.X - mousePosition.X - OFFSET_RIGHT
					local spaceLeft = mousePosition.X - OFFSET_LEFT

					if spaceRight < value.X + BUFFER and spaceLeft > spaceRight then
						localAnchorPoint = Vector2.new(1, localAnchorPoint.Y)
					end

					local spaceBelow = target.AbsoluteSize.Y - mousePosition.Y - OFFSET_DOWN
					local spaceAbove = mousePosition.Y - OFFSET_UP
					if spaceBelow < value.Y + BUFFER and spaceAbove > spaceBelow then
						localAnchorPoint = Vector2.new(localAnchorPoint.X, 1)
					end
				end
			end
		end

		return localAnchorPoint
	end)

	local tooltipSize = fullSize:map(OffsetFromVector2)
	local tooltipPosition = fullSize:map(function(value)
		local offset = Vector2.zero
		if display then
			local target = if reference:getValue()
				then reference:getValue():FindFirstAncestorWhichIsA("LayerCollector")
				else nil

			if target then
				local mousePosition = displayPosition.Current
				if mousePosition then
					local spaceRight = target.AbsoluteSize.X - mousePosition.X - OFFSET_RIGHT
					local spaceLeft = mousePosition.X - OFFSET_LEFT

					if spaceRight < value.X + BUFFER and spaceLeft > spaceRight then
						offset = Vector2.new(-OFFSET_LEFT, offset.Y)
					end

					local spaceBelow = target.AbsoluteSize.Y - mousePosition.Y - OFFSET_DOWN
					local spaceAbove = mousePosition.Y - OFFSET_UP
					if spaceBelow < value.Y + BUFFER and spaceAbove > spaceBelow then
						offset = Vector2.new(offset.X, -OFFSET_UP)
					end
				end
			end
		end

		return OffsetFromVector2(displayPosition.Current + offset)
	end)

	local dropShadow = nil
	local target: LayerCollector? = nil
	if display then
		target = if reference:getValue() then reference:getValue():FindFirstAncestorWhichIsA("LayerCollector") else nil
		if target ~= nil then
			dropShadow = Roact.createElement(Shadow, {
				Position = UDim2.fromOffset(4, 4),
				Radius = 5,
				Size = UDim2.new(1, 1, 1, 1),
				Transparency = 0.96,
			}, {
				Shadow = Roact.createElement(Shadow, {
					Position = UDim2.fromOffset(1, 1),
					Radius = 4,
					Size = UDim2.new(1, -2, 1, -2),
					Transparency = 0.88,
				}, {
					Shadow = Roact.createElement(Shadow, {
						Position = UDim2.fromOffset(1, 1),
						Radius = 3,
						Size = UDim2.new(1, -2, 1, -2),
						Transparency = 0.8,
					}, {
						Shadow = Roact.createElement(Shadow, {
							Position = UDim2.fromOffset(1, 1),
							Radius = 2,
							Size = UDim2.new(1, -2, 1, -2),
							Transparency = 0.77,
						}),
					}),
				}),
			})
		end
	end

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		[Roact.Change.AbsolutePosition] = cancel,
		[Roact.Event.InputBegan] = onInputBeganChanged,
		[Roact.Event.InputChanged] = onInputBeganChanged,
		[Roact.Event.InputEnded] = onInputEnded,
		[Roact.Ref] = reference,
	}, {
		Portal = target and Roact.createElement(Roact.Portal, {
			target = target,
		}, {
			Tooltip = Roact.createElement("Frame", {
				AnchorPoint = anchorPoint,
				BackgroundTransparency = 1,
				Position = tooltipPosition,
				Size = tooltipSize,
				ZIndex = 2 ^ 31 - 1,
			}, {
				Label = Roact.createElement("TextLabel", {
					BackgroundColor3 = backgroundColor3,
					BackgroundTransparency = 0,
					BorderColor3 = borderColor3,
					FontFace = FONT,
					Size = UDim2.fromScale(1, 1),
					Text = text,
					TextColor3 = textColor3,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					ZIndex = 1,
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, TEXT_PADDING_BOTTOM),
						PaddingLeft = UDim.new(0, TEXT_PADDING_SIDES),
						PaddingRight = UDim.new(0, TEXT_PADDING_SIDES),
						PaddingTop = UDim.new(0, TEXT_PADDING_TOP),
					}),
				}),

				Shadow = dropShadow,
			}),
		}),
	})
end

return RoactHooked.HookPure(Tooltip, {
	DefaultProps = {
		HoverDelay = 0.4,
		MaxWidth = 200,
		Text = "Tooltip.defaultProps.Text",
	} :: any,

	Name = "Tooltip",
})
