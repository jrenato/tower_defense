class_name HurtBoxArea2D extends Area2D

## Emitted when receiving a hit.
signal hit_landed(damage: float)

enum TEAMS { PLAYER, ENEMY }
@export var team: TEAMS = TEAMS.PLAYER

# An entity may have some armor rating, reducing incoming damage.
@export var armor: float = 0.0


## Called by `HitBoxArea2D` when it interacts with this hurt box.
func get_hurt(damage: float) -> void:
	var final_damage: float = damage - armor
	hit_landed.emit(final_damage)
