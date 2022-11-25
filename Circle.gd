extends Area2D


onready var orbit_position = $Pivot/OrbitPosition
var radius := 70
var rotation_speed := PI


func init(_position, _radius := radius) -> void:
	position = _position
	radius = _radius
	rotation_speed *= pow(-1, randi() % 2)
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25


func _process(delta: float) -> void:
	$Pivot.rotation += rotation_speed * delta


func capture():
	$AnimationPlayer.play("capture")


func implode():
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()
