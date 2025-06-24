extends Node3D

signal cassette_play()

@onready var cassette_slot := $InventorySlot
@onready var key_item_1 := $CassetteEvents/KeyItemDaiVoltZ
@onready var key_item_2 := $CassetteEvents/KeyItemMalakasMaganda
@onready var key_item_3 := $CassetteEvents/KeyItemNutribun
@onready var key_item_4 := $CassetteEvents/KeyItemManilaFilmCenter
@onready var key_item_5 := $CassetteEvents/KeyItemGiraffe
@onready var key_item_6 := $CassetteEvents/KeyItemButbutCloth
@onready var key_item_7 := $CassetteEvents/KeyItemRolexWatch

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var cassette_play_sfx: AudioStreamPlayer3D = $CassettePlaySFX
@onready var cassette_add_remove_sfx: AudioStreamPlayer3D = $CassetteAddRemoveSFX


func _ready() -> void:
	pass

func _on_inventory_slot_slot_picked_up() -> void:
	pass # Replace with function body.


func _on_inventory_slot_current_object_in_slot(object: Variant, row: Variant, col: Variant) -> void: 
	cassette_add_remove_sfx.play()
	if is_instance_valid(object):
		print(object.name + " is in the Cassete Player")
		if object.is_in_group("KeyItemTape"):
			if object.name == "DaiVoltZTape":
				cassette_play.connect(key_item_1._on_cassette_player_play)
			elif object.name == "MalakasMagandaTape":
				cassette_play.connect(key_item_2._on_cassette_player_play)
			elif object.name == "NutribunTape":
				cassette_play.connect(key_item_3._on_cassette_player_play)
			elif object.name == "ManilaFilmCenterTape":
				cassette_play.connect(key_item_4._on_cassette_player_play)
			elif object.name == "GiraffeTape":
				cassette_play.connect(key_item_5._on_cassette_player_play)
			elif object.name == "ButbutClothTape":
				cassette_play.connect(key_item_6._on_cassette_player_play)
			elif object.name == "RolexWatchTape":
				cassette_play.connect(key_item_7._on_cassette_player_play)
	


func _on_inventory_slot_slot_dropped() -> void:
	if cassette_play.is_connected(key_item_1._on_cassette_player_play):
		cassette_play.disconnect(key_item_1._on_cassette_player_play)
	if cassette_play.is_connected(key_item_2._on_cassette_player_play):
		cassette_play.disconnect(key_item_2._on_cassette_player_play)
	if cassette_play.is_connected(key_item_3._on_cassette_player_play):
		cassette_play.disconnect(key_item_3._on_cassette_player_play)
	if cassette_play.is_connected(key_item_4._on_cassette_player_play):
		cassette_play.disconnect(key_item_4._on_cassette_player_play)
	if cassette_play.is_connected(key_item_5._on_cassette_player_play):
		cassette_play.disconnect(key_item_5._on_cassette_player_play)
	if cassette_play.is_connected(key_item_6._on_cassette_player_play):
		cassette_play.disconnect(key_item_6._on_cassette_player_play)
	if cassette_play.is_connected(key_item_7._on_cassette_player_play):
		cassette_play.disconnect(key_item_7._on_cassette_player_play)


func _on_xr_tools_interactable_area_pointer_event(event: Variant) -> void:
	print("HALLO")
	if event.event_type == XRToolsPointerEvent.Type.PRESSED and not audio_stream_player_3d.playing:
		print("PLAYING CASSETTE")
		cassette_play_sfx.play()
		await cassette_play_sfx.finished
		cassette_play.emit()
