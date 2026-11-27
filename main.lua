local player = {
    pos = {
        x = 0,
        y = 0,
    },

    x = 0,
    y = 0,
    speed = 200,
}


local gridLines = {}

WindowWidth, WindowHeight = love.graphics.getDimensions()

function love.load()
    Utils = require("src.utils")
    Camera = require("libraries.camera")
    Timer = require("libraries.timer")
    Draw = require("src.draw")

    Unit = require("src.unit")

    UiElements = require("src.uiElements")

    ReusableUiElements = require("src.reusableUiElements")

    Player = require("src.player")
    City = require("src.city")
    Tile = require("src.tile")
    Allegiance = require("src.allegiance")

    math.randomseed(os.time())

    Tile.init()
    Allegiance.init()

    FlagImages160 = {}
    FlagImages2560 = {}
    local function loadFlagImages()
        for _, allegianceName in ipairs(AllegiancesInGame) do
            local flagCode = Allegiances[allegianceName].flagName
            FlagImages160[allegianceName] = love.graphics.newImage("/images/flags160/" .. flagCode .. ".png")
            FlagImages2560[allegianceName] = love.graphics.newImage("/images/flags160/" .. flagCode .. ".png")
        end
    end
    loadFlagImages()

    UiElementPriorityDraw = {}

    local function initUiElements()
        for _, uiElement in pairs(UiElements) do
            uiElement.init(uiElement)

            table.insert(UiElementPriorityDraw, uiElement)
        end
    end

    initUiElements()
    print(Utils.dump(UiElementPriorityDraw))

    

    cam = Camera(player.pos.x, player.pos.y)


    love.keyboard.setKeyRepeat(true)

    -- verticle lines
    for x = 0, MapWidth, TileSize do
        local line = {x, 0, x, MapHeight}
        table.insert(gridLines, line)
    end

    -- horizontal lines
    for y = 0, MapHeight, TileSize do
        local line = {0, y, MapHeight, y}
        table.insert(gridLines, line)
    end

    Timer.every(1, function() City.update() end)
end


function love.update(dt)
    Timer.update(dt)

    -- direction
    local dx, dy = 0, 0

    if love.keyboard.isDown("w") then dy = dy - 1 end
    if love.keyboard.isDown("a") then dx = dx - 1 end
    if love.keyboard.isDown("s") then dy = dy + 1 end
    if love.keyboard.isDown("d") then dx = dx + 1 end

    -- normalize diagonal movement, so it isn't faster
    local length = math.sqrt(dx ^ 2 + dy ^ 2)
    if length > 0 then
        dx, dy = dx / length, dy / length
    end

    player.x = player.x + dx * player.speed * dt
    player.y = player.y + dy * player.speed * dt


    cam:lookAt(player.x, player.y)
end


function love.draw()

    cam:attach()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
    for _, line in ipairs(gridLines) do
        love.graphics.line(line)
    end

    Tile.draw()

    City.draw()

    Draw.drawCamera()

    cam:detach()

    local hoverCity = Player.hoverCity
    if hoverCity then
        local screenX, screenY = cam:cameraCoords(hoverCity.x, hoverCity.y)
        screenX, screenY = Utils.roundToInteger(screenX), Utils.roundToInteger(screenY)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(hoverCity.name, screenX, screenY)
    end

    Draw.drawAfterCamera()

    -- crosshair
    -- local crosshairSize = 15
    -- local screenWidth, screenHeight = love.graphics.getDimensions()
    -- love.graphics.setLineWidth(2)
    -- love.graphics.setColor(0, 1, 1, 0.5)
    -- love.graphics.line(screenWidth / 2, screenHeight / 2 - crosshairSize / 2, screenWidth / 2, screenHeight / 2 + crosshairSize / 2)
    -- love.graphics.line(screenWidth / 2 - crosshairSize / 2, screenHeight / 2, screenWidth / 2 + crosshairSize / 2, screenHeight / 2)

end


local function isMouseHoverOverCity(mouseX, mouseY)
    local hoverCityDistanceRequired = 1

    local x, y = cam:worldCoords(mouseX, mouseY)

    for _, c in pairs(Cities) do
        local distance = Utils.distance(x, y, c.x, c.y)
        if distance <= c.size + hoverCityDistanceRequired then
            return c
        end
    end

    return false
end


local function isMouseHoverOverUnit(mouseX, mouseY)
    local hoverUnitDistanceRequired = 5

    local x, y = cam:worldCoords(mouseX, mouseY)

    for _, u in pairs(Units) do
        if (not u.alive) then
            goto continue
        end 
        local distance = Utils.distance(x, y, u.x, u.y)
        if distance <= u.hitboxSize + hoverUnitDistanceRequired then
            return u
        end
        ::continue::
    end

    return false
end


function love.mousemoved(x, y, dx, dy, istouch)
    Player.hoverUnit = isMouseHoverOverUnit(x, y)
    if Player.hoverUnit then
        return
    end
    
    Player.hoverCity = isMouseHoverOverCity(x, y)
    if Player.hoverCity then
        return
    end
end


local function activateUiAndSetToLargestDrawPriority(ui)
    ui.active = true
    local index = Utils.findIndex(UiElementPriorityDraw, ui)
    if (not index) then
        return
    end

    table.remove(UiElementPriorityDraw, index)
    table.insert(UiElementPriorityDraw, ui)
end


function love.mousepressed(x, y, button, istouch)
    print("clicked at: ", x, y)

    if button == 1 then
        for _, ui in ipairs(UiElementPriorityDraw) do
            print("ui state: ", ui.active)
            if ui.active == false then
                goto continue
            end

            for _, buttonThing in pairs(ui.buttons) do
                if (Utils.isCoordInBox(x, y, buttonThing.x, buttonThing.y, buttonThing.width, buttonThing.height)) then
                    print("clicked button", buttonThing)
                    buttonThing:onClick()
                    return
                end
            end

            ::continue::
        end

        if (Player.selectedUnit) then
            print("move")
            local worldX, worldY = cam:worldCoords(x, y)

            Player.selectedUnit:move(worldX, worldY)
            Player.selectedUnit = false
        end

        if (Player.hoverCity) then
            print("open city ui")
            Player.selectedCity = Player.hoverCity
            activateUiAndSetToLargestDrawPriority(UiElements.cityUi)
            UiElements.settlerUi.active = false
            UiElements.shipUi.active = false

        else if (Player.hoverUnit) then
            print("open unit ui")
            Player.selectedUnit = Player.hoverUnit
            if (Player.selectedUnit) and (Player.selectedUnit.name == "settler") then
                activateUiAndSetToLargestDrawPriority(UiElements.settlerUi)
                UiElements.shipUi.active = false
            end

            if (Player.selectedUnit) and (Player.selectedUnit.name == "ship") then
                activateUiAndSetToLargestDrawPriority(UiElements.shipUi)
                UiElements.settlerUi.active = false
            end
            
            UiElements.cityUi.active = false
        end
        end
    end
end


function love.keypressed(key, scancode, isrepeat)
   if key == "e" then
        print("toggle menu ui")
        if (UiElements.menuUi.active == false) then
            activateUiAndSetToLargestDrawPriority(UiElements.menuUi) 
        else
            UiElements.menuUi.active = false
        end
   end
end



function love.resize(w, h)
    WindowWidth, WindowHeight = w, h
end