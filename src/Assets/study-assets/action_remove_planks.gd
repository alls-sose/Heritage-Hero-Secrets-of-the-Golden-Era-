extends Event

@onready var bedroom_teleporter = get_tree().get_root().get_node("Main/TeleporterManager/Bedroom Broken Wall")

func _on_wooden_planks_planks_cleared() -> void:
	print(bedroom_teleporter)
	bedroom_teleporter.teleporter_active = true
	bedroom_teleporter.get_parent()._set_teleporter_states() 
	emit_signal("event_ended")
	close_event()
	QuestControl.update_active_quests()
