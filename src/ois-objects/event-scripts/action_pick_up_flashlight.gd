extends Event

@onready var flashlight := get_parent()

func _on_event_started() -> void:
	flashlight.grabbed.connect(_on_ois_flashlight_radio_grabbed)


func _on_ois_flashlight_radio_grabbed(pickable: Variant, by: Variant) -> void:
	if by is XRToolsFunctionPickup:
		emit_signal("event_ended")
	
		print("-----------------------------------------")
		print("EVENT ENDED: " + event_name)
		print("-----------------------------------------")
		
		QuestControl.update_active_quests()
		close_event()
