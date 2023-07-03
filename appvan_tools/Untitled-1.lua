

x1 = [0, 16]
x2 = [5, 16]
x3 = [13, 21]


mx1 = 7
mx2 = 10
mx3 = 17


mrx1 = (7 - 0) / (16 - 0) = 0.4375
mrx2 = (11 - 6) / (16 - 6) = 0.5
mrx3 = (17 - 13) / (21 - 13) = 0.5


y1 = [2, 8]
y2 = [5, 15]

my1 = 5
my2 = 10


mry1 = (5 - 2) / (8 - 2) = 0.5
mry2 = (15 - 10) / (15 - 5) = 0.5






var mx1 = 10
var x1 = [3, 17]
var x2 = [6, 17]

mrx1 = (10 - 3) / (17 - 3) = 0.5
mrx2 = 0.5

(mx2 - 6) / (17 - 6) = 0.5
mx2 = 0.5 * (17 - 6) + 6
mx2 = 11.5




var p_lt_1 = [3, 18]
var p_rt_1 = [17, 18]
var p_rb_1 = [17, 29]
var p_lb_1 = [3, 29]

var p_m_1 = [10, 24]

p_m_1_rx = (10 - 3) / (17 - 3) = 0.5
p_m_1_ry = (24 - 18) / (29 - 18) = 0.5454

// p_l_m_1 = [3, 24]
// p_l_m_1_rx = (3 - 3) / (3 - 3) = NaN
// p_l_m_1_ry = (24 - 18) / (29 - 18) = 0.5454

// p_r_m_1 = [17, 24]
// p_l_m_1_rx = (17 - 17) / (17 - 17) = NaN
// p_l_m_1_ry = (24 - 18) / (29 - 18) = 0.5454



var p_lt_2 = [9, 4]
var p_rt_2 = [17, 4]
var p_rb_2 = [17, 15]
var p_lb_2 = [3, 9]


p_l_m_2_rx = 0.5
p_l_m_2_ry = 0.5454

p_l_m_2_x = 0.5 * ( 3 - 9 ) + 9 = 6
p_l_m_2_y = 0.5454 * ( 9 - 4 ) + 4 = 6.727


p_r_m_2_rx = 0.5
p_r_m_2_ry = 0.5454

p_r_m_2_x = 0.5 * ( 17 - 17 ) + 17 = 17
p_r_m_2_y = 0.5454 * ( 15 - 4 ) + 4 = 9.9994


p_m_2_x = 0.5 * ( 17 - 6 ) + 6 = 11.5
p_m_2_y = 0.5454 * ( 9.9994 - 6.727 ) + 6.727 = 8.5117



p_m_2 = [11.5, 8.5117]

















var p_lt_1 = [3, 18]
var p_rt_1 = [17, 18]
var p_rb_1 = [17, 29]
var p_lb_1 = [3, 29]

var p_m_1 = [7, 21]

p_m_1_rx = (7 - 3) / (17 - 3) = 0.285
p_m_1_ry = (21 - 18) / (29 - 18) = 0.2727



var p_lt_2 = [3, 9]
var p_rt_2 = [17, 4]
var p_rb_2 = [17, 15]
var p_lb_2 = [9, 4]


p_l_m_2_rx = 0.285
p_l_m_2_ry = 0.2727

p_l_m_2_x = 0.285 * ( 9 - 3 ) + 3 = 4.71
p_l_m_2_y = 0.2727 * ( 4 - 9 ) + 9 = 7.6365


p_r_m_2_rx = 0.285
p_r_m_2_ry = 0.2727

p_r_m_2_x = 0.285 * ( 17 - 17 ) + 17 = 17
p_r_m_2_y = 0.2727 * ( 15 - 4 ) + 4 = 6.9997


p_m_2_x = 0.285 * ( 17 - 4.71 ) + 4.71 = 8.21265
p_m_2_y = 0.2727 * ( 6.9997 - 7.6365 ) + 7.6365 = 7.4628



p_m_2 = [8.21265, 7.4628]



local sprite = app.activeSprite
if not sprite then return end

local image = sprite.cels[1].image
local width, height = image.width, image.height


local controlPoints = {}
local spacingX = width / 3
local spacingY = height / 3
for row = 0, 3 do
  controlPoints[row] = {}
  for col = 0, 3 do
    controlPoints[row][col] = { x = col * spacingX, y = row * spacingY }
  end
end



for row = 0, 2 do
  for col = 0, 2 do

    var p_lt_1 = controlPoints[row][col]
    var p_rt_1 = controlPoints[row+1][col]
    var p_rb_1 = controlPoints[row+1][col+1]
    var p_lb_1 = controlPoints[row][col+1]


    for y = p_lt_1.y, p_rb_1.y - 1 do

      for x = p_lt_1.x, p_rb_1.x - 1 do

        pixel = [x, y]

        var p_m_1 = pixel

        var p_m_1_rx = (p_m_1.x - p_lt_1.x) / (p_rb_1.x - p_lt_1.x)
        var p_m_1_ry = (p_m_1.y - p_lt_1.y) / (p_rb_1.y - p_lt_1.y)


        var p_lt_2 = [ p_lt_1.x - p_lt_d.x ,  p_lt_1.y - p_lt_d.y ]
        var p_rt_2 = [ p_rt_1.x - p_rt_d.x ,  p_rt_1.y - p_rt_d.y ]
        var p_rb_2 = [ p_rb_1.x - p_rb_d.x ,  p_rb_1.y - p_rb_d.y ]
        var p_lb_2 = [ p_lb_1.x - p_lb_d.x ,  p_lb_1.y - p_lb_d.y ]

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

        p_m_2 = [ p_m_2_x, p_m_2_y ]


        newImage:putPixel(
          p_m_2.x, 
          p_m_2.y, 
          image:getPixel(
            p_m_1.x, 
            p_m_1_y
          )
        )

      end
    end
  end
end

