----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------- 
local addonName = "GPBREAKER"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local GPBreaker = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
ui.SysMsg(string.format("%s"..".lua is loaded.",addonNameLower));
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
GPBreaker.msgtable = {

	"FIELDBOSS_WORLD_EVENT_WIN_MSG",
	"NOTICE_READY_FIELDBOSS_WORLD_EVENT",
	"NOTICE_START_FIELDBOSS_WORLD_EVENT",
	"NOTICE_END_FIELDBOSS_WORLD_EVENT",
}
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function GPBREAKER_ON_INIT(addon, frame)

	GPBreaker.addon = addon;
	GPBreaker.frame = frame;

	frame:ShowWindow(0);
	
	acutil.setupHook(GPBREAKER_HOOK_NOTICE_ON_MSG, 'NOTICE_ON_MSG')
	acutil.setupHook(GPBREAKER_HOOK_MINIMIZED_GODPROTECTION_STARTT, 'MINIMIZED_GODPROTECTION_START')
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function GPBREAKER_HOOK_NOTICE_ON_MSG(frame, msg, argStr, argNum)


	if msg == "NOTICE_Dm_Global_Shout" then 
	
		local IsFound = false;
	
		for index, value in ipairs(GPBreaker.msgtable) do
			if string.find(argStr,value) ~= nil then 
				IsFound = true;
				return;
			end
		end
		
		if IsFound == false then
			return NOTICE_ON_MSG_OLD(frame, msg, argStr, argNum);
		end
	else
		return NOTICE_ON_MSG_OLD(frame, msg, argStr, argNum);
	end
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function GPBREAKER_HOOK_MINIMIZED_GODPROTECTION_STARTT(frame)

	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);	
    if IS_GODPROTECTION_MAP(mapCls) == false then
        frame:ShowWindow(0);
    else
    	frame:ShowWindow(0);
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	local font = frame:GetUserConfig("TIME_FONT_NOMAL");
	time:SetFormat(font.."%s:%s");
	time:ReleaseBlink();

	-- 남은 시간 설정
	MINIMIZED_GODPROTECTION_REMAIN_TIME(frame);
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
