-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


defineTile('.', 'GRASS')
defineTile(':', 'FLOOR')
defineTile('#', 'TREE')
defineTile('%', 'WALL')
defineTile('&', 'HARDWALL')
defineTile('+', 'DOOR')
defineTile('<', 'GRASS_UP_WILDERNESS')
defineTile('L', 'FLOOR', nil, 'GRAYSWANDIR_TROLL_LORD')
defineTile('X', 'FLOOR', nil, nil, nil, nil, {
		type = 'special', subtype = 'actor', actor = 'ASSASSIN_LORD',})
defineTile('@', 'FLOOR', nil, nil, nil, nil, {
		type = 'special', subtype = 'actor', actor = 'MERCHANT'})

local room = function(self, xmin, xmax, ymin, ymax)
	local grass_chance = rng.percent(40) and rng.range(0, 25) or 0
	for x = xmin, xmax do
		for y = ymin, ymax do
			self.map(x, y, Map.TERRAIN, self:resolve(rng.percent(grass_chance) and 'grass_floor' or 'floor'))
			end end end

local wall = function(self, xmin, xmax, ymin, ymax)
	for x = xmin, xmax do
		for y = ymin, ymax do
			local grid = 'wall'
			if not self:isEdgeWall(x, y) and rng.percent(8) then
				grid = rng.percent(6) and 'grass_wall' or 'floor_wall'
			elseif rng.percent(2) then
				grid = 'tree_wall' end
			self.map(x, y, Map.TERRAIN, self:resolve(grid))
			end end end

subGenerator {
	x = 10, y = 19, w = 39, h = 22,
	generator = 'data-grayswandir-thievery.class.DenseRooms',
	overlay = true,
	data = {
		draw_room = room, draw_hallway = room, draw_wall = wall,
		floor = 'FLOOR', floor_wall = 'FLOOR_XWALL', grass_floor = 'GRASS_XFLOOR',
		wall = 'WALL', tree_wall = 'TREE_XWALL', grass_wall = 'GRASS_XWALL',
		door = 'DOOR',
		edges = {[2] = 'door', [8] = 'door', [6] = 'wall',},},}

subGenerator {
	x = 10, y = 1, w = 39, h = 18,
	generator = 'data-grayswandir-thievery.class.DenseRooms',
	overlay = true,
	data = {
		draw_room = room, draw_hallway = room, draw_wall = wall,
		floor = 'FLOOR', floor_wall = 'FLOOR_XWALL', grass_floor = 'GRASS_XFLOOR',
		wall = 'WALL', tree_wall = 'TREE_XWALL', grass_wall = 'GRASS_XWALL',
		door = 'DOOR',
		edges = {[6] = 'door',},},}

subGenerator {
	x = 10, y = 41, w = 39, h = 18,
	generator = 'data-grayswandir-thievery.class.DenseRooms',
	overlay = true,
	data = {
		draw_room = room, draw_hallway = room, draw_wall = wall,
		floor = 'FLOOR', floor_wall = 'FLOOR_XWALL', grass_floor = 'GRASS_XFLOOR',
		wall = 'WALL', tree_wall = 'TREE_XWALL', grass_wall = 'GRASS_XWALL',
		door = 'DOOR',
		edges = {[6] = 'door',},},}

subGenerator {
	x = 49, y = 1, w = 10, h = 23,
	generator = 'data-grayswandir-thievery.class.DenseRooms',
	overlay = true,
	data = {
		draw_room = room, draw_hallway = room, draw_wall = wall,
		floor = 'FLOOR', floor_wall = 'FLOOR_XWALL', grass_floor = 'GRASS_XFLOOR',
		wall = 'WALL', tree_wall = 'TREE_XWALL', grass_wall = 'GRASS_XWALL',
		door = 'DOOR',},}

subGenerator {
	x = 49, y = 36, w = 10, h = 23,
	generator = 'data-grayswandir-thievery.class.DenseRooms',
	overlay = true,
	data = {
		draw_room = room, draw_hallway = room, draw_wall = wall,
		floor = 'FLOOR', floor_wall = 'FLOOR_XWALL', grass_floor = 'GRASS_XFLOOR',
		wall = 'WALL', tree_wall = 'TREE_XWALL', grass_wall = 'GRASS_XWALL',
		door = 'DOOR',},}

startx = 0
starty = 29
endx = 55
endy = 29

return {
	[[#########&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&]],
	[[####...##%                                                 &]],
	[[##......#%                                                 &]],
	[[###....##%                                                 &]],
	[[##..#...#%                                                 &]],
	[[###......%                                                 &]],
	[[#.......#%                                                 &]],
	[[##.......%                                                 &]],
	[[#...##...%                                                 &]],
	[[#...###..%                                                 &]],
	[[###..#.##%                                                 &]],
	[[##....##.%                                                 &]],
	[[##...##..%                                                 &]],
	[[#..#...#.%                                                 &]],
	[[#...##..#%                                                 &]],
	[[#.#....#.%                                                 &]],
	[[#####..##%                                                 &]],
	[[#.####...%                                                 &]],
	[[#...###.#%                                                 &]],
	[[#..#.....%                                                 &]],
	[[#....##..%                                                 &]],
	[[#..##...#%                                                 &]],
	[[#.##.#...%                                                 &]],
	[[#...###..%                                                 &]],
	[[#.......#%                                      %%%%%++%%%%&]],
	[[##......#%                                      %::::::::::&]],
	[[#.......#%                                      %::::::::::&]],
	[[#..#....#%                                      %::::::::::&]],
	[[#........%                                      %:::X::::::&]],
	[[<........+                                      %::::::::::&]],
	[[#........+                                      %::::::::L:&]],
	[[##...#..#%                                      %::::::::::&]],
	[[##.......%                                      %::::::::::&]],
	[[#.......#%                                      %:@::::::::&]],
	[[##......#%                                      %::::::::::&]],
	[[#.##...##%                                      %%%%%++%%%%&]],
	[[#..#.#...%                                                 &]],
	[[#......##%                                                 &]],
	[[##..#...#%                                                 &]],
	[[#.......#%                                                 &]],
	[[#..###...%                                                 &]],
	[[#...###.#%                                                 &]],
	[[#....#...%                                                 &]],
	[[#.......#%                                                 &]],
	[[#.#.###.#%                                                 &]],
	[[#.###..#.%                                                 &]],
	[[#....##..%                                                 &]],
	[[#..##...#%                                                 &]],
	[[#....##..%                                                 &]],
	[[#.##.....%                                                 &]],
	[[###.#....%                                                 &]],
	[[#...###..%                                                 &]],
	[[#.####..#%                                                 &]],
	[[#..####.#%                                                 &]],
	[[#...##.##%                                                 &]],
	[[#..#...##%                                                 &]],
	[[#..##.#.#%                                                 &]],
	[[##..###..%                                                 &]],
	[[####....#%                                                 &]],
	[[#########&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&]],}
