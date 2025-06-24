extends Event


func _on_crowbar_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		emit_signal("event_ended")
		QuestControl.update_active_quests()
		close_event()
