----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
local addonName = "FKOFF"
local addonNameUpper = string.upper(addonName)
local addonNameLower = string.lower(addonName)

local author = 'tester'
local authorUpper = string.upper(author)
local authorLower = string.lower(author)

_G['ADDONS'] = _G['ADDONS'] or {}
_G['ADDONS'][authorUpper] = _G['ADDONS'][authorUpper] or {}
_G['ADDONS'][authorUpper][addonNameUpper] = _G['ADDONS'][authorUpper][addonNameUpper] or {}
local FkOff = _G['ADDONS'][authorUpper][addonNameUpper]
local acutil = require('acutil');
FkOff.settingsFileLoc = string.format("../addons/%s/settings.json", addonNameLower);
CHAT_SYSTEM(string.format("%s"..".lua is loaded.",addonNameLower));
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
if not FkOff.loaded then

	FkOff.settings = {
	
		kicktable = {},
		mode = "alert"		
	};
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function FKOFF_ON_INIT(addon, frame)

	FkOff.addon = addon;
	FkOff.frame = frame;

	frame:ShowWindow(0);
	
	if not FkOff.loaded then
		local t, err = acutil.loadJSON(FkOff.settingsFileLoc, FkOff.settings);
		if err then
			CHAT_SYSTEM(string.format("[%s][%s] cannot load setting files.", addonName, FkOff.settings.mode));
		else
			FkOff.settings = t;
		end
		FkOff.loaded = true;
	end

	FKOFF_SAVE_SETTINGS();
	
	addon:RegisterMsg('PARTY_UPDATE',"FKOFF_IDK_HOWTODELAY");
		
	acutil.slashCommand("/FKOFF", FKOFF_PROCESS_COMMAND);
	acutil.slashCommand("/fkoff", FKOFF_PROCESS_COMMAND);
	acutil.slashCommand("/꺼져", FKOFF_PROCESS_COMMAND);
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function FKOFF_SAVE_SETTINGS()
	acutil.saveJSON(FkOff.settingsFileLoc, FkOff.settings);
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function FKOFF_IDK_HOWTODELAY()
	ReserveScript("FKOFF_PARTY_UPDATE()",3)
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function FKOFF_PARTY_UPDATE()
	
	local MyName = info.GetFamilyName(session.GetMyHandle());
	
	if session.party.GetPartyInfo() ~= nil then	
		local memList = session.party.GetPartyMemberList(PARTY_NORMAL);
		if memList:Count() > 1 then
			for i = 0 , memList:Count() - 1 do 
				local memInfo = memList:Element(i);	
				local targetName = tostring(memInfo:GetName());	
				for index, value in pairs(FkOff.settings.kicktable) do
					if targetName == value and MyName ~= value then
						local IsLeader = AM_I_LEADER(PARTY_NORMAL);
						if IsLeader == 1 and FkOff.settings.mode == "kick" then
							local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None');
							local keywordTable = StringSplit(zoneKeyword, ';');
							if session.world.IsIntegrateServer() == true or table.find(keywordTable, 'IsRaidField') > 0 or world.GetLayer() ~= 0 then
								ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 가입하였습니다.",addonName, FkOff.settings.mode));
							else
								ui.Chat("/partyban PARTY_NORMAL "..value.."\n");
								ui.SysMsg(string.format("[%s][%s] 등록된 팀을 강퇴시켰습니다.",addonName, FkOff.settings.mode));
							end
							
						elseif IsLeader == 1 and FkOff.settings.mode == "kickPlus" then
							local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None');
							local keywordTable = StringSplit(zoneKeyword, ';');
							if session.world.IsIntegrateServer() == true or table.find(keywordTable, 'IsRaidField') > 0 or world.GetLayer() ~= 0 then
								ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 가입하여 숙소로 이동합니다.",addonName, FkOff.settings.mode));
								APPS_TRY_MOVE_BARRACK();
							else
								ui.Chat("/partyban PARTY_NORMAL "..value.."\n");
								ui.SysMsg(string.format("[%s][%s] 등록된 팀을 강퇴시켰습니다.",addonName, FkOff.settings.mode));
							end
							
						elseif IsLeader == 0 and FkOff.settings.mode == "kickPlus" then
							local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None');
							local keywordTable = StringSplit(zoneKeyword, ';');
							if session.world.IsIntegrateServer() == true or table.find(keywordTable, 'IsRaidField') > 0 or world.GetLayer() ~= 0 then
								ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 존재하여 숙소로 이동합니다.",addonName, FkOff.settings.mode));
								APPS_TRY_MOVE_BARRACK();
							else
								ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 존재하여 파티를 탈퇴합니다.",addonName, FkOff.settings.mode));
								OUT_PARTY();
							end
							
						elseif IsLeader == 0 and FkOff.settings.mode == "kick" then
							ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 가입하였습니다.",addonName, FkOff.settings.mode));
						elseif FkOff.settings.mode == "alert" then
							ui.SysMsg(string.format("[%s][%s] 등록된 팀이 파티에 가입하였습니다.",addonName, FkOff.settings.mode));
						end		
					end
				end
			end
		end
	end
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
function FKOFF_PROCESS_COMMAND(command)

	
	local MyName = info.GetFamilyName(session.GetMyHandle());
	
	local cmd = "";
	
	if #command > 0 then
		cmd = table.remove(command, 1);	
	end
			
	if cmd == "add" or cmd =="추가" then 
	
		if #command > 0 then
			cmd = table.remove(command, 1);	
		else
			ui.SysMsg(string.format("[%s][%s] 잘못된 파라미터 입니다.",addonName, FkOff.settings.mode));
			return;
		end
		
		local IsFound = false;
		
		for index, value in pairs(FkOff.settings.kicktable) do
			if cmd == value then
				IsFound = true;
				ui.SysMsg(string.format("[%s][%s] 이미 등록된 팀입니다.",addonName, FkOff.settings.mode));
				return;
			end
		end
		
		if IsFound == false then 
			table.insert(FkOff.settings.kicktable, cmd);
			FKOFF_SAVE_SETTINGS()
			ui.SysMsg(string.format("[%s][%s] 팀 목록에 추가 : %s",addonName, FkOff.settings.mode, cmd));
		end			
		
			
	elseif cmd == "delete" or cmd == "삭제" then

		if #command > 0 then
			cmd = table.remove(command, 1);	
		else
			ui.SysMsg(string.format("[%s][%s] 잘못된 파라미터 입니다.",addonName, FkOff.settings.mode));
			return;
		end
		
		local IsFound = false;
		
		for index, value in pairs(FkOff.settings.kicktable) do
			if cmd == value then
				IsFound = true;
				table.remove(FkOff.settings.kicktable, index);
				FKOFF_SAVE_SETTINGS();
				ui.SysMsg(string.format("[%s][%s] 팀 목록에서 삭제 : %s",addonName, FkOff.settings.mode, cmd));
				return;
			end
		end
		
		if IsFound == false then
			ui.SysMsg(string.format("[%s][%s] 목록에 해당 팀이 존재하지 않습니다.",addonName, FkOff.settings.mode));
		end
		
		return;
	
	
	elseif cmd == "list" or cmd == "목록" then
	
		ui.SysMsg(string.format("[%s][%s] 등록된 팀 목록이 시스템 메시지에 출력됩니다.",addonName, FkOff.settings.mode));
		
		for index, value in pairs(FkOff.settings.kicktable) do
			CHAT_SYSTEM(string.format("%s : %s",index, value));		
		end
	
		return;
	
	
	elseif cmd == "강퇴" or cmd == "kick" then
		FkOff.settings.mode = "kick";
		FKOFF_SAVE_SETTINGS();
		ui.SysMsg(string.format("[%s][%s] 강퇴 모드로 설정되었습니다.",addonName, FkOff.settings.mode));
		return;
	
	elseif cmd == "알림" or cmd == "alert" then 
		FkOff.settings.mode = "alert";
		FKOFF_SAVE_SETTINGS();
		ui.SysMsg(string.format("[%s][%s] 알림 모드로 설정되었습니다.",addonName, FkOff.settings.mode));
		return;

	elseif cmd == "강퇴+" or cmd == "kick+" then 
		FkOff.settings.mode = "kickPlus";
		FKOFF_SAVE_SETTINGS();
		ui.SysMsg(string.format("[%s][%s] 강퇴+탈퇴 모드로 설정되었습니다.",addonName, FkOff.settings.mode));
		return;

	end
	
end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
