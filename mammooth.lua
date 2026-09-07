local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:mammooth", {
	type = "animal",
	passive = false,
        attack_type = "dogfight",
	attack_animals = false,
	attack_monsters = true,
	group_attack = true,
	reach = 3,
        damage = 16,
	hp_min = 100,
	hp_max = 180,
	armor = 100,
	collisionbox = {-0.8, -0.01, -0.8, 0.8, 1.5, 0.8},
	visual = "mesh",
	mesh = "Mammooth.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"texturemammooth.png"},
		{"texturemammooth2.png"},
		{"texturemammooth3.png"},
	},
	sounds = {
		random = "livingfloatlands_mammooth",
		attack = "livingfloatlands_mammooth",
                distance = 15,
	},
	makes_footstep_sound = true,
	walk_velocity = 2,
	run_velocity = 4,
	runaway = false,
        knock_back = false,
	jump = false,
        jump_height = 6,
	stepheight = 2,
        stay_near = {{"livingfloatlands:coldsteppe_shrub", "livingfloatlands:coldsteppe_grass", "livingfloatlands:coldsteppe_grass2", "livingfloatlands:coldsteppe_grass3", "livingfloatlands:coldsteppe_grass4", "default:grass_1", "default:dry_grass_1", "default:fern_1", "default:snow"}, 5},
	drops = {
		{name = "livingfloatlands:largemammalraw", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
        pathfinding = false,
	animation = {
		speed_normal = 70,
		stand_start = 0,
		stand_end = 100,
		walk_start = 100,
		walk_end = 200,
		punch_start = 250,
		punch_end = 350,
		die_start = 250,
		die_end = 350,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

	follow = {
		"ethereal:banana_single", "farming:corn_cob", "farming:cabbage",
		"default:apple", "farming:cabbage", "farming:carrot", "farming:cucumber", "farming:grapes", "farming:pineapple", "ethereal:orange", "ethereal:coconut", "ethereal:coconut_slice", "livingfloatlands:coldsteppe_pine3_sapling", "livingfloatlands:coldsteppe_pine2_sapling", "livingfloatlands:coldsteppe_pine_sapling", "livingfloatlands:coldsteppe_bulbous_chervil_root"
	},
	view_range = 12,
	replace_rate = 10,
	replace_what = {"farming:soil", "farming:soil_wet"},
	replace_with = "default:dirt",
	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 0, 20, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:mammooth",
	nodes = livingfloatlands.habitats.cold,
	chance = 18000,
	active_object_count = 1,
	day_toggle = true,
})

mobs:register_egg("livingfloatlands:mammooth", S("Mammooth"), "amammooth.png")
