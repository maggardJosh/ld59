extends CanvasLayer

func _ready():
	EventManager.score_updated.connect(score)
	EventManager.lives_updated.connect(lives_updated)
	EventManager.free_mode.connect(_on_free_mode_changed)
	EventManager.game_started.connect(_on_game_started)

func _on_free_mode_changed(enabled: bool) -> void:
	$MarginContainer/VBoxContainer/Control/Deaths.visible = not enabled

func _on_game_started() -> void:
	game_time = 0
var game_time: float
func _process(delta):
	if EventManager.demo_mode_enabled:
		return
	game_time += delta
	$MarginContainer/Time.text = get_converted_time(int(game_time))

func get_converted_time(time: int) -> String:
	var minutes: int = floor(time / 60.0)
	var seconds: int = time - minutes * 60
	var time_string: String = "%02d:%02d" % [minutes, seconds]
	return time_string

func score(points: int) -> void:
	var score_label = $MarginContainer/VBoxContainer/Control2/Score
	var animPlayer = $MarginContainer/VBoxContainer/Control2/Score/AnimationPlayer
	animPlayer.stop()
	animPlayer.play("pulse")
	score_label.text = "Score: " + str(points)

func lives_updated(num_lives: int) -> void:
	var death_label = $MarginContainer/VBoxContainer/Control/Deaths
	var animPlayer = $MarginContainer/VBoxContainer/Control/Deaths/AnimationPlayer
	animPlayer.stop()
	animPlayer.play("pulse")
	death_label.text = "Lives: " + str(num_lives)
	if (not EventManager.free_mode_enabled and not EventManager.demo_mode_enabled) and num_lives <= 0:
		$GameOver.visible = true
		$MarginContainer.visible = false
		$GameOver/VBoxContainer/Score.text = "Time: " + get_converted_time(int(game_time)) + "\nFinal Score: " + $MarginContainer/VBoxContainer/Score.text
		EventManager.demo_mode.emit(true)


func _on_standard_pressed() -> void:
	EventManager.demo_mode.emit(false)
	EventManager.free_mode.emit(false)
	EventManager.game_started.emit()
	$Title.visible = false
	$MarginContainer.visible = true
	$GameOver.visible = false


func _on_free_pressed() -> void:
	EventManager.demo_mode.emit(false)
	EventManager.free_mode.emit(true)
	EventManager.game_started.emit()
	$Title.visible = false
	$MarginContainer.visible = true
	$GameOver.visible = false
	
