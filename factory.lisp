\return \(fn (mod)

(set mod.recipe_redo_setup (fn (rules)
	
(set factory_default_resource_output (fn (world job_giver worker output center)
    (locals
        i 0
        bonus (job_worker_bonus job_giver worker)
        base_amt (math.floor bonus)
        spread (- bonus base_amt)
        last_stack nil
    )
    (legacy-foreach-kv
        (fn (k n)
            (locals
                res (R k)
                tc (n2d_to_tile center)
                amt (math.max 1
                    (math.floor
                        (+
                            (math.max n (* n base_amt))
                            (if (>= spread (bridge_random_f 0.0 1.0))
                                1.0
                                0.0)
                        )
                    ))
            )
            (make_scrolling_text { .world world .wx center.x .wy center.y .by (+ 40 (* 20 i))
                .icon_frame res.icons.px30
                .text (format false "~A ~A" res.name amt)})
            (set last_stack (ItemDepositInRect
                world
                tc.x tc.y tc.w tc.h
                (ItemMake world center.x center.y res amt)))
            (goal_add_counter_resource
                (bridge_hash "production")
                (bridge_hash "production-resource")
                (bridge_hash "production-resource-tag")
                res amt
            )
            (timeseries_delta_production res amt)
            (set i (+ i 1))
        )
        output
    )
    (when last_stack
        (unless (try_near_pallet_stack (ecs_pos_center job_giver) last_stack)
            (unless (try_near_pallet_stack (ecs_pos_center last_stack) last_stack)
                (when (worker_able_to_work_comp worker delivery_job_component)
                    (try_delivery worker last_stack)
                )
            )
        )
    )
))

(set recipe_redo_installed true)

))

)