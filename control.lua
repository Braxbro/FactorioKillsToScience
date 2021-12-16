local function getMaximumEnergyOfRecipe(productName)
	local recipes
	if game.item_prototypes[name] then
		recipes = game.get_filtered_recipe_prototypes({{filter = "has-product-item", elem_filters = {{filter = "name", name = productName}}}}) --recipe is an item
	else 
		if game.fluid_prototypes[name] then
			recipes = game.get_filtered_recipe_prototypes({{filter = "has-product-fluid", elem_filters = {{filter = "name", name = productName}}}}) --recipe is a fluid
		else
			return 0 --cannot find recipe
		end
	end
	local maxProductEnergy = 0
	local maxEnergyRecipe 
	for name, recipe in pairs(recipes) do
		local count
		for _, product in pairs(recipe.products) do
			if product.name = name then
				count = product.amount or product.amount_min
			end
		end
		if (recipe.energy / count) > maxProductEnergy then
			maxProductEnergy = recipe.energy / count
			maxEnergyRecipe = recipe
		end
	end
	if maxEnergyRecipe then
		local sum
		for _, ingredient in pairs do
			maxProductEnergy = maxProductEnergy + getMaximumEnergyOfRecipe(ingredient.name) * ingredient.amount
		end
	end
	return maxProductEnergy
end
	

local function calculateScienceCosts()
	local packs = game.get_filtered_item_prototypes({{filter = "subgroup", subgroup = "science-pack"}})
	for _, pack in pairs(packs) do
		global.packCost[pack.name] = getMaximumEnergyOfRecipe(pack.name)
	end
end

local function onInit()
	global.packCost = {}
	global.storedCost = {}
    if settings.startup["startup-unlock-tech"].value then
	   for index, force in pairs(game.forces) do
	   force.technologies["automation"].researched = true
	   force.technologies["stone-wall"].researched = true
	   force.technologies["gun-turret"].researched = true
	   force.technologies["military"].researched = true
	   force.technologies["logistics"].researched = true
	   end
	end
	calculateScienceCosts()
end

function onDeathHandler(event)
    local entity = event.entity
	local attackingForce = event.force
	
	if (attackingForce == nil) then
		return
	end
	local overflow = settings.startup["science-overflow-mode"].value
	local costPerDamage = settings.startup["cost-per-damage"].value
	if (attackingForce.current_research == nil) then
		if overflow = "void" then -- if not retaining science
			return
		else
			global.storedCost[attackingForce.name] = (global.storedCost[attackingForce.name] or 0) + (entity.prototype.max_health * costPerDamage) * (1 + attackingForce.laboratory_productivity_bonus) -- if retaining science (keep or decay modes)
			return
		end
	end

	-- Do not reward destroying your allied or neutral entities (like trees)
	if (entity.force == attackingForce or entity.force.name == "neutral") then
		return
	end
	
	-- Disable reward for kills on cease-fired/neutral targets if not enabled 
	if ((not settings.startup["reward-neutral-kills"].value) and attackingForce.get_cease_fire(entity.force)) then
		return
	end

	local researchUnitCost
	for index, ingredient in pairs(attackingForce.current_research.research_unit_ingredients) do
		researchUnitCost = researchUnitCost + global.packCost[ingredient.name] * ingredient.amount
	end
	researchUnitCost = (researchUnitCost + attackingForce.current_research.research_unit_energy) / (1 + attackingForce.laboratory_speed_modifier))
	local researchTotalCost = researchUnitCost * attackingForce.current_research.research_unit_count
	local researchDelta = (entity.prototype.max_health * costPerDamage) / researchTotalCost * (1 + attackingForce.laboratory_productivity_bonus)
	local researchProgress = attackingForce.research_progress + researchDelta
	if not overflow = "void" then
		local costGain = (entity.prototype.max_health * costPerDamage) * (1 + attackingForce.laboratory_productivity_bonus)
		global.storedCost[attackingForce.name] = global.storedCost[attackingForce.name] + math.max(costGain - (1 - researchTotalCost * attackingForce.research_progress), 0) -- excess gets stored if retaining science
	end
	if (researchProgress >= 1) then
		attackingForce.research_progress = 0
		attackingForce.current_research.researched = true
	else
		attackingForce.research_progress = researchProgress
	end
end

local function onTick()
	for _, force in pairs(game.forces) do
		if (force.current_research and global.storedCost[force.name]) then
			local researchUnitCost
			for index, ingredient in pairs(force.current_research.research_unit_ingredients) do
				researchUnitCost = researchUnitCost + global.packCost[ingredient.name] * ingredient.amount
			end
			researchUnitCost = (researchUnitCost + force.current_research.research_unit_energy) / (1 + force.laboratory_speed_modifier))
			local researchTotalCost = researchUnitCost * force.current_research.research_unit_count
			local researchDelta = global.storedCost[force.name]/researchTotalCost
			local researchProgress = force.research_progress + researchDelta
			global.storedCost[force.name] = math.max(0, global.storedCost[force.name] - (researchTotalCost * (1 - force.research_progress))) -- spend any stored science
		else if settings.startup["science-overflow-mode"].value = "decay" then -- don't decay stored science that was spent this tick
			global.storedCost[force.name] = (1 - settings.startup["science-decay-per-tick"]) * global.storedCost[force.name]
		end
	end
end
		
script.on_init(onInit)
script.on_tick(onTick)
script.on_configuration_changed(calculateScienceCosts)
script.on_event(defines.events.on_entity_died, onDeathHandler)
