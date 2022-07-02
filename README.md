# AuraDriver

AuraDriver is an unofficial VRChat world-side plugin designed to generate the Luma Aura effect similar to the one that was on the [Furality](https://furality.org/) Aqua worlds. The effect would light up the ground, objects, plants, etc. as the player would walk around the worlds.

This plugin provides the basic functionality required to add it to your own worlds and comes with two example usable surface shaders. Advanced implementations will require you to copy the parts of it and implement it in your own shaders however.

**NOTE: This project is a derivative work and is not part of Furality Online Xperience or created by Furality, Inc.**

A live demo is available in the [Luminescent Ledge](https://vrchat.com/home/world/wrld_fb4edc80-6c48-43f2-9bd1-2fa9f1345621) VRChat world! Make sure to have an avatar with the [Aqua Shader](https://furality.org/aqua-shader-info) and with the correctly set Luma Aura Color property.

## Features
* Provides the infrastructure needed to add the Luma Aura effect to a world.
* Two example usable surface shaders, one made with [Amplify Shader Editor](https://assetstore.unity.com/packages/tools/visual-scripting/amplify-shader-editor-68570) and one as raw shader code.
* Example scene showing off the Aura Effect.

**Requires:** [VRChat SDK](https://docs.vrchat.com/docs/setting-up-the-sdk) Any newest version should be fine.

**Optional:** [Furality Aqua Shader](https://furality.org/aqua-shader-info) Aqua Shader is necessary if you wish to try the example scene.

## Usage
0. *Optional:* Import the [Furality Aqua Shader](https://furality.org/aqua-shader-info). The shader is necessary if you wish to try the example scene.
1. Import the AuraDriver Unity package.
2. Drag the `AuraDriver` prefab into the scene.
3. Make sure it is positioned somewhere above your world - it is essentially a camera.
4. If the world is not centered around X=0 and Z=0, feel free to move AuraDriver along X and Z, but make note of the new location.
5. If AuraDriver's camera is unable to fit the area of the world where you want the Aura to function, increase the camera's `Size` property and make note of it.
6. AuraDriver by default only makes objects that are on the `Player` and `PlayerLocal` layers as sources of the aura. If you want more layers, you can enable them on the camera's `Culling Mask` property.
7. Set the `AuraSurface_Standard_Amplify` or `AuraSurface_Standard_Code` shaders to the materials on objects in your scene which you want to react to the Aura. These two shaders are functionally the same and quite simple, but serve as starting points for those who want to write their own compatible shaders.
8. If you have changed the camera's size or moved AuraDriver previously, enter the correct values into the material properties `AuraDriver Camera Size`, `AuraDriver Camera Offset X` and `AuraDriver Camera Offset Z`.
9. If the `AuraDriver CRT` texture slot is empty, assign it the following: `AuraDriver/CustomRenderTexture/AuraDriver_Output` 
10. You are done! Feel free to test the world and see if your avatar makes the objects light up with aura. Make sure to have an avatar with the [Furality Aqua Shader](https://furality.org/aqua-shader-info) and with the correctly set Luma Aura property. Read below for more customization tips etc.

## Example Scene

![alt text](https://raw.githubusercontent.com/Thorinair/AuraDriver/master/img/ExampleScene.png "Example Scene")

Example scene gives an overview example of what you can do with AuraDriver. It comes with 4 objects which have materials on them that respond to the aura and a sphere which serves as a source of the aura.

### Using The Scene

1. Make sure to import [Furality Aqua Shader](https://furality.org/aqua-shader-info) first, otherwise the scene will not work correctly.
2. Open the scene located in `AuraDriver/Examples/AuraExample_Scene`
3. Hit play in Unity.
4. Move the sphere around and watch as the objects light up in different ways!
5. You can play around with the Aura color by changing it on the sphere's material.

## Customizing AuraDriver
AuraDriver can be customized in a few different places. Primarily, by changing how it behaves globally for the whole world it is in and how it behaves on certain materials.

### Global Properties

![alt text](https://raw.githubusercontent.com/Thorinair/AuraDriver/master/img/Custom01.png "Fade Customization")

The first set of properties can be found by opening the CustomRenderTexture asset located in: `AuraDriver/CustomRenderTexture/AuraDriver_Fade`. Here, you can adjust the speed at which the aura effect builds up and fades after the source has moved.

* **Fade In** - The time it takes for the aura to fade in when an aura source object enters the area.
* **Fade Out** - The time it takes for the aura to fade out when the aura source object leaves the area.
* **Aura Render Texture** - Input render texture. **Should not be changed.**

![alt text](https://raw.githubusercontent.com/Thorinair/AuraDriver/master/img/Custom02.png "Output Customization")

The second set of properties can be found by opening the CustomRenderTexture asset located in: `AuraDriver/CustomRenderTexture/AuraDriver_Output`. Here, you can adjust the level of blur applied to the aura as well as disabling the effect. Blurring is necessary to remove pixelization.

* **Luma Aura Enabled** - A toggle for the aura effect. Disabling will make the output simply black, disabling the aura effect.
* **Blur Size** - The size of the gaussian blur kernel. Higher values will have higher performance impact but will result in a more blurred effect.
* **Blur Spread** - Spread of the blurring effect within the kernel. 
* **Aura Fade Texture** - Input render texture. **Should not be changed.**

### Material Properties

![alt text](https://raw.githubusercontent.com/Thorinair/AuraDriver/master/img/Custom03.png "Material Customization")

Aura enabled shaders should have a set of certain standard properties to make them easier to work with. The two shaders that come with the package have identical properties.

* **Aura Intensity** - Intensity of the aura brightness on the material.
* **Aura Distortion** - An effect which uses the normal map of the material to apply a slight distortion to the glow. This creates a more natural and less flat effect.
* **Aura Noise** - A noise texture that can be used to add a bit of variation to the aura effect.
* **Aura Noise Intensity** - Defines how visible the noise texture is in the aura.
* **AuraDriver Camera Size** - Size of the camera attached to AuraDriver. Should always be same as the value set on AuraDriver prefab.
* **AuraDriver Camera Offset X** - X position in the world of the AuraDriver prefab.
* **AuraDriver Camera Offset Z** - Z position in the world of the AuraDriver prefab.
* **AuraDriver CRT** - Input render texture. **Should not be changed. Set it to `AuraDriver/CustomRenderTexture/AuraDriver_Output` if empty.**

## Advanced Topics

### Implementing Aura In Other Shaders
AuraDriver can be integrated to work with your own shaders. For this purpose, there are two available shaders which can be used to study how to integrate it into your own. These shaders are located within `AuraDriver/Shaders/` folder and are the following:

* **AuraSurface_Standard_Amplify** - This shader was made using the [Amplify Shader Editor](https://assetstore.unity.com/packages/tools/visual-scripting/amplify-shader-editor-68570). It can be used to study how to implement the aura on your own Amplify-made shaders.
* **AuraSurface_Standard_Code** - This shader was made as raw written code because some people prefer writing shaders like this. It can be used to study how to implement the aura in your own code written shaders.

### Making Any Shader An Aura Source
It is possible (and quite easy) to make any shader a source of the aura, much like how Aqua Shader is. To do this, simply add the line of code below into any shader's `Properties` block. This will create a color property which can be used to assign the color of the aura this material emits.

`_LumaAuraColor ("Luma Aura Color", Color) = (0, 0, 0)`

**NOTE:** This might not work out-of-the-box if the shader in question implements a custom property GUI.