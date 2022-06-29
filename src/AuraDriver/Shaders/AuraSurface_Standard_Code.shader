Shader "AuraDriver/AuraSurface_Standard_Code"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset] [Normal] _NormalMap("Normal Map", 2D) = "bump" {}
        _NormalScale("Normal Scale", Range(0 , 1)) = 1
        [NoScaleOffset] _Metallic("Metallic", 2D) = "black" {}
        _Emission("Emission", 2D) = "black" {}
        [HDR] _EmissionColor("Emission Color", Color) = (0, 0, 0, 0)

        // Aura Properties
        [Header(Luma Aura)]
        _AuraIntensity("Aura Intensity", Float) = 1
        _AuraDistortion("Aura Distortion", Float) = 0.005
        _AuraNoise("Aura Noise", 2D) = "white" {}
        _AuraNoiseIntensity("Aura Noise Intensity", Range( 0 , 1)) = 1
        _AuraDriverCameraSize("AuraDriver Camera Size", Float) = 40
        _AuraDriverCameraOffsetX("AuraDriver Camera Offset X", Float) = 0
        _AuraDriverCameraOffsetZ("AuraDriver Camera Offset Z", Float) = 0
        [NoScaleOffset] _AuraDriverCRT("AuraDriver CRT", 2D) = "black" {}
        
        [HideInInspector] _texcoord( "", 2D ) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue" = "Geometry+0" "IsEmissive" = "true" }
        Cull Back
        LOD 200
        CGPROGRAM

        #pragma target 3.0
        #pragma surface surf Standard keepalpha addshadow fullforwardshadows

        struct Input
        {
            float2 uv_texcoord;

            // Required for Luma Aura
            float3 worldPos;
        };

        uniform sampler2D _MainTex;
        uniform float4    _MainTex_ST;
        uniform float4    _Color;        
        uniform sampler2D _NormalMap;
        uniform float     _NormalScale;
        uniform sampler2D _Metallic;
        uniform sampler2D _Emission;
        uniform float4    _Emission_ST;
        uniform float4    _EmissionColor;

        // Aura parameters
        uniform float     _AuraIntensity;
        uniform float     _AuraDistortion;
        uniform sampler2D _AuraNoise;
        uniform float4    _AuraNoise_ST;
        uniform float     _AuraNoiseIntensity;
        uniform float     _AuraDriverCameraSize;
        uniform float     _AuraDriverCameraOffsetX;
        uniform float     _AuraDriverCameraOffsetZ;
        uniform sampler2D _AuraDriverCRT;

        void surf (Input i, inout SurfaceOutputStandard o)
        {
            // Albedo
            float2 uvMainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
            o.Albedo = (_Color * tex2D(_MainTex, uvMainTex)).rgb;
            // Normal Map
            float3 normal = UnpackScaleNormal(tex2D(_NormalMap, uvMainTex), _NormalScale);
            o.Normal = normal;
            // Metallic Smoothness
            float4 metalSmooth = tex2D(_Metallic, uvMainTex);
            o.Metallic = metalSmooth.r;
            o.Smoothness = metalSmooth.a;
            // Emission
            o.Alpha = 1;

            // Luma Aura
            float2 worldPos = float2(i.worldPos.x - _AuraDriverCameraOffsetX, i.worldPos.z - _AuraDriverCameraOffsetZ);
            float2 auraPos = (normal * _AuraDistortion + float3((worldPos / (_AuraDriverCameraSize * 2.0) - float2(-0.5,-0.5)), 0)).xy;
            float2 uvEmission = i.uv_texcoord * _Emission_ST.xy + _Emission_ST.zw;
            float4 basicEmission = tex2D(_Emission, uvEmission) * _EmissionColor;
            float2 uvAuraNoise = i.uv_texcoord * _AuraNoise_ST.xy + _AuraNoise_ST.zw;
            float4 lerpAura = lerp(float4(1, 1, 1, 0), tex2D( _AuraNoise, uvAuraNoise), _AuraNoiseIntensity);
            float4 auraEmission = lerpAura * (tex2D(_AuraDriverCRT, auraPos) * _AuraIntensity);
            o.Emission = (basicEmission + auraEmission).rgb;            
        }
        ENDCG
    }
    FallBack "Diffuse"
}
