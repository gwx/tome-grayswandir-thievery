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

if escort1 and escort2 then

	newChat {
		id = 'start',
		text = [["Now that that brute's down, we can mop up the rest. Your work here is done."]],
		answers = {{'...',},},}

elseif escort1 and not escort2 then

	newChat {
		id = 'start',
		text = [["Now that that brute's down, I'll be enough for the rest. Your work here is done."]],
		answers = {{'...',},},}

elseif not escort1 and escort2 then

	newChat {
		id = 'start',
		text = [["You've fulfilled your duty. The rest are mine."]],
		answers = {{'...',},},}

else

	newChat {
		id = 'start',
		text = [[The main foe slain, it's only a matter of time before the rest of the creatures disperse. You've done your duty.

With no one to report your results to, you decide to simply leave.]],
		answers = {{'...',},},}

	end

return 'start'
