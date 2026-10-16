--------------------------------------------------------------------------------
-- Folder Notes Plugin (folder_notes.lrdevplugin)
-- Info.lua

-- This plugin allows associating textual notes to a Lightroom Classic folder
--------------------------------------------------------------------------------

return {
	LrLibraryMenuItems = {{                               -- Main menu entries in Library module
		title = "Open folder notes",
		file = "FolderNotes.lua",
	}},
	LrPluginInfoUrl = "https://example.com/coming-soon",  -- URL of web page that provides information for the plugin
	LrPluginInfoProvider = "PluginInfoProvider.lua",      -- Name of the Lua file to be executed when the plugin is loaded
	LrPluginName = "MA Folder Notes",                     -- This string appears in the Plug-in Manager dialog

	LrSdkVersion = 14.0,
	LrSdkMinimumVersion = 3.0,  -- Minimum SDK version required by this plug-in

	LrToolkitIdentifier = "com.mrzgll.foldernotes",       -- Unique identifier of the plugin

	VERSION = { major = 1, minor = 1 },
}