extends State
class_name PlayerState

const IDLE = "Idle"
const DASH = "Dash"
const ATTACK1 = "Attack1"
const ATTACK2 = "Attack2"
const ATTACK3 = "Attack3"
const DODGE = "Dodge"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
	print("Starting State")
