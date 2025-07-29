extends Node
class_name FpsController

enum PlayerState {
	STANDING,
	MOVING,
	NOTHING,
}

var state: PlayerState = PlayerState.STANDING

@export_category("Movement")
@export var movement_speed = 200
@export var running_speed = 400
@export var acceleration = 15
@export var gravity = 20
@export var jump_strength = 450
@export var terminal_velocity = -100
var vertical_speed = 0.0
var direction = Vector3.ZERO

@export_category("Stamina")
@export var stamina_on = false
@export var stamina_recharge_speed = 30
@export var stamina_degradation_speed = 15

@onready var body: CharacterBody3D = self.get_parent()
@onready var head: Node3D = self.get_parent().get_node("Head")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and state != PlayerState.NOTHING and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		body.rotate_y(deg_to_rad(-event.relative.x * Global.mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * Global.mouse_sens))
		head.rotation.x = deg_to_rad(clamp(head.rotation_degrees.x, -70, 70))
