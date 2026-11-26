local Allegiance = {}

Allegiances = require("src.allegianceData")
AllegiancesInGame = {"finland", "australia", "japan"}

function Allegiance.init()

    for _, allegianceName in ipairs(AllegiancesInGame) do
        print(allegianceName)

        City.spawnCapital(Allegiances[allegianceName].capital, allegianceName)   

    end

end


function Allegiance.update()

    -- for _, allegiance in 
end



return Allegiance