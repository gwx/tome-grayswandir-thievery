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

-- temporarily wrap game.player:incMoney to increase the cost.
local incMoney = game.player.incMoney
local incMoneyReal = rawget(game.player, 'incMoney')
function game.player:incMoney(money)
	incMoney(self, money * 1.5)
	end

-- Grab current chats table.
local Chat
local index = 1
local name, value
while true do
	name, value = debug.getlocal(2, index)
	if not name then
		error '[grayswandir-thievery] Could not find chat object.'
	elseif 'self' == name then
		Chat = value
		break
	else
		index = index + 1
		end	end

-- Fake having saved the lost merchant.
local hasQuestReal = rawget(game.player, 'hasQuest')
game.player.hasQuest = function() return {isStatus = function() return true end,} end

-- Load original lost merchant.
local f, err = loadfile('/data/chats/last-hope-lost-merchant.lua')
if not f and err then error(err) end
setfenv(f, setmetatable(
		{newChat = function(c) if c.id ~= 'welcome' then Chat:addChat(c) end end,},
		{__index = Chat.data,}))
f()

game.player.hasQuest = hasQuestReal

newChat {
	id = 'welcome',
	text = 'With a nervous glance at the Assassin Lord, the merchant stutters: "P-please, my friend, won\'t you buy s-something?"'..
		(game.state:isAdvanced() and [[
"Or you could place .. a special order."]]or ''),
	answers = {
		{'Show me what you have.',
			action = function(npc, player)
				npc.store:loadup(game.level, game.zone)
				npc.store:interact(player) end,},
		{'A Special Order?',
			cond = function(npc, player) return game.state:isAdvanced() end,
			jump = 'special',},
		{'No.',},},}

newChat {
	id = 'special',
	text = [["For a paltry 6000 gold donation to our lord, you can have a completely unique item."
The Assassin Lord grins as he sees you considering.]],
	answers = {
		{'Certainly',
			cond = function(npc, player) return player.money >= 6000 end,
			jump = 'make',},
		{'No.',},},}


local unregisterDialog = game.unregisterDialog
local unregisterDialogReal = rawget(game, 'unregisterDialog')
function game:unregisterDialog(dialog)
	unregisterDialog(self, dialog)
	if dialog.__CLASSNAME == 'engine.dialogs.Chat' then
		game.player.incMoney = incMoneyReal
		self.unregisterDialog = unregisterDialogReal
		end end

return 'welcome'
