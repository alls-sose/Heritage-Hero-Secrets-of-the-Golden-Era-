extends XRToolsPickable

@onready var slots: Node3D = $Slots
@onready var nutribun_instance = preload("res://src/Assets/kitchen-assets/Nutribun.tscn")
var dough_slot_bool_1 : bool
var dough_slot_bool_2 : bool
var dough_slot_bool_3 : bool
var dough_slot_bool_4 : bool
var i_am_ready : bool 
var just_make_dis_happen_once : bool

signal nutribun_ready
signal all_dough_ready

func _ready() -> void:
	super()
	dough_slot_bool_1 = false
	dough_slot_bool_2 = false
	dough_slot_bool_3 = false
	dough_slot_bool_4 = false
	just_make_dis_happen_once = false
	
	
func _physics_process(delta: float) -> void:
	if dough_slot_bool_1 and dough_slot_bool_2 and dough_slot_bool_3 and dough_slot_bool_4 and not just_make_dis_happen_once:
		i_am_ready = true
		all_dough_ready.emit()
		just_make_dis_happen_once = true


func _spawn_finished_nutribuns():
	for hallo in slots.get_children():
		if is_instance_valid(hallo.current_object):
			hallo.current_object.queue_free()
		var nutribun = nutribun_instance.instantiate()
		self.get_parent().add_child(nutribun)
		nutribun.owner = get_tree().edited_scene_root
		hallo.group_required = "Nutribun"
		hallo._pick_up_object(nutribun)
		nutribun_ready.emit()


func _on_dough_slot_slot_picked_up() -> void:
	dough_slot_bool_1 = true

func _on_dough_slot_2_slot_picked_up() -> void:
	dough_slot_bool_2 = true

func _on_dough_slot_3_slot_picked_up() -> void:
	dough_slot_bool_3 = true

func _on_dough_slot_4_slot_picked_up() -> void:
	dough_slot_bool_4 = true
