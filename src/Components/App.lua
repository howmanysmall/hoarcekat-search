--!native
--!optimize 2
--!strict

local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseTheme = require(Hoarcekat.Plugin.Hooks.UseTheme)

local Preview = require(script.Parent.Preview)
local Sidebar = require(script.Parent.Sidebar)
local VerticalSplitter = require(script.Parent.VerticalSplitter)

export type AppProperties = {
	Mouse: PluginMouse,
}

local function App(properties: AppProperties)
	local theme = UseTheme()
	return Roact.createElement("Frame", {
		BackgroundColor3 = theme.MainBackground.Default,
		Size = UDim2.fromScale(1, 1),
	}, {
		Splitter = Roact.createElement(VerticalSplitter, {
			Mouse = properties.Mouse,
		}, {
			Left = Roact.createElement(Sidebar, {}),
			Right = Roact.createElement(Preview, {}),
		}),
	})
end

return RoactHooked.HookPure(App, {
	ComponentType = "PureComponent",
	Name = "App",
})
