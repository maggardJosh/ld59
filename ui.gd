extends CanvasLayer

func _ready():
	EventManager.score_updated.connect(score)
	EventManager.lives_updated.connect(lives_updated)
	EventManager.free_mode.connect(_on_free_mode_changed)

func _on_free_mode_changed(enabled: bool) -> void:
	$MarginContainer/VBoxContainer/Deaths.visible = not enabled

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
	var score_label = $MarginContainer/VBoxContainer/Score
	score_label.text = "Score: " + str(points)

func lives_updated(num_lives: int) -> void:
	var death_label = $MarginContainer/VBoxContainer/Deaths
	death_label.text = "Lives: " + str(num_lives)


func _on_standard_pressed() -> void:
	EventManager.demo_mode.emit(false)
	EventManager.free_mode.emit(false)
	$Title.visible = false
	$MarginContainer.visible = true


func _on_free_pressed() -> void:
	EventManager.demo_mode.emit(false)
	EventManager.free_mode.emit(true)
	$Title.visible = false
	$MarginContainer.visible = true
	
