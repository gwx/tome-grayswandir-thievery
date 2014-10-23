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


local get = util.getval

newTalent {
	name = 'Ruler\'s Aura', short_name = 'GRAYSWANDIR_RULERS_AURA',
	type = {'psionic/other', 1,},
	points = 1,
	mode = 'passive',
	duration = 3,
	radius = 3,
	chance = 20,
	power = function(self, t) return self:scale {low = 33, high = 67, 'u.mind',} end,
	callbackOnActBase = function(self, t)
		local tg = {type = 'ball', selffire = false, talent = t, range = 0, radius = get(t.radius, self, t),}
		local chance = get(t.chance, self, t)
		local duration = get(t.duration, self, t)
		local power = get(t.power, self, t)
		self:project(tg, self.x, self.y, function(x, y)
				local actor = game.level.map(x, y, Map.ACTOR)
				if not actor then return end
				if not rng.percent(chance) then return end
				if self:reactionToward(actor) < 0 then
					actor:setEffect('EFF_INTIMIDATED', duration, {src = self, power = power,})
				else
					actor:setEffect('EFF_GRAYSWANDIR_ENCOURAGED', duration, {src = self, power = power,})
					end
				end)
		end,
	info = function(self, t)
		return ([[Every turn, all creatures within radius %d of you have a %d%% chance to be affected by your aura, lasting for %d turns. Their physical, mind, and spell powers will be adjusted by %d #SLATE#[mind]#LAST#. Friendly creatures will have them increased, hostile creatures decreased.]]):format(
			get(t.radius, self, t),
			get(t.chance, self, t),
			get(t.duration, self, t),
			get(t.power, self, t))
		end,}

for i = 1, 2 do
	newTalent {
		name = 'Grayswandir Shadowblade Escort '..i,
		type = {'other/other', 1,},
		image = 'talents/grayswandir_shadowblade_escort.png',
		mode = 'sustained',
		cooldown = 30, no_npc_use = true, no_energy = true,
		range = function(self, t) return self.sight end,
		flee_percent = 50,
		use_percent = 90,
		on_pre_use = function(self, t, silent)
			local escort = get(t.actor, self, t)
			if escort.x then
				if not silent then
					game.logPlayer(self, '%s is still in the level!', escort.name:capitalize())
					end
				return false
				end
			if escort.life * 100 / escort.max_life < get(t.use_percent, self, t) then
				if not silent then
					game.logPlayer(self, '%s does not have enough life and will ignore your call!',
						escort.name:capitalize())
					end
				return false
				end
			return true
			end,
		actor = function(self, t, default, no_generate)
			local actor = table.get(self, 'talents_data', t.id, 'escort')
			if actor then return actor end

			if default then
				table.set(self, 'talents_data', t.id, 'escort', default)
				return default
				end

			if no_generate then return end

			local NPC = require 'mod.class.NPC'
			actor = NPC.new {
				source_talent = t.id,

				type = 'humanoid', subtype = 'human', display = 'p', color = colors.BLUE,
				image = 'npc/humanoid_human_shadowblade.png',
				name = 'temp', faction = 'assasin-lair',
				rank = 3, size_category = 3,
				body = {INVEN = 10, MAINHAND = 1, OFFHAND = 1, BODY = 1,},
				desc = [[A shadowblade under your command.]],
				summoner = self, ai = 'summon-escort',

				level_range = {12, nil,},
				max_life = 300, life_rating = 10, life_teleport_percent = get(t.flee_percent, self, t),
				life_regen = 2,

				open_door = true,
				resolvers.inscription('INFUSION:_REGENERATION', {heal = 120, inc_stat = 30, dur = 5, cooldown = 12,}),
				resolvers.inscriptions(1, 'rune'),

				stats = {str = 10, dex = 16, con = 10, cun = 16, wil = 12, mag = 14,},
				autolevel = 'roguemage',

				resolvers.equip {
					{type = 'weapon', subtype = 'dagger', autoreq = true,},
					{type = 'weapon', subtype = 'dagger', autoreq = true,},
					{type = 'armor', subtype = 'light', autoreq = true,},},

				resolvers.racial(), resolvers.sustains_at_birth(),

				resolvers.talents{
					T_STEALTH = {base = 3, every = 5, max = 8,},
					T_DUAL_WEAPON_TRAINING = {base = 2, every = 6, max = 6,},
					T_DUAL_WEAPON_DEFENSE = {base = 2, every = 6, max = 6,},
					T_DUAL_STRIKE = {base = 1, every = 6, max = 6,},
					T_SHADOWSTRIKE = {base = 2, every = 6, max = 6,},
					T_SHADOWSTEP = {base = 2, every = 6, max = 6,},
					T_LETHALITY = {base = 5, every = 6, max = 8,},
					T_SHADOW_LEASH = {base = 1, every = 6, max = 6,},
					T_SHADOW_AMBUSH = {base = 1, every = 6, max = 6,},
					T_SHADOW_COMBAT = {base = 1, every = 6, max = 6,},
					T_SHADOW_VEIL = {last = 20, base = 0, every = 6, max = 6,},
					T_BLUR_SIGHT = {last = 10, base = 0, every = 6, max = 6,},},

				on_die = function(actor, src, death_note)
					actor.summoner:unlearnTalentFull(actor.source_talent)
					end,

				on_teleport_out = function(actor)
					game.level.map:particleEmitter(actor.x, actor.y, 1, 'summon')
					actor.ai_state.want_teleport_out = nil
					if table.get(actor, 'ai_state', 'flee_min_life') then
						actor.ai_state.flee_min_life = nil
						game.logSeen(actor, '%s is heavily injured, and flees!', actor.name:capitalize())
						end
					if actor.summoner:isTalentActive(actor.source_talent) then
						actor.summoner:forceUseTalent(actor.source_talent, {ignore_energy = true,})
						end
					actor.life = actor.max_life
					actor:removeAllEffects()
					end,}

			actor.short_name = actor:generateName 'male'
			actor.name = actor.short_name..' the Shadowblade'

			self:setupSummon(actor)
			actor.remove_from_party_on_death = true
			actor.control = 'order'
			actor:resolve() actor:resolve(nil, true)
			actor:forceLevelup(self.level)

			table.set(self, 'talents_data', t.id, 'escort', actor)

			return actor
			end,
		on_learn = function(self, t)
			local escort = get(t.actor, self, t)
			t.name = 'Escort: '..escort.name
			game.party:addMember(escort, {
					control ='no', type = 'summon', title = 'Escort',
					leave_level = function(escort, d)
						game.level:removeEntity(escort, true)
						escort.x = nil
						escort.y = nil
						end,
					orders = {target = true, leash = true, anchor = true, talents = true,},})
			end,
		on_unlearn = function(self, t)
			local escort = get(t.actor, self, t, nil, true)
			if escort then
				if escort.x and escort.y then
					game.level.map:remove(escort.x, escort.y, Map.ACTOR)
					end
				game.party:removeMember(escort, true)
				game:removeEntity(escort)
				end
			local data = self.talents_data
			if data then data[t.id] = nil end
			end,
		callbackOnLevelup = function(self, t) get(t.actor, self, t):forceLevelup(self.level) end,
		callbackOnLoad = function(self, t)
			local escort = get(t.actor, self, t, nil, true)
			if escort then t.name = 'Escort: '..(escort.name) end
			end,
		activate = function(self, t)
			local tg = {type = 'hit', range = get(t.range, self, t),}
			local x, y, actor = self:getTarget(tg)
			if not x or not y then return end
			local escort = get(t.actor, self, t)
			if not escort then t.on_learn(self, t) escort = get(t.actor, self, t) end
			escort:forceLevelup(self.level)
			escort.fov.actors_dist = {} -- fix stealth issue.
			if actor then
				local t = escort:getTalentFromId 'T_SHADOWSTEP'
				local tx, ty = util.findFreeGrid(x, y, get(t.range, self, t), true, {[Map.ACTOR] = true,})
				if not tx or not ty or not escort:canMove(tx, ty) then return end
				game.zone:addEntity(game.level, escort, 'actor', tx, ty)
				escort:setTarget(actor)
				escort:forceUseTalent('T_SHADOWSTEP', {ignore_energy = true, ignore_cd = true, force_target = actor,})
				return true
			elseif escort:canMove(x, y) then
				game.zone:addEntity(game.level, escort, 'actor', x, y)
				return true
				end
			end,
		deactivate = function(self, t, p)
			if not self:knowTalent(t.id) then return true end
			local escort = get(t.actor, self, t, nil, true)
			if escort then table.set(escort, 'ai_state', 'want_teleport_out', true) end
			return true
			end,
		info = function(self, t)
			local name = get(t.actor, self, t).short_name
			return ([[Activating this will cause the shadowblade %s to come to your aid. They will appear at the selected space, or shadowstep whatever is standing there. Deactivating this talent will cause them to teleport out at their next opportunity.

%s will try to flee if he drops below 50%% life. If %s dies, it will be permanent.]]):format(name, name, name)
			end,}

	end
