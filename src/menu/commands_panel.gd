extends Sprite

const DURATION: float = 0.1


func set_visibility(show: bool = true) -> void:
	if show:
		$Tween.stop_all()
		$Tween.interpolate_property(get_material(), "shader_param/amountHidden",
				get_material().get_shader_param("amountHidden"), 0,
				DURATION - ((1 - get_material().get_shader_param("amountHidden")) * DURATION),
				Tween.TRANS_QUART, Tween.EASE_OUT)
		$Tween.start()
	else:
		$Tween.stop_all()
		$Tween.interpolate_property(get_material(), "shader_param/amountHidden",
				get_material().get_shader_param("amountHidden"), 1,
				DURATION - (get_material().get_shader_param("amountHidden") * DURATION),
				Tween.TRANS_QUART, Tween.EASE_OUT)
		$Tween.start()
