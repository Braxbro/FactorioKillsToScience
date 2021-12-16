data:extend({
    {
      type = "bool-setting",
      name = "startup-unlock-tech",
      setting_type = "startup",
      default_value = true
    }
})
data:extend({
    {
      type = "bool-setting"
      name = "reward-neutral-kills"
      setting_type = "startup"
      default_value = false
    } 
})
data:extend({
    {
        type = "double-setting",
        name = "cost-per-damage",
        setting_type = "startup",
        minimum_value = 0.01
        default_value = 1
        maximum_value = 100
    }
})
data:extend({
	{
		type = "string-setting"
		name = "science-overflow-mode"
        setting_type = "startup"
		allowed_values = {"void", "keep", "decay"}
	}
})
			
            
