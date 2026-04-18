extends Node2D

var stoplights: Array[Stoplight]

func _ready():
	for child in get_children():
		if child is Stoplight:
			child.light_changed.connect(_on_light_changed)
			stoplights.append(child)


func _on_light_changed(stoplight_changed: Stoplight, enabled: bool) -> void:
	if enabled:
		for stoplight in stoplights:
			if stoplight != stoplight_changed:
				stoplight.set_light_enabled(false)
