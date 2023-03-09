extends CharacterBody2D

class_name Catlin

@onready var animator: AnimationPlayer = $CatlinAnimations
@onready var anim_tree: AnimationTree = $CatlinAnimationTree
@onready var spell_shape: CollisionShape2D = get_node("SpellArea/SpellAreaShape")

@export var speed_multiplier: float = 1.0
const MOVE_SPEED: float = 210.0
const ACCELERATION: float = MOVE_SPEED / 10
const DECELERATION: float = 20.0
var spell: String = "Shatter"
var input_vector: Vector2 = Vector2.ZERO
var face_vector: Vector2 = Vector2.DOWN
var move_vector: Vector2 = Vector2.ZERO
var movement: Vector2 = Vector2.ZERO
var action_name: String = ""
var input_value: Dictionary = {
	"move_north": false,
	"move_south": false,
	"move_west":  false,
	"move_east":  false,
	"shatter": false
}

#-----------------------------------
# Built In Functions
#-----------------------------------
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	move() # Move Catlin as directed by input
	turn() # Turn Catlin as directed by input

func _unhandled_input(event) -> void:
	action_name = get_action_name(event)
	
	if action_name == "": pass
	elif action_name == "shatter":
		cast_spell("shatter")
	else:
		set_input_value_dict(event)
		set_input_vector()
		set_face_vector()

#-----------------------------------
# Local Functions
#-----------------------------------
func move() -> void:
	if input_vector.length() > move_vector.length():
		move_vector = move_vector.move_toward(input_vector, ACCELERATION * speed_multiplier)
	else:
		move_vector = move_vector.move_toward(input_vector, DECELERATION * speed_multiplier)
	velocity = move_vector	
	move_and_slide()

func turn() -> void:
	anim_tree.set("parameters/Idle/blend_position", face_vector)

func cast_spell(_spell: String):
	animator.play("CastSpell")

func set_input_value_dict(event: InputEvent): # Run before set_input_vector()
	# Update input_value Dictionary
	if event.is_action_pressed(action_name,true): input_value[action_name] = true
	elif event: input_value[action_name] = false

func set_input_vector() -> void:
	# Update input_vector
	input_vector.x = int(input_value["move_east"]) - int(input_value["move_west"])
	input_vector.y = int(input_value["move_south"]) - int(input_value["move_north"])
	input_vector = input_vector.normalized() * MOVE_SPEED * speed_multiplier

func set_face_vector() -> void:
	if input_vector == Vector2.ZERO: return
	else: face_vector = input_vector.normalized()

func get_action_name(event: InputEvent) -> String:
	if event.is_action("move_north"): return "move_north"
	if event.is_action("move_south"): return "move_south"
	if event.is_action("move_west"): return "move_west"
	if event.is_action("move_east"): return "move_east"
	if event.is_action("shatter"): return "shatter"
	return ""


#func _on_spell_area_body_entered(body: Node2D) -> void:
#	if !(body is StaticBody2D): return
#	if body.name == "Boulder":
#		var boulder: StaticBody2D = get_node(body.get_path())
#		boulder.shatter()
