@tool
extends Node3D
  
signal document_completed

@onready var full_doc := $Plane
@onready var piece_1 := $Plane_001
@onready var piece_2 := $Plane_002
@onready var piece_3 := $Plane_003
@onready var piece_4 := $Plane_004
@onready var piece_5 := $Plane_005
@onready var piece_6 := $Plane_006
@onready var piece_7 := $Plane_007

@export var active_pieces : Dictionary = {
	"Piece1" : {
		"Active" : false,
		"Neighbors" : ["Piece2", "Piece3"]
	},
	"Piece2" : {
		"Active" : false,
		"Neighbors" : ["Piece1", "Piece4"]
	},
	"Piece3" : {
		"Active" : false,
		"Neighbors" : ["Piece1", "Piece4", "Piece5"]
	},
	"Piece4" : {
		"Active" : false,
		"Neighbors" : ["Piece2", "Piece3", "Piece7"]
	},
	"Piece5" : {
		"Active" : false,
		"Neighbors" : ["Piece3", "Piece6"]
	},
	"Piece6" : {
		"Active" : false,
		"Neighbors" : ["Piece5", "Piece7"]
	},
	"Piece7" : {
		"Active" : false,
		"Neighbors" : ["Piece4", "Piece6"]
	}
}

var current_neighbors : Array

func _ready() -> void:
	document_completed.connect(get_parent().get_parent().get_node("ActionAssembleDocument")._on_malakas_at_maganda_doc_document_completed)
	for child in get_children():
		child.visible = false
	for piece in active_pieces:
		if active_pieces[piece]["Active"]:
			current_neighbors += active_pieces[piece]["Neighbors"]
	initialize_active_pieces()
	if not Engine.is_editor_hint():
		call_deferred("check_completed")

func check_neighbors(other_piece : Variant) -> bool:
	
	var b = false
	
	var other_piece_active_pieces : Array
	
	for piece in other_piece.active_pieces:
		if other_piece.active_pieces[piece]["Active"]:
			other_piece_active_pieces.append(piece)
	
	for piece in other_piece_active_pieces:
		if piece in current_neighbors:
			b = true
	
	return b


func get_combined_active_pieces(other_piece : Variant) -> Dictionary:
	var combined_dict : Dictionary = active_pieces
	
	for piece in other_piece.active_pieces:
		if not combined_dict[piece]["Active"]:
			combined_dict[piece]["Active"] = other_piece.active_pieces[piece]["Active"]
	
	return combined_dict


func initialize_active_pieces() -> void:
	if active_pieces["Piece1"]["Active"]:
		piece_1.visible = true
	if active_pieces["Piece2"]["Active"]:
		piece_2.visible = true
	if active_pieces["Piece3"]["Active"]:
		piece_3.visible = true
	if active_pieces["Piece4"]["Active"]:
		piece_4.visible = true
	if active_pieces["Piece5"]["Active"]:
		piece_5.visible = true
	if active_pieces["Piece6"]["Active"]:
		piece_6.visible = true
	if active_pieces["Piece7"]["Active"]:
		piece_7.visible = true
	
	if not Engine.is_editor_hint():
		call_deferred("check_completed")

func check_completed() -> void:
	var b = true
	
	for piece in active_pieces:
		if not active_pieces[piece]["Active"]:
			b = false
	
	if b:
		emit_signal("document_completed")
