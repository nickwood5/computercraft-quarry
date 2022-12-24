
unwanted = {
    "minecraft:dirt",
    "minecraft:stone",
    "minecraft:grass_block",
    "minecraft:diorite",
    "minecraft:andesite",
    "minecraft:gravel",
    "minecraft:sand"
}

stop_level = -57

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
        print("Block name: ", block.name)
        print("Block metadata: ", block.metadata)
        
        if is_block_wanted(block.name) then
          print("yes")
          turtle.digUp()
          return true
        end 
    end

    return false
end

function inspect_down()
    local success, block = turtle.inspectDown()
    if success then
        print("Block name: ", block.name)
        print("Block metadata: ", block.metadata)
        
        if is_block_wanted(block.name) then
          print("yes")
          turtle.digDown()
          return true
        end 
    end

    return false
end

function assert_forward()
    local success = turtle.forward()
    while not success do
        turtle.dig()
        success = turtle.forward()
    end
end

function inspect_forward()
    local success, block = turtle.inspect()
    if success then
        print("Block name: ", block.name)
        print("Block metadata: ", block.metadata)
        
        if is_block_wanted(block.name) then
          print("yes")
          turtle.dig()
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
        end
        turtle.turnRight()
    end

    mined = inspect_forward()

    if mined then
        check_edge()
    end

    turtle.digDown()
    turtle.down()
end
    

local home = vector.new(45, 85, 20)
local position = vector.new(gps.locate(5))
local displacement = position - home

local x, y, z = gps.locate(5)
print(x)
print(y)
print(z)


for y = 1, 100, 1 do
    dig_layer()
end

for y = 1, 100, 1 do
    turtle.up()
end




