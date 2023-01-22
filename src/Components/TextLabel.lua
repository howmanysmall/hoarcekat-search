local TextService = game:GetService("TextService")
local Roact = require(script.Parent.Parent.Parent.Vendor.Roact)

local function TextLabel(props)
	local update

	if props.TextWrapped then
		function update(rbx)
			if not rbx then
				return
			end

			local width = rbx.AbsoluteSize.X
			local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width - 2, 100000))
			rbx.Size = UDim2.new(1, 0, 0, tb.Y)
		end
	else
		function update(rbx)
			if not rbx then
				return
			end

			local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(100000, 100000))
			rbx.Size = UDim2.new(props.Width or UDim.new(0, tb.X), UDim.new(0, tb.Y))
		end
	end

	local autoSize = not props.Size

	return Roact.createElement("TextLabel", {
		BackgroundTransparency = 1,
		Font = props.Font or Enum.Font.SourceSans,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Size = props.Size or props.TextWrapped and UDim2.fromScale(1, 0) or nil,
		Text = props.Text or "<Text Not Set>",
		TextColor3 = props.TextColor3 or Color3.fromRGB(0, 0, 0),
		TextSize = props.TextSize or 20,
		TextWrapped = props.TextWrapped,
		TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
		TextYAlignment = props.TextYAlignment,

		[Roact.Change.AbsoluteSize] = if autoSize then update else nil,
		[Roact.Change.Parent] = if autoSize then update else nil,
		[Roact.Change.TextBounds] = if autoSize then update else nil,

		[Roact.Ref] = if autoSize then update else nil,
	})
end

return TextLabel
