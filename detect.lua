function check_names() 
    for i = 1,16,1 do
        turtle.select(i)
        item = turtle.getItemDetail()
        if item then
            print(item.name)
        end
    end 
end

check_names() 