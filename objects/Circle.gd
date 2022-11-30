extends Area2D


signal full_orbit

# enum MODES {STATIC, LIMITED}
# modes: "static" or "limited"
var mode = "static"

onready var orbit_position = $Pivot/OrbitPosition
onready var move_tween = $MoveTween


var radius := 120
var rotation_speed := PI * 0.7
var move_range = 100
var move_speed = 1.0

const MAX_ORBITS := 3 			# Maximum orbits until circle disappears
var current_orbit := 0		# Current orbit of Jumper
var orbit_start			 	# Where in the rotation the orbits started
var jumper


func set_mode(_mode):
	mode = _mode
	var color
	match mode:
		"static":
			$Label.hide()
			color = Settings.theme["circle_static"]
		"limited":
			current_orbit = MAX_ORBITS
			$Label.text = str(current_orbit)
			# $Label.show()
			color = Settings.theme["circle_limited"]
	$Sprite.material.set_shader_param("color", color)


func init(_position, _mode = "static", _radius := radius,
		_rotation_speed := PI, _move_range := 100, _move_speed := 0.5) -> void:
	set_mode(_mode)
	add_to_group("circles")
	position = _position
	radius = _radius
	rotation_speed = _rotation_speed * pow(-1, randi() % 2)
	move_range = _move_range
	move_speed = _move_speed
	
	$Sprite.material = $Sprite.material.duplicate()
	$SpriteEffect.material = $Sprite.material
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.radius = radius
	var img_size = $Sprite.texture.get_size().x / 2
	$Sprite.scale = Vector2(1, 1) * radius / img_size
	orbit_position.position.x = radius + 25
	set_tween()


func set_tween():
	if move_range == 0:
		return
	yield(get_tree().create_timer(0.1),"timeout")
	move_range *= -1
	move_tween.interpolate_property(self, "position:x",
		position.x, position.x + move_range, move_speed,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	move_tween.start()
	

func _process(delta: float) -> void:
	$Pivot.rotation += rotation_speed * delta
	if jumper:
		check_orbits()
		update()


func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbit -= 1
		emit_signal("full_orbit")
		if mode == "limited":
			if Settings.enable_sound:
				$Beep.play()
			$Label.text = str(current_orbit)
			if current_orbit <= 0:
				jumper.die()
				jumper = null
				implode()
		orbit_start = $Pivot.rotation


func capture(target):
	jumper = target
	$AnimationPlayer.play("capture")
	$Pivot.rotation = (jumper.position - position).angle()
	orbit_start = $Pivot.rotation
	

func implode():
	jumper = null
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("implode")
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


func _draw():
	if mode != "limited":
		return
	if jumper:
		var color = Settings.theme["circle_fill"]
		var r = ((radius - 50) / MAX_ORBITS) * (1 + MAX_ORBITS - current_orbit)
		draw_circle_arc_poly(
			Vector2.ZERO,
			r,
			orbit_start + PI/2,
			$Pivot.rotation + PI/2,
			color
		)
