return {
    ---@param x integer
    ---@param y integer
    ---@param size integer
    ---@param thickness integer
    ---@param color table
    ---@return nil
    drawCross = function (x, y, size, thickness, color)
        love.graphics.setColor(color)
        love.graphics.setLineWidth(thickness)

        love.graphics.line(x - size / 2, y - size / 2, x + size / 2, y + size / 2)
        love.graphics.line(x - size / 2, y + size / 2, x + size / 2, y - size / 2)
    end,

    ---@param x integer
    ---@param y integer
    ---@param width integer
    ---@param height integer
    ---@param color table
    ---@return nil
    drawButton = function(x, y, width, height, color)
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x, y, width, height)
    end
}