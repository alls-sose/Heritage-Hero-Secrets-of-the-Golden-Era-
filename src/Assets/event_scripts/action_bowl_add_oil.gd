extends Event

@onready var add_oil_player: AudioStreamPlayer3D = $"../../AddOilPlayer"

func _on_ois_oil_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	close_event()
	add_oil_player.play()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
