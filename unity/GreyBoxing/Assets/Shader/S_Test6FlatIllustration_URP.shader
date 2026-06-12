Shader "Custom/FlatIllustration_URP"
{
    // Equivalent URP de S_FlatIllustration.shader
    // Aplat mat + ombre 2 tons + grain papier leger + outline creme

    Properties
    {
        _BaseColor      ("Couleur",                 Color)          = (1,1,1,1)
        _BaseMap        ("Texture",                 2D)             = "white" {}

        // Ombre 2 tons plate (pas de degradé, bord net/doux)
        _ShadowColor     ("Teinte ombre",           Color)          = (0.75, 0.78, 0.85, 1)
        _ShadowThreshold ("Seuil ombre",            Range(-1, 1))   = 0.0
        _ShadowSoftness  ("Fondu bord",             Range(0, 0.3))  = 0.08
        _ShadowStrength  ("Intensité ombre",        Range(0, 1))    = 0.35

        // Grain papier leger (optionnel)
        _GrainTex       ("Grain papier",            2D)             = "white" {}
        _GrainStrength  ("Intensité grain",         Range(0, 0.25)) = 0.07
        _GrainScale     ("Echelle grain",           Range(0.1, 8))  = 2.0

        // Influence lumiere scene (0 = couleur pure, 1 = lumiere complete)
        _LightInfluence ("Influence lumiere",       Range(0, 1))    = 0.15

        // Outline creme tres fin
        _OutlineColor   ("Couleur outline",         Color)          = (0.97, 0.93, 0.87, 1)
        _OutlineWidth   ("Épaisseur outline",       Range(0, 0.02)) = 0.004
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType"     = "Opaque"
            "Queue"          = "Geometry"
        }

        // PASS 1 — Outline
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
                half4  _BaseColor;
                half4  _OutlineColor;
                float  _OutlineWidth;
                half4  _ShadowColor;
                float  _ShadowThreshold;
                float  _ShadowSoftness;
                float  _ShadowStrength;
                float  _GrainStrength;
                float  _GrainScale;
                float  _LightInfluence;
            CBUFFER_END

            struct Attributes { float4 positionOS:POSITION; float3 normalOS:NORMAL; };
            struct Varyings   { float4 positionCS:SV_POSITION; };

            Varyings vertOutline(Attributes v)
            {
                Varyings o;
                float4 clip  = TransformObjectToHClip(v.positionOS.xyz);
                float3 cn    = TransformWorldToHClip(TransformObjectToWorldNormal(v.normalOS)).xyz;
                float2 off   = normalize(cn.xy);
                off.x       /= _ScreenParams.x / _ScreenParams.y;
                clip.xy     += off * _OutlineWidth * clip.w;
                o.positionCS = clip;
                return o;
            }
            half4 fragOutline(Varyings i):SV_Target { return _OutlineColor; }
            ENDHLSL
        }

        // PASS 2 — Aplat 2 tons + grain
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

            TEXTURE2D(_BaseMap);  SAMPLER(sampler_BaseMap);
            TEXTURE2D(_GrainTex); SAMPLER(sampler_GrainTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _BaseColor;
                half4  _OutlineColor;
                float  _OutlineWidth;
                half4  _ShadowColor;
                float  _ShadowThreshold;
                float  _ShadowSoftness;
                float  _ShadowStrength;
                float  _GrainStrength;
                float  _GrainScale;
                float  _LightInfluence;
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
                float3 normalWS   : TEXCOORD1;
            };

            Varyings vert(Attributes v)
            {
                Varyings o;
                o.positionCS = TransformObjectToHClip(v.positionOS.xyz);
                o.normalWS   = TransformObjectToWorldNormal(v.normalOS);
                o.uv         = TRANSFORM_TEX(v.uv, _BaseMap);
                return o;
            }

            half4 frag(Varyings i) : SV_Target
            {
                half4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv) * _BaseColor;

                // Ombre 2 tons avec bord controlable
                Light  mainLight = GetMainLight();
                float3 normal    = normalize(i.normalWS);
                float  NdotL     = dot(normal, mainLight.direction);
                float  toon      = smoothstep(
                    _ShadowThreshold - _ShadowSoftness,
                    _ShadowThreshold + _ShadowSoftness,
                    NdotL
                );
                col.rgb = lerp(
                    col.rgb * _ShadowColor.rgb,
                    col.rgb,
                    lerp(1.0, toon, _ShadowStrength)
                );

                // Influence legere de la couleur de lumiere (sans ecraser les pastels)
                half3 litColor = col.rgb * mainLight.color;
                col.rgb = lerp(col.rgb, litColor, _LightInfluence);

                // Grain papier leger
                float grain  = SAMPLE_TEXTURE2D(_GrainTex, sampler_GrainTex, i.uv * _GrainScale).r - 0.5;
                col.rgb     += grain * _GrainStrength;

                // Ambiance legere (additive, ne multiplie plus col.rgb pour eviter l assombrissement)
                col.rgb += SampleSH(normal) * 0.10 * _LightInfluence;

                return half4(saturate(col.rgb), col.a);
            }
            ENDHLSL
        }

        // PASS 3 — Shadow Caster
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On ZTest LEqual Cull Back ColorMask 0
            HLSLPROGRAM
            #pragma vertex vertShadow
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
