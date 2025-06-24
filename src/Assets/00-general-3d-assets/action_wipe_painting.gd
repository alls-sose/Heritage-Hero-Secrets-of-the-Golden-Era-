extends Event

@onready var wet_painting: MeshInstance3D = $"../WetPainting"
@onready var progress_view: Node3D = $"../Progress View"
@onready var painting_7: MeshInstance3D = $"../Painting7"
@onready var WIPE_collision_shape_3d: CollisionShape3D = $"../WipeRagReceiver/Area3D/CollisionShape3D"

func _on_wipe_rag_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.progress_complete_anim()
	wet_painting.visible = false
	emit_signal("event_ended")
	WIPE_collision_shape_3d.disabled = true
	close_event()
	QuestControl.update_active_quests()
	
