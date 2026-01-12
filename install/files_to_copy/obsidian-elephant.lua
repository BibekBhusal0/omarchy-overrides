Name = "obsidian"
NamePretty = "Obsidian"
Icon = "obsidian"
Placeholder = "Search Notes..."
Match = "Fuzzy"
Cache = true

Action = "obsidian '%VALUE%'"

local home = os.getenv("HOME")
local icon_dir = home .. "/.config/elephant/icons/"
local icon_note = icon_dir .. "obsidian-note.svg"
local icon_canvas = icon_dir .. "obsidian-canvas.svg"
local icon_base = icon_dir .. "obsidian-base.svg"

local function url_encode(str)
	if not str then
		return ""
	end
	str = str:gsub("\n", "\r\n")
	-- Encode non-alphanumeric chars (excluding standard safe chars)
	str = str:gsub("([^%w %-%_%.%~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
	return str:gsub(" ", "%%20")
end

function GetEntries()
	local entries = {}
	local vault_config = home .. "/.config/obsidian/obsidian.json"

	-- Check config existence
	local f = io.open(vault_config, "r")
	if f ~= nil then
		io.close(f)
	else
		return entries
	end

	-- Extract vault path using jq (matches your bash script logic for the 1st vault)
	local handle_vault = io.popen("jq -r '.vaults | to_entries | .[0].value.path' " .. vault_config)
	local vault_path = handle_vault:read("*a"):gsub("%s+", "")
	handle_vault:close()

	if vault_path == "" then
		return entries
	end

	-- Extract just the folder name from the path to use as the 'vault=' parameter
	-- e.g., /home/Documents/MyVault -> MyVault
	local vault_name = vault_path:match("([^/]+)$")
	local encoded_vault_name = url_encode(vault_name)

	-- FD: Search for md, canvas, and base
	local fd_cmd = "fd -e md -e canvas -e base --type file --strip-cwd-prefix --base-directory='" .. vault_path .. "'"
	local handle_fd = io.popen(fd_cmd)

	for relative_path in handle_fd:lines() do
		local path_lower = relative_path:lower()

		-- Filter: Ignore daily notes
		if not path_lower:find("daily") then
			local encoded_file = url_encode(relative_path)
			local uri = "obsidian://open?vault=" .. encoded_vault_name .. "&file=" .. encoded_file

			-- Defaults (Markdown Note)
			local current_icon = icon_note
			local subtext = "Note"
			local clean_name = relative_path:gsub("%.md$", ""):gsub("%.canvas$", ""):gsub("%.base$", "")

			-- Specific Icon Logic
			if relative_path:match("%.canvas$") then
				current_icon = icon_canvas
				subtext = "Canvas"
			elseif relative_path:match("%.base$") then
				current_icon = icon_base
				subtext = "Base"
			end

			table.insert(entries, {
				Text = clean_name,
				Subtext = subtext,
				Value = uri,
				Icon = current_icon,
			})
		end
	end
	handle_fd:close()

	return entries
end
