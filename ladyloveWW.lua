--CC List
ccTable = {"Gnaw", "Asphyxiate", "Remorseless Winter", "Monstrous Blow", "Bash", "Bear Hug", "Cyclone", "Disorienting Roar", "Maim", "Mighty Bash", "Pounce", "Hammer of Justice", "Intimidating Roar", "Freezing Trap", "Scatter Shot", "Wyvern Sting", "Bad Manner", "Intimidation", "Lullaby", "Paralyzing Quill", "Petrifying Gaze", "Sonic Blast", "Sting", "Web Wrap", "Impact", "Deep Freeze", "Dragon's Breath", "Polymorph", "Polymorph: Pig", "Polymorph: Black Cat", "Polymorph: Rabbit", "Polymorph: Turkey", "Polymorph: Turtle", "Ring of Frost", "Breath of Fire", "Clash", "Charging Ox Wave", "Fists of Fury", "Leg Sweep", "Paralysis", "Blinding Light", "Fist of Justice", "Holy Wrath", "Repentance", "Dominate Mind", "Holy  Word: Chastise", "Psychic Horror", "Psychic Scream", "Psychic Terror", "Sin and Punishment", "Blind", "Cheap Shot", "Gouge", "Kidney Shot", "Paralysis", "Sap", "EarthQuake", "Hex", "Static Charge", "Blod Horror", "Demonic Leap", "Fear", "Howl of Terror", "Infernal Awakening", "Mortal Coil", "Seduction", "Shadowfury", "Sleep", "Axe Toss", "Mesermerize", "Charge", "Dragon Roar", "Intimidating Shout", "Shockwave", "Storm Bolt", "Warbringer"}

--Settings
ladylove_UpdateInterval = 0.05;

--global variables
triggeredAbility = nil
setFocusID = nil

--Globals
ladylove_bar = CreateFrame("Frame",nil,UIParent)
ladylove_barEnabled = CreateFrame("Frame",nil,UIParent)

ladylove_bar:RegisterEvent("UI_ERROR_MESSAGE");
ladylove_bar:RegisterEvent("SPELL_UPDATE_COOLDOWN");
ladylove_bar:RegisterEvent("UNIT_SPELLCAST_SENT");
local function eventHandler(self, event, ...)
	local arg1, arg2, arg3, arg4 = ... 
	if (event == "UI_ERROR_MESSAGE") then
		if (arg1 == "Target needs to be in front of you." or
			arg1 == "Out of range." or
			arg1 == "Out of Range." or
			arg1 == "Target not in line of sight") then
			offenseTime = GetTime()
		end
	end
	if (event == "SPELL_UPDATE_COOLDOWN") then
	end
	if (event == "UNIT_SPELLCAST_SENT") then
		if (arg1 == "player" or arg1 == "Player") then
			if (arg2 == triggeredAbility and triggeredAbility ~= nil) then
				triggeredAbility = nil
			end
		end
	end
end
ladylove_bar:SetScript("OnEvent", eventHandler);

SLASH_LADYLOVE21 = '/lady'; 
function SlashCmdList.LADYLOVE2(msg, editbox)
	if msg == 'toggle' then
		if (addonEnabled) then
			addonEnabled = false
			ladylove_barEnabled.texture:SetTexture(0, 0, 0, 0.5)
		else
			addonEnabled = true
			ladylove_barEnabled.texture:SetTexture(0, 0.5, 0, 0.5)
		end
		return
	elseif msg == 'setfocus' then
		setFocusID = UnitGUID("focus")
		print(setFocusID)
	else
		triggeredAbility = msg
	end
end

function ladylove_OnLoad()
	ladylove_bar:SetFrameStrata("BACKGROUND")
	ladylove_bar:SetWidth(5) -- Set these to whatever height/width is needed 
	ladylove_bar:SetHeight(5) -- for your Texture
	t = ladylove_bar:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0.00390625 * 10,0,1)
	t:SetAllPoints(ladylove_bar)
	ladylove_bar.texture = t
	ladylove_bar:SetPoint("TOPLEFT", 5,0)
	ladylove_bar:Show()
	
	ladylove_barEnabled:SetFrameStrata("BACKGROUND")
	ladylove_barEnabled:SetWidth(10) -- Set these to whatever height/width is needed 
	ladylove_barEnabled:SetHeight(10) -- for your Texture
	t = ladylove_barEnabled:CreateTexture(nil,"BACKGROUND")
	t:SetTexture(0,0,0)
	t:SetAllPoints(ladylove_barEnabled)
	ladylove_barEnabled.texture = t
	ladylove_barEnabled:SetPoint("BOTTOMLEFT", 600, 130)
	ladylove_barEnabled.texture:SetTexture(0, 0, 0, 0.5)
	ladylove_barEnabled:Show()
end

function ladylove_OnUpdate(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed 	
	if (self.TimeSinceLastUpdate > ladylove_UpdateInterval) then
		if not(addonEnabled) then
			setColorForKey("none")
			return
		end
		if (IsMounted()) then
			setColorForKey("none")
			return
		end
		if (triggeredAbility ~= nil) then
			if(isSpellUsable(triggeredAbility)) then
				setColorForAbility(triggeredAbility)
				return
			end
		end
		setColorForKey("none")
	end
end

function purgeCC()
	for i,v in ipairs(ccTable) do
		name, rank, icon, count, debuffType, duration = UnitDebuff("Player", v)
		if(duration ~= nil) then
			if (duration > 4) then
				setColorForKey("alt1")
				return true
			end
		end
	end
	return false
end

function setColorForAbility(ability)
	if (ability == "Power Word: Shield") then
		setColorForKey("c")
		return true
	end
end

function isSpellUsable(spellName)
	start, duration = GetSpellCooldown("Leap of Faith")
	--print("duration " .. duration)
	if (spellName ~= "Summon Pet") then
		usable = IsUsableSpell(spellName)
		start, duration = GetSpellCooldown(spellName)
		if (duration ~= 0) then
			return false
		end
	end
end

function isMoving()
	moving = false
	if (GetUnitSpeed("Player") ~= 0) then
		moving = true
	end
	return moving
end

lastKey = "0"
function setColorForKey(key)
	if (key ~= lastKey) then
		--print("Key:" .. lastKey)
		lastKey = key
	end
	currentRed = 0
	if (key == "none") then
		currentRed = 0
	elseif (key == "num1") then
		currentRed = 0.00390625 * 1
	elseif (key == "num2") then
		currentRed = 0.00390625 * 2
	elseif (key == "num3") then
		currentRed = 0.00390625 * 3
	elseif (key == "num4") then
		currentRed = 0.00390625 * 4
	elseif (key == "num5") then
		currentRed = 0.00390625 * 5
	elseif (key == "num6") then
		currentRed = 0.00390625 * 6
	elseif (key == "num7") then
		currentRed = 0.00390625 * 7
	elseif (key == "num8") then
		currentRed = 0.00390625 * 8
	elseif (key == "num9") then
		currentRed = 0.00390625 * 9
	elseif (key == "num10") then
		currentRed = 0.00390625 * 10
	elseif (key == "mouse1") then
		currentRed = 0.00390625 * 11
	elseif (key == "num12") then
		currentRed = 0.00390625 * 12
	elseif (key == "1") then
		currentRed = 0.00390625 * 13
	elseif (key == "2") then
		currentRed = 0.00390625 * 14
	elseif (key == "3") then
		currentRed = 0.00390625 * 15
	elseif (key == "4") then
		currentRed = 0.00390625 * 16
	elseif (key == "5") then
		currentRed = 0.00390625 * 17
	elseif (key == "6") then
		currentRed = 0.00390625 * 18
	elseif (key == "e") then
		currentRed = 0.00390625 * 19
	elseif (key == "z") then
		currentRed = 0.003690625 * 20
	elseif (key == "r") then
		currentRed = 0.00390625 * 21
	elseif (key == "x") then
		currentRed = 0.00390625 * 22
	elseif (key == "f") then
		currentRed = 0.00390625 * 23
	elseif (key == "q") then
		currentRed = 0.00390625 * 24
	elseif (key == "c") then
		currentRed = 0.00390625 * 25
	elseif (key == "7") then
		currentRed = 0.00390625 * 26
	elseif (key == "8") then
		currentRed = 0.00390625 * 27
	elseif (key == "9") then
		currentRed = 0.00390625 * 28
	elseif (key == "0") then
		currentRed = 0.00390625 * 29
	elseif (key == "f1") then
		currentRed = 0.00390625 * 30
	elseif (key == "f2") then
		currentRed = 0.00390625 * 31
	elseif (key == "f3") then
		currentRed = 0.00390625 * 32
	elseif (key == "f4") then
		currentRed = 0.00390625 * 33
	elseif (key == "f5") then
		currentRed = 0.00390625 * 34
	elseif (key == "f6") then
		currentRed = 0.003690625 * 35
	elseif (key == "f7") then
		currentRed = 0.00390625 * 36
	elseif (key == "f8") then
		currentRed = 0.00390625 * 37
	elseif (key == "f9") then
		currentRed = 0.00390625 * 38
	elseif (key == "f10") then
		currentRed = 0.00390625 * 39
	elseif (key == "f11") then
		currentRed = 0.00390625 * 40
	elseif (key == "f12") then
		currentRed = 0.00390625 * 41
	elseif (key == "home") then
		currentRed = 0.00390625 * 42
	elseif (key == "num/") then
		currentRed = 0.00390625 * 43
	elseif (key == "num*") then
		currentRed = 0.00390625 * 44
	elseif (key == "num-") then
		currentRed = 0.00390625 * 45
	elseif (key == "num+") then
		currentRed = 0.00390625 * 46
	elseif (key == "nume") then
		currentRed = 0.00390625 * 47
	elseif (key == "num.") then
		currentRed = 0.00390625 * 48
	elseif (key == "delete") then
		currentRed = 0.00390625 * 49
	elseif (key == "pageup") then
		currentRed = 0.00390625 * 50
	elseif (key == "]") then
		currentRed = 0.00390625 * 51
	elseif (key == "[") then
		currentRed = 0.00390625 * 52
	elseif (key == "-") then
		currentRed = 0.00390625 * 53
	elseif (key == "-") then
		currentRed = 0.00390625 * 54
	elseif (key == ".") then
		currentRed = 0.00390625 * 55
	elseif (key == "up") then
		currentRed = 0.00390625 * 56
	elseif (key == "down") then
		currentRed = 0.00390625 * 57
	elseif (key == "left") then
		currentRed = 0.00390625 * 58
	elseif (key == "right") then
		currentRed = 0.00390625 * 59
	elseif (key == "g") then
		currentRed = 0.00390625 * 60
	elseif (key == "end") then
		currentRed = 0.00390625 * 61
	elseif (key == "j") then
		currentRed = 0.00390625 * 62
	elseif (key == "'") then
		currentRed = 0.00390625 * 63
	elseif (key == "v") then
		currentRed = 0.00390625 * 64
	elseif (key == "insert") then
		currentRed = 0.00390625 * 65
	elseif (key == "alt0") then
		currentRed = 0.00390625 * 66
	elseif (key == "alt1") then
		currentRed = 0.00390625 * 67
	elseif (key == "alt2") then
		currentRed = 0.00390625 * 68
	elseif (key == "alt3") then
		currentRed = 0.00390625 * 69
	elseif (key == "alt4") then
		currentRed = 0.00390625 * 70
	elseif (key == "alt5") then
		currentRed = 0.00390625 * 71
	elseif (key == "alt6") then
		currentRed = 0.00390625 * 72
	elseif (key == "alt7") then
		currentRed = 0.00390625 * 73
	elseif (key == "alt8") then
		currentRed = 0.00390625 * 74
	elseif (key == "alt9") then
		currentRed = 0.00390625 * 75
	end
	ladylove_bar.texture:SetTexture(currentRed,0,0, 1)
end

function setKeyForTarget(target)
	if (target == "player" or target == "Player") then
		setColorForKey("num1")
	elseif (target == "Party1") then
		setColorForKey("num2")
	elseif (target == "Party2") then
		setColorForKey("num3")
	elseif (target == "Party3") then
		setColorForKey("num4")
	elseif (target == "Party4") then
		setColorForKey("num5")
	elseif (target == "Raid1") then
		setColorForKey("num/")
	elseif (target == "Raid2") then
		setColorForKey("num*")
	elseif (target == "Raid3") then
		setColorForKey("num-")
	elseif (target == "Raid4") then
		setColorForKey("num+")
	elseif (target == "Raid5") then
		setColorForKey("num.")
	elseif (target == "Raid6") then
		setColorForKey("num7")
	elseif (target == "Raid7") then
		setColorForKey("num8")
	elseif (target == "Raid8") then
		setColorForKey("num9")
	elseif (target == "Raid9") then
		setColorForKey("num10")
	elseif (target == "Raid10") then
		setColorForKey("f1")
	elseif (target == "Raid11") then
		setColorForKey("f2")
	elseif (target == "Raid12") then
		setColorForKey("f3")
	elseif (target == "Raid13") then
		setColorForKey("f4")
	elseif (target == "Raid14") then
		setColorForKey("f5")
	elseif (target == "Raid15") then
		setColorForKey("f6")
	elseif (target == "Raid16") then
		setColorForKey("f7")
	elseif (target == "Raid17") then
		setColorForKey("f8")
	elseif (target == "Raid18") then
		setColorForKey("f9")
	elseif (target == "Raid19") then
		setColorForKey("f10")
	elseif (target == "Raid20") then
		setColorForKey("f11")
	elseif (target == "Raid21") then
		setColorForKey("f12")
	elseif (target == "Raid22") then
		setColorForKey("0")
	elseif (target == "Raid23") then
		setColorForKey("9")
	elseif (target == "Raid24") then
		setColorForKey("8")
	elseif (target == "Raid25") then
		setColorForKey("home")
	end
end

function doesTableContain(aTable, value) 
	for j,v in ipairs(aTable) do 
		if (v == value) then
			return true
		end
	end
	return false
end