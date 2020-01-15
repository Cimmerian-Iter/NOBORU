dofile "app0:assets/libs/catalogs.lua"
dofile "app0:assets/libs/details.lua"

LIBRARY_MODE    = 0
CATALOGS_MODE   = 1
SETTINGS_MODE   = 2
local MENU_MODE = -1
local ButtonsAnimX = {1, 1, 1}

Menu = {
    SetMode = function (new_mode)
        if MENU_MODE == new_mode then return end
        if MENU_MODE == CATALOGS_MODE then
            Catalogs.Shrink()
        end
        MENU_MODE = new_mode
    end,
    Input = function (OldPad, Pad, OldTouch, Touch)
        if Details.GetMode() == DETAILS_END then
            if Controls.check(Pad, SCE_CTRL_RTRIGGER) and not Controls.check(OldPad, SCE_CTRL_RTRIGGER) then
                Menu.SetMode(math.min(MENU_MODE + 1, 2))
            end
            if Controls.check(Pad, SCE_CTRL_LTRIGGER) and not Controls.check(OldPad, SCE_CTRL_LTRIGGER) then
                Menu.SetMode(math.max(MENU_MODE - 1, 0))
            end
            if Touch.x ~= nil and OldTouch.x == nil and Touch.x < 250 then
                if Touch.y < 85 then
                    Menu.SetMode(LIBRARY_MODE)
                elseif Touch.y < 145 then
                    Menu.SetMode(CATALOGS_MODE)
                elseif Touch.y > 440 then
                    Menu.SetMode(SETTINGS_MODE)
                end
            end
            if MENU_MODE == CATALOGS_MODE then
                Catalogs.Input(OldPad, Pad, OldTouch, Touch)
            end
        else
            Details.Input(OldPad, Pad, OldTouch, Touch)
        end
    end,
    Update = function (delta)
        if MENU_MODE == CATALOGS_MODE then
            Catalogs.Update(delta)
        end
        Details.Update(delta)
    end,
    Draw = function ()
        local bax = ButtonsAnimX
        for i = 1, 3 do
            if MENU_MODE + 1 == i then
                bax[i] = math.max(bax[i] - 0.1, 0)
            else
                bax[i] = math.min(bax[i] + 0.1, 1)
            end
        end
        Screen.clear(Color.new(18, 18, 18))
        Font.print(FONT32, 35,  45,  Language[LANG].APP.LIBRARY, Color.new(255, 255, 255, 255-128*bax[1]))
        Font.print(FONT32, 35, 105, Language[LANG].APP.CATALOGS, Color.new(255, 255, 255, 255-128*bax[2]))
        Font.print(FONT32, 35, 462, Language[LANG].APP.SETTINGS, Color.new(255, 255, 255, 255-128*bax[3]))
        if MENU_MODE == CATALOGS_MODE then
            Catalogs.Draw()
        end
        Details.Draw()
    end
}

Menu.SetMode(LIBRARY_MODE)