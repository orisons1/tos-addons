function QUICKPATH_MAINTANENCE()

	file = io.open("maintenance.lua", "w+");
		
	local t = {};

	for k = 0, 30000 do -- refer map.ies 
		local MapClassName = GetClassString('Map', k, 'ClassName');		 
		if MapClassName ~= "None" then 
			local MapName = GetClassString('Map', k, 'Name');				
			t[MapName] = MapClassName;
		end
		
	end

	for i = 0, 30000 do 
		local MapClassID = GetClassString('Map', i, 'ClassID');
		local MapClassName = GetClassString('Map', i, 'ClassName');
		local MapName = GetClassString('Map', i, 'Name');
		if MapClassName ~= "None" then 
			local mapprop = geMapTable.GetMapProp(MapClassName);
			local mongens = mapprop.mongens;
			if mongens ~= nil then
				local cnt = mongens:Count();
				file:write("--[["..MapName.."]][\""..MapClassName.."\"] = \n			{\n"); 
				for i = 0 , cnt - 1 do
					local MonProp = mongens:Element(i);            
					if --[[MonProp:GetClassName() == 'Warp_arrow']] 1 then
						if MonProp.Minimap >= 1 then
							local GenList = MonProp.GenList;
							local GenCnt = GenList:Count();
							for j = 0 , GenCnt - 1 do
								local WorldPos = GenList:Element(j);
								local ctrlname = MonProp:GetName();
								--local GenType = MonProp.GenType;
								
								local korName = ctrlname;
								local EngName = "  ";
								
								for k,v in pairs(t) do
									if k == ctrlname then		
										EngName = v;
									end
								end
								file:write("			--[["..korName.."]][\""..EngName.."\"] = {"..string.format("x=%d,y=%d,z=%d}, \n", WorldPos.x, WorldPos.y, WorldPos.z));
									
							end								
						end								
					end
				end
				file:write("			}, \n\n");
			end	
		end 
	end 
	file:close();
	
	
	local mapclassname_kor = {}
	
	file2 = io.open("mapclassname_kor.lua", "w+");
	
	
	for k = 0, 30000 do -- refer map.ies 
		local MapClassName = GetClassString('Map', k, 'ClassName');		 
		if MapClassName ~= "None" then 
			local MapName = GetClass("Map", MapClassName).Name;				
			mapclassname_kor[MapClassName] = MapName;
		end
		
	end
	
	file2:write("local mapClassName_Kor = \n	{");
	
	for k,v in pairs(mapclassname_kor) do
		file2:write("[\""..k.."\"] = \""..v.."\", \n");
	end

	file2:write("}");
	
	file2:close();

end
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------

--MapClassID <-> MapClassName
-- ->
--	1. GetClassString('Map', mapId, 'ClassName');


--			-> MapName
--	1. GET_MAP_NAME(mapId)
--  2. GetClass("Map", "c_Klaipe").Name
