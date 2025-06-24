extends Control

@onready var animation: AnimationPlayer = $Animation

signal credits_play_finished

func play_final_sequence():
	if EventManager.completed_events.has("KeyItemDaiVoltZ_Done"):
		animation.play("play_anime")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemMalakasMaganda_Done"):
		animation.play("play_malakas")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemNutribun_Done"):
		animation.play("play_nutribun")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemManilaFilmCenter_Done"):
		animation.play("play_filmcenter")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemGiraffe_Done"):
		animation.play("play_zoo")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemButbutCloth_Done"):
		animation.play("play_dam")
		await animation.animation_finished
	if EventManager.completed_events.has("KeyItemRolexWatch_Done"):
		animation.play("play_rolex")
		await animation.animation_finished
	
	animation.play("play_credits")
	await animation.animation_finished
	credits_play_finished.emit()
