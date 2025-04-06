extends Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SignalBus.flip_arrow.connect(FlipArrow)

func FlipArrow() ->void:
	self.flip_v = true
