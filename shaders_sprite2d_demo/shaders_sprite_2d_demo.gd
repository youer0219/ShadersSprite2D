extends Node2D

@onready var shaders_sprite_2d: ShadersSprite2D = %ShadersSprite2D



func _ready() -> void:
	_test_shaders_sprite2d()


func _test_shaders_sprite2d():
	print("====   开始测试   ====")
	print("同时应用两个shader的效果展示")
	print("等待4s")
	
	await get_tree().create_timer(4.0).timeout
	print("修改shader的属性调整效果")
	shaders_sprite_2d.set_shader_param_by_name("shader01","hit_effect",1)
	print("预期效果： 抖动变得更加剧烈")
	print("等待4s")
	
	await get_tree().create_timer(4.0).timeout
	print("修改shader的属性调整效果")
	shaders_sprite_2d.set_shader_param_by_name("shader02","movement",0.8)
	print("预期效果： 图像显示位置明确下移（超过图像边界的不会显示）")
