extends Node3D

@export_category("Player Options")
@export var xr_anchor_to_object: Node3D
@export var xr_camera_anchor: Node3D
@export var dialogue_button_hand : XRController3D
@export var dialogue_button : String
@export var local_transform_adjustment : Vector3
@export var slots_distance_to_player : float = 0.75
@export var height_adjustment : float = 1.4
@export var dialogue_toggler_hand : XRController3D
@export var dialogue_toggler_button : String

@export var audio_node : AudioStreamPlayer3D
@export var desktop_node : CanvasLayer


var dialogue_button_pressed : bool
var finish_dialogue_scroll : bool
@export var anchored_ui_scale : float = 1

signal button_pressed
signal dialogue_array_complete
signal complete_line_scroll
signal complete_line_scroll_nonclick


#@export_category("Testing Options")
#@export var test_anchored_item : Node3D
#@export var text_duration : float
#@export var string : String = "UMMMM.... UMMM... harro?? yes.. BENIHANA TERIYAKI HIBACHI"
#@export var npcname : String = "hehe xd!!"
#@onready var mesh_instance_3d: MeshInstance3D = $"../MeshInstance3D"
#@onready var mesh_instance_3d_2: MeshInstance3D = $"../MeshInstance3D2"

var anchored_ui := preload("res://src/dialogue-system/dialogue_anchored_ui.tscn")
var viewport_2d_in_3d := preload("res://addons/godot-xr-tools/objects/viewport_2d_in_3d.tscn")
const DRAW_ON_TOP_MATERIAL = preload("res://src/dialogue-system/draw_on_top_material.tres")

var timer_set : float
var timer_set_bool : bool
var test_time := Timer.new()

var string_array : Array
var anchor_for_array : Node3D
var npc_name_for_array : String
var clickable_param_for_array : bool
var line_counter : int

var dialogue_progressed : bool

@onready var main_viewport: Node3D = $"Main Viewport"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	test_time.one_shot = true
	add_child(test_time) 
	
	dialogue_button_hand.button_pressed.connect(_dialogue_progress_pressed)
	
	#await get_tree().create_timer(1).timeout
	#_print_dialogue("stringasdasdad", "nyarccj", 3, mesh_instance_3d, false ,false)
	#_print_dialogue("Ah, KUROMI !! How cool? Yeah, look at me!","Kuromi", 4, mesh_instance_3d_2, false, false)
	#_print_dialogue("Ling gang, goolie goolie goolie goolie watcha ling gang goo ling gang goo","CANDYYY UMAK lmao", 15, null, false, false)

	
func _initialize_anchored_dialogue(anchored_item_node : Node3D) -> void:
	var new_visible_on_screen_notifier = VisibleOnScreenNotifier3D.new()
	new_visible_on_screen_notifier.set_aabb(AABB(Vector3(-0.1,-0.1,-0.1),Vector3(0.2,0.2,0.2)))
	new_visible_on_screen_notifier.name = anchored_item_node.name + "_notifier"
	anchored_item_node.add_child(new_visible_on_screen_notifier)
	new_visible_on_screen_notifier.owner = get_tree().edited_scene_root
	
	var new_anchored_ui = viewport_2d_in_3d.instantiate()
	new_anchored_ui.name = anchored_item_node.name
	new_anchored_ui.set_material(DRAW_ON_TOP_MATERIAL)
	new_anchored_ui.set_scene(anchored_ui)
	new_anchored_ui.set_screen_size(Vector2(1000,100))
	new_anchored_ui.set_viewport_size(Vector2(1000,100))
	new_anchored_ui.scale = Vector3(0.003,0.003,0.003)
	new_anchored_ui.set_unshaded(true)
	new_anchored_ui.position = anchored_item_node.position + Vector3(0,0.6,0)
	self.add_child(new_anchored_ui)
	
	if is_instance_valid(self.get_node(str(anchored_item_node.name)).get_node("Viewport").get_child(0)):
		var dialogue_anchor_ref = self.get_node(str(anchored_item_node.name)).get_node("Viewport").get_child(0)
		dialogue_anchor_ref.anchored_object = anchored_item_node
	
	new_anchored_ui.owner = get_tree().edited_scene_root

func _update_anchored_dialogue(anchor : Node3D, dialogue : String, npcname : String, time : float, clickable : bool, final_line : bool):
	if is_instance_valid(self.get_node(str(anchor.name)).get_node("Viewport").get_child(0)):
		
		var dialogue_anchor_ref = self.get_node(str(anchor.name)).get_node("Viewport").get_child(0)
		print(dialogue_anchor_ref.name)
		if npcname != dialogue_anchor_ref.npc_name.text:
			dialogue_anchor_ref._change_npc_name(npcname)
		dialogue_anchor_ref.dialogue_time = time
		dialogue_anchor_ref.clickable = clickable
		dialogue_anchor_ref.final_line = final_line
		dialogue_anchor_ref.dialogue_system = self
		dialogue_anchor_ref._change_npc_dialogue(dialogue)

func _update_main_dialogue(dialogue : String, npcname : String, time : float, clickable : bool, final_line : bool) -> void:
	if is_instance_valid(main_viewport.get_node("Viewport").get_child(0)):
		var dialogue_main_ref = main_viewport.get_node("Viewport").get_child(0)
		if npcname != dialogue_main_ref.npc_name.text:
				dialogue_main_ref._change_npc_name(npcname)
		dialogue_main_ref.dialogue_time = time
		dialogue_main_ref.clickable = clickable
		dialogue_main_ref.final_line = final_line
		dialogue_main_ref.dialogue_system = self
		dialogue_main_ref._change_npc_dialogue(dialogue)
		
func _update_desktop_dialogue(dialogue : String, npcname : String, time : float, clickable : bool, final_line : bool) -> void:
	if is_instance_valid(desktop_node):
		if npcname != desktop_node.npc_name.text:
				desktop_node._change_npc_name(npcname)
		desktop_node.dialogue_time = time
		desktop_node.clickable = clickable
		desktop_node.final_line = final_line
		desktop_node.dialogue_system = self
		desktop_node._change_npc_dialogue(dialogue)

func _delete_anchored_dialogue(anchor : Node3D):
	if is_instance_valid(self.get_node(str(anchor.name))):
		self.get_node(str(anchor.name)).queue_free()
	var anchor_notifier_remove_access_name = anchor.name + "_notifier"
	if is_instance_valid(anchor.get_node(anchor_notifier_remove_access_name)):
		anchor.get_node(anchor_notifier_remove_access_name).queue_free()

func _physics_process(delta):
	if timer_set_bool:
		test_time.start()
		timer_set_bool = false

func _print_dialogue(dialogue : String, npcname : String, time : float, anchor : Node3D, clickable : bool, final_line : bool) -> void:
	var anchor_dialogue_initialized : bool = false
	
	test_time.wait_time = time
	timer_set_bool = true
	
	if anchor != null:
		if !is_instance_valid(self.get_node(str(anchor.name))):
			if is_instance_valid(anchor) and anchor != null:
				_initialize_anchored_dialogue(anchor)
				anchor_dialogue_initialized = true
		else:
			anchor_dialogue_initialized = true
		
	_update_main_dialogue(dialogue, npcname, time, clickable, final_line)
	if anchor_dialogue_initialized:
		_update_anchored_dialogue(anchor, dialogue, npcname, time, clickable, final_line)
	if is_instance_valid(desktop_node):
		_update_desktop_dialogue(dialogue, npcname, time, clickable, final_line)

func _input(event):
	if Input.is_key_pressed(KEY_K) and not event.is_echo():
		print("[DEBUG] Pressed K to progress dialogue...")
		_progress_string_array()
		button_pressed.emit()

func _dialogue_progress_pressed(button) -> void:
	if button == dialogue_toggler_button:
		dialogue_progressed = true
		
		if dialogue_progressed and not finish_dialogue_scroll and clickable_param_for_array:
			complete_line_scroll.emit()
			dialogue_progressed = false
		elif dialogue_progressed and not finish_dialogue_scroll and not clickable_param_for_array:
			complete_line_scroll_nonclick.emit()
			dialogue_progressed = false
		
		if dialogue_progressed and finish_dialogue_scroll and clickable_param_for_array: 
			_progress_string_array()
			button_pressed.emit()
			dialogue_progressed = false
			finish_dialogue_scroll = false

func _progress_string_array() -> void:
	if string_array != null:
			if clickable_param_for_array:
				if line_counter < string_array.size()-1:
					line_counter+=1
					_print_dialogue(string_array[line_counter]["Line"],string_array[line_counter]["Character"], string_array[line_counter]["Time"], anchor_for_array, clickable_param_for_array, false)
				elif line_counter == string_array.size()-1:
					line_counter+=1
					_print_dialogue("",string_array[line_counter-1]["Character"], 4, anchor_for_array, clickable_param_for_array, true)
					dialogue_array_complete.emit()
					_clear_string_array()
				if is_instance_valid(audio_node):
					audio_node.position = main_viewport.position
					audio_node.playing = true
			else:
				for line in string_array:
					if line_counter < string_array.size()-1:
						finish_dialogue_scroll = false
						line_counter+=1
						_print_dialogue(line["Line"], string_array[line_counter-1]["Character"], line["Time"], anchor_for_array, clickable_param_for_array, false)
						await get_tree().create_timer(line["Time"]).timeout
					elif line_counter == string_array.size()-1:
						finish_dialogue_scroll = false
						line_counter+=1
						_print_dialogue(line["Line"], string_array[line_counter-1]["Character"], line["Time"], anchor_for_array, clickable_param_for_array, true)
						await get_tree().create_timer(line["Time"]).timeout
						dialogue_array_complete.emit()
						_clear_string_array()

func _load_string_array(array : Array, npcname : String, anchor : Node3D, clickable : bool) -> void:
	if line_counter > 0:
		return
	for line in array:
		string_array.append({"Character" : line["Character"], "Line" : line["Line"], "Time" : line["Time"] })
	anchor_for_array = anchor
	npc_name_for_array = npcname
	clickable_param_for_array = clickable
	# load first line
	if clickable:
		_print_dialogue(string_array[0]["Line"], string_array[0]["Character"], string_array[0]["Time"], anchor_for_array, clickable_param_for_array, false)
	else:
		_progress_string_array()
	
func _clear_string_array() -> void:
	string_array = []
	anchor_for_array = null
	npc_name_for_array = ""
	clickable_param_for_array = false
	line_counter = 0
		
		
	
	
	
