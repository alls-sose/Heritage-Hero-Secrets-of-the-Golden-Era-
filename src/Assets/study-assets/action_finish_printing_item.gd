extends Event

@onready var final_teleporter = get_tree().get_root().get_node("Main/TeleporterManager/Final Teleporter")

func _on_printing_press_printer_printed() -> void:
	final_teleporter.visible = true
	final_teleporter.teleporter_active = true
	final_teleporter.teleporter_enabled = true
	final_teleporter.get_parent()._set_teleporter_states() 
	close_event()
	emit_signal("event_ended")
	QuestControl.add_active_quest("QuestLeaveTheMansion")
	QuestControl.update_active_quests()
