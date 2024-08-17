extends Node
# Unit Global Config (UGC)
class_name UGC

enum UnitTypes {
	CAT,
	ONION,
	CRAB
}

## StatPrimitives are the unit stats that can be affected by traits that are shared among all units
enum StatPrimitives {
	HEALTH,
	HUNGER,
	SOCIAL,
	HAPPINESS
}

## Life Events are possible events that can occur that affect traits
enum LifeEvents {
	HURT,
	FEED,
	TALK,
	SUNSET,
	SUNRISE,
	RAIN,
	THUNDERSTORM,
	BLIZZARD,
	HEATWAVE,
}

static var list_of_names = [
	"John",
	"Chef",
	"Salmon Sally",
	"Catlady",
	"Small Potatoes"
]

static var values_to_effects = [
	{

	},

]

