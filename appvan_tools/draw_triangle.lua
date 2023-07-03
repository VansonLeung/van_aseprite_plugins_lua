-- Mat3 = {}
-- Mat3.__index = Mat3

-- setmetatable(Mat3, {
--     __call = function (cls, ...)
--         return cls.new(...)
--     end})

-- ---Constructs a row major 3x3 matrix from numbers.
-- ---Intended for use as a 2D affine transform.
-- ---@param m00 number row 0, col 0 right x
-- ---@param m01 number row 0, col 1 forward x
-- ---@param m02 number row 0, col 2 translation x
-- ---@param m10 number row 1, col 0 right y
-- ---@param m11 number row 1, col 1 forward y
-- ---@param m12 number row 1, col 2 translation y
-- ---@param m20 number row 2, col 0 right z
-- ---@param m21 number row 2, col 1 forward z
-- ---@param m22 number row 2, col 2 translation z
-- ---@return table
-- function Mat3.new(
--     m00, m01, m02,
--     m10, m11, m12,
--     m20, m21, m22)
--     local inst = {}
--     setmetatable(inst, Mat3)

--     inst.m00 = m00 or 1.0
--     inst.m01 = m01 or 0.0
--     inst.m02 = m02 or 0.0

--     inst.m10 = m10 or 0.0
--     inst.m11 = m11 or 1.0
--     inst.m12 = m12 or 0.0

--     inst.m20 = m20 or 0.0
--     inst.m21 = m21 or 0.0
--     inst.m22 = m22 or 1.0

--     return inst
-- end

-- function Mat3:__tostring()
--     return string.format(
--         [[{ m00: %.4f, m01: %.4f, m02: %.4f,
--   m10: %.4f, m11: %.4f, m12: %.4f,
--   m20: %.4f, m21: %.4f, m22: %.4f }]],
--         self.m00, self.m01, self.m02,
--         self.m10, self.m11, self.m12,
--         self.m20, self.m21, self.m22)
-- end






-- ---Constructs a matrix from an angle in radians.
-- ---@param radians number angle
-- ---@return table
-- function Mat3.fromRotZ(radians)
--     return Mat3.fromRotZInternal(
--         math.cos(radians),
--         math.sin(radians))
-- end

-- ---Constructs a matrix from the cosine and sine of an angle.
-- ---@param cosa number cosine of the angle
-- ---@param sina number sine of the angle
-- ---@return table
-- function Mat3.fromRotZInternal(cosa, sina)
--     return Mat3.new(
--         cosa, -sina, 0.0,
--         sina,  cosa, 0.0,
--          0.0,   0.0, 1.0)
-- end

-- ---Constructs a matrix from a nonuniform scale.
-- ---@param width number width
-- ---@param depth number depth
-- ---@return table
-- function Mat3.fromScale(width, depth)
--     local w = 1.0
--     if width and width ~= 0.0 then
--         w = width
--     end

--     local d = w
--     if depth and depth ~= 0.0 then
--         d = depth
--     end

--     return Mat3.new(
--           w, 0.0, 0.0,
--         0.0,   d, 0.0,
--         0.0, 0.0, 1.0)
-- end

-- ---Constructs a matrix from a translation.
-- ---@param x number x
-- ---@param y number y
-- ---@return table
-- function Mat3.fromTranslation(x, y)
--     return Mat3.new(
--         1.0, 0.0,   x,
--         0.0, 1.0,   y,
--         0.0, 0.0, 1.0)
-- end





-- ---Finds the product of two matrices.
-- ---@param a table left operand
-- ---@param b table right operand
-- ---@return table
-- function Mat3.mul(a, b)
--     return Mat3.new(
--         a.m00 * b.m00 + a.m01 * b.m10 + a.m02 * b.m20,
--         a.m00 * b.m01 + a.m01 * b.m11 + a.m02 * b.m21,
--         a.m00 * b.m02 + a.m01 * b.m12 + a.m02 * b.m22,
--         a.m10 * b.m00 + a.m11 * b.m10 + a.m12 * b.m20,
--         a.m10 * b.m01 + a.m11 * b.m11 + a.m12 * b.m21,
--         a.m10 * b.m02 + a.m11 * b.m12 + a.m12 * b.m22,
--         a.m20 * b.m00 + a.m21 * b.m10 + a.m22 * b.m20,
--         a.m20 * b.m01 + a.m21 * b.m11 + a.m22 * b.m21,
--         a.m20 * b.m02 + a.m21 * b.m12 + a.m22 * b.m22)
-- end








-- Vec2 = {}
-- Vec2.__index = Vec2

-- -- Allow Vec2(3, 4) without new.
-- setmetatable(Vec2, {
--     __call = function (cls, ...)
--         return cls.new(...)
--     end})

-- function Vec2.new(x, y)
--     local inst = {}
--     setmetatable(inst, Vec2)
--     inst.x = x or 0.0
--     inst.y = y or inst.x
--     return inst
-- end

-- -- Define metamethods (:__)
-- -- Define instance methods (:)
-- -- Define static methods (.)








-- function Vec2:__add(b)
--   return Vec2.add(self, b)
-- end

-- function Vec2:__mul(b)
--   return Vec2.mul(self, b)
-- end

-- ---Finds the sum of two vectors.
-- ---@param a table left operand
-- ---@param b table right operand
-- ---@return table
-- function Vec2.add(a, b)
--   return Vec2.new(a.x + b.x, a.y + b.y)
-- end

-- ---Multiplies two vectors component-wise.
-- ---A shortcut for multiplying a scale matrix
-- ---with a vector.
-- ---@param a table left operand
-- ---@param b table right operand
-- ---@return table
-- function Vec2.mul(a, b)
--   return Vec2.new(a.x * b.x, a.y * b.y)
-- end





-- function Vec2.round(a)
--   local iy, fy = math.modf(a.y)
--   if iy <= 0.0 and fy <= -0.5 then iy = iy - 1
--   elseif iy >= 0.0 and fy >= 0.5 then iy = iy + 1 end

--   local ix, fx = math.modf(a.x)
--   if ix <= 0.0 and fx <= -0.5 then ix = ix - 1
--   elseif ix >= 0.0 and fx >= 0.5 then ix = ix + 1 end

--   return Vec2.new(ix, iy)
-- end









-- function Vec2:__tostring()
--   return string.format(
--       "{ x: %.4f, y: %.4f }",
--       self.x, self.y)
-- end










-- Utilities = {}
-- Utilities.__index = Utilities

-- setmetatable(Utilities, {
--     __call = function (cls, ...)
--         return cls.new(...)
--     end})

-- ---Houses utility methods not included in Lua math.
-- ---@return table
-- function Utilities.new()
--     local inst = {}
--     setmetatable(inst, Utilities)
--     return inst
-- end

-- ---Multiplies a matrix with a vector.
-- ---The vector is treated as a point.
-- ---@param a table matrix
-- ---@param b table vector
-- ---@return table
-- function Utilities.mulMat3Vec2(a, b)
--     local w = a.m20 * b.x + a.m21 * b.y + a.m22
--     if w ~= 0.0 then
--         local wInv = 1.0 / w
--         return Vec2.new(
--             (a.m00 * b.x + a.m01 * b.y + a.m02) * wInv,
--             (a.m10 * b.x + a.m11 * b.y + a.m12) * wInv)
--     else
--         return Vec2.new(0.0, 0.0)
--     end
-- end








-- Mesh2 = {}
-- Mesh2.__index = Mesh2

-- setmetatable(Mesh2, {
--     __call = function (cls, ...)
--         return cls.new(...)
--     end})

-- ---Constructs a 2D mesh with a variable
-- ---number of vertices per face.
-- ---@param fs table faces
-- ---@param vs table coordinates
-- ---@param name string name
-- ---@return table
-- function Mesh2.new(fs, vs, name)
--     local inst = {}
--     setmetatable(inst, Mesh2)
--     inst.fs = fs or {}
--     inst.vs = vs or {}
--     inst.name = name or "Mesh2"
--     return inst
-- end

-- function Mesh2:__len()
--     return #self.fs
-- end

-- function Mesh2:__tostring()
--     local str = "{ name: \""
--     str = str .. self.name
--     str = str .. "\", fs: [ "

--     local fsLen = #self.fs
--     for i = 1, fsLen, 1 do
--         local f = self.fs[i]
--         local fLen = #f
--         str = str .. "[ "
--         for j = 1, fLen, 1 do
--             str = str .. f[j]
--             if j < fLen then str = str .. ", " end
--         end
--         str = str .. " ]"
--         if i < fsLen then str = str .. ", " end
--     end

--     str = str .. " ], vs: [ "

--     local vsLen = #self.vs
--     for i = 1, vsLen, 1 do
--         str = str .. tostring(self.vs[i])
--         if i < vsLen then str = str .. ", " end
--     end
--     str = str .. " ] }"

--     return str
-- end







-- function Mesh2:transform(matrix)
--   local vsLen = #self.vs
--   for i = 1, vsLen, 1 do
--       self.vs[i] = Utilities.mulMat3Vec2(
--           matrix, self.vs[i])
--   end
--   return self
-- end






-- function Mesh2.polygon(sectors)
--   local vsect = 3
--   if sectors > 3 then vsect = sectors end
--   local radius = 0.5
--   local toTheta = 6.283185307179586 / vsect
--   local vs = {}
--   local f = {}
--   for i = 0, vsect - 1, 1 do
--       local theta = i * toTheta
--       table.insert(vs, Vec2.new(
--           radius * math.cos(theta),
--           radius * math.sin(theta)))
--       table.insert(f, 1 + i)
--   end
--   return Mesh2.new({ f }, vs, "Polygon")
-- end















-- AseUtilities = {}
-- AseUtilities.__index = AseUtilities

-- setmetatable(AseUtilities, {
--     __call = function (cls, ...)
--         return cls.new(...)
--     end})

-- ---Houses utility methods for scripting
-- ---Aseprite add-ons.
-- ---@return table
-- function AseUtilities.new()
--     local inst = {}
--     setmetatable(inst, AseUtilities)
--     return inst
-- end

-- ---Draws a mesh in Aseprite with the contour tool.
-- ---@param mesh table
-- ---@param useFill boolean
-- ---@param fillClr table
-- ---@param useStroke boolean
-- ---@param strokeClr table
-- ---@param brsh table
-- ---@param cel table
-- ---@param layer table
-- function AseUtilities.drawMesh(
--     mesh, useFill, fillClr,
--     useStroke, strokeClr,
--     brsh, cel, layer)

--     -- Convert Vec2s to Points.
--     -- Round Vec2 for improved accuracy.
--     local vs = mesh.vs
--     local vsLen = #vs
--     local pts = {}
--     for i = 1, vsLen, 1 do
--         -- local v = vs[i]
--         local v = Vec2.round(vs[i])
--         table.insert(pts, Point(v.x, v.y))
--     end

--     -- Group points by face.
--     local fs = mesh.fs
--     local fsLen = #fs
--     local ptsGrouped = {}
--     for i = 1, fsLen, 1 do
--         local f = fs[i]
--         local fLen = #f
--         local ptsFace = {}
--         for j = 1, fLen, 1 do
--             table.insert(ptsFace, pts[f[j]])
--         end
--         table.insert(ptsGrouped, ptsFace)
--     end

--     -- Group fills into one transaction.
--     if useFill then
--         app.transaction(function()
--             for i = 1, fsLen, 1 do
--                 app.useTool {
--                     tool = "contour",
--                     color = fillClr,
--                     brush = brsh,
--                     points = ptsGrouped[i],
--                     cel = cel,
--                     layer = layer }
--             end
--         end)
--     end

--     -- Group strokes into one transaction.
--     -- Draw strokes line by line.
--     if useStroke then
--         app.transaction(function()
--             for i = 1, fsLen, 1 do
--                 local ptGroup = ptsGrouped[i]
--                 local ptgLen = #ptGroup
--                 local ptPrev = ptGroup[ptgLen]
--                 for j = 1, ptgLen, 1 do
--                     local ptCurr = ptGroup[j]
--                     app.useTool {
--                         tool = "line",
--                         color = strokeClr,
--                         brush = brsh,
--                         points = { ptPrev, ptCurr },
--                         cel = cel,
--                         layer = layer }
--                     ptPrev = ptCurr
--                 end
--             end
--         end)
--     end

--     app.refresh()
-- end













-- local defaults = {
--   sides = 6,
--   angle = 90,
--   scale = 32,
--   xOrigin = 0,
--   yOrigin = 0,
--   useFill = true,
--   useStroke = true,
--   strokeWeight = 1,
--   strokeClr = Color(32, 32, 32, 255),
--   fillClr = Color(255, 245, 215, 255)
-- }

-- local dlg = Dialog { title = "Convex Polygon" }

-- dlg:slider {
--   id = "sides",
--   label = "Sides: ",
--   min = 3,
--   max = 16,
--   value = defaults.sides
-- }

-- dlg:slider {
--   id = "angle",
--   label = "Angle:",
--   min = -180,
--   max = 180,
--   value = defaults.angle
-- }

-- dlg:number {
--   id = "scale",
--   label = "Scale: ",
--   text = string.format("%.1f", defaults.scale),
--   decimals = 5
-- }

-- dlg:number {
--   id = "xOrigin",
--   label = "Origin X: ",
--   text = string.format("%.1f", defaults.xOrigin),
--   decimals = 5
-- }

-- dlg:number {
--   id = "yOrigin",
--   label = "Origin Y: ",
--   text = string.format("%.1f", defaults.yOrigin),
--   decimals = 5
-- }

-- dlg:check {
--   id = "useStroke",
--   label = "Use Stroke: ",
--   selected = defaults.useStroke
-- }

-- dlg:slider {
--   id = "strokeWeight",
--   label = "Stroke Weight:",
--   min = 1,
--   max = 64,
--   value = defaults.strokeWeight
-- }

-- dlg:color {
--   id = "strokeClr",
--   label = "Stroke Color: ",
--   color = defaults.strokeClr
-- }

-- dlg:check {
--   id = "useFill",
--   label = "Use Fill: ",
--   selected = defaults.useFill
-- }

-- dlg:color {
--   id = "fillClr",
--   label = "Fill Color: ",
--   color = defaults.fillClr
-- }

-- dlg:button {
--   id = "ok",
--   text = "OK",
--   focus = true,
--   onclick = function()

--   local args = dlg.data
--   local mesh = Mesh2.polygon(args.sides)

--   -- Translate, rotate then scale the mesh.
--   local t = Mat3.fromTranslation(
--       args.xOrigin,
--       args.yOrigin)
--   local r = Mat3.fromRotZ(math.rad(args.angle))
--   local sclval = args.scale
--   if sclval < 2.0 then sclval = 2.0 end
--   local s = Mat3.fromScale(sclval, sclval)
--   local mat = Mat3.mul(Mat3.mul(t, r), s)
--   mesh:transform(mat)

--   local sprite = app.activeSprite
--   if sprite == nil then
--       sprite = Sprite(64, 64)
--       app.activeSprite = sprite
--   end

--   local layer = sprite:newLayer()
--   layer.name = mesh.name

--   AseUtilities.drawMesh(
--       mesh,
--       args.useFill,
--       args.fillClr,
--       args.useStroke,
--       args.strokeClr,
--       Brush(args.strokeWeight),
--       sprite:newCel(layer, 1),
--       layer)
--   end
-- }

-- dlg:button {
--   id = "cancel",
--   text = "CANCEL",
--   onclick = function()
--       dlg:close()
--   end
-- }

-- dlg:show { wait = false }






local sprite = app.activeSprite
if sprite == nil then
    sprite = Sprite(64, 64)
    app.activeSprite = sprite
end


local layer = sprite:newLayer()
layer.name = "Triangle"


local pts = {
  Point(50,50),
  Point(150, 100),
  Point(30,75),
  Point(20,45),
}



app.transaction(function()
  app.useTool {
    tool = "contour",
    color = Color(32, 32, 32, 255),
    brush = Brush(1),
    points = pts,
    -- cel = sprite:newCel(layer, 1),
    layer = layer }
end)

app.refresh()
