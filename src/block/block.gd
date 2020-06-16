extends Node2D
class_name Block

const MAX_REPULSE_DIST: float = 150.0
const REPULSE_POWER: float = 15.0

var _explode_delay: float = 0.2
var _move_speed: float = 0.2
var _repulse_displacement: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	if _repulse_displacement.length() < 0.05:
		return
	_repulse_displacement = lerp(_repulse_displacement, Vector2.ZERO, 0.08)
	$Sprite.position = _repulse_displacement


func repulse(origin: Vector2) -> void:
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
	randomize()
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


func explode() -> void:
	randomize()
	$ExplodeTimer.start(randf() * _explode_delay)
	yield($ExplodeTimer, "timeout")
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale, Vector2.ZERO, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
	for block in get_tree().get_nodes_in_group("Block"):
		block.repulse(global_position)
	
	$Sprite.scale = Vector2.ONE * 0.5
	$Light2D.enabled = true
	$ColorRect.visible = true
	$ExplosionParticles.emitting = true
	$ExplodeTimer.start(0.05)
	yield($ExplodeTimer, "timeout")
#	$TrailParticles.process_material.lifetime_randomness = 1.0
#	$TrailParticles.amount = 20
#	$TrailParticles.lifetime = 0.5
#	$TrailParticles.one_shot = true
#	$TrailParticles.explosiveness = 1
#	$TrailParticles.emitting = true
	$DustParticles.emitting = true
	$Light2D.enabled = false
	$ColorRect.visible = false
	$Sprite.visible = false
	$ExplodeTimer.start($ExplosionParticles.lifetime)
	yield($ExplodeTimer, "timeout")
	queue_free()
