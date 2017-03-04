local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Evelynn" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Evelynn/master/Evelynn.lua', SCRIPT_PATH .. 'Evelynn.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Evelynn/master/Evelynn.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local EvelynnMenu = Menu("Evelynn", "Evelynn")

EvelynnMenu:SubMenu("Combo", "Combo")

EvelynnMenu.Combo:Boolean("Q", "Use Q in combo", true)
EvelynnMenu.Combo:Boolean("W", "Use W in combo", true)
EvelynnMenu.Combo:Boolean("E", "Use E in combo", true)
EvelynnMenu.Combo:Boolean("R", "Use R in combo", true)
EvelynnMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
EvelynnMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
EvelynnMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
EvelynnMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
EvelynnMenu.Combo:Boolean("RHydra", "Use RHydra", true)
EvelynnMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
EvelynnMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
EvelynnMenu.Combo:Boolean("Randuins", "Use Randuins", true)


EvelynnMenu:SubMenu("AutoMode", "AutoMode")
EvelynnMenu.AutoMode:Boolean("Level", "Auto level spells", false)
EvelynnMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
EvelynnMenu.AutoMode:Boolean("Q", "Auto Q", false)
EvelynnMenu.AutoMode:Boolean("W", "Auto W", false)
EvelynnMenu.AutoMode:Boolean("E", "Auto E", false)
EvelynnMenu.AutoMode:Boolean("R", "Auto R", false)

EvelynnMenu:SubMenu("LaneClear", "LaneClear")
EvelynnMenu.LaneClear:Boolean("Q", "Use Q", true)
EvelynnMenu.LaneClear:Boolean("W", "Use W", true)
EvelynnMenu.LaneClear:Boolean("E", "Use E", true)
EvelynnMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
EvelynnMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

EvelynnMenu:SubMenu("Harass", "Harass")
EvelynnMenu.Harass:Boolean("Q", "Use Q", true)
EvelynnMenu.Harass:Boolean("W", "Use W", true)

EvelynnMenu:SubMenu("KillSteal", "KillSteal")
EvelynnMenu.KillSteal:Boolean("Q", "KS w Q", true)
EvelynnMenu.KillSteal:Boolean("E", "KS w E", true)

EvelynnMenu:SubMenu("AutoIgnite", "AutoIgnite")
EvelynnMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

EvelynnMenu:SubMenu("Drawings", "Drawings")
EvelynnMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

EvelynnMenu:SubMenu("SkinChanger", "SkinChanger")
EvelynnMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
EvelynnMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)

	--AUTO LEVEL UP
	if EvelynnMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if EvelynnMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
				if target ~= nil then 
                                      CastTargetSpell(target, _Q)
                                end
            end

            if EvelynnMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 500) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if EvelynnMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 500) then
			CastSpell(YGB)
            end

            if EvelynnMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if EvelynnMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if EvelynnMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 500) then
			 CastTargetSpell(target, Cutlass)
            end

            if EvelynnMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 500) then
			 CastSpell(_E)
	    end

            if EvelynnMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 500) then
		     if target ~= nil then 
                         CastTargetSpell(target, _Q)
                     end
            end

            if EvelynnMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if EvelynnMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 500) then
			CastTargetSpell(target, Gunblade)
            end

            if EvelynnMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if EvelynnMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 500) then
			CastSpell(_W)
	    end
	    
	    
            if EvelynnMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 500) and (EnemiesAround(myHeroPos(), 650) >= EvelynnMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 500) and EvelynnMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         if target ~= nil then 
                                      CastTargetSpell(target, _Q)
		         end
                end 

                if IsReady(_E) and ValidTarget(enemy, 187) and EvelynnMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastSpell(_E)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if EvelynnMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 500) then
	        	CastTargetSpell(closeminion, _Q)
                end

                if EvelynnMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 500) then
	        	CastSpell(_W)
	        end

                if EvelynnMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 187) then
	        	CastSpell(_E)
	        end

                if EvelynnMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if EvelynnMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if EvelynnMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 500) then
		      CastTargetSpell(target, _Q)
          end
        end 
        if EvelynnMenu.AutoMode.W:Value() then        
          if Ready(_W)  then
	  	      CastSpell(_W)
          end
        end
        if EvelynnMenu.AutoMode.E:Value() then        
	  if Ready(_E)  then
		      CastSpell(_E)
	  end
        end
        if EvelynnMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 650) then
		      CastTargetSpell(target, _R)
	  end
        end
                
	--AUTO GHOST
	if EvelynnMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if EvelynnMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 500, 0, 200, GoS.Red)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        if unit.isMe and spell.name:lower():find("Evelynnempowertwo") then 
		Mix:ResetAA()	
	end        

        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if EvelynnMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Evelynn</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





