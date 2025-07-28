## This Node can be added to PhysicsBodies to make them interactable 
extends Node
class_name Interacter

## is emited when once at the start of the interaction
signal start_of_interaction()

## is emited every physics tick OR every frame
## (depending if physics_interacter is true or false)
## while the interacting
signal interaction()

## is emited when the interaction stops 
signal end_of_interaction()

var _start_guard: bool = false
var _end_guard: bool = false

## This variable controlls if the interaction life cycle logic is beeing processed 
## every physics tick or every frame it is here so if the logic that starts the life cycle
## aka by calling [method interact()] is implemented in [code]_physics_process(_delta: float)[/code]
## it dosent cause bugs 
@export var physics_interacter: bool = false

func _ready() -> void:
	get_parent().add_to_group("Interactable")
	
func _process(_delta: float) -> void:
	if not physics_interacter:
		_handle_guards()

func _physics_process(_delta: float) -> void:
	if physics_interacter:
		_handle_guards()

## This method starts the interaction life cycle and is supose to be called every frame
## of the interaction
func interact() -> void:
	if not _start_guard:
		start_of_interaction.emit()
		_start_guard = true
	
	interaction.emit()
	
	_end_guard = true
	
func _handle_guards() -> void:
	if _start_guard and not _end_guard:
		_start_guard = false
		end_of_interaction.emit()
	else:
		_end_guard = false
