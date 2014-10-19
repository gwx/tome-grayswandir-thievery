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


local Stats = require 'engine.interface.ActorStats'

newEntity {
	define_as = 'GRAYSWANDIR_RULERS_GRASP', unique = true,
	base = 'BASE_GAUNTLETS',
	power_source = {psionic = true,},
	unided_name = 'heavy golden gauntlets', color = colors.YELLOW,
	name = 'Ruler\'s Grasp', image = 'object/grayswandir_rulers_grasp.png',
	desc = [[These gauntlets put out an aura of pure awe.]],
	cost = 400, material_level = 3,
	rarity = 350, level_range = {17, 32,},
	wielder = {
		combat_armor = 12,
		combat_mindpower = 8,
		combat_mentalresist = 16,
		combat_mindcrit = 8,
		inc_stats = {[Stats.STAT_WIL] = 4, [Stats.STAT_STR] = 4,},
		learn_talent = {T_GRAYSWANDIR_RULERS_AURA = 1,},
		combat = {
			dam = 24, apr = 8, physcrit = 5, physspeed = 0.2, damrange = 0.2,
			dammod = {dex = 0.4, str = -0.6, cun = 0.4, wil = 0.2,},
			melee_project = {MIND = 14,},
			talent_on_hit = {T_DOMINATE = {level = 3, chance = 20,},},},},}
