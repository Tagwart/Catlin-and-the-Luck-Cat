extends StaticBody2D

@onready var sprite: Sprite2D = $BoulderSprite
@onready var animator: AnimationPlayer = $BoulderAnimations
@onready var catlin = Catlin.new()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func shatter():
	animator.play("ShatterBoulder")


func _on_boulder_area_area_entered(area: Area2D) -> void:
	if !(area.name == "SpellArea"): return
	match catlin.spell:
		"Shatter":
			shatter()
		"Shart":
			print("Oh, no! Time to change your pants!")
