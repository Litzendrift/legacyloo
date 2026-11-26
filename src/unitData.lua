return {

    settler = {
        id = -1,
        name = "settler",
        x = 0,
        y = 0,
        allegianceName = "UNKNOWN",
        speed = 15,
        health = 15,
        maxHealth = 15,
        damage = 0,
        color = {1, 1, 1, 1},
        height = 20,
        width = 10,
        rotation = 0,
        hitboxSize = 10,
        cost = 10000000,

        ---comment
        ---@param self any
        ---@param destinationX number
        ---@param destinationY number
        move = function(self, destinationX, destinationY)

            if (self.tweenHandle) then
                Timer.cancel(self.tweenHandle)
            end
            if (self.tweenHandle2) then
                Timer.cancel(self.tweenHandle2)
            end


            local x, y = self.x, self.y - self.height / 2
            -- add math.pi / 2 since we defined the triangle's tip from upright position and love.graphics.rotate starts from right
            self.rotation = Utils.angle(x, y, destinationX, destinationY) + math.pi / 2

            local distance = Utils.distance(x, y, destinationX, destinationY)
            local totalTravelTime = Unit.calculateTotalTravelTime(self.speed, distance)

            local tweenHandle = Timer.tween(totalTravelTime, self, {x = destinationX}, 'linear')
            local tweenHandle2 = Timer.tween(totalTravelTime, self, {y = destinationY}, 'linear')

            self.tweenHandle = tweenHandle
            self.tweenHandle2 = tweenHandle2

        end,

        draw = function(self)

            local centerX, centerY = self.x, self.y

            local x, y = centerX, centerY - self.height / 2
            local x1, y1 = centerX - self.width / 2, centerY + self.height / 2
            local x2, y2 = centerX + self.width / 2, centerY + self.height / 2

            love.graphics.setColor(self.color)
            love.graphics.push()
            -- rotation center
            love.graphics.translate(centerX, centerY)
            love.graphics.rotate(self.rotation)
            -- move it back
            love.graphics.translate(-centerX, -centerY)
            love.graphics.polygon("fill", x, y, x1, y1, x2, y2)
            love.graphics.pop()

        end,
    },


    ship = {
        id = -1,
        name = "ship",
        x = 0,
        y = 0,
        allegianceName = "UNKNOWN",
        speed = 15,
        health = 135,
        maxHealth = 135,
        damage = 5,
        color = {1, 1, 1, 1},
        height = 20,
        width = 10,
        rotation = 0,
        hitboxSize = 10,
        cost = 5000000,

        ---comment
        ---@param self any
        ---@param destinationX number
        ---@param destinationY number
        move = function(self, destinationX, destinationY)

            if (self.tweenHandle) then
                Timer.cancel(self.checkHitboxHandle)
                Timer.cancel(self.tweenHandle)
            end
            if (self.tweenHandle2) then
                Timer.cancel(self.checkHitboxHandle)
                Timer.cancel(self.tweenHandle2)
            end


            local x, y = self.x, self.y - self.height / 2
            -- add math.pi / 2 since we defined the triangle's tip from upright position and love.graphics.rotate starts from right
            self.rotation = Utils.angle(x, y, destinationX, destinationY) + math.pi / 2

            local distance = Utils.distance(x, y, destinationX, destinationY)
            local totalTravelTime = Unit.calculateTotalTravelTime(self.speed, distance)

            local tweenHandle = Timer.tween(totalTravelTime, self, {x = destinationX}, 'linear')
            local tweenHandle2 = Timer.tween(totalTravelTime, self, {y = destinationY}, 'linear')
            -- performance very very bad, it is not ending when the ship has moved to its destination
            local checkHitboxHandle = Timer.every(0.1, function() Unit.checkHitbox(self) end)

            self.tweenHandle = tweenHandle
            self.tweenHandle2 = tweenHandle2
            self.checkHitboxHandle = checkHitboxHandle

        end,

        draw = function(self)

            local centerX, centerY = self.x, self.y

            local x, y = centerX, centerY - self.height / 2
            local x1, y1 = centerX - self.width / 2, centerY + self.height / 2
            local x2, y2 = centerX + self.width / 2, centerY + self.height / 2

            love.graphics.setColor(self.color)
            love.graphics.push()
            -- rotation center
            love.graphics.translate(centerX, centerY)
            love.graphics.rotate(self.rotation)
            -- move it back
            love.graphics.translate(-centerX, -centerY)
            love.graphics.polygon("fill", x, y, x1, y1, x2, y2)
            love.graphics.pop()

        end,
    },

}