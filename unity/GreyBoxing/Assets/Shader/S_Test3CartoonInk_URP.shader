Shader "Custom/CartoonInk_URP"
{
    Properties
    {
        // ---- Base ----
        _BaseColor      ("Couleur",             Color)          = (1,1,1,1)
        _BaseMap        ("Texture",             2D)             = "white" {}

        // ---- Outline crayon/encre ----
        // Astuce : on module l'épaisseur avec un noise
        // pour simuler un trait irrégulier fait à la main
        _OutlineColor   ("Couleur trait",       Color)          = (0.08, 0.05, 0.03, 1)
        _OutlineWidth   ("Épaisseur trait",     Range(0, 0.02)) = 0.006
        _OutlineNoise   ("Irrégularité trait",  Range(0, 1))    = 0.45

        // ---- Dégradé ombre doux ----
        _ShadowColor    ("Teinte ombre",        Color)          = (0.55, 0.60, 0.75, 1)
        _ShadowSmooth   ("Douceur dégradé",     Range(0.01, 1)) = 0.6
        _ShadowShift    ("Décalage ombre",      Range(-1, 1))   = 0.1
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType"     = "Opaque"
            "Queue"          = "Geometry"
        }

        // =============================================
        // PASS 1 — Outline irrégulier (crayon/encre)
        // =============================================
        Pass
        {
            Name "Outline"
            Tags { "LightMode" = "SRPDefaultUnlit" }
            Cull Front
            ZWrite On

            HLSLPROGRAM
            #pragma vertex   vertOutline
            #pragma fragment fragOutline
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _OutlineColor;
                float  _OutlineWidth;
                float  _OutlineNoise;
                half4  _ShadowColor;
                float  _ShadowSmooth;
                float  _ShadowShift;
                half4  _BaseColor;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv         : TEXCOORD0;
            };

            // Hash simple pour simuler irrégularité du trait
            float hash(float2 p)
            {
                return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5);
            }

            Varyings vertOutline(Attributes v)
            {
                Varyings o;

                // Bruit basse fréquence sur la position pour
                // faire varier l'épaisseur du trait
                float noise = hash(v.positionOS.xy * 8.0);
                float width = _OutlineWidth * (1.0 - _OutlineNoise * noise * 0.5);

                // Extrusion en clip space (outline uniforme en écran)
                float4 clipPos  = TransformObjectToHClip(v.positionOS.xyz);
                float3 clipNorm = TransformWorldToHClip(
                    TransformObjectToWorldNormal(v.normalOS)).xyz;
                float2 offset   = normalize(clipNorm.xy);
                offset.x       /= _ScreenParams.x / _ScreenParams.y;
                clipPos.xy     += offset * width * clipPos.w;

                o.positionCS = clipPos;
                o.uv         = v.uv;
                return o;
            }

            half4 fragOutline(Varyings i) : SV_Target
            {
                return _OutlineColor;
            }
            ENDHLSL
        }

        // =============================================
        // PASS 2 — Couleur + dégradé doux cartoon
        // =============================================
        Pass
        {
            Name "ForwardLit"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _BaseColor;
                half4  _OutlineColor;
                float  _OutlineWidth;
                float  _OutlineNoise;
                half4  _ShadowColor;
                float  _ShadowSmooth;
                float  _ShadowShift;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float2 uv         : TEXCOORD0;
            };
            struct Varyings
            {
                float4 positionCS  : SV_POSITION;
                float2 uv          : TEXCOORD0;
                float3 normalWS    : TEXCOORD1;
                float3 positionWS  : TEXCOORD2;
            };

            Varyings vert(Attributes v)
            {
                Varyings o;
                VertexPositionInputs vpi = GetVertexPositionInputs(v.positionOS.xyz);
                o.positionCS = vpi.positionCS;
                o.positionWS = vpi.positionWS;
                o.normalWS   = TransformObjectToWorldNormal(v.normalOS);
                o.uv         = TRANSFORM_TEX(v.uv, _BaseMap);
                return o;
            }

            half4 frag(Varyings i) : SV_Target
            {
                // --- Texture * couleur ---
                half4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv) * _BaseColor;

                // --- Lumière principale URP ---
                Light mainLight = GetMainLight();
                float3 normal   = normalize(i.normalWS);
                float  NdotL    = dot(normal, mainLight.direction);

                // Dégradé doux : smoothstep large = fondu progressif
                // Pas de bord dur, look illustration 2D douce
                float ramp = smoothstep(
                    _ShadowShift - _ShadowSmooth,
                    _ShadowShift + _ShadowSmooth,
                    NdotL
                );

                // Mélange couleur de base / teinte ombre
                half3 shadedCol = lerp(_ShadowColor.rgb * col.rgb, col.rgb, ramp);

                // Lumière ambiante URP (SH)
                half3 ambient = SampleSH(normal) * 0.5;
                shadedCol    += ambient * col.rgb * 0.15;

                // Couleur de la lumière principale
                shadedCol    *= mainLight.color;

                return half4(saturate(shadedCol), col.a);
            }
            ENDHLSL
        }

        // =============================================
        // PASS 3 — Shadow Caster URP
        // =============================================
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On
            ZTest  LEqual
            Cull   Back
            ColorMask 0

            HLSLPROGRAM
            #pragma vertex   vertShadow
            #pragma fragment fragShadow
            #pragma multi_compile_shadowcaster
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
    }
}
