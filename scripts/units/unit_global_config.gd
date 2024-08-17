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

static var list_of_objectives = [
	{
		"description": "1 healthy onion, please",
		"objective": 
			{
				"unit_type" : UnitTypes.ONION,
				"trait": StatPrimitives.HEALTH,
				"target": 0.8
			}
		
	},
	{
		"description": "I need a chatty cat",
		"objective": 
			{
				"unit_type" : UnitTypes.CAT,
				"trait": StatPrimitives.SOCIAL,
				"target": 0.8
			}
		
	},
	{
		"description": "Hungry Crab",
		"objective": 
			{
				"unit_type" : UnitTypes.CRAB,
				"trait": StatPrimitives.HUNGER,
				"target": 0.8
			}
		
	},
	{
		"description" : "Chatty crab",
		"objective": 
			{
				"unit_type" : UnitTypes.CRAB,
				"trait": StatPrimitives.SOCIAL,
				"target": 0.8
			}
		
	},
	{
		"description" : "Healthy Crab",
		"objective": 
			{
				"unit_type" : UnitTypes.CRAB,
				"trait": StatPrimitives.HEALTH,
				"target": 0.8
			}
		
	}
]

