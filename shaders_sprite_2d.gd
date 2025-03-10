@tool
class_name ShadersSprite2D
extends Sprite2D
## Multi-pass shader processor for Sprite2D with real-time editor preview.
## [br][br]Usage:
## - Set base texture in 'shaders_texture'
## - Add shader materials to 'shaders_dic' (key: shader name, value: material)
## - Click generate button to refresh effects
## [br][br]Warnings:
## - Do NOT manually set texture/material properties - they will be overwritten
## - Only supports CanvasItemMaterial/ShaderMaterial types
## - Editor preview may glitch with invalid configurations

## This property makes the subviewport background transparent. This property should not be modified at all.
const TRANSPARENT_BG :bool = true

## if texture show wrong,press it to refresh
@export_tool_button("generate") var genarete_func = generate

@export var shaders_texture:Texture2D:
	set(value):
		shaders_texture = value
		generate()
		update_configuration_warnings()
@export var shaders_dic:Dictionary[StringName,Material]:
	set(value):
		shaders_dic = value
		generate()
		update_configuration_warnings()

@export_group("Subviewport Setting")
## Expands the size to handle special shaders that expand the display range of the image
@export var size_expand:Vector2 = Vector2(1,1)
@export var snap_2d_transforms_to_pixel:bool = false
@export var snap_2d_vertices_to_pixel:bool = false
@export var canvas_item_default_texture_filter:Viewport.DefaultCanvasItemTextureFilter = Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_LINEAR 
## Modifications are not recommended, as 3D rendering is generally not required
@export var disable_3d:bool = true

var first_sub_viewport:SubViewport # Root viewport for effect chain

func _ready() -> void:
	generate()

## Clears all generated nodes and resets state
func clear():
	texture = null
	material = null
	if first_sub_viewport != null:
		first_sub_viewport.queue_free()
		first_sub_viewport = null

## Updates shader parameter for specified material
func set_shader_param_by_name(choose_material_name:StringName,param:StringName, value:Variant):
	var choose_material = get_material_by_name(choose_material_name) as ShaderMaterial
	if choose_material == null:
		return null
	choose_material.set_shader_parameter(param,value)

func add_material(material_name:StringName,new_material:Material):
	if shaders_dic.has(material_name):
		push_warning("Try adding duplicate keys to the dictionary")
		return
	shaders_dic[material_name] = new_material
	generate()

func erase_material(material_name:StringName):
	if not shaders_dic.has(material_name):
		push_warning("Try removing attributes that aren't in the dictionary!")
		return
	shaders_dic.erase(material_name)
	generate()

## Retrieves material from dictionary by name
func get_material_by_name(choose_material_name:StringName)->Material:
	if not shaders_dic.has(choose_material_name):
		push_warning(name + " shaders_dir" + "not has "+ choose_material_name)
		return null
	return shaders_dic[choose_material_name]

## Generates multi-pass shader effect chain
func generate():
	clear()
	
	if shaders_texture == null:
		return
	
	var shaders_dic_size := shaders_dic.size()
	
	## no shader and return
	if shaders_dic_size == 0:
		texture = shaders_texture
		return
	
	var last_sprite_2d:Sprite2D = self
	var shaders_array:Array = shaders_dic.values()
	
	for shader in shaders_array:
		assert(shader.is_class("ShaderMaterial") or shader.is_class("CanvasItemMaterial"),"错误的sprite材质配置")
	
	for index in shaders_dic_size:
		last_sprite_2d.material = shaders_array[index]
		
		if shaders_dic_size - index == 1:
			last_sprite_2d.texture = shaders_texture
		else:
			## add subviewport
			var new_subviewport:SubViewport = _get_subviewport()
			last_sprite_2d.add_child(new_subviewport)
			
			## node first subviewport
			if first_sub_viewport == null:
				first_sub_viewport = new_subviewport
			
			## add viewport-texture for last sprite2d
			last_sprite_2d.texture = new_subviewport.get_texture()
			
			## add new sprite2d
			var new_sprite_2d:Sprite2D = Sprite2D.new()
			new_sprite_2d.position = new_subviewport.size / 2.0
			new_subviewport.add_child(new_sprite_2d)
			last_sprite_2d = new_sprite_2d


## Creates configured SubViewport
func _get_subviewport()->SubViewport:
	var subviewport = SubViewport.new()
	subviewport.disable_3d = disable_3d
	subviewport.transparent_bg = TRANSPARENT_BG
	subviewport.size = shaders_texture.get_size() * size_expand
	subviewport.snap_2d_transforms_to_pixel = snap_2d_transforms_to_pixel
	subviewport.snap_2d_vertices_to_pixel = snap_2d_vertices_to_pixel
	subviewport.canvas_item_default_texture_filter = canvas_item_default_texture_filter
	
	return subviewport


func _get_configuration_warnings():
	var warnings = []
	
	if shaders_dic.size() <= 1:
		warnings.append("It is not recommended to use this node when there is no shader or only one shader.")
	
	var shader_materals := shaders_dic.values()
	for shader_materal in shader_materals:
		if not (shader_materal.is_class("ShaderMaterial") or shader_materal.is_class("CanvasItemMaterial")):
			warnings.append("Only ShaderMaterial/CanvasItemMaterial supported.")
			break
	
	if shaders_texture == null:
		warnings.append("No bottom image provided; shaders won't take effect.")
	
	return warnings

## Delete the texture before saving, and assign the value again after saving 
## to avoid the editor error by saving the automatically generated viewport texture to the scene file('Path to node is invalid')
## The solution comes from:
## https://forum.godotengine.org/t/how-to-make-variables-for-scripts-running-in-the-editor-not-save-to-the-scene-file-in-godot/104490/2
## Thanks for the guidance:https://forum.godotengine.org/u/mrcdk/summary
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			texture = null
		NOTIFICATION_EDITOR_POST_SAVE:
			if first_sub_viewport != null:
				texture = first_sub_viewport.get_texture()
