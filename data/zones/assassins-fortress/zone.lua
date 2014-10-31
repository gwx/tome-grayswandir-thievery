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
	store_levels_by_restock = {20, 35, 45,},
	generator = {
		map = {
			class = 'engine.generator.map.Static',
			map = 'grayswandir-thievery+assassins-fortress',},
		actor = {
			class = 'mod.class.generator.actor.Random',
			nb_npc = {75, 85,},},
		actor2 = {
			class = 'mod.class.generator.actor.Random',
			nb_npc = {25, 35,},},
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
	on_enter = function()
		local Quest = require 'engine.Quest'
		local Map = require 'engine.Map'
		local player = game:getPlayer(true)
		local q = 'grayswandir-thievery+assassins-fortress'
		local zone = game.zone
		local level = game.level

		-- Convenience for testing, make sure they have the quest.
		if not player:hasQuest(q) then player:grantQuest(q) end

		local escort1, escort2

		-- Give escort talents if the quest isn't finished.
		if not player:isQuestStatus('assassins-fortress', Quest.DONE) then
			escort1 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1', 'actor', zone.quest_escort_1)
			escort2 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', 'actor', zone.quest_escort_2)
			zone.quest_escort_1 = escort1
			zone.quest_escort_2 = escort2
			player:learnTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1', true)
			player:learnTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', true)
			end

		-- Advance the quest if this is the first time we've entered.
		if not player:isQuestStatus('assassins-fortress', Quest.DONE, 'find-fortress') then
			player:setQuestStatus('assassins-fortress', Quest.DONE, 'find-fortress')
			require('engine.Chat').new('assassins-fortress-enter', escort1, game.player):invoke()
			end

		-- The first time we enter after finishing the quest.
		if player:isQuestStatus('assassins-fortress', Quest.DONE) and
			not player:isQuestStatus('assassins-fortress', Quest.DONE, 'fortress-inhabited')
		then
			player:setQuestStatus('assassins-fortress', Quest.DONE, 'fortress-inhabited')

			-- Repair the fortress
			for x = 0, level.map.w - 1 do
				for y = 0, level.map.h - 1 do
					local g = level.map(x, y, Map.TERRAIN)
					if g and g.special_change then
						level.map(x, y, Map.TERRAIN, zone.grid_list[g.special_change])
						game.nicer_tiles:updateAround(level, x, y)
						end
					end end

			-- Kill all existing enemies.
			for uid, entity in pairs(level.entities) do
				if entity.act and game.player:reactionToward(entity) < 0 then
					entity:die() end end

			-- Switch to the rogue enemy list.
			_load_zone = zone
			zone.npc_list = zone.npc_class:loadList(zone:getBaseName()..'npcs2.lua')
			_load_zone = nil
			level:setEntitiesList('actor', zone:computeRarities('actor', zone.npc_list, level))
			level.data.generator.actor = level.data.generator.actor2

			-- Add special actors
			for _, spot in pairs(level.spots) do
				if spot.subtype == 'actor' then
					local actor = zone:makeEntityByName(level, 'actor', spot.actor)
					if actor then zone:addEntity(level, actor, 'actor', spot.x, spot.y) end
					end
				end

			-- Populate with rogues.
			zone:getGenerator('actor', level, {}):generate()
			for uid, entity in pairs(level.entities) do
				if entity.act and game.player:reactionToward(entity) < 0 then
					entity.faction = 'assassin-lair' end end


			end

		end,
	on_leave = function(_, _, zone)
		local player = game:getPlayer(true)
		player:unlearnTalentFull 'T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1'
		player:unlearnTalentFull 'T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2'
		end,}
