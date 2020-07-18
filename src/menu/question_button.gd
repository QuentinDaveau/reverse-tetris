extends TextureButton


onready var _commands_panel = owner.get_node("CommandsPanel")


func _on_TextureButton_mouse_entered() -> void:
	_commands_panel.set_visibility(true)


func _on_TextureButton_mouse_exited() -> void:
	_commands_panel.set_visibility(false)
