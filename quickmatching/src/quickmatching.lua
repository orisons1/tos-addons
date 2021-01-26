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
ui.SysMsg(string.format("%s"..".lua is loaded.",addonNameLower));
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
QuickMatching.delay = 0; 
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
    
	local pc = GetMyPCObject()
	local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);	
	end

	if cmd == "1" or cmd == "2" or cmd == "3" or cmd == "4" or cmd == "5" or cmd == "6" then 
    	
		-- 매칭 던전중이거나 pvp존이면 이용 불가
		if session.world.IsIntegrateServer() == true or IsPVPField(pc) == 1 or IsPVPServer(pc) == 1 then
			ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
			return
		end
		-- 퀘스트나 챌린지 모드로 인해 레이어 변경되면 이용 불가
		if world.GetLayer() ~= 0 then
			ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
			return
		end
		-- 레이드 지역에서 이용 불가
		local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None')
		local keywordTable = StringSplit(zoneKeyword, ';')
		if table.find(keywordTable, 'IsRaidField') > 0 or table.find(keywordTable, 'WeeklyBossMap') > 0 then
        	ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        	return
		end  
	end
	
	if cmd == "1" then
		if pc.Lv >= 400 or pc.Lv < 361 then
			ui.SysMsg("레벨 조건이 맞지않습니다.")
			return;
		end
		if (GET_CURRENT_ENTERANCE_COUNT(815) == GET_INDUN_MAX_ENTERANCE_COUNT(815)) then
			ui.SysMsg("오늘은 더 이상 참여할 수 없습니다.")
			return;
		end
		ReqChallengeAutoUIOpen(644);
		session.SetSelectDlgList();    
		ui.OpenFrame('dialogselect');
		control.DialogSelect(1); 	
		ReserveScript("control.DialogCancel()",0.5+QuickMatching.delay);
		ReserveScript("ReqMoveToIndun(2, 0)",1+QuickMatching.delay);
		return	
	elseif cmd == "2" then
		if pc.Lv < 400 then
			ui.SysMsg("레벨 조건이 맞지않습니다.")
			return
		end
		if (GET_CURRENT_ENTERANCE_COUNT(815) == GET_INDUN_MAX_ENTERANCE_COUNT(815)) then
			ui.SysMsg("오늘은 더 이상 참여할 수 없습니다.")
			return
		end
		ReqChallengeAutoUIOpen(645);
		session.SetSelectDlgList();    
		ui.OpenFrame('dialogselect');
		control.DialogSelect(1); 	
		ReserveScript("control.DialogCancel()",0.5+QuickMatching.delay);
		ReserveScript("ReqMoveToIndun(2, 0)",1+QuickMatching.delay);
		return	
	elseif cmd == "3" then
		if pc.Lv < 450 then
			ui.SysMsg("레벨 조건이 맞지않습니다.")
			return
		end
		if (GET_CURRENT_ENTERANCE_COUNT(815) == GET_INDUN_MAX_ENTERANCE_COUNT(815)) then
			ui.SysMsg("오늘은 더 이상 참여할 수 없습니다.")
			return
		end
		ReqChallengeAutoUIOpen(646);
		session.SetSelectDlgList();    
		ui.OpenFrame('dialogselect');
		control.DialogSelect(1); 	
		ReserveScript("control.DialogCancel()",0.5+QuickMatching.delay);
		ReserveScript("ReqMoveToIndun(2, 0)",1+QuickMatching.delay);
		return	
	elseif cmd == "4" then
		if pc.Lv < 450 then
			ui.SysMsg("레벨 조건이 맞지않습니다.")
			return
		end		
		if(GET_CURRENT_ENTERANCE_COUNT(816) == 0) then
			ui.SysMsg("오늘은 더 이상 참여할 수 없습니다.")
			return
		end		
		ReqChallengeAutoUIOpen(647);
		session.SetSelectDlgList();    
		ui.OpenFrame('dialogselect');
		control.DialogSelect(1); 	
		ReserveScript("control.DialogCancel()",0.5+QuickMatching.delay);
		ReserveScript("ReqMoveToIndun(2, 0)",1+QuickMatching.delay);
		return		
	elseif cmd == "delay1" or cmd == "딜레이1" then
		QuickMatching.delay=0;
		ui.SysMsg("QuickMatching delay 0")
		return
	elseif cmd == "delay2" or cmd == "딜레이2" then
		QuickMatching.delay=0.5;
		ui.SysMsg("QuickMatching delay 0 + 0.5")
		return
	elseif cmd == "delay3" or cmd == "딜레이3" then
		QuickMatching.delay=1;
		ui.SysMsg("QuickMatching delay 0 + 1.0")
		return			
	else	
		ui.SysMsg("명령어 => /챌 or /qm")
		ui.SysMsg("파라미터 =>   1,  2,   3,  4,  5,  6")
		ui.SysMsg("파라미터 =>   delay1,  delay2,   delay3")
		ReserveScript("ui.SysMsg(\"파라미터 =>   딜레이1,  딜레이2,   딜레이3\")",3);
		ReserveScript("ui.SysMsg(\"ex) /챌 4 (= 자동분열), /qm 3 (= 자동챌 3지역)\")",3);
		ReserveScript("ui.SysMsg(\"ex) /챌 딜레이1 (= 기본), /qm delay3 (= +1.0초)\")",3);
		ReserveScript("ui.SysMsg(\"Tip) Hotkey Addon과 같이 사용하면 좋습니다.\")",6);
	end
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
