extends AudioStreamPlayer2D
@export var random_pitch: bool = true
@export var random_pitch_range: Vector2 = Vector2(0.8, 1.2)

func _ready():
	var buttonParent:Button = get_parent()
	if(buttonParent):
		buttonParent.pressed.connect(play_random_pitch)
	if random_pitch:
		self.pitch_scale = randf_range(random_pitch_range.x, random_pitch_range.y)

func play_random_pitch():
	if random_pitch:
		self.pitch_scale = randf_range(random_pitch_range.x, random_pitch_range.y)
	play()
