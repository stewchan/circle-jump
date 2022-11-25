extends Area2D


signal captured(area)

onready var trail = $Trail/Points
var trail_length = 25

var velocity := Vector2(100, 0)
var jump_speed := 1000
var target : Area2D = null


func _ready() -> void:
	trail.position = position


func _unhandled_input(event: InputEvent) -> void:
	if target and event is InputEventScreenTouch and event.pressed:
		jump()


func jump() -> void:
	target.implode()
	target = null
	velocity = transform.x * jump_speed


func _physics_process(delta: float) -> void:
#	if trail.points.size() > trail_length:
#		trail.remove_point(0)
#	trail.add_point(position)

	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
	



func _on_Jumper_area_entered(area: Area2D) -> void:
	target = area
	target.get_node("Pivot").rotation = (position - target.position).angle()
	velocity = Vector2.ZERO
	emit_signal("captured", area)
