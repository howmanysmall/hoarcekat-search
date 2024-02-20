--!native
--!optimize 2
--!strict

export type ColorData = {
	Default: Color3,
	Disabled: Color3,
	Hover: Color3,
	Pressed: Color3,
	Selected: Color3,
}

export type ThemeData = {
	GetColor: (
		StudioStyleGuideColor: Enum.StudioStyleGuideColor,
		StudioStyleGuideModifier: Enum.StudioStyleGuideModifier?
	) -> Color3,

	ThemeName: "Dark" | "Light",

	AttributeCog: ColorData,
	Border: ColorData,
	BrightText: ColorData,
	Button: ColorData,
	ButtonBorder: ColorData,
	ButtonText: ColorData,
	CategoryItem: ColorData,
	ChatIncomingBgColor: ColorData,
	ChatIncomingTextColor: ColorData,
	ChatModeratedMessageColor: ColorData,
	ChatOutgoingBgColor: ColorData,
	ChatOutgoingTextColor: ColorData,
	CheckedFieldBackground: ColorData,
	CheckedFieldBorder: ColorData,
	CheckedFieldIndicator: ColorData,
	ColorPickerFrame: ColorData,
	CurrentMarker: ColorData,
	Dark: ColorData,
	DebuggerCurrentLine: ColorData,
	DebuggerErrorLine: ColorData,
	DialogButton: ColorData,
	DialogButtonBorder: ColorData,
	DialogButtonText: ColorData,
	DialogMainButton: ColorData,
	DialogMainButtonText: ColorData,
	DiffFilePathBackground: ColorData,
	DiffFilePathBorder: ColorData,
	DiffFilePathText: ColorData,
	DiffLineNum: ColorData,
	DiffLineNumAdditionBackground: ColorData,
	DiffLineNumDeletionBackground: ColorData,
	DiffLineNumNoChangeBackground: ColorData,
	DiffLineNumSeparatorBackground: ColorData,
	DiffTextAddition: ColorData,
	DiffTextAdditionBackground: ColorData,
	DiffTextDeletion: ColorData,
	DiffTextDeletionBackground: ColorData,
	DiffTextHunkInfo: ColorData,
	DiffTextNoChange: ColorData,
	DiffTextNoChangeBackground: ColorData,
	DiffTextSeparatorBackground: ColorData,
	DimmedText: ColorData,
	DocViewCodeBackground: ColorData,
	Dropdown: ColorData,
	DropShadow: ColorData,
	EmulatorBar: ColorData,
	EmulatorDropDown: ColorData,
	ErrorText: ColorData,
	FilterButtonAccent: ColorData,
	FilterButtonBorder: ColorData,
	FilterButtonBorderAlt: ColorData,
	FilterButtonChecked: ColorData,
	FilterButtonDefault: ColorData,
	FilterButtonHover: ColorData,
	GameSettingsTableItem: ColorData,
	GameSettingsTooltip: ColorData,
	HeaderSection: ColorData,
	InfoBarWarningBackground: ColorData,
	InfoBarWarningText: ColorData,
	InfoText: ColorData,
	InputFieldBackground: ColorData,
	InputFieldBorder: ColorData,
	Item: ColorData,
	Light: ColorData,
	LinkText: ColorData,
	MainBackground: ColorData,
	MainButton: ColorData,
	MainText: ColorData,
	Mid: ColorData,
	Midlight: ColorData,
	Notification: ColorData,
	RibbonButton: ColorData,
	RibbonTab: ColorData,
	RibbonTabTopBar: ColorData,
	ScriptBackground: ColorData,
	ScriptBool: ColorData,
	ScriptBracket: ColorData,
	ScriptBuiltInFunction: ColorData,
	ScriptComment: ColorData,
	ScriptEditorCurrentLine: ColorData,
	ScriptError: ColorData,
	ScriptFindSelectionBackground: ColorData,
	ScriptFunction: ColorData,
	ScriptFunctionName: ColorData,
	ScriptKeyword: ColorData,
	ScriptLocal: ColorData,
	ScriptLuauKeyword: ColorData,
	ScriptMatchingWordSelectionBackground: ColorData,
	ScriptMethod: ColorData,
	ScriptNil: ColorData,
	ScriptNumber: ColorData,
	ScriptOperator: ColorData,
	ScriptProperty: ColorData,
	ScriptRuler: ColorData,
	ScriptSelectionBackground: ColorData,
	ScriptSelectionText: ColorData,
	ScriptSelf: ColorData,
	ScriptSideWidget: ColorData,
	ScriptString: ColorData,
	ScriptText: ColorData,
	ScriptTodo: ColorData,
	ScriptWarning: ColorData,
	ScriptWhitespace: ColorData,
	ScrollBar: ColorData,
	ScrollBarBackground: ColorData,
	SensitiveText: ColorData,
	Separator: ColorData,
	Shadow: ColorData,
	StatusBar: ColorData,
	SubText: ColorData,
	Tab: ColorData,
	TabBar: ColorData,
	TableItem: ColorData,
	Titlebar: ColorData,
	TitlebarText: ColorData,
	Tooltip: ColorData,
	ViewPortBackground: ColorData,
	WarningText: ColorData,
}

return false
