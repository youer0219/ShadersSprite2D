extends Node2D

@onready var shaders_sprite_2d: ShadersSprite2D = %ShadersSprite2D

func _ready() -> void:
	_test_shaders_sprite2d()

func _test_shaders_sprite2d():
	print("====   Start Test   ====")  # ==== 开始测试 ====
	print("Display effect of applying shaders simultaneously")  # 同时应用多个shader的效果展示
	# 可以注意到，图像的size_expand设置为1.2，这是因为描边需要更多的空间。
	print("It can be noticed that the size_expand of the image is set to 1.2, and this is because the stroke requires more space.")
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Change texture")  # 修改图像
	var new_texture = load("res://shaders_sprite2d_demo/image/rgb_low_entropy_image_512x512.png")
	shaders_sprite_2d.shaders_texture = new_texture
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Modify shader parameters to adjust effects")  # 修改shader的属性调整效果
	shaders_sprite_2d.set_shader_param_by_name("shader01","hit_effect",1)
	print("Expected effect: Shaking becomes more intense")  # 预期效果：抖动变得更加剧烈
	print("Wait 4 seconds")  # 等待4s
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Modify shader parameters to adjust effects")  # 修改shader的属性调整效果
	## TODO: Call the method via tween to set the animation
	shaders_sprite_2d.set_shader_param_by_name("shader02","gray_scale",0.8)
	print("Expected effect: iamge more gray")  # 预期效果：图像明显变灰
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
	shaders_sprite_2d.add_material("shader01",new_material)
	print("")
	
	await get_tree().create_timer(4.0).timeout
	print("Add melting_screen_like_shader_material")  # 添加一个屏幕图像融化的shader
	var new_material02 = load("res://shaders_sprite2d_demo/shaders/melting_screen_like_shader_material.tres")
	shaders_sprite_2d.add_material("shader04",new_material02)
	print("")
	
	await get_tree().create_timer(1.0).timeout
	print("====   Test Completed   ====")  # ==== 测试结束 ====
