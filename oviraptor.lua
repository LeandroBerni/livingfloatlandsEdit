local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:oviraptor", {
stepheight = 2,
	type = "animal",
	passive = false,
        attack_type = "dogfight",
	attack_animals = false,
        attack_monsters = true,
	reach = 2,
        damage = 6,
	hp_min = 30,
	hp_max = 60,
	armor = 100,
	collisionbox = {-0.7, -0.01, -0.5, 0.7, 0.9, 0.5},
	visual = "mesh",
	mesh = "Oviraptor.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"textureoviraptor.png"},
	},
	sounds = {
		random = "livingfloatlands_oviraptor2",
		attack = "livingfloatlands_oviraptor",
                distance = 13,
	},
	makes_footstep_sound = true,
	walk_velocity = 2,
	run_velocity = 4,
        walk_chance = 20,
	runaway = true,
        runaway_from = {"animalworld:bear", "animalworld:crocodile", "animalworld:tiger", "animalworld:spider", "animalworld:spidermale", "animalworld:shark", "animalworld:hyena", "animalworld:kobra", "animalworld:monitor", "animalworld:snowleopard", "animalworld:volverine", "livingfloatlands:deinotherium", "livingfloatlands:carnotaurus", "livingfloatlands:lycaenops", "livingfloatlands:smilodon", "livingfloatlands:tyrannosaurus", "livingfloatlands:velociraptor"},
	jump = true,
        jump_height = 8,
        stay_near = {{"livingfloatlands:paleodesert_fern", "livingfloatlands:puzzlegrass", "default:dry_shrub", "default:cactus", "default:dry_grass_1"}, 5},
	drops = {
		{name = "livingfloatlands:theropodraw", chance = 1, min = 1, max = 1},
		{name = "livingfloatlands:dinosaur_feather", chance = 1, min = 0, max = 2},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
	animation = {
		speed_normal = 30,
		stand_start = 250,
		stand_end = 350,
		walk_speed = 100,
		walk_start = 0,
		walk_end = 100,
		punch_speed = 75,
		punch_start = 100,
		punch_end = 200,
		die_start = 100,
		die_end = 200,
		die_speed = 50,
		die_loop = false,
		die_rotate = true,
	},

	follow = {
		"ethereal:fish_raw", "animalworld:rawfish", "mobs_fish:tropical", "mobs:meat_raw", "animalworld:rabbit_raw", "animalworld:pork_raw", "water_life:meat_raw", "animalworld:chicken_raw", "default:apple", "farming:potato", "farming:melon_slice", "farming:cucumber", "farming:cabbage", "farming:lettuce", "farming:bread", "livingfloatlands:ornithischiaraw", "livingfloatlands:sauropodraw", "livingfloatlands:theropodraw", "livingfloatlands:paleodesert_joshua_sapling", "livingfloatlands:paleodesert_fern"
	},
	view_range = 15,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 20, 0, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:oviraptor",
	nodes = livingfloatlands.habitats.desert,
	chance = 4000,
	active_object_count = 2,
	day_toggle = true,
})

mobs:register_egg("livingfloatlands:oviraptor", ("Oviraptor"), "aoviraptor.png")
