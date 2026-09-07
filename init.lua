-- Living Floatlands: prehistoric biomes and animals for Luanti / Minetest.
-- Biomes are registered as extra climates and never clear or overwrite vanilla ones.

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

-- Spawn on both this mod's ground and matching vanilla / ethereal nodes.
livingfloatlands.habitats = {
	cold = {
		"livingfloatlands:coldsteppe_litter",
		"default:dirt_with_snow",
		"default:permafrost_with_moss",
		"default:permafrost_with_stones",
		"default:snowblock",
		"default:dirt_with_coniferous_litter",
	},
	grassland = {
		"livingfloatlands:coldsteppe_litter",
		"livingfloatlands:giantforest_litter",
		"default:dirt_with_grass",
		"default:dry_dirt_with_dry_grass",
		"default:dirt_with_dry_grass",
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
	},
	desert = {
		"livingfloatlands:paleodesert_litter",
		"default:desert_sand",
		"default:sand",
		"default:silver_sand",
		"default:dry_dirt_with_dry_grass",
	},
	coast = {
		"livingfloatlands:paleojungle_litter",
		"livingfloatlands:giantforest_litter",
		"livingfloatlands:giantforest_paleoredwood_trunk",
		"default:dirt_with_rainforest_litter",
		"default:dirt_with_grass",
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

-- Sparse, low-lag defaults. Higher chance = rarer spawn.
function livingfloatlands.spawn_mob(def)
	if mobs.custom_spawn_livingfloatlands then
		return
	end
	def.min_light = def.min_light or 8
	def.interval = def.interval or 90
	def.chance = def.chance or 15000
	def.active_object_count = def.active_object_count or 1
	def.min_height = def.min_height or 1
	def.max_height = def.max_height or 31000
	mobs:spawn(def)
end

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
dofile(path .. "coldsteppe.lua")
dofile(path .. "paleodesert.lua")
dofile(path .. "giantforest.lua")
dofile(path .. "coldgiantforest.lua")
dofile(path .. "paleojungle.lua")
dofile(path .. "dye.lua")
dofile(path .. "crafting.lua")
dofile(path .. "leafdecay.lua")
dofile(path .. "hunger.lua")

-- Load custom spawning
if mobs.custom_spawn_livingfloatlands then
	dofile(path .. "spawn.lua")
end

print(S("[MOD] Living Floatlands loaded"))
