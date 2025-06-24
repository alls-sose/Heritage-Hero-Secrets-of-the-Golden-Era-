extends XRToolsPickable

@onready var slots: Node3D = $Slots

var dough_slot_bool_1 : bool
var dough_slot_bool_2 : bool
var dough_slot_bool_3 : bool
var dough_slot_bool_4 : bool
var i_am_ready : bool 
var just_make_dis_happen_once : bool


func _ready() -> void:
	super()
	dough_slot_bool_1 = false
	dough_slot_bool_2 = false
	dough_slot_bool_3 = false
	dough_slot_bool_4 = false
	just_make_dis_happen_once = false
	
	
func _physics_process(delta: float) -> void:
	if dough_slot_bool_1 and dough_slot_bool_2 and dough_slot_bool_3 and dough_slot_bool_4 and not just_make_dis_happen_once:
		print("nice")
		i_am_ready = true
		just_make_dis_happen_once = true


func _spawn_finished_nutribuns():
	for hallo in slots.get_children():
		if is_instance_valid(hallo.current_object):
			hallo._drop_current_slot_object()
		var nutribun = preload("res://src/Assets/kitchen-assets/Nutribun.tscn")
		hallo._pick_up_object(nutribun)


func _on_dough_slot_slot_picked_up() -> void:
	dough_slot_bool_1 = true

func _on_dough_slot_2_slot_picked_up() -> void:
	dough_slot_bool_2 = true

func _on_dough_slot_3_slot_picked_up() -> void:
	dough_slot_bool_3 = true

func _on_dough_slot_4_slot_picked_up() -> void:
	dough_slot_bool_4 = true
