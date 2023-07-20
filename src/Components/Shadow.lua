--!strict
local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

export type IShadowProps = {
	Radius: number,
	Position: UDim2,
	Size: UDim2,
	Transparency: number,
}

local function Shadow(props: IShadowProps)
	local theme = UseTheme()
	return Roact.createElement("Frame", {
		BackgroundColor3 = theme.DropShadow.Default,
		BackgroundTransparency = props.Transparency,
		BorderSizePixel = 0,
		Position = props.Position,
		Size = props.Size,
		ZIndex = 0,
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.Radius),
		}),

		Children = Roact.createFragment(props[Roact.Children]),
	})
end

return RoactHooked.HookPure(Shadow, {Name = "Shadow"})
