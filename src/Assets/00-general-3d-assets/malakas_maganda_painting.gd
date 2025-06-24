extends Node3D
signal spray_done
signal wipe_done

@onready var wet_painting: MeshInstance3D = $WetPainting
@onready var progress_view: Node3D = $"Progress View"
@onready var painting_7: MeshInstance3D = $Painting7


func _on_wipe_rag_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	var percentage = total_progress / requirement
	progress_view.visible = true
	progress_view.change_progress_value(percentage*100)
	wet_painting.get_surface_override_material(0).albedo_color = Color(1,1,1,1-percentage)


func _on_wipe_rag_receiver_action_started(requirement: Variant, total_progress: Variant) -> void:
	progress_view.progress_idle_state()
