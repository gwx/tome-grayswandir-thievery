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

newEffect {
	name = 'GRAYSWANDIR_ENCOURAGED',
	desc = 'Encouraged',
	long_desc = function(self, eff)
		return ('The target\'s morale has strengthened, increasing its physical, mind, and spell powers by %d.')
			:format(eff.power)
		end,
	type = 'mental',
	status = 'beneficial',
	subtype = {morale = true,},
	parameters = {power = 10,},
	on_gain = function() return '#Target#\'s morale has been raised.', '+Encouraged' end,
	on_lose = function() return '#Target# has lost encouragement.', '-Encouraged' end,
	activate = function(self, eff)
		self:autoTemporaryValues(eff, {
				combat_dam = eff.power,
				combat_spellpower = eff.power,
				combat_mindpower = eff.power,})
		end,
	deactivate = function(self, eff) end,}
