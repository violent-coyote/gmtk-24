extends Node
# Unit Global Config (UGC)
class_name UGC

# region
## Traits are all unique "personality" traits that can affect unit stats
enum Traits {
	AGGRESSIVE,
	SNEAKY,
	CRUEL,
	COWARDLY
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
	"Absolutely Atrocious",
	"Salmon Sally",
]

