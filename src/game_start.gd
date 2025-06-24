extends Event


func _on_main_game_started() -> void:
	emit_signal("event_ended")
	close_event()
