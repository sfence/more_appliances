--------------------
-- Air Compressor --
--------------------
----- Ver 2.0 ------
-----------------------
-- Initial Functions --
-----------------------
local S = more_appliances.translator;

more_appliances.air_compressor = appliances.appliance:new(
    {
      node_name_inactive = "more_appliances:air_compressor",
      node_name_active = "more_appliances:air_compressor_active",
      
      node_description = S("Air compressor"),
    	node_help = S("Connect to power").." (100 EU)".."\n"..S("Fill gas cylinder with preasured air."),
      
      use_stack_size = 0,
      have_usage = false,
      
      need_water = false,
      
      sounds = {
        running = {
          sound = "more_appliances_air_compressor_running",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_idle = {
          sound = "more_appliances_air_compressor_poweroff",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_nopower = {
          sound = "more_appliances_air_compressor_poweroff",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
      },
    })

local air_compressor = more_appliances.air_compressor

air_compressor:power_data_register(
  {
    ["LV"] = {
        demand = 100,
        run_speed = 1,
        disable = {}
      },
    ["more_appliances_generator_power"] = {
        demand = 100,
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
    mesh = "more_appliances_air_compressor.obj",
    use_texture_alpha = "clip",
 }

local node_inactive = {
    tiles = {
        "more_appliances_air_compressor_base.png",
        "more_appliances_air_compressor_cylinder.png",
        "more_appliances_air_compressor_engine_body.png",
        "more_appliances_air_compressor_rotor_body.png",
        "more_appliances_air_compressor_hosepipe_valve.png",
        {
          image = "more_appliances_air_compressor_rotor.png",
          backface_culling = false,
        }
    },
  }

local node_active = {
    tiles = {
        "more_appliances_air_compressor_base.png",
        "more_appliances_air_compressor_cylinder.png",
        "more_appliances_air_compressor_engine_body.png",
        "more_appliances_air_compressor_rotor_body.png",
        "more_appliances_air_compressor_hosepipe_valve.png",
        {
          image = "more_appliances_air_compressor_rotor_active.png",
          backface_culling = false,
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 0.5
          }
        }
    },
  }

air_compressor:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

appliances.register_craft_type("more_appliances_air_compressor", {
    description = S("Compressing"),
    width = 1,
    height = 1,
  })

air_compressor:recipe_register_input(
	"more_appliances:gas_cylinder",
	{
		inputs = 1,
		outputs = {"more_appliances:gas_cylinder_air"},
		production_time = 180,
		consumption_step_size = 1,
	});

--air_compressor:register_recipes("more_appliances_air_compressor", "")

