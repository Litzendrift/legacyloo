return {

    cityUi = {
        name = "cityUi",
        active = false,
        x = 0,
        y = 0,
        width = 150,
        height = 200,
        color = {33 / 255, 31 / 255, 31 / 255},
        pad = 10,
        layer = 1,
        buttons = {},

        position = function(self)

            self.x = self.pad
            self.y = WindowHeight - self.height - self.pad

        end,

        init = function(self)
            
            self:position()

            local guiCloseButton = {
                x = self.x + self.width - 15,
                y = self.y,
                width = 15,
                height = 15,
                color = {1, 0, 0, 1},

                onClick = function()
                    self.active = false
                    Player.selectedCity = false
                end,
            }

            local spawnSettlerButton = {
                x = self.x,
                y = self.y + 115,
                width = 50,
                height = 20,
                color = {74 / 255, 69 / 255, 69 / 255},

                onClick = function()
                    local sc = Player.selectedCity
                    local allegiance = Allegiances[sc.allegianceName]

                    local cost = UnitData.settler.cost
                    if not cost then
                        return false
                    end

                    if not (allegiance.treasury >= cost) then
                        return false
                    end

                    allegiance.treasury = allegiance.treasury - cost
                    Unit.spawnUnit("settler", sc.x, sc.y, sc.allegianceName, sc.color, sc.name)

                    return true
                end,
            }

            local spawnShipButton = {
                x = self.x,
                y = self.y + 145,
                width = 50,
                height = 20,
                color = {74 / 255, 69 / 255, 69 / 255},

                onClick = function()
                    local sc = Player.selectedCity
                    local allegiance = Allegiances[sc.allegianceName]

                    local cost = UnitData.ship.cost
                    if not cost then
                        return false
                    end

                    if not (allegiance.treasury >= cost) then
                        return false
                    end

                    allegiance.treasury = allegiance.treasury - cost
                    Unit.spawnUnit("ship", sc.x, sc.y, sc.allegianceName, sc.color, sc.name)

                    return true
                end
            }

            local developCityButton = {
                x = self.x,
                y = self.y + 175,
                width = 50,
                height = 25,
                color = {74 / 255, 69 / 255, 69 / 255},

                onClick = function()
                    local sc = Player.selectedCity
                    local allegiance = Allegiances[sc.allegianceName]

                    local cost = City.calculateCostOfDevelopingCity(sc)

                    if not cost then
                        return false
                    end

                    if not (allegiance.treasury >= cost) then
                        return false
                    end

                    allegiance.treasury = allegiance.treasury - cost
                    sc.tier = sc.tier + 1

                    return true
                end,
            }

            self.buttons.guiCloseButton = guiCloseButton
            self.buttons.spawnSettlerButton = spawnSettlerButton
            self.buttons.spawnShipButton = spawnShipButton
            self.buttons.developCityButton = developCityButton
           
        end,

        draw = function(self)

            if (not self.active) then
                return
            end

            local selectedCity = Player.selectedCity
            if (not selectedCity) then
                return
            end

            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

            love.graphics.setColor({1, 1, 1, 1})
            local image = FlagImages160[selectedCity.allegianceName]
            local targetWidth, targetHeight = 86, 48
            local scaleX = targetWidth / image:getWidth()
            local scaleY = targetHeight / image:getHeight()
            love.graphics.draw(image, self.x, self.y, 0, scaleX, scaleY)

            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print(selectedCity.name, self.x, self.y + 55)

            love.graphics.print("city tier: " .. selectedCity.tier, self.x, self.y + 67)

            love.graphics.print("population: " .. selectedCity.population, self.x, self.y + 79)

            love.graphics.print("income: " .. City.calculateCityIncome(selectedCity), self.x, self.y + 91)

            local guiCloseButton = self.buttons.guiCloseButton
            ReusableUiElements.drawButton(guiCloseButton.x, guiCloseButton.y, guiCloseButton.width, guiCloseButton.height, guiCloseButton.color)
            ReusableUiElements.drawCross(self.x + self.width - 15 + (15/2), self.y + 15/2, 10, 2, {0, 0, 0, 1})

            local b = self.buttons.spawnSettlerButton
            ReusableUiElements.drawButton(b.x, b.y, b.width, b.height, b.color)
            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print("settler", b.x, b.y)
            love.graphics.setNewFont(10)
            love.graphics.print("cost: " .. UnitData.settler.cost, b.x + b.width, b.y)

            local b3 = self.buttons.spawnShipButton
            ReusableUiElements.drawButton(b3.x, b3.y, b3.width, b3.height, b3.color)
            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print("ship", b3.x, b3.y)
            love.graphics.setNewFont(10)
            love.graphics.print("cost: " .. UnitData.ship.cost, b3.x + b3.width, b3.y)
            love.graphics.setNewFont(12)

            local b2 = self.buttons.developCityButton
            ReusableUiElements.drawButton(b2.x, b2.y, b2.width, b2.height, b2.color)
            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.setNewFont(10)
            love.graphics.print("develop \ncity", b2.x, b2.y)
            local costDevelopCity = City.calculateCostOfDevelopingCity(selectedCity)
            if (not costDevelopCity) then
                costDevelopCity = "MAX"
            end
            love.graphics.print("cost: " .. costDevelopCity, b2.x + b2.width, b2.y)
            love.graphics.setNewFont(12)

            --love.graphics.print("income: " .. selectedCity.income, self.x, self.y + 85)
        end,
    },


    settlerUi = {
        name = "settlerUi",
        active = false,
        x = 0,
        y = 0,
        width = 150,
        height = 200,
        color = {33 / 255, 31 / 255, 31 / 255},
        pad = 10,
        layer = 1,
        buttons = {},

        position = function(self)

            self.x = self.pad
            self.y = WindowHeight - self.height - self.pad

        end,

        init = function(self)
            
            self:position()

            local guiCloseButton = {
                x = self.x + self.width - 15,
                y = self.y,
                width = 15,
                height = 15,
                color = {1, 0, 0, 1},

                onClick = function()
                    self.active = false
                    Player.selectedUnit = false
                end,
            }

            local buildCityButton = {
                x = self.x,
                y = self.y + 100,
                width = 50,
                height = 20,
                color = {74 / 255, 69 / 255, 69 / 255},

                onClick = function()
                    local u = Player.selectedUnit

                    local city = City.spawnCity(false, u.x, u.y, u.allegianceName)

                    if (city) then
                        Unit.destroyUnit(u)
                        Player.selectedUnit = false
                        return true
                    end

                    return false
                end,
            }

            self.buttons.guiCloseButton = guiCloseButton
            self.buttons.buildCityButton = buildCityButton

        end,

        draw = function(self)

            if (not self.active) then
                return
            end

            local selectedUnit = Player.selectedUnit
            if (not selectedUnit) then
                return
            end
            
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

            love.graphics.setColor({1, 1, 1, 1})
            local image = FlagImages160[selectedUnit.allegianceName]
            local targetWidth, targetHeight = 86, 48
            local scaleX = targetWidth / image:getWidth()
            local scaleY = targetHeight / image:getHeight()
            love.graphics.draw(image, self.x, self.y, 0, scaleX, scaleY)

            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print(selectedUnit.name, self.x, self.y + 55)

            love.graphics.setColor({1, 0, 0, 1})
            love.graphics.rectangle("fill", self.x + 3, self.y + 68, self.width - self.pad, 5)
            
            local healthPercentage = selectedUnit.health / selectedUnit.maxHealth
            love.graphics.setColor({0, 1, 0, 1})
            love.graphics.rectangle("fill", self.x + 3, self.y + 68, (self.width - self.pad) * healthPercentage, 5)
            --love.graphics.print("(" .. selectedUnit.x .. ", " .. selectedUnit.y .. ")", self.x, self.y + 65)

            local guiCloseButton = self.buttons.guiCloseButton
            ReusableUiElements.drawButton(guiCloseButton.x, guiCloseButton.y, guiCloseButton.width, guiCloseButton.height, guiCloseButton.color)
            ReusableUiElements.drawCross(self.x + self.width - 15 + (15/2), self.y + 15/2, 10, 2, {0, 0, 0, 1})

            local b = self.buttons.buildCityButton
            ReusableUiElements.drawButton(b.x, b.y, b.width, b.height, b.color)
            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print("build city", b.x, b.y)

        end,

    },


    shipUi = {
        name = "shipUi",
        active = false,
        x = 0,
        y = 0,
        width = 150,
        height = 200,
        color = {33 / 255, 31 / 255, 31 / 255},
        pad = 10,
        layer = 1,
        buttons = {},

        position = function(self)

            self.x = self.pad
            self.y = WindowHeight - self.height - self.pad

        end,

        init = function(self)
            
            self:position()

            local guiCloseButton = {
                x = self.x + self.width - 15,
                y = self.y,
                width = 15,
                height = 15,
                color = {1, 0, 0, 1},

                onClick = function()
                    self.active = false
                    Player.selectedUnit = false
                end,
            }

            local disbandButton = {
                x = self.x,
                y = self.y + 100,
                width = 50,
                height = 20,
                color = {74 / 255, 69 / 255, 69 / 255},

                onClick = function()
                    local u = Player.selectedUnit

                    u.alive = false
                    Player.selectedUnit = false

                    return false
                end,
            }

            self.buttons.guiCloseButton = guiCloseButton
            self.buttons.disbandButton = disbandButton

        end,

        draw = function(self)

            if (not self.active) then
                return
            end

            local selectedUnit = Player.selectedUnit
            if (not selectedUnit) then
                return
            end
            
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

            love.graphics.setColor({1, 1, 1, 1})
            local image = FlagImages160[selectedUnit.allegianceName]
            local targetWidth, targetHeight = 86, 48
            local scaleX = targetWidth / image:getWidth()
            local scaleY = targetHeight / image:getHeight()
            love.graphics.draw(image, self.x, self.y, 0, scaleX, scaleY)

            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print(selectedUnit.name, self.x, self.y + 55)

            love.graphics.setColor({1, 0, 0, 1})
            love.graphics.rectangle("fill", self.x + 3, self.y + 68, self.width - self.pad, 5)
            
            local healthPercentage = selectedUnit.health / selectedUnit.maxHealth
            love.graphics.setColor({0, 1, 0, 1})
            love.graphics.rectangle("fill", self.x + 3, self.y + 68, (self.width - self.pad) * healthPercentage, 5)
            --love.graphics.print("(" .. selectedUnit.x .. ", " .. selectedUnit.y .. ")", self.x, self.y + 65)

            local guiCloseButton = self.buttons.guiCloseButton
            ReusableUiElements.drawButton(guiCloseButton.x, guiCloseButton.y, guiCloseButton.width, guiCloseButton.height, guiCloseButton.color)
            ReusableUiElements.drawCross(self.x + self.width - 15 + (15/2), self.y + 15/2, 10, 2, {0, 0, 0, 1})

            local b = self.buttons.disbandButton
            ReusableUiElements.drawButton(b.x, b.y, b.width, b.height, b.color)
            love.graphics.setColor({1, 1, 1, 1})
            love.graphics.print("disband", b.x, b.y)

        end,

    },


    menuUi = {
        name = "menuUi",
        active = false,
        x = 0,
        y = 0,
        width = 300,
        height = 200,
        color = {33 / 255, 31 / 255, 31 / 255},
        pad = 10,
        layer = 1,
        buttons = {},

        position = function(self)

            self.x = WindowWidth / 2 - self.width / 2
            self.y = WindowHeight / 2 - self.height / 2

        end,

        init = function(self)

            self:position()

            local statsTabButton = {
                x = self.x,
                y = self.y,

                onClick = function()
                    print("switch to stats tab")
                end
            }

            function statsTabButton:init(x, y, width, height)
                self.x = x
                self.y = y
                self.width = width
                self.height = height
            end

            local policiesTabButton = {
                x = self.x,
                y = self.y,

                onClick = function()
                    print("switch to policies tab")
                end
            }

            function policiesTabButton:init(x, y, width, height)
                self.x = x
                self.y = y
                self.width = width
                self.height = height
            end

            self.buttons.statsTabButton = statsTabButton
            self.buttons.policiesTabButton = policiesTabButton

        end,

        draw = function(self)

            if (not self.active) then
                return
            end

            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

            love.graphics.setColor({1, 1, 1, 1})
            local image = FlagImages160[Player.allegianceName]
            local targetWidth, targetHeight = 86, 48
            local scaleX = targetWidth / image:getWidth()
            local scaleY = targetHeight / image:getHeight()
            love.graphics.draw(image, self.x, self.y, 0, scaleX, scaleY)


            local font = love.graphics.getFont()
            love.graphics.print("STATS", self.x + targetWidth + 5, self.y + 10)
            local stb = self.buttons.statsTabButton
            local w, h = font:getWidth("STATS"), font:getHeight()
            stb.init(stb, self.x+targetWidth + 5, self.y + 10, w, h)

            love.graphics.print("POLICIES", self.x + targetWidth + 55, self.y + 10)
            local ptb = self.buttons.policiesTabButton
            local w2, h2 = font:getWidth("POLICIES"), font:getHeight()
            ptb.init(ptb, self.x+targetWidth + 55, self.y + 10, w2, h2)


            love.graphics.setColor({1, 0, 0, 1})
            love.graphics.rectangle("fill", self.x + 3, self.y + 68, self.width - self.pad, 5)

        end,
    },
}