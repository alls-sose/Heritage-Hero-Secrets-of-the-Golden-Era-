extends Event


func _on_bowl_main_mix_3_done() -> void:
	print("MIX 3 DONE")
	close_event()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
