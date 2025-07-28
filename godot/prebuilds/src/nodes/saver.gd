@icon("res://prebuilds/icons/saver_icon.svg")

## This Nodes save's requested properties of the parent node 
##
##
## This [Node] is for saving state of an object between game sesions and is tied to the SaveSystem Global.
## The SaveSystem has methods [code]save_game()[/code] and [code]load_game()[/code] wich when called will go trough all Saver Nodes
## and call the [method saveout] method or [method loadin] methods and these methods go trough the [member properties_to_save] and set them or get them 
## form the parent node 
extends Node
class_name Saver

## these are the parents properties that can be saved and loaded,
## but they have to be primitive nothing complex like full Nodes
@export var properties_to_save: Array[StringName] = []  

@onready var _parent = self.get_parent()

func _ready() -> void:
	add_to_group("Savers")

## Saves all the properties listed in [member properties_to_save] from the parent of this node
func saveout() -> Dictionary:
	var result: Dictionary = {}
	
	for property in properties_to_save:
		var value = _parent.get(property)
		result[property] = type_string(typeof(value))+str(value)
		
	print(result)
	return result


## Loads all the properties listed in [member properties_to_save] into the parent of this node
func loadin(data: Dictionary) -> void:
	print(data)
	for property in data:
		_parent.set(property, str_to_var(data[property]))
		print(_parent.position)
