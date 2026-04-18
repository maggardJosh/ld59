extends Node2D

@export var maxCars: int = 100
@export var carScene: PackedScene
@export var carSpawnerNodeParent: Node2D
@export var goals: Array[Node2D]
@export var minCarSpawnTime: float = 1.0
@export var maxCarSpawnTime: float = 3.0
@export_flags_2d_physics var carCollisionMask: int

var carSpawners: Array[Node2D] = []
var timeToNextSpawn: float = 0.0
var carCount: int = 0

	
func _ready() -> void: 
	for carSpawner in carSpawnerNodeParent.get_children():
		carSpawners.append(carSpawner)
	timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)

func _process(delta: float) -> void:
	if carSpawners.size() == 0:
		return
	timeToNextSpawn -= delta
	if timeToNextSpawn <= 0.0:
		spawn_car()
		timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)

func on_car_destroyed() -> void:
	carCount -= 1

func spawn_car() -> void:
	if carCount >= maxCars:
		return
	var max_tries = 10;
	var tries = 0
	while tries < max_tries:
		var spawn_index = randi() % carSpawners.size()
		var spawner = carSpawners[spawn_index]
		var spawnPoint = spawner.global_position
		
		var pp = PhysicsPointQueryParameters2D.new()
		pp.collide_with_areas = true
		pp.position = spawnPoint
		pp.collision_mask = carCollisionMask

		var res = get_world_2d().direct_space_state.intersect_point(pp, 1)
		if(res):
			tries+=1
			continue

		var car: Car = carScene.instantiate() 
		car.random_type()
		spawner.add_child(car)
		car.tree_exited.connect(on_car_destroyed)
		car.global_position = spawner.global_position 
		car.set_goal(goals[car.type])
		carCount += 1
		return
