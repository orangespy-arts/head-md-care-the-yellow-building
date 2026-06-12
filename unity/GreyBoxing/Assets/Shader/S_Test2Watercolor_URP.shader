Shader "Custom/Watercolor_URP"
{
    // Equivalent URP de S_Watercolor.shader
    // Variation pigment + bords assombris (pigment sec) + opacite papier

    Properties
    {
        _BaseColor      ("Couleur",                 Color)          = (1,1,1,1)
        _BaseMap        ("Texture",                 2D)             = "white" {}

        // Noise aquarelle : variation irreguliere du pigment
        _NoiseTex       ("Noise aquarelle",         2D)             = "white" {}
        _NoiseScale     ("Echelle noise",           Range(0.5, 8))  = 2.0
        _NoiseStrength  ("Variation pigment",       Range(0, 0.4))  = 0.15

        // Bords assombris : pigment qui seche sur les contours
        _EdgeDarkening  ("Assombrissement bords",   Range(0, 1))    = 0.35
        _EdgeSharpness  ("Netteté bords",           Range(1, 12))   = 5.0

        // Opacite papier : laisse transparaitre le fond
        _Opacity        ("Opacité",                 Range(0.5, 1))  = 0.90

        // Outline creme (minimal, juste pour definir les formes)
        _OutlineColor   ("Couleur outline",         Color)          = (0.97, 0.93, 0.87, 1)
        _OutlineWidth   ("Épaisseur outline",       Range(0, 0.02)) = 0.004
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType"     = "Transparent"
            "Queue"          = "Transparent"
        }

        // PASS 1 — Outline
        Pass
        {
            Name "Outline"
            Tags { "LightMode" = "SRPDefaultUnlit" }
            Cull Front
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex   vertOutline
            #pragma fragment fragOutline
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _BaseColor;
                half4  _OutlineColor;
                float  _OutlineWidth;
                float  _NoiseScale;
                float  _NoiseStrength;
                float  _EdgeDarkening;
                float  _EdgeSharpness;
                float  _Opacity;
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

        // PASS 2 — Aquarelle
        Pass
        {
            Name "Watercolor"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            TEXTURE2D(_BaseMap);  SAMPLER(sampler_BaseMap);
            TEXTURE2D(_NoiseTex); SAMPLER(sampler_NoiseTex);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _BaseColor;
                half4  _OutlineColor;
                float  _OutlineWidth;
                float  _NoiseScale;
                float  _NoiseStrength;
                float  _EdgeDarkening;
                float  _EdgeSharpness;
                float  _Opacity;
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
                float3 positionWS : TEXCOORD2;
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
                half4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv) * _BaseColor;

                // 1. Variation pigment (2 couches noise decalees)
                float n1    = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, i.uv * _NoiseScale).r;
                float n2    = SAMPLE_TEXTURE2D(_NoiseTex, sampler_NoiseTex, i.uv * _NoiseScale * 1.7 + 0.3).r;
                float noise = (n1 + n2) * 0.5 - 0.5;
                col.rgb    += noise * _NoiseStrength;

                // 2. Bords assombris via fresnel (pigment sec)
                float3 normal  = normalize(i.normalWS);
                float3 viewDir = normalize(GetCameraPositionWS() - i.positionWS);
                float  fresnel = 1.0 - saturate(dot(normal, viewDir));
                col.rgb       -= pow(fresnel, _EdgeSharpness) * _EdgeDarkening;

                // 3. Lumiere tres douce, pas d'ombre dure
                Light mainLight = GetMainLight();
                float NdotL     = dot(normal, mainLight.direction) * 0.5 + 0.5;
                col.rgb        *= lerp(0.75, 1.0, NdotL) * mainLight.color;

                // 4. Ambiance legere
                col.rgb += SampleSH(normal) * col.rgb * 0.10;

                return half4(saturate(col.rgb), _Opacity);
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
