# Unity Import animation with skin note

1. 点击模型文件的根文件夹
2. 在Inspector里Rig标签下，设置Animation type 为Humanoid，点击apply

3. 点击动画文件的根文件夹
4. 在Inspector里Rig标签下，设置Animation type为Humanoid, Avatar Definition选 Copy from other avatar,选择第一步的模型，点apply
5. 在Inspector里Animation标签下， 有个Loop Time, 勾上，点apply

6. 把模型文件拖到Hierachy里面

7. 点击动画文件的根文件夹，展开，把Clip文件拖到Hierachy的模型文件根文件夹上（自动创建Animation Controler，和模型文件同名，且保存到了Project里

8. 附加材质：Project 中，点击材质的彩色贴图，拖到Hierachy 模型文件根文件夹展开的 模型文件上

9. 点击播放，就好了

