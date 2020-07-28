return function (mod)

	include_lisp(mod, "factory.lisp")

    mod.on_prepare_rules = function (rules)
		mod.recipe_redo_setup(rules)
    end

end
