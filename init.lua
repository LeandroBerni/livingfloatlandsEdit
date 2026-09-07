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
			})
		end
		if #nodes > 0 then
			def.nodes = nodes
			def.min_light = 0
			def.max_light = 15
			def.interval = def.interval or 30
			def.chance = def.chance or 4000
			def.active_object_count = def.active_object_count or 2
			def.min_height = def.min_height or 0
			def.max_height = def.max_height or 31000
			mobs:spawn(def)
			remember_nodes(def)
		end
	end
end)

-- Lightweight nearby spawn so animals actually show up while exploring.
-- ABM alone is easy to miss (rare rolls, 12-node no-spawn radius around the player).
local nearby_timer = 0

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

local function find_ground(x, z, y0)
	for y = math.floor(y0 + 20), math.floor(y0 - 28), -1 do
		local ground = {x = x, y = y, z = z}
		local above = {x = x, y = y + 1, z = z}
		local n = minetest.get_node(ground)
		local a = minetest.get_node(above)
		local ndef = minetest.registered_nodes[n.name]
		if ndef and ndef.walkable and a.name == "air" then
			return ground, n.name
		end
	end
end

minetest.register_globalstep(function(dtime)
	if mobs.custom_spawn_livingfloatlands then
		return
	end
	nearby_timer = nearby_timer + dtime
	if nearby_timer < 12 then
		return
	end
	nearby_timer = 0

	for _, player in ipairs(minetest.get_connected_players()) do
		local ppos = player:get_pos()
		if ppos and count_our_mobs(ppos, 48) < 4 then
			local ang = math.random() * math.pi * 2
			local dist = math.random(18, 38)
			local gx = ppos.x + math.cos(ang) * dist
			local gz = ppos.z + math.sin(ang) * dist
			local ground, nodename = find_ground(gx, gz, ppos.y)
			if ground then
				local choices = node_to_mobs[nodename]
				if choices and #choices > 0 then
					local name = choices[math.random(#choices)]
					local spawnpos = {x = ground.x, y = ground.y + 1, z = ground.z}
					if not minetest.is_protected(spawnpos, "") then
						if mobs.add_mob then
							mobs:add_mob(spawnpos, {name = name})
						else
							minetest.add_entity(spawnpos, name)
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
