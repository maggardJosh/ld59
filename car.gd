class_name Car
extends Node2D

@onready var navAgent = $NavigationAgent2D
@export_flags_2d_physics var light_collision_mask: int
@export var type: int = 0

@export var carTextures: Array[Texture2D]
@export var minCarSpeed: float = 50
@export var maxCarSpeed: float = 150

@export var carMaxIdleTime: float = 20
@export var carStartIdleWarningTime: float = 15

@export var explosionScene: PackedScene

@onready var sprite = $Sprite2D
var next_light_enabled = true
var stopped_at_light = false
var next_light: Stoplight

var car_ahead_of_us = false
var speed: float = 100
var max_speed: float = 100
var idle_time: float = 0.0
@export var acc: float = 20.0
func _ready() -> void:
	sprite.texture = carTextures[type]
	max_speed = randf_range(minCarSpeed, maxCarSpeed)

func random_type() -> void:
	type = randi() % carTextures.size()

func set_goal(new_goal: Node2D) -> void:
	navAgent.target_position = new_goal.global_position
	
var last_nav_pos: Vector2

func explode() -> void:
	var explosion = explosionScene.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = self.global_position
	explosion.emitting = true
	self.queue_free()

func _physics_process(delta: float) -> void:
	if speed < .1:
		idle_time += delta
		if idle_time >= carMaxIdleTime:
			explode()
			return
	else:
		idle_time = 0.0
	

	var idle_danger_tValue:float = clamp((idle_time - carStartIdleWarningTime) / (carMaxIdleTime - carStartIdleWarningTime), 0, 1)
	

	var scaleX = 1.0 + randf_range(-.02, .02) + randf_range(-.4, .4) * idle_danger_tValue
	var scaleY = 1.0 + randf_range(-.01, .01) + randf_range(-.3, .3) * idle_danger_tValue
	sprite.scale = Vector2(scaleX, scaleY)

	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(navAgent.get_navigation_map()) == 0:
		return
	if navAgent.is_navigation_finished():
		self.queue_free()
		return

	var nextPos = navAgent.get_next_path_position()
	if nextPos != last_nav_pos:
		if not next_light_enabled:
			stopped_at_light = true
		else:
			var pp = PhysicsPointQueryParameters2D.new()
			pp.collide_with_areas = true
			pp.position = nextPos
			pp.collision_mask = light_collision_mask

			var res = get_world_2d().direct_space_state.intersect_point(pp, 1)
			if(res):
				next_light = res[0].collider.get_parent()
			else:
				next_light = null

		last_nav_pos = nextPos

	if next_light:
		next_light_enabled = next_light.lightEnabled
	if (stopped_at_light and not next_light_enabled) or car_ahead_of_us:
		speed *= .8
		return
	if stopped_at_light:
		next_light = null
		stopped_at_light = false

	var dirTo = global_position.direction_to(nextPos)
	look_at(nextPos)
	speed = move_toward(speed, max_speed, acc * delta)
	self.global_position += dirTo * speed * delta


func _on_area_2d_2_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	car_ahead_of_us = true


func _on_area_2d_2_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:	
	car_ahead_of_us = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 2 and event.is_pressed():
		explode()
