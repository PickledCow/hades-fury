local lava_synthesis = {
    type = "recipe",
    name = "hades-fury-lava-synthesis",
    icon = "__hades-fury__/graphics/lava-synthesis.png",
    enabled = false,
    category = "metallurgy",
    subgroup = "vulcanus-processes",
    order = "a[melting]-c[lava]",
    energy_required = 6.4,
    allow_productivity = false,
    allow_productivity_message = {"item-limitation.hades-fury-forbid-lava-productivity"},
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 100 },
        { type = "fluid", name = "molten-copper", amount = 100 },
        { type = "item", name = "stone", amount = 10}
    },
    results = { { type = "fluid", name = "lava", amount = 50 } }
}

local lava_turret = {
    type = "recipe",
    name = "hades-fury-lava-turret",
    icon = "__hades-fury__/graphics/lava-turret.png",
    enabled = false,
    category = "metallurgy",
    subgroup = "defensive-structure",
    order = "b[turret]-c[lava-turret]",
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "molten-iron", amount = 1000 },
        { type = "item", name = "big-mining-drill", amount = 1},
        { type = "item", name = "pump", amount = 1},
        { type = "item", name = "tungsten-plate", amount = 50},
        { type = "item", name = "pipe", amount = 100},
    },
    results = { { type = "item", name = "hades-fury-lava-turret", amount = 1 } }
}

local lava_grenade = {
    name = "hades-fury-lava-grenade",
    type = "recipe",
    enabled = false,
    category = "metallurgy",
    subgroup = "gun",
    energy_required = 20,
    ingredients = {
        { type = "fluid", name = "lava", amount = 200 },
        { type = "item", name = "poison-capsule", amount = 1 },
        { type = "item", name = "explosives", amount = 10 },
        { type = "item", name = "tungsten-plate", amount = 1},
    },
    results = { { type = "item", name = "hades-fury-lava-grenade", amount = 1 } }

}
data:extend({lava_synthesis, lava_turret, lava_grenade})
