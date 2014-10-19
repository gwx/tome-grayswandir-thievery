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


newAI('summon-escort', function(self)
		local Map = require 'engine.Map'

		local percent = self.life_teleport_percent
		if percent and self.life < percent * 0.01 * self.max_life then
			table.set(self, 'ai_state', 'want_teleport_out', true)
			table.set(self, 'ai_state', 'flee_min_life', true)
			end

		if table.get(self, 'ai_state', 'want_teleport_out') then
			self:on_teleport_out()
			game.level.map:remove(self.x, self.y, Map.ACTOR)
			game.level:removeEntity(self)
			game:addEntity(self)
			self.x = nil
			self.y = nil
			self.ai_state.want_teleport_out = nil
			self.ai_state.flee_min_life = nil
			end

		return self:runAI 'tactical'
		end)
