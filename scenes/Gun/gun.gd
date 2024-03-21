extends Node2D

class_name Gun

var player: Player
var bullets_layer: Node2D
var SMOOTHING: int = 35
var rot_deg: float

const RECOIL_LENGTH: int = 5

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var shoot_delay_timer: Timer = $ShootDelayTimer
@onready var muzzle_marker: Marker2D = $MuzzleMarker

var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	bullets_layer = get_tree().get_first_node_in_group("bullets_layer")
	if is_instance_valid(player):
		global_position = player.gun_position.global_position


func _physics_process(delta: float) -> void:
	if is_instance_valid(player):
		global_position = lerp(global_position, player.gun_position.global_position, SMOOTHING * delta)
		
		look_at(get_global_mouse_position())
		
		rot_deg = rad_to_deg(global_position.angle_to_point(get_global_mouse_position()))
		
		if rot_deg < -90 or rot_deg > 90:
			sprite_2d.flip_v = true
		else:
			sprite_2d.flip_v = false
	
		shoot_bullet()


func shoot_bullet() -> void:
	if Input.is_action_pressed("shoot") and shoot_delay_timer.is_stopped():
		shoot_delay_timer.start()
		if bullet_scene:
			var bullet: Bullet = bullet_scene.instantiate() as Bullet
			bullets_layer.add_child(bullet)
			bullet.global_position = muzzle_marker.global_position
			bullet.look_at(get_global_mouse_position())
			bullet.direction = (get_global_mouse_position() - bullet.global_position).normalized()
			recoil()


func recoil() -> void:
	global_position -= Vector2.RIGHT.rotated(rotation) * RECOIL_LENGTH
