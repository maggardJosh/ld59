extends Node2D

@export var goal:Node2D
@export var speed:float = 100
@onready var navAgent = $NavigationAgent2D

func _ready() -> void:
	navAgent.target_position = goal.global_position
	


func _physics_process(delta: float) -> void:
	

	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navAgent.get_navigation_map()) == 0:
		return
	if navAgent.is_navigation_finished():
		return

	var nextPos = navAgent.get_next_path_position()
	var dirTo = global_position.direction_to(nextPos)
	look_at(nextPos)
	self.global_position += dirTo * speed * delta
