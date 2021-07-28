----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local addonName = "QUICKTRADE"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local QuickTrade = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
CHAT_SYSTEM(string.format("%s"..".lua is loaded.",addonNameLower));
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKTRADE_ON_INIT(addon, frame)

	QuickTrade.addon = addon;
	QuickTrade.frame = frame;

	frame:ShowWindow(0);

	acutil.slashCommand("/qt", QUICKTRADE_PROCESS_COMMAND);
	acutil.slashCommand("/거래", QUICKTRADE_PROCESS_COMMAND);		
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKTRADE_PROCESS_COMMAND(command)
    
	local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);	
	end
	
	local IsFound = false;
	local myHandle = session.GetMyHandle();
	local foundList, foundCount = SelectObject(GetMyPCObject(), 10000, 'ALL')
	
	for i = 1, foundCount do
		local handle = GetHandle(foundList[i])
		local targetInfo = info.GetTargetInfo(handle);
		local familyName = info.GetFamilyName(handle);
		if handle ~= myHandle and targetInfo.IsDummyPC ~= 1 then	
			if tostring(familyName) == cmd then
				IsFound = true;
				exchange.RequestChange(handle);
				break;
			end		
		end
	end
  
	if IsFound == false then 
		ui.SysMsg(string.format("[QuickTrade][Alert] %s 팀을 찾을 수 없습니다.", cmd));	
	end
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
