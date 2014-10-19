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


return {
	name = 'Assassin\'s Fortress',
	level_range = {15, 25,},
	level_scheme = 'player',
	max_level = 1,
	decay = {300, 800,},
	actor_adjust_level = function(zone, level, e)
		return zone.base_level + e:getRankLevelAdjust() + rng.range(1, 3)
		end,
	width = 60, height = 60,
	day_night = true,
	persistent = 'zone',
	color_shown = {0.9, 0.9, 0.9, 1.0,},
	color_obscure = {0.9*0.7, 0.6*0.9, 0.6*0.9, 0.6*1.0,},
	min_material_level = 2,	max_material_level = 3,
	nicer_tiler_overlay = 'DungeonWallsGrass',
	generator = {
		map = {
			class = 'engine.generator.map.Static',
			map = 'grayswandir-thievery+assassins-fortress',},
		actor = {
			class = 'mod.class.generator.actor.Random',
			nb_npc = {75, 85,},},
		object = {
			class = 'engine.generator.object.Random',
			nb_object = {6, 9,},},
		trap = {
			class = 'engine.generator.trap.Random',
			nb_trap = {0, 0,},},},
	post_process = function(level)
		game.state:makeWeather(
			level, 6, {
				max_nb = 3, chance = 1, dir = 110,
				speed = {0.1, 0.6,}, alpha = {0.3, 0.5,},
				particle_name = 'weather/dark_cloud_%02d',})

		game.state:makeAmbientSounds(
			level, {
				wind = {chance = 120, volume_mod = 1.9, pitch = 2, random_pos = {rad = 10,},
					files = {
						'ambient/forest/wind1', 'ambient/forest/wind2',
						'ambient/forest/wind3', 'ambient/forest/wind4',},},
				bird = {chance = 60, volume_mod = 0.75,
					files = {
						'ambient/forest/bird1', 'ambient/forest/bird2',
						'ambient/forest/bird3', 'ambient/forest/bird4',
						'ambient/forest/bird5', 'ambient/forest/bird6',
						'ambient/forest/bird7'},},
				creature = {chance = 2500, volume_mod = 0.6, pitch = 0.5, random_pos = {rad = 10,},
					files = {
						'creatures/bears/bear_growl_2', 'creatures/bears/bear_growl_3',
						'creatures/bears/bear_moan_2',},},})

		level.map:liteAll(0, 0, 9, 59)

		end,
	foreground = function(level, x, y, nb_keyframes)
		if not config.settings.tome.weather_effects or not level.foreground_particle then return end
		level.foreground_particle.ps:toScreen(x, y, true, 1)
		end,
	on_enter = function(_, _, zone)
		local Quest = require 'engine.Quest'
		local player = game:getPlayer(true)
		local q = 'grayswandir-thievery+assassins-fortress'

		-- Convenience for testing, make sure they have the quest.
		if not player:hasQuest(q)  then
			player:grantQuest(q)
			end

		local escort1, escort2

		if not player:isQuestStatus('assassins-fortress', Quest.DONE) then
			escort1 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1', 'actor', game.zone.quest_escort_1)
			escort2 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', 'actor', game.zone.quest_escort_2)
			game.zone.quest_escort_1 = escort1
			game.zone.quest_escort_2 = escort2
			player:learnTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1', true)
			player:learnTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', true)
			end

		if not player:isQuestStatus('assassins-fortress', Quest.DONE, 'find-fortress') then
			player:setQuestStatus('assassins-fortress', Quest.DONE, 'find-fortress')
			require('engine.Chat').new('assassins-fortress-enter', escort1, game.player):invoke()
			end

		end,
	on_leave = function(_, _, zone)
		local player = game:getPlayer(true)
		player:unlearnTalentFull 'T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1'
		player:unlearnTalentFull 'T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2'
		end,}
