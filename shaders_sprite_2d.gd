@tool
class_name ShadersSprite2D
extends Sprite2D
## Usage Method:
## Add images to the bottom_texture; add the shader name and shader material resources to the shaders_dic.
## Do not configure the texture and material properties of the Sprite2D by yourself, as they will be replaced!
## This node can also display the effect in real-time in the editor. However, currently, there is an issue where the image may not be displayed correctly due to problems such as incorrect data configuration.
## After configuring the data correctly, you can click the generate button to refresh it.
## WARNING: Materials of the CanvasItemMaterial type are allowed to be created here, but the author has not used them, so there is no testing...
## Known Editor Error: ERROR: Path to node is invalid: 'Sprite2D/@SubViewport@23869'.
## But it seems to have no impact on the program. 

@export_tool_button("generate") var genarete_func = generate
@export var bottom_texture:Texture2D:
	set(value):
		bottom_texture = value
		generate()
		update_configuration_warnings()
@export var shaders_dic:Dictionary[StringName,Material]:
	set(value):
		shaders_dic = value
		generate()
		update_configuration_warnings()

var first_sub_viewport:SubViewport

func _ready() -> void:
	generate()

func clear():
	texture = null
	material = null
	if first_sub_viewport != null:
		first_sub_viewport.queue_free()
		first_sub_viewport = null

func set_shader_param_by_name(choose_material_name:StringName,param:StringName, value:Variant):
	var choose_material = get_material_by_name(choose_material_name) as ShaderMaterial
	if choose_material == null:
		return null
	choose_material.set_shader_parameter(param,value)

func get_material_by_name(choose_material_name:StringName)->Material:
	if not shaders_dic.has(choose_material_name):
		push_warning(name + " shaders_dir" + "not has "+ choose_material_name)
		return null
	return shaders_dic[choose_material_name]

func generate():
	clear()
	
	if bottom_texture == null:
		return
	
	var shaders_dic_size := shaders_dic.size()
	
	## 没有shader，返回
	if shaders_dic_size == 0:
		return
	
	var last_sprite_2d:Sprite2D = self
	var shaders_array:Array = shaders_dic.values()
	
	for shader in shaders_array:
		assert(shader.is_class("ShaderMaterial") or shader.is_class("CanvasItemMaterial"),"错误的sprite材质配置")
	
	for index in shaders_dic_size:
		last_sprite_2d.material = shaders_array[index]
		
		if shaders_dic_size - index == 1:
			last_sprite_2d.texture = bottom_texture
		else:
			## 添加subviewport
			var new_subviewport:SubViewport = _get_subviewport()
			last_sprite_2d.add_child(new_subviewport)
			if first_sub_viewport == null:
				first_sub_viewport = new_subviewport
			
			## 给sprite2d添加viewport-texture
			last_sprite_2d.texture = new_subviewport.get_texture()
			
			## 添加新的sprite2d
			var new_sprite_2d:Sprite2D = Sprite2D.new()
			new_sprite_2d.position = bottom_texture.get_size() / 2.0
			new_subviewport.add_child(new_sprite_2d)
			last_sprite_2d = new_sprite_2d


## 内部方法。获取一个适配图像大小的禁用3D渲染的透明背景的SubViewport实例化节点。
func _get_subviewport()->SubViewport:
	var subviewport = SubViewport.new()
	subviewport.disable_3d = true
	subviewport.transparent_bg = true
	subviewport.size = bottom_texture.get_size()
	
	return subviewport

func _get_configuration_warnings():
	var warnings = []
	
	if shaders_dic.size() <= 1:
		## 不建议在没有或只有一个shader的情况下使用该节点
		warnings.append("It is not recommended to use this node when there is no shader or only one shader.")
	
	var shader_materals := shaders_dic.values()
	for shader_materal in shader_materals:
		if not (shader_materal.is_class("ShaderMaterial") or shader_materal.is_class("CanvasItemMaterial")):
			## 请保证字典中的材质为ShaderMaterial或CanvasItemMaterial类型
			warnings.append("Please ensure that the materials in the dictionary are of the ShaderMaterial or CanvasItemMaterial type.")
			break
	
	if bottom_texture == null:
		## 没有图像，shader资源无法生效
		warnings.append("Without an image, the shader resource will not take effect.")
	
	return warnings
