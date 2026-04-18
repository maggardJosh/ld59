extends Node2D

@export var goals: Array[Node2D]
@export var carScene: PackedScene
@export var carSpawnerNodeParent: Node2D
@export var minCarSpawnTime: float = 1.0
@export var maxCarSpawnTime: float = 3.0

var carSpawners: Array[Node2D] = []

var timeToNextSpawn: float = 0.0

func _ready() -> void: 
	for carSpawner in carSpawnerNodeParent.get_children():
		carSpawners.append(carSpawner)
	timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)


func _process(delta: float) -> void:
	if carSpawners.size() == 0:
		return
	timeToNextSpawn -= delta
	if timeToNextSpawn <= 0.0:
		var spawner = carSpawners[randi() % carSpawners.size()]
		var car: Car = carScene.instantiate() 
		car.random_type()
		spawner.add_child(car)
		car.global_position = spawner.global_position 
		car.set_goal(goals[car.type])
		timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)
