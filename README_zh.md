# ShadersSprite2D 
*Godot 4.4 多层级着色器特效节点* 

[中文文档](README_zh.md) | [English Documentation](README.md)

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 概述
通过链式 `SubViewport` 节点实现的 **多通道着色器处理** 专用 Sprite2D 子类。功能特性：  
- 实时编辑器预览（支持自动刷新）
	- 支持在图像显示异常时手动刷新
- 提供实时修改指定shader属性的方法


## 🛠️ 安装
1. 将 `ShadersSprite2D.gd` 添加至项目  
2. 按照 Sprite2D 的使用方法使用。但注意 `texture`/`material` 属性不应该被手动设置
3. 如果你是较低版本，更新按钮和类型化字典将无法使用，可以将其修改或删除，但其他部分应该并无问题！（需要测试）

## ⚙️ 配置

- 在编辑器中配置 shaders_texture（基础纹理） 和 shaders_dic（shader材质字典） 
- 如果Shader的效果需要超出原有图像大小，则应该调整 size_expand 属性来扩大视口大小
- 按需配置subviewport的属性以实现预期的视觉效果
	- 如果需要自己定义，可以添加 @export 属性并只需要修改 _get_subviewport 方法即可

**关键限制**：  
⚠️ 不应该手动设置 `texture`/`material` 属性（由内部自动管理）  
⚠️ Sprite2D材质类型：`ShaderMaterial`（推荐），`CanvasItemMaterial`（未测试）  

## 🔬 技术实现  

* SubViewport + ViewportTexture

**视口链构建流程**：
1. 根据`shaders_dic`长度创建对应数量减一的SubViewport
2. 每个SubViewport内部创建中心对齐的Sprite2D节点
3. 逐级配置：
   - SubViewport的输出作为上一级Sprite2D的输入纹理
   - 末级Sprite2D直接使用`shaders_texture`作为输入
4. 每个SubViewport自动匹配基础纹理尺寸（`shaders_texture.get_size()`），同时按需设置窗口扩大比例
5. 推荐阅读[SubViewport节点文档](https://docs.godotengine.org/zh-cn/4.x/classes/class_subviewport.html)

**节点结构示例**：
```
ShadersSprite2D (主节点,应用 Material 01)
└── SubViewport1 (首视口)
	└── Sprite2D (应用 Material 02)
		└── SubViewport2
			└── Sprite2D (应用 Material 03)
				└── ...（递归至末级）
```

## ⚠️ 问题列表（已全部解决）
| 问题描述 | 影响级别 | 解决方案 | 发生频率 |  
|----------|----------|----------|----------|  
| `ERROR: Path to node is invalid` (编辑器) | 已解决 | 可忽略 - 不影响运行时 | 从不 | 

- 感谢指导：https://forum.godotengine.org/u/mrcdk/summary

## 📜 致谢与许可协议  
### 着色器作者  
| 特效名称 | 作者 | 来源 | 许可协议 |  
|---------|------|------|---------|  
| 熔融屏幕 | Shader Kitten | [GodotShaders](https://godotshaders.com/shader/doom-like-melting-screen/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| 随机抖动+闪光 | Rain | [GodotShaders](https://godotshaders.com/shader/simple-2d-random-shake-%ef%bc%86-flash/) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | 

### 核心脚本  
- **许可协议**：MIT  
- **适配版本**：Godot 4.4  

## 🔄 其他实现方法

- 可以使用canvas-group节点实现，但要求有改动着色器的能力
	- 可以参考[canvas_group_shader.gdshader](other_implementation_methods/canvas_group/canvas_group_shader.gdshader)的着色器实现
	- 推荐阅读[CanvasGroup节点文档](https://docs.godotengine.org/zh-cn/4.x/classes/class_canvasgroup.html)
