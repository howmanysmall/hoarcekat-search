local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

local Preview = require(script.Parent.Preview)
local Sidebar = require(script.Parent.Sidebar)

local function App()
	local theme = UseTheme()
	return Roact.createElement("Frame", {
		BackgroundColor3 = theme.MainBackground.Default,
		Size = UDim2.fromScale(1, 1),
	}, {
		Sidebar = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.2, 1),
		}, {
			Sidebar = Roact.createElement(Sidebar, {}),
		}),

		Preview = Roact.createElement("Frame", {
			AnchorPoint = Vector2.xAxis,
			BackgroundTransparency = 1,
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.fromScale(0.8, 1),
		}, {
			Preview = Roact.createElement(Preview, {}),
		}),
	})
end

return RoactHooked.HookPure(App, {
	ComponentType = "PureComponent",
	Name = "App",
})
