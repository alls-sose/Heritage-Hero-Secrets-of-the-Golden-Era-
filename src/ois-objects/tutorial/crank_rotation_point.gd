extends Marker3D

@export var axis : Vector3 = Vector3(1, 0, 0)
var init_transform
var hand_init_transform

@onready var hand = $Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_transform = self.transform.basis
	hand_init_transform = hand.transform.basis
	

func _on_ois_crank_receiver_action_in_progress(_requirement: Variant, total_progress: Variant) -> void:
	print("THIS IS HAPPENING")
	self.transform.basis = init_transform
	print(total_progress)
	self.set_rotation_degrees(axis * total_progress * -360)
	hand.set_rotation_degrees(axis * total_progress * 360)
	

func _on_ois_crank_receiver_action_ended(_requirement: Variant, _total_progress: Variant) -> void:
	self.transform.basis = init_transform
	hand_init_transform = hand.transform.basis


func _on_ois_crank_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	pass # Replace with function body.
