class_name Weapon2D extends Node2D

signal fired

@export var bullet_scene: PackedScene
## Range of the weapon in pixels.
@export var fire_range: float = 200.0: set = set_fire_range
## Cooldown in seconds to fire again
@export var fire_cooldown: float = 1.0

@onready var _bullet_spawn_position: Marker2D = %BulletSpawnPosition2D
@onready var _cooldown_timer: Timer = %CooldownTimer
@onready var _range_area: Area2D = %RangeArea2D
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _range_shape: CollisionShape2D = %CollisionShape2D


# Ensures that the `_range_shape` has its radius up to date
func _ready() -> void:
	set_fire_range(fire_range)


func _physics_process(delta: float) -> void:
	if not _cooldown_timer.is_stopped():
		return

	var targets: Array = _range_area.get_overlapping_areas()

   # Returns if the list of available targets is empty
	if targets.is_empty():
		return

	var target: Node2D = targets[0]
	shoot_at(target.global_position)


# Syncs the fire_range value with the _range_shape radius
func set_fire_range(new_range: float) -> void:
	fire_range = new_range

  # Awaits for the Weapon to be ready to access the _range_shape
  # This allows us to set the fire_range through the Inspector.
	if not is_inside_tree():
		await ready

	_range_shape.radius = fire_range


func shoot_at(target_position: Vector2) -> void:
  # Rotates the Weapon to face the target's position
	look_at(target_position)
	_animation_player.play("shoot")

  # Creates an instance of the bullet_scene at the _bullet_spawn_position
	var bullet = bullet_scene.instance()
	add_child(bullet)
	bullet.global_position = _bullet_spawn_position.global_position

	  # Fires the bullet towards the target's position
	bullet.fly_to(target_position)

	_cooldown_timer.start(fire_cooldown)
	fired.emit()
