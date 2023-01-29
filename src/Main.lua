local RunService = game:GetService("RunService")
local Hoarcekat = script:FindFirstAncestor("Hoarcekat")

local App = require(script.Parent.Components.App)
local Reducer = require(script.Parent.Reducer)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)
local Rodux = require(Hoarcekat.Vendor.Rodux)

local function getSuffix(plugin)
	if plugin.isDev then
		return " [DEV]", "Dev"
	else
		return "", ""
	end
end

local function Main(plugin, savedState)
	local displaySuffix, nameSuffix = getSuffix(plugin)
	local toolbar = plugin:toolbar("HoarcekatSearch" .. displaySuffix)

	local toggleButton =
		plugin:button(toolbar, "HoarcekatSearch", "Open the Hoarcekat window", "rbxassetid://4621571957")

	local store = Rodux.Store.new(Reducer, savedState, {})

	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 0, 0)
	local gui = plugin:createDockWidgetPluginGui("HoarcekatSearch" .. nameSuffix, info)
	gui.Name = "HoarcekatSearch" .. nameSuffix
	gui.Title = "HoarcekatSearch " .. displaySuffix
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	toggleButton:SetActive(gui.Enabled)

	local connection = toggleButton.Click:Connect(function()
		gui.Enabled = not gui.Enabled
		toggleButton:SetActive(gui.Enabled)
	end)

	local app = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App, {}),
	})

	local instance = Roact.mount(app, gui, "HoarcekatSearch")

	plugin:beforeUnload(function()
		Roact.unmount(instance)
		connection:Disconnect()
		return store:getState()
	end)

	if RunService:IsRunning() then
		return
	end

	local unloadConnection
	unloadConnection = gui.AncestryChanged:Connect(function()
		print("New Hoarcekat version coming online; unloading the old version")
		unloadConnection:Disconnect()
		plugin:unload()
	end)
end

return Main
