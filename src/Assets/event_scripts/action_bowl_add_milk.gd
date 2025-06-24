extends Event
@onready var powder_add_player: AudioStreamPlayer3D = $"../../PowderAddPlayer"
func _on_ois_milk_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	close_event()
	powder_add_player.play()
	emit_signal("event_ended")
	QuestControl.update_active_quests()
