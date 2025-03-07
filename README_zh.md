# ShadersSprite2D 
*Godot 4.4 多层级着色器特效节点*  

![Godot 4.4+](https://img.shields.io/badge/Godot-4.4%2B-%23478cbf)  

## 🔍 概述  
通过链式 `SubViewport` 节点实现的 **多通道着色器处理** 专用 Sprite2D 子类。功能特性：  
- 实时编辑器预览（支持自动刷新）  
- 脚本动态参数调整  
- 兼容 CC0 协议的着色器集成  

## 🛠️ 安装  
1. 将 `ShadersSprite2D.gd` 添加至项目  
2. 作为子节点挂载到任意 2D 场景  

## ⚙️ 配置  
```gdscript
# 在检视器面板配置
@export var bottom_texture: Texture2D  # 基础纹理输入
@export var shaders_dic: Dictionary[StringName, Material] = {
	"特效1": preload("material1.tres"),
	"特效2": preload("material2.tres")
}
```  
**关键限制**：  
⚠️ 禁止手动设置 `texture`/`material` 属性（由内部自动管理）  
⚠️ 材质类型：`ShaderMaterial`（推荐），`CanvasItemMaterial`（未充分测试）  

## 🔬 技术实现  
  
* SubViewport + ViewportTexture

采用 **视口嵌套策略**：  
1. 创建与着色器数量匹配的 SubViewport 链  
2. 每个视口应用一个着色器材质  
3. 最终输出为多层级特效叠加结果  
4. 可通过远程场景树调试工具查看实时结构  

## ⚠️ 已知问题  
| 问题描述 | 影响范围 | 解决方案 |  
|---------|---------|---------|  
| `ERROR: Path to node is invalid`（编辑器报错） | 仅显示问题 | 忽略 - 不影响运行时 |  

## 📜 致谢与许可协议  
### 着色器作者  
| 特效名称 | 作者 | 来源 | 许可协议 |  
|---------|------|------|---------|  
| 熔融屏幕 | Shader Kitten | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) |  
| 随机抖动+闪光 | Rain | [GodotShaders](https://godotshaders.com) | [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/) | 

### 核心脚本  
- **许可协议**：MIT  
- **适配版本**：Godot 4.4  

## 🔄 刷新机制  
1. 在检视器面板完成配置  
2. 点击 **Generate** 按钮实现：  
   - 重建视口链  
   - 应用更新后的着色器参数  
   - 修复预览异常  
