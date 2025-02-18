-- -- technology.lua

data:extend({
    {
        type = "technology",
        name = "hades-fury-hades-fury",
        prerequisites = { "military-4", "refined-flammables-6", "stronger-explosives-6", "metallurgic-science-pack" },

        icons = {
            {
                icon = "__hades-fury__/graphics/technology.png",
                icon_size = 256
            }
        },
        
        unit = {
            count = 5000,
            ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"military-science-pack", 1}, {"chemical-science-pack", 1}, {"utility-science-pack", 1}, {"space-science-pack", 1}, {"metallurgic-science-pack", 1}},
            time = 60
        },
        effects = {
            {type = "unlock-recipe", recipe = "hades-fury-lava-synthesis"},
            {type = "unlock-recipe", recipe = "hades-fury-lava-grenade"},
            {type = "unlock-recipe", recipe = "hades-fury-lava-turret"}
        }
    },

    
})
