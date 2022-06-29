Shader "AuraDriver/AuraDriver_Replacement"
{
    Properties
    {
        _LumaAuraColor ("Luma Aura Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _LumaAuraColor;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                if (_LumaAuraColor.x == 0 && _LumaAuraColor.y == 0 && _LumaAuraColor.z == 0 && _LumaAuraColor.w == 0)
                    o.vertex = fixed4(0, 0, 0, 0);
                else
                    o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return fixed4(_LumaAuraColor.x, _LumaAuraColor.y, _LumaAuraColor.z, 1);
            }
            ENDCG
        }
    }
}
