extends Node
class_name ComboEntry

var type: COMBO_POSSIBILITIES
var amount: int

func _init(type: COMBO_POSSIBILITIES, amount: int = 1):
	self.type = type
	self.amount = amount
