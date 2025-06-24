extends XRToolsPickable

@onready var plastic_cover: MeshInstance3D = $PlasticCover
@onready var ois_plastic_receiver: OISWipeReceiver = $OISPlasticReceiver

func _ready() -> void:
	super()
	plastic_cover.visible = false
	
func _set_plastic_visible() -> void:
	plastic_cover.visible = true
	add_to_group("nutribun_sealed")

func _on_ois_plastic_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	_set_plastic_visible()
	ois_plastic_receiver.interacting_object.queue_free()
	
