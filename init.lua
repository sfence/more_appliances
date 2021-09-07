
more_appliances = {
  translator = minetest.get_translator(minetest.get_current_modname())
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath.."/generators/generators.lua")

dofile(modpath.."/compressors/compressors.lua")

