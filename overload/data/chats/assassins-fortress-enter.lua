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

local escort2 = game.player:callTalent('T_GRAYSWANDIR_SHADOWBLADE_ESCORT_2', 'actor')

newChat {
	id = 'start',
	text = ([[A pair of shadowblades lazily walk up to you as you enter the clearing. The one in front does the talking. "Our lord thinks that this here fortress", he begins, waving broadly behind him, "will make a great base of operations. Once we've cleared out the vermin, anyway. You've dealt with trolls before, of course?"

He grins before continuing. "Me and %s here will be on hand if you have any trouble." He finishes and then vanishes in a puff of smoke.

%s gives you a vicious grin. "Make sure to leave some for us." He then vanishes as well.

#ORANGE#Note: You've learned some new talents just for this map.#LAST#]]):format(
			escort2.short_name, escort2.short_name),
	answers = {{'...',},},}

return 'start'
