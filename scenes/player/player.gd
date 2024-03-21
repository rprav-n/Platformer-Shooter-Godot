extends CharacterBody2D

class_name Player

const SPEED: int = 250
const ACCELERATION: int = 1300
const DECELERATION: int = 1600
const GRAVITY: int = 1600
const JUMP_SPEED: int = -600

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var gun_position: Marker2D = $GunPosition


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_movement(delta)
	handle_jump()
	move_and_slide()
	update_animation()


func apply_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta
	

func get_movement_direction() -> float:
	return Input.get_axis("move_left", "move_right")


func handle_movement(delta: float) -> void:
	var direction: float = get_movement_direction()
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_SPEED


func update_animation() -> void:
	if velocity.x != 0:
		animated_sprite_2d.flip_h = true if velocity.x < 0 else false
	
	if is_on_floor():
		if velocity.x != 0:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("air")
		animated_sprite_2d.frame = 0 if velocity.y < 0 else 1
