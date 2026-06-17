# Unity Import Animation with Skin Note

1. Click on the root folder of the model file
2. In the Inspector, under the Rig tab, set Animation type to Humanoid, then click apply

3. Click on the root folder of the animation file
4. In the Inspector, under the Rig tab, set Animation type to Humanoid, and in Avatar Definition select "Copy from other avatar", then choose the model from step 1, and click apply
5. In the Inspector, under the Animation tab, check the "Loop Time" option and click apply

6. Drag the model file into the Hierarchy

7. Click on the root folder of the animation file, expand it, and drag the Clip file to the root folder of the model file in the Hierarchy (this automatically creates an Animation Controller with the same name as the model file and saves it to the Project)

8. Apply material: In the Project, click on the color map of the material and drag it to the expanded model file in the Hierarchy's root folder

9. Click play, and you're done!
