extends Node2D

class_name Bullet

const SPEED: int = 40

var direction: Vector2 = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	global_position += direction * SPEED


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
