----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local addonName = "gfe"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local gfe = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
CHAT_SYSTEM("gfe.lua is loaded.");
gfe.working = 1;
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function GFE_ON_INIT(addon, frame)

	gfe.addon = addon;
	gfe.frame = frame;
	
	addon:RegisterMsg('FISHING_SUCCESS_COUNT', 'GFE_CAPTURE_MSG');
	acutil.slashCommand("/gfe", 'GFE_PROCESS_COMMAND');
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function GFE_CAPTURE_MSG(frame, msg, argStr, argNum)

	if gfe.working == 1 then 

		if argNum == 1 and argStr ~= nil and argStr ~= "None" then
			local itemList = session.GetEtcItemList(IT_FISHING);
			if itemList:Count() < 1 then
				ui.SysMsg(ClMsg('YouDontHaveAnyItemToTake'));
			elseif itemList:Count()>= 5 then
				Fishing.ReqGetFishingItem();	
				ui.SysMsg("[gfe] 살림통을 비웠습니다.");
			end
		end
		
	end

end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

function GFE_PROCESS_COMMAND(command)
    
	local cmd = "";
	if #command > 0 then
		cmd = table.remove(command, 1);	
	
		if cmd == "on" then
			gfe.working = 1;
			ui.SysMsg("[gfe] Enabled.");
		elseif cmd == "off" then
			gfe.working = 0;
			ui.SysMsg("[gfe] Disabled.");
		else
			ui.SysMsg("[gfe] Invalid Command.");
		end
	end
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------