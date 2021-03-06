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


load('/data/general/grids/basic.lua')
load('/data/general/grids/forest.lua')
load('/data/general/grids/water.lua')

local Grid = require 'mod.class.Grid'

local grass_editor = {method = 'borders_def', def = 'dark_grass',}

for _, extra in pairs {false, 'WALL', 'FLOOR'} do

	local base = 'GRASS'
	if extra then base = base .. '_X' .. extra end

	newEntity{
		define_as = base,
		type = 'floor', subtype = 'dark_grass',
		name = 'grass', image = 'terrain/grass/dark_grass_main_01.png',
		display = '.', color = colors.LIGHT_GREEN, back_color = {r = 44, g = 95, b = 43,},
		grow = 'TREE',
		special_change = extra,
		nice_tiler = {method = 'replace', base = {base, 100, 1, 14,},},
		nice_editer = grass_editor,}

	for i = 1, 14 do
		newEntity {
			base = base, define_as = base..i,
			image = ('terrain/grass/dark_grass_main_%02d.png'):format(i),}
		end

	end

newEntity {
	base = 'FLOOR',
	define_as = 'FLOOR_XWALL',
	special_change = 'WALL',}

newEntity {
	define_as = 'PORTAL',
	type = 'quest', subtype = 'portal',
	name = 'Recall Portal',
	show_tooltip = true,
	display = '&', color = colors.VIOLET,
	image = 'terrain/grass/dark_grass_main_01.png',
	add_displays = {class.new {image = 'terrain/maze_teleport.png', z = 8,},},
	notice = true,
	always_remember = true,
	quest_portal = true,
	desc = 'A recall portal home.',}

local treesdef = {
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_01', {'foliage_summer_%02d',1,2}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_02', {'foliage_summer_%02d',3,3}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_03', {'foliage_summer_%02d',4,4}}},
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'oldforest_tree_01', {tall=-1, 'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'oldforest_tree_02', {tall=-1, 'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'oldforest_tree_03', {tall=-1, 'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'small_oldforest_tree_01', {'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'small_oldforest_tree_02', {'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_01', {'foliage_bare_%02d',1,2}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_02', {'foliage_bare_%02d',3,3}}},
	{'small_oldforest_tree_03', {'shadow', 'trunk_03', {'foliage_bare_%02d',4,4}}},}

for _, extra in pairs {false, 'WALL',} do

	local base = 'TREE'
	if extra then base = base .. '_X' .. extra end

	newEntity {
		define_as = base,
		type = 'wall', subtype = 'dark_grass',
		name = 'tree',
		image = 'terrain/tree.png',
		display = '#', color = colors.LIGHT_GREEN, back_color = {r = 44, g = 95, b = 43,},
		always_remember = true,
		can_pass = {pass_tree = 1,},
		does_block_move = true,
		block_sight = true,
		dig = 'GRASS', special_change = extra,
		nice_tiler = {method = 'replace', base = {base, 100, 1, 30,},},
		nice_editer = grass_editor,}

	for i = 1, 30 do
		newEntity(class:makeNewTrees({base = base, define_as = base..i, image = 'terrain/grass/dark_grass_main_01.png'}, treesdef, 3))
		end

	end

newEntity{
	define_as = 'HARDTREE',
	type = 'wall', subtype = 'dark_grass',
	name = 'tall thick tree',
	image = 'terrain/tree.png',
	display = '#', color = colors.LIGHT_GREEN, back_color = {r = 44, g = 95, b = 43,},
	always_remember = true,
	does_block_move = true,
	block_sight = true,
	block_sense = true,
	block_esp = true,
	nice_tiler = {method = 'replace', base = {'HARDTREE', 100, 1, 30,},},
	nice_editer = grass_editor,}

for i = 1, 30 do
	newEntity(class:makeNewTrees({base='HARDTREE', define_as = 'HARDTREE'..i, image = 'terrain/grass/dark_grass_main_01.png'}, treesdef))
	end

newEntity{
	define_as = 'GRASS_UP_WILDERNESS', base = 'GRASS_UP_WILDERNESS',
	image = 'terrain/grass/dark_grass_main_01.png',
	nice_editer = grass_editor,}
