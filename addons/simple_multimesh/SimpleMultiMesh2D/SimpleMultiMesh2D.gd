class_name SimpleMultiMesh2D extends MultiMeshInstance2D

enum UpdateMode { ONCE, PROCESS, PHYSICS }

@export var groupName : StringName
@export var updateMode : UpdateMode

var groupNodes : Array:
	get = get_group_nodes

func get_group_nodes() -> Array:
	return get_tree().get_nodes_in_group(groupName)

func _ready():
	render_meshes()
	
	if (updateMode == UpdateMode.ONCE):
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _process(delta):
	if (updateMode == UpdateMode.PROCESS):
		render_meshes()
	
func _physics_process(delta):
	if (updateMode == UpdateMode.PHYSICS):
		render_meshes()

func render_meshes():
	var group_nodes = groupNodes
	
	multimesh.instance_count = maxi(group_nodes.size(), multimesh.instance_count)
	multimesh.visible_instance_count = group_nodes.size()
	
	for i in multimesh.visible_instance_count:
		if (is_instance_valid(groupNodes[i]) and not groupNodes[i].is_queued_for_deletion()):
			multimesh.set_instance_transform_2d(i, group_nodes[i].global_transform)
