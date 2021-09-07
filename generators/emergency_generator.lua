-------------------------
-- Emergency Generator --
-------------------------
----- Ver 1.0 ---------
-----------------------
-- Initial Functions --
-----------------------
local S = more_appliances.translator;

more_appliances.emergency_generator = appliances.appliance:new(
    {
      node_name_inactive = "more_appliances:emergency_generator",
      node_name_active = "more_appliances:emergency_generator_active",
      
      node_description = S("Emergency generator"),
    	node_help = S("Fill it with liquid fuel.").."\n"..S("Use this for generate energy.").."\n"..S("Startup and Shutdown by punch."),
      
      input_stack_size = 0,
      have_input = false,
      
      power_connect_sides = {"front","back","right","left"},
      
      have_control = true,
      
      sounds = {
        active_running = {
          sound = "more_appliances_emergency_generator_startup",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 3,
        },
        waiting_running = {
          sound = "more_appliances_emergency_generator_startup",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 3,
        },
        running = {
          sound = "more_appliances_emergency_generator_running",
          sound_param = {max_hear_distance = 32, gain = 1},
          repeat_timer = 1,
        },
        running_idle = {
          sound = "more_appliances_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_nopower = {
          sound = "more_appliances_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
        running_waiting = {
          sound = "more_appliances_emergency_generator_shutdown",
          sound_param = {max_hear_distance = 32, gain = 1},
        },
      },
    })

local emergency_generator = more_appliances.emergency_generator

emergency_generator:power_data_register(
  {
    ["time_power"] = {
        run_speed = 1,
        disable = {}
      },
  })
emergency_generator:control_data_register(
  {
    ["punch_control"] = {
      },
  })

--------------
-- Formspec --
--------------

function emergency_generator:get_formspec(meta, production_percent, consumption_percent)
  local progress = "";
  
  progress = "image[3.6,0.9;5.5,0.95;appliances_consumption_progress_bar.png^[transformR270]]";
  if consumption_percent then
    progress = "image[3.6,0.9;5.5,0.95;appliances_consumption_progress_bar.png^[lowpart:" ..
            (consumption_percent) ..
            ":appliances_consumption_progress_bar_full.png^[transformR270]]";
  end
  
  
  
  local formspec =  "formspec_version[3]" .. "size[12.75,8.5]" ..
                    "background[-1.25,-1.25;15,10;appliances_appliance_formspec.png]" ..
                    progress..
                    "list[current_player;main;1.5,3;8,4;]" ..
                    "list[context;"..self.use_stack..";2,0.8;1,1;]"..
                    "list[context;"..self.output_stack..";9.75,0.25;2,2;]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.use_stack.."]" ..
                    "listring[current_player;main]" ..
                    "listring[context;"..self.output_stack.."]" ..
                    "listring[current_player;main]";
  return formspec;
end

---------------
-- Callbacks --
---------------

local function update_generator_supply(self, pos, use_usage)
  local side_data = {};
  local total_demand = 0;
  for _,side in pairs(self.power_connect_sides) do
    local side_pos = appliances.get_side_pos(pos, side);
    local side_node = minetest.get_node(side_pos);
    local side_def = minetest.registered_nodes[side_node.name];
    if side_def and side_def._generator_connect_sides then
      if appliances.is_connected_to(side_pos, pos, side_def._generator_connect_sides) then
        local meta = minetest.get_meta(side_pos);
        local demand = meta:get_int("generator_demand") or 0
        if (demand>0) then
          total_demand = total_demand + demand;
          table.insert(side_data, {meta=meta,demand=demand});
        else
          meta:set_int("generator_input", 0)
        end
      end
    end
  end
  
  if (total_demand>0) then
    local generator_output = 0;
    if use_usage then
      generator_output = use_usage.generator_output or 150;
    end
    local part = generator_output/total_demand;
    
    for _,side in pairs(side_data) do
      side.meta:set_int("generator_input", math.floor(side.demand*part))
    end
  end
end

function emergency_generator:cb_on_production(pos, meta, use_input, use_usage)
  update_generator_supply(self, pos, use_usage)
end

function emergency_generator:cb_deactivate(pos, meta)
  update_generator_supply(self, pos, nil)
end

----------
-- Node --
----------

local node_def = {
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2},
    legacy_facedir_simple = true,
    is_ground_content = false,
    sounds = default.node_sound_metal_defaults(),
    drawtype = "mesh",
    mesh = "more_appliances_emergency_generator.obj",
    use_texture_alpha = "clip",
 }

local node_inactive = {
    tiles = {
        "more_appliances_emergency_generator_frame_lid_hose.png",
        "more_appliances_emergency_generator_front_panel_body.png",
        "more_appliances_emergency_generator_back_body.png",
        "more_appliances_emergency_generator_tank.png",
        "more_appliances_emergency_generator_cable.png",
        "more_appliances_emergency_generator_moving_parts.png",
    },
  }

local node_active = {
    tiles = {
        "more_appliances_emergency_generator_frame_lid_hose.png",
        "more_appliances_emergency_generator_front_panel_body.png",
        "more_appliances_emergency_generator_back_body.png",
        "more_appliances_emergency_generator_tank.png",
        "more_appliances_emergency_generator_cable.png",
        {
          image = "more_appliances_emergency_generator_moving_parts_active.png",
          backface_culling = false,
          animation = {
            type = "vertical_frames",
            aspect_w = 16,
            aspect_h = 16,
            length = 1.5
          }
        }
    },
  }

emergency_generator:register_nodes(node_def, node_inactive, node_active)

-------------------------
-- Recipe Registration --
-------------------------

emergency_generator:recipe_register_usage(
	"biofuel:phial_fuel",
	{
		inputs = 1,
		outputs = {"biofuel:phial"},
		consumption_time = 2,
		consumption_step_size = 1,
    generator_output = 150,
	});
emergency_generator:recipe_register_usage(
	"biofuel:bottle_fuel",
	{
		inputs = 1,
		outputs = {"vessels:glass_bottle"},
		consumption_time = 20,
		consumption_step_size = 1,
    generator_output = 150,
	});
emergency_generator:recipe_register_usage(
	"biofuel:fuel_can",
	{
		inputs = 1,
		outputs = {"biofuel:can"},
		consumption_time = 160,
		consumption_step_size = 1,
    generator_output = 150,
	});

emergency_generator:register_recipes("more_appliances_air_compressor", "")

