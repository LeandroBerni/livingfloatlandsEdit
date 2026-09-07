local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:stegosaurus", {
	type = "animal",
	passive = false,
        attack_type = "dogfight",
	attack_animals = false,
	group_attack = true,
        attack_monsters = true,
	reach = 5,
        damage = 16,
	hp_min = 250,
	hp_max = 350,
	armor = 100,
	collisionbox = {-1.0, -0.01, -1.0, 1.0, 2.5, 1.0},
	visual = "mesh",
	mesh = "Stegosaurus.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"texturestegosaurus.png"},
		{"texturestegosaurus2.png"},
	},
	sounds = {
		random = "livingfloatlands_stegosaurus",
		attack = "default_punch.ogg",
                distance = 16,
	},
	makes_footstep_sound = true,
	walk_velocity = 2,
	run_velocity = 3,
        walk_chance = 20,
	runaway = false,
        knock_back = false,
	jump = false,
        jump_height = 6,
        stay_near = {{"livingfloatlands:paleojungle_litter_leaves", "livingfloatlands:paleojungle_smallpalm", "livingfloatlands:giantforest_grass3", "livingfloatlands:paleojungle_ferngrass", "default:junglegrass", "default:fern_1", "default:grass_1"}, 5},
	stepheight = 2,
	drops = {
		{name = "livingfloatlands:ornithischiaraw", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
        pathfinding = false,
	animation = {
		speed_normal = 25,
		stand_start = 0,
		stand_end = 100,
		walk_speed = 50,
		walk_start = 100,
		walk_end = 200,
		punch_speed = 100,
		punch_start = 250,
		punch_end = 350,
		die_start = 250,
		die_end = 350,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

	follow = {
		"default:grass_3", "default:dry_grass_3", "ethereal:dry_shrub", "farming:lettuce", "farming:seed_wheat", "default:junglegrass", "livingfloatlands:paleojungle_clubmoss_fruit", "livingfloatlands:giantforest_oaknut", "livingfloatlands:paleojungle_ferngrass"
	},
	view_range = 15,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 0, 5, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:stegosaurus",
	nodes = livingfloatlands.habitats.jungle,
	chance = 18000,
	active_object_count = 1,
	day_toggle = true,
})

mobs:register_egg("livingfloatlands:stegosaurus", ("Stegosaurus"), "astegosaurus.png")
