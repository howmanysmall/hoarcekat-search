local Hoarcekat = script:FindFirstAncestor("Hoarcekat")
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

export type ISearchBoxProps = {
	-- Custom Properties
	GraphemeLimit: number?,
	TextLimit: number?,

	-- Native Properties
	ClearTextOnFocus: boolean?,
	LayoutOrder: number?,
	Position: UDim2?,

	-- Functions
	OnFocused: nil | (rbx: TextBox) -> (),
	OnFocusLost: nil | (text: string, enterPressed: boolean, inputObject: InputObject) -> (),
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

	local theme = UseTheme()

	local graphemeLimit = props.GraphemeLimit
	local textLimit = props.TextLimit

	local transformText = props.TransformText

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
	})
end

return RoactHooked.HookPure(SearchBox, {
	ComponentType = "PureComponent",
	Name = "SearchBox",
})
