----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local addonName = "KRMEMBERINFO"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local KrMemberinfo = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
CHAT_SYSTEM(string.format("%s"..".lua is loaded.",addonNameLower));
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function KRMEMBERINFO_ON_INIT(addon, frame)

	KrMemberinfo.addon = addon;
	KrMemberinfo.frame = frame;
	
	acutil.slashCommand("/보기", KRMEMBERINFO_PROCESS_COMMAND);
	acutil.slashCommand("/관음", KRMEMBERINFO_PROCESS_COMMAND);	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function KRMEMBERINFO_PROCESS_COMMAND(command)
 
	local cmd = "";
	local str = "/memberinfo ";
	
	if #command > 0 then
		cmd = table.remove(command, 1);
		ui.Chat(str..cmd.."\n")	
	end
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
