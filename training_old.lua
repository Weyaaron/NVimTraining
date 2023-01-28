
index_table = { prev_y_index = 0, prev_x_index = 0 }
additional_data = { streak= 0, last_task_type = "u" }




BaseTask = {desc = "A generic task"}

function BaseTask:new(object)
    o = object or {}
    setmetatable(o, self)
    self.__index = self
    return o
end 

TaskUp = BaseTask:new()

function TaskUp:check_for_sucess()

    cursor =  vim.api.nvim_win_get_cursor(0)

    return cursor[1] == index_table.prev_x_index-1
end

TaskDown = BaseTask:new()

function TaskDown:check_for_sucess()

    cursor =  vim.api.nvim_win_get_cursor(0)

    return cursor[1] == index_table.prev_x_index+1
    
end


function task_right()
    function inner_func()

    cursor =  vim.api.nvim_win_get_cursor(0)
    return cursor[2] == index_table.prev_y_index +1 
    end 
    return task_body(inner_func)
end

function task_left()
    function inner_func()

    cursor =  vim.api.nvim_win_get_cursor(0)
    return cursor[2] == index_table.prev_y_index-1
    end 
    return task_body(inner_func)
end

function task_down()
    function inner_func()

    cursor =  vim.api.nvim_win_get_cursor(0)
    return cursor[1] == index_table.prev_x_index+1 
    end 
    return task_body(inner_func)
end


function task_body(task_function)
    
    if task_function() then

       additional_data.streak = additional_data.streak  +1 

       play_success_sound()
       return  "Success down "
    else 
        play_failure_sound()
        additional_data.streak = 0 
        return "Failure down"

    end 
        
        
end

task_types = { TaskDown, TaskUp }

display_elements = {float_buffer = nil, float_window = nil }

local os = require("os")


function play_levelup_sound()
    
    os.execute("play ding.flac 2> /dev/null")
end
function play_success_sound()
    
    os.execute("play click.flac 2> /dev/null")
end
function play_failure_sound()
    
    os.execute("play clack.flac 2> /dev/null")
end

function main(autocmd_args)
    
    if task_data.current_task.check_for_sucess()
        task_data.current_task.success()
    else: 
        task_data.current_task.failure()
    

    if additional_data.streak > 3 then
        play_levelup_sound()
    end
    index_table.prev_x_index = cursor[1]
    index_table.prev_y_index = cursor[2]
    additional_data.last_task_type = task_types[math.random(1,2)]
    --print_content = print_content .. "\n\n" .. additional_data.last_task_type


end

function setup()

vim.api.nvim_create_autocmd({"CursorMoved"}, {
  callback = main,
})
display_elements.float_buffer = vim.api.nvim_create_buf(false, false) 


float_window = vim.api.nvim_open_win(display_elements.float_buffer, false,
  {relative='win', row=20, col=20, width=12, height=12})

display_elements.float_window = float_window
display_text({"Hallo"})

end 

function display_text( input_text)

vim.api.nvim_buf_set_lines(display_elements.float_buffer,0,-1, false, input_text)
end



setup()
