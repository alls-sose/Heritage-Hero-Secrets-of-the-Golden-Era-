extends Node3D

signal lock_solved()

@export var code : String

@onready var button_hitbox := $XRToolsInteractableArea/CollisionShape3D

@onready var wheel1 := $"CombinationLock Wheel"
@onready var wheel2 := $"CombinationLock Wheel2"
@onready var wheel3 := $"CombinationLock Wheel3"

var lock_open = false

func _ready() -> void:
	lock_active(false)


func lock_active(b: bool) -> void:
	button_hitbox.disabled = !b
	wheel1.wheel_hitboxes_active(b)
	wheel2.wheel_hitboxes_active(b)
	wheel3.wheel_hitboxes_active(b)


func check_answer() -> void:
	if !lock_open:
		var answer := str(wheel1.get_number()) + str(wheel2.get_number()) + str(wheel3.get_number())
		if answer == code:
			lock_open = true
			emit_signal("lock_solved")


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		check_answer()
