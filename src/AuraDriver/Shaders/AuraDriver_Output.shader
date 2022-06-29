Shader "AuraDriver/AuraDriver_Output"
{
    Properties
    {
        [Header(Basic Options)]
        [Space(15)]
        [MaterialToggle] _IsEnabled("Luma Aura Enabled", Float) = 1
        [Space(10)]
        _BlurSize("Blur Size", Float) = 11
        _BlurSpread("Blur Spread", Float) = 0.5
        [Space(10)]
        [NoScaleOffset] _AuraFadeCRT("Aura Fade Texture", 2D) = "black" {}
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
            
            static const float TWO_PI = 6.28319;
            static const float E = 2.71828;

            float _IsEnabled;
            float _BlurSize;
            float _BlurSpread;
            sampler2D _AuraFadeCRT;
            float4 _AuraFadeCRT_ST;
            half4 _AuraFadeCRT_TexelSize;

            float4 frag(v2f_customrendertexture IN) : COLOR {
                if (_IsEnabled == 1) {
                    fixed3 sum = fixed3(0, 0, 0);
                    float3 col = float3(0, 0, 0);
                    float kernelSum = 0;

                    _BlurSize = round(_BlurSize);
                    _BlurSize = -(1.0 - saturate(fmod(_BlurSize, 2.0))) + _BlurSize;
                    _BlurSize = clamp(_BlurSize, 1, 39);

                    int upper = ((_BlurSize - 1) / 2 );
                    int lower = -upper;

                    for (int x = lower; x <= upper; ++x)
                    {
                        for (int y = lower; y <= upper; ++y)
                        {
                            float sigmaSqu = _BlurSpread * _BlurSpread;
                            float gauss = (1 / sqrt(TWO_PI * sigmaSqu)) * pow(E, -((x * x) + (y * y)) / (2 * sigmaSqu));
                            kernelSum += gauss;

                            fixed2 offset = fixed2(_AuraFadeCRT_TexelSize.x * x, _AuraFadeCRT_TexelSize.y * y);
                            col += gauss * tex2Dlod(_AuraFadeCRT, float4(IN.localTexcoord.xy + offset.xy, 0, 0));
                        }
                    }

                    col /= kernelSum;
                    return float4(col, 1);
                }
                return fixed4(0, 0, 0, 1);
            }
            ENDCG
        }
    }
}
