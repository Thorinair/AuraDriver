Shader "AuraDriver/AuraDriver_Fade"
{
    Properties
    {
        [Header(Basic Options)]
        [Space(15)]
        _FadeIn("Fade In", Float) = 0.1
        _FadeOut("Fade Out", Float) = 0.005
        [Space(10)]
        [NoScaleOffset] _AuraRT("Aura Render Texture", 2D) = "black" {}
    }

    SubShader
    {
        Lighting Off
        Blend One Zero

        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0

            #include "UnityCG.cginc"

            struct appdata {
                float2 uv : TEXCOORD0;
            };

            float _FadeIn;
            float _FadeOut;
            sampler2D _AuraRT;

            float computeChannel(float diff, float self, float rt) {
                if(diff >= 0) {
                    self += diff * _FadeIn;
                    self = clamp(self, 0, rt);
                }
                else {
                    self += diff * _FadeOut;
                    self = clamp(self, rt, 1);
                }
                return self;
            }
                
            float4 frag(v2f_customrendertexture IN) : COLOR {
                float2 uv = float2(IN.globalTexcoord.x, IN.globalTexcoord.y);
                
                float4 sampleRT = tex2D(_AuraRT, uv);
                float4 sampleSelf = tex2D(_SelfTexture2D, uv);
                float4 output = float4(0, 0, 0, 1);
                
                float3 diff = sampleRT - sampleSelf;
                
                output.x = computeChannel(diff.x, sampleSelf.x, sampleRT.x);
                output.y = computeChannel(diff.y, sampleSelf.y, sampleRT.y);
                output.z = computeChannel(diff.z, sampleSelf.z, sampleRT.z);
                
                return output;
            }
            ENDCG
        }
    }
}
