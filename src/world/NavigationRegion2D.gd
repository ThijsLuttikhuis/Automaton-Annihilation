extends NavigationRegion2D

var new_navigation_polygon: NavigationPolygon = get_navigation_polygon()

func _physics_process(_dt):

	#parse_2d_collisionshapes($"../Buildings")

	var fullMesh = addAllChildMeshes($"../Buildings")
	
	#NavigationServer2D.parse_source_geometry_data(new_navigation_polygon)
	
	NavigationServer2D.region_set_navigation_polygon()
	
	NavigationServer2D.bake_from_source_geometry_data(new_navigation_polygon, fullMesh)



	new_navigation_polygon.make_polygons_from_outlines()
	print(new_navigation_polygon.get_polygon_count())
	set_navigation_polygon(new_navigation_polygon)

func addAllChildMeshes(rootNode: Node2D, fullMesh: NavigationMeshSourceGeometryData2D = null):
	if !fullMesh:
		fullMesh = NavigationMeshSourceGeometryData2D.new()
		var r = 1000
		var p = Vector2(0,0)
		var vec: Array[Vector2] = []
		vec.push_back(p + Vector2(-r,r))
		vec.push_back(p + Vector2(r,r))
		vec.push_back(p + Vector2(r,-r))
		vec.push_back(p + Vector2(-r,r))
		var collisionpolygon: PackedVector2Array = vec
		fullMesh.add_traversable_outline(collisionpolygon)
		
	for node in rootNode.get_children():
		if node.get_child_count() > 0 && node is Node2D:
			addAllChildMeshes(node, fullMesh)
		
		if node is CollisionShape2D:
			if node.shape is CircleShape2D:
				var r = node.shape.radius
				var p = node.global_position
				var vec: Array[Vector2] = []
				vec.push_back(p + Vector2(-r,r))
				vec.push_back(p + Vector2(r,r))
				vec.push_back(p + Vector2(r,-r))
				vec.push_back(p + Vector2(-r,r))
				var collisionpolygon: PackedVector2Array = vec
				
				fullMesh.add_obstruction_outline(collisionpolygon)
	
	return fullMesh

	#
#func parse_2d_collisionshapes(root_node: Node2D):
#
	#for node in root_node.get_children():
#
		#if node.get_child_count() > 0 && node is Node2D:
			#parse_2d_collisionshapes(node)
#
		#if node is CollisionShape2D:
			#
			#if node.shape is CircleShape2D:
#
				#var r = node.shape.radius
				#var p = Vector2(0,0)#node.global_position
				#var vec: Array[Vector2] = []
				#vec.push_back(p + Vector2(-r,r))
				#vec.push_back(p + Vector2(r,r))
				#vec.push_back(p + Vector2(r,-r))
				#vec.push_back(p + Vector2(-r,r))
				#var collisionpolygon_transform: Transform2D = node.get_global_transform()
				#var collisionpolygon: PackedVector2Array = vec
				#var new_collision_outline: PackedVector2Array = collisionpolygon_transform * collisionpolygon
				#new_navigation_polygon.add_outline(new_collision_outline)
				##
			##var collisionpolygon_transform: Transform2D = node.get_global_transform()
			##var collisionpolygon: PackedVector2Array = node.polygon
##
			##var new_collision_outline: PackedVector2Array = collisionpolygon_transform * collisionpolygon
##
			##new_navigation_polygon.add_outline(new_collision_outline)
