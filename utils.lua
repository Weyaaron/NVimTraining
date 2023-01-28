
function play_levelup_sound()
    
    os.execute("play ding.flac 2> /dev/null")
end
function play_success_sound()
    
    os.execute("play click.flac 2> /dev/null")
end
function play_failure_sound()
    
    os.execute("play clack.flac 2> /dev/null")
end

exports = { play_failure_sound, play_success_sound, play_levelup_sound }
return exports
