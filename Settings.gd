extends Node

var settings_file = "user://settings.save"
var enable_sound = true
var enable_music = true
var enable_ads = false
var circles_per_level = 5


var color_schemes = {
	"NEON1": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(203, 255, 0),
		'player_trail': Color8(204, 0, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(0, 255, 102),
		'circle_limited': Color8(204, 0, 255)
	},
	"NEON2": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(246, 255, 0),
		'player_trail': Color8(255, 255, 255),
		'circle_fill': Color8(255, 0, 110),
		'circle_static': Color8(151, 255, 48),
		'circle_limited': Color8(127, 0, 255)
	},
	"NEON3": {
		'background': Color8(0, 0, 0),
		'player_body': Color8(255, 0, 187),
		'player_trail': Color8(255, 148, 0),
		'circle_fill': Color8(255, 148, 0),
		'circle_static': Color8(170, 255, 0),
		'circle_limited': Color8(204, 0, 255)
	}
}
var theme = color_schemes["NEON1"]



	



func _ready() -> void:
	load_settings()


func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_sound)
	f.store_var(enable_music)
	f.store_var(enable_ads)
	f.close()


func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_sound = f.get_var()
		enable_music = f.get_var()
		self.enable_ads = f.get_var()
		f.close()


#func set_enable_ads():
#	save_settings()


# Stages
var level_settings = [
	{
		"mode": "static",
		"radius": 120,
		"rotation_speed" : PI * 0.7,
		"move_range": 0,
		"move_speed": 1.0,
		"jump_speed": 1000,
	},
	{
		"mode": "limited",
		"radius": 120,
		"rotation_speed" : PI * 0.7,
		"move_range": 0,
		"move_speed": 1.0,
		"jump_speed": 1000,
	},

	
]
