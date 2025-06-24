extends XRToolsPickable

@onready var bowl_main = get_parent()
@onready var ois_detach_receiver: OISDetachReceiver = $OISDetachReceiver

func _ready() -> void:
	super()
	if is_instance_valid(bowl_main):
		print("hell yeah")
		

func _on_ois_detach_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	if requirement >= ois_detach_receiver.requirement:
		if is_instance_valid(bowl_main):
			bowl_main.split_counter +=1
