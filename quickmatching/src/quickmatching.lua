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
local SoloBuff = { [1]=190019, [2]=190020, [3]=190021, [4]=190022, [5]=190008 };
local PartyBuff = { [1]=190003, [2]=190004, [3]=190005, [4]=190006 };

QuickMatching.settings = { SoloBuffNumber = 0, PartyBuffNumber = 0 };

----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKMATCHING_ON_INIT(addon, frame)

	
	QuickMatching.addon = addon;
	QuickMatching.frame = frame;

	QuickMatching.CID = session.GetMySession():GetCID();
	
	QuickMatching.settingsFileLoc = string.format("../addons/%s/%s.json", addonNameLower, QuickMatching.CID);

	local t, err = acutil.loadJSON(QuickMatching.settingsFileLoc, QuickMatching.settings);
	if err then
		CHAT_SYSTEM("[qm] Cannot load setting files.");
		QuickMatching.settings = { SoloBuffNumber = 0, PartyBuffNumber = 0 };
	else
		QuickMatching.settings = t;
	end
			
	QUICKMATCHING_SAVE_SETTINGS();	
	
	addon:RegisterMsg('GAME_START_3SEC',"QUICKMATCHING_SELECT_BUFF");
	acutil.slashCommand("/qm", QUICKMATCHING_PROCESS_COMMAND);	
	acutil.slashCommand("/챌", QUICKMATCHING_PROCESS_COMMAND);
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKMATCHING_SAVE_SETTINGS()
	acutil.saveJSON(QuickMatching.settingsFileLoc, QuickMatching.settings);
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function QUICKMATCHING_SELECT_BUFF()

	local MapName = session.GetMapName();

	if MapName == "Challenge_shadow_raid_main" or 
		MapName == "Challenge_d_thorn_39_2" or 
			MapName == "Challenge_Division_d_cathedral_78_1" then
		if SoloBuff[QuickMatching.settings.SoloBuffNumber]== nil or
			PartyBuff[QuickMatching.settings.PartyBuffNumber] == nil then
			ui.SysMsg("[qm] 자동으로 선택할 버프를 설정하지 않아 선택하지 않았습니다.")
			return
		end

		SelectSoloBuff(SoloBuff[QuickMatching.settings.SoloBuffNumber], 0);
		SelectPartyBuff(PartyBuff[QuickMatching.settings.PartyBuffNumber]);
		ui.GetFrame('select_mgame_buff_party'):ShowWindow(false);
	end
	
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
		if cmd == "1" then
			ui.SysMsg("[qm] 1단계는 지원하지 않습니다.");
			return;
		end
		
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
		local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None');
		local keywordTable = StringSplit(zoneKeyword, ';');
		if table.find(keywordTable, 'IsRaidField') > 0 or table.find(keywordTable, 'WeeklyBossMap') > 0 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
        return;
		end
      
	
		if cmd == "2" or cmd == "3" then
			if (GET_CURRENT_ENTERANCE_COUNT(815) == GET_INDUN_MAX_ENTERANCE_COUNT(815)) then
				ui.SysMsg("[qm] 오늘은 더 이상 참여할 수 없습니다.")
				return
			end
		elseif cmd == "4" then
			if (GET_CURRENT_ENTERANCE_COUNT(816) == 0) then
				ui.SysMsg("[qm] 오늘은 더 이상 참여할 수 없습니다.")
				return
			end
		end


		local code;
		
		if cmd == "2" then
			if pc.Lv < 400  then
				ui.SysMsg("[qm] 레벨 조건이 맞지않습니다.")
				return
			else
				code = 645;
			end
		elseif cmd == "3" then
			if pc.Lv < 450 then
				ui.SysMsg("[qm] 레벨 조건이 맞지않습니다.")
				return
			else
				code = 646;			
			end
		elseif cmd == "4" then
			if pc.Lv < 450 then
				ui.SysMsg("[qm] 레벨 조건이 맞지않습니다.")
				return
			else
				code = 647;			
			end
		end


		
		ReqChallengeAutoUIOpen(code);
				
		local textObj = ui.GetFrame('dialog'):GetChild('textlist')
		tolua.cast(textObj, 'ui::CFlowText');
		textObj:PassAllText();
		session.SetSelectDlgList();
		ui.OpenFrame('dialogselect');
		control.DialogSelect(1); 
		ReserveScript("control.DialogCancel()",0.5);
		ReserveScript("ReqMoveToIndun(2, 0)",0.7);
		return;		
		
	elseif cmd == "buff" then
		if #command > 0 then
			cmd = table.remove(command, 1);	
		end
		local sb = tonumber(cmd);
		CHAT_SYSTEM(cmd);
		if #command > 0 then
			cmd = table.remove(command, 1);	
		end
		CHAT_SYSTEM(cmd);
		local pb = tonumber(cmd);
		
		if SoloBuff[sb] == nil and PartyBuff[pb] == nil then
			ui.SysMsg("[qm] Invalid Parameter.");
			return;
		end
		QuickMatching.settings.SoloBuffNumber = sb;
		QuickMatching.settings.PartyBuffNumber = pb;
		QUICKMATCHING_SAVE_SETTINGS();
		ui.SysMsg("[qm] Save Buff Select Parameter.");
	else	
		ui.SysMsg("[qm] Invalid Command.");		
	end
	

end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

