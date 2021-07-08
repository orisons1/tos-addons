----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local addonName = "QUICKMATCHING"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local QuickMatching = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
CHAT_SYSTEM("quickmatching.lua is loaded.");
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKMATCHING_ON_INIT(addon, frame)

	QuickMatching.addon = addon;
	QuickMatching.frame = frame;
	
	acutil.slashCommand("/qm", QUICKMATCHING_PROCESS_COMMAND);	
	acutil.slashCommand("/챌", QUICKMATCHING_PROCESS_COMMAND);
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKMATCHING_PROCESS_COMMAND(command)
    
	local pc = GetMyPCObject();
	local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);	
	end

   		
	if cmd == "1" or cmd == "2" or cmd == "3" or cmd == "4" then 	
		-- 매칭 던전중이거나 pvp존이면 이용 불가
		if session.world.IsIntegrateServer() == true or IsPVPField(pc) == 1 or IsPVPServer(pc) == 1 then
			ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
			return;
		end

		-- 퀘스트나 챌린지 모드로 인해 레이어 변경되면 이용 불가
		if world.GetLayer() ~= 0 then
			ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
			return;
		end

		-- 레이드 지역에서 이용 불가
		local curMap = GetClass('Map', session.GetMapName());
		local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None');
		local keywordTable = StringSplit(zoneKeyword, ';');
		if table.find(keywordTable, 'IsRaidField') > 0 or table.find(keywordTable, 'WeeklyBossMap') > 0 then
			ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
			return;
		end
      
	
		if cmd == "1" or cmd == "2" or cmd == "3" then
			if (GET_CURRENT_ENTERANCE_COUNT(815) == GET_INDUN_MAX_ENTERANCE_COUNT(815)) then
				ui.SysMsg("[qm] 오늘은 더 이상 참여할 수 없습니다.");
				return;
			end
		elseif cmd == "4" then
			if (GET_CURRENT_ENTERANCE_COUNT(816) == 0) then
				ui.SysMsg("[qm] 오늘은 더 이상 참여할 수 없습니다.");
				return;
			end
		end


		local indunCls;
		local matchType;
		local multipleCnt = 0;
		
		if cmd == "1" then
			indunCls = 644;
			matchType = 1;
		elseif cmd == "2" then
			indunCls = 645;
			matchType = 2;				
		elseif cmd == "3" then
			indunCls = 646;
			matchType = 2;				
		elseif cmd == "4" then
			indunCls = 647;	
			matchType = 2;
		end
	

		ReqChallengeAutoUIOpen(indunCls);		
		local strScp = string.format("ReqMoveToIndun(\"%s\", \"%s\")", matchType, multipleCnt);
		ReserveScript(strScp, 0.5);
		
	else	
		ui.SysMsg("[qm] Invalid Command.");		
	end
	

end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------