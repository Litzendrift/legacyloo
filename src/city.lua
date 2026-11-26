local City = {}

Cities = {}

local maxCityTier = 7

local randomCityNames = require("src.randomCityNames")


local function calculateTileCoordinates(x, y)
    local tileX = (x / TileSize)
    local tileY = (y / TileSize)
    
    return math.floor(tileX), math.floor(tileY)
end


function City.new(name, x, y, allegianceName)

    local newCity = {
        name = name,
        x = x,
        y = y,
        allegianceName = allegianceName,
        size = 5,
        population = 1000,
        color = {1, 1, 1, 1},
        tier = 1, -- tiers 1 to 7
        underSeige = false,
    }

    newCity.tileX, newCity.tileY = calculateTileCoordinates(x, y)
    newCity.color = Allegiances[allegianceName].color
    newCity.health = City.calculateCityHealth(newCity)

    Cities[newCity.name] = newCity

    return newCity

end


function City.spawnCity(name, x, y, allegianceName)
    if (not name) then
        name = City.pickRandomCityNameThenRemove(allegianceName)
        if (not name) then
            return false
        end
    end

    local previewCity = {
        name = name,
        x = x, 
        y = y,
        allegianceName = allegianceName,
    }
    previewCity.tileX, previewCity.tileY = calculateTileCoordinates(x, y)

    local fufillRequirements, failMessage = City.isFufillCityRequirements(previewCity)

    if (not fufillRequirements) then
        print(failMessage)
        return false
    end

    local city = City.new(name, x, y, allegianceName)

    return city
end


function City.spawnCapital(name, allegianceName)

    -- pick a random tile
    local tile = Tile.pickRandomNoAllegianceTile()

    if tile then
        tile.allegianceName = allegianceName

        -- pick random coordinates inside the tile
        local x, y = Tile.pickRandomCoordsInsideTile(tile)

        local city = City.spawnCity(name, x, y, allegianceName)
        -- all capitals start with 10000 population
        city.population = 10000
    end

end


function City.pickRandomCityNameThenRemove(allegianceName)
    if (not randomCityNames[allegianceName]) then
        return false
    end

    local randomIndex = math.random(1, #randomCityNames[allegianceName])

    table.remove(randomCityNames[allegianceName], randomIndex)

    return randomCityNames[allegianceName][randomIndex]
end


function City.isFufillCityRequirements(c)

    local minDistanceApart = 10

    -- check if city is a min distance from all other cities
    -- only check against cities that are in the same tile as the previewCity
    for _, otherCity in pairs(Cities) do

        if not (otherCity.tileX == c.tileX) or not (otherCity.tileY == c.tileY) then
            goto continue
        end
        
        local distance = Utils.distance(c.x, c.y, otherCity.x, otherCity.y)
        if distance >= minDistanceApart then
            return false
        end

        ::continue::
    end

    return true

end


function City.calculateCityHealth(c)
    return Utils.roundToInteger((c.population * 0.05) * ((c.tier * 0.01) + 1))
end


function City.calculateNewPopulation(c)
    local populationGrowthPercentage = c.tier * 0.01

    local populationAdded = Utils.roundToInteger(c.population * populationGrowthPercentage)
    local newPopulation = c.population + populationAdded

    return newPopulation
end


function City.calculateCitySizeAccordingToPopulation(c)
    local population = c.population

    if ((population) < 10000) then
        return 5
    end

    if ((population) >= 10000000) then
        return 15
    end

    return ((10 / 9990000) * population) - (100000 / 9990000) + 5

end


function City.calculateCostOfDevelopingCity(c)
    if (c.tier >= maxCityTier) then
        return false
    end

    return Utils.roundToInteger((c.population * 6) * (1.2 ^ (c.tier)))
end


function City.calculateCityIncome(c)
    return Utils.roundToInteger((c.population / 5) * (1.15 ^ c.tier))
end


function City.update()
    for _, c in pairs(Cities) do
        local newPopulation = City.calculateNewPopulation(c)
        c.population = newPopulation

        local newSize = City.calculateCitySizeAccordingToPopulation(c)
        c.size = newSize

        if (not c.underSeige) then
            local newHealth = City.calculateCityHealth(c)
            c.health = newHealth
        end
        
    end
end


function City.draw()
    for _, c in pairs(Cities) do
        love.graphics.setColor(c.color)
        love.graphics.setPointSize(c.size)
        love.graphics.points(c.x, c.y)
    end
end


return City