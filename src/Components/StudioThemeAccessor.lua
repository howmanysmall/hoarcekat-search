--!native
--!optimize 2
--!strict

local Hoarcekat = script.Parent.Parent.Parent
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactHooked = require(Hoarcekat.Vendor.RoactHooked)
local UseExternalEvent = require(Hoarcekat.Plugin.Hooks.UseExternalEvent)

local function StudioThemeAccessor(properties)
	local studioSettings = settings().Studio
	local theme, setTheme = RoactHooked.UseState(studioSettings.Theme)

	UseExternalEvent(studioSettings.ThemeChanged, function()
		setTheme(studioSettings.Theme)
	end)

	local render = Roact.oneChild(properties[Roact.Children])
	return render(theme)
end

return RoactHooked.HookPure(StudioThemeAccessor, {
	ComponentType = "PureComponent",
	Name = "StudioThemeAccessor",
})
