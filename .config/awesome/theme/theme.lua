--[[

     Powerarrow Awesome WM theme
     github.com/lcpz

--]]
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local dpi = require("beautiful.xresources").apply_dpi

local math, string, os = math, string, os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local solarized = {
    bg_dark_dark = "#002b36",
    bg_dark_light = "#073642",
    fg_dark_dark = "#586e75",
    fg_dark_light = "#657b83",
    bg_light_dark = "#eee8d5",
    bg_light_light = "#93a1a1",
    fg_light_dark = "#839496",
    fg_light_light = "#93a1a1",
    accent_yellow = "#b58900",
    accent_orange = "#cb4b16",
    accent_red = "#dc322f",
    accent_magenta = "#d33682",
    accent_violet = "#6c71c4",
    accent_blue = "#268bd2",
    accent_cyan = "#2aa198",
    accent_green = "#859900"
}

local theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/theme"
theme.wallpaper = theme.dir .. "/wall.png"
theme.font = "xos4 Terminus 9"
theme.fg_normal = "#F0F0F0"
theme.fg_dim = "#808080"
theme.fg_focus = "#32D6FF"
theme.fg_urgent = solarized.accent_orange
theme.bg_normal = solarized.bg_dark_dark
theme.bg_focus = solarized.bg_dark_light
theme.bg_urgent = "#3F3F3F"
theme.taglist_fg_focus = theme.fg_focus
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_focus = theme.fg_focus
theme.border_width = dpi(2)
theme.border_normal = solarized.fg_dark_dark
theme.border_focus = solarized.accent_blue
theme.border_marked = solarized.accent_orange
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_focus = theme.fg_focus
theme.menu_height = dpi(16)
theme.menu_width = dpi(140)
theme.menu_submenu_icon = theme.dir .. "/icons/submenu.png"
theme.awesome_icon = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile = theme.dir .. "/icons/tile.png"
theme.layout_tileleft = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv = theme.dir .. "/icons/fairv.png"
theme.layout_fairh = theme.dir .. "/icons/fairh.png"
theme.layout_spiral = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle = theme.dir .. "/icons/dwindle.png"
theme.layout_max = theme.dir .. "/icons/max.png"
theme.layout_fullscreen = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier = theme.dir .. "/icons/magnifier.png"
theme.layout_floating = theme.dir .. "/icons/floating.png"
theme.widget_ac = theme.dir .. "/icons/ac.png"
theme.widget_battery = theme.dir .. "/icons/battery.png"
theme.widget_battery_low = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty = theme.dir .. "/icons/battery_empty.png"
theme.widget_brightness = theme.dir .. "/icons/brightness.png"
theme.widget_mem = theme.dir .. "/icons/mem.png"
theme.widget_cpu = theme.dir .. "/icons/cpu.png"
theme.widget_temp = theme.dir .. "/icons/temp.png"
theme.widget_net = theme.dir .. "/icons/net.png"
theme.widget_hdd = theme.dir .. "/icons/hdd.png"
theme.widget_music = theme.dir .. "/icons/note.png"
theme.widget_music_on = theme.dir .. "/icons/note_on.png"
theme.widget_music_pause = theme.dir .. "/icons/pause.png"
theme.widget_music_stop = theme.dir .. "/icons/stop.png"
theme.widget_vol = theme.dir .. "/icons/vol.png"
theme.widget_vol_low = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail = theme.dir .. "/icons/mail.png"
theme.widget_mail_on = theme.dir .. "/icons/mail_on.png"
theme.widget_task = theme.dir .. "/icons/task.png"
theme.widget_scissors = theme.dir .. "/icons/scissors.png"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true
theme.useless_gap = dpi(10)
theme.titlebar_close_button_focus = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- Text clock
local textclock = wibox.widget.textclock("%d.%m. | %H:%M")

-- Calendar
theme.cal =
    lain.widget.cal(
    {
        --cal = "cal --color=always",
        attach_to = {textclock},
        notification_preset = {
            font = "xos4 Terminus 10",
            fg = theme.fg_normal,
            bg = theme.bg_normal
        }
    }
)

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem =
    lain.widget.mem(
    {
        settings = function()
            widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
        end
    }
)

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu =
    lain.widget.cpu(
    {
        settings = function()
            widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
        end
    }
)

-- Coretemp (lm_sensors, per core)
local temp, temp_timer =
    awful.widget.watch(
    {awful.util.shell, "-c", "echo arstdawfw"},
    1,
    function(widget, stdout)
        widget:set_markup(markup.font(theme.font, stdout))
    end
    -- awful.widget.watch(
    -- "bash -c sensors",
    -- 1,
    -- function(widget, stdout)
    --     local temps = ""
    --     for line in stdout:gmatch("[^\r\n]+") do
    --         temps = temps .. line:match("+(%d+).*°C") .. "° " -- in Celsius
    --     end
    --     widget:set_markup(markup.font(theme.font, " " .. temps))
    -- end
)
--]]
--[[ Coretemp (lain, average)
local temp =
    lain.widget.temp(
    {
        settings = function()
            widget:set_markup(markup.font(theme.font, " " .. coretemp_now .. "°C "))
        end
    }
)
--]]
local tempicon = wibox.widget.imagebox(theme.widget_temp)

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat =
    lain.widget.bat(
    {
        settings = function()
            if bat_now.status and bat_now.status ~= "N/A" then
                if bat_now.ac_status == 1 then
                    widget:set_markup(markup.font(theme.font, " AC "))
                    baticon:set_image(theme.widget_ac)
                    return
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                    baticon:set_image(theme.widget_battery_empty)
                elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                    baticon:set_image(theme.widget_battery_low)
                else
                    baticon:set_image(theme.widget_battery)
                end
                widget:set_markup(markup.font(theme.font, " " .. bat_now.perc .. "% "))
            else
                widget:set_markup()
                baticon:set_image(theme.widget_ac)
            end
        end
    }
)

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net =
    lain.widget.net(
    {
        settings = function()
            widget:set_markup(
                markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " ")
            )
        end
    }
)

-- Separators
local arrow = separators.arrow_left

local widget_colors = {
    background = theme.bg_normal,
    filler = solarized.bg_dark_light,
    filler_light = solarized.fg_light_dark,
    systray = theme.bg_normal,
    clock = solarized.accent_green,
    net = solarized.accent_cyan,
    battery = solarized.accent_magenta,
    temp = solarized.accent_orange,
    cpu = solarized.accent_yellow,
    mem = solarized.accent_violet
}

function theme.at_screen_connect(s)
    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- {{{ Tags with Charitable
    local tags = awful.layout.tags
    -- Show an unselected tag when a screen is connected
    for i = 1, #tags do
        if not tags[i].selected then
            tags[i].screen = s
            tags[i]:view_only()
            break
        end
    end

    -- create a special scratch tag for double buffering
    s.scratch = awful.tag.add("scratch-" .. s.index, {})

    s.mytaglist =
        awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        source = function(screen, args)
            return tags
        end,
        widget_template = {
            {
                {
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox
                    },
                    layout = wibox.layout.fixed.horizontal
                },
                left = 16,
                right = 16,
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
            shape = gears.shape.powerline,
            create_callback = function(self, tag, index, taglist)
                if index % 2 == 0 then
                    self.bg = theme.bg_focus
                else
                    self.bg = theme.bg_normal
                end
                if #tag:clients() > 0 then
                    self.fg = theme.fg_normal
                else
                    self.fg = theme.fg_dim
                end
            end,
            update_callback = function(self, tag, index, taglist)
                if #tag:clients() > 0 then
                    self.fg = theme.fg_normal
                else
                    self.fg = theme.fg_dim
                end
            end
        },
        buttons = awful.util.taglist_buttons
    }
    -- }}}

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(
        my_table.join(
            awful.button(
                {},
                1,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                2,
                function()
                    awful.layout.set(awful.layout.layouts[1])
                end
            ),
            awful.button(
                {},
                3,
                function()
                    awful.layout.inc(-1)
                end
            ),
            awful.button(
                {},
                4,
                function()
                    awful.layout.inc(1)
                end
            ),
            awful.button(
                {},
                5,
                function()
                    awful.layout.inc(-1)
                end
            )
        )
    )

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox =
        awful.wibar({position = "top", screen = s, height = dpi(16), bg = theme.bg_normal, fg = theme.fg_normal})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            arrow(alpha, widget_colors.filler),
            arrow(widget_colors.filler, widget_colors.mem),
            wibox.container.background(
                wibox.container.margin(
                    wibox.widget {memicon, mem.widget, layout = wibox.layout.align.horizontal},
                    dpi(2),
                    dpi(3)
                ),
                widget_colors.mem
            ),
            arrow(widget_colors.mem, widget_colors.cpu),
            wibox.container.background(
                wibox.container.margin(
                    wibox.widget {cpuicon, cpu.widget, layout = wibox.layout.align.horizontal},
                    dpi(3),
                    dpi(4)
                ),
                widget_colors.cpu
            ),
            arrow(widget_colors.cpu, widget_colors.temp),
            wibox.container.background(
                wibox.container.margin(
                    wibox.widget {tempicon, temp.widget, layout = wibox.layout.align.horizontal},
                    dpi(4),
                    dpi(4)
                ),
                widget_colors.temp
            ),
            arrow(widget_colors.temp, widget_colors.battery),
            wibox.container.background(
                wibox.container.margin(
                    wibox.widget {baticon, bat.widget, layout = wibox.layout.align.horizontal},
                    dpi(3),
                    dpi(3)
                ),
                widget_colors.battery
            ),
            arrow(widget_colors.battery, widget_colors.net),
            wibox.container.background(
                wibox.container.margin(
                    wibox.widget {nil, neticon, net.widget, layout = wibox.layout.align.horizontal},
                    dpi(3),
                    dpi(3)
                ),
                widget_colors.net
            ),
            arrow(widget_colors.net, widget_colors.clock),
            wibox.container.background(wibox.container.margin(textclock, dpi(4), dpi(8)), widget_colors.clock),
            arrow(widget_colors.clock, widget_colors.systray),
            --]]
            wibox.container.background(
                wibox.container.margin(wibox.widget.systray(), dpi(4), dpi(4)),
                widget_colors.systray
            ),
            arrow(widget_colors.systray, widget_colors.filler),
            arrow(widget_colors.filler, alpha),
            s.mylayoutbox
        }
    }
end

return theme
