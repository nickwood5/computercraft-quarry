-- (x = 1, y = 0, z = 0)

x_dir = 1
y_dir = 0

x_location = 0
y_location = 0
z_location = 0

function right()
    turtle.turnRight()

    if x_dir == 1 then
        new_x_dir = 0
        new_y_dir = 1
    elseif x_dir == -1 then
        new_x_dir = 0
        new_y_dir = -1
    elseif y_dir == 1 then
        new_y_dir = 0
        new_x_dir = -1
    elseif y_dir == -1 then
        new_y_dir = 0
        new_x_dir = 1
    end

    print("Turning left, new x dir is "..new_x_dir)
    print("Turning left, new y dir is "..new_x_dir)

    x_dir = new_x_dir
    y_dir = new_y_dir
end

function left()
    turtle.turnLeft()


    if x_dir == 1 then
        new_x_dir = 0
        new_y_dir = -1
    elseif x_dir == -1 then
        new_x_dir = 0
        new_y_dir = 1
    elseif y_dir == 1 then
        new_y_dir = 0
        new_x_dir = 1
    elseif y_dir == -1 then
        new_y_dir = 0
        new_x_dir = -1
    end

    print("Turning left, new x dir is "..new_x_dir)
    print("Turning left, new y dir is "..new_x_dir)

    x_dir = new_x_dir
    y_dir = new_y_dir
end



function down_break_forward(blocks)
    for x = 1, blocks, 1 do
        success = false
        while not success do
            turtle.digDown()
            success = turtle.down()
            turtle.dig()
        end

        z_location = z_location - 1
        print("Bot is at x: ".. x_location .. " y: ".. y_location .. " z: "..z_location)
    end 
end

function down(blocks)
    for x = 1, blocks, 1 do
        success = false
        while not success do
            turtle.digDown()
            success = turtle.down()
        end

        z_location = z_location - 1
        print("Bot is at x: ".. x_location .. " y: ".. y_location .. " z: "..z_location)
    end 
end
 
function up_break_forward(blocks)
    for x = 1, blocks, 1 do
        success = false
        while not success do
            turtle.digUp()
            success = turtle.up()
            turtle.dig()
        end

        z_location = z_location + 1
        print("Bot is at x: ".. x_location .. " y: ".. y_location .. " z: "..z_location)
    end 
end

function up(blocks)
    for x = 1, blocks, 1 do
        success = false
        while not success do
            turtle.digUp()
            success = turtle.up()
        end

        z_location = z_location + 1
        print("Bot is at x: ".. x_location .. " y: ".. y_location .. " z: "..z_location)
    end 
end
 
function forward(blocks)
    for x = 1, blocks, 1 do
        success = false
        while not success do
            turtle.dig()
            success = turtle.forward()
        end

        x_location = x_location + x_dir
        y_location = y_location + y_dir
        print("Bot is at x: ".. x_location .. " y: ".. y_location .. " z: "..z_location)
    end
end

function mine_single_strip(depth)
    down_break_forward(depth)
    forward(2)
    turtle.dig()
    organize()
    remove_junk() 
    if is_turtle_full() then
        print("Turtle is full")
        deposit()
    end
    up_break_forward(depth)
    remove_junk() 
    if is_turtle_full() then
        print("Turtle is full")
        deposit()
    end
    forward(1)
end

function mine_complete_strip(strips, depth)
    for x = 1, strips, 1 do
        mine_single_strip(depth)
    end
end

function remove_junk() 
    for i = 1,16,1 do
        turtle.select(i)
        a = turtle.getItemDetail()
        if a then
            if a.name =="minecraft:dirt" or a.name == "minecraft:cobblestone" then
                turtle.drop()
            end
        end
    end 
end

function drop_all()
    for i = 1,16,1 do
        turtle.select(i)
        turtle.drop()
    end 
end

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

function deposit()
    blocks_moved = -z_location + x_location + y_location
    x_blocks = x_location
    y_blocks = y_location
    z_blocks = -z_location

    x_dir_save = x_dir
    y_dir_save = y_dir

    fuel_expended = ((blocks_moved - (blocks_moved % 80)) / 80) + 1

    up(-z_location)
    correct_y = false
    while not correct_y do
        left()
        if y_dir == -1 then
            correct_y = true
        end
    end
    forward(y_location)

    correct_x = false
    while not correct_x do
        left()
        if x_dir == -1 then
            correct_x = true
        end
    end
    forward(x_location)
    
    drop_all()
    right()
    turtle.suck(fuel_expended)
    turtle.refuel(fuel_expended)

    for i = 1,16,1 do
        turtle.select(i)
        a = turtle.getItemDetail()
        if a then
            turtle.refuel()
        end
    end 

    right()
    forward(x_blocks)
    right()
    forward(y_blocks)
    down(z_blocks)

    correct_direction = false
    while not correct_direction do
        left()
        if x_dir == x_dir_save and y_dir == y_dir_save then
            correct_direction = true
        end
    end

end

function end_mine()
    up(-z_location)
    correct_y = false
    while not correct_y do
        left()
        if y_dir == -1 then
            correct_y = true
        end
    end
    forward(y_location)

    correct_x = false
    while not correct_x do
        left()
        if x_dir == -1 then
            correct_x = true
        end
    end
    forward(x_location)
    
    drop_all()
    right()
    right()
end


function mine_single_chunk(strips, depth)
    mine_complete_strip(strips, depth)
    right()
    forward(1)
    right()
    mine_complete_strip(strips, depth)
    left()
    forward(1)
    left()
end

function mine_complete_chunk(strips, depth)
    mine_single_chunk(strips, depth)
    mine_single_chunk(strips, depth)
end

function is_turtle_full()
    for i = 1,16,1 do
        turtle.select(i)
        a = turtle.getItemDetail()
        if a == nil then
            return false
        end
    end 
    return true
end

left()
area = 4*4*50*2

area = ((8*8*65) / 2) + 8 + 8


current_fuel = turtle.getFuelLevel()

coal_needed = ((area - (area % 80)) / 80) + 1
print("Needs "..coal_needed)





turtle.suck(coal_needed)
right()
for i = 1,16,1 do
    turtle.select(i)
    a = turtle.getItemDetail()
    if a then
        turtle.refuel()
    end
end 

x_chunks = 2
y_chunks = 2

for y_chunks = 1, y_chunks, 1 do
    mine_complete_chunk(x_chunks, 65)
end

end_mine()