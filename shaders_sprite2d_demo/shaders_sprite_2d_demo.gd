extends Node2D

@onready var shaders_sprite_2d: ShadersSprite2D = %ShadersSprite2D

func _ready() -> void:
	_test_shaders_sprite2d()

func _test_shaders_sprite2d():
	print("====   Start Test   ====")  # ==== 开始测试 ====
	print("Display effect of applying two shaders simultaneously")  # 同时应用两个shader的效果展示
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Modify shader parameters to adjust effects")  # 修改shader的属性调整效果
	shaders_sprite_2d.set_shader_param_by_name("shader01","hit_effect",1)
	print("Expected effect: Shaking becomes more intense")  # 预期效果：抖动变得更加剧烈
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Modify shader parameters to adjust effects")  # 修改shader的属性调整效果
	shaders_sprite_2d.set_shader_param_by_name("shader02","movement",0.8)
	print("Expected effect: Image position clearly shifts down (out-of-bounds parts won't show)")  # 预期效果：图像显示位置明确下移
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Remove shake and flash shaders")  # 删除抖动和闪烁相关shader
	shaders_sprite_2d.erase_material("shader01")
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Add new shake and flash shader")  # 添加抖动和闪烁相关shader
	var new_material = load("res://shaders_sprite2d_demo/shaders/simple_2d_random_shake_and_flash.tres")
	shaders_sprite_2d.add_material("shader03",new_material)
	print("")
	
	await get_tree().create_timer(1.0).timeout
	print("====   Test Completed   ====")  # ==== 测试结束 ====
