extends Container
class_name SURFEED

@onready var viewport_01: SubViewport = $SubViewportContainer_1/SubViewport
@onready var camera_01: Camera3D = $SubViewportContainer_1/SubViewport/Camera3D
@onready var container_1: SubViewportContainer = $SubViewportContainer_1
@onready var viewport_02: SubViewport = $SubViewportContainer_2/SubViewport
@onready var camera_02: Camera3D = $SubViewportContainer_2/SubViewport/Camera3D
@onready var container_2: SubViewportContainer = $SubViewportContainer_2

var cameras := {}

func _ready():
	self.visible = false;
	cameras = {
	"1": {"viewport": viewport_01, "camera": camera_01, "container": container_1},
	"2": {"viewport": viewport_02, "camera": camera_02, "container": container_2},
	}
	
	for  k in cameras:
		cameras[k]["viewport"].render_target_update_mode = SubViewport.UPDATE_DISABLED
		cameras[k]["camera"].current = false
		cameras[k]["container"].visible = false
	
	self.visible = false

func _activate_feed(camera_id: String):
	self.visible = true;
	for k in cameras:
		cameras[k]["viewport"].render_target_update_mode = SubViewport.UPDATE_DISABLED
		cameras[k]["camera"].current = false;
		cameras[k]["container"].visible = false
	
	cameras[camera_id]["viewport"].render_target_update_mode = SubViewport.UPDATE_ALWAYS
	cameras[camera_id]["camera"].current = true;
	cameras[camera_id]["container"].visible = true
