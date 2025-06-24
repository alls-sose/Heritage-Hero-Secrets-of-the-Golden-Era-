extends OISReceiverComponent

@export var buffer : float = 0.1
@export var replacement_object_path : String
var interacting_initial_pos : Vector3

var is_attached : bool = false
var attached_to : Variant = null

@onready var malakas_maganda_doc := $"../MalakasAtMagandaDoc"
@onready var malakas_maganda_control: Node = $"../MalakasMagandaControl"


func initialize_action_vars():
	interacting_initial_pos = interacting_object.position


func action_ongoing(delta: float) -> void:
	print("ACTION IS ONGOING")
	if not is_attached:
		if interacting_actor.get_parent().has_node("MalakasAtMagandaDoc"):
			print("IT HAS MALAKAS AT MAGANDA")
			if self.position.distance_to(interacting_actor.position) < buffer and not interacting_actor.actor_state_machine.controller.has_node("LeftHand"):
				if malakas_maganda_doc.check_neighbors(interacting_actor.get_parent().get_node("MalakasAtMagandaDoc")):
					is_attached = true
					attached_to = interacting_object 
					var replacement_object = load(replacement_object_path)
					var new_object = replacement_object.instantiate()
					new_object.get_node("MalakasAtMagandaDoc").active_pieces = malakas_maganda_doc.get_combined_active_pieces(interacting_actor.get_parent().get_node("MalakasAtMagandaDoc"))
					get_parent().get_parent().add_child(new_object)
					new_object.get_node("MalakasAtMagandaDoc").initialize_active_pieces()
					new_object.get_node("MalakasMagandaControl").configure_collision_and_hand(get_parent(), interacting_actor.get_parent())
					new_object.get_node("MalakasAtMagandaDoc").check_completed()
					interacting_actor.actor_state_machine.controller.get_node("FunctionPickup")._pick_up_object(new_object)
					
					get_parent().queue_free()
					attached_to.queue_free()
					print("YAY Attached the Objects")
	#var interacting_current_pos = interacting_object.position
	#
	#var delta_dist = interacting_initial_pos.distance_to(interacting_current_pos)
	#
	#interacting_initial_pos = interacting_current_pos
	#
	#if (delta_dist > buffer):
		#total_progress += rate * delta
	#
	#print("=======================")
	#print("Total progress: "+str(total_progress))
	#print("=======================\n")
	
		super(delta)
