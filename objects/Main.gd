extends Node2D

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score : int setget set_score
var multiplier setget set_multiplier
var new_highscore
var level
var captures


func _ready() -> void:
	randomize()
	$HUD.hide()
	

func new_game():
	$Camera2D.position = $StartPosition.position
	player = Jumper.instance()
	player.position = $StartPosition.position
	add_child(player)
	player.connect("captured", self, "_on_Jumper_captured")
	player.connect("died", self, "_on_Jumper_died")
	self.score = 0
	self.multiplier = 0
	new_highscore = false
	level = 0
	captures = 0
	Settings.intensify(level)
	spawn_circle($StartPosition.position)
	$HUD.visible = true
	$HUD.show()
	$HUD.show_message("Go!")
	if Settings.enable_music:
		$Music.volume_db = 0
		$Music.play()


func set_score(value : int):
	$HUD.update_score(value)
	if score > Settings.highscore:
		if !new_highscore:
			new_highscore = true
			$HUD.show_message("New Record!")
		Settings.highscore = score
		Settings.save_settings()
	

func set_multiplier(value : int):
	multiplier = value
	$HUD.update_multiplier(multiplier)
	

func _on_Jumper_captured(object):
	captures += 1
	self.score += 1 * multiplier
	self.multiplier += 1
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")
	if captures > 0 and captures % Settings.circles_per_level == 0:
		level += 1
		Settings.intensify(level)
		$HUD.show_message("Level %s" % str(level))


func _on_Jumper_died():
	get_tree().call_group("circles", "implode")
	$Screens.game_over()
	$HUD.hide()
	if Settings.enable_music:
		fade_music()


func spawn_circle(_position = null) -> void:
	var c = Circle.instance()
	if _position == null:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.connect("full_orbit", self, "set_multiplier", [1])
	
	# Spawn circle based on current level
	var mode = Settings.level_settings["mode"]
	var radius = Settings.level_settings["radius"]
	var move_range = Settings.level_settings["move_range"]
	var move_speed = Settings.level_settings["move_speed"]
	var rotation_speed = Settings.level_settings["rotation_speed"]
	c.init(_position, mode, radius, rotation_speed, move_range, move_speed)


func fade_music():
	$MusicFade.interpolate_property($Music, "volume_db", 0, -50, 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$MusicFade.start()
	yield($MusicFade, "tween_all_completed")
	
	

		
