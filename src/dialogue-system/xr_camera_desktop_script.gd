extends Camera3D

var xr_interface
var xr_bool :bool

@export var xr_origin : Node3D
@export var xr_camera : Node3D

func _ready() -> void:
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("BASED")
		xr_bool = true
		
func _physics_process(delta: float) -> void:
	if xr_bool:
		self.global_transform = XRServer.get_hmd_transform()
		self.position = xr_origin.position + xr_camera.position
