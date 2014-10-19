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


-- A map generator for densely packed rooms, and possibly hallways.

local class = require 'engine.class'
local BSP = require 'engine.BSP'
local Generator = require 'engine.Generator'
local Map = require 'engine.Map'
local RoomsLoader = require 'engine.generator.map.RoomsLoader'

local get = util.getval

module(..., package.seeall, class.inherit(Generator, RoomsLoader))

function _M:init(zone, map, level, data)
	Generator.init(self, zone, map, level)
	self.data = data
	self.grid_list = self.zone.grid_list

	self.min_room_size = 6
	self.split_room = data.split_room or function(length)
		return rng.percent(util.bound((length - 6) ^ 2, 0, 100))
		end
	self.hallway = data.hallway or function(depth) return rng.percent(100 / (depth + 1)) end
	self.hallway_width = data.hallway_width or function(depth) return depth > 1 and 1 or 2 end
	self.min_hallway_length = data.min_hallway_length or 8
	self.max_hallway_length = data.max_hallway_length or 18
	self.door_spacing = data.door_spacing or 3
	self.extra_door = data.extra_door or function(length)
		return rng.percent(math.min(70, length ^ 2))
		end
	self.draw_wall = data.draw_wall or function(self, xmin, xmax, ymin, ymax, depth)
		for x = xmin, xmax do
			for y = ymin, ymax do
				self.map(x, y, Map.TERRAIN, self:resolve 'wall')
				end end end
	self.draw_room = data.draw_room or function(self, xmin, xmax, ymin, ymax, depth, links)
		for x = xmin, xmax do
			for y = ymin, ymax do
				self.map(x, y, Map.TERRAIN, self:resolve 'floor')
				end end end
	self.draw_hallway = data.draw_hallway or function(self, xmin, xmax, ymin, ymax, depth)
		for x = xmin, xmax do
			for y = ymin, ymax do
				self.map(x, y, Map.TERRAIN, self:resolve 'floor')
				end end end
	self.edges = data.edges or {}

	self.edge_xmin = 0
	self.edge_xmax = self.map.w - 1
	self.edge_ymin = 0
	self.edge_ymax = self.map.h - 1

	RoomsLoader.init(self, data)
	end

function _M:generate(level)

	local xmin, xmax, ymin, ymax = 0, self.map.w - 1, 0, self.map.h - 1
	local links = {}

	self:draw_wall(xmin, xmax, ymin, ymax, 0)

	if 'wall' == self.edges[2] or 'door' == self.edges[2] then
		ymax = ymax - 1
		if 'door' == self.edges[2] then links[2] = true end
		end
	if 'wall' == self.edges[4] or 'door' == self.edges[4] then
		xmin = xmin + 1
		if 'door' == self.edges[4] then links[4] = true end
		end
	if 'wall' == self.edges[6] or 'door' == self.edges[6] then
		xmax = xmax - 1
		if 'door' == self.edges[6] then links[6] = true end
		end
	if 'wall' == self.edges[8] or 'door' == self.edges[8] then
		ymin = ymin + 1
		if 'door' == self.edges[8] then links[8] = true end
		end

	self:generateArea(xmin, xmax, ymin, ymax, 0, links)

	-- Get rid of doors on walls.
	--[[ Disabled until I'm sure the rest doesn't have bugs.
	local is_wall = function(x, y)
		local g = self.map(x, y, Map.TERRAIN)
		return 'wall' == g.type and not g.is_door
		end
	for x = 0, self.map.w - 1 do
		for y = 0, self.map.h - 1 do
			if self.map(x, y, Map.TERRAIN).is_door then
				local xl = x - 1
				if xl < 0 then xl = nil end
				local xr = x + 1
				if xr >= self.map.w then xr = nil end
				local horz_wall = xl and is_wall(xl, y) and xr and is_wall(xr, y)
				local horz_block = (xl and is_wall(xl, y)) or (xr and is_wall(xr, y))

				local yu = y - 1
				if yu < 0 then yu = nil end
				local yd = y + 1
				if yd >= self.map.h then yd = nil end
				local vert_wall = yu and is_wall(x, yu) and yd and is_wall(x, yd)
				local vert_block = (yu and is_wall(x, yu)) or (yd and is_wall(x, yd))

				if horz_wall and not vert_wall and vert_block then
					self.map(xl, y, Map.TERRAIN, self:resolve 'door')
					self.map(x, y, Map.TERRAIN, self:resolve 'wall')
					self.map(xr, y, Map.TERRAIN, self:resolve 'door')
					end

				if vert_wall and not horz_wall and horz_block then
					self.map(x, yu, Map.TERRAIN, self:resolve 'door')
					self.map(x, y, Map.TERRAIN, self:resolve 'wall')
					self.map(x, yd, Map.TERRAIN, self:resolve 'door')
					end

				end end end
	--]]

	return 0, 0, 0, 0, {}
	end

function _M:generateArea(xmin, xmax, ymin, ymax, depth, links)
	local width, height = xmax - xmin, ymax - ymin
	links = links or {}

	if width < 0 or height < 0 then return end

	local horz = get(self.split_room, width)
	if width < self.min_room_size * 2 + 1 then horz = false end
	local vert = get(self.split_room, height)
	if height < self.min_room_size * 2 + 1 then vert = false end
	if horz and vert then
		horz = rng.percent(100 * width / (width + height))
		vert = not horz
		end


	local hallway = get(self.hallway, depth)
	local hallway_width = get(self.hallway_width, depth)

	if horz then
		local split = xmin + rng.range(self.min_room_size, width - self.min_room_size)

		local linkl = {}
		local linkr = {}
		if rng.percent(50) then linkl[6] = true else linkr[4] = true end
		if links[4] then linkl[4] = true end
		if links[6] then linkr[6] = true end
		if links[2] then
			if rng.percent(50) then linkl[2] = true else linkr[2] = true end
			end
		if links[8] then
			if rng.percent(50) then linkl[8] = true else linkr[8] = true end
			end

		if hallway then
			linkl[6] = true
			linkr[4] = true
			local xmidl = split - math.floor(hallway_width / 2) - 1
			local xmidr = split + math.ceil(hallway_width / 2)
			self:generateArea(xmin, xmidl - 1, ymin, ymax, depth + 1, linkl)
			self:generateHallway(xmidl + 1, xmidr - 1, ymin, ymax, depth + 1)
			self:generateArea(xmidr + 1, xmax, ymin, ymax, depth + 1, linkr)
		else
			self:generateArea(xmin, split - 1, ymin, ymax, depth + 1, linkl)
			self:generateArea(split + 1, xmax, ymin, ymax, depth + 1, linkr)
			end
		return end

	if vert then
		local split = ymin + rng.range(self.min_room_size, height - self.min_room_size)

		local linku = {}
		local linkd = {}
		if rng.percent(50) then linku[2] = true else linkd[8] = true end
		if links[8] then linku[8] = true end
		if links[2] then linkd[2] = true end
		if links[4] then
			if rng.percent(50) then linku[4] = true else linkd[4] = true end
			end
		if links[6] then
			if rng.percent(50) then linku[6] = true else linkd[6] = true end
			end

		if hallway then
			linku[2] = true
			linkd[8] = true
			local ymidu = split - math.floor(hallway_width / 2) - 1
			local ymidd = split + math.ceil(hallway_width / 2)
			self:generateArea(xmin, xmax, ymin, ymidu - 1, depth + 1, linku)
			self:generateHallway(xmin, xmax, ymidu + 1, ymidd - 1, depth + 1)
			self:generateArea(xmin, xmax, ymidd + 1, ymax, depth + 1, linkd)
		else
			self:generateArea(xmin, xmax, ymin, split - 1, depth + 1, linku)
			self:generateArea(xmin, xmax, split + 1, ymax, depth + 1, linkd)
			end
		return end

	self:draw_room(xmin, xmax, ymin, ymax, depth, links)

	if xmin - 1 > self.edge_xmin or (self.edges[4] == 'door' and xmin - 1 == self.edge_xmin) then
		self:generateDoors(xmin - 1, xmin - 1, ymin + 1, ymax - 1, not links[4])
		end
	if xmax + 1 < self.edge_xmax or (self.edges[6] == 'door' and xmax + 1 == self.edge_xmax) then
		self:generateDoors(xmax + 1, xmax + 1, ymin + 1, ymax - 1, not links[6])
		end
	if ymin - 1 > self.edge_ymin or (self.edges[8] == 'door' and ymin - 1 == self.edge_ymin) then
		self:generateDoors(xmin + 1, xmax - 1, ymin - 1, ymin - 1, not links[8])
		end
	if ymax + 1 < self.edge_ymax or (self.edges[2] == 'door' and ymax + 1 == self.edge_ymax) then
		self:generateDoors(xmin + 1, xmax - 1, ymax + 1, ymax + 1, not links[2])
		end
	end

function _M:isEdgeWall(x, y)
	if x == self.edge_xmin and self.edges[4] then return true end
	if x == self.edge_xmax and self.edges[6] then return true end
	if y == self.edge_ymin and self.edges[8] then return true end
	if y == self.edge_ymax and self.edges[2] then return true end
	end

function _M:generateHallway(xmin, xmax, ymin, ymax, depth)
	local width, height = xmax - xmin, ymax - ymin
	if width > height and width > self.max_hallway_length then
		local split = xmin + rng.range(self.min_hallway_length, width - self.min_hallway_length)
		self:generateHallway(xmin, split - 1, ymin, ymax, depth + 1)
		for y = ymin, ymax do self.map(split, y, Map.TERRAIN, self:resolve 'door') end
		self:generateHallway(split + 1, xmax, ymin, ymax, depth + 1)
		return end
	if height > width and height > self.max_hallway_length then
		local split = ymin + rng.range(self.min_hallway_length, height - self.min_hallway_length)
		self:generateHallway(xmin, xmax, ymin, split - 1, depth + 1)
		for x = xmin, xmax do self.map(x, split, Map.TERRAIN, self:resolve 'door') end
		self:generateHallway(xmin, xmax, split + 1, ymax, depth + 1)
		return end

	self:draw_hallway(xmin, xmax, ymin, ymax, depth)
	end

function _M:generateDoors(xmin, xmax, ymin, ymax, is_extra)
	local width, height = xmax - xmin, ymax - ymin
	if width < 0 or height < 0 then return end
	if is_extra then
		for x = xmin, xmax do
			for y = ymin, ymax do
				local g = self.map(x, y, Map.TERRAIN)
				if g and g.is_door then
					return end end end end
	if width > height then
		if is_extra and not get(self.extra_door, width) then return end
		local split = xmin + rng.range(0, width)
		self:generateDoors(xmin, split - self.door_spacing, ymin, ymax, true)
		for y = ymin, ymax do self.map(split, y, Map.TERRAIN, self:resolve 'door') end
		self:generateDoors(split + self.door_spacing, xmax, ymin, ymax, true)
		return end
	if height > width then
		if is_extra and not get(self.extra_door, height) then return end
		local split = ymin + rng.range(0, height)
		self:generateDoors(xmin, xmax, ymin, split - self.door_spacing, true)
		for x = xmin, xmax do self.map(x, split, Map.TERRAIN, self:resolve 'door') end
		self:generateDoors(xmin, xmax, split + self.door_spacing, ymax, true)
		return end
	end
