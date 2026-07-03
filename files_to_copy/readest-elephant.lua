Name = "readest"
NamePretty = "Readest"
Icon = "com.bilingify.readest"
Placeholder = "Search Books..."
Match = "Fuzzy"
Cache = true

local home = os.getenv("HOME")

local LIB_DIR = home .. "/.var/app/com.bilingify.readest/data/com.bilingify.readest/Readest/Books"
local LIB_JSON = LIB_DIR .. "/library.json"

Action = "flatpak run com.bilingify.readest -- '%VALUE%'"

function GetEntries()
	local entries = {}

	local f = io.open(LIB_JSON, "r")
	if not f then
		return entries
	end
	f:close()

	local handle = io.popen("jq -r '.[] | [.title, .hash, (.author // \"\")] | @tsv' '" .. LIB_JSON .. "'")

	if not handle then
		return entries
	end

	for line in handle:lines() do
		local title, hash, author = line:match("([^\t]*)\t([^\t]*)\t?(.*)")

		if title and hash then
			local fd = io.popen("fd -a -d1 -e epub -e pdf . '" .. LIB_DIR .. "/" .. hash .. "' | head -n1")

			if fd then
				local book = fd:read("*l")
				fd:close()

				if book and book ~= "" then
					table.insert(entries, {
						Text = title,
						Subtext = author,
						Value = book,
						Icon = "com.bilingify.readest",
						Preview = LIB_DIR .. "/" .. hash .. "/cover.png",
					})
				end
			end
		end
	end

	handle:close()

	return entries
end
