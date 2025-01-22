extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate(randf_range(0.0, PI * 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
