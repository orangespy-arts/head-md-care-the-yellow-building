Shader "Custom/Watercolor_URP"
{
    // Noise genere mathematiquement — aucune texture externe requise
    // Variation pigment + bords assombris + opacite papier

    Properties
    {
        _BaseColor      ("Couleur",                 Color)          = (1,1,1,1)
        _BaseMap        ("Texture",                 2D)             = "white" {}

        _NoiseScale     ("Echelle noise",           Range(0.5, 8))  = 2.0
        _NoiseStrength  ("Variation pigment",       Range(0, 0.4))  = 0.15

        _EdgeDarkening  ("Assombrissement bords",   Range(0, 1))    = 0.35
        _EdgeSharpness  ("Netteté bords",           Range(1, 12))   = 5.0

        _Opacity        ("Opacité",                 Range(0.5, 1))  = 0.90

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

            TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);

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

            // ---- Fonctions noise mathematiques ----

            // Hash 2D -> valeur pseudo-aleatoire [0,1]
            float hash(float2 p)
            {
                p = frac(p * float2(127.1, 311.7));
                p += dot(p, p + 19.19);
                return frac(p.x * p.y);
            }

            // Interpolation douce (smoothstep cubique)
            float2 smooth(float2 t)
            {
                return t * t * (3.0 - 2.0 * t);
            }

            // Value noise — donne un aspect "tache de peinture"
            float valueNoise(float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                float2 s = smooth(f);

                float a = hash(i);
                float b = hash(i + float2(1,0));
                float c = hash(i + float2(0,1));
                float d = hash(i + float2(1,1));

                return lerp(lerp(a, b, s.x),
                            lerp(c, d, s.x), s.y);
            }

            // Fractal Brownian Motion (fBm) — 3 octaves
            // Superpose plusieurs couches de noise a echelles differentes
            // Resultat : aspect organique, irrégulier, comme du pigment aquarelle
            float fbm(float2 uv)
            {
                float value    = 0.0;
                float amplitude = 0.5;
                float frequency = 1.0;

                // Octave 1 — grandes taches
                value += valueNoise(uv * frequency) * amplitude;
                amplitude *= 0.5;
                frequency *= 2.1;

                // Octave 2 — details moyens
                value += valueNoise(uv * frequency) * amplitude;
                amplitude *= 0.5;
                frequency *= 2.1;

                // Octave 3 — petits details (grain papier)
                value += valueNoise(uv * frequency) * amplitude;

                return value;
            }

            // ---- Structs ----

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

                // 1. Variation pigment via fBm
                // Deux couches decalees = variation plus riche et moins repetitive
                float noise1 = fbm(i.uv * _NoiseScale);
                float noise2 = fbm(i.uv * _NoiseScale * 1.7 + 0.43);
                float noise  = (noise1 + noise2) * 0.5 - 0.5; // centre sur 0
                col.rgb     += noise * _NoiseStrength;

                // 2. Bords assombris via fresnel (pigment sec sur les contours)
                float3 normal  = normalize(i.normalWS);
                float3 viewDir = normalize(GetCameraPositionWS() - i.positionWS);
                float  fresnel = 1.0 - saturate(dot(normal, viewDir));
                col.rgb       -= pow(fresnel, _EdgeSharpness) * _EdgeDarkening;

                // 3. Lumiere douce sans ombre dure
                Light  mainLight = GetMainLight();
                float  NdotL     = dot(normal, mainLight.direction) * 0.5 + 0.5;
                col.rgb         *= lerp(0.75, 1.0, NdotL) * mainLight.color;

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
