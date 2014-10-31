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
	define_as = 'BLACK_MARKET',
	name = 'black market',
	display = '*', color = colors.BLACK,
	store = {
		nb_fill = 30,
		purse = 10,
		empty_before_restock = false,
		sell_percent = 325,
		filters = function()
			return {
				id = true,
				ignore = {type = 'money',},
				add_levels = 14,
				force_tome_drops = true,
				tome_drops = 'boss',
				tome_mod = {money = 0, basic = 0,},
				special = function(o) return o.type ~= 'scroll' end,}
			end,},}
