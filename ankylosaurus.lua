local S = minetest.get_translator("livingfloatlands")
mobs:register_mob("livingfloatlands:ankylosaurus", {
	type = "animal",
	passive = false,
        attack_type = "dogfight",
	group_attack = true,
        attack_monsters = true,
	reach = 5,
        damage = 10,
	hp_min = 650,
	hp_max = 850,
	armor = 100,
	collisionbox = {-1.5, -0.01, -1.0, 1.1, 1.5, 1.0},
	visual = "mesh",
	mesh = "Ankylosaurus.b3d",
	visual_size = {x = 1.0, y = 1.0},
	textures = {
		{"textureankylosaurus.png"},
		{"textureankylosaurus2.png"},
	},
	sounds = {
		random = "livingfloatlands_ankylosaurus",
		attack = "default_punch.ogg",
                distance = 15,
	},
	makes_footstep_sound = true,
	walk_velocity = 1,
	run_velocity = 2,
        walk_chance = 20,
	runaway = false,
        knock_back = false,
	jump = false,
        jump_height = 6,
	stepheight = 2,
        stay_near = {{"livingfloatlands:paleodesert_fern", "livingfloatlands:puzzlegrass", "default:dry_shrub", "default:cactus", "default:dry_grass_1"}, 6},
	drops = {
		{name = "livingfloatlands:ornithischiaraw", chance = 1, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	fear_height = 3,
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

follow = {"default:apple", "default:dry_dirt_with_dry_grass", "farming:seed_wheat", "default:junglegrass", "farming:seed_oat", "livingfloatlands:paleodesert_joshua_sapling", "livingfloatlands:paleodesert_fern"},
	view_range = 10,

	on_rightclick = function(self, clicker)

		-- feed or tame
		if mobs:feed_tame(self, clicker, 4, false, true) then return end
		if mobs:protect(self, clicker) then return end
		if mobs:capture_mob(self, clicker, 0, 0, 15, false, nil) then return end
	end,
})


livingfloatlands.spawn_mob({
	name = "livingfloatlands:ankylosaurus",
	nodes = livingfloatlands.habitats.desert,
	chance = 4500,
	active_object_count = 2,
	day_toggle = true,
})

mobs:register_egg("livingfloatlands:ankylosaurus", ("Ankylosaurus"), "aankylosaurus.png")

-- raw Ornithischia
minetest.register_craftitem(":livingfloatlands:ornithischiaraw", {
	description = S("Raw Ornithischia Meat"),
	inventory_image = "livingfloatlands_ornithischiaraw.png",
	on_use = minetest.item_eat(3),
	groups = {food_meat_raw = 1, flammable = 2},
})

-- cooked Ornithischia
minetest.register_craftitem(":livingfloatlands:ornithischiacooked", {
	description = S("Cooked Ornithischia Meat"),
	inventory_image = "livingfloatlands_ornithischiacooked.png",
	on_use = minetest.item_eat(5),
	groups = {food_meat = 1, flammable = 2},
})

minetest.register_craft({
	type = "cooking",
	output = "livingfloatlands:ornithischiacooked",
	recipe = "livingfloatlands:ornithischiaraw",
	cooktime = 30,
})

