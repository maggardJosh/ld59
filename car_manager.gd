extends Node2D

@export var maxCars: int = 100
@export var carScene: PackedScene
@export var carSpawnerNodeParent: Node2D
@export var goals: Array[Node2D]

var minCarSpawnTime: float = 1.0
var maxCarSpawnTime: float = 3.0

@export var easyMinCarSpawnTime: float = 3.0
@export var easyMaxCarSpawnTime: float = 5.0
@export var hardMinCarSpawnTime: float = 0.5
@export var hardMaxCarSpawnTime: float = 1.5

@export var difficultyCurveTime: float = 60
@export var difficultyCurve: Curve


@export_flags_2d_physics var carCollisionMask: int

var carSpawners: Array[Node2D] = []
var timeToNextSpawn: float = 0.0
var carCount: int = 0
var cars: Array[Car] = []

@export var standard_lives: int = 10

var lives_left: int
func _ready() -> void: 
	lives_left = standard_lives
	EventManager.lives_updated.emit(lives_left)
	EventManager.score_updated.emit(0)
	EventManager.car_reached_goal.connect(on_car_reached_goal)
	EventManager.car_exploded.connect(on_car_exploded)
	EventManager.game_started.connect(_on_game_started)
	for carSpawner in carSpawnerNodeParent.get_children():
		carSpawners.append(carSpawner)
	update_difficulty()
	timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)

func _on_game_started() -> void:
	elapsed_time = 0
	lives_left = standard_lives
	EventManager.lives_updated.emit(lives_left)
	EventManager.score_updated.emit(0)
	for car in cars:
		car.queue_free()
		

func update_difficulty() -> void:
	var difficulty_tValue: float = difficultyCurve.sample(clamp(elapsed_time / difficultyCurveTime, 0, 1))
	minCarSpawnTime = easyMinCarSpawnTime + (hardMinCarSpawnTime - easyMinCarSpawnTime) * difficulty_tValue
	maxCarSpawnTime = easyMaxCarSpawnTime + (hardMaxCarSpawnTime - easyMaxCarSpawnTime) * difficulty_tValue
	print("Difficulty: " + str(difficulty_tValue) + " Spawn Time Range: " + str(minCarSpawnTime) + " - " + str(maxCarSpawnTime))

var elapsed_time: float = 0.0
func _process(delta: float) -> void:
	if carSpawners.size() == 0:
		return
	elapsed_time += delta
	timeToNextSpawn -= delta
	if timeToNextSpawn <= 0.0:
		spawn_car()
		update_difficulty()
		timeToNextSpawn = randf_range(minCarSpawnTime, maxCarSpawnTime)

var score: int = 0
func on_car_reached_goal() -> void:
	score+=100
	EventManager.score_updated.emit(score)

func on_car_exploded() -> void:
	lives_left -= 1
	EventManager.lives_updated.emit(lives_left)

func on_car_destroyed(car:Car) -> void:
	carCount -= 1
	cars.remove_at(cars.find(car))

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
		car.tree_exited.connect(on_car_destroyed.bind(car))
		car.global_position = spawner.global_position 
		car.set_goal(goals[car.type])
		cars.append(car)
		carCount += 1
		return
