local Projectile = {}

ProjectileData = require("src.projectilesData")
Projectiles = {}

local projectileIdCounter = 1

function Projectile.spawnProjectile(projectileName, x, y, allegianceName, color)

    if (not ProjectileData[projectileName]) then
        return false
    end

    local newProjectile = Utils.shallowClone(ProjectileData[projectileName])

    newProjectile.id = projectileIdCounter
    newProjectile.active = true
    newProjectile.x = x
    newProjectile.y = y
    newProjectile.allegianceName = allegianceName
    newProjectile.color = color

    projectileIdCounter = projectileIdCounter + 1

    Projectiles[newProjectile.id] = newProjectile

    return newProjectile
end


return Projectile