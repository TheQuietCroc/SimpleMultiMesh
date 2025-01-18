class_name SimpleMultiMesh3D extends MultiMeshInstance3D

enum UpdateMode { ONCE, PROCESS, PHYSICS }

@export var group_name : StringName
@export var update_mode : UpdateMode

var group_nodes : Array:
	get = get_group_nodes

func get_group_nodes() -> Array:
	return get_tree().get_nodes_in_group(group_name)

func _ready():
	render_meshes()
	
	if (update_mode == UpdateMode.ONCE):
		process_mode = ProcessMode.PROCESS_MODE_DISABLED

func _process(delta):
	if (update_mode == UpdateMode.PROCESS):
		render_meshes()
	
func _physics_process(delta):
	if (update_mode == UpdateMode.PHYSICS):
		render_meshes()

func render_meshes():
	if (!is_instance_valid(multimesh)):
		return

	var _group_nodes = group_nodes
	
	multimesh.instance_count = maxi(_group_nodes.size(), multimesh.instance_count)
	multimesh.visible_instance_count = _group_nodes.size()
	
	for i in multimesh.visible_instance_count:
		if (is_instance_valid(_group_nodes[i]) and not _group_nodes[i].is_queued_for_deletion()):
			multimesh.set_instance_transform(i, _group_nodes[i].global_transform)
