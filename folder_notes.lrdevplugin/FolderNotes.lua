--------------------------------------------------------------------------------
-- Folder Notes Plugin (folder_notes.lrdevplugin)
-- FolderNotes.lua

-- Main logic for handling folder notes in Lightroom.
--------------------------------------------------------------------------------

local lr_application = import 'LrApplication'
local lr_dialogs = import 'LrDialogs'
local lr_prefs = import 'LrPrefs'.prefsForPlugin()
local lr_path_utils = import 'LrPathUtils'
local lr_tasks = import 'LrTasks'
local lr_file_utils = import 'LrFileUtils'


-- Return the first pattern's capture, or use the second pattern if needed.
local function extract_note_id(folder_name)
	local pattern1 = lr_prefs.pattern1 or lr_prefs.digitalPattern or ""
	local pattern2 = lr_prefs.pattern2 or lr_prefs.analogPattern or ""

	local c1 = folder_name:match(pattern1)
	if c1 then
		return c1
	end

	return folder_name:match(pattern2)
end

-- Main
function open_folder_note()
	local catalog = lr_application.activeCatalog()
	local sources = catalog:getActiveSources()

	if #sources ~= 1 then
		lr_dialogs.message("Select one folder",
			"Please select exactly one folder.",
			"warning")
		return
	end

	local folder = sources[1]
	if folder:type() ~= "LrFolder" then
		lr_dialogs.message("Invalid selection",
			"Please select a folder.",
			"error")
		return
	end

	local folder_name = folder:getName()
	local c1 = extract_note_id(folder_name)

	if not c1 then
		lr_dialogs.message("Cannot determine note filename",
			"Folder name does not match either configured pattern.",
			"error")
		return
	end

	-- Load preferences
	local notes_folder = lr_prefs.notesFolderPath or ""
	local editor = lr_prefs.editorPath or ""

	if notes_folder == "" or editor == "" then
		lr_dialogs.message("Plugin not configured",
			"Please set notes folder and editor path in the Plugin Manager.",
			"warning")
		return
	end

	if lr_file_utils.exists(notes_folder) ~= "directory" then
		lr_dialogs.message("Invalid notes folder",
			"The configured notes folder does not exist or is not a directory:\n" .. notes_folder,
			"error")
		return
	end

	-- Prepare note file
	local note_path = lr_path_utils.child(notes_folder, c1 .. ".txt")

	-- Open with editor
	lr_tasks.startAsyncTask(function()
		local editor_path = tostring(editor)
		local file_path = tostring(note_path)
		local options = tostring(lr_prefs.editorOptions or "")
		if options ~= "" then
			options = options .. " "
		end
		local command = string.format('cmd /c start "" "%s" %s"%s"', editor_path, options, file_path)
		lr_tasks.execute(command)
	end)
end

-- Start async task
lr_tasks.startAsyncTask(open_folder_note, "runPlugin")