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


local get = util.getval

hook('ToME:load', function(self, data)

		local Talents = require 'engine.interface.ActorTalents'
		Talents:newTalent {
			name = 'Command Escort', short_name = 'GRAYSWANDIR_COMMAND_ESCORT',
			type = {'other/other', 1,},
			points = 1,
			range = function(self, t) return self.sight end,
			no_npc_use = true, no_energy = true,
			action = function(self, t)
				local tg = {type = 'hit', range = get(t.range, self, t),}
				local x, y, actor = self:getTarget(tg)

				if not actor or
					not actor.summoner == self or not actor.grayswandir_can_command or
					not self:hasLoS(actor)
				then return end

				local x, y, actor2 = self:getTarget(tg)
				if not x or not y then return end

				actor.grayswandir_command_target = {x, y, actor2,}
				return true end,
			info = function(self, t)
				return 'Command your escort! First target an escort, then a target. Target a hostile creature to attack it, a friendly creature to follow and defend it, or an empty spot on the ground to have it guard that area.'
				end,}

		end)
