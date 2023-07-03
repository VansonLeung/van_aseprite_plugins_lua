--[[
==Pixel Outline v1.00 (LUA)==
Outlines current layer with 1px of fg colour

By Rik Nicol / @hot_pengu / https://github.com/rikfuzz/aseprite-scripts

Requirements
Aseprite (Currently requires Aseprite v1.2.10-beta2)
Click "Open Scripts Folder" in File > Scripts and drag the script into the folder.
]]--




function alert(txt)

    local dlg = Dialog {
        title = txt
    }

    dlg:button {
      id = "ok",
      text = "OK",
      onclick = function()
        dlg:close()
      end
    }

    dlg:show {wait = false}

end



function lerp(first, second, by)
  return first * (1 - by) + second * by
end

function colorToInt(color)
  return (color.red << 16) + (color.green << 8) + (color.blue)
end

function lerpRGBInt(color1, color2, amount)
  local X1 = 1 - amount
  local X2 = color1 >> 24 & 255
  local X3 = color1 >> 16 & 255
  local X4 = color1 >> 8 & 255
  local X5 = color1 & 255
  local X6 = color2 >> 24 & 255
  local X7 = color2 >> 16 & 255
  local X8 = color2 >> 8 & 255
  local X9 = color2 & 255
  local X10 = X2 * X1 + X6 * amount
  local X11 = X3 * X1 + X7 * amount
  local X12 = X4 * X1 + X8 * amount
  local X13 = X5 * X1 + X9 * amount
  return X10 << 24 | X11 << 16 | X12 << 8 | X13
end

function colorShift(color, hueShift, satShift, lightShift, shadeShift)
  local newColor = Color(color) -- Make a copy of the color so we don't modify the parameter

  -- SHIFT HUE
  newColor.hslHue = (newColor.hslHue + hueShift * 360) % 360

  -- SHIFT SATURATION
  if (satShift > 0) then
    newColor.saturation = lerp(newColor.saturation, 1, satShift)
  elseif (satShift < 0) then
    newColor.saturation = lerp(newColor.saturation, 0, -satShift)
  end

  -- SHIFT LIGHTNESS
  if (lightShift > 0) then
    newColor.lightness = lerp(newColor.lightness, 1, lightShift)
  elseif (lightShift < 0) then
    newColor.lightness = lerp(newColor.lightness, 0, -lightShift)
  end

  -- SHIFT SHADING
  local newShade = Color {red = newColor.red, green = newColor.green, blue = newColor.blue}
  local shadeInt = 0
  if (shadeShift >= 0) then
    newShade.hue = 50
    shadeInt = lerpRGBInt(colorToInt(newColor), colorToInt(newShade), shadeShift)
  elseif (shadeShift < 0) then
    newShade.hue = 215
    shadeInt = lerpRGBInt(colorToInt(newColor), colorToInt(newShade), -shadeShift)
  end
  newColor.red = shadeInt >> 16
  newColor.green = shadeInt >> 8 & 255
  newColor.blue = shadeInt & 255

  return newColor
end











local color_base = app.fgColor;
local color_shadow = colorShift(color_base, 0, 0.2, -0.3, -0.4);
local color_shadow_deeper = colorShift(color_base, 0, 0.3, -0.6, -0.6);
local color_lighting = colorShift(color_base, 0, 0, 0.4, 0.3);

local newImages1 = Image(app.activeSprite.width, app.activeSprite.height)
local newImages2 = Image(app.activeSprite.width, app.activeSprite.height)
local newImages3 = Image(app.activeSprite.width, app.activeSprite.height)
local newImages4 = Image(app.activeSprite.width, app.activeSprite.height)
local newImages5 = Image(app.activeSprite.width, app.activeSprite.height)
local newImages6 = Image(app.activeSprite.width, app.activeSprite.height)


function redraw()
  color_base = app.fgColor;
  color_shadow = colorShift(color_base, 0, 0.2, -0.3, -0.4);
  color_shadow_deeper = colorShift(color_base, 0, 0.3, -0.6, -0.6);
  color_lighting = colorShift(color_base, 0, 0, 0.4, 0.3);
  
  for y=0, newImages1.height do
      for x=0, newImages1.width do
          newImages1:putPixel(x, y, color_base)
      end
  end


  for y=0, newImages2.height do
      for x=0, newImages2.width do
          if (x == 15) then
            newImages2:putPixel(x, y, color_shadow_deeper)
          end
          if (y == 15) then
            newImages2:putPixel(x, y, color_shadow_deeper)
          end
      end
  end

  newImages3 = Image(app.activeSprite.width, app.activeSprite.height)
  newImages4 = Image(app.activeSprite.width, app.activeSprite.height)
  newImages5 = Image(app.activeSprite.width, app.activeSprite.height)

  for y=0, newImages6.height do
      for x=0, newImages6.width do
          if (x == 0 and y == 0) then
            newImages6:putPixel(x, y, color_shadow)
          end
          if (x == 14 and y == 0) then
            newImages6:putPixel(x, y, color_shadow)
          end
          if (x == 0 and y == 14) then
            newImages6:putPixel(x, y, color_shadow)
          end
          if (x == 14 and y == 14) then
            newImages6:putPixel(x, y, color_shadow)
          end
      end
  end

end




function drawSquare(start_x, start_y, end_x, end_y)

  for y=0, newImages3.height do
      for x=0, newImages3.width do
          if (x == end_x and y >= start_y and y <= end_y) then
            newImages3:putPixel(x, y, color_lighting)
            newImages4:putPixel(x+1, y, color_shadow)
          end
          if (x >= start_x and x <= end_x and y == end_y) then
            newImages3:putPixel(x, y, color_lighting)
            newImages4:putPixel(x, y+1, color_shadow)
          end
      end
  end
  newImages5:putPixel(end_x+1, end_y+1, color_shadow_deeper)
  newImages5:putPixel(end_x, end_y+1, color_shadow_deeper)
  newImages5:putPixel(end_x+1, end_y, color_shadow_deeper)
  -- newImages5:putPixel(end_x+2, end_y+1, color_shadow_deeper)
  -- newImages5:putPixel(end_x+1, end_y+2, color_shadow_deeper)

end

-- for y = 0, 2 do
--   for x = 0, 2 do
--     local start_x = x * 8
--     local start_y = y * 8
--     local end_x = start_x + 6
--     local end_y = start_y + 6
--     drawSquare(start_x, start_y, end_x, end_y)
--   end
-- end

-- for y = 0, 3 do
--   for x = 0, 3 do
--     local start_x = x * 5
--     local start_y = y * 5
--     local end_x = start_x + 3
--     local end_y = start_y + 3
--     drawSquare(start_x, start_y, end_x, end_y)
--   end
-- end

function drawGround1x1()
  for y = 0, 1 do
    for x = 0, 1 do
      local start_x = x * 16
      local start_y = y * 16
      local end_x = start_x + 14
      local end_y = start_y + 14
      drawSquare(start_x, start_y, end_x, end_y)
    end
  end
end

function drawGround2x2()
  for y = 0, 2 do
    for x = 0, 2 do
      local start_x = x * 8
      local start_y = y * 8
      local end_x = start_x + 6
      local end_y = start_y + 6
      drawSquare(start_x, start_y, end_x, end_y)
    end
  end

end

function drawGround3x3()
  for y = 0, 3 do
    for x = 0, 3 do
      local start_x = x * 5
      local start_y = y * 5
      local end_x = start_x + 3
      local end_y = start_y + 3
      drawSquare(start_x, start_y, end_x, end_y)
    end
  end

end

function drawWall()
  for y = 0, 2 do
    for x = 0, 3 do
      local start_x = x * 5
      local start_y = y * 8
      local end_x = start_x + 3
      local end_y = start_y + 2
      drawSquare(start_x, start_y, end_x, end_y)
    end
  end

  for y = 0, 2 do
    for x = 0, 3 do
      local start_x = x * 5 - 3
      local start_y = y * 8 + 3
      local end_x = start_x + 3
      local end_y = start_y + 3
      drawSquare(start_x, start_y, end_x, end_y)
    end
  end
end


-- drawSquare(0, 8, 6, 14)
-- drawSquare(8, 0, 14, 6)
-- drawSquare(8, 8, 14, 14)
-- drawSquare(0, 0, 14, 14)



function commit()
  app.transaction(
    function()

      local spr = app.activeSprite
      local layer_names = ""

      for i,layer in ipairs(spr.layers) do
        if (i == 1) then
          spr:newCel(layer, app.activeFrame, newImages1, Point(0,0))
        end
        if (i == 2) then
          spr:newCel(layer, app.activeFrame, newImages3, Point(0,0))
        end
        if (i == 3) then
          spr:newCel(layer, app.activeFrame, newImages4, Point(0,0))
        end
        if (i == 4) then
          spr:newCel(layer, app.activeFrame, newImages5, Point(0,0))
        end
        if (i == 5) then
          spr:newCel(layer, app.activeFrame, newImages6, Point(0,0))
        end
        if (i == 6) then
          spr:newCel(layer, app.activeFrame, newImages2, Point(0,0))
        end
      end
    end
  )
end










function showColors(shadingColor, fg, bg, windowBounds)
  local dlg
  dlg =
    Dialog {
    title = "Van Grounds"
  }

  -- CACHING
  local FGcache = app.fgColor
  if(fg ~= nil) then
    FGcache = fg
  end

  local BGcache = app.bgColor
  if(bg ~= nil) then
    BGcache = bg
  end

  -- DIALOGUE
  dlg:button {
    -- GET BUTTON
    id = "ground1x1",
    text = "Ground 1x1",
    onclick = function()
      redraw()
      drawGround1x1()
      commit()
    end
  }
  dlg:button {
    -- GET BUTTON
    id = "ground2x2",
    text = "Ground 2x2",
    onclick = function()
      redraw()
      drawGround2x2()
      commit()
    end
  }
  dlg:button {
    -- GET BUTTON
    id = "ground3x3",
    text = "Ground 3x3",
    onclick = function()
      redraw()
      drawGround3x3()
      commit()
    end
  }
  dlg:button {
    -- GET BUTTON
    id = "wall",
    text = "Wall",
    onclick = function()
      redraw()
      drawWall()
      commit()
    end
  }
  dlg:button {
    -- GET BUTTON
    id = "close",
    text = "Close",
    onclick = function()
      dlg:close()
    end
  }


  dlg:show {wait = false, bounds = windowBounds}
end

-- Run the script
do
  showColors(app.fgColor)
end

