
unwanted = {
    "minecraft:dirt"
}

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

local home = vector.new(45, 85, 20)
local position = vector.new(gps.locate(5))
local displacement = position - home

local x, y, z = gps.locate(5)
print(x)
print(y)
print(z)

local success, data = turtle.inspect()

if success then
  print("Block name: ", data.name)
  print("Block metadata: ", data.metadata)
  
  if is_block_wanted(data.name) then
    print("yes")
  else
    print("no")
  end 
end