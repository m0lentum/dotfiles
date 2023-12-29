local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local lain = require("lain")
local gears = require("gears")
local charitable = require("charitable")
local beautiful = require("beautiful")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- screenshot commands require maim, ifne and sed to be installed.
-- transparency removal assumes transparency is created by picom.
local screenshot_pipe =
    " | ifne tee ~/Pictures/Screenshots/$(date +%y-%m-%d_%T)_$(xdotool getwindowname $(xdotool getactivewindow) | sed 's/ /_/g').png | xclip -sel clip -t image/png"
local screenshot_normal = function(maim_opts)
    return 'bash -c "maim -o ' .. maim_opts .. screenshot_pipe .. '"'
end
local screenshot_nocompton = function(maim_opts)
    return 'bash -c "systemctl --user stop picom && maim -o ' .. maim_opts .. screenshot_pipe .. ' && systemctl --user start picom"'
end

local globalkeys =
    my_table.join(
    awful.key(
        {modkey}, "s",
        hotkeys_popup.show_help,
        {description = "show help", group = "awesome"}
    ),
    -- custom wallpaper slideshow thing, functions defined in rc.lua
    awful.key(
        {modkey}, "w",
        toggle_slideshow,
        {description = "toggle wallpaper slideshow", group = "screen"}
    ),
    awful.key(
        {modkey, "Shift"}, "w",
        const_wallpaper,
        {description = "set constant wallpaper", group = "screen"}
    ),
    -- Spotify
    awful.key(
        {}, "XF86AudioPlay",
        function()
            awful.spawn(
                "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
            )
        end
    ),
    awful.key(
        {}, "XF86AudioNext",
        function()
            awful.spawn(
                "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
            )
        end
    ),
    awful.key(
        {}, "XF86AudioPrev",
        function()
            awful.spawn(
                "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
            )
        end
    ),
    --
    -- Screenshots w/ maim
    --
    awful.key(
        {}, "Print",
        function() awful.spawn(screenshot_normal("--select --hidecursor")) end,
        {description = "custom area", group = "screenshots"}
    ),
    awful.key(
        {altkey}, "Print",
        function() awful.spawn(screenshot_nocompton("--select --hidecursor")) end,
        {description = "custom area, no transparency", group = "screenshots"}
    ),
    awful.key(
        {"Shift"}, "Print",
        function() awful.spawn(screenshot_normal("-i $(xdotool getactivewindow) -B")) end,
        {description = "active window", group = "screenshots"}
    ),
    awful.key(
        {altkey, "Shift"}, "Print",
        function() awful.spawn(screenshot_normal("-i $(xdotool getactivewindow)")) end,
        {description = "active window, no transparency", group = "screenshots"}
    ),
    --
    -- Screen blank
    --
    awful.key(
        {modkey}, "z",
        function() awful.spawn("xset dpms force off") end,
        {description = "Blank the screen", group = "screen"}
    ),
    --
    --
    -- Navigation
    --
    --
    awful.key(
        {modkey}, "p",
        awful.tag.history.restore,
        {description = "go back", group = "tag"}
    ),
    awful.key(
        {modkey}, "j",
        function() awful.client.focus.byidx(1) end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key(
        {modkey}, "k",
        function() awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}
    ),
    -- By direction client focus
    awful.key(
        {modkey}, "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus down", group = "client"}
    ),
    awful.key(
        {modkey}, "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus up", group = "client"}
    ),
    awful.key(
        {modkey}, "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus left", group = "client"}
    ),
    awful.key(
        {modkey}, "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "focus right", group = "client"}
    ),
    awful.key(
        {modkey}, "End",
        function() awful.screen.focus_bydirection("right") end,
        {description = "focus the screen on the right", group = "screen"}
    ),
    awful.key(
        {modkey}, "Home",
        function() awful.screen.focus_bydirection("left") end,
        {description = "focus the screen on the left", group = "screen"}
    ),
    --
    --
    -- Layout
    --
    --
    awful.key(
        {modkey, altkey}, "Left",
        function() awful.client.swap.bydirection("left") end,
        {description = "swap with client on the left", group = "client"}
    ),
    awful.key(
        {modkey, altkey}, "Right",
        function() awful.client.swap.bydirection("right") end,
        {description = "swap with client on the right", group = "client"}
    ),
    awful.key(
        {modkey, altkey}, "Up",
        function() awful.client.swap.bydirection("up") end,
        {description = "swap with client above", group = "client"}
    ),
    awful.key(
        {modkey, altkey}, "Down",
        function() awful.client.swap.bydirection("down") end,
        {description = "swap with client below", group = "client"}
    ),
    awful.key(
        {modkey}, "b",
        function()
            for s in screen do
                s.mywibox.visible = not s.mywibox.visible
                if s.mybottomwibox then
                    s.mybottomwibox.visible = not s.mybottomwibox.visible
                end
            end
        end,
        {description = "toggle wibox", group = "awesome"}
    ),
    awful.key(
        {modkey}, "Prior",
        function() awful.tag.incmwfact(0.025) end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key(
        {modkey}, "Next",
        function() awful.tag.incmwfact(-0.025) end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"}, "Prior",
        function() awful.tag.incnmaster(1, nil, true) end,
        {description = "increase the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Shift"}, "Next",
        function() awful.tag.incnmaster(-1, nil, true) end,
        {description = "decrease the number of master clients", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"}, "Prior",
        function() awful.tag.incncol(1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"}, "Next",
        function() awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}
    ),
    awful.key(
        {modkey, altkey}, "Prior",
        -- increment_padding defined in rc.lua
        function() increment_padding(-40) end,
        {description = "decrease screen padding", group = "layout"}
    ),
    awful.key(
        {modkey, altkey}, "Next",
        function() increment_padding(40) end,
        {description = "increase screen padding", group = "layout"}
    ),
    awful.key(
        {modkey, "Control"}, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}
    ),
    --
    --
    -- Shortcuts
    --
    --
    awful.key(
        {modkey}, "Return",
        function() awful.spawn(terminal) end,
        {description = "open a terminal", group = "launcher"}
    ),
    awful.key(
        {modkey, "Control"}, "r",
        awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),
    awful.key(
        {modkey, "Control", "Shift"}, "q", 
        awesome.quit, 
        {description = "quit awesome", group = "awesome"}
    ),
    -- User programs
    awful.key(
        {modkey}, "q",
        function() awful.spawn(browser) end,
        {description = "run browser", group = "launcher"}
    ),
    awful.key(
        {modkey}, "r",
        function() awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"}
    ),
    awful.key(
        {modkey}, "a",
        function() awful.spawn("obsidian") end,
        {description = "run obsidian", group = "launcher"}
    )
)

local clientkeys =
    my_table.join(
    awful.key(
        {modkey}, "m", 
        lain.util.magnify_client, 
        {description = "magnify client", group = "client"}
    ),
    awful.key(
        {modkey, "Shift"}, "q",
        function(c) c:kill() end,
        {description = "close", group = "client"}
    ),
    awful.key(
        {modkey, altkey}, "Home",
        function(c)
            local target = c.screen:get_next_in_direction("left")
            if target then
                c:move_to_screen(target)
            end
        end,
        {description = "move to screen on the left", group = "client"}
    ),
    awful.key(
        {modkey, altkey}, "End",
        function(c)
            local target = c.screen:get_next_in_direction("right")
            if target then
                c:move_to_screen(target)
            end
        end,
        {description = "move to screen on the right", group = "client"}
    ),
    awful.key(
        {modkey}, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {description = "minimize", group = "client"}
    ),
    awful.key(
        {modkey}, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "fullscreen", group = "client"}
    )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys =
        my_table.join(
        globalkeys,
        -- View tag only.
        awful.key(
            {modkey},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = awful.layout.tags[i]
                if tag then
                    charitable.select_tag(tag, screen)
                end
            end,
            descr_view
        ),
        -- Toggle tag display.
        awful.key(
            {modkey, "Control"},
            "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = awful.layout.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle
        ),
        -- Move client to tag.
        awful.key(
            {modkey, altkey},
            "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.layout.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move
        ),
        -- Toggle tag on focused client.
        awful.key(
            {modkey, "Control", "Shift"},
            "#" .. i + 9,
            function()
                charitable.toggle_tag(tags[i], awful.screen.focused())
            end,
            descr_toggle_focus
        )
    )
end

local clientbuttons =
    gears.table.join(
    awful.button(
        {},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end
    ),
    awful.button(
        {modkey},
        1,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end
    ),
    awful.button(
        {modkey},
        3,
        function(c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end
    )
)

return function()
    return globalkeys, clientkeys, clientbuttons
end
