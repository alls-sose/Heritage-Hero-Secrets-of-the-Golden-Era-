extends Node

@onready var collision_shape_3d: CollisionShape3D = $"../CollisionShape3D"
@onready var grab_point_hand_right: XRToolsGrabPointHand = $"../GrabPointHandRight"
@onready var grab_point_hand_left: XRToolsGrabPointHand = $"../GrabPointHandLeft"
@onready var ois_actor_component: OISActorComponent = $"../OISActorComponent"
@onready var ois_receiver_component: Node3D = $"../OISReceiverComponent"


func configure_collision_and_hand(piece1 : Variant, piece2 : Variant) -> void:
	var p1_min_x = piece1.get_node("CollisionShape3D").position.x - (piece1.get_node("CollisionShape3D").shape.size.x / 2)
	var p1_max_x = piece1.get_node("CollisionShape3D").position.x + (piece1.get_node("CollisionShape3D").shape.size.x / 2)
	var p1_min_z = piece1.get_node("CollisionShape3D").position.z - (piece1.get_node("CollisionShape3D").shape.size.z / 2)
	var p1_max_z = piece1.get_node("CollisionShape3D").position.z + (piece1.get_node("CollisionShape3D").shape.size.z / 2)
	
	var p2_min_x = piece2.get_node("CollisionShape3D").position.x - (piece2.get_node("CollisionShape3D").shape.size.x / 2)
	var p2_max_x = piece2.get_node("CollisionShape3D").position.x + (piece2.get_node("CollisionShape3D").shape.size.x / 2)
	var p2_min_z = piece2.get_node("CollisionShape3D").position.z - (piece2.get_node("CollisionShape3D").shape.size.z / 2)
	var p2_max_z = piece2.get_node("CollisionShape3D").position.z + (piece2.get_node("CollisionShape3D").shape.size.z / 2)
	
	var min_x = min(p1_min_x, p2_min_x)
	var max_x = max(p1_max_x, p2_max_x)
	var min_z = min(p1_min_z, p2_min_z)
	var max_z = max(p1_max_z, p2_max_z)
	
	collision_shape_3d.position.x = (min_x + max_x) / 2.0
	collision_shape_3d.position.z = (min_z + max_z) / 2.0
	
	collision_shape_3d.shape.size.x = abs(max_x - min_x)
	collision_shape_3d.shape.size.z = abs(max_z - min_z)
	collision_shape_3d.shape.size.y = 0.001
	
	var p1_grab_left = piece1.get_node("GrabPointHandLeft")
	var p1_grab_right = piece1.get_node("GrabPointHandRight")
	var p2_grab_left = piece2.get_node("GrabPointHandLeft")
	var p2_grab_right = piece2.get_node("GrabPointHandRight")
	
	grab_point_hand_left.position = Vector3(min(p1_grab_left.position.x, p2_grab_left.position.x), -0.066, max(p1_grab_left.position.z, p2_grab_left.position.z))
	grab_point_hand_right.position = Vector3(max(p1_grab_right.position.x, p2_grab_right.position.x), -0.066, max(p1_grab_right.position.z, p2_grab_right.position.z))
