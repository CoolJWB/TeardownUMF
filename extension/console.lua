
if REALM_HUD or REALM_MENU then

	local console_buffer = util.shared_buffer("savegame.console", 128)

	local bottom = not not REALM_MENU
	local function console()
		local w, h = UiWidth(), UiHeight()
		local cw, ch = w / 2 - 220, bottom and math.floor(h * 0.75) or h - 40
		local visible = bottom and 1 - (gSandboxScale + gCreateScale + gOptionsScale + (gChallengesScale or 0)) or pauseMenuAlpha - optionsAlpha
		if not visible or visible == 0 then return end
		UiPush()
			if bottom then
				UiTranslate(w - 20, h - 20)
				UiAlign("right bottom")
			else
				UiTranslate(w - 20, 20)
				UiAlign("right top")
			end
			UiWordWrap(cw)
			UiColor(.0, .0, .0, 0.7 * visible)
			UiImageBox("common/box-solid-shadow-50.png", cw, ch, -50, -50)
			UiWindow(cw, ch, true)
			UiColor(1,0,0,1)
			UiFont("../../mods/umf/assets/font/consolas.ttf", 24)
			UiAlign("left bottom")
			UiTranslate(0,ch)
			local len = console_buffer:len() - 1
			for i = len, 0, -1 do
				local data = console_buffer:get(i)
				local r, g, b, text = data:match("([^;]+);([^;]+);([^;]+);(.*)")
				if text then -- if this is nil, something went horribly wrong!
					UiColor(tonumber(r), tonumber(g), tonumber(b), 1 * visible)
					local w, h = UiText(#text == 0 and " " or text, false)
					UiTranslate(0,-math.max(h, 24))
				end
			end
		UiPop()
	end

	if UMF_CONFIG.devmode then
		hook.add("base.draw", "console.draw", console)
	end

	hook.add("base.command.activate", "console.updateconfig", function()
		if UMF_CONFIG.devmode then
			hook.add("base.draw", "console.draw", console)
		else
			hook.remove("base.draw", "console.draw")
		end
	end)

end