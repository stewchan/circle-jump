extends Node

var settings_file = "user://settings.save"
var enable_sound = true
var enable_music = true
var enable_ads = false
var circles_per_level = 5
var highscore = 0
	

var color_schemes = {
	"NEON0":
	{
		"background": Color8(0, 0, 0),
		"player_body": Color8(203, 255, 0),
		"player_trail": Color8(204, 0, 255),
		"circle_fill": Color8(255, 0, 110),
		"circle_static": Color8(0, 255, 102),
		"circle_limited": Color8(204, 0, 255)
	},
	"NEON1":
	{
		"background": Color8(0, 0, 0),
		"player_body": Color8(246, 255, 0),
		"player_trail": Color8(255, 255, 255),
		"circle_fill": Color8(255, 0, 110),
		"circle_static": Color8(151, 255, 48),
		"circle_limited": Color8(127, 0, 255)
	},
	"NEON2":
	{
		"background": Color8(0, 0, 0),
		"player_body": Color8(255, 0, 187),
		"player_trail": Color8(255, 148, 0),
		"circle_fill": Color8(255, 148, 0),
		"circle_static": Color8(170, 255, 0),
		"circle_limited": Color8(204, 0, 255)
	}
}

var theme_name = "NEON0"
var theme = color_schemes[theme_name]


func _ready() -> void:
	load_settings()
	

func save_settings():
	var f = File.new()
	f.open(settings_file, File.WRITE)
	f.store_var(enable_sound)
	f.store_var(enable_music)
	f.store_var(enable_ads)
	f.store_var(highscore)
	f.close()


func load_settings():
	var f = File.new()
	if f.file_exists(settings_file):
		f.open(settings_file, File.READ)
		enable_sound = f.get_var()
		enable_music = f.get_var()
		self.enable_ads = f.get_var()
		highscore = f.get_var()
		f.close()


#func set_enable_ads():
#	save_settings()

# Starting game play settings
const LEVEL_START = {
	"mode": "static",
	"radius": 120,
	"rotation_speed": PI * 0.7,
	"move_range": 0,
	"move_speed": 1.0,
	"jump_speed": 1000,
}

var level_settings = LEVEL_START


func intensify(level):
	var settings = level_settings.duplicate()
	var num_levels = len(_level_changes)

	# Change the color scheme every so often
	if level % 5 == 0:
		next_theme()

	level = clamp(level, 0, num_levels - 1)
	var dict = _level_changes[level]
	
	for key in dict:
		settings[key] = dict[key]
	level_settings = settings


func next_theme():
	var num = int(theme_name[len(theme_name) - 1])
	num = (num + 1) % len(color_schemes)
	theme_name = "NEON" + str(num)
	theme = color_schemes[theme_name]


var _level_changes = [
	LEVEL_START,
	{"mode": "limited"},
	{"rotation_speed": PI * 0.8},
	{"radius": 100},
	{"move_range": 100},
	{"move_speed": 0.8},
	{"rotation_speed": PI * 0.9},
	{"radius": 90},
	{"move_range": 120},
	{"move_speed": 0.7},
	{"rotation_speed": PI * 1.0},
	{"radius": 80},
	{"move_range": 130},
	{"move_speed": 0.6},
	{"rotation_speed": PI * 1.1},
	{"radius": 60},
	{"move_range": 140},
	{"move_speed": 0.5},
	{"rotation_speed": PI * 1.2},
	{"radius": 40},
	{"move_range": 150},
	{"move_speed": 0.4},
	{"rotation_speed": PI * 1.3},
	{"radius": 20},
	{"move_range": 160},
	{"move_speed": 0.3},
	{"rotation_speed": PI * 1.5},
	{"radius": 10},
	{"move_range": 180},
	{"move_speed": 0.3},
	{"rotation_speed": PI * 1.8},
	{"radius": 5},
	{"move_range": 200},
	{"move_speed": 0.2},
]
