--!optimize 2
local RoactHooked = require(script.Parent.Parent.Parent.Vendor:FindFirstChild("RoactHooked"))
local GetTheme = require(script:FindFirstChild("GetTheme"))

local function UseTheme(): GetTheme.ThemeData
	local Theme, SetTheme = RoactHooked.UseState(GetTheme())
	RoactHooked.UseEffect(function()
		local Connection = settings().Studio.ThemeChanged:Once(function()
			SetTheme(GetTheme())
		end)

		return function()
			if Connection.Connected then
				Connection:Disconnect()
			end
		end
	end)

	return Theme
end

return UseTheme
