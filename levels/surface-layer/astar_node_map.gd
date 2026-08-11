extends Node2D

@export var collision_map: TileMapLayer
var astar_grid: AStarGrid2D

func _ready() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_size = collision_map.tile_set.tile_size
	astar_grid.region = Rect2(Vector2.ZERO, ceil(get_viewport_rect().size/astar_grid.cell_size))
	astar_grid.update()
	
	for id in collision_map.get_used_cells():
		var data = collision_map.get_cell_tile_data(id)
		if data and data.get_custom_data('obstacle'):
			astar_grid.set_point_solid(id)

func get_grid()->AStarGrid2D:
	return astar_grid
