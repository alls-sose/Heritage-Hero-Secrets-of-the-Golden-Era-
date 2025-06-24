extends Node3D
@onready var quest_paperguide: MeshInstance3D = $"printing press modified no rust/QUEST_PAPERGUIDE"
@onready var quest_greenbutton: MeshInstance3D = $"printing press modified no rust/QUEST_GREENBUTTON"
@onready var button_area: CollisionShape3D = $XRToolsInteractableArea/CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_slot: InventorySlot = $ButtonSlot
@onready var paper_slot: InventorySlot = $PaperSlot
@onready var button_snap_zone: XRToolsSnapZone = $ButtonSlot/SnapZone
@onready var paper_snap_zone: XRToolsSnapZone = $PaperSlot/SnapZone
@onready var indicator_for_paper: MeshInstance3D = $"printing press modified no rust/IndicatorForPaper"
@onready var indicator_for_button: MeshInstance3D = $"printing press modified no rust/IndicatorForButton"
var anim_playing : bool
var paper_already_printed : bool
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


var paper_in : bool
var button_in : bool
signal paper_added
signal button_added
signal printer_printed

func _ready() -> void:
	quest_paperguide.visible = false
	quest_greenbutton.visible = false
	paper_already_printed = false

func _on_greenbutton_find() -> void:
	quest_greenbutton.visible = true
	paper_in = true
	button_slot.slot_enabled = false
	button_slot.visible = false
	button_snap_zone.enabled = false
	button_slot.current_object.visible = false
	indicator_for_button.visible = false
	button_added.emit()
	
func _on_paper_find() -> void:
	quest_paperguide.visible = true
	button_in = true
	paper_slot.slot_enabled = false
	paper_slot.visible = false
	paper_snap_zone.enabled = false
	paper_slot.current_object.visible = false
	indicator_for_paper.visible = false
	paper_added.emit()

func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		if paper_in and button_in and not anim_playing and not paper_already_printed:
			anim_playing = true
			animation_player.play("printing_press_activate")
			audio_stream_player_3d.play()
			await animation_player.animation_finished
			animation_player.play('printing_press_idle')
			anim_playing = false
			paper_already_printed = true
			printer_printed.emit()
