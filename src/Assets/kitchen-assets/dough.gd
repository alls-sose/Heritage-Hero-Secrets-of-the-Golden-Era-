extends XRToolsPickable

@onready var progress_view: Node3D = $"Progress View"
@onready var cube: MeshInstance3D = $Nutribun/Cube
@onready var cube_2: MeshInstance3D = $Nutribun/Cube2
@onready var knead_receiver: OISWipeReceiver = $KneadReceiver
@onready var detach_receiver_collision_shape_3d: CollisionShape3D = $OISDetachReceiver/Area3D/CollisionShape3D

signal dough_kneaded


func _ready() -> void:
	super()
	detach_receiver_collision_shape_3d.disabled = true
	
func _on_knead_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.progress_complete_anim()
	cube.visible = false
	cube_2.visible = true
	detach_receiver_collision_shape_3d.disabled = false
	knead_receiver.queue_free()
	dough_kneaded.emit()

func _on_knead_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	var percentage = total_progress / requirement
	progress_view.visible = true
	progress_view.change_progress_value(percentage*100)
