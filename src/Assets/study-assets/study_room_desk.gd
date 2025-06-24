extends Node3D

@export var interface : Node3D

@export var object_follow_speed := 4
@export var object_distance := 1.0
@export var object_height := 0

@onready var anim = $AnimationPlayer
@onready var xr_tools_interactable_area: XRToolsInteractableArea = $XRToolsInteractableArea

var camera
var main
var lock_rotate
var trying_lock = false

func _ready() -> void:
	call_deferred("initialize_lock")
	deactivate_lock()


func initialize_lock() -> void:
	camera = get_tree().get_root().get_node("Main/XRPlayer/XRViewport/XROrigin3D/XRCamera3D")
	main = get_tree().get_root().get_node("Main")

func _physics_process(delta: float) -> void:
	if trying_lock:
		var point = camera.global_transform.origin 
		
		var temp_pos = interface.position
		
		var position_x_rotate = object_distance * cos(camera.global_rotation.y)
		var position_z_rotate = object_distance * sin(camera.global_rotation.y)
		var position_ui_offset = Vector3(-position_z_rotate, object_height, -position_x_rotate)
		
		interface.global_transform.origin = interface.global_transform.origin.lerp(camera.global_transform.origin + position_ui_offset, delta * object_follow_speed)
		interface.rotation.y = camera.global_rotation.y + 1.6


func activate_lock() -> void:
	interface.lock_active(true)
	interface.visible = true
	trying_lock = true


func deactivate_lock() -> void:
	interface.lock_active(false)
	interface.visible = false
	trying_lock = false


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		if !trying_lock:
			activate_lock()
		elif trying_lock:
			deactivate_lock()


func _on_desk_lock_lock_solved() -> void:
	deactivate_lock()
	anim.play("open_drawer")
	xr_tools_interactable_area.queue_free()


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	deactivate_lock()
