extends GutTest

const hit_box_scene = preload("res://Objects/HitBox/hit_box_area_2d.tscn")
const hurt_box_scene = preload("res://Objects/HurtBox/hurt_box_area_2d.tscn")

var hit_box: HitBoxArea2D
var hurt_box: HurtBoxArea2D


func before_all():
	hit_box = hit_box_scene.instantiate()
	add_child(hit_box)
	hit_box.team = HitBoxArea2D.TEAMS.PLAYER
	var hit_box_collision_shape: CollisionShape2D = CollisionShape2D.new()
	hit_box.add_child(hit_box_collision_shape)
	hit_box_collision_shape.shape = CircleShape2D.new()
	hit_box_collision_shape.shape.radius = 50.0

	hurt_box = hurt_box_scene.instantiate()
	add_child(hurt_box)
	hurt_box.team = HurtBoxArea2D.TEAMS.PLAYER
	var hurt_box_collision_shape: CollisionShape2D = CollisionShape2D.new()
	hurt_box.add_child(hurt_box_collision_shape)
	hurt_box_collision_shape.shape = RectangleShape2D.new()
	hurt_box_collision_shape.shape.extents = Vector2(50.0, 50.0)

	hit_box.global_position = hurt_box.global_position + Vector2(0, -500)


func test_hit_box_not_hit_hurt_box_because_distant():
	hurt_box.team = HurtBoxArea2D.TEAMS.ENEMY
	hit_box.global_position = hurt_box.global_position + Vector2(0, -500)
	await wait_frames(1)

	watch_signals(hurt_box)

	assert_signal_not_emitted(hurt_box, 'hit_landed')


func test_hit_box_not_hit_hurt_box_because_same_team():
	hit_box.global_position = hurt_box.global_position + Vector2(0, -500)
	hurt_box.team = HurtBoxArea2D.TEAMS.PLAYER
	await wait_frames(1)

	watch_signals(hurt_box)

	hit_box.global_position = hurt_box.global_position + Vector2(0, -10)
	await wait_frames(1)

	assert_signal_not_emitted(hurt_box, 'hit_landed')


func test_hit_box_hit_hurt_box():
	hit_box.global_position = hurt_box.global_position + Vector2(0, -500)
	await wait_frames(1)
	hurt_box.team = HurtBoxArea2D.TEAMS.ENEMY

	watch_signals(hurt_box)

	hit_box.global_position = hurt_box.global_position + Vector2(0, -10)
	await wait_frames(1)

	assert_signal_emitted(hurt_box, 'hit_landed')
