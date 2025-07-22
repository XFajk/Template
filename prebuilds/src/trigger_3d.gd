extends Area3D
class_name Trigger3D

@export var trigger_node: PhysicsBody3D = null
@export var trigger_once: bool = false
@export var retrigger_duration_seconds: float = 1.0

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	if retrigger_duration_seconds:
		timer.wait_time = retrigger_duration_seconds
		timer.one_shot = true
		timer.timeout.connect(_on_timeout)
		
		add_child(timer, false, Node.INTERNAL_MODE_BACK)
	
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D) -> void:
	if body == trigger_node or trigger_node == null:
		for child in get_children():
			if child is CollisionShape3D:
				continue
			
			if not child.has_method("_on_trigger"):
				push_warning("Child %s of trigger %s is missing _on_trigger(). Please add this method." % [child.name, self.name])
				continue
								
			child._on_trigger(body)
			
		if trigger_once:
			queue_free()
		else: 
			if retrigger_duration_seconds:
				body_entered.disconnect(_on_body_entered)
				timer.start()
			
func _on_timeout() -> void:
	body_entered.connect(_on_body_entered)
	
