-- Living Floatlands: prehistoric biomes and animals for Luanti / Minetest.
-- Biomes are extra climates and never clear or overwrite vanilla ones.

livingfloatlands = {}

local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("livingfloatlands") or
		dofile(path .. "intllib.lua")

mobs.intllib = S

-- Optional override file: if spawn.lua exists, skip the built-in spawn rules.
local input = io.open(path .. "spawn.lua", "r")
if input then
	mobs.custom_spawn_livingfloatlands = true
	input:close()
	input = nil
end

local function add_nodes(list, extra)
	for _, name in ipairs(extra) do
		list[#list + 1] = name
	end
end

local function filter_nodes(list)
	local out = {}
	for _, name in ipairs(list) do
		if minetest.registered_nodes[name] then
			out[#out + 1] = name
		end
	end
	return out
end

-- Spawn on this mod's ground and matching vanilla / ethereal nodes.
livingfloatlands.habitats = {
	cold = {
		"livingfloatlands:coldsteppe_litter",
		"default:dirt_with_snow",
		"default:permafrost_with_moss",
		"default:permafrost_with_stones",
		"default:snowblock",
		"default:snow",
		"default:dirt_with_coniferous_litter",
	},
	grassland = {
		"livingfloatlands:coldsteppe_litter",
		"livingfloatlands:giantforest_litter",
		"default:dirt_with_grass",
		"default:dry_dirt_with_dry_grass",
		"default:dirt_with_dry_grass",
		"default:dry_dirt",
	},
	forest = {
		"livingfloatlands:giantforest_litter",
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_rainforest_litter",
	},
	jungle = {
		"livingfloatlands:paleojungle_litter",
		"livingfloatlands:giantforest_litter",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_grass",
		"default:dirt_with_coniferous_litter",
	},
	desert = {
		"livingfloatlands:paleodesert_litter",
		"default:desert_sand",
		"default:sand",
		"default:silver_sand",
		"default:dry_dirt_with_dry_grass",
		"default:desert_sandstone",
		"default:sandstone",
	},
	coast = {
		"livingfloatlands:paleojungle_litter",
		"livingfloatlands:giantforest_litter",
		"livingfloatlands:giantforest_paleoredwood_trunk",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_grass",
		"default:sand",
		"default:desert_sand",
	},
}

-- Decorative ground that replaces the biome top node.
local extra_ground = {
	"livingfloatlands:giantforest_litter_walkway",
	"livingfloatlands:giantforest_litter_with_moss",
	"livingfloatlands:paleojungle_littler_dirt",
	"livingfloatlands:paleojungle_littler_leaves",
	"livingfloatlands:coldsteppe_bulbouschervil_block",
	"default:dirt",
}
add_nodes(livingfloatlands.habitats.forest, extra_ground)
add_nodes(livingfloatlands.habitats.jungle, extra_ground)
add_nodes(livingfloatlands.habitats.grassland, extra_ground)
add_nodes(livingfloatlands.habitats.cold, extra_ground)
add_nodes(livingfloatlands.habitats.coast, extra_ground)

if minetest.get_modpath("ethereal") then
	add_nodes(livingfloatlands.habitats.cold, {
		"ethereal:crystal_dirt",
		"ethereal:gray_dirt",
		"ethereal:cold_dirt",
	})
	add_nodes(livingfloatlands.habitats.grassland, {
		"ethereal:prairie_dirt",
		"ethereal:dry_dirt",
		"ethereal:bamboo_dirt",
	})
	add_nodes(livingfloatlands.habitats.forest, {
		"ethereal:grove_dirt",
		"ethereal:prairie_dirt",
		"ethereal:bamboo_dirt",
	})
	add_nodes(livingfloatlands.habitats.jungle, {
		"ethereal:grove_dirt",
		"ethereal:jungle_dirt",
		"ethereal:bamboo_dirt",
	})
	add_nodes(livingfloatlands.habitats.desert, {
		"ethereal:dry_dirt",
		"ethereal:fiery_dirt",
	})
	add_nodes(livingfloatlands.habitats.coast, {
		"ethereal:grove_dirt",
		"ethereal:jungle_dirt",
		"ethereal:bamboo_dirt",
	})
end

if minetest.get_modpath("livingdesert") then
	add_nodes(livingfloatlands.habitats.cold, {
		"livingdesert:coldsteppe_ground2",
	})
	add_nodes(livingfloatlands.habitats.grassland, {
		"livingdesert:coldsteppe_ground2",
	})
end

-- Queue spawn rules and register them after every node exists.
livingfloatlands._spawns = {}

function livingfloatlands.spawn_mob(def)
	livingfloatlands._spawns[#livingfloatlands._spawns + 1] = def
end

local node_to_mobs = {}

local function remember_nodes(def)
	for _, node in ipairs(def.nodes or {}) do
		local list = node_to_mobs[node]
		if not list then
			list = {}
			node_to_mobs[node] = list
		end
		list[#list + 1] = def.name
	end
end

-- Plants sit on top of dirt, so requiring "air" neighbors makes grassy biomes never spawn.
local spawn_neighbors = {
	"air",
	"group:flora",
	"group:grass",
	"group:dry_grass",
	"group:flower",
	"group:plant",
	"group:leaves",
}

minetest.register_on_mods_loaded(function()
	if mobs.custom_spawn_livingfloatlands then
		return
	end

	for _, def in ipairs(livingfloatlands._spawns) do
		local nodes = filter_nodes(def.nodes or {})
		if #nodes == 0 then
			nodes = filter_nodes({
				"default:dirt_with_grass",
				"default:dirt_with_coniferous_litter",
				"default:dirt_with_rainforest_litter",
				"default:dirt_with_snow",
				"default:dry_dirt_with_dry_grass",
				"default:desert_sand",
				"default:sand",
				"group:soil",
				"group:sand",
			})
		end
		if #nodes > 0 then
			def.nodes = nodes
			def.neighbors = spawn_neighbors
			def.min_light = 0
			def.max_light = 15
			-- Balanced with other animal mods: uncommon, not a swarm.
			def.interval = 45
			def.chance = math.max(def.chance or 5000, 4000)
			def.active_object_count = math.min(def.active_object_count or 2, 2)
			def.min_height = def.min_height or 0
			def.max_height = def.max_height or 31000
			mobs:spawn(def)
			remember_nodes(def)
		end
	end
end)

-- Nearby spawn: ABM is easy to miss. Keep a visible pack around each player.
local nearby_timer = 0
local MAX_NEAR = 10
local SPAWN_TRIES = 8

local function count_our_mobs(pos, radius)
	local total = 0
	for _, obj in ipairs(minetest.get_objects_inside_radius(pos, radius)) do
		local ent = obj:get_luaentity()
		if ent and ent.name and ent.name:find("^livingfloatlands:") then
			total = total + 1
		end
	end
	return total
end

local function is_open(name)
	if name == "air" then
		return true
	end
	local def = minetest.registered_nodes[name]
	return def and not def.walkable
end

local function find_ground(x, z, y0)
	for y = math.floor(y0 + 24), math.floor(y0 - 32), -1 do
		local ground = {x = x, y = y, z = z}
		local above_name = minetest.get_node({x = x, y = y + 1, z = z}).name
		local n = minetest.get_node(ground)
		local ndef = minetest.registered_nodes[n.name]
		if ndef and ndef.walkable and is_open(above_name) then
			return ground, n.name
		end
	end
end

local function pick_mob(nodename)
	local choices = node_to_mobs[nodename]
	if choices and #choices > 0 then
		return choices[math.random(#choices)]
	end
	-- Any registered animal if the exact ground isn't mapped.
	for _, list in pairs(node_to_mobs) do
		if list[1] then
			return list[math.random(#list)]
		end
	end
end

local function spawn_one(pos, name)
	if minetest.is_protected(pos, "") then
		return false
	end
	-- Bypass mobs_redo AOC so nearby fill-in actually happens.
	local obj = minetest.add_entity(pos, name)
	return obj ~= nil
end

minetest.register_globalstep(function(dtime)
	if mobs.custom_spawn_livingfloatlands then
		return
	end
	nearby_timer = nearby_timer + dtime
	if nearby_timer < 3.5 then
		return
	end
	nearby_timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos then
			local have = count_our_mobs(ppos, 56)
			local need = MAX_NEAR - have
			if need > 0 then
				for _ = 1, math.min(SPAWN_TRIES, need) do
					local ang = math.random() * math.pi * 2
					local dist = math.random(10, 28)
					local gx = ppos.x + math.cos(ang) * dist
					local gz = ppos.z + math.sin(ang) * dist
					local ground, nodename = find_ground(gx, gz, ppos.y)
					if ground then
						local name = pick_mob(nodename)
						if name then
							local spawnpos = {x = ground.x, y = ground.y + 1, z = ground.z}
							spawn_one(spawnpos, name)
						end
					end
				end
			end
		end
	end
end)

-- Nodes/biomes first so ground exists, then animals.
dofile(path .. "coldsteppe.lua")
dofile(path .. "paleodesert.lua")
dofile(path .. "giantforest.lua")
dofile(path .. "coldgiantforest.lua")
dofile(path .. "paleojungle.lua")

-- Animals
dofile(path .. "carnotaurus.lua")
dofile(path .. "nigersaurus.lua")
dofile(path .. "deinotherium.lua")
dofile(path .. "mammooth.lua")
dofile(path .. "gastornis.lua")
dofile(path .. "woollyrhino.lua")
dofile(path .. "velociraptor.lua")
dofile(path .. "triceratops.lua")
dofile(path .. "smilodon.lua")
dofile(path .. "parasaurolophus.lua")
dofile(path .. "gigantopithecus.lua")
dofile(path .. "wildhorse.lua")
dofile(path .. "entelodon.lua")
dofile(path .. "oviraptor.lua")
dofile(path .. "stegosaurus.lua")
dofile(path .. "ankylosaurus.lua")
dofile(path .. "lycaenops.lua")
dofile(path .. "tyrannosaurus.lua")
dofile(path .. "cavebear.lua")
dofile(path .. "rhamphorhynchus.lua")
dofile(path .. "dye.lua")
dofile(path .. "crafting.lua")
dofile(path .. "leafdecay.lua")
dofile(path .. "hunger.lua")

if mobs.custom_spawn_livingfloatlands then
	dofile(path .. "spawn.lua")
end

print(S("[MOD] Living Floatlands loaded"))
