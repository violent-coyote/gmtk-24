# extends Node
# # Unit Global Config (UGC)
# class_name UGC

# # region
# ## Traits are all unique "personality" traits that can affect unit stats
# enum Traits {
# 	AGGRESSIVE,
# 	SNEAKY,
# 	CRUEL,
# 	COWARDLY
# }
# ## StatPrimitives are the unit stats that can be affected by traits that are shared among all units
# enum StatPrimitives {
# 	HEALTH,
# 	HUNGER,
# 	SOCIAL,
# 	HAPPINESS
# }

# ## Life Events are possible events that can occur that affect traits
# enum LifeEvents {
# 	HURT,
# 	FEED,
# 	TALK,
# 	SUNSET,
# 	SUNRISE,
# 	RAIN,
# 	THUNDERSTORM,
# 	BLIZZARD,
# 	HEATWAVE,
# }

# static var list_of_names = [
# 	"John",
# 	"Absolutely Atrocious",
# 	"Salmon Sally",
# ]

# # Global mapping of traits to effects
# static var traits_to_effects = {
# 		Traits.AGGRESSIVE: [StatEffects.new(StatPrimitives.HEALTH, 3)],
# 		Traits.SNEAKY: [StatEffects.new(StatPrimitives.HUNGER, 1)],
# 		Traits.COWARDLY: [
# 			StatEffects.new(StatPrimitives.ATTACK, -3),
# 			StatEffects.new(StatPrimitives.HAPPINESS, 2),
# 			StatEffects.new(StatPrimitives.HEALTH, -2)
# 		],
# 		Traits.CRUEL: [
# 			StatEffects.new(StatPrimitives.ATTACK, 5),
# 			StatEffects.new(StatPrimitives.HAPPINESS, -3),
# 			],
# 	}

# static var species_list = [
# 	Species.new("Crab", [
# 		TraitAffinity.new(Traits.AGGRESSIVE, 0.2),
# 		TraitAffinity.new(Traits.CRUEL, 0.3),
# 		TraitAffinity.new(Traits.COWARDLY, -0.3)
# 	]),
# 	Species.new("Onion", [
# 		TraitAffinity.new(Traits.SNEAKY, 0.9),
# 		TraitAffinity.new(Traits.COWARDLY, 0.3),
# 		TraitAffinity.new(Traits.AGGRESSIVE, -0.5)
# 	])
# 	# Add more species here
# ]
# # endregion

# # region classes
# class StatEffects:
# 	var stat: StatPrimitives  # StatPrimitives
# 	var maximum_effect_size: int

# 	func _init(_stat: StatPrimitives, max_effect: int):
# 		self.stat = _stat
# 		self.maximum_effect_size = max_effect

# class TraitAffinity:
# 	## this is the trait that the affinity is mapped to
# 	var unit_trait: Traits
# 	## this value is -1 to 1, with -1 being the min and 1 being the max
# 	var affinity_value: float

# 	func _init(_unit_trait: Traits, _value: float = 0.0):
# 		self.unit_trait = _unit_trait
# 		self.affinity_value = _value

# class Species:
# 	var name: String
# 	## FIXME do all species have a single affinitiy for all base traits, or just some? this assumes any number of affinities (see current species list)
# 	var base_affinities: Array[TraitAffinity] 

# 	func _init(_name: String, _affinities: Array[TraitAffinity]):
# 		self.name = _name
# 		self.base_affinities = _affinities

# class LifeEvent:
# 	var name : String
# 	## A life event changes a single trait (FIXME would we ever want to change multiple traits at once?)
# 	var affinity_change : TraitAffinity

# 	func _init(_name: String, _affinity_change: TraitAffinity):
# 		self.name = _name
# 		self.affinity_change = _affinity_change
# # endregion
