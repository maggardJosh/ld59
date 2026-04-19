extends CanvasLayer

func _ready():
	EventManager.score_updated.connect(score)
	EventManager.lives_updated.connect(lives_updated)

var game_time: float
func _process(delta):
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
