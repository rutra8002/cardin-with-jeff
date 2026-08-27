extends MarginContainer

@onready var front_face = $FrontFace
@onready var back_face = $BackFace

var is_dragging = false
var drag_offset = Vector2.ZERO
var is_face_up = false

@onready var original_scale_x = scale.x 

func _ready():
	pivot_offset = size / 2.0
	front_face.visible = is_face_up
	back_face.visible = !is_face_up

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_offset = get_global_mouse_position() - global_position 
			set_as_top_level(true) 
			z_index = 100 
		else:
			is_dragging = false
			set_as_top_level(false)
			z_index = 0
			
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		flip()
		
	if event is InputEventMouseMotion and is_dragging:
		global_position = get_global_mouse_position() - drag_offset

func flip():
	var tween = create_tween()
	tween.tween_property(self, "scale:x", 0.0, 0.15)
	tween.tween_callback(swap_faces)
	tween.tween_property(self, "scale:x", original_scale_x, 0.15)

func swap_faces():
	is_face_up = !is_face_up
	front_face.visible = is_face_up
	back_face.visible = !is_face_up
