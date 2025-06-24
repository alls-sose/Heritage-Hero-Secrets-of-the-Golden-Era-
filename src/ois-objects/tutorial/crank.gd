extends Node3D

@onready var handle := $InteractableHandle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not handle.is_picked_up():
		handle.global_transform = handle.handle_origin.global_transform
