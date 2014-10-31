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

load '/data/general/npcs/thieve.lua'

newEntity {
	define_as = 'MERCHANT',
	type = 'humaniod', subtype = 'human',
	display = '@', color = colors.UMBER, image = 'npc/humanoid_human_lost_merchant.png',
	name = 'Enslaved Merchant',
	size_category = 3,
	ai = 'simple', faction = 'victim',
	desc = [[Battered and bruised, this merchant has seen better days.]],
	resolvers.store('BLACK_MARKET', 'assassin-lair'),
	resolvers.chatfeature('assassins-fortress-merchant', 'assassins-lair'),}

newEntity {
	define_as = 'ASSASSIN_LORD',
	type = 'humanoid', subtype = 'human',
	display = 'p', color = colors.VIOLET,
	name = 'Assassin Lord',
	body = {INVEN = 10, MAINHAND = 1, OFFHAND = 1, BODY = 1,},
	cant_be_moved = true,

	resolvers.drops{chance = 20, nb = 1, {},},
	resolvers.equip{
		{type = 'weapon', subtype = 'dagger', autoreq = true, force_drop = true, tome_drops = 'boss',},
		{type = 'weapon', subtype = 'dagger', autoreq = true, force_drop = true, tome_drops = 'boss',},
		{type = 'armor', subtype = 'light', autoreq = true, force_drop = true, tome_drops = 'boss',},},
	resolvers.drops{chance = 100, nb = 2, {type = 'money'},},

	rank = 4, size_category = 3, open_door = true,

	autolevel = 'rogue',
	ai = 'tactical', ai_state = {talent_in = 2,},
	stats = {str = 12, dex = 18, mag = 8, cun = 20, con = 11,},

	resolvers.tmasteries{['cunning/stealth'] = 1.3,},

	desc = [[He is the leader of a gang of bandits; watch out for his men.]],

	level_range = {24, 50,}, exp_worth = 2,
	combat_armor = 12, combat_def = 18,
	max_life = resolvers.rngavg(190, 200), life_rating = 16,
	resolvers.talents{
		T_LETHALITY = {base = 5, every = 4, max = 10,},
		T_STEALTH = {base = 6, every = 4, max = 10,},
		T_VILE_POISONS = {base = 5, every = 4, max = 10,},
		T_VENOMOUS_STRIKE = {base = 5, every = 4, max = 10,},
		T_SHADOWSTEP = {base = 5, every = 4, max = 10,},
		T_SHADOW_VEIL = {base = 5, every = 4, max = 10,},
		T_AMBUSCADE = {base = 5, every = 4, max = 10,},
		T_EMPOWER_POISONS = {base = 5, every = 4, max = 10,},
		T_HIDE_IN_PLAIN_SIGHT = {base = 5, every = 4, max = 10,},
		T_DIRTY_FIGHTING = {base = 5, every = 4, max = 10,},},
	stamina_regen = 5,
	mana_regen = 6,

	can_talk = 'assassins-fortress-lord',}
