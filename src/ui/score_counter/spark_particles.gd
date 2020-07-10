extends Particles2D

const SPARK_LIMIT: float = 800.0

func set_speed(speed: float) -> void:
	var particle_material: ParticlesMaterial = get_process_material()
	var speed_factor = (speed - SPARK_LIMIT) / 2000.0

	if not speed_factor > 0:
		emitting = false
		return
	if not emitting:
		emitting = true
	
	lifetime = (0.5 / speed_factor)
	var particle_scale: float = (0.15 * speed_factor) + 0.1
	if particle_scale > 0.3:
		particle_scale = 0.3
	particle_material.set_param(ParticlesMaterial.PARAM_SCALE, 
			particle_scale)
	particle_material.set_param(ParticlesMaterial.PARAM_INITIAL_LINEAR_VELOCITY, 
			2000 * speed_factor)
