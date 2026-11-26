


local Draw = {}


function Draw.drawBeforeCamera()

end


function Draw.drawCamera()

    Unit.draw()

end


function Draw.drawAfterCamera()
    for _, ui in ipairs(UiElementPriorityDraw) do
        ui:draw()
    end

end


return Draw