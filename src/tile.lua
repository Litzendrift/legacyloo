local Tile = {}

TileSize = 50

MapWidthTiles = 10
MapHeightTiles = 10

MapWidth = TileSize * MapWidthTiles
MapHeight = TileSize * MapHeightTiles

TilePadding = 2

TileOutlines = {}
TileHighlights = {}

Map = {} -- the map of the game


function Tile.init()

    local TileData = {
        allegianceName = false,
    }

    for x = 0, MapWidthTiles - 1 do
        Map[x] = {}
        for y = 0, MapHeightTiles - 1 do
            local t = Utils.shallowClone(TileData)
            t.tileX = x
            t.tileY = y
            Map[x][y] = t
        end
    end

end


function Tile.draw()
    for _, tileOutline in ipairs(TileOutlines) do
        love.graphics.setColor(tileOutline.color)
        for _, line in ipairs(tileOutline.lines) do
            love.graphics.line(line)
        end
    end

    for _, tileHighlight in ipairs(TileHighlights) do
        love.graphics.setColor(tileHighlight.color)
        love.graphics.rectangle(tileHighlight.rectangle)
    end
end


function Tile.pickRandomNoAllegianceTile()
    local noAllegianceTiles = {}

    for x = 0, MapWidthTiles - 1 do
        for y = 0, MapHeightTiles - 1 do

            local t = Map[x][y]

            if t.allegianceName == false then
                table.insert(noAllegianceTiles, t)
            end

        end
    end

    if #noAllegianceTiles == 0 then
        return false
    end

    return noAllegianceTiles[math.random(1, #noAllegianceTiles)]
end


function Tile.pickRandomCoordsInsideTile(t)

    local minX, minY = t.tileX * TileSize, t.tileY * TileSize

    return minX + love.math.random(TilePadding, TileSize - TilePadding), minY + love.math.random(TilePadding, TileSize - TilePadding)

end


function Tile.outlineTile(tileX, tileY, color)
    local colorToSet = color or {1, 1, 1, 1}

    local x, y = tileX * TileSize, tileY * TileSize

    local topLine = {x, y, x + TileSize, y}
    local bottomLine = {x, y + TileSize, x + TileSize, y + TileSize}
    local leftLine = {x, y, x, y + TileSize}
    local rightLine = {x + TileSize, y, x + TileSize, y + TileSize}

    local tileOutline = {lines = {topLine, bottomLine, leftLine, rightLine}, color = colorToSet}

    table.insert(TileOutlines, tileOutline)
end


function Tile.highlightInsides(t)
    local tileX, tileY = t.tileX, t.tileY
    local x, y = tileX * TileSize, tileY * TileSize

    if (t.allegianceName == false) then
        return
    end

    local color = Allegiances[t.allegianceName].color
    color[4] = 0

    local tileHighlight = {rectangle = {"fill", x, y, TileSize, TileSize}, color = color}

    table.insert(TileHighlights, tileHighlight)
end


return Tile