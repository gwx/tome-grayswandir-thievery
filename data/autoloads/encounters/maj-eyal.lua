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


newEntity {
	name = 'Assassin Lord\'s Messenger',
	type = 'harmless', subtype = 'special', unique = true,
	level_range = {15, 25,},
	rarity = 9,
	min_level = 12,
	on_world_encounter = 'merchant-quest',
	on_encounter = function(self, who)
		local Quest = require 'engine.Quest'
		-- If we haven't finished the lost merchant quest, don't spawn.
		if not who:isQuestStatus('lost-merchant', Quest.DONE) then return end
		-- If we have finished the lost merchant quest but didn't ally
		-- with the lord, spawn but do nothing.
		if not who:isQuestStatus('lost-merchant', Quest.DONE, 'evil') then return true end

		who.energy.value = game.energy_to_act
		game.paused = true
		who:runStop()

		local Dialog = require 'engine.ui.Dialog'
		Dialog:simplePopup('Encounter', [[A rogue steps out of the shadows to speak with you:
"Our Lord requires your assistance. Come to the southern end of the old forest."

He hands you a small map of the area and then vanishes.]])
		game.player:grantQuest 'grayswandir-thievery+assassins-fortress'
		end,}
