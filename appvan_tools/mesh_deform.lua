
function drawAnyPolygon(pts, layer, cel, color)
  app.useTool {
    tool = "contour",
    color = color,
    brush = Brush(1),
    points = pts,
    cel = cel,
    layer = layer }


end

function isPointInsidePolygon(point, polygon_pt1, polygon_pt2, polygon_pt3, polygon_pt4)
  local vertices = { polygon_pt1, polygon_pt2, polygon_pt3, polygon_pt4 }
  local inside = false

  local x = point.x
  local y = point.y

  for i = 1, #vertices do
    local j = i % #vertices + 1

    if ((vertices[i].y > y) ~= (vertices[j].y > y)) and (x < (vertices[j].x - vertices[i].x) * (y - vertices[i].y) / (vertices[j].y - vertices[i].y) + vertices[i].x) then
      inside = not inside
    end
  end

  return inside
end




local sprite = app.activeSprite
if not sprite then return end

-- local image = sprite.cels[1].image
local image = sprite.cels[1].image
local width, height = image.width, image.height



-- Apply the deformation to the image
local newImage = Image(sprite.width, sprite.height, ColorMode.RGB)



function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end








-- local errDlg = Dialog("Error")
-- errDlg:label {label = "X"}
-- errDlg:label {label = spacingX}
-- errDlg:label {label = "Y"}
-- errDlg:label {label = spacingY}
-- errDlg:label {label = sprite.cels[1].position.x}
-- errDlg:label {label = sprite.cels[1].position.y}

function deform(controlPoints, controlPoints_delta)
  local oldNewPixelMapping = {}


  for row = 0, 2 do
    for col = 0, 2 do


      local p_lt_1 = controlPoints[row][col]
      local p_rt_1 = controlPoints[row+1][col]
      local p_rb_1 = controlPoints[row+1][col+1]
      local p_lb_1 = controlPoints[row][col+1]

      local p_lt_d = controlPoints_delta[row][col]
      local p_rt_d = controlPoints_delta[row+1][col]
      local p_rb_d = controlPoints_delta[row+1][col+1]
      local p_lb_d = controlPoints_delta[row][col+1]



      for y = p_lt_1.y, p_rb_1.y  do

        if oldNewPixelMapping[y] == nil then
          oldNewPixelMapping[y] = {}
        end
    
        for x = p_lt_1.x, p_rb_1.x  do

          pixel = { x = x, y = y }

          local p_m_1 = pixel

          local p_m_1_rx = (p_m_1.x - p_lt_1.x) / (p_rb_1.x - p_lt_1.x)
          local p_m_1_ry = (p_m_1.y - p_lt_1.y) / (p_rb_1.y - p_lt_1.y)


          local p_lt_2 = { x = p_lt_1.x + p_lt_d.x, y = p_lt_1.y + p_lt_d.y }
          local p_rt_2 = { x = p_rt_1.x + p_rt_d.x, y = p_rt_1.y + p_rt_d.y }
          local p_rb_2 = { x = p_rb_1.x + p_rb_d.x, y = p_rb_1.y + p_rb_d.y }
          local p_lb_2 = { x = p_lb_1.x + p_lb_d.x, y = p_lb_1.y + p_lb_d.y }

          p_l_m_2_rx = p_m_1_rx
          p_l_m_2_ry = p_m_1_ry

          p_l_m_2_x = p_l_m_2_rx * ( p_lb_2.x - p_lt_2.x ) + p_lt_2.x
          p_l_m_2_y = p_l_m_2_ry * ( p_lb_2.y - p_lt_2.y ) + p_lt_2.y

          p_r_m_2_rx = p_m_1_rx
          p_r_m_2_ry = p_m_1_ry

          p_r_m_2_x = p_r_m_2_rx * ( p_rb_2.x - p_rt_2.x ) + p_rt_2.x
          p_r_m_2_y = p_r_m_2_ry * ( p_rb_2.y - p_rt_2.y ) + p_rt_2.y


          p_m_2_x = p_m_1_rx * ( p_r_m_2_x - p_l_m_2_x ) + p_l_m_2_x
          p_m_2_y = p_m_1_ry * ( p_r_m_2_y - p_l_m_2_y ) + p_l_m_2_y

          p_m_2 = { x = p_m_2_x, y = p_m_2_y }


          local original_pixel_position = p_m_1
          local new_pixel_position = p_m_2


          oldNewPixelMapping[y][x] = {
            original_pixel_position = original_pixel_position, 
            new_pixel_position = new_pixel_position 
          }


        end
      end



    end
  end




  for row = 0, 2 do
    for col = 0, 2 do

      local p_lt_1 = controlPoints[row][col]
      local p_rt_1 = controlPoints[row+1][col]
      local p_rb_1 = controlPoints[row+1][col+1]
      local p_lb_1 = controlPoints[row][col+1]

      for y = p_lt_1.y, p_rb_1.y  do  
        for x = p_lt_1.x, p_rb_1.x  do

          local ox = x
          local oy = y


          -- errDlg:label {label = oy}
          -- errDlg:label {label = ox}
          -- errDlg:label {label = dump(oldNewPixelMapping[0][0])}
          -- errDlg:label {label = dump(controlPoints[0][0])}
          -- errDlg:show {wait = false}

          local original_pixel_position = oldNewPixelMapping[oy][ox].original_pixel_position
          local new_pixel_position_lt = oldNewPixelMapping[oy][ox].new_pixel_position
          local new_pixel_position_rt = oldNewPixelMapping[oy][ox].new_pixel_position
          local new_pixel_position_rb = oldNewPixelMapping[oy][ox].new_pixel_position
          local new_pixel_position_lb = oldNewPixelMapping[oy][ox].new_pixel_position
          
          if oldNewPixelMapping[oy+1] ~= nil then
            new_pixel_position_lb = oldNewPixelMapping[oy+1][ox].new_pixel_position  
            new_pixel_position_rb = oldNewPixelMapping[oy+1][ox].new_pixel_position
            if oldNewPixelMapping[oy+1][ox+1] ~= nil then
              new_pixel_position_rt = oldNewPixelMapping[oy][ox+1].new_pixel_position
              new_pixel_position_rb = oldNewPixelMapping[oy+1][ox+1].new_pixel_position
            end
          end


          local original_pixel = image:getPixel(
            original_pixel_position.x, 
            original_pixel_position.y
          )

          local new_pixel_position_center = {
            x = (new_pixel_position_lt.x + new_pixel_position_rt.x + new_pixel_position_rb.x + new_pixel_position_lb.x) / 4,
            y = (new_pixel_position_lt.y + new_pixel_position_rt.y + new_pixel_position_rb.y + new_pixel_position_lb.y) / 4,
          }


          for ny = new_pixel_position_lt.y, new_pixel_position_rb.y  do  
            for nx = new_pixel_position_lt.x, new_pixel_position_rb.x  do

              if isPointInsidePolygon({x = nx, y = ny}, new_pixel_position_lt, new_pixel_position_rt, new_pixel_position_rb, new_pixel_position_lb) then


                local new_pixel = newImage:getPixel(
                  nx + sprite.cels[1].position.x,
                  ny + sprite.cels[1].position.y
                )
    
    
                if (app.pixelColor.rgbaA(original_pixel) > 0) then
    
                  newImage:putPixel(
                    nx + sprite.cels[1].position.x, 
                    ny + sprite.cels[1].position.y, 
                    original_pixel
                  )
    
                end
                
          

              end

              

            end
          end
          
          newImage:putPixel(
            new_pixel_position_lt.x + sprite.cels[1].position.x, 
            new_pixel_position_lt.y + sprite.cels[1].position.y, 
            original_pixel
          )
          newImage:putPixel(
            new_pixel_position_rt.x + sprite.cels[1].position.x, 
            new_pixel_position_rt.y + sprite.cels[1].position.y, 
            original_pixel
          )
          newImage:putPixel(
            new_pixel_position_rb.x + sprite.cels[1].position.x, 
            new_pixel_position_rb.y + sprite.cels[1].position.y, 
            original_pixel
          )
          newImage:putPixel(
            new_pixel_position_lb.x + sprite.cels[1].position.x, 
            new_pixel_position_lb.y + sprite.cels[1].position.y, 
            original_pixel
          )
        

        end
      end
    end
  end





  -- -- Update the sprite with the transformed image
  local newLayer = sprite:newLayer()
  local newCel = sprite:newCel(newLayer, sprite.frames[1], newImage, Point(0, 0))

  -- app.transaction(function()
  -- end)
  -- app.refresh()


  -- app.transaction(function()


  --   for row = 0, 2 do
  --     for col = 0, 2 do

  --       local p_lt_1 = controlPoints[row][col]
  --       local p_rt_1 = controlPoints[row+1][col]
  --       local p_rb_1 = controlPoints[row+1][col+1]
  --       local p_lb_1 = controlPoints[row][col+1]

  --       for y = p_lt_1.y, p_rb_1.y  do  
  --         for x = p_lt_1.x, p_rb_1.x  do

  --           local ox = x
  --           local oy = y

  --           local original_pixel_position = oldNewPixelMapping[oy][ox].original_pixel_position
  --           local new_pixel_position_lt = oldNewPixelMapping[oy][ox].new_pixel_position
  --           local new_pixel_position_rt = oldNewPixelMapping[oy][ox].new_pixel_position
  --           local new_pixel_position_rb = oldNewPixelMapping[oy][ox].new_pixel_position
  --           local new_pixel_position_lb = oldNewPixelMapping[oy][ox].new_pixel_position
            
  --           if oldNewPixelMapping[oy+1] ~= nil then
  --             if oldNewPixelMapping[oy+1][ox+1] ~= nil then
  --               new_pixel_position_rt = oldNewPixelMapping[oy][ox+1].new_pixel_position
  --               new_pixel_position_rb = oldNewPixelMapping[oy+1][ox+1].new_pixel_position
  --             end
  --             new_pixel_position_lb = oldNewPixelMapping[oy+1][ox].new_pixel_position  
  --           end

  --           local original_pixel = image:getPixel(
  --             original_pixel_position.x, 
  --             original_pixel_position.y
  --           )

    

  --           local new_pixel_position_center = {
  --             x = (new_pixel_position_lt.x + new_pixel_position_rt.x + new_pixel_position_rb.x + new_pixel_position_lb.x) / 4,
  --             y = (new_pixel_position_lt.y + new_pixel_position_rt.y + new_pixel_position_rb.y + new_pixel_position_lb.y) / 4,
  --           }

  --           local new_pixel_position_lc = {
  --             x = (new_pixel_position_lt.x + new_pixel_position_lb.x) / 2,
  --             y = (new_pixel_position_lt.y + new_pixel_position_lb.y) / 2,
  --           }

  --           local new_pixel_position_tc = {
  --             x = (new_pixel_position_lt.x + new_pixel_position_rt.x) / 2,
  --             y = (new_pixel_position_lt.y + new_pixel_position_rt.y) / 2,
  --           }

  --           local new_pixel_position_rc = {
  --             x = (new_pixel_position_rt.x + new_pixel_position_rb.x) / 2,
  --             y = (new_pixel_position_rt.y + new_pixel_position_rb.y) / 2,
  --           }

  --           local new_pixel_position_bc = {
  --             x = (new_pixel_position_lb.x + new_pixel_position_rb.x) / 2,
  --             y = (new_pixel_position_lb.y + new_pixel_position_rb.y) / 2,
  --           }

  --           -- if errDlg ~= nil then

  --           --   errDlg:label {label = new_pixel_position_center.x}
  --           --   errDlg:label {label = new_pixel_position_center.y}
  --           --   errDlg:label {label = new_pixel_position_lc.x}
  --           --   errDlg:label {label = new_pixel_position_lc.y}
  --           --   errDlg:label {label = new_pixel_position_tc.x}
  --           --   errDlg:label {label = new_pixel_position_tc.y}
  --           --   errDlg:label {label = new_pixel_position_rc.x}
  --           --   errDlg:label {label = new_pixel_position_rc.y}
  --           --   errDlg:label {label = new_pixel_position_bc.x}
  --           --   errDlg:label {label = new_pixel_position_bc.y}
  --           --   errDlg:show {wait = false}
  --           --   errDlg = nil
  --           -- end
      
            
  --           -- drawAnyPolygon({
  --           --   Point(new_pixel_position_center.x + sprite.cels[1].position.x, new_pixel_position_center.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_lc.x + sprite.cels[1].position.x, new_pixel_position_lc.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_lt.x + sprite.cels[1].position.x, new_pixel_position_lt.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_tc.x + sprite.cels[1].position.x, new_pixel_position_tc.y + sprite.cels[1].position.y),
  --           -- }, newLayer, newCel, Color(32, 32, 32, 255))

  --           -- drawAnyPolygon({
  --           --   Point(new_pixel_position_center.x + sprite.cels[1].position.x, new_pixel_position_center.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_tc.x + sprite.cels[1].position.x, new_pixel_position_tc.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_rt.x + sprite.cels[1].position.x, new_pixel_position_rt.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_rc.x + sprite.cels[1].position.x, new_pixel_position_rc.y + sprite.cels[1].position.y),
  --           -- }, newLayer, newCel, Color(255, 32, 32, 255))

  --           -- drawAnyPolygon({
  --           --   Point(new_pixel_position_center.x + sprite.cels[1].position.x, new_pixel_position_center.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_rc.x + sprite.cels[1].position.x, new_pixel_position_rc.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_rb.x + sprite.cels[1].position.x, new_pixel_position_rb.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_bc.x + sprite.cels[1].position.x, new_pixel_position_bc.y + sprite.cels[1].position.y),
  --           -- }, newLayer, newCel, Color(32, 255, 32, 255))

  --           -- drawAnyPolygon({
  --           --   Point(new_pixel_position_center.x + sprite.cels[1].position.x, new_pixel_position_center.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_bc.x + sprite.cels[1].position.x, new_pixel_position_bc.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_lb.x + sprite.cels[1].position.x, new_pixel_position_lb.y + sprite.cels[1].position.y),
  --           --   Point(new_pixel_position_lc.x + sprite.cels[1].position.x, new_pixel_position_lc.y + sprite.cels[1].position.y),
  --           -- }, newLayer, newCel, Color(32, 32, 255, 255))

  --           -- for ny = new_pixel_position_lt.y, new_pixel_position_rb.y  do  
  --           --   for nx = new_pixel_position_lt.x, new_pixel_position_rb.x  do
                
  --           --     local new_pixel = newImage:getPixel(
  --           --       nx + sprite.cels[1].position.x,
  --           --       ny + sprite.cels[1].position.y
  --           --     )


  --           --     if (app.pixelColor.rgbaA(original_pixel) > 0) then

  --           --       newImage:putPixel(
  --           --         nx + sprite.cels[1].position.x, 
  --           --         ny + sprite.cels[1].position.y, 
  --           --         original_pixel
  --           --       )

  --           --       newImage:putPixel(
  --           --         math.floor(nx + 0.5) + sprite.cels[1].position.x, 
  --           --         math.floor(ny + 0.5) + sprite.cels[1].position.y, 
  --           --         original_pixel
  --           --       )
                
  --           --     end
                
          
  --           --   end
  --           -- end


  --         end
  --       end
  --     end
  --   end

  -- end)



  app.refresh()



  -- local function deformImage()
  --   local sprite = app.activeSprite
  --   if not sprite then return end

  --   local image = sprite.cels[1].image
  --   local width, height = image.width, image.height

  --   -- Create a 4x4 control point grid
  --   local controlPoints = {}
  --   local spacingX = width / 3
  --   local spacingY = height / 3
  --   for row = 0, 3 do
  --     controlPoints[row] = {}
  --     for col = 0, 3 do
  --       controlPoints[row][col] = { x = col * spacingX, y = row * spacingY }
  --     end
  --   end

  --   -- Implement the deformation logic
  --   local function deformPixel(x, y)
  --     local sourceX, sourceY = x, y
  --     -- Calculate the destination position based on control point displacements
  --     local destinationX, destinationY = x, y
  --     -- Perform interpolation and apply deformation algorithm
  --     -- Example: Bilinear interpolation
  --     local controlX, controlY = math.floor(x / spacingX), math.floor(y / spacingY)
  --     local u, v = (x % spacingX) / spacingX, (y % spacingY) / spacingY
  --     -- local u, v = 0, 0

  --     local p00 = controlPoints[controlY][controlX]
  --     local p10 = controlPoints[controlY][controlX + 1]
  --     local p01 = controlPoints[controlY + 1][controlX]
  --     local p11 = controlPoints[controlY + 1][controlX + 1]

  --     destinationX = (1 - u) * (1 - v) * p00.x + u * (1 - v) * p10.x + (1 - u) * v * p01.x + u * v * p11.x
  --     destinationY = (1 - u) * (1 - v) * p00.y + u * (1 - v) * p10.y + (1 - u) * v * p01.y + u * v * p11.y

  --     return image:getPixel(destinationX, destinationY)
  --   end

  --   -- Apply the deformation to the image
  --   local newImage = Image(width, height, ColorMode.RGB)
  --   for y = 0, height - 1 do
  --     for x = 0, width - 1 do
  --       newImage:putPixel(x, y, deformPixel(x, y))
  --     end
  --   end

  --   -- Update the sprite with the transformed image
  --   sprite:newCel(sprite:newLayer(), sprite.frames[1], newImage, Point(0, 0))
  --   app.refresh()
  -- end

  -- deformImage()

  -- -- Register the plugin
  -- -- local plugin = Plugin {
  -- --   name = "Deform Image",
  -- --   author = "Your Name",
  -- --   version = "1.0",
  -- --   description = "Deforms the image using a mesh",
  -- --   start = deformImage
  -- -- }

  -- -- Add the plugin to Aseprite's Scripts menu
  -- local sprMenu = app.menus["Sprite"]
  -- local scriptMenu = sprMenu[#sprMenu]
  -- scriptMenu:addItem(plugin)
end



-- Create a dialog with a specified title
local dlg = Dialog("Input Points")

-- Create arrays to store the input fields
local inputFieldsX = {}
local inputFieldsY = {}

-- Function to handle the Apply button click
local function applyButtonClicked()
  local points = {}

  -- Retrieve the values from the input fields and store them in the points array
  for i = 1, 4 do
    points[i] = {}
    for j = 1, 4 do
  --   end
  -- end
      local x = tonumber(dlg.data["x" .. i .. j])
      local y = tonumber(dlg.data["y" .. i .. j])
      points[i][j] = {x = x, y = y}
    end
  end

  -- Do something with the points array (e.g., draw the points on the canvas)
  -- Replace the code below with your desired action


  dlg:close()

  local controlPoints = {}
  local controlPoints_delta = {}
  
  local spacingX = width / 3
  local spacingY = height / 3
  for row = 0, 3 do
    controlPoints[row] = {}
    controlPoints_delta[row] = {}
    for col = 0, 3 do
      controlPoints[row][col] = { x = col * spacingX, y = row * spacingY }
      controlPoints_delta[row][col] = { x = points[row+1][col+1].x, y = points[row+1][col+1].y }
    end
  end

  deform(controlPoints, controlPoints_delta)

  -- Close the dialog
end

-- Create the input fields and arrange them in a 4x4 grid
for i = 1, 4 do
  local label = string.format("Row %d:", (i - 1))
  for j = 1, 4 do
    if j == 1 then
      local xField = dlg:number{ id = "x" .. i .. j, label = label, text="0", decimals=1 }
      table.insert(inputFieldsX, xField)
    else
      local xField = dlg:number{ id = "x" .. i .. j, text="0", decimals=1 }
      table.insert(inputFieldsX, xField)
    end
    local yField = dlg:number{ id = "y" .. i .. j, text="0", decimals=1 }
    table.insert(inputFieldsY, yField)
  end
  dlg:newrow { always = false }
end

-- Add the Apply button and associate it with the applyButtonClicked function
dlg:button{ id = "applyButton", text = "Apply", onclick = applyButtonClicked }

-- Show the dialog
dlg:show{ wait = false }



