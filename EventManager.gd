extends Node

signal car_exploded()
signal car_reached_goal()
signal score_updated(points: int)
signal lives_updated(num_lives: int)
signal demo_mode(enabled: bool)
signal free_mode(enabled: bool)
signal game_started()

var demo_mode_enabled: bool = false
var free_mode_enabled: bool = false
func _ready() -> void:
	demo_mode.connect(_on_demo_mode_changed)
	free_mode.connect(_on_free_mode_changed)
	demo_mode.emit(true)

func _on_free_mode_changed(enabled: bool) -> void:
	free_mode_enabled = enabled

func _on_demo_mode_changed(enabled: bool) -> void:
	demo_mode_enabled = enabled