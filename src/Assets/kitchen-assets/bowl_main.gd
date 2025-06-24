@tool
extends XRToolsPickable

@onready var bowl_contents: MeshInstance3D = $BowL/Domain

@onready var progress_view: Node3D = $"Progress View"
@onready var ois_sugar_receiver: OISWipeReceiver = $OISSugarReceiver
@onready var ois_wheat_flour_receiver: OISWipeReceiver = $OISWheatFlourReceiver
@onready var ois_yeast_receiver: OISWipeReceiver = $OISYeastReceiver
@onready var ois_mix_receiver: OISWipeReceiver = $OISMixReceiver
@onready var ois_water_receiver: OISWipeReceiver = $OISWaterReceiver
@onready var ois_oil_receiver: OISWipeReceiver = $OISOilReceiver
@onready var ois_milk_receiver: OISWipeReceiver = $OISMilkReceiver
@onready var ois_salt_receiver: OISWipeReceiver = $OISSaltReceiver
@onready var knead_receiver: OISWipeReceiver = $Dough/KneadReceiver

@onready var flour_area_3d: Area3D = $OISWheatFlourReceiver/Area3D
@onready var sugar_area_3d: Area3D = $OISSugarReceiver/Area3D
@onready var yeast_area_3d: Area3D = $OISYeastReceiver/Area3D
@onready var mix_area_3d: Area3D = $OISMixReceiver/Area3D
@onready var water_area_3d: Area3D = $OISWaterReceiver/Area3D
@onready var oil_area_3d: Area3D = $OISOilReceiver/Area3D
@onready var milk_area_3d: Area3D = $OISMilkReceiver/Area3D
@onready var salt_area_3d: Area3D = $OISSaltReceiver/Area3D

@onready var lols: XRToolsSnapZone = $lols
@onready var lols_collision_shape_3d: CollisionShape3D = $lols/CollisionShape3D

@onready var snap_zone_collision: CollisionShape3D = $lols/CollisionShape3D

@onready var mix_collision_shape_3d: CollisionShape3D = $OISMixReceiver/Area3D/CollisionShape3D
@onready var mix_audio_player: AudioStreamPlayer3D = $MixAudioPlayer



var mix_counter : int
var allow_rotate: bool
var tween_anim_bool :bool
var tween : Tween
var split_counter : int

signal mix_1_done
signal mix_2_done
signal mix_3_done
signal mix_4_done
signal split_done

func _ready() -> void:
	super()
	lols.scale = Vector3(0.01,0.01,0.01)
	lols.enabled = false
	bowl_contents.set("blend_shapes/Key 1", -0.50)
	progress_view.visible = false
	sugar_area_3d.monitorable = false
	yeast_area_3d.monitorable = false
	mix_area_3d.monitorable = false
	water_area_3d.monitorable = false
	oil_area_3d.monitorable = false
	milk_area_3d.monitorable = false
	salt_area_3d.monitorable = false
	lols_collision_shape_3d.disabled = true

func _physics_process(delta: float) -> void:
	if allow_rotate:
		bowl_contents.rotation_degrees.y += 30 * delta
	if tween_anim_bool:
		if is_instance_valid(tween):
			var timer_time = tween.get_total_elapsed_time() / 10
			#progress_view.change_progress_value(timer_time * 100)
	if split_counter == 2:
		print("EMIT SIGNAL DONE")
		split_done.emit()
		split_counter = 0

func _on_ois_wheat_flour_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", -0.10)
	ois_wheat_flour_receiver.queue_free()
	yeast_area_3d.monitorable = true

func _on_ois_yeast_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.20)
	ois_yeast_receiver.queue_free()
	sugar_area_3d.monitorable = true

func _on_ois_sugar_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.40)
	ois_sugar_receiver.queue_free()
	mix_collision_shape_3d.disabled = false
	mix_area_3d.monitorable = true

func _on_ois_water_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.50)
	ois_water_receiver.queue_free()
	mix_collision_shape_3d.disabled = false
	mix_area_3d.monitorable = true

func _on_ois_oil_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.55)
	ois_oil_receiver.queue_free()
	mix_collision_shape_3d.disabled = false
	mix_area_3d.monitorable = true

func _on_ois_milk_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.80)
	ois_milk_receiver.queue_free()
	salt_area_3d.monitorable = true

func _on_ois_salt_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	progress_view.visible = true
	progress_view.progress_complete_checkmark_only_anim()
	bowl_contents.set("blend_shapes/Key 1", 0.90)
	ois_salt_receiver.queue_free()
	mix_collision_shape_3d.disabled = false
	mix_area_3d.monitorable = true

func _on_ois_mix_receiver_action_in_progress(requirement: Variant, total_progress: Variant) -> void:
	allow_rotate = true
	var percentage = total_progress / requirement
	progress_view.visible = true
	progress_view.change_progress_value(percentage*100)

func _on_ois_mix_receiver_action_completed(requirement: Variant, total_progress: Variant) -> void:
	allow_rotate = false
	progress_view.progress_complete_anim()
	mix_collision_shape_3d.disabled = true
	mix_area_3d.monitorable = false
	
	ois_mix_receiver.total_progress = 0
	
	mix_counter+=1
	match mix_counter:
		1:
			water_area_3d.monitorable = true
			mix_1_done.emit()
		2: 
			oil_area_3d.monitorable = true
			mix_2_done.emit()
		3:
			milk_area_3d.monitorable = true
			mix_3_done.emit()
		4:
			await get_tree().create_timer(1).timeout
			tween = get_tree().create_tween()
			tween.set_parallel(true)
			tween_anim_bool = true
			tween.tween_property(lols, "scale", Vector3(1,1,1), 10).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(bowl_contents, "scale", Vector3(0,0,0), 10).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
			lols.enabled = true
			lols_collision_shape_3d.disabled = false
			tween_anim_bool = false
			progress_view.progress_complete_checkmark_only_anim()
			mix_4_done.emit()


func _on_ois_mix_receiver_action_ended(requirement: Variant, total_progress: Variant) -> void:
	allow_rotate = false

func _on_ois_mix_receiver_action_started(requirement: Variant, total_progress: Variant) -> void:
	mix_audio_player.play()
	progress_view.progress_idle_state()
	
	
