PaperWM = hs.loadSpoon("PaperWM")
PaperWM:bindHotkeys({
    refresh_windows      = { { "cmd" }, "forwarddelete" },
    toggle_floating      = { { "cmd" }, "padclear" },
    focus_left           = { { "cmd" }, "left" },
    focus_right          = { { "cmd" }, "right" },
    focus_up             = { { "cmd" }, "up" },
    focus_down           = { { "cmd" }, "down" },
    swap_left            = { { "alt", "cmd" }, "left" },
    swap_right           = { { "alt", "cmd" }, "right" },
    swap_up              = { { "alt", "cmd" }, "up" },
    swap_down            = { { "alt", "cmd" }, "down" },
    center_window        = { { "cmd" }, "padenter" },
    full_width           = { { "cmd" }, "pad=" },
    cycle_width          = { { "cmd" }, "pad+" },
    cycle_height         = { { "cmd" }, "pad-" },
    reverse_cycle_width  = { { "alt", "cmd" }, "pad+" },
    reverse_cycle_height = { { "alt", "cmd" }, "pad-" },
    slurp_in             = { { "cmd" }, "pad*" },
    barf_out             = { { "cmd" }, "pad/" },
    switch_space_l       = { { "cmd" }, "," },
    switch_space_r       = { { "cmd" }, "pad." },
    switch_space_1       = { { "cmd" }, "pad1" },
    switch_space_2       = { { "cmd" }, "pad2" },
    switch_space_3       = { { "cmd" }, "pad3" },
    switch_space_4       = { { "cmd" }, "pad4" },
    switch_space_5       = { { "cmd" }, "pad5" },
    switch_space_6       = { { "cmd" }, "pad6" },
    switch_space_7       = { { "cmd" }, "pad7" },
    switch_space_8       = { { "cmd" }, "pad8" },
    switch_space_9       = { { "cmd" }, "pad9" },
    move_window_1        = { { "alt", "cmd" }, "pad1" },
    move_window_2        = { { "alt", "cmd" }, "pad2" },
    move_window_3        = { { "alt", "cmd" }, "pad3" },
    move_window_4        = { { "alt", "cmd" }, "pad4" },
    move_window_5        = { { "alt", "cmd" }, "pad5" },
    move_window_6        = { { "alt", "cmd" }, "pad6" },
    move_window_7        = { { "alt", "cmd" }, "pad7" },
    move_window_8        = { { "alt", "cmd" }, "pad8" },
    move_window_9        = { { "alt", "cmd" }, "pad9" }
})
PaperWM.window_filter:rejectApp("ClipBook")
PaperWM:start()

ActiveSpace = hs.loadSpoon("ActiveSpace")
ActiveSpace:start()
