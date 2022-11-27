extends Node2D

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score := 0 setget set_score
var level := 0


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
	level = 0
	Settings.intensify(level)
	spawn_circle($StartPosition.position)
	$HUD.update_score(score)
	$HUD.show()
	$HUD.show_message("Go!")
	if Settings.enable_music:
		$Music.play()


func set_score(value):
	score = value
	if score > Settings.highscore:
		Settings.highscore = score
		Settings.save_settings()
	$HUD.update_score(score)
	if score > 0 and score % Settings.circles_per_level == 0:
		level += 1
		Settings.intensify(level)
		$HUD.show_message("Level %s" % str(level))


func _on_Jumper_captured(object):
	self.score += 1
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")


func _on_Jumper_died():
	get_tree().call_group("circles", "implode")
	$Screens.game_over()
	$HUD.hide()
	if Settings.enable_music:
		$Music.stop()


func spawn_circle(_position = null) -> void:
	var c = Circle.instance()
	if _position == null:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	
	# Spawn circle based on current level
	var mode = Settings.level_settings["mode"]
	var radius = Settings.level_settings["radius"]
	var move_range = Settings.level_settings["move_range"]
	var move_speed = Settings.level_settings["move_speed"]
	var rotation_speed = Settings.level_settings["rotation_speed"]
	c.init(_position, mode, radius, rotation_speed, move_range, move_speed)



		
