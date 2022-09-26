_PersonalMenu.filterArray = {
	{ Name = "Aucun", Value = "" },
	{ Name = "A", Value = "A" },
	{ Name = "B", Value = "B" },
	{ Name = "C", Value = "C" },
	{ Name = "D", Value = "D" },
	{ Name = "E", Value = "E" },
	{ Name = "F", Value = "F" },
	{ Name = "G", Value = "G" },
	{ Name = "H", Value = "H" },
	{ Name = "I", Value = "I" },
	{ Name = "J", Value = "J" },
	{ Name = "K", Value = "K" },
	{ Name = "L", Value = "L" },
	{ Name = "M", Value = "M" },
	{ Name = "N", Value = "N" },
	{ Name = "O", Value = "O" },
	{ Name = "P", Value = "P" },
	{ Name = "Q", Value = "Q" },
	{ Name = "R", Value = "R" },
	{ Name = "S", Value = "S" },
	{ Name = "T", Value = "T" },
	{ Name = "U", Value = "U" },
	{ Name = "V", Value = "V" },
	{ Name = "W", Value = "W" },
	{ Name = "X", Value = "X" },
	{ Name = "Y", Value = "Y" },
	{ Name = "Z", Value = "Z" },
}
_PersonalMenu.index = {
	filter = 1
}
_PersonalMenu.Filter = _PersonalMenu.filterArray[1].Value

function _PersonalMenu:start(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end