extends CanvasLayer

#Intended to only access layers inside the UI.

@onready var control: Control = $Control
@onready var npc_name: RichTextLabel = $Control/NPC_Name
@onready var npc_dialogue: RichTextLabel = $Control/NPC_Dialogue
@onready var bar: TextureRect = $Control/Bar

@export var dialogue_system : Node3D

@onready var xr_camera_anchor : Node3D = dialogue_system.xr_camera_anchor
@onready var xr_anchor_to_object : Node3D = dialogue_system.xr_anchor_to_object
@onready var slots_distance_to_player : float = dialogue_system.slots_distance_to_player
@onready var local_transform_adjustment : Vector3 = dialogue_system.local_transform_adjustment
@onready var height_adjustment : float = dialogue_system.height_adjustment
@onready var timer : Timer = dialogue_system.test_time
@onready var dialogue_time : float
@onready var button_prompt: VBoxContainer = $"Control/Button Prompt"

var npc_dialogue_string : String
var change_called : bool
var charlength : float = 0
var textratio : float = 0
var clickable : bool
var final_line : bool
var complete_scroll : bool

@export var fade_out_timer_bool : bool
@export var fade_out_timer : Timer = Timer.new()
@export var fade_out_seconds : float = 2
var fade_out_anim_bool : bool

signal dialogue_line_finished_main

func _ready():
	add_child(fade_out_timer)
	fade_out_timer.set_wait_time(0.001)
	fade_out_timer.one_shot = true
	fade_out_timer_bool = false

func _change_npc_name(npcname : String) -> void:
	npc_name.text = "[color=#FFD700]" + npcname
	
func _change_npc_dialogue(npcdialogue : String) -> void:
	_fade_in_dialogue_test()
	_change_visible_character_ratio(0)
	complete_scroll = false
	button_prompt.modulate = Color(1,1,1,0)
	npc_dialogue.text = npcdialogue
	npc_dialogue_string = npcdialogue
	
	if clickable:
		if not dialogue_system.complete_line_scroll.is_connected(_complete_line_scroll):
			dialogue_system.complete_line_scroll.connect(_complete_line_scroll)
		if not dialogue_system.complete_line_scroll_nonclick.is_connected(_complete_line_scroll_nonclick):
			dialogue_system.complete_line_scroll_nonclick.connect(_complete_line_scroll_nonclick)
			
	change_called = true
	fade_out_timer.set_wait_time(dialogue_time+fade_out_seconds)
	fade_out_timer_bool = true
	fade_out_anim_bool = true
	
func _change_npc_dialogue_internal(npcdialogue : String) -> void:
	npc_dialogue.text = npcdialogue
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
	dialogue_line_finished_main.emit()
		
func _fade_out_dialogue_test() -> void:
	if fade_out_timer.time_left <= 0:
		if fade_out_anim_bool:
			fade_out_anim_bool = false
			var tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween.tween_property(control, "modulate", Color(1,1,1,0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
			if final_line:
				dialogue_line_finished_main.emit()

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
	if fade_out_timer_bool:
		fade_out_timer_bool = false
		fade_out_timer.start()
		
	if !clickable:	
		_fade_out_dialogue_test()
	elif clickable and final_line:
		_fade_out_dialogue_box()
		final_line = false
	
	if !complete_scroll:
		_run_character_ratio(fade_out_timer)

func reposition_ui() -> void:
	var position_offset : Vector3
	
	if is_instance_valid(xr_camera_anchor) and is_instance_valid(xr_anchor_to_object):
		var position_x_rotate = slots_distance_to_player * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * cos(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		var position_z_rotate = slots_distance_to_player * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y) + local_transform_adjustment.z * sin(xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y)
		self.get_parent().get_parent().rotation.y = xr_camera_anchor.global_rotation.y - self.get_parent().get_parent().get_parent().global_rotation.y
		position_offset = Vector3(-position_z_rotate,height_adjustment*1.5,-position_x_rotate)
		self.get_parent().get_parent().global_position = xr_anchor_to_object.position + xr_camera_anchor.position + position_offset

func _complete_line_scroll() -> void:
	complete_scroll = true
	dialogue_system.finish_dialogue_scroll = true
	_change_visible_character_ratio(1)
	_fade_in_button_prompt()
	
func _complete_line_scroll_nonclick() -> void:
	complete_scroll = true
	dialogue_system.finish_dialogue_scroll = true
	_change_visible_character_ratio(1)
