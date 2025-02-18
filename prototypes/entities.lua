-- ----

-- Look, I tried large demolishers and it was just too much even just visually
local custom_fissure = table.deepcopy(data.raw["delayed-active-trigger"]["medium-demolisher-fissure-explosion-delay"])
custom_fissure.name = "hades-fury-medium-demolisher-fissure-explosion-delay"
custom_fissure.delay = 20

local custom_particle =
    table.deepcopy(data.raw["delayed-active-trigger"]["medium-demolisher-fissure-explosion-particles-delay"])
custom_particle.name = "hades-fury-medium-demolisher-fissure-explosion-particles-delay"
custom_particle.delay = 30

-- The actual attack "flame"
local custom_eruption = table.deepcopy(data.raw["explosion"]["medium-demolisher-fissure"])
custom_eruption.name = "hades-fury-medium-demolisher-fissure"
custom_eruption.created_effect[1].action_delivery.delayed_trigger =
    "hades-fury-medium-demolisher-fissure-explosion-delay"
custom_eruption.created_effect[2].action_delivery.delayed_trigger =
    "hades-fury-medium-demolisher-fissure-explosion-particles-delay"
custom_eruption.created_effect[3] = nil -- Move this to the turret to give correct attribution and research bonuses

-- Copies small lava thing 
local custom_small_explosion = table.deepcopy(data.raw["explosion"]["small-demolisher-fissure-explosion"])
custom_small_explosion.name = "hades-fury-small-demolisher-fissure-explosion"
custom_small_explosion.render_layer = "object-under"
custom_small_explosion.animations[1].shift = {
    0,
    1
}
custom_small_explosion.animations[2].shift = {
    0,
    1
}
custom_small_explosion.animations[3].shift = {
    0,
    1
}
custom_small_explosion.animations[4].shift = {
    0,
    1
}

local custom_small_scorchmark = table.deepcopy(data.raw["corpse"]["small-demolisher-fissure-scorchmark"])
custom_small_scorchmark.name = "hades-fury-small-demolisher-fissure-scorchmark"
custom_small_scorchmark.animation.shift = { 0, 1 }

local custom_small_fissure = table.deepcopy(data.raw["delayed-active-trigger"]["small-demolisher-fissure-explosion-delay"])
custom_small_fissure.name = "hades-fury-small-demolisher-fissure-explosion-delay"
custom_small_fissure.delay = 10
custom_small_fissure.action[1].action_delivery.target_effects[1].entity_name = "hades-fury-small-demolisher-fissure-explosion"
custom_small_fissure.action[1].action_delivery.target_effects[2].entity_name = "hades-fury-small-demolisher-fissure-scorchmark"

local custom_small_particle =
    table.deepcopy(data.raw["delayed-active-trigger"]["small-demolisher-fissure-explosion-particles-delay"])
    custom_small_particle.name = "hades-fury-small-demolisher-fissure-explosion-particles-delay"
    custom_small_particle.delay = 20
for i = 1, 6,1 do
    custom_small_particle.action[1].action_delivery.target_effects[i].offset_deviation = { {-0.25, -0.25 }, { 0.25, 0.25 } }
    custom_small_particle.action[1].action_delivery.target_effects[i].offsets = {{0, 2}}
end

local custom_small_eruption = table.deepcopy(data.raw["explosion"]["small-demolisher-fissure"])
custom_small_eruption.name = "hades-fury-small-demolisher-fissure"
custom_small_eruption.created_effect[1].action_delivery.delayed_trigger =
    "hades-fury-small-demolisher-fissure-explosion-delay"
custom_small_eruption.created_effect[2].action_delivery.delayed_trigger =
    "hades-fury-small-demolisher-fissure-explosion-particles-delay"
custom_small_eruption.created_effect[3] = nil -- Removes damage


local force = "not-friend"

if settings.startup["hades-fury-friendly-fire"].value then
    force = "all"
end

-- turret graphics replace with drill
local drill_data = table.deepcopy(data.raw["mining-drill"]["big-mining-drill"])

local lava_turret = table.deepcopy(data.raw["fluid-turret"]["flamethrower-turret"])
lava_turret.name = "hades-fury-lava-turret"
lava_turret.surface_conditions = {
    {property = "gravity", min = 1}
}
lava_turret.icon = "__hades-fury__/graphics/lava-turret.png"
lava_turret.attack_parameters.ammo_type =
    table.deepcopy(data.raw["segmented-unit"]["medium-demolisher"]).revenge_attack_parameters.ammo_type
lava_turret.attack_parameters.range = 60
lava_turret.prepare_range = 75
-- lava_turret.prepared_speed = 100
-- lava_turret.prepared_speed_secondary = 100
lava_turret.attack_parameters.min_range = 10
lava_turret.attack_parameters.turn_range = 1
lava_turret.attack_parameters.fluids = {{type = "lava"}}
lava_turret.attack_parameters.fluid_consumption = 1
lava_turret.attack_parameters.cooldown = 36
lava_turret.rotation_speed = 100
lava_turret.preparing_speed = 100
-- lava_turret.shoot_in_prepare_state = true -- Instant reaction
-- Remove extra eruptions
lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[1] =
    lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[3]
lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[2] = nil
lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[3] = nil

lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[1].probability = 1
lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[1].entity_name =
    "hades-fury-medium-demolisher-fissure"
lava_turret.attack_parameters.ammo_type.action.action_delivery.target_effects[1].offset_deviation = {
    {-0.5, -0.5},
    {0.5, 0.5}
}
----
lava_turret.attack_parameters.ammo_type.action.action_delivery = {
    -- Targed effects
    lava_turret.attack_parameters.ammo_type.action.action_delivery,
    {
        -- source effects
        type = "instant",
        source_effects = {
            {
                type = "create-entity",
                entity_name = "hades-fury-small-demolisher-fissure"
            }
        },
        -- Damage
        target_effects = {
            {
                type = "nested-result",
                action = {
                    type = "area",
                    radius = 1.5,
                    force = force,
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "damage",
                                damage = {
                                    type = "explosion",
                                    amount = 350
                                }
                            },
                            {
                                type = "damage",
                                damage = {
                                    type = "fire",
                                    amount = 250
                                }
                            }
                        }
                    }
                }
            },
            {
                type = "nested-result",
                action = {
                    type = "area",
                    radius = 2.5,
                    force = force,
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            {
                                type = "damage",
                                damage = {
                                    type = "explosion",
                                    amount = 100
                                }
                            },
                            {
                                type = "damage",
                                damage = {
                                    type = "fire",
                                    amount = 75
                                }
                            }
                        }
                    }
                }
            },
            {
                -- Never deal friendly fire
                type = "nested-result",
                action = {
                    type = "area",
                    radius = 3,
                    force = "not-friend",
                    action_delivery = {
                        type = "instant",
                        target_effects = {
                            show_in_tooltip = true,
                            sticker = "fire-sticker",
                            type = "create-sticker"
                        }
                    }
                }
            }
        }
    }
}

-- Sounds WIP
lava_turret.attack_parameters.cyclic_sound = {
    middle_sound = {
        {
            filename = "__base__/sound/burner-mining-drill-1.ogg",
            volume = 0.75
        },
        {
            filename = "__base__/sound/burner-mining-drill-2.ogg",
            volume = 0.75
        }
    }
}

-- lava_turret.attack_parameters.ammo_type.action.force = "not-friend" -- Disable frinedly fire

lava_turret.attack_parameters.lead_target_for_projectile_delay = 0 -- Currently damage is instant so no leading

lava_turret.circuit_connector = drill_data.circuit_connector
lava_turret.close_sound = drill_data.close_sound
lava_turret.collision_box = drill_data.collision_box
lava_turret.selection_box = drill_data.selection_box
lava_turret.corpse = "big-mining-drill-remnants"
lava_turret.drawing_box_vertical_extension = 1
lava_turret.fluid_box = drill_data.input_fluid_box
lava_turret.fluid_box.filter = "lava"

lava_turret.minable = {
    mining_time = 0.5,
    result = "hades-fury-lava-turret"
}

-- Set graphics
--- Base and shadow
lava_turret.graphics_set = {
    base_visualisation = {
        animation = drill_data.graphics_set.animation
    }
}
local scorchmark_static = {
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-scorchmark.png",
    height = 164,
    line_length = 1,
    priority = "high",
    scale = 0.5,
    shift = {
    0,
    0.203125
    },
    width = 202
}

local scorchmark_anim = {
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-scorchmark.png",
    height = 164,
    line_length = 1,
    repeat_count = 72,
    priority = "high",
    scale = 0.5,
    shift = {
    0,
    0.203125
    },
    width = 202
}

local drill_static = {
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill.png",
    frame_count = 1,
    height = 226,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0,
        -0.734375
    },
    width = 168
}

local drill_anim = {
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill.png",
    frame_count = 1,
    repeat_count = 72,
    height = 226,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0,
        -0.734375
    },
    width = 168
}

local drill_shadow_static = {
    draw_as_shadow = true,
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-shadow.png",
    frame_count = 1,
    height = 120,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0.6875,
        0.09375
    },
    width = 272
}

local drill_shadow_anim = {
    draw_as_shadow = true,
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-shadow.png",
    frame_count = 1,
    repeat_count = 72,
    height = 120,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0.6875,
        0.09375
    },
    width = 272
}

local dust_anim = {
    
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-dust.png",
    frame_count = 24,
    repeat_count = 3,
    height = 190,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0.015625,
        -0.203125
    },
    width = 216
}

local dust_tint_anim = {
    
    filename = "__space-age__/graphics/entity/big-mining-drill/big-mining-drill-drill-dust-tint.png",
    frame_count = 24,
    repeat_count = 3,
    height = 252,
    line_length = 6,
    priority = "high",
    scale = 0.5,
    shift = {
        0,
        -0.671875
    },
    width = 230
}

local tint = {
    0.7, 0.8, 0.8
}

local idle_anim = {
    animation_speed = 0.5,
    east = {
        layers = {
            scorchmark_static,
            drill_static,
            drill_shadow_static,
            -- Steel Reel
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-still-reel.png",
                height = 38,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    1.3125
                },
                width = 284
            },
            -- Wheel
            {
                dice_y = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-wheels.png",
                frame_count = 1,
                height = 296,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.40625,
                    -0.09375
                },
                width = 208
            },
            -- Output
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-output.png",
                frame_count = 1,
                height = 110,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.046875,
                    -0.078125
                },
                width = 84
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections.png",
                height = 74,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.34375,
                    -2.609375
                },
                width = 256
            },
            -- Support
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-support.png",
                frame_count = 1,
                height = 306,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.5,
                    -0.625
                },
                width = 208
            },
            -- Support shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-support-shadow.png",
                frame_count = 1,
                height = 288,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.84375,
                    0.046875
                },
                width = 248
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-still-front.png",
                height = 352,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    1,
                    -0.328125
                },
                width = 188,
                tint = tint
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections-front.png",
                height = 318,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.078125,
                    0.25
                },
                width = 334
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections-shadow.png",
                height = 352,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.859375,
                    0
                },
                width = 434
            },
            -- Nozzle
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top-nozzle.png",
                frame_count = 1,
                height = 68,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    1.203125,
                    -2.109375
                },
                width = 118
            },
            -- Top
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top.png",
                frame_count = 1,
                height = 160,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.265625,
                    -1.75
                },
                width = 212,
                tint = tint
            },
            -- Top shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top-shadow.png",
                frame_count = 1,
                height = 104,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.375,
                    0.28125
                },
                width = 250
            }
        }
    },
    north = {
        layers = {
            scorchmark_static,
            drill_static,
            drill_shadow_static,
            -- Steel Reel
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-still.png",
                height = 324,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.375
                },
                width = 324
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-wheels.png",
                frame_count = 1,
                height = 150,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.34375
                },
                width = 298
            },
            -- Output
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-output.png",
                frame_count = 1,
                height = 88,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.0625,
                    -2.078125
                },
                width = 128
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections.png",
                height = 164,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.03125,
                    -1.1875
                },
                width = 338
            },
            -- Support
            {
                
                dice_x = 3,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-support.png",
                frame_count = 1,
                height = 190,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    -0.65625
                },
                width = 290
            },
            -- Support shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-support-shadow.png",
                frame_count = 1,
                height = 138,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.6875,
                    -0.171875
                },
                width = 380
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-still-front.png",
                height = 302,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.015625
                },
                width = 320,
                tint = tint
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections-front.png",
                height = 274,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.046875,
                    0.59375
                },
                width = 340
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections-shadow.png",
                height = 284,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.484375,
                    0.515625
                },
                width = 382
            },
            -- Nozzle
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top-nozzle.png",
                frame_count = 1,
                height = 142,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.5625,
                    -2.296875
                },
                width = 40
            },
            -- Top
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top.png",
                frame_count = 1,
                height = 176,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    -1.921875
                },
                width = 150,
                tint = tint
            },
            -- Top shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top-shadow.png",
                height = 138,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.25,
                    0.046875
                },
                width = 216
            }
        }
    },
    south = {
        layers = {
            scorchmark_static,
            drill_static,
            drill_shadow_static,
            -- Steel Reel
            {
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-still.png",
                height = 294,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.15625
                },
                width = 324
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-wheels.png",
                frame_count = 1,
                height = 150,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.25
                },
                width = 300
            },
            -- Output
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-output.png",
                frame_count = 1,
                height = 78,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    2.03125
                },
                width = 134
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections.png",
                height = 90,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    -2.0625
                },
                width = 326
            },
            -- Support
            {
                
                dice_x = 3,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-support.png",
                frame_count = 1,
                height = 190,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.640625
                },
                width = 294
            },
            -- Support shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-support-shadow.png",
                frame_count = 1,
                height = 138,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.6875,
                    -0.171875
                },
                width = 380
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-still-front.png",
                height = 176,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.96875
                },
                width = 322,
                tint = tint
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections-front.png",
                height = 196,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    0.09375
                },
                width = 338
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections-shadow.png",
                height = 310,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.5625,
                    0.078125
                },
                width = 390
            },
            -- Nozzle
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top-nozzle.png",
                frame_count = 1,
                 height = 192,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.578125,
                    -1.171875
                },
                width = 40
            },
            -- Top
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top.png",
                frame_count = 1,
                height = 174,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.03125,
                    -1.640625
                },
                width = 152,
                tint = tint
            },
            -- Top shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top-shadow.png",
                frame_count = 1,
                height = 140,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.109375,
                    0.46875
                },
                width = 206
            }
        }
    },
    west = {
        layers = {
            scorchmark_static,
            drill_static,
            drill_shadow_static,
            -- Steel Reel
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-still-reel.png",
                height = 40,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    1.296875
                },
                width = 284
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_y = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-wheels.png",
                frame_count = 1,
                height = 296,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.40625,
                    -0.09375
                },
                width = 208
            },
            -- Output
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-output.png",
                frame_count = 1,
                height = 108,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -2.046875,
                    -0.078125
                },
                width = 86
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections.png",
                height = 74,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.359375,
                    -2.609375
                },
                width = 256
            },
            -- Support
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-support.png",
                frame_count = 1,
                height = 306,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.328125,
                    -0.625
                },
                width = 186
            },
            -- Support shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-support-shadow.png",
                frame_count = 1,
                height = 288,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.53125,
                    0.046875
                },
                width = 312
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-still-front.png",
                height = 352,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -1,
                    -0.328125
                },
                width = 188,
                tint = tint
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections-front.png",
                height = 318,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.0625,
                    0.25
                },
                width = 332
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections-shadow.png",
                height = 352,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.65625,
                    0
                },
                width = 298
            },
            -- Nozzle
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top-nozzle.png",
                frame_count = 1,
                height = 68,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -1.1875,
                    -2.109375
                },
                width = 118
            },
            -- Top
            {
                
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top.png",
                frame_count = 1,
                height = 158,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.265625,
                    -1.75
                },
                width = 214,
                tint = tint
            },
            -- Top shadow
            {
                
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top-shadow.png",
                frame_count = 1,
                height = 106,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.0625,
                    0.28125
                },
                width = 238
            }
        }
    }
}

-- Currently the firing animation is broken because I'm stupid

local drilling_anim = {
    animation_speed = 0.5,
    east = {
        layers = {
            scorchmark_anim,
            drill_anim,
            drill_shadow_anim,
            dust_anim,
            dust_tint_anim,
            -- Steel Reel
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-still-reel.png",
                height = 38,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    1.3125
                },
                width = 284
            },
            -- Wheel
            {
                dice_y = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-wheels.png",
                frame_count = 3,
                repeat_count = 24,
                height = 296,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.40625,
                    -0.09375
                },
                width = 208
            },
            -- Output FRAME SKIP, used to be 5
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-output.png",
                frame_count = 4,
                repeat_count = 18,
                height = 110,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.046875,
                    -0.078125
                },
                width = 84
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections.png",
                height = 74,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.34375,
                    -2.609375
                },
                width = 256
            },
            -- Support
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-support.png",
                frame_count = 6,
                repeat_count = 12,
                height = 306,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.5,
                    -0.625
                },
                width = 208
            },
            -- Support shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-support-shadow.png",
                frame_count = 1,
                height = 288,
                line_length = 1,
                priority = "high",
                repeat_count = 72,
                scale = 0.5,
                shift = {
                    0.84375,
                    0.046875
                },
                width = 248
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-still-front.png",
                height = 352,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    1,
                    -0.328125
                },
                width = 188
            },
            -- Output Particles 
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-output-particles.png",
                frame_count = 24,
                repeat_count = 3,
                height = 152,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    1.84375,
                    -1
                },
                width = 84
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections-front.png",
                height = 318,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.078125,
                    0.25
                },
                width = 334
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-pipe-connections-shadow.png",
                height = 352,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.859375,
                    0
                },
                width = 434
            },
            -- Nozzle FRAME SKIP, used to be 19
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top-nozzle.png",
                frame_count = 18,
                repeat_count = 4,
                height = 68,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    1.203125,
                    -2.109375
                },
                width = 118
            },
            -- Top
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top.png",
                frame_count = 18,
                repeat_count = 4,
                height = 160,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.265625,
                    -1.75
                },
                width = 212
            },
            -- Top shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/East/big-mining-drill-E-top-shadow.png",
                frame_count = 18,
                repeat_count = 4,
                height = 104,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.375,
                    0.28125
                },
                width = 250
            }
        }
    },
    north = {
        layers = {
            scorchmark_anim,
            drill_anim,
            drill_shadow_anim,
            dust_anim,
            dust_tint_anim,
            -- Steel Reel
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-still.png",
                height = 324,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.375
                },
                width = 324
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-wheels.png",
                frame_count = 3,
                repeat_count = 24,
                height = 150,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.34375
                },
                width = 298
            },
            -- Output should be 5 but is 4
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-output.png",
                frame_count = 4,
                repeat_count = 18,
                height = 88,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.0625,
                    -2.078125
                },
                width = 128
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections.png",
                height = 164,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.03125,
                    -1.1875
                },
                width = 338
            },
            -- Support
            {
                animation_speed = 0.5,
                dice_x = 3,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-support.png",
                frame_count = 6,
                repeat_count = 12,
                height = 190,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    -0.65625
                },
                width = 290
            },
            -- Support shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-support-shadow.png",
                frame_count = 1,
                height = 138,
                line_length = 1,
                priority = "high",
                repeat_count = 72,
                scale = 0.5,
                shift = {
                    0.6875,
                    -0.171875
                },
                width = 380
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-still-front.png",
                height = 302,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.015625
                },
                width = 320
            },
            -- Output Particles 
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-output-particles.png",
                frame_count = 24,
                repeat_count = 3,
                height = 82,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.4375,
                    -2.359375
                },
                width = 94
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections-front.png",
                height = 274,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.046875,
                    0.59375
                },
                width = 340
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-pipe-connections-shadow.png",
                height = 284,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.484375,
                    0.515625
                },
                width = 382
            },
            -- Nozzle 19 but 18
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top-nozzle.png",
                frame_count = 18,
                repeat_count = 4,
                height = 142,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.5625,
                    -2.296875
                },
                width = 40
            },
            -- Top
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top.png",
                frame_count = 18,
                repeat_count = 4,
                height = 176,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    -1.921875
                },
                width = 150
            },
            -- Top shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/North/big-mining-drill-N-top-shadow.png",
                frame_count = 18,
                repeat_count = 4,
                height = 138,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.25,
                    0.046875
                },
                width = 216
            }
        }
    },
    south = {
        layers = {
            scorchmark_anim,
            drill_anim,
            drill_shadow_anim,
            dust_anim,
            dust_tint_anim,
            -- Steel Reel
            {
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-still.png",
                height = 294,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.15625
                },
                width = 324
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_x = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-wheels.png",
                frame_count = 3,
                repeat_count = 24,
                height = 150,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.25
                },
                width = 300
            },
            -- Output 5 but 4
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-output.png",
                frame_count = 4,
                repeat_count = 18,
                height = 78,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    2.03125
                },
                width = 134
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections.png",
                height = 90,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.03125,
                    -2.0625
                },
                width = 326
            },
            -- Support
            {
                animation_speed = 0.5,
                dice_x = 3,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-support.png",
                frame_count = 6,
                repeat_count = 12,
                height = 190,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    -0.640625
                },
                width = 294
            },
            -- Support shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-support-shadow.png",
                frame_count = 1,
                height = 138,
                line_length = 1,
                priority = "high",
                repeat_count = 72,
                scale = 0.5,
                shift = {
                    0.6875,
                    -0.171875
                },
                width = 380
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-still-front.png",
                height = 176,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    0,
                    0.96875
                },
                width = 322
            },
            -- Output Particles 
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-output-particles.png",
                frame_count = 24,
                repeat_count = 3,
                height = 140,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.328125,
                    0.859375
                },
                width = 118
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections-front.png",
                height = 196,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    0.09375
                },
                width = 338
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-pipe-connections-shadow.png",
                height = 310,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.5625,
                    0.078125
                },
                width = 390
            },
            -- Nozzle 19 to 18
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top-nozzle.png",
                frame_count = 18,
                repeat_count = 4,
                height = 192,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.578125,
                    -1.171875
                },
                width = 40
            },
            -- Top
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top.png",
                frame_count = 18,
                repeat_count = 4,
                height = 174,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.03125,
                    -1.640625
                },
                width = 152
            },
            -- Top shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/South/big-mining-drill-S-top-shadow.png",
                frame_count = 18,
                repeat_count = 4,
                height = 140,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.109375,
                    0.46875
                },
                width = 206
            }
        }
    },
    west = {
        layers = {
            scorchmark_anim,
            drill_anim,
            drill_shadow_anim,
            dust_anim,
            dust_tint_anim,
            -- Steel Reel
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-still-reel.png",
                height = 40,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.015625,
                    1.296875
                },
                width = 284
            },
            -- Wheel
            {
                animation_speed = 0.2,
                dice_y = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-wheels.png",
                frame_count = 3,
                repeat_count = 24,
                height = 296,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.40625,
                    -0.09375
                },
                width = 208
            },
            -- Output 5 but 4
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-output.png",
                frame_count = 4,
                repeat_count = 18,
                height = 108,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -2.046875,
                    -0.078125
                },
                width = 86
            },
            -- Pipe connctions
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections.png",
                height = 74,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.359375,
                    -2.609375
                },
                width = 256
            },
            -- Support
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-support.png",
                frame_count = 6,
                repeat_count = 12,
                height = 306,
                line_length = 3,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.328125,
                    -0.625
                },
                width = 186
            },
            -- Support shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-support-shadow.png",
                frame_count = 1,
                height = 288,
                line_length = 1,
                priority = "high",
                repeat_count = 72,
                scale = 0.5,
                shift = {
                    0.53125,
                    0.046875
                },
                width = 312
            },
            -- Front
            {
                dice = 2,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-still-front.png",
                height = 352,
                repeat_count = 72,
                line_length = 1,
                priority = "high",
                scale = 0.5,
                shift = {
                    -1,
                    -0.328125
                },
                width = 188
            },
            -- Output Particles 
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-output-particles.png",
                frame_count = 24,
                repeat_count = 3,
                height = 152,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -1.828125,
                    -1
                },
                width = 84
            },
            -- Pipe front
            {
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections-front.png",
                height = 318,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.0625,
                    0.25
                },
                width = 332
            },
            -- Pipe shadow
            {
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-pipe-connections-shadow.png",
                height = 352,
                line_length = 1,
                repeat_count = 72,
                priority = "high",
                scale = 0.5,
                shift = {
                    0.65625,
                    0
                },
                width = 298
            },
            -- Nozzle 19 but 18
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top-nozzle.png",
                frame_count = 18,
                repeat_count = 4,
                height = 68,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -1.1875,
                    -2.109375
                },
                width = 118
            },
            -- Top
            {
                animation_speed = 0.5,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top.png",
                frame_count = 18,
                repeat_count = 4,
                height = 158,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    -0.265625,
                    -1.75
                },
                width = 214
            },
            -- Top shadow
            {
                animation_speed = 0.5,
                draw_as_shadow = true,
                filename = "__space-age__/graphics/entity/big-mining-drill/West/big-mining-drill-W-top-shadow.png",
                frame_count = 18,
                repeat_count = 4,
                height = 106,
                line_length = 6,
                priority = "high",
                scale = 0.5,
                shift = {
                    2.0625,
                    0.28125
                },
                width = 238
            }
        }
    },
}

lava_turret.folding_animation = idle_anim
lava_turret.attacking_animation = idle_anim

lava_turret.folded_animation = idle_anim
lava_turret.ending_attack_animation = idle_anim
lava_turret.prepared_animation = idle_anim

-- Remove muzzle
lava_turret.muzzle_animation = nil

-- Indicator LED replacement WIP
lava_turret.enough_fuel_indicator_picture.east = {
    filename = drill_data.graphics_set.working_visualisations[14].east_animation.filename,
    height = drill_data.graphics_set.working_visualisations[14].east_animation.height,
    scale = drill_data.graphics_set.working_visualisations[14].east_animation.scale,
    shift = drill_data.graphics_set.working_visualisations[14].east_animation.shift,
    width = drill_data.graphics_set.working_visualisations[14].east_animation.width,
    x = 0
}
lava_turret.enough_fuel_indicator_picture.north = {
    filename = drill_data.graphics_set.working_visualisations[14].north_animation.filename,
    height = drill_data.graphics_set.working_visualisations[14].north_animation.height,
    scale = drill_data.graphics_set.working_visualisations[14].north_animation.scale,
    shift = drill_data.graphics_set.working_visualisations[14].north_animation.shift,
    width = drill_data.graphics_set.working_visualisations[14].north_animation.width,
    x = 0
}
lava_turret.enough_fuel_indicator_picture.south = {
    filename = drill_data.graphics_set.working_visualisations[14].south_animation.filename,
    height = drill_data.graphics_set.working_visualisations[14].south_animation.height,
    scale = drill_data.graphics_set.working_visualisations[14].south_animation.scale,
    shift = drill_data.graphics_set.working_visualisations[14].south_animation.shift,
    width = drill_data.graphics_set.working_visualisations[14].south_animation.width,
    x = 0
}
lava_turret.enough_fuel_indicator_picture.west = {
    filename = drill_data.graphics_set.working_visualisations[14].west_animation.filename,
    height = drill_data.graphics_set.working_visualisations[14].west_animation.height,
    scale = drill_data.graphics_set.working_visualisations[14].west_animation.scale,
    shift = drill_data.graphics_set.working_visualisations[14].west_animation.shift,
    width = drill_data.graphics_set.working_visualisations[14].west_animation.width,
    x = 0
}

lava_turretfast_replaceable_group = nil -- different size from flamethrower so can't be overwridden
lava_turret.surface_conditions = {
    {property = "gravity", min = 1}
}

local lava_grenade_smoke = table.deepcopy(data.raw["trivial-smoke"]["poison-capsule-smoke"])
lava_grenade_smoke.name = "hades-fury-lava-grenade-smoke"
lava_grenade_smoke.color = {
    0.5, 0.5, 0.5, 0.69
}


local lava_grenade = table.deepcopy(data.raw["projectile"]["poison-capsule"])
lava_grenade.name = "hades-fury-lava-grenade"
lava_grenade.light = {
  intensity = 0.75,
  size = 8
}
lava_grenade.animation.filename = "__hades-fury__/graphics/lava-grenade.png"


if settings.startup["hades-fury-friendly-fire-grenade"].value then
    force = "all"
end

lava_grenade.action = {
    {
        type = "direct",
        action_delivery = {
            lava_turret.attack_parameters.ammo_type.action.action_delivery[1],
            {
                target_effects = table.deepcopy(lava_turret.attack_parameters.ammo_type.action.action_delivery[2].target_effects),
                type = "instant"
            }
        }
    }
}


lava_grenade.action[1].action_delivery[2].target_effects[1].action.force = force
lava_grenade.action[1].action_delivery[2].target_effects[2].action.force = force

lava_grenade.smoke[1].name = "hades-fury-lava-grenade-smoke"

data:extend({
    lava_turret,
    custom_eruption,
    custom_fissure,
    custom_particle,
    custom_small_eruption,
    custom_small_fissure,
    custom_small_particle,
    custom_small_explosion,
    custom_small_scorchmark,
    lava_grenade,
    lava_grenade_smoke
})