-- -- items.lua

local lava_turret = table.deepcopy(data.raw["item"]["flamethrower-turret"])
lava_turret.name = "hades-fury-lava-turret"
lava_turret.place_result = "hades-fury-lava-turret"
lava_turret.icon = "__hades-fury__/graphics/lava-turret.png"

local lava_grenade = table.deepcopy(data.raw["capsule"]["grenade"])
lava_grenade.name = "hades-fury-lava-grenade"
lava_grenade.order = "ca[hades-fury-lava-grenade]"
lava_grenade.icon = "__hades-fury__/graphics/lava-grenade-item.png"
lava_grenade.capsule_action = {
    type = "throw",
    attack_parameters = {
        activation_type = "throw",
        ammo_category = "grenade",
        cooldown = 36,
        projectile_creation_distance = 0.6,
        range = 25,
        type = "projectile",
        ammo_type = {
            target_type = "position",
            action = {
                lava_grenade.capsule_action.attack_parameters.ammo_type.action[2], -- Copy sound over
                {
                    type = "direct",
                    action_delivery = {
                        type = "projectile",
                        starting_speed = 0.3,
                        projectile = "hades-fury-lava-grenade"
                    }
                }
            }

        }

    }
}


data:extend({ lava_turret, lava_grenade})
