-- Living Floatlands: prehistoric biomes and animals for Luanti / Minetest.
-- Biomes are extra climates and never clear or overwrite vanilla ones.
-- Animals spawn only on matching biome ground (no player-centered spawn).

livingfloatlands = {}

local path = minetest.get_modpath(minetest.get_current_modname()) .. "/"

local S = minetest.get_translator and minetest.get_translator("livingfloatlands") or
		dofile(path .. "intllib.lua")

mobs.intllib = S

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

-- Habitat = specific ground of that climate, not "anywhere near the player".
livingfloatlands.habitats = {
	cold = {
		"livingfloatlands:coldsteppe_litter",
		"livingfloatlands:coldsteppe_bulbouschervil_block",
		"default:dirt_with_snow",
		"default:permafrost_with_moss",
		"default:permafrost_with_stones",
		"default:snowblock",
		"default:snow",
		"default:dirt_with_coniferous_litter",
	},
	grassland = {
		"livingfloatlands:coldsteppe_litter",
		"default:dirt_with_grass",
		"default:dry_dirt_with_dry_grass",
		"default:dirt_with_dry_grass",
		"default:dry_dirt",
	},
	forest = {
		"livingfloatlands:giantforest_litter",
		"livingfloatlands:giantforest_litter_walkway",
		"livingfloatlands:giantforest_litter_with_moss",
		"default:dirt_with_coniferous_litter",
		"default:dirt_with_grass",
	},
	jungle = {
		"livingfloatlands:paleojungle_litter",
		"livingfloatlands:paleojungle_littler_dirt",
		"livingfloatlands:paleojungle_littler_leaves",
		"livingfloatlands:giantforest_litter",
		"default:dirt_with_rainforest_litter",
	},
	desert = {
		"livingfloatlands:paleodesert_litter",
		"default:desert_sand",
		"default:sand",
		"default:silver_sand",
		"default:dry_dirt_with_dry_grass",
		"default:desert_sandstone",
	},
	coast = {
		"livingfloatlands:paleojungle_litter",
		"livingfloatlands:giantforest_paleoredwood_trunk",
		"default:dirt_with_rainforest_litter",
		"default:sand",
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
	})
	add_nodes(livingfloatlands.habitats.forest, {
		"ethereal:grove_dirt",
		"ethereal:bamboo_dirt",
	})
	add_nodes(livingfloatlands.habitats.jungle, {
		"ethereal:jungle_dirt",
		"ethereal:grove_dirt",
	})
	add_nodes(livingfloatlands.habitats.desert, {
		"ethereal:fiery_dirt",
		"ethereal:dry_dirt",
	})
	add_nodes(livingfloatlands.habitats.coast, {
		"ethereal:grove_dirt",
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

-- Queue spawn rules; register after all nodes exist.
livingfloatlands._spawns = {}

function livingfloatlands.spawn_mob(def)
	livingfloatlands._spawns[#livingfloatlands._spawns + 1] = def
end

-- Grass/plants sit on dirt, so neighbors must include flora or grassy biomes never spawn.
local spawn_neighbors = {
	"air",
	"group:flora",
	"group:grass",
	"group:dry_grass",
	"group:flower",
	"group:plant",
}

minetest.register_on_mods_loaded(function()
	if mobs.custom_spawn_livingfloatlands then
		return
	end

	for _, def in ipairs(livingfloatlands._spawns) do
		local nodes = filter_nodes(def.nodes or {})
		if #nodes > 0 then
			def.nodes = nodes
			def.neighbors = spawn_neighbors
			def.min_light = 0
			def.max_light = 15
			def.interval = def.interval or 40
			def.chance = def.chance or 5000
			def.active_object_count = def.active_object_count or 2
			def.min_height = def.min_height or 1
			def.max_height = def.max_height or 31000
			mobs:spawn(def)
		end
	end
end)

-- Nodes/biomes first so ground exists, then animals.
dofile(path .. "coldsteppe.lua")
dofile(path .. "paleodesert.lua")
dofile(path .. "giantforest.lua")
dofile(path .. "coldgiantforest.lua")
dofile(path .. "paleojungle.lua")

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
