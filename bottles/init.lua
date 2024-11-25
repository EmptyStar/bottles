-- Local wrapping functions for on_use reuse
local function do_fill(...)
  return bottles.fill(...)
end

local function do_spill(...)
  return bottles.spill(...)
end

-- Globals
bottles = {

  -- Registry of filled bottles
  registered_filled_bottles = {},

  -- Index target nodes to their filled bottle types
  target_node_map = {},

  -- Play a sound whenever a bottle is filled or spilled
  play_bottle_sound = function(pos,sound)
    if sound then
      minetest.sound_play(sound,{
        pos,
        gain = 0.25,
        pitch = 5.0,
        max_hear_distance = 12,
      },true)
    end
  end,

  -- Fill an empty glass bottle
  fill = function(itemstack,placer,target)
    if target.type == "node" and placer:is_player() then
      -- Get targeted node
      local node = minetest.get_node(target.under)
      local  filled_bottle = bottles.target_node_map[node.name]
      if filled_bottle then
        -- Play contents sound
        bottles.play_bottle_sound(placer:get_pos(),filled_bottle.sound)

        -- Subtract from stack of empty bottles
        local count = itemstack:get_count()
        local retval = nil
        if count == 1 then
          itemstack:clear()
          retval = ItemStack(filled_bottle.name)
        else
          itemstack:set_count(count - 1)
          retval = itemstack
          local leftover = placer:get_inventory():add_item("main", ItemStack(filled_bottle.name))
          if not leftover:is_empty() then
            minetest.add_item(placer:get_pos(),leftover)
          end
        end

        -- Return value
        return retval
      end
    end
    return itemstack
  end,

  -- Spill the contents out of a filled bottle
  spill = function(itemstack,placer)
    if placer:is_player() then
      -- Play contents sound
      bottles.play_bottle_sound(placer:get_pos(),bottles.registered_filled_bottles[itemstack:get_name()].sound)

      -- Subtract from stack of filled bottles and set return value
      local count = itemstack:get_count()
      local retval = nil
      if count == 1 then
        itemstack:clear()
        retval = ItemStack("vessels:glass_bottle")
      else
        itemstack:set_count(count - 1)
        retval = itemstack
        local leftover = placer:get_inventory():add_item("main", ItemStack("vessels:glass_bottle"))
        if not leftover:is_empty() then
          minetest.add_item(placer:get_pos(),leftover)
        end
      end

      -- Return value
      return retval
    else
      return itemstack
    end
  end,

  -- Register a filled bottle
  register_filled_bottle = function(spec)
    -- Validate spec, and set defaults
    if not spec.target then
      return false
    end

    local target_type = type(spec.target)

    if not spec.contents then
      if target_type == "string" then
        spec.contents = spec.target
      elseif target_type == "table" then
        spec.contents = spec.target[1]
      else
        return false
      end
    end

    local contents_node = minetest.registered_nodes[spec.contents]
    if not contents_node then
      return false
    end

    if spec.image then
      -- do nothing
    elseif type(contents_node.tiles[1]) == "string" then
      spec.image = contents_node.tiles[1]
    elseif type(contents_node.tiles[1]) == "table" then
      spec.image = contents_node.tiles[1].name
    else
      return false
    end
    spec.image = "[combine:16x16:0,0=" .. spec.image .. "^vessels_glass_bottle_mask.png^[makealpha:0,254,0"
    spec.name = "bottles:" .. (spec.name or "bottle_of_" .. contents_node.name:split(":")[2])

    -- Ensure that name is not already in use, fail registration if so
    if bottles.registered_filled_bottles[spec.name] then
      return false
    end

    -- Normalize target type
    if target_type == "string" then
      spec.target = {spec.target}
    end

    -- Ensure that target nodes are not already in use, fail registration if so
    for _,target in ipairs(spec.target) do
      if bottles.target_node_map[target] then
        return false
      end
    end

    -- Extract node footstep sounds if possible and if no other sounds are provided
    if not spec.sound and contents_node.sounds and contents_node.sounds.footstep then
      spec.sound = contents_node.sounds.footstep.name
    end

    -- Map target nodes to spec
    for _,target in ipairs(spec.target) do
      bottles.target_node_map[target] = spec
    end

    -- Put bottle into map of registered filled bottles
    bottles.registered_filled_bottles[spec.name] = spec

    -- Register new bottle node
    minetest.register_node(":" .. spec.name,{
      description = spec.description or ("Bottle of " .. contents_node.description:split("\n")[1]),
      drawtype = "plantlike",
      tiles = {spec.image},
      inventory_image = spec.image,
      wield_image = spec.image,
      paramtype = "light",
      is_ground_content = false,
      walkable = false,
      selection_box = {
        type = "fixed",
        fixed = {-0.25, -0.5, -0.25, 0.25, 0.3, 0.25}
      },
      groups = {vessel = 1, dig_immediate = 3, attached_node = 1},
      sounds = default.node_sound_glass_defaults(),
      on_use = do_spill
    })

    -- Successful registration
    return true
  end,

  -- Unregister a filled bottle
  unregister_filled_bottle = function(name)
    -- Only unregister if it's already registered
    local spec = bottles.registered_filled_bottles[name]
    if not spec then
      return false
    end

    -- Remove from registered bottles list and target index
    bottles.registered_filled_bottles[name] = nil
    for _,target in ipairs(spec.target) do
      bottles.target_node_map[target] = nil
    end

    -- Unregister node
    minetest.unregister_item(name)

    -- Successfully unregistered filled bottle
    return true
  end,
}

-- Make empty glass bottles able to 'point and fill'
minetest.override_item("vessels:glass_bottle",{
  liquids_pointable = true,
  on_use = do_fill,
})