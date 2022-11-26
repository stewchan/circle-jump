extends Area2D


enum MODES {STATIC, LIMITED}

onready var orbit_position = $Pivot/OrbitPosition
var radius := 70
var rotation_speed := PI
var mode = MODES.STATIC

const MAX_ORBITS := 3 			# Maximum orbits until circle disappears
var current_orbit := 0		# Current orbit of Jumper
var orbit_start			 	# Where in the rotation the orbits started
var jumper


func set_mode(_mode):
	mode = _mode
	match mode:
		MODES.STATIC:
			$Label.hide()
		MODES.LIMITED:
			current_orbit = MAX_ORBITS
			$Label.text = str(current_orbit)
			$Label.show()


func init(_position, _radius := radius, _mode = MODES.LIMITED) -> void:
	set_mode(_mode)
	add_to_group("circles")
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
	if mode == MODES.LIMITED and jumper:
		check_orbits()
		update()


func check_orbits():
	if abs($Pivot.rotation - orbit_start) > 2 * PI:
		current_orbit -= 1
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
	if jumper:
		var r = ((radius - 50) / MAX_ORBITS) * (1 + MAX_ORBITS - current_orbit)
		draw_circle_arc_poly(Vector2.ZERO, r, orbit_start + PI/2,
							$Pivot.rotation + PI/2, Color(1, 0, 0))
