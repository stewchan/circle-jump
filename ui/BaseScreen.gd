extends CanvasLayer


onready var tween = $Tween


func appear() -> void:
	get_tree().call_group("buttons", "set_disabled", false)
	tween.interpolate_property(self, "offset:x", 500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()	


func disappear() -> void:
	get_tree().call_group("buttons", "set_disabled", true)
	tween.interpolate_property(self, "offset:x", 0, 500, 0.4, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()


func _on_TextEdit_meta_clicked(meta) -> void:
	OS.shell_open(meta)
