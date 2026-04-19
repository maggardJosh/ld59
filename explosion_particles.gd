extends CPUParticles2D

func _ready() -> void:
	self.finished.connect(_on_finished)

func _on_finished() -> void:
	self.queue_free()