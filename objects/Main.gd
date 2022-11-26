extends Node2D

var Circle = preload("res://objects/Circle.tscn")
var Jumper = preload("res://objects/Jumper.tscn")

var player
var score

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
	spawn_circle($StartPosition.position)
	score = 0
	$HUD.update_score(score)
	$HUD.show()
	$HUD.show_message("Go!")


func _on_Jumper_captured(object):
	score += 1
	$HUD.update_score(score)
	$Camera2D.position = object.position
	object.capture(player)
	call_deferred("spawn_circle")


func _on_Jumper_died():
	get_tree().call_group("circles", "implode")
	$Screens.game_over()
	$HUD.hide()


func spawn_circle(_position = null) -> void:
	var c = Circle.instance()
	if _position == null:
		var x = rand_range(-150, 150)
		var y = rand_range(-500, -400)
		_position = player.target.position + Vector2(x, y)
	add_child(c)
	c.init(_position)



		
