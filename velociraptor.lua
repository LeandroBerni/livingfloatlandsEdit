local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:velociraptor", {
stepheight = 2,
	type = "monster",
	passive = false,
        attack_type = "dogfight",
	attack_animals = true,
	reach = 2,
        damage = 9,
	hp_min = 60,
	hp_max = 80,
	armor = 100,
	collisionbox = {-0.7, -0.01, -0.4, 0.7, 0.7, 0.4},
	visual = "mesh",
	mesh = "Velociraptor.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"texturevelociraptor.png"},
	},
	sounds = {
		random = "livingfloatlands_velociraptor2",
		attack = "livingfloatlands_velociraptor",
	},
	makes_footstep_sound = true,
	walk_velocity = 3,
	run_velocity = 6,
        walk_chance = 20,
	runaway = false,
	jump = true,
        jump_height = 10,
        stay_near = {{"livingfloatlands:paleodesert_fern", "livingfloatlands:puzzlegrass", "default:dry_shrub", "default:cactus", "default:dry_grass_1"}, 6},
	drops = {
		{name = "livingfloatlands:theropodraw", chance = 1, min = 1, max = 1},
		{name = "livingfloatlands:dinosaur_feather", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
	animation = {
		speed_normal = 60,
		stand_start = 0,
		stand_end = 100,
		walk_speed = 100,
		walk_start = 100,
		walk_end = 200,
		run_speed = 200,
		run_start = 100,
		run_end = 200,
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
		"ethereal:fish_raw", "animalworld:rawfish", "mobs_fish:tropical",
		"mobs:meat_raw", "animalworld:rabbit_raw", "animalworld:pork_raw", "water_life:meat_raw", "animalworld:chicken_raw", "livingfloatlands:ornithischiaraw", "livingfloatlands:sauropodraw", "livingfloatlands:theropodraw", "mobs:meatblock_raw", "animalworld:chicken_raw", "livingfloatlands:ornithischiaraw", "livingfloatlands:largemammalraw", "livingfloatlands:theropodraw", "livingfloatlands:sauropodraw", "animalworld:raw_athropod", "animalworld:whalemeat_raw", "animalworld:rabbit_raw", "nativevillages:chicken_raw", "mobs:meat_raw", "animalworld:pork_raw", "people:mutton:raw"
	},
	view_range = 10,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 10, 0, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:velociraptor",
	nodes = livingfloatlands.habitats.desert,
	chance = 4000,
	active_object_count = 2,
})

mobs:register_egg("livingfloatlands:velociraptor", ("Velociraptor"), "avelociraptor.png")
