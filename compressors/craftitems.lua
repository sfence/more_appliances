
local S = more_appliances.translator

if true then
  local texture = "more_appliances_gas_cylinder_top.png^more_appliances_gas_cylinder_bottom.png"
  minetest.register_craftitem(
      "more_appliances:gas_cylinder",
      {
        description = S("Empty gas cylinder"),
        inventory_image = texture,
        wield_image = texture,
        groups = {}
      }
    );
  local texture = "(more_appliances_gas_cylinder_top.png^[multiply:#00F000)^(more_appliances_gas_cylinder_bottom.png)"
  minetest.register_craftitem(
      "more_appliances:gas_cylinder_air",
      {
        description = S("Gas cylinder with air"),
        inventory_image = texture,
        wield_image = texture,
        groups = {}
      }
    );
end

