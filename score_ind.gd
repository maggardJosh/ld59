extends Control

@onready var animPlayer:AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animPlayer.play("float")
	animPlayer.animation_finished.connect(_on_anim_finished)
	
func _on_anim_finished(animName: String) -> void:
	queue_free()