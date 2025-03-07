# ShadersSprite2D  
*Multi-Pass Shader Processor for Godot 4.4*  

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 Overview  
A specialized `Sprite2D` subclass implementing **multi-pass shader processing** via chained `SubViewport` nodes. Key features:  
- Real-time editor preview (auto-refresh supported)  
- Dynamic parameter adjustment via scripting  
- CC0-licensed shader integration  

## 🛠️ Installation  
1. Add `ShadersSprite2D.gd` to your project  
2. Attach as child node to any 2D scene  

## ⚙️ Configuration  
```gdscript
# Configure in Inspector
@export var bottom_texture: Texture2D  # Base texture input
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
1. Create SubViewport chain matching shader count  
2. Apply one shader material per viewport  
3. Final output combines multi-layer effects  
4. Real-time structure inspectable via remote scene tree  

## ⚠️ Known Issues  
| Description | Impact | Solution |  
|------------|--------|----------|  
| `ERROR: Path to node is invalid` (Editor) | Cosmetic | Ignore - no runtime effect |  

## 📜 Credits & Licensing  
### Shader Authors  
| Effect | Author | Source | License |  
|--------|--------|--------|---------|  
| Screen Melt | Shader Kitten | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| Random Shake+Flash | Rain | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  

### Core Script  
- **License**: MIT  
- **Compatibility**: Godot 4.4+  

## 🔄 Refresh Workflow  
1. Complete configuration in Inspector  
2. Click **Generate** button to:  
   - Rebuild viewport chain  
   - Apply updated shader parameters  
   - Fix preview anomalies  
