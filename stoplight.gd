class_name Stoplight
extends AnimatedSprite2D

@export var navArea: NavigationRegion2D
@export var lightEnabled: bool = false

func _ready():
	update_light_enabled_status()

func update_light_enabled_status() -> void:
	#navArea.enabled = lightEnabled	
	self.frame = 1 if lightEnabled else 0


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		lightEnabled = not lightEnabled
		update_light_enabled_status()

