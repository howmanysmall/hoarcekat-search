--!optimize 2
--!strict
local Types = require(script:FindFirstChild("Types"))
export type ThemeData = Types.ThemeData

local StudioStyleGuideColors = Enum.StudioStyleGuideColor:GetEnumItems()
local StudioStyleGuideModifiers = Enum.StudioStyleGuideModifier:GetEnumItems()

local function GetTheme(): ThemeData
	local StudioTheme = settings().Studio.Theme :: StudioTheme
	local Theme = {}
	Theme.ThemeName = StudioTheme.Name

	for _, StudioStyleGuideColor in StudioStyleGuideColors do
		local Color = {}
		for _, StudioStyleGuideModifier in StudioStyleGuideModifiers do
			Color[StudioStyleGuideModifier.Name] = StudioTheme:GetColor(StudioStyleGuideColor, StudioStyleGuideModifier)
		end

		Theme[StudioStyleGuideColor.Name] = table.freeze(Color)
	end

	function Theme.GetColor(
		StudioStyleGuideColor: Enum.StudioStyleGuideColor,
		StudioStyleGuideModifier: Enum.StudioStyleGuideModifier?
	)
		return Theme[StudioStyleGuideColor.Name][if StudioStyleGuideModifier
			then StudioStyleGuideModifier.Name
			else "Default"]
	end

	return (table.freeze(Theme) :: any) :: ThemeData
end

return GetTheme
