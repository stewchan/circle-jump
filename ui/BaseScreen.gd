extends CanvasLayer


onready var tween = $Tween


func _ready() -> void:
	pass


func appear() -> void:
	tween.interpolate_property(self, "offset:x", 500, 0, 0.5, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()	


func disappear() -> void:
	tween.interpolate_property(self, "offset:x", 0, 500, 0.4, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
