extends Event

@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var printing_press_teleporter = get_tree().get_root().get_node("Main/TeleporterManager/Study Room Printing Press")

func _on_ois_twist_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	printing_press_teleporter.teleporter_active = true
	printing_press_teleporter.get_parent()._set_teleporter_states() 
	emit_signal("event_ended")
	print("Gate Has Been Opened")
	animation_player.play("open_gate")
	close_event()
	QuestControl.add_active_quest("QuestCompletePrintingMachine")
	QuestControl.update_active_quests()
