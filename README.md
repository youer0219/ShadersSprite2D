# ShadersSprite2D  
*Multi-layer Shader Effects Node for Godot 4.4*  

[中文文档](README_zh.md) | [English Documentation](README.md)  

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 Overview  
A specialized Sprite2D subclass for **multi-pass shader processing** implemented via chained `SubViewport` nodes. Key features:  
- Real-time editor preview (supports auto-refresh)  
  - Allows manual refresh when image anomalies occur  
- Provides methods to modify specified shader properties in real-time  

## 🛠️ Installation  
1. Add `ShadersSprite2D.gd` to your project  
2. Use it like a regular Sprite2D. **Note**: Do not manually set the `texture`/`material` properties  
3. For Godot versions below 4.4: The "Generate" button and typed dictionaries may not work. Modify or remove them if needed (untested).  

## ⚙️ Configuration  
- Configure `shaders_texture` (base texture) and `shaders_dic` (shader material dictionary) in the editor  
- Adjust `size_expand` to expand viewport size if shaders exceed the original texture bounds  
- Modify SubViewport properties as needed for visual effects  
  - To customize, add `@export` properties and modify `_get_subviewport()`  

**Key Constraints**:  
⚠️ Do NOT manually set `texture`/`material` properties (managed internally)  
⚠️ Sprite2D material types: `ShaderMaterial` (recommended), `CanvasItemMaterial` (untested)  

## 🔬 Technical Implementation  
* SubViewport + ViewportTexture  

**Viewport Chain Construction**:  
1. Create SubViewports based on `shaders_dic` length (minus one)  
2. Each SubViewport contains a centered Sprite2D node  
3. Hierarchical setup:  
   - SubViewport output feeds into the previous Sprite2D's texture  
   - The last Sprite2D uses `shaders_texture` directly  
4. SubViewports auto-match `shaders_texture` size, with optional expansion  
5. Recommended reading: [SubViewport class reference](https://docs.godotengine.org/en/stable/classes/class_subviewport.html)

**Example Node Structure**:  
```
ShadersSprite2D (main node, applies Material 01)  
└── SubViewport1 (first viewport)  
	└── Sprite2D (applies Material 02)  
		└── SubViewport2  
			└── Sprite2D (applies Material 03)  
				└── ... (recursive to last layer)  
```  

## ⚠️ Known Issues (Resolved)  
| Description | Severity | Solution | Frequency |  
|-------------|----------|----------|-----------|  
| `ERROR: Path to node is invalid` (editor) | Resolved | Safe to ignore - no runtime impact | Never |  

- Special thanks: https://forum.godotengine.org/u/mrcdk/summary  

## 📜 Credits & Licenses  
### Shader Authors  
| Effect | Author | Source | License |  
|--------|--------|--------|---------|  
| Melting Screen | Shader Kitten | [GodotShaders](https://godotshaders.com/shader/doom-like-melting-screen/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| Random Shake + Flash | Rain | [GodotShaders](https://godotshaders.com/shader/simple-2d-random-shake-%ef%bc%86-flash/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  

### Core Script  
- **License**: MIT  
- **Compatibility**: Godot 4.4+  

## 🔄 Other Implementation Methods

- Can be implemented using the `CanvasGroup` node, but requires the ability to modify shaders  
	- Reference the shader implementation at [canvas_group_shader.gdshader](other_implementation_methods/canvas_group/canvas_group_shader.gdshader)
	- Recommended reading: [CanvasGroup class reference](https://docs.godotengine.org/en/stable/classes/class_canvasgroup.html)
