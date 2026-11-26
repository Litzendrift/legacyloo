local Unit = {}

UnitData = require("src.unitData")
Units = {}

local unitIdCounter = 1


---@param unitName string
---@param x integer
---@param y integer
---@param allegianceName string
---@param color table
---@param cityName string
---@return boolean
function Unit.spawnUnit(unitName, x, y, allegianceName, color, cityName)

    if (not UnitData[unitName]) then
        return false
    end

    local newUnit = Utils.shallowClone(UnitData[unitName])

    newUnit.id = unitIdCounter
    newUnit.alive = true
    newUnit.x = x
    newUnit.y = y
    newUnit.allegianceName = allegianceName
    newUnit.color = color
    newUnit.cityName = cityName

    unitIdCounter = unitIdCounter + 1

    Units[newUnit.id] = newUnit

    return newUnit
end


function Unit.destroyUnit(unit)
    local unitId = unit.id

    print("destroy", unitId)

    if Player.selectedUnit == unit then
        Player.selectedUnit = false
    end

    Units[unit.id].alive = false
end


function Unit.calculateTotalTravelTime(speed, distance)
    return distance / speed
end


function Unit.draw()
    for _, unit in ipairs(Units) do
        if unit.alive then
            unit:draw()
        end
    end
end


return Unit