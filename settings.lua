data:extend({
		{
			type = "int-setting",
			name = "startup-tech-boost",
			setting_type = "startup",
			default_value = 30000,
			min_value = 0
		}
})
data:extend({
		{
			type = "bool-setting",
			name = "reward-neutral-kills",
			setting_type = "startup",
			default_value = false
		} 
})
data:extend({
		{
			type = "double-setting",
			name = "cost-per-damage",
			setting_type = "startup",
			minimum_value = 0.01,
			default_value = 1,
			maximum_value = 100
		}
})
data:extend({
		{
			type = "string-setting",
			name = "science-overflow-mode",
			setting_type = "startup",
			allowed_values = {"void", "keep", "decay"},
			default_value = "void"
		}
})
data:extend({
		{
			type = "double-setting",
			name = "science-decay-per-tick",
			setting_type = "startup",
			minimum_value = 0.01,
			default_value = 0.05,
			maximum_value = 0.99
		}
})
data:extend({
		{
			type = "bool-setting",
			name = "print-science-values",
			setting_type = "runtime-global",
			default_value = false
		}
})
