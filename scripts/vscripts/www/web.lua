if web == nil then
	web = class({})
end

function web:init()
	web:start_game()
end

function web:start_game()
	print("hello")
    Shop:get_db_info()
    print("hello")
end