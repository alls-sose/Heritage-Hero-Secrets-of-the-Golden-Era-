extends Event

@onready var wet_painting: MeshInstance3D = $"../WetPainting"
@onready var progress_view: Node3D = $"../Progress View"
@onready var painting_7: MeshInstance3D = $"../Painting7"
@onready var collision_shape_3d: CollisionShape3D = $"../WipeRagReceiver/Area3D/CollisionShape3D"

func _on_spray_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	wet_painting.visible = true
	painting_7.visible = false
	collision_shape_3d.disabled = false
	emit_signal("event_ended")
	close_event()
