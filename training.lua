
index_table = { prev_y_index = 0, prev_x_index = 0 }
additional_data = { streak= 0, last_task_type = "u" }
task_types = { "u", "d", "l", "r"}



function main(autocmd_args)
    
    print_content = ""

    cursor =  vim.api.nvim_win_get_cursor(0)

    if additional_data.last_task_type == "u" then
        
    if cursor[1] == index_table.prev_x_index-1 then
       print_content = print_content .. "Success"
    end
        print("Fail up")
    end

    if additional_data.last_task_type == "d" then
    if cursor[1] == index_table.prev_x_index+1 then


       print_content = print_content .. "Success"
    end

        print("Fail down")
end

    index_table.prev_x_index = cursor[1]
    index_table.prev_y_index = cursor[2]
    additional_data.last_task_type = task_types[math.random(1,2)]
    print_content = print_content .. additional_data.last_task_type


    print(print_content)
    --print("Move your Cursor left")
end

function setup()

vim.api.nvim_create_autocmd({"CursorMoved"}, {
  callback = main,
})
end

setup()
