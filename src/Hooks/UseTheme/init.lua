--!optimize 2
local RoactHooked = require(script.Parent.Parent.Parent.Vendor:FindFirstChild("RoactHooked"))
local GetTheme = require(script:FindFirstChild("GetTheme"))

local function UseTheme(): GetTheme.ThemeData
	local theme, setTheme = RoactHooked.UseState(GetTheme())
	RoactHooked.UseEffect(function()
		local connection = settings().Studio.ThemeChanged:Connect(function()
			setTheme(GetTheme())
		end)

		return function()
			if connection.Connected then
				connection:Disconnect()
			end
		end
	end)

	return theme
end

return UseTheme
