extends Node2D
class_name Block

const SCORE_SPEED_INCREASE: float = 200.0

const MAX_REPULSE_DIST: float = 200.0
const MAX_SHAKE_DIST: float = 200.0
const REPULSE_POWER: float = 15.0
const CAMERA_SHAKE_POWER: float = 3.0

var _explode_delay: float = 0.2
var _move_speed: float = 0.2
var _repulse_displacement: Vector2 = Vector2.ZERO
var _repulse_shake: float = 0.0


func _process(delta: float) -> void:
	if _repulse_displacement.length() > 0.05:
		_repulse_displacement = lerp(_repulse_displacement, Vector2.ZERO, 0.08)
		$Sprite.position = _repulse_displacement
	if abs($Sprite.rotation) > 0.001:
		_repulse_shake = lerp(_repulse_shake, 0.0, 0.2)
		$Sprite.rotation = _repulse_shake


func highlight(highlight_color: Color) -> void:
	$Sprite.get_material().set_shader_param("HighlightColor", highlight_color)


func repulse(origin: Vector2) -> void:
	var shake_power := (MAX_SHAKE_DIST - origin.distance_to(global_position)) / MAX_SHAKE_DIST
	if shake_power <= 0:
		return
	randomize()
	_repulse_shake += (randf() - 0.5) * shake_power * PI/2
	$Sprite.rotation = _repulse_shake
	
	var power = (MAX_REPULSE_DIST - origin.distance_to(global_position)) / MAX_REPULSE_DIST
	if power <= 0:
		return
	_repulse_displacement += origin.direction_to(global_position) * REPULSE_POWER * power


func complete_spawn(wait_time: float) -> void:
	if wait_time > 0:
		$MoveTimer.start(wait_time)
		yield($MoveTimer, "timeout")
	$Sprite.visible = true


func update_position(new_position: Vector2, wait_time: float) -> void:
	if wait_time > 0:
		$MoveTimer.start(wait_time)
		yield($MoveTimer, "timeout")
	$Tween.interpolate_property(self, "global_position", global_position,
		new_position, _move_speed, Tween.TRANS_BACK, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:x", 1, 0.5, 
		_move_speed / 3, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "scale:x", 0.5, 1, 
		2 * _move_speed / 3, Tween.TRANS_BACK, Tween.EASE_OUT, _move_speed / 3)
	$TrailParticles.emitting = true
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$TrailParticles.emitting = false


func explode(explosion_color: Color, limit_left: float, limit_right: float, limit_bottom: float) -> void:
	$Light2D.color = explosion_color
	$ColorRect.color = explosion_color
	randomize()
	$ExplodeTimer.start(randf() * _explode_delay)
	yield($ExplodeTimer, "timeout")
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2.ZERO, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	ScoreManager.get_counter().add_speed(SCORE_SPEED_INCREASE)
	for block in get_tree().get_nodes_in_group("Block"):
		block.repulse(global_position)
	CameraManager.get_camera().add_shake(CAMERA_SHAKE_POWER)
	$ExplosionParticles.get_process_material().set_shader_param("max_left", limit_left)
	$ExplosionParticles.get_process_material().set_shader_param("max_right", limit_right)
	$ExplosionParticles.get_process_material().set_shader_param("max_bottom", limit_bottom)
	$Sprite.scale = Vector2.ONE * 0.5
	$Light2D.enabled = true
	$ColorRect.visible = true
	$ExplosionParticles.emitting = true
	$ExplodeTimer.start(0.05)
	yield($ExplodeTimer, "timeout")
	$DustParticles.emitting = true
	$Light2D.enabled = false
	$ColorRect.visible = false
	$Sprite.visible = false
	$ExplodeTimer.start($ExplosionParticles.lifetime)
	yield($ExplodeTimer, "timeout")
	queue_free()
