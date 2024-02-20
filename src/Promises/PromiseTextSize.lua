--!native
--!optimize 2
--!strict

local TextService = game:GetService("TextService")
local Promise = require(script.Parent.Parent.Parent.Vendor.Promise)

local function GetTextBoundsAsync(getTextBoundsParams: GetTextBoundsParams)
	return TextService:GetTextBoundsAsync(getTextBoundsParams)
end

local function PromiseTextSize(text: string, textSize: number, font: Font, frameSize: Vector2)
	local getTextBoundsParams = Instance.new("GetTextBoundsParams")
	getTextBoundsParams.Font = font
	getTextBoundsParams.Size = textSize
	getTextBoundsParams.Text = text
	getTextBoundsParams.Width = frameSize.X

	return Promise.new(function(resolve, reject)
		local success, value = pcall(GetTextBoundsAsync, getTextBoundsParams);
		(success and resolve or reject)(value)
	end):timeout(1, "Took longer than one second.")
end

return PromiseTextSize
