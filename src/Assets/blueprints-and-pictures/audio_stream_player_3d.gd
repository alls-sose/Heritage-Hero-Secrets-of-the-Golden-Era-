extends AudioStreamPlayer3D


func _on_picture_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsSnapZone:
		play()
