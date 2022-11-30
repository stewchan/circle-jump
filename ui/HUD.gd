extends CanvasLayer


var score : int
var old_score : int = 0


func show_message(text):
	$Message.text = text
	$MessageAnim.play("show_message")


func hide():
	$ScoreBox.hide()


func show():
	$ScoreBox.show()


func update_multiplier(value):
	$Multiplier.text = str(value) + "x"


func update_score(value : int):
	var new_score = old_score + value
	$Tween.interpolate_method(self, "step_score", old_score, new_score, 0.25, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	old_score = new_score


func step_score(value:int) -> void:
	$ScoreBox/HBoxContainer/Score.text = str(value)
