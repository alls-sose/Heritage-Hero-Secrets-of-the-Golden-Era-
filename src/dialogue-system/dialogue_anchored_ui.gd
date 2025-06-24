extends CanvasLayer

#Intended to only access layers inside the UI.

@onready var control: Control = $Control
@onready var npc_name: RichTextLabel = $Control/NPC_Name
@onready var npc_dialogue: RichTextLabel = $Control/VBoxContainer/NPC_Dialogue
@onready var bar: TextureRect = $Control/Bar
@onready var button_prompt: VBoxContainer = $Control/Arrow

@onready var xr_camera_anchor : Node3D = get_parent().get_parent().get_parent().xr_camera_anchor
@onready var xr_anchor_to_object : Node3D = get_parent().get_parent().get_parent().xr_anchor_to_object
@onready var slots_distance_to_player : float = get_parent().get_parent().get_parent().slots_distance_to_player
@onready var local_transform_adjustment : Vector3 = get_parent().get_parent().get_parent().local_transform_adjustment
@onready var height_adjustment : float = get_parent().get_parent().get_parent().height_adjustment
@onready var timer : Timer = get_parent().get_parent().get_parent().test_time
@onready var dialogue_system : Node3D

@onready var dialogue_time : float
@onready var anchored_object : Node3D

var npc_dialogue_string : String
var change_called : bool
var charlength : float = 0
var textratio : float = 0
var clickable : bool
var final_line : bool
var button_pressed_bool : bool = false
var complete_scroll : bool

@export var fade_out_timer_bool : bool
@export var fade_out_timer : Timer = Timer.new()
@export var fade_out_seconds : float = 2
var fade_out_anim_bool : bool

signal dialogue_line_finished_anchored

func _ready():
	add_child(fade_out_timer)
	fade_out_timer.set_wait_time(0.001)
	fade_out_timer.one_shot = true
	fade_out_timer_bool = false
	button_pressed_bool = false


func _change_npc_name(npcname : String) -> void:
	npc_name.text = "[center][color=#FFD700]" + npcname
	
func _change_npc_dialogue(npcdialogue : String) -> void:
	_fade_in_dialogue_test()
	complete_scroll = false
	_change_visible_character_ratio(0)
	button_prompt.modulate = Color(1,1,1,0)
	npc_dialogue.text = "[center]" + npcdialogue
	npc_dialogue_string = npcdialogue
	
	if clickable:
		if not dialogue_system.complete_line_scroll.is_connected(_complete_line_scroll):
			dialogue_system.complete_line_scroll.connect(_complete_line_scroll)
		if not dialogue_system.button_pressed.is_connected(_final_button_press):
			dialogue_system.complete_line_scroll.connect(_final_button_press)
		if not dialogue_system.complete_line_scroll_nonclick.is_connected(_complete_line_scroll_nonclick):
			dialogue_system.complete_line_scroll_nonclick.connect(_complete_line_scroll_nonclick)
			
	change_called = true
	fade_out_timer.set_wait_time(dialogue_time+fade_out_seconds)
	fade_out_timer_bool = true
	fade_out_anim_bool = true
	
func _change_npc_dialogue_internal(npcdialogue : String) -> void:
	npc_dialogue.text = "[center]" + npcdialogue
	npc_dialogue_string = npcdialogue
	
func _change_visible_character_count(count : float) -> void:
	npc_dialogue.visible_characters = count

func _change_visible_character_ratio(ratio : float) -> void:
	npc_dialogue.visible_ratio = ratio
	
func _run_character_ratio(time : Timer) -> void:
	if change_called:
		if time.time_left >= (dialogue_time + fade_out_seconds) * 0.5:
			var set_ratio : float = (dialogue_time + fade_out_seconds - time.time_left) / (dialogue_time + fade_out_seconds - ((dialogue_time + fade_out_seconds) * 0.5)) 
			if set_ratio > 0.98:
				set_ratio = 1
				complete_scroll = true
			_change_visible_character_ratio(set_ratio)
			if clickable and complete_scroll:
				_fade_in_button_prompt()
		else:
			change_called = false
			charlength = 0

func _run_per_character_appear(delta : float) -> void:
	if change_called:
		if charlength < npc_dialogue_string.length():
			charlength+=(1*delta)
			_change_visible_character_count(int(charlength))
		else:
			change_called = false
			charlength = 0
			
func _fade_out_dialogue_box() -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	get_parent().get_parent().queue_free()
		
func _fade_out_dialogue_test() -> void:
	if fade_out_timer.time_left <= 0:
		if fade_out_anim_bool:
			fade_out_anim_bool = false
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
			if final_line:
				get_parent().get_parent().queue_free()

func _fade_in_dialogue_test() -> void:
	if !control.modulate.a == 1:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(control, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished

func _fade_in_button_prompt() -> void:
	if !button_prompt.modulate.a == 1:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(button_prompt, "modulate", Color(1,1,1,1), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		await tween.finished

func _physics_process(delta: float) -> void:
	reposition_ui()
	if fade_out_timer_bool:
		fade_out_timer_bool = false
		fade_out_timer.start()
	
	if !complete_scroll:
		_run_character_ratio(fade_out_timer)
	
	if !clickable:	
		_fade_out_dialogue_test()
	elif clickable and button_pressed_bool and final_line:
		_fade_out_dialogue_box()
		button_pressed_bool = false
	

func reposition_ui() -> void:
	var position_offset : Vector3
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		self.get_parent().get_parent().rotation.y = xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y
	
func _final_button_press():
	button_pressed_bool = true

func _complete_line_scroll() -> void:
	complete_scroll = true
	_change_visible_character_ratio(1)
	_fade_in_button_prompt()
	
func _complete_line_scroll_nonclick() -> void:
	complete_scroll = true
	_change_visible_character_ratio(1)
	
	
	
