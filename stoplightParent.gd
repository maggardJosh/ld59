extends Node2D

var stoplights: Array[Stoplight]
func _enter_tree() -> void:
	EventManager.demo_mode.connect(_on_demo_mode_changed)

func _on_demo_mode_changed(enabled: bool) -> void:
	for stoplight in stoplights:
		stoplight.set_light_enabled(false)
	if enabled:
		plan_auto_light_change()

var time_to_next_change = 0.0
func plan_auto_light_change() -> void:
	time_to_next_change = randf_range(2.0, 5.0)

func _ready():
	for child in get_children():
		if child is Stoplight and child.visible:
			child.light_changed.connect(_on_light_changed)
			stoplights.append(child)

func _process(delta: float) -> void:
	if EventManager.demo_mode_enabled:
		time_to_next_change -= delta
		if time_to_next_change <= 0:
			var random_stoplight = stoplights[randi() % stoplights.size()]
			random_stoplight.set_light_enabled(true)
			_on_light_changed(random_stoplight, true)
			plan_auto_light_change()

func _on_light_changed(stoplight_changed: Stoplight, enabled: bool) -> void:
	if enabled:
		for stoplight in stoplights:
			if stoplight != stoplight_changed:
				stoplight.set_light_enabled(false)
