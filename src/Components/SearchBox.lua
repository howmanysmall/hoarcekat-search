local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local Tooltip = require(script.Parent.Tooltip)

local Assets = require(Hoarcekat.Plugin.Assets)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

export type ISearchBoxProps = {
	-- Custom Properties
	GraphemeLimit: number?,
	PatternEnabled: boolean?,
	TextLimit: number?,

	-- Native Properties
	ClearTextOnFocus: boolean?,
	LayoutOrder: number?,
	Position: UDim2?,

	-- Functions
	OnFocused: nil | (rbx: TextBox) -> (),
	OnFocusLost: nil | (text: string, enterPressed: boolean, inputObject: InputObject) -> (),
	OnPatternToggle: nil | (usePattern: boolean) -> (),
	OnTextChanged: nil | (text: string) -> (),

	TransformText: nil | (text: string) -> string,
}

local function GetFontFace(value)
	return Font.new("rbxasset://fonts/families/SourceSansPro.json", value)
end

local function SearchBox(props: ISearchBoxProps)
	local hasText, setHasText = RoactHooked.UseState(false)
	local fontWeight, setFontWeight = RoactHooked.UseBinding(Enum.FontWeight.Bold)
	local text, setText = RoactHooked.UseBinding("")

	local hovered, setHovered = RoactHooked.UseBinding(false)
	local pressed, setPressed = RoactHooked.UseBinding(false)

	local theme = UseTheme()

	local graphemeLimit = props.GraphemeLimit
	local textLimit = props.TextLimit

	local transformText = props.TransformText

	local onPatternToggle = props.OnPatternToggle
	local patternEnabled = props.PatternEnabled

	RoactHooked.UseEffect(function()
		setFontWeight(if hasText then Enum.FontWeight.Regular else Enum.FontWeight.Bold)
	end, RoactHooked.GetDependencies(hasText))

	local limitText = RoactHooked.UseCallback(function(newText: string)
		local hasGraphemeLimit = if graphemeLimit then graphemeLimit > -1 else false
		local hasTextLimit = if textLimit then textLimit > -1 else false

		local fixedText = newText
		if hasGraphemeLimit or hasTextLimit then
			local textWithTextLimit = string.sub(newText, 1, if hasTextLimit then textLimit else nil)
			if hasGraphemeLimit then
				local graphemesToLength = {}
				local length = 0
				for _, last in utf8.graphemes(textWithTextLimit) do
					length += 1
					graphemesToLength[length] = last
				end

				local cutoffLength = graphemesToLength[graphemeLimit] or graphemesToLength[length]
				fixedText = string.sub(textWithTextLimit, 1, cutoffLength)
			else
				fixedText = textWithTextLimit
			end
		end

		return fixedText
	end, RoactHooked.GetDependencies(graphemeLimit, textLimit))

	local onTextChanged = RoactHooked.UseCallback(function(rbx: TextBox)
		local transformedText = if transformText then transformText(rbx.Text) else rbx.Text

		local newText = limitText(transformedText)
		setText(newText)
		setHasText(newText ~= "")

		if props.OnTextChanged then
			props.OnTextChanged(newText)
		end
	end, RoactHooked.GetDependencies(props.OnTextChanged, limitText, transformText))

	local onFocusLost = RoactHooked.UseCallback(function(_, enterPressed: boolean, inputObject: InputObject)
		if props.OnFocusLost then
			props.OnFocusLost(text:getValue(), enterPressed, inputObject)
		end
	end, RoactHooked.GetDependencies(props.OnFocusLost))

	if onPatternToggle then
		local joinedBindings = Roact.joinBindings({
			hovered = hovered,
			pressed = pressed,
		})

		return Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.ScrollBar.Default,
			BorderSizePixel = 0,
			LayoutOrder = props.LayoutOrder,
			Position = props.Position,
			Size = UDim2.new(1, 0, 0, 20),
			ZIndex = 2,
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),

			Search = Roact.createElement("TextBox", {
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClearTextOnFocus = props.ClearTextOnFocus,
				FontFace = fontWeight:map(GetFontFace),
				LayoutOrder = 0,
				PlaceholderColor3 = theme.DimmedText.Default,
				PlaceholderText = "SEARCH",
				Size = UDim2.new(1, -20, 0, 20),
				Text = text,
				TextColor3 = theme.SubText.Default,
				TextSize = 18,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 2,
				[Roact.Change.Text] = onTextChanged,
				[Roact.Event.Focused] = props.OnFocused,
				[Roact.Event.FocusLost] = onFocusLost,
			}, {
				Tooltip = Roact.createElement(Tooltip, {
					Text = "Search for a story.",
				}),
			}),

			PatternToggle = Roact.createElement("ImageButton", {
				BackgroundColor3 = joinedBindings:map(function(state: {hovered: boolean, pressed: boolean})
					return theme.Button[if patternEnabled
						then "Selected"
						else state.pressed and "Pressed" or (state.hovered and "Hover" or "Default")]
				end),

				BorderSizePixel = 0,
				Image = Assets.regexp,
				ImageColor3 = joinedBindings:map(function(state: {hovered: boolean, pressed: boolean})
					return theme.ButtonText[if patternEnabled
						then "Selected"
						else state.pressed and "Pressed" or (state.hovered and "Hover" or "Default")]
				end),

				LayoutOrder = 1,
				Size = UDim2.fromOffset(20, 20),
				ZIndex = 3,

				[Roact.Event.Activated] = function()
					onPatternToggle(not patternEnabled)
				end,

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
				Tooltip = Roact.createElement(Tooltip, {
					Text = "Use Luau patterns",
				}),
			}),
		})
	else
		return Roact.createElement("TextBox", {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = theme.ScrollBar.Default,
			BorderSizePixel = 0,
			ClearTextOnFocus = props.ClearTextOnFocus,
			FontFace = fontWeight:map(GetFontFace),
			LayoutOrder = props.LayoutOrder,
			PlaceholderColor3 = theme.DimmedText.Default,
			PlaceholderText = "SEARCH",
			Position = props.Position,
			Size = UDim2.new(1, 0, 0, 20),
			Text = text,
			TextColor3 = theme.SubText.Default,
			TextSize = 18,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 2,

			[Roact.Change.Text] = onTextChanged,
			[Roact.Event.Focused] = props.OnFocused,
			[Roact.Event.FocusLost] = onFocusLost,
		}, {
			Tooltip = Roact.createElement(Tooltip, {
				Text = "Search for a story.",
			}),
		})
	end
end

return RoactHooked.HookPure(SearchBox, {
	ComponentType = "PureComponent",
	Name = "SearchBox",
})
