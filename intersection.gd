extends Node2D

@export var top_light: Stoplight
@export var right_light: Stoplight
@export var bottom_light: Stoplight
@export var left_light: Stoplight

@export var top_light_exists: bool = true
@export var right_light_exists: bool = true
@export var bottom_light_exists: bool = true
@export var left_light_exists: bool = true

func _ready():
	top_light.visible = top_light_exists
	right_light.visible = right_light_exists
	bottom_light.visible = bottom_light_exists
	left_light.visible = left_light_exists
