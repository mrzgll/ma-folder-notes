--------------------------------------------------------------------------------
-- Folder Notes Plugin (folder_notes.lrdevplugin)
-- PluginInfoProvider.lua

-- Manage the configuration of the plugin within the Lightroom Plugin Manager.

-- This will create a section in the Plugin Manager Dialog window.
--------------------------------------------------------------------------------
local lr_view = import 'LrView'
local lr_http = import 'LrHttp'
local lr_color = import 'LrColor'
local lr_prefs = import 'LrPrefs'.prefsForPlugin()
local bind = lr_view.bind

lr_prefs.pattern1 = lr_prefs.pattern1 or lr_prefs.digitalPattern or ""
lr_prefs.pattern2 = lr_prefs.pattern2 or lr_prefs.analogPattern or ""

local function sections_for_top_of_dialog(_, _)
	local factory = lr_view.osFactory()

	return {
		{
			title = "Configuration",

			factory:column {
				spacing = factory:control_spacing(),
				bind_to_object = lr_prefs,
				factory:static_text {
					title =
						"This plugin associates plain-text notes with Lightroom folders.\n" ..
						"Each note is a .txt file stored in the notes folder and opened with your editor.\n\n" ..
						"NOTE FILE PATTERNS\n" ..
						"Up to two Lua patterns can be defined to extract the folder identifier (FID)\n" ..
						"from the folder name. Each pattern should capture the complete FID in one group.",
				},
				factory:static_text {
					title = "More info on Lua patterns (click to open in browser)",
					text_color = lr_color(0, 0.3, 0.8),
					mouse_down = function()
						lr_http.openUrlInBrowser("https://gist.github.com/spr2-dev/46ca9f4a6f933fa266bccd87fd15d09a")
					end,
				},
				factory:static_text {
					title =
						"Pattern 1 is tried first; Pattern 2 only if Pattern 1 does not capture a FID.\n" ..
						"They can match folder names following two different naming conventions,\n" ..
						"e.g. native digital photos and digitized analog photos.\n" ..
						"The note filename is the captured FID followed by .txt.\n\n" ..
						"Pattern 1 example (native digital photos): ^(%d%d%d%d[-_]%d%d[-_]%d%d[-_]%w+)\n" ..
						"   2024-12-15-A7II-Cagliari  ->  FID = 2024-12-15-A7II  ->  2024-12-15-A7II.txt\n" ..
						"   2025_01_05_Df_Pisa  ->  FID = 2025_01_05_Df  ->  2025_01_05_Df.txt\n\n" ..
						"Pattern 2 example (digitized analog photos): ^(%w+%-%d%d%d%d%w*)%-%d%d%d%d\n" ..
						"   s-0128-1999  ->  FID = s-0128  ->  s-0128.txt\n" ..
						"   (The FID is the roll ID.)\n\n" ..
						"Only the captured parts of the folder name are used to form the note filename.\n" ..
						"This means you can add or change a suffix in the folder name without breaking its\n" ..
						"association with the note file, as long as the captured parts remain the same.\n\n" ..
						"FILE SYSTEM PATHS\n" ..
						"Notes folder path: directory where note files are stored. Use a folder that is\n" ..
						"always available and add it to your backup procedure.\n\n" ..
						"Notes editor path: path to your preferred text editor.\n\n" ..
						"Editor options: optional command-line options passed to the editor before the\n" ..
						"note path, e.g. -nosession for Notepad++. Leave it empty for editors that do not\n" ..
						"need options (for example Notepad, which does not accept -nosession).",
				},

				factory:static_text {
					title = " ",
				},

				factory:row {
					factory:static_text {
						title = "Pattern 1:",
						alignment = "right",
						width = 100,
					},
					factory:edit_field {
						value = bind "pattern1",
						width_in_chars = 50,
					},
				},
				factory:row {
					factory:static_text {
						title = "Pattern 2:",
						alignment = "right",
						width = 100,
					},
					factory:edit_field {
						value = bind "pattern2",
						width_in_chars = 50,
					},
				},

				factory:row {
					spacing = factory:label_spacing(),
					factory:static_text {
						title = "Notes folder path:",
						alignment = "right",
						width = 100,
					},
					factory:edit_field {
						value = bind "notesFolderPath",  -- THIS writes automatically to prefs
						width_in_chars = 50,
					},
				},

				factory:row {
					spacing = factory:label_spacing(),
					factory:static_text {
						title = "Notes editor path:",
						alignment = "right",
						width = 100,
					},
					factory:edit_field {
						value = bind "editorPath",  -- Same here
						width_in_chars = 50,
					},
				},

				factory:row {
					spacing = factory:label_spacing(),
					factory:static_text {
						title = "Editor options:",
						alignment = "right",
						width = 100,
					},
					factory:edit_field {
						value = bind "editorOptions",  -- optional command-line options, e.g. -nosession
						width_in_chars = 50,
					},
				},

				factory:static_text {
					title = " ",
				},
				
			}
		},

		{
			title = "Usage",

			factory:column {
				spacing = factory:control_spacing(),
				factory:static_text {
					title =
						"1. In the Library module, select a folder.\n" ..
						"2. Go to \"Library → Plug-in Extras → Open folder notes\".\n" ..
						"3. The note file is opened in the configured editor. If it does not exist, the\n" ..
						"    editor creates it.\n" ..
						"4. When you are done editing, save your notes.",
				},
			}
		}
	}
end

return {
	sectionsForTopOfDialog = sections_for_top_of_dialog,
}
