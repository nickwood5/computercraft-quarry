
unwanted = {
    "minecraft:dirt",
    "minecraft:stone",
    "minecraft:cobblestone",
    "minecraft:packed_ice",
    "minecraft:grass_block",
    "minecraft:diorite",
    "minecraft:gravel",
    "minecraft:sand",
    "minecraft:rail",
    "minecraft:oak_fence",
    "minecraft:oak_planks",
    "minecraft:tuff",
    "minecraft:calcite",
    "minecraft:water",
    "minecraft:lava",
    "minecraft:granite",
    "minecraft:spruce_leaves",
    "soul_ice:lightstone",
    "biomesoplenty:mud_ball",
    "biomesoplenty:mud",
    "biomesoplenty:glowing_moss_carpet",
    "biomesoplenty:glowing_moss_block",
    "minecraft:andesite",
    "minecraft:cobbled_deepslate",
    "minecraft:polished_deepslate",
    "minecraft:deepslate"
}

removed = {
    "minecraft:andesite",
    "minecraft:cobbled_deepslate",
    "minecraft:deepslate"
}

stop_level = -62
clear_junk_threshold = 20
mined = 0

function organize()
    for i = 1,16 do
        if turtle.getItemCount(i) > 0 and turtle.getItemCount(i) < 64 then
            turtle.select(i)
            for j = i+1,16 do
                if turtle.compareTo(j) then
                    turtle.select(j)
                    turtle.transferTo(i)
                    turtle.select(i)
                end
            end
        end
    end
    
    for i = 1,16 do
        if turtle.getItemCount(i) > 0 then
            for j = 1,i do
                if turtle.getItemCount(j) == 0 then
                    turtle.select(i)
                    turtle.transferTo(j)
                    break
                end
            end
        end
    end
end

function dig()
    turtle.dig()
    mined = mined + 1

    if mined >= clear_junk_threshold then
        remove_junk()
        mined = 0
    end
end

function dig_up()
    turtle.digUp()
    mined = mined + 1

    if mined >= clear_junk_threshold then
        remove_junk()
        mined = 0
    end
end

function dig_down()
    turtle.digDown()
    mined = mined + 1

    if mined >= clear_junk_threshold then
        remove_junk()
        mined = 0
    end
end

function has_value(table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

function is_block_wanted(block_name)
    if has_value(unwanted, block_name) then
        return false
    end
    return true
end

function inspect_up()
    local success, block = turtle.inspectUp()
    if success then
        if is_block_wanted(block.name) then
          dig_up()
          return true
        end 
    end

    return false
end

function inspect_down()
    local success, block = turtle.inspectDown()
    if success then
        if is_block_wanted(block.name) then
          dig_down()
          return true
        end 
    end

    return false
end

function assert_down()
    local success = turtle.down()
    while not success do
        dig_down()
        success = turtle.down()
    end
end

function remove_junk()
    organize() 
    print("removing junk")
    for i = 1,16,1 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item then
            if not is_block_wanted(item.name) then
                turtle.drop()
            end
        end
    end 
end

function assert_up()
    local success = turtle.up()
    while not success do
        dig_up()
        success = turtle.up()
    end
end

function assert_forward()
    local success = turtle.forward()
    while not success do
        dig()
        success = turtle.forward()
    end
end

function inspect_forward()
    local success, block = turtle.inspect()
    if success then
        if is_block_wanted(block.name) then
            dig()
          return true
        end 
    end

    return false
end

function check_edge()
    assert_forward()

    inspect_forward()  
    inspect_down() 
    inspect_up()
    turtle.turnLeft()    
    inspect_forward()
    turtle.turnRight()    
    turtle.turnRight()    
    inspect_forward()
    turtle.turnRight()    

    assert_forward()
    turtle.turnLeft()    
end


function dig_layer()
    local mined, x

    for x = 1, 3, 1 do
    
        mined = inspect_forward()

        if mined then
            check_edge()
        else
            turtle.turnRight()
        end
    end

    mined = inspect_forward()

    if mined then
        check_edge()
    end

    dig_down()
    assert_down()
end
    

local home = vector.new(45, 85, 20)
local position = vector.new(gps.locate(5))
local displacement = position - home

local x, y, z = gps.locate(5)
print(x)
print(y)
print(z)


print("Network out of range. Enter height manually.")
    height = read()

num_levels = height - stop_level
print("Dig down"..num_levels)

fuel_needed = 10*num_levels
print("We need ".. fuel_needed)
print("We have ".. turtle.getFuelLevel())

for y = 1, num_levels, 1 do
    dig_layer()
end

remove_junk()

for y = 1, num_levels, 1 do
    assert_up()
end




