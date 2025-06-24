extends Event

@onready var teleporter_manager: TeleporterManager = $"../../TeleporterManager"


func _on_event_started() -> void:
	teleporter_manager.location_changed.connect(_on_teleporter_manager_location_changed)

func _on_teleporter_manager_location_changed(location_name: Variant) -> void:
	if location_name == "Sofas":
		close_event()
