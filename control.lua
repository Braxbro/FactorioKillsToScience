local function getMaximumEnergyOfRecipe(productName)
	local recipes
	if game.item_prototypes[name] then
		recipes = game.get_filtered_recipe_prototypes({{filter = "has-product-item", elem_filters = {{filter = "name", name = productName) --recipe is an item
	else 
		if game.fluid_prototypes[name] then
			recipes = game.get_filtered_recipe_prototypes({{filter = "has-product-fluid", elem_filters = {{filter = "name", name = productName) --recipe is a fluid
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
		return maxProductEnergy
	else
		return 0
	end
end
	

local function calculateScienceCosts()
	local tools = game.get_filtered_item_prototypes({{filter = "tool"}})
	for _, pack in pairs(tools) do
		
	

local function onInit()
    if settings.startup["startup-unlock-tech"].value then
	   for index, force in pairs(game.forces) do
	   force.technologies["automation"].researched = true
	   force.technologies["stone-wall"].researched = true
	   force.technologies["gun-turret"].researched = true
	   force.technologies["military"].researched = true
	   force.technologies["logistics"].researched = true
	   end
	end
end

function onDeathHandler(event)
    local entity = event.entity
	local attackingForce = event.force
	
	if (attackingForce == nil) then
		return
	end
	if(attackingForce.current_research == nil) then
		return
	end

	-- Do not reward destroying your allied or neutral entities (like trees)
	if (entity.force == attackingForce or entity.force.name == "neutral") then
		return
	end
	
	-- Disable reward for kills on cease-fired targets if not enabled 
	if ((not settings.startup["reward-neutral-kills"]) and attackingForce.get_cease_fire(entity.force)) then
		return
	end

	local researchIngredientCount = 0
	for index, ingredient in pairs(attackingForce.current_research.research_unit_ingredients) do
		researchIngredientCount = researchIngredientCount + ingredient.amount
	end
	local researchUnitCost = researchIngredientCount * (attackingForce.current_research.research_unit_energy / 60 / (1 + attackingForce.laboratory_speed_modifier))
	local researchTotalCost = researchUnitCost * attackingForce.current_research.research_unit_count
	-- TODO: rename
	local damageEffectScale = settings.startup["damage-effect-scale"].value / 100
	local researchDelta = entity.prototype.max_health / (researchTotalCost * damageEffectScale) * (1 + attackingForce.laboratory_productivity_bonus)
	local researchProgress = attackingForce.research_progress + researchDelta
	if(researchProgress >= 1)then
		attackingForce.research_progress = 0
		attackingForce.current_research.researched = true
	else
		attackingForce.research_progress = researchProgress
	end

end

script.on_init(onInit)
script.on_event(defines.events.on_entity_died, onDeathHandler)
