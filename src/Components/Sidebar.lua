local Hoarcekat = script.Parent.Parent.Parent

local Janitor = require(Hoarcekat.Vendor.Janitor)
local Roact = require(Hoarcekat.Vendor.Roact)
local RoactRodux = require(Hoarcekat.Vendor.RoactRodux)

local Assets = require(Hoarcekat.Plugin.Assets)

local AutomatedScrollingFrame = require(script.Parent.AutomatedScrollingFrame)
local Collapsible = require(script.Parent.Collapsible)
local IconListItem = require(script.Parent.IconListItem)
local SearchBox = require(script.Parent.SearchBox)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local TextLabel = require(script.Parent.TextLabel)

local Sidebar = Roact.PureComponent:extend("Sidebar")

local NONE = newproxy(true)
local USER_SERVICES = {
	"Workspace",
	"ReplicatedFirst",
	"ReplicatedStorage",
	"ServerScriptService",
	"ServerStorage",
	"StarterGui",
	"StarterPlayer",
}

local function isStoryScript(instance)
	return instance:IsA("ModuleScript") and string.match(instance.Name, "%.story$")
end

local function SidebarList(props)
	local children = props.Children
	if type(children) ~= "table" then
		warn(`Invalid children passed to SidebarList - {children} ({typeof(children)})`)
		return Roact.createFragment({})
	end

	local contents = {}

	for childName, child in children do
		if typeof(child) == "Instance" then
			contents["Instance" .. child.Name] = Roact.createElement(IconListItem, {
				Activated = function()
					props.SelectStory(child)
				end,

				Icon = Assets.hamburger,
				Selected = props.SelectedStory == child,
				Text = string.sub(child.Name, 1, #child.Name - 6),
			})
		else
			contents["Folder" .. childName] = Roact.createElement(SidebarList, {
				Children = child,
				SelectStory = props.SelectStory,
				SelectedStory = props.SelectedStory,
				Title = childName,
			})
		end
	end

	return Roact.createElement(Collapsible, {
		Title = props.Title,
	}, contents)
end

function Sidebar:init()
	self.janitor = Janitor.new()
	self:setState({
		searchTerm = "",
		usePattern = false,
	})

	self.onPatternToggle = function(usePattern: boolean)
		self:setState({
			usePattern = usePattern,
		})
	end

	self.onTextChanged = function(text: string)
		self:setState({
			searchTerm = text,
		})
	end

	self.transformText = function(text: string)
		return string.gsub(string.gsub(text, "[%s]+$", ""), "^[%s]+", "")
	end

	for _, serviceName in USER_SERVICES do
		local service = game:GetService(serviceName)

		self:lookForStories(service)

		self.janitor:Add(service.DescendantAdded:Connect(function(child)
			self:lookForStories(child)
			self:checkStory(child)
		end), "Disconnect")
	end
end

function Sidebar:patchStoryScripts(patch)
	if self.cleaning then
		return
	end

	local storyScripts = {}

	for storyScript in self.state.storyScripts or {} do
		storyScripts[storyScript] = true
	end

	local modified = false

	for key, value in patch do
		if value == NONE then
			value = nil
		end

		if storyScripts[key] ~= value then
			modified = true
			storyScripts[key] = value
		end
	end

	if modified then
		self:setState({
			storyScripts = storyScripts,
		})
	end
end

function Sidebar:lookForStories(instance)
	for _, child in instance:GetDescendants() do
		self:checkStory(child)
	end
end

function Sidebar:checkStory(instance)
	if isStoryScript(instance) then
		self:addStoryScript(instance)
	else
		self:removeStoryScript(instance)
	end
end

function Sidebar:addStoryScript(storyScript)
	local instanceJanitor = Janitor.new()

	instanceJanitor:Add(function()
		self:removeStoryScript(storyScript)
		self.janitor:Remove(instanceJanitor)
	end, true)

	instanceJanitor:Add(storyScript.Changed:Connect(function()
		if not isStoryScript(storyScript) then
			-- We were a story script, now we're not, remove us
			instanceJanitor:Cleanup()
		end
	end), "Disconnect")

	instanceJanitor:Add(storyScript.AncestryChanged:Connect(function()
		if not storyScript:IsDescendantOf(game) then
			-- We were removed from the data model
			instanceJanitor:Cleanup()
		end
	end), "Disconnect")

	self:patchStoryScripts({
		[storyScript] = true,
	})

	self.janitor:Add(instanceJanitor, "Cleanup", instanceJanitor) -- hopefully making this Cleanyo
end

function Sidebar:removeStoryScript(storyScript)
	self:patchStoryScripts({
		[storyScript] = NONE,
	})

	if storyScript:IsDescendantOf(game) then
		local changedConnection
		changedConnection = storyScript.Changed:Connect(function()
			if isStoryScript(storyScript) then
				-- We didn't use to be a story script, now we are, add us
				self:addStoryScript(storyScript)
				changedConnection:Disconnect()
			end
		end)
	end
end

function Sidebar:willUnmount()
	self.cleaning = true
	self.janitor:Destroy()
end

type IStoryTreeEntry = {[number]: ModuleScript} & {[string]: IStoryTreeEntry}
type IStoryTree = {[string]: IStoryTreeEntry}

local Debounces = {}
local function DisableDebounce(ErrorName: string)
	Debounces[ErrorName] = nil
end

local function DebounceWarn(Length: number, ErrorName: string, ...: unknown)
	if not Debounces[ErrorName] then
		Debounces[ErrorName] = true
		warn(...)
		task.delay(Length, DisableDebounce, ErrorName)
	end
end

local function SafeMatch(String: string, SearchTerm: string, UsePattern: boolean)
	if UsePattern then
		local Success, Value = pcall(string.match, String, SearchTerm)
		if Success then
			return Value ~= nil
		else
			DebounceWarn(1, "StringMatch", "string.match failed with error -", Value)
			local FindSuccess, FindValue = pcall(string.find, String, SearchTerm)
			if FindSuccess then
				return FindValue ~= nil
			else
				DebounceWarn(1, "StringFind", "string.find failed with error -", FindValue)
				return true
			end
		end
	else
		local FindSuccess, FindValue = pcall(string.find, String, SearchTerm, nil, true)
		if FindSuccess then
			return FindValue ~= nil
		else
			DebounceWarn(1, "StringFind", "string.find failed with error -", FindValue)
			return true
		end
	end
end

function Sidebar:render()
	local props = self.props
	local state = self.state
	local searchTerm = string.lower(state.searchTerm)
	local isEmpty = searchTerm == ""
	local usePattern = state.usePattern

	return Roact.createElement(StudioThemeAccessor, {}, {
		function(theme)
			local storyTree: IStoryTree = {}

			for storyScript in state.storyScripts or {} do
				if not (isEmpty or SafeMatch(string.lower(storyScript.Name), searchTerm, usePattern)) then
					continue
				end

				local hierarchy = {}
				local parent = storyScript

				repeat
					table.insert(hierarchy, 1, parent)
					parent = parent.Parent
				until parent == game or parent == nil

				local current = storyTree
				for _, node in hierarchy do
					if node == storyScript then
						--if isEmpty or SafeMatch(storyScript.Name, searchTerm) then
						--	table.insert(current, storyScript)
						--end
						table.insert(current, storyScript)
						break
					end

					local name = node.Name

					if not current[name] then
						current[name] = {}
					end

					current = current[name]
				end
			end

			local storyLists = {}
			for parent, children in storyTree do
				storyLists[parent] = Roact.createElement(SidebarList, {
					Children = children,
					SelectStory = props.selectStory,
					SelectedStory = props.selectedStory,
					Title = parent,
				})
			end

			return Roact.createElement("Frame", {
				BackgroundColor3 = theme:GetColor(
					Enum.StudioStyleGuideColor.ScrollBarBackground,
					Enum.StudioStyleGuideModifier.Default
				),

				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = UDim2.fromScale(1, 1),
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 5),
					PaddingTop = UDim.new(0, 2),
				}),

				StoriesLabelContainer = Roact.createElement("Frame", {
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
				}, {
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),

					StoriesLabel = Roact.createElement(TextLabel, {
						Font = Enum.Font.SourceSansBold,
						LayoutOrder = 0,
						Text = "STORIES",
						TextColor3 = theme:GetColor(
							Enum.StudioStyleGuideColor.DimmedText,
							Enum.StudioStyleGuideModifier.Default
						),
					}),

					StoriesSearch = Roact.createElement(SearchBox, {
						ClearTextOnFocus = true,
						LayoutOrder = 1,
						PatternEnabled = usePattern,

						OnPatternToggle = self.onPatternToggle,
						OnTextChanged = self.onTextChanged,
						TransformText = self.transformText,
					}),
				}),

				StoryLists = Roact.createElement(AutomatedScrollingFrame, {
					LayoutClass = "UIListLayout",

					Native = {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 1, -40),
					},
				}, storyLists),
			})
		end,
	})
end

return RoactRodux.connect(function(state)
	return {
		selectedStory = state.StoryPicker,
	}
end, function(dispatch)
	return {
		selectStory = function(story)
			dispatch({
				story = story,
				type = "SetSelectedStory",
			})
		end,
	}
end)(Sidebar)
