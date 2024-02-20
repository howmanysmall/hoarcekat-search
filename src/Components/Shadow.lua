--!native
--!optimize 2
--!strict

local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

export type ShadowProperties = {
	Radius: number,
	Position: UDim2,
	Size: UDim2,
	Transparency: number,
}

local function Shadow(properties: ShadowProperties)
	local theme = UseTheme()
	return Roact.createElement("Frame", {
		BackgroundColor3 = theme.DropShadow.Default,
		BackgroundTransparency = properties.Transparency,
		BorderSizePixel = 0,
		Position = properties.Position,
		Size = properties.Size,
		ZIndex = 0,
	}, {
		UICorner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, properties.Radius),
		}),

		Children = Roact.createFragment(properties[Roact.Children]),
	})
end

return RoactHooked.HookPure(Shadow, {Name = "Shadow"})
