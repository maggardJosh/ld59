class_name Stoplight
extends AnimatedSprite2D

@export var navArea: NavigationRegion2D
@export var lightEnabled: bool = false
@export var stoplightFrameIndex: int = 0

signal light_changed(light:Stoplight, enabled: bool)

func _ready():
	update_light_enabled_status()


func update_light_enabled_status() -> void:
	self.frame = 1 if lightEnabled else 0

func set_light_enabled(enabled: bool) -> void:
	lightEnabled = enabled
	update_light_enabled_status()
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		lightEnabled = not lightEnabled
		light_changed.emit(self, lightEnabled)
		update_light_enabled_status()

