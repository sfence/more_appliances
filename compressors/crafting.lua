-- air compressor
if minetest.get_modpath("technic") then
  minetest.register_craft(
      {
        output = "more_appliances:air_compressor",
        recipe = {
            {"default:bronze_ingot", "basic_materials:motor","default:bronze_ingot"},
            {"technic:carbon_steel_ingot", "technic:machine_casing", "technic:carbon_steel_ingot"},
            {"basic_materials:plastic_sheet","technic:raw_latex","basic_materials:plastic_sheet"},
          },
      }
    );
else
  minetest.register_craft(
      {
        output = "more_appliances:air_compressor",
        recipe = {
            {"default:bronze_ingot", "basic_materials:motor","default:bronze_ingot"},
            {"default:steel_ingot", "default:steelblock", "default:steel_ingot"},
            {"basic_materials:plastic_sheet","basic_materials:paraffin","basic_materials:plastic_sheet"},
          },
      }
    );
end

-- gas cylinder
if minetest.get_modpath("technic") then
  minetest.register_craft(
      {
        output = "more_appliances:gas_cylinder",
        recipe = {
            {"technic:stainless_steel_ingot"},
            {"technic:stainless_steel_ingot"},
            {"technic:stainless_steel_ingot"},
          },
      }
    );
else
  minetest.register_craft(
      {
        output = "more_appliances:gas_cylinder",
        recipe = {
            {"default:steel_ingot"},
            {"default:steel_ingot"},
            {"default:steel_ingot"},
          },
      }
    );
end

