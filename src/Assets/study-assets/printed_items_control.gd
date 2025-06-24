extends Control

@onready var zoo: TextureRect = $Zoo
@onready var miff: TextureRect = $MIFF
@onready var rolex_watches: TextureRect = $RolexWatches
@onready var cordillera: TextureRect = $Cordillera
@onready var nutribun: TextureRect = $Nutribun
@onready var malakas_maganda: TextureRect = $MalakasMaganda
@onready var jp_anime: TextureRect = $JPAnime

func _ready() -> void:
	zoo.visible = false
	miff.visible = false
	malakas_maganda.visible = false
	rolex_watches.visible = false
	nutribun.visible = false
	cordillera.visible = false
	jp_anime.visible = false

func check_items() -> void:
	if EventManager.completed_events.has("KeyItemDaiVoltZ_Done"):
		jp_anime.visible = true
	if EventManager.completed_events.has("KeyItemMalakasMaganda_Done"):
		malakas_maganda.visible = true
	if EventManager.completed_events.has("KeyItemNutribun_Done"):
		nutribun.visible = true
	if EventManager.completed_events.has("KeyItemManilaFilmCenter_Done"):
		miff.visible = true
	if EventManager.completed_events.has("KeyItemGiraffe_Done"):
		zoo.visible = true
	if EventManager.completed_events.has("KeyItemButbutCloth_Done"):
		cordillera.visible = true
	if EventManager.completed_events.has("KeyItemRolexWatch_Done"):
		rolex_watches.visible = true

	
