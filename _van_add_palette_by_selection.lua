
local spr = app.activeSprite
if not spr then return end

local sel = spr.selection
local im = Image(spr)

local new_palettes = {}



if not sel.isEmpty then
  local rect = sel.bounds

  for x = rect.x, rect.x + rect.width do
    for y = rect.y, rect.y + rect.height do
      if sel:contains(x, y) then

        local pixelValue = im:getPixel(x, y)

        local pixelColorString = string.format("%d-%d-%d-%d", app.pixelColor.rgbaR(pixelValue), app.pixelColor.rgbaG(pixelValue), app.pixelColor.rgbaB(pixelValue), app.pixelColor.rgbaA(pixelValue))
        if (new_palettes[pixelColorString] == nil) then
          if (app.pixelColor.rgbaA(pixelValue) > 0) then
            new_palettes[pixelColorString] = Color{ r=app.pixelColor.rgbaR(pixelValue),
                               g=app.pixelColor.rgbaG(pixelValue),
                               b=app.pixelColor.rgbaB(pixelValue) }
          end
        end

     end
    end
  end
end


local new_color_count = 0
local new_color_debug = ""
local new_palettes_sorted = {}

for n in pairs(new_palettes) do
  table.insert(new_palettes_sorted, new_palettes[n])
end

table.sort(new_palettes_sorted, function(a,b) 
  if a.hsvValue == 0 and b.hsvValue > 0 then
    return false
  end
  if a.hsvValue > 0 and b.hsvValue == 0 then
    return true
  end
  if a.hsvSaturation == b.hsvSaturation then
    return a.hsvValue > b.hsvValue
  end
  return a.hsvSaturation < b.hsvSaturation 
end)



for k, v in ipairs(new_palettes_sorted) do
  new_color_count = new_color_count + 1
  new_color_debug = new_color_debug .. "\n" .. "[" .. v.hsvSaturation .. "]"
end


local palette = spr.palettes[1]
local ncolors = #palette

palette:resize(ncolors + new_color_count)

app.transaction(
  function()
    for k, v in ipairs(new_palettes_sorted) do
      palette:setColor(ncolors + k - 1, v)
    end
  end
)


-- app.alert(new_color_debug)
return





-- local spr = app.activeSprite
-- if not spr then
--   return app.alert("There is no active sprite")
-- end

-- app.transaction(
--   function()
--     math.randomseed(os.time())
--     local pal = spr.palettes[1]
--     for i = 0,#pal-1 do
--       pal:setColor(i, Color{ r=math.random(256)-1,
--                              g=math.random(256)-1,
--                              b=math.random(256)-1 })
--     end
--   end)

-- app.refresh()





-- local img = Image(spr)
-- local sel = spr.selection

