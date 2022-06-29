// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "AuraDriver/AuraSurface_Standard_Amplify"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,0)
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 1)) = 1
		[NoScaleOffset]_Metallic("Metallic", 2D) = "black" {}
		_Emission("Emission", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[Header(Luma Aura)]_AuraIntensity("Aura Intensity", Float) = 1
		_AuraDistortion("Aura Distortion", Float) = 0.005
		_AuraNoise("Aura Noise", 2D) = "white" {}
		_AuraNoiseIntensity("Aura Noise Intensity", Range( 0 , 1)) = 1
		_AuraDriverCameraSize("AuraDriver Camera Size", Float) = 40
		_AuraDriverCameraOffsetX("AuraDriver Camera Offset X", Float) = 0
		_AuraDriverCameraOffsetZ("AuraDriver Camera Offset Z", Float) = 0
		[NoScaleOffset]_AuraDriverCRT("AuraDriver CRT", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _NormalMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _NormalScale;
		uniform float4 _Color;
		uniform sampler2D _Emission;
		uniform float4 _Emission_ST;
		uniform float4 _EmissionColor;
		uniform sampler2D _AuraNoise;
		uniform float4 _AuraNoise_ST;
		uniform float _AuraNoiseIntensity;
		uniform sampler2D _AuraDriverCRT;
		uniform float _AuraDistortion;
		uniform float _AuraDriverCameraOffsetX;
		uniform float _AuraDriverCameraOffsetZ;
		uniform float _AuraDriverCameraSize;
		uniform float _AuraIntensity;
		uniform sampler2D _Metallic;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 tex2DNode18 = UnpackScaleNormal( tex2D( _NormalMap, uv_MainTex ), _NormalScale );
			o.Normal = tex2DNode18;
			o.Albedo = ( _Color * tex2D( _MainTex, uv_MainTex ) ).rgb;
			float2 uv_Emission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
			float2 uv_AuraNoise = i.uv_texcoord * _AuraNoise_ST.xy + _AuraNoise_ST.zw;
			float4 lerpResult33 = lerp( float4( 1,1,1,0 ) , tex2D( _AuraNoise, uv_AuraNoise ) , _AuraNoiseIntensity);
			float3 ase_worldPos = i.worldPos;
			float2 appendResult3 = (float2(( ase_worldPos.x - _AuraDriverCameraOffsetX ) , ( ase_worldPos.z - _AuraDriverCameraOffsetZ )));
			o.Emission = ( ( tex2D( _Emission, uv_Emission ) * _EmissionColor ) + ( lerpResult33 * ( tex2D( _AuraDriverCRT, ( ( tex2DNode18 * _AuraDistortion ) + float3( ( ( appendResult3 / ( _AuraDriverCameraSize * 2.0 ) ) - float2( -0.5,-0.5 ) ) ,  0.0 ) ).xy ) * _AuraIntensity ) ) ).rgb;
			float4 tex2DNode20 = tex2D( _Metallic, uv_MainTex );
			o.Metallic = tex2DNode20.r;
			o.Smoothness = tex2DNode20.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
363;337;1716;894;1956.44;-22.315;1.3;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-1634.462,739.4495;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;47;-1718.343,959.839;Inherit;False;Property;_AuraDriverCameraOffsetZ;AuraDriver Camera Offset Z;13;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1718.743,884.6392;Inherit;False;Property;_AuraDriverCameraOffsetX;AuraDriver Camera Offset X;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1366.989,1010.406;Inherit;False;Property;_AuraDriverCameraSize;AuraDriver Camera Size;11;0;Create;True;0;0;0;False;0;False;40;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1239.684,-864.86;Inherit;True;Property;_MainTex;Main Texture;0;0;Create;False;0;0;0;False;0;False;None;5c797996fcdfee8448319a1473741131;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-1436.617,742.193;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-1437.617,833.193;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1107.753,1015.268;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-991.2538,-601.8876;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-1053.956,-467.4516;Inherit;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;3;-1287.723,763.8575;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;51;-1218.607,-659.9393;Inherit;True;Property;_NormalMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;09afd84b35363d746bc65a479d719b05;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-1107.205,796.5004;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1342.162,665.9589;Inherit;False;Property;_AuraDistortion;Aura Distortion;8;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;18;-763.237,-661.2861;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-1164.489,645.5511;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;6;-979.4336,796.3045;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;-0.5,-0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;7;-1035.805,565.9249;Inherit;True;Property;_AuraDriverCRT;AuraDriver CRT;14;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;636c634864f6a034bab54043f2238e7e;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;32;-1029.721,290.9917;Inherit;True;Property;_AuraNoise;Aura Noise;9;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;45;-820.1359,767.7452;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-630.6987,828.5113;Inherit;False;Property;_AuraIntensity;Aura Intensity;7;1;[Header];Create;True;1;Luma Aura;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-749.4211,290.9918;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1001.015,-121.7607;Inherit;True;Property;_Emission;Emission;5;0;Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;8;-748.7634,565.6493;Inherit;True;Property;_AuraDriverCRTInput;AuraDriver CRT (Input);31;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;34;-731.788,484.6831;Inherit;False;Property;_AuraNoiseIntensity;Aura Noise Intensity;10;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-765.7148,-121.7606;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-441.4407,723.8598;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;33;-416.788,295.6831;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-679.4945,68.06554;Inherit;False;Property;_EmissionColor;Emission Color;6;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-988.9419,-278.856;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-257.0232,296.7513;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;15;-761.9401,-860.9568;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;19;-1231.902,-348.5223;Inherit;True;Property;_Metallic;Metallic;4;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;419a41d23ffba09469d0e04d7fa45ae9;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-446.5641,-117.4161;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-677.9199,-1041.985;Inherit;False;Property;_Color;Color;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.6792453,0.6792453,0.6792453,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-768.4263,-345.9223;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-135.3074,111.8906;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-441.3197,-879.4847;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;123.9472,-117.2834;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;AuraDriver/AuraSurface_Standard_Amplify;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;49;0;1;1
WireConnection;49;1;46;0
WireConnection;50;0;1;3
WireConnection;50;1;47;0
WireConnection;4;0;2;0
WireConnection;36;2;14;0
WireConnection;3;0;49;0
WireConnection;3;1;50;0
WireConnection;5;0;3;0
WireConnection;5;1;4;0
WireConnection;18;0;51;0
WireConnection;18;1;36;0
WireConnection;18;5;38;0
WireConnection;44;0;18;0
WireConnection;44;1;43;0
WireConnection;6;0;5;0
WireConnection;45;0;44;0
WireConnection;45;1;6;0
WireConnection;31;0;32;0
WireConnection;8;0;7;0
WireConnection;8;1;45;0
WireConnection;12;0;13;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;33;1;31;0
WireConnection;33;2;34;0
WireConnection;37;2;14;0
WireConnection;11;0;33;0
WireConnection;11;1;10;0
WireConnection;15;0;14;0
WireConnection;30;0;12;0
WireConnection;30;1;29;0
WireConnection;20;0;19;0
WireConnection;20;1;37;0
WireConnection;35;0;30;0
WireConnection;35;1;11;0
WireConnection;23;0;22;0
WireConnection;23;1;15;0
WireConnection;0;0;23;0
WireConnection;0;1;18;0
WireConnection;0;2;35;0
WireConnection;0;3;20;1
WireConnection;0;4;20;4
ASEEND*/
//CHKSM=F51E6B22141E1D23C0C00B33DF7F014218094C98