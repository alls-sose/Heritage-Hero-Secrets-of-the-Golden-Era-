extends Node3D

var nutribun1 : bool
var nutribun2 : bool
var nutribun3 : bool
var nutribun4 : bool
var all_nutribuns_in_box : bool
var allow_box_open : bool
var box_open_state : bool

@onready var n_1: InventorySlot = $N1
@onready var n_2: InventorySlot = $N2
@onready var n_3: InventorySlot = $N3
@onready var n_4: InventorySlot = $N4
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var paper_roll: XRToolsPickable = $"Paper Roll"
@onready var nutribun_tape: XRToolsPickable = $NutribunTape
@onready var grab_particle: Node3D = $BoxMeshAndCollision/BoxDoor/GrabParticle
@onready var box_sound: AudioStreamPlayer3D = $BoxSound

signal all_nutri_in_box

func _ready() -> void:
	nutribun1 = false
	nutribun2 = false
	nutribun3 = false
	nutribun4 = false
	all_nutribuns_in_box = false
	paper_roll.enabled = false
	paper_roll.visible = false
	nutribun_tape.enabled = false
	nutribun_tape.visible = false
	n_1.visible = false
	n_2.visible = false
	n_3.visible = false
	n_4.visible = false
	allow_box_open = false
	box_open_state = false
	grab_particle.visible = false
	
func _physics_process(delta: float) -> void:
	if nutribun1 and nutribun2 and nutribun3 and nutribun4 and not all_nutribuns_in_box:
		all_nutribuns_in_box = true
		all_nutri_in_box.emit()


func _on_n_1_slot_picked_up() -> void:
	nutribun1 = true
	n_1.slot_enabled = false


func _on_n_2_slot_picked_up() -> void:
	nutribun2 = true
	n_2.slot_enabled = false


func _on_n_3_slot_picked_up() -> void:
	nutribun3 = true
	n_3.slot_enabled = false


func _on_n_4_slot_picked_up() -> void:
	nutribun4 = true
	n_4.slot_enabled = false


func _on_oven_emit_baking_done() -> void:
	allow_box_open = true
	grab_particle.visible = true


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if allow_box_open:
		if event.event_type == XRToolsPointerEvent.Type.PRESSED:
			if !box_open_state:
				box_sound.play()
				grab_particle.visible = false
				nutribun_tape.visible = true
				paper_roll.visible = true
				animation_player.play("box_open")
				await animation_player.animation_finished
				paper_roll.enabled = true
				nutribun_tape.enabled = true
				n_1.visible = true
				n_2.visible = true
				n_3.visible = true
				n_4.visible = true
				n_1.slot_enabled = true
				n_2.slot_enabled = true
				n_3.slot_enabled = true
				n_4.slot_enabled = true
				box_open_state = true
			else:
				box_sound.play()
				n_1.visible = false
				n_2.visible = false
				n_3.visible = false
				n_4.visible = false
				n_1.slot_enabled = false
				n_2.slot_enabled = false
				n_3.slot_enabled = false
				n_4.slot_enabled = false
				animation_player.play("box_close")
				await animation_player.animation_finished
				box_open_state = false
