
--mod base ver 1.0.2 (oo 58.126)

local addonName = "CAMCON";
local addonNameLower = string.lower(addonName);

local author = "SUZUMEIKO";


_G["ADDONS"] = _G["ADDONS"] or {};
_G["ADDONS"][author] = _G["ADDONS"][author] or {};
_G["ADDONS"][author][addonName] = _G["ADDONS"][author][addonName] or {};
local g = _G["ADDONS"][author][addonName];


g.settingsFileLoc = string.format("../addons/%s/settings.json", addonNameLower);


	
if not g.loaded then

g.settings = {
	enable = true,
	window = 1,
	position = {
		x = 500,
		y = 500
	},
	defaultcampos = {
		x = 45,
		y = 45,
		z = 336
	},
	
	max = {
		x = 360,
		y = 90,
		z = 700
	},
	
	backupcampos = {
		x = 45,
		y = 45,
		z = 336
	}	
}

end


local acutil = require('acutil');


function CAMCON_ON_INIT(addon, frame)

	g.addon = addon;
	g.frame = frame;

	
	frame:ShowWindow(0);
	acutil.slashCommand("/camcon", CAMCON_PROCESS_COMMAND);
	acutil.slashCommand("/캠컨", CAMCON_PROCESS_COMMAND);
	
	if not g.loaded then
		local t, err = acutil.loadJSON(g.settingsFileLoc, g.settings);
		if err then

		else
			g.settings = t;
		end
		g.loaded = true;
	end
	
	
	
	
	if g.settings.enable then
		frame:ShowWindow(1);
	end
	
	

	if not g.settings.window then
		g.settings.window = 1;
		CAMCON_SAVE_SETTINGS();
	end
	
	

	frame:EnableMove(1);
	frame:EnableHitTest(1);
	frame:SetEventScript(ui.LBUTTONUP, "CAMCON_END_DRAG");

	frame:Move(g.settings.position.x, g.settings.position.y);
	frame:SetOffset(g.settings.position.x, g.settings.position.y);


	CAMCON_INIT_FRAME(frame);
	

	CAMCON_WINDOW_INIT();
	
	addon:RegisterMsg("GAME_START", "CAMCON_CAMERA_DELAYED_UPDATE");
	addon:RegisterMsg("GAME_START_3SEC", "CAMCON_CAMERA_DELAYED_UPDATE");
	
end

function CAMCON_SAVE_SETTINGS()
	acutil.saveJSON(g.settingsFileLoc, g.settings);
end

function CAMCON_CAMERA_DELAYED_UPDATE()

	camera.CamRotate(g.settings.backupcampos.y, g.settings.backupcampos.x);
	if g.settings.backupcampos.z == 336 then 
		camera.ChangeCameraZoom(2, 336, 0.5, 1.5);
	else
		camera.CustomZoom(g.settings.backupcampos.z);
	end
end



function CAMCON_INIT_FRAME(frame)

	local frame = ui.GetFrame("camcon");
	frame:SetSkinName("box_glass");
	
	local titleText = frame:CreateOrGetControl("richtext", "n_titleText", 0, 0, 0, 0);
	titleText:SetOffset(10,10);
	titleText:SetFontName("white_16_ol");
	titleText:SetText("카메라 컨트롤 [/캠컨][/camcon]");
	
	local tipText = frame:CreateOrGetControl("richtext", "n_tip", 0, 0, 0, 0);
	tipText:SetOffset(10,120);
	tipText:SetFontName("white_12_ol");
	tipText:SetText("Z좌표를 벗어나면 XY좌표가 자동으로 리셋됩니다");
	
	local btnReset = frame:CreateOrGetControl("button", "n_resize", 236, 4, 30, 30);
	btnReset:SetText("{@sti7}{s16}_");
	btnReset:SetEventScript(ui.LBUTTONUP, "CAMCON_WINDOW_RESIZE");
	
	local btnReset = frame:CreateOrGetControl("button", "n_reset", 266, 4, 30, 30);
	btnReset:SetText("{@sti7}{s16}리셋");
	btnReset:SetEventScript(ui.LBUTTONUP, "CAMCON_RESET");
	
	local labelX = frame:CreateOrGetControl("richtext", "n_labelX", 0, 0, 0, 0);
	labelX:SetOffset(20,40);
	labelX:SetFontName("white_14_ol");
	labelX:SetText("X좌표("..(g.settings.backupcampos.x).."):");

	
	local labelY = frame:CreateOrGetControl("richtext", "n_labelY", 0, 0, 0, 0);
	labelY:SetOffset(20,70);
	labelY:SetFontName("white_14_ol");
	labelY:SetText("Y좌표("..(g.settings.backupcampos.y).."):");
	
	local labelZ = frame:CreateOrGetControl("richtext", "n_labelZ", 0, 0, 0, 0);
	labelZ:SetOffset(20,100);
	labelZ:SetFontName("white_14_ol");
	labelZ:SetText("Z좌표("..(g.settings.backupcampos.z).."):");
	
	local scrX = frame:CreateOrGetControl("slidebar", "n_scrX", 120, 34, 180, 30);
	scrX=tolua.cast(scrX, 'ui::CSlideBar');
	scrX:SetMinSlideLevel(0);
	scrX:SetMaxSlideLevel(g.settings.max.x-1);
	scrX:SetLevel(g.settings.backupcampos.x);
	
	local scrY = frame:CreateOrGetControl("slidebar", "n_scrY", 120, 64, 180, 30);
	scrY=tolua.cast(scrY, 'ui::CSlideBar');
	scrY:SetMinSlideLevel(-89);
	scrY:SetMaxSlideLevel(g.settings.max.y-1);
	scrY:SetLevel(g.settings.backupcampos.y);
	
	local scrZ = frame:CreateOrGetControl("slidebar", "n_scrZ", 120, 94, 180, 30);
	scrZ=tolua.cast(scrZ, 'ui::CSlideBar');
	scrZ:SetMinSlideLevel(50);
	scrZ:SetMaxSlideLevel(g.settings.max.z);
	scrZ:SetLevel(g.settings.backupcampos.z);
		
end


function CAMCON_RESET()
	local frame = ui.GetFrame("camcon");
	local scrX = frame:GetChild("n_scrX");
	local scrY = frame:GetChild("n_scrY");
	local scrZ = frame:GetChild("n_scrZ");
	scrX=tolua.cast(scrX, 'ui::CSlideBar');
	scrY=tolua.cast(scrY, 'ui::CSlideBar');
	scrZ=tolua.cast(scrZ, 'ui::CSlideBar');
	
	g.settings.backupcampos.x = g.settings.defaultcampos.x;
	g.settings.backupcampos.y = g.settings.defaultcampos.y;
	g.settings.backupcampos.z = g.settings.defaultcampos.z;
	
	scrX:SetLevel(g.settings.defaultcampos.x);
	scrY:SetLevel(g.settings.defaultcampos.y);
	scrZ:SetLevel(g.settings.defaultcampos.z);
	
	-- UPDATE
	camera.CamRotate(g.settings.defaultcampos.y, g.settings.defaultcampos.x,0);
	
	camera.ChangeCameraZoom(2, g.settings.defaultcampos.z, 0, 0);


	local labelX = frame:GetChild("n_labelX");
	local labelY = frame:GetChild("n_labelY");
	local labelZ = frame:GetChild("n_labelZ");

	labelX=tolua.cast(labelX, 'ui::CRichText');
	labelY=tolua.cast(labelY, 'ui::CRichText');
	labelZ=tolua.cast(labelZ, 'ui::CRichText');
		
	labelX:SetText("X좌표("..(g.settings.backupcampos.x).."):");
	labelY:SetText("Y좌표("..(g.settings.backupcampos.y).."):");
	labelZ:SetText("Z좌표("..(g.settings.backupcampos.z).."):");

	CAMCON_SAVE_SETTINGS();
end


function CAMCON_WINDOW_INIT()
	local frame = ui.GetFrame("camcon");
	if g.settings.window == 1 then
		frame:Resize(300,40);
	else
		frame:Resize(300,140);
	end
end
function CAMCON_WINDOW_RESIZE()
	local frame = ui.GetFrame("camcon");
	if g.settings.window == 0 then
		g.settings.window = 1;
		frame:Resize(300,40);
	else
		g.settings.window = 0;
		frame:Resize(300,140);
	end
	CAMCON_SAVE_SETTINGS();
end


function CAMCON_CAMERA_UPDATE_XY()
	local frame = ui.GetFrame("camcon");
	local labelX = frame:GetChild("n_labelX");
	local scrX = frame:GetChild("n_scrX");
	local labelY = frame:GetChild("n_labelY");
	local scrY = frame:GetChild("n_scrY");
	scrX=tolua.cast(scrX, 'ui::CSlideBar');
	scrY=tolua.cast(scrY, 'ui::CSlideBar');

	g.settings.backupcampos.x = scrX:GetLevel();
	g.settings.backupcampos.y = scrY:GetLevel();

	labelX:SetText("X좌표("..(g.settings.backupcampos.x).."):");
	labelY:SetText("Y좌표("..(g.settings.backupcampos.y).."):");

	-- UPDATE
	camera.CamRotate(g.settings.backupcampos.y, g.settings.backupcampos.x);
	
	
end


function CAMCON_CAMERA_UPDATE_Z()
	local frame = ui.GetFrame("camcon");
	local labelZ = frame:GetChild("n_labelZ");
	local scrZ = frame:GetChild("n_scrZ");
	scrZ=tolua.cast(scrZ, 'ui::CSlideBar');

	g.settings.backupcampos.z = scrZ:GetLevel();

	labelZ:SetText("Z좌표("..(g.settings.backupcampos.z).."):");

	-- UPDATE
	if g.settings.backupcampos.z == 336 then 
		camera.ChangeCameraZoom(2, 336, 0.5, 1.5);
	else
		camera.CustomZoom(g.settings.backupcampos.z);
	end
end

  

function CAMCON_END_DRAG()
	g.settings.position.x = g.frame:GetX();
	g.settings.position.y = g.frame:GetY();
	CAMCON_SAVE_SETTINGS();
end


function CAMCON_PROCESS_COMMAND(command)

	local cmd = "";

	if #command > 0 then
		cmd = table.remove(command, 1);
	end

	if cmd == "reset" or cmd == "리셋" then
		CAMCON_RESET();
		return;
	else
		local frame = ui.GetFrame("camcon");
			if g.settings.enable == true then
				frame:ShowWindow(0);
				g.settings.enable=false;
			else
				frame:ShowWindow(1);
				g.settings.enable=true;
			end
		return;
	end

end
