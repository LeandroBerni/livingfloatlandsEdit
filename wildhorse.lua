local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:wildhorse", {
	type = "animal",
	passive = true,
        attack_type = "dogfight",
	attack_animals = true,
	reach = 2,
        damage = 20,
	hp_min = 50,
	hp_max = 70,
	armor = 100,
	collisionbox = {-0.5, -0.01, -0.5, 0.7, 1.2, 0.7},
	visual = "mesh",
	mesh = "Wildhorse.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"texturewildhorse.png"},
	},
	sounds = {
		random = "livingfloatlands_wildhorse",
		damage = "livingfloatlands_wildhorse",
	},
	makes_footstep_sound = true,
	walk_velocity = 2,
	run_velocity = 4,
        walk_chance = 20,
	runaway = true,
        runaway_from = {"animalworld:bear", "animalworld:crocodile", "animalworld:tiger", "animalworld:spider", "animalworld:spidermale", "animalworld:shark", "animalworld:hyena", "animalworld:kobra", "animalworld:monitor", "animalworld:snowleopard", "animalworld:volverine", "livingfloatlands:deinotherium", "livingfloatlands:carnotaurus", "livingfloatlands:lycaenops", "livingfloatlands:smilodon", "livingfloatlands:tyrannosaurus", "livingfloatlands:velociraptor"},
	jump = true,
        jump_height = 6,
	stepheight = 2,
        stay_near = {{"livingfloatlands:coldsteppe_shrub", "livingfloatlands:coldsteppe_grass", "livingfloatlands:coldsteppe_grass2", "livingfloatlands:coldsteppe_grass3", "livingfloatlands:coldsteppe_grass4", "livingdesert:coldsteppe_grass1", "livingdesert:coldsteppe_grass2", "livingdesert:coldsteppe_grass3", "default:grass_1", "default:dry_grass_1", "default:dry_shrub"}, 5},
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
	animation = {
		speed_normal = 50,
		stand_start = 0,
		stand_end = 100,
		walk_speed = 75,
		walk_start = 100,
		walk_end = 200,
		run_speed = 100,
		run_start = 200,
		run_end = 300,
		die_start = 100,
		die_end = 200,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

	follow = {
		"default:grass_3", "default:dry_grass_3", "ethereal:dry_shrub", "farming:lettuce", "farming:seed_wheat", "default:junglegrass", "livingfloatlands:coldsteppe_pine3_sapling", "livingfloatlands:coldsteppe_pine2_sapling", "livingfloatlands:coldsteppe_pine_sapling", "livingfloatlands:coldsteppe_bulbous_chervil_root", "livingdesert:coldsteppe_grass1"
	},
	view_range = 15,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 0, 15, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:wildhorse",
	nodes = livingfloatlands.habitats.grassland,
	chance = 3500,
	active_object_count = 2,
	day_toggle = true,
})

mobs:register_egg("livingfloatlands:wildhorse", S("Wild Horse"), "awildhorse.png")
