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

-- Allows you to grab chats from an addons data/chats folder by
-- prepending with 'addon-short-name+'.

-- XXX NOT WORKING

superload('engine.Chat', function(_M)

		function _M:init(name, npc, player, data)
			print('XXXXX')
			local filename
			local _, addon, basename = name:find('^([^+]+)%+(.+)$')
			print(addon, basename)
			if addon and basename then
				name = basenmae
				filename = '/data-'..addon..'/chats/'..name..'.lua'
			else
				filename = '/data/chats/'..name..'.lua'
				end

			self.quick_replies = 0
			self.chats = {}
			self.npc = npc
			self.player = player
			self.name = name
			data = setmetatable(data or {}, {__index=_G})
			self.data = data

			local f, err = loadfile(filename)
			if not f and err then error(err) end
			setfenv(f, setmetatable({
						newChat = function(c) self:addChat(c) end,
						}, {__index=data}))
			self.default_id = f()

			self:triggerHook{"Chat:load", data=data}
			end
		end)
