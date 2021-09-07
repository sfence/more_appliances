-------------------------
-- Hand Air Compressor --
-------------------------
-------- Ver 1.0 --------
-----------------------
-- Initial Functions --
-----------------------
local S = more_appliances.translator;

more_appliances.hand_air_compressor = appliances.appliance:new(
    {
      node_name_inactive = "more_appliances:hand_air_compressor",
      node_name_active = "more_appliances:hand_air_compressor_active",
      
      node_description = S("Hand air compressor"),
    	node_help = S("Powered by hand.").."\n"..S("Fill gas cylinder with preasured air."),
      
      use_stack_size = 0,
      have_usage = false,
      
      sounds = {
        running = {
          sound = "more_appliances_hand_air_compressor_running",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 1,
        },
      },
    })

local hand_air_compressor = more_appliances.hand_air_compressor

hand_air_compressor:power_data_register(
  {
    ["punch_power"] = {
        run_speed = 1,
        disable = {}
      },
  })

--------------
-- Formspec --
--------------

----------
-- Node --
----------

local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = default.node_sound_stone_defaults(),
    drawtype = "mesh",
    mesh = "more_appliances_hand_air_compressor.obj",
    use_texture_alpha = "blend",
 }

local node_inactive = {
    tiles = {
        "more_appliances_hand_air_compressor_base.png",
        "more_appliances_hand_air_compressor_cylinder.png",
        "more_appliances_hand_air_compressor_body_hosepipe.png",
        "more_appliances_hand_air_compressor_pump.png",
    },
  }

local node_active = {
    tiles = {
        "more_appliances_hand_air_compressor_base.png",
        "more_appliances_hand_air_compressor_cylinder.png",
        "more_appliances_hand_air_compressor_body_hosepipe.png",
        {
          image = "more_appliances_hand_air_compressor_pump_active.png",
          backface_culling = false,
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 2
          }
        },
    },
  }

hand_air_compressor:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("more_appliances_hand_air_compressor", {
    description = S("Compressing"),
    width = 1,
    height = 1,
  })

hand_air_compressor:recipe_register_input(
	"more_appliances:gas_cylinder",
	{
		inputs = 1,
		outputs = {"more_appliances:gas_cylinder_air"},
		production_time = 360,
		consumption_step_size = 1,
	});

--hand_air_compressor:register_recipes("more_appliances_hand_air_compressor", "")

