for node,description in pairs({
  ["naturalbiomes:alderswamp_litter"] = "Alder Swamp Grass",
  ["naturalbiomes:alpine_litter"] = "Alpine Grass",
  ["naturalbiomes:bambooforest_litter"] = "Bamboo Litter",
  ["naturalbiomes:bushland_bushlandlitter"] = false,
  ["naturalbiomes:bushland_bushlandlitter2"] = false,
  ["naturalbiomes:bushland_bushlandlitter3"] = false,
  ["naturalbiomes:heath_litter"] = "Heath Litter",
  ["naturalbiomes:heath_litter2"] = "Heath Litter",
  ["naturalbiomes:heath_litter3"] = "Heath Litter",
  ["naturalbiomes:mediterran_litter"] = "Mediterranean Grass",
  ["naturalbiomes:outback_litter"] = "Outback Grass",
  ["naturalbiomes:palmbeach_sand"] = "Beach Sand",
  ["naturalbiomes:savannalitter"] = "Savanna Litter",
}) do
  bottles.register_filled_bottle({
    target = node,
    description = description and ("Bottle of " .. description) or nil,
  })
end