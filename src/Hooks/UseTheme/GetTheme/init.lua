--!optimize 2
--!strict
local Types = require(script:FindFirstChild("Types"))
export type ThemeData = Types.ThemeData

local StudioStyleGuideColors = Enum.StudioStyleGuideColor:GetEnumItems()
local StudioStyleGuideModifiers = Enum.StudioStyleGuideModifier:GetEnumItems()

local THEME_CACHE: {[string]: ThemeData} = {}

local function GetTheme(): ThemeData
	local studioTheme = settings().Studio.Theme :: StudioTheme
	local cached = THEME_CACHE[studioTheme.Name]
	if cached then
		return cached
	end

	local theme = {}
	theme.ThemeName = studioTheme.Name

	for _, studioStyleGuideColor in StudioStyleGuideColors do
		local color = {}
		for _, studioStyleGuideModifier in StudioStyleGuideModifiers do
			color[studioStyleGuideModifier.Name] = studioTheme:GetColor(studioStyleGuideColor, studioStyleGuideModifier)
		end

		theme[studioStyleGuideColor.Name] = table.freeze(color)
	end

	function theme.GetColor(
		studioStyleGuideColor: Enum.StudioStyleGuideColor,
		studioStyleGuideModifier: Enum.StudioStyleGuideModifier?
	)
		return theme[studioStyleGuideColor.Name][if studioStyleGuideModifier
			then studioStyleGuideModifier.Name
			else "Default"]
	end

	local trueTheme: ThemeData = table.freeze(theme) :: any
	THEME_CACHE[studioTheme.Name] = trueTheme
	return trueTheme
end

return GetTheme
