if (not nmm) then
    nmm = {}
end

nmm = {
    show_options_button = true,
}

nmm = SMODS.current_mod
nmm_config = nmm.config
nmm.enabled = copy_table(nmm_config)



local fakeeval = evaluate_play_final_scoring

function evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
	if (nmm.config.convert) then
        hand_chips = hand_chips + (mult - 1)
    end

	mult = 1
	fakeeval(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
end

local hudcopy = create_UIBox_HUD
function create_UIBox_HUD(force)
	local res = hudcopy()

    res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[1].config.minw = 4
    res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[2] = {n=G.UIT.C, config={align = "cm"}, nodes={
		{n=G.UIT.T, config={id = "chipmult_op", text = "no", lang = G.LANGUAGES['en-us'], scale = 0, colour = G.C.WHITE, shadow = true}},
	}}

	res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[3] = {n=G.UIT.C, config={align = "cl", minw = 0, minh=0, r = 0,colour = G.C.BLACK, id = 'hand_mult_area', emboss = 0.05}, nodes={
        {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
        {n=G.UIT.B, config={w=0,h=0}},
        {n=G.UIT.O, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = "", colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = 0.4*2.3})}},
    }}

    -- does this works?
	return res
end

local fakeupd = Game.update
function Game:update(dt)
    fakeupd(self, dt)

    if G and G.HUD and G.HUD:get_UIE_by_ID("hand_mult_area") then
        G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    end

end

nmm.config_tab = function()
    local scale = 5/6
    return {n=G.UIT.ROOT, 
        config = {align = "cl", minh = G.ROOM.T.h*0.5, padding = 0.0, r = 0.1, colour = G.C.GREY}, 
        nodes = {
            {n = G.UIT.R, config = { padding = 0.05 }, 
                nodes = {
                    {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.125, padding = 0.05 }, 
                        nodes = {
                            create_toggle{
                                label = "Convert mult to chips", -- the label that shows up next to the toggle button
                                info = {"Converts mult to chips after scoring.", "Makes the mod slightly more bearable."}, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN, -- the color of the toggle when it is on
                                ref_table = nmm.config, -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "convert" -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                }
            },

        }
    }
end
