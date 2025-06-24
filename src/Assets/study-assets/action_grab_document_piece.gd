extends Event


func _on_doc_pickable_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		close_event()
