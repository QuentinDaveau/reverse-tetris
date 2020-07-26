extends Particles2D

const SPARK_LIMIT: float = 800.0

func set_speed(speed: float) -> void:
	var particle_material: ParticlesMaterial = get_process_material()
	var speed_factor = (speed - SPARK_LIMIT) / 2000.0

	if not speed_factor > 0:
		emitting = false
		$SparkSound.volume_db = -80
		if $SparkSound.is_playing():
			$SparkSound.stop()
		return
	if not emitting:
		emitting = true
		$SparkSound.play()
	
	
	var spark_volume = sqrt(speed_factor * 1.2)
	if spark_volume > 0.85:
		spark_volume = 0.85
	
	$SparkSound.volume_db = (spark_volume - 1) * 80
	$SparkSound.pitch_scale = (spark_volume * 1.4) + 0.5
	
	
	lifetime = (0.5 / speed_factor)
	var particle_scale: float = (0.1 * speed_factor) + 0.1
	if particle_scale > 0.22:
		particle_scale = 0.22
	particle_material.set_param(ParticlesMaterial.PARAM_SCALE, 
			particle_scale)
	particle_material.set_param(ParticlesMaterial.PARAM_INITIAL_LINEAR_VELOCITY, 
			2000 * speed_factor)
