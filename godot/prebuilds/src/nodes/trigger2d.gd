## A reusable 2D trigger zone that executes trigger logic on child nodes.
##
## This node detects when a [PhysicsBody2D] enters its area and calls a method named
## [_on_trigger(body)] on each child that defines it. Children without this method are ignored.
##
## Optionally, you can restrict the trigger to a specific [PhysicsBody2D] using [member trigger_node].
## If left empty, any body entering the area will activate the trigger.
##
## If [member trigger_once] is true, the trigger will activate once and then remove itself.
##
## If [member retrigger_duration_seconds] is greater than `0.0`, the trigger will be temporarily
## disabled after activation and will automatically reactivate after the specified time.
##
## Emits [signal triggerd] each time the trigger is activated.

extends Area2D
class_name Trigger2D

@export var trigger_node: PhysicsBody2D = null
@export var trigger_once: bool = false
@export var retrigger_duration_seconds: float = 1.0

@onready var _timer: Timer = Timer.new()

signal triggered(body: PhysicsBody2D)

func _ready() -> void:
	if retrigger_duration_seconds:
		_timer.wait_time = retrigger_duration_seconds
		_timer.one_shot = true
		_timer.timeout.connect(_on_timeout)
		
		add_child(_timer, false, Node.INTERNAL_MODE_BACK)
	
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node2D) -> void:
	if body == trigger_node or trigger_node == null:
		for child in get_children():
			if not child.has_method("_on_trigger"):
				continue
								
			child._on_trigger(body)
			triggered.emit(body)
			
		if trigger_once:
			queue_free()
		else: 
			if retrigger_duration_seconds:
				body_entered.disconnect(_on_body_entered)
				_timer.start()
			
func _on_timeout() -> void:
	body_entered.connect(_on_body_entered)
	
