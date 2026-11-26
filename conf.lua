function love.conf(t)
    t.identity = "legacy-loo"
    t.version = "11.5"
    t.console = false

    -- Native game resolution. Web builds (love.js) need an explicit canvas
    -- size since there is no desktop to query.
    t.window.width = 800
    t.window.height = 600
    t.window.title = "Legacy Loo"

    -- resizable=true here breaks love.js (canvas collapses to ~1x1).
    -- Desktop enables resizing via setMode in src/startup/gameStart.lua.
    t.window.resizable = true
    t.window.borderless = false
    t.window.fullscreen = false
    t.window.vsync = 1
end