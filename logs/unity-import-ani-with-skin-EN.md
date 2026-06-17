# Unity Import Animation with Skin — Guide

1. Select the root folder of the model file
2. In the Inspector, go to the **Rig** tab, set Animation Type to **Humanoid**, and click Apply

3. Select the root folder of the animation file
4. In the Inspector, go to the **Rig** tab, set Animation Type to **Humanoid**, set Avatar Definition to **Copy from Other Avatar**, select the model from step 1, and click Apply
5. In the Inspector, go to the **Animation** tab, check the **Loop Time** option, and click Apply

6. Drag the model file into the Hierarchy

7. Select the animation file root folder in the Project, expand it, and drag the Clip file onto the model file in the Hierarchy (this will automatically create an Animation Controller with the same name as the model and save it to the Project)

8. Apply Material: In the Project, select the color texture of the material and drag it onto the expanded model file in the Hierarchy

9. Click Play, and you're done!
