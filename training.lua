
BaseTask = {desc = "A generic task", setup_desc = "Base setup" }

function BaseTask:new(object)
    o = object or {}
    setmetatable(o, self)
    self.__index = self
    return o
end 

function BaseTask:cycle_setup()
   display_text({"Task:".. self.setup_desc})
end

function BaseTask:success()
    play_success_sound()
    display_text( {"Success"})

    
end

function BaseTask:failure()
 play_failure_sound()
 display_text({"Failure"})
end


    

TaskUp = BaseTask:new({setup_desc= "Move a line up" })

function TaskUp:check_for_sucess()

    cursor =  vim.api.nvim_win_get_cursor(0)

    return cursor[1] == prev_x_index-1
end

TaskDown = BaseTask:new({setup_desc= "Move a line down"})

function TaskDown:check_for_sucess()

    cursor =  vim.api.nvim_win_get_cursor(0)

    return cursor[1] == prev_x_index+1
    
end

display_elements = {float_buffer = nil, float_window = nil }

local os = require("os")
local utility = require("utils")
last_task = TaskUp
streak = 0
prev_x_index = 0
prev_y_index = 0
task_types = {TaskUp, TaskDown}


function main(autocmd_args)
    



    if  last_task.check_for_sucess() then
        last_task.success()
    else
        last_task.failure()
    end

    if  streak > 3 then
        utility.play_levelup_sound()
    end
    prev_x_index = cursor[1]
    prev_y_index = cursor[2]
    last_task= task_types[math.random(1,2)]
    last_task.cycle_setup(last_task)

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
