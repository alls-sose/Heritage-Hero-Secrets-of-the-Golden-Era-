extends XRToolsPickable

@onready var printed_items_control: Control = $Document/Viewport2Din3D/Viewport/PrintedThings/Control

func _on_visibility_changed() -> void:
	# check items when item is set to visible
	printed_items_control.check_items()
