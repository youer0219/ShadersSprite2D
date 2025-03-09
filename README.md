# ShadersSprite2D  
*Godot 4.4 Multi-Layer Shader Effect Node*  

[中文文档](README_zh.md) | [English Documentation](README.md)  

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 Overview  
A specialized `Sprite2D` subclass for **multi-pass shader processing** via chained `SubViewport` nodes. Features:  
- Real-time editor preview (supports auto-refresh)  
  - Allows manual refresh if visual anomalies occur  
- Dynamic parameter adjustment via scripts  

## 🛠️ Installation  
1. Add `ShadersSprite2D.gd` to your project  
2. Use it like a regular `Sprite2D`, but **DO NOT** manually set the `texture`/`material` properties  
3. For Godot versions below 4.4:  
   - The "Update" button and typed dictionaries may not work (modify/remove them if needed)  

## ⚙️ Configuration  
- Set `bottom_texture` (base texture) and `shaders_dic` (shader material dictionary) in the editor  

**Key Restrictions**:  
⚠️ **DO NOT** manually modify `texture`/`material` properties (managed internally)  
⚠️ Sprite2D material types: `ShaderMaterial` (recommended), `CanvasItemMaterial` (untested)  

## 🔬 Technical Implementation  

* SubViewport + ViewportTexture  

**Viewport Chain Construction**:  
1. Creates `SubViewport` nodes based on the length of `shaders_dic` (minus one)  
2. Each `SubViewport` contains a centered `Sprite2D` node  
3. Hierarchical setup:  
   - Each `SubViewport`'s output becomes the input texture for the previous-level `Sprite2D`  
   - The final-level `Sprite2D` uses `bottom_texture` directly  
4. All `SubViewport` nodes auto-match the size of `bottom_texture`  

**Node Structure Example**:  
```
ShadersSprite2D (Main node, applies Material 01)  
└── SubViewport1 (First Viewport)  
	└── Sprite2D (Applies Material 02)  
		└── SubViewport2  
			└── Sprite2D (Applies Material 03)  
				└── ... (Recursive until last level)  
```

## ⚠️ Known Issues (Resolved)  
| Description | Severity | Solution | Frequency |  
|-------------|----------|----------|-----------|  
| `ERROR: Path to node is invalid` (Editor) | Resolved | Safe to ignore - no runtime impact | Never |  

- Special thanks: https://forum.godotengine.org/u/mrcdk/summary  

## 📜 Credits & Licenses  
### Shader Authors  
| Effect Name | Author | Source | License |  
|-------------|--------|--------|---------|  
| Melting Screen | Shader Kitten | [GodotShaders](https://godotshaders.com/shader/doom-like-melting-screen/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| Random Shake + Flash | Rain | [GodotShaders](https://godotshaders.com/shader/simple-2d-random-shake-%ef%bc%86-flash/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  

### Core Script  
- **License**: MIT  
- **Compatibility**: Godot 4.4+  

## 🔄 Refresh Mechanism  
1. Complete configuration in the inspector  
2. Click the **Generate** button to:  
   - Rebuild the viewport chain  
   - Apply updated shader parameters  
   - Fix preview issues
