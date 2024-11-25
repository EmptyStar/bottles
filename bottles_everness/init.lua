for node,description in pairs({
  ["everness:coral_desert_stone_with_moss"] = "Coral Cave Moss",
  ["everness:mold_stone_with_moss"] = "Moldy Moss",
  ["everness:coral_dirt"] = false,
  ["everness:cursed_dirt"] = false,
  ["everness:crystal_dirt"] = false,
  ["everness:forsaken_tundra_dirt"] = false,
  ["everness:forsaken_tundra_dirt_with_grass"] = "Forsaken Tundra Grass",
  ["everness:dirt_with_coral_grass"] = "Coral Grass",
  ["everness:dirt_with_cursed_grass"] = "Cursed Grass",
  ["everness:dirt_with_crystal_grass"] = "Crystal Grass",
  ["everness:dry_ocean_dirt"] = false,
  ["everness:crystal_cave_dirt"] = false,
  ["everness:crystal_cave_dirt_with_moss"] = "Crystal Cave Moss",
  ["everness:moss_block"] = "Moss",
  ["everness:crystal_moss_block"] = "Crystal Moss",
  ["everness:coral_sand"] = false,
  ["everness:coral_white_sand"] = false,
  ["everness:cursed_sand"] = false,
  ["everness:crystal_sand"] = false,
  ["everness:forsaken_tundra_beach_sand"] = false,
  ["everness:forsaken_desert_sand"] = false,
  ["everness:coral_forest_deep_ocean_sand"] = false,
  ["everness:cursed_lands_deep_ocean_sand"] = false,
  ["everness:crystal_forest_deep_ocean_sand"] = false,
  ["everness:mineral_sand"] = false,
  ["everness:frosted_snowblock"] = "Frosted Snow",
  ["everness:cursed_mud"] = false,
}) do
  bottles.register_filled_bottle({
    target = node,
    description = description and ("Bottle of " .. description) or nil,
  })
end

-- Mineral water has an extra target
bottles.register_filled_bottle({
  target = {
    "everness:mineral_water_source",
    "everness:mineral_water_flowing",
  },
  description = "Bottle of Mineral Water",
})