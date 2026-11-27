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


function Unit.shootCity(unit, city)

    if (city.health > 0) and (unit.damage > 0) then

        local bullet = {
            x = unit.x,
            y = unit.y,
            color = unit.color
        }

        city.health = city.health - unit.damage

    end

end


function Unit.checkHitbox(unit)

    -- loop through all units
    for _, u in ipairs(Units) do
        if (u.allegianceName == unit.allegianceName) then
            goto continue
        end

        if u.alive then
            if (Utils.distance(unit.x, unit.y, u.x, u.y)) <= unit.hitboxSize then
                print("is hitting other unit")


            end
        end
        ::continue::
    end 

    for _, c in pairs(Cities) do
        if (c.allegianceName == unit.allegianceName) then
            goto continue
        end

        if (Utils.distance(unit.x, unit.y, c.x, c.y)) <= unit.hitboxSize then
            c.underSeige = true

            print("city health:", c.health)

            Unit.shootCity(unit, c)

            print("new city health:", c.health)

        end
        ::continue::
    end

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