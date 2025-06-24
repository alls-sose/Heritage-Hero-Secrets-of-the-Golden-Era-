extends MarginContainer

@onready var key_item_01_text := $KeyItemsPage1/MarginContainer2/RichTextLabel
@onready var key_item_02_text := $KeyItemsPage2/MarginContainer2/RichTextLabel
@onready var key_item_03_text := $KeyItemsPage3/MarginContainer2/RichTextLabel
@onready var key_item_04_text := $KeyItemsPage4/MarginContainer2/RichTextLabel
@onready var key_item_05_text := $KeyItemsPage5/MarginContainer2/RichTextLabel
@onready var key_item_06_text := $KeyItemsPage6/MarginContainer2/RichTextLabel
@onready var key_item_07_text := $KeyItemsPage7/MarginContainer2/RichTextLabel

var current_page : int = 0


func _ready() -> void:
	redraw_key_item_pages()
	check_key_items()


func check_key_items() -> void:
	key_item_01_text.visible = false
	key_item_02_text.visible = false
	key_item_03_text.visible = false
	key_item_04_text.visible = false
	key_item_05_text.visible = false
	key_item_06_text.visible = false
	key_item_07_text.visible = false
	
	
	if EventManager.completed_events.has("KeyItemDaiVoltZ_Done"):
		key_item_01_text.visible = true
	if EventManager.completed_events.has("KeyItemMalakasMaganda_Done"):
		key_item_02_text.visible = true
	if EventManager.completed_events.has("KeyItemNutribun_Done"):
		key_item_03_text.visible = true
	if EventManager.completed_events.has("KeyItemManilaFilmCenter_Done"):
		key_item_04_text.visible = true
	if EventManager.completed_events.has("KeyItemGiraffe_Done"):
		key_item_05_text.visible = true
	if EventManager.completed_events.has("KeyItemButbutCloth_Done"):
		key_item_06_text.visible = true
	if EventManager.completed_events.has("KeyItemRolexWatch_Done"):
		key_item_07_text.visible = true


func redraw_key_item_pages() -> void:
	for page in get_children():
		page.visible = false
	
	get_child(current_page).visible = true
	
	check_key_items()


func turn_page_right() -> void:
	if not current_page <= 0:
		current_page -= 1
	else:
		current_page = 0
	
	redraw_key_item_pages()

func turn_page_left() -> void:
	if not current_page >= (get_child_count() - 1):
		current_page += 1
	else:
		current_page = get_child_count() - 1
	
	redraw_key_item_pages()
