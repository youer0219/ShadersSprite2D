# ShadersSprite2D  
*Multi-Pass Shader Processor for Godot 4.4*  
[中文文档](README_zh.md) | [English Documentation](README.md)

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 Overview  
A specialized `Sprite2D` subclass implementing **multi-pass shader processing** via chained `SubViewport` nodes. Key features:  
• Real-time editor preview (auto-refresh supported)  
• Dynamic parameter adjustment via scripting  
• CC0-licensed shader integration  

## 🛠️ Installation  
1. Add `ShadersSprite2D.gd` to your project  
2. Attach as child node to any 2D scene  
3. If you're on an earlier version, the update button and typed dictionary won't work, but the rest of the parts should be fine! (Test required)

## ⚙️ Configuration  
```gdscript
// Configure in Inspector
@export var bottom_texture: Texture2D  // Base texture input
@export var shaders_dic: Dictionary[StringName, Material] = {
	"Effect1": preload("material1.tres"),
	"Effect2": preload("material2.tres")
}
```  
**Key Constraints**:  
⚠️ Never manually set `texture`/`material` properties (managed internally)  
⚠️ Material types: `ShaderMaterial` (recommended), `CanvasItemMaterial` (limited testing)  

## 🔬 Technical Implementation  

*SubViewport + ViewportTexture Architecture*

**Viewport Nesting Strategy**:  
1. Create SubViewport chain matching shader count (N-1 SubViewports for N shaders)  
2. Each SubViewport contains center-aligned Sprite2D node  
3. Hierarchical configuration:
   • SubViewport's output feeds previous Sprite2D's texture  
   • Final level uses `bottom_texture` directly  
4. Automatic size matching to base texture (`bottom_texture.get_size()`)

**Node Structure Example**:  
```
ShadersSprite2D (Main Node,Applies Material 01)
└── SubViewport1 (First Viewport)
	└── Sprite2D (Applies Material 02)
		└── SubViewport2
			└── Sprite2D (Applies Material 03)
				└── ... (Recursive to final level)
```


## ⚠️ List of Issues (All Resolved)
| Problem description | Impact Level | Solution | Frequency of occurrence |
|----------|----------|----------|----------|
| 'ERROR: Path to node is invalid' (editor) | Resolved | Negligible - Does not affect runtime | Never |

## 📜 Credits & Licensing  
### Shader Authors  
| Effect | Author | Source | License |  
|--------|--------|--------|---------|  
| Screen Melt | Shader Kitten | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| Random Shake+Flash | Rain | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  

### Core Script  
• **License**: MIT  
• **Compatibility**: Godot 4.4+  

## 🔄 Refresh Workflow  
1. Complete configuration in Inspector  
2. Click **Generate** button to:  
   • Rebuild viewport chain  
   • Apply updated shader parameters  
   • Fix preview anomalies  

---

🔧 The content comes from the AI's translation of the Chinese document, hopefully this is accurate.
