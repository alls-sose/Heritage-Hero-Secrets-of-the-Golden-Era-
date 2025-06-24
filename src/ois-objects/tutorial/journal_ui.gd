extends Control


@onready var quest_log := $VBoxContainer
@onready var key_items_log := $KeyItemsContainer

enum sections{QUESTLOG, KEYITEMSLOG}

var current_section

func _ready() -> void:
	open_quest_log()


func page_turn_left() -> void:
	if current_section == sections.QUESTLOG:
		key_items_log.current_page = 0
		key_items_log.redraw_key_item_pages()
		open_key_items_log()
	elif current_section == sections.KEYITEMSLOG:
		if key_items_log.current_page == key_items_log.get_child_count() - 1:
			open_quest_log()
		else:
			key_items_log.turn_page_left()


func page_turn_right() -> void:
	if current_section == sections.QUESTLOG:
		key_items_log.current_page = key_items_log.get_child_count() - 1
		key_items_log.redraw_key_item_pages()
		open_key_items_log()
	elif current_section == sections.KEYITEMSLOG:
		if key_items_log.current_page == 0:
			open_quest_log()
		else:
			key_items_log.turn_page_right()

func open_quest_log() -> void:
	key_items_log.visible = false
	quest_log.visible = true
	current_section = sections.QUESTLOG


func open_key_items_log() -> void:
	quest_log.visible = false
	key_items_log.visible = true
	current_section = sections.KEYITEMSLOG
