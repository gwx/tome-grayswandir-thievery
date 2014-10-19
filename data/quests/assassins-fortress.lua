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


id = 'assassins-fortress'
kind = {}
name = 'The Lord\'s Task'

desc = function(self, who)
	local Quest = require 'engine.Quest'
	local desc = {}

	if not self:isStatus(Quest.DONE, 'find-fortress') then
		table.insert(desc, 'The Assassin Lord has requested your presence at the southern end of the Old Forest.')
	elseif not self:isStatus(Quest.DONE) then
		table.insert(desc, 'The Assassin Lord has called you to the southern Old Forest. There is an old fortress here that needs to be cleaned.')
	else
		table.insert(desc, 'You cleared out the fortress in southern Old Forest for the Assassin Lord.')
		end

	return table.concat(desc, '\n')
	end

on_grant = function(self, who)
	if game.zone.wilderness then
		local Grid = require('mod.class.Grid')
		local g = Grid.new {
			show_tooltip = true, always_remember = true,
			name = 'A path into the Old Forest',
			display = '*', color = colors.WHITE,
			notice = true,
			image = 'terrain/grass.png',
			add_displays = {
				Grid.new {image = 'terrain/road_going_right_01.png', z = 8, display_w = 2,},},
			change_level = 1, glow = true,
			change_zone = 'grayswandir-thievery+assassins-fortress',}
		g:resolve() g:resolve(nil, true)
		game.zone:addEntity(game.level, g, 'terrain', 26, 31)
		game.logPlayer(game.player, 'You have been directed to the southern end of the Old Forest.')
		end end
