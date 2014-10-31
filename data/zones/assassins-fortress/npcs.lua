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


-- No basic trolls.
load('/data/general/npcs/troll.lua', function(e)
		if e.rarity then
			e.rarity = e.rarity * 0.3
			if e.rank < 3 then e.rarity = nil end
			if e.name == 'mountain troll' then e.rarity = nil end
			end end)
load('/data/general/npcs/plant.lua', rarity(3))
load('/data/general/npcs/swarm.lua', rarity(6))
load('/data/general/npcs/rodent.lua', rarity(9))
load('/data/general/npcs/vermin.lua', rarity(8))
load('/data/general/npcs/molds.lua', rarity(5))
load('/data/general/npcs/snake.lua', rarity(7))

load('/data/general/npcs/all.lua', rarity(5, 35))

newEntity {
	define_as = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	type = 'giant', subtype = 'troll',
	allow_infinite_dungeon = true,
	display = 'T', color = colors.UMBER,
	sound_moam = {'creatures/trolls/troll_moan_%d', 1, 2,},
	sound_die = {'creatures/trolls/troll_die_%d', 1, 2,},
	sound_random = {'creatures/trolls/troll_growl_%d', 1, 4,},

	combat = {
		dam = 5,
		atk = 2, apr = 6, physspeed = 1.2, dammod = {str = 1.0,}, sound = 'creatures/trolls/stomp' },

	body = {INVEN = 10, HANDS = 1, BODY = 1,},
	resolvers.drops{chance=20, nb=1, {} },
	resolvers.drops{chance=60, nb=1, {type='money'} },

	infravision = 10,
	life_rating = 15,
	life_regen = 3,
	max_stamina = 90,
	rank = 2,
	size_category = 4,

	autolevel = 'heavy-brawler',
	ai = 'dumb_talented_simple', ai_state = {ai_move='move_complex', talent_in = 2,},
	stats = {str = 20, dex = 12, cun = 12, mag = 6, con = 16,},

	open_door = true,

	resists = {FIRE = -50,},
	fear_immune = 1,
	ingredient_on_death = 'TROLL_INTESTINE',}

newEntity {
	base = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	name = 'troll brute', color = colors.YELLOW_GREEN, image='npc/troll_f.png',
	desc = [[This hulking, brutish troll charges at you.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 0.6,
	max_life = resolvers.rngavg(140, 180),
	combat_armor = 6, combat_def = 2,
	resolvers.talents {
		T_WEAPON_COMBAT = {base = 1, every = 7, max = 5,},
		T_RUSH = {base = 1, every = 7, max = 5,},
		T_UNARMED_MASTERY = {base = 1, every = 6, max = 6,},
		T_UNFLINCHING_RESOLVE = {base = 2, every = 5, max = 5,},},}

newEntity {
	base = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	name = 'troll thug', color = colors.DARK_SLATE_GRAY, image='npc/troll_s.png',
	desc = [[A troll with a mean look in its eye. For a troll, that's saying something.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 0.6,
	max_life = resolvers.rngavg(110, 150),
	combat_armor = 12, combat_def = 5,
	resolvers.talents {
		T_WEAPON_COMBAT = {base = 1, every = 7, max = 5,},
		['T_RIOT-BORN'] = {base = 1, every = 7, max = 5,},
		T_DIRTY_FIGHTING = {base = 1, every = 7, max = 5,},
		T_TOTAL_THUGGERY = {base = 1, every = 7, max = 5,},
		T_UNARMED_MASTERY = {base = 2, every = 6, max = 6,},},}

newEntity {
	base = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	name = 'troll brawler', color = colors.UMBER, image='npc/troll_m.png',
	desc = [[A heavy-set troll wearing a pair of humongous gauntlets.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 0.6,
	max_life = resolvers.rngavg(140, 180),
	combat_armor = 6, combat_def = 5,
	resolvers.talents {
		T_WEAPON_COMBAT = {base = 2, every = 7, max = 6,},
		T_ARMOUR_TRAINING = 1,
		T_DOUBLE_STRIKE = {base = 1, every = 7, max = 5,},
		T_UPPERCUT = {base = 1, every = 7, max = 5,},
		T_HEIGHTENED_REFLEXES = {base = 1, every = 7, max = 5,},
		T_UNARMED_MASTERY = {base = 3, every = 6, max = 8,},},
	resolvers.equip {
		{type = 'armor', subtype = 'hands', properties = {'metallic',}, autoreq = true,},},}

newEntity {
	base = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	name = 'troll striker', color = colors.DARK_UMBER, image='npc/grayswandir_troll_striker.png',
	desc = [[Small (for a troll), this creature moves with a suprising speed.]],
	level_range = {12, nil}, exp_worth = 1,
	rarity = 1.35,
	rank = 3,
	max_life = 150,
	combat_armor = 6, combat_def = 8,
	movement_speed = 0.9,
	ai_state = {ai_move = 'move_complex', talent_in = 1,},
	resolvers.talents {
		T_WEAPON_COMBAT = {base = 3, every = 7, max = 7,},
		T_DOUBLE_STRIKE = {base = 2, every = 5, max = 7,},
		T_SPINNING_BACKHAND = {base = 1, every = 7, max = 6,},
		T_AXE_KICK = {base = 1, every = 9, max = 5,},
		T_UPPERCUT = {base = 3, every = 7, max = 6,},
		T_BUTTERFLY_KICK = {base = 1, every = 7, max = 5,},
		T_UNIFIED_BODY = {base = 3, every = 6, max = 9,},
		T_PUSH_KICK = {base = 1, every = 9, max = 5,},
		T_HEIGHTENED_REFLEXES = {base = 1, every = 7, max = 5,},
		T_UNARMED_MASTERY = {base = 3, every = 6, max = 8,},},
	resolvers.equip {
		{type = 'armor', subtype = 'hands', not_properties = {'metallic',}, autoreq = true,},},}

newEntity{
	base = 'GRAYSWANDIR_BASE_BRAWLER_TROLL',
	define_as = 'GRAYSWANDIR_TROLL_LORD',
	name = 'Troll Lord',
	color = colors.SLATE,
	resolvers.nice_tile {
		image = 'invis.png',
		add_mos = {{image = 'npc/grayswandir_troll_lord.png', display_h = 2, display_y = -1,},},},
	desc = [[This massive troll reigns over the local trolls.]],
	level_range = {14, nil}, exp_worth = 2,
	max_life = 600, life_rating = 22, fixed_rating = true,
	max_stamina = 140,
	stats = {str = 30, dex = 16, cun = 32, mag = 10, con = 24, wil = 16,},
	combat_mindpower = 20,
	rank = 4,
	instakill_immune = 1,
	move_others = true,

	resolvers.equip {
		{type = 'armor', subtype = 'hands', properties = {'metallic',},
			defined = 'GRAYSWANDIR_RULERS_GRASP', random_art_replace = {chance = 50,}, autoreq = true,},},

	resolvers.drops {chance = 100, nb = 3, {tome_drops = 'boss',},},

	resolvers.talents {
		T_SUMMON = 1,
		T_VITALITY = 2,
		T_ARMOUR_TRAINING = 1,
		T_WEAPON_COMBAT = {base = 3, every = 7, max = 9,},
		T_UNFLINCHING_RESOLVE = {base = 3, every = 9, max = 6,},
		T_DOUBLE_STRIKE = {base = 4, every = 7, max = 8,},
		T_SPINNING_BACKHAND = {base = 2, every = 7, max = 6,},
		T_AXE_KICK = {base = 2, every = 6, max = 5,},
		T_UPPERCUT = {base = 3, every = 7, max = 6,},
		T_BUTTERFLY_KICK = {base = 2, every = 7, max = 5,},
		T_UNIFIED_BODY = {base = 5, every = 6, max = 9,},
		T_PUSH_KICK = {base = 2, every = 9, max = 5,},
		T_HEIGHTENED_REFLEXES = {base = 5, every = 7, max = 8,},
		T_UNARMED_MASTERY = {base = 4, every = 6, max = 8,},},

	resolvers.inscriptions(1, {'wild infusion', 'heroism infusion',}),

	ai = 'tactical', ai_state = {talent_in = 1, ai_move = 'move_astar',},
	ai_tactic = resolvers.tactic 'melee',

	talent_cd_reduction = {T_SUMMON = -6,},
	summon = {
		{name = 'troll brute', number = 2, hasxp = false,},
		{name = 'troll thug', number = 2, hasxp = false,},
		{name = 'troll striker', number = 1, hasxp = false,},},

	on_die = function(self, who)
		local Quest = require 'engine.Quest'
		game.player:resolveSource():setQuestStatus('grayswandir-thievery+assassins-fortress', Quest.DONE)
	end,

	on_die = function(self, who)
		local player = game:getPlayer(true)

		local Quest = require 'engine.Quest'
		local q = 'assassins-fortress'
		player:setQuestStatus(q, Quest.DONE)

		local Chat = require 'engine.Chat'
		local data = {
			escort1 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_1', 'actor'),
			escort2 = player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', 'actor'),}
		Chat.new('assassins-fortress-finish', data.escort1 or data.escort2 or player, player, data):invoke()

		end,}
