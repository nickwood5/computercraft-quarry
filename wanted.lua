unwanted = {
    "minecraft:dirt",
    "minecraft:stone",
    "minecraft:grass_block",
    "minecraft:diorite",
    "minecraft:andesite",
    "minecraft:gravel",
    "minecraft:sand",
    "minecraft:rail",
    "minecraft:oak_fence",
    "minecraft:oak_planks",
    "minecraft:cobbled_deepslate",
    "minecraft:deepslate",
    "minecraft:tuff",
    "minecraft:water",
    "minecraft:lava",
    "minecraft:granite"
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

success, block = turtle.inspect()
if success then
    print("Block name: ", block.name)
    print("Block metadata: ", block.metadata)
    
    if is_block_wanted(block.name) then
      print("yes")
      turtle.dig()
    end 
end