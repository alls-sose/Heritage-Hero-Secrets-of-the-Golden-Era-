extends Node3D

signal lock_solved()

@export var code : String

@onready var keypad_label: Label = $Viewport2Din3D/Viewport/KeypadUI/CenterContainer/Label
@onready var beep: AudioStreamPlayer3D = $Beep
@onready var wrong: AudioStreamPlayer3D = $Wrong
@onready var correct: AudioStreamPlayer3D = $Correct

var current_code : String = ""


func _ready() -> void:
	keypad_label.text = "-------"
	lock_active(false)


func keypad_inputter(number : String) -> void:
	beep.play()
	keypad_label.text = ""
	if current_code.length() < 7:
		current_code += number
	else:
		current_code = ""
	
	keypad_label.text = current_code
	
	while keypad_label.text.length() < 7:
		keypad_label.text += "-"


func check_solution() -> void:
	if current_code == code:
		correct.play()
		emit_signal("lock_solved")
	else:
		wrong.play()
		current_code = ""
		keypad_label.text = "-------"


func lock_active(b:bool) -> void:
	$Key1/CollisionShape3D.disabled = !b
	$Key2/CollisionShape3D.disabled = !b
	$Key3/CollisionShape3D.disabled = !b
	$Key4/CollisionShape3D.disabled = !b
	$Key5/CollisionShape3D.disabled = !b
	$Key6/CollisionShape3D.disabled = !b
	$Key7/CollisionShape3D.disabled = !b
	$Key8/CollisionShape3D.disabled = !b
	$Key9/CollisionShape3D.disabled = !b
	$Keyc/CollisionShape3D.disabled = !b
	$Key0/CollisionShape3D.disabled = !b
	$Keye/CollisionShape3D.disabled = !b


func _on_key_1_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("1")


func _on_key_2_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("2")


func _on_key_3_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("3")


func _on_key_4_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("4")


func _on_key_5_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("5")


func _on_key_6_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("6")


func _on_key_7_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("7")


func _on_key_8_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("8")


func _on_key_9_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("9")


func _on_key_0_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		keypad_inputter("0")


func _on_keyc_keye_pointer_event(event: Variant) -> void:
	if event.event_type == XRToolsPointerEvent.Type.PRESSED:
		check_solution()
