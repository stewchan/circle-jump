extends Area2D


var velocity := Vector2(100, 0)
var jump_speed := 1000
var target : Area2D = null


func _unhandled_input(event: InputEvent) -> void:
	if target and event is InputEventScreenTouch and event.pressed:
		jump()


func jump() -> void:
	target = null
	velocity = transform.x * jump_speed


func _physics_process(delta: float) -> void:
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta


func _on_Jumper_area_entered(area: Area2D) -> void:
	target = area
	velocity = Vector2()
