return {

    bullet = {
        x = 0,
        y = 0,
        width = 3,
        height = 5,

        speed = 50,

        rotation = 0,

        fireAtCity = function(self, startX, startY, city)
            self:move(startX, startY)
        end,

        ---comment
        ---@param self any
        ---@param destinationX number
        ---@param destinationY number
        move = function(self, destinationX, destinationY)

            -- override previous movement
            if (self.moveHandleX) then
                Timer.cancel(self.moveHandleX)
            end
            if (self.moveHandleY) then
                Timer.cancel(self.moveHandleY)
            end


            local x, y = self.x, self.y - self.height / 2
            -- add math.pi / 2 since we defined the triangle's tip from upright position and love.graphics.rotate starts from right
            self.rotation = Utils.angle(x, y, destinationX, destinationY) + math.pi / 2

            local distance = Utils.distance(x, y, destinationX, destinationY)
            local totalTravelTime = Unit.calculateTotalTravelTime(self.speed, distance)

            local moveHandleX = Timer.tween(totalTravelTime, self, {x = destinationX}, 'linear')
            local moveHandleY = Timer.tween(totalTravelTime, self, {y = destinationY}, 'linear')

            self.moveHandleX = moveHandleX
            self.moveHandleY = moveHandleY

        end,

        draw = function(self)
            local centerX = self.x + self.width / 2
            local centerY = self.y + self.height / 2

            local x1 = self.x + self.width
            local y1 = self.y

            local x2 = self.x
            local y2 = self.y + self.height

            local x3 = self.x + self.width
            local y3 = self.y + self.height

            love.graphics.setColor(self.color)
            love.graphics.push()
            love.graphics.translate(centerX, centerY)
            love.graphics.rotate(self.rotation)
            love.graphics.translate(-centerX, -centerY)
            love.graphics.polygon("fill", self.x, self.y, x1, y1, x2, y2, x3, y3)
            love.graphics.pop()
        end,
    }

}