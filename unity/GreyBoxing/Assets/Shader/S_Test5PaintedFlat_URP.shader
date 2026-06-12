Shader "Custom/PaintedFlat_URP"
{
    // Style cible : illustration peinte a la main
    // Aplat pur + grain papier procedural + zero outline + zero ombre dure
    // Aucune texture externe requise (grain genere mathematiquement)

    Properties
    {
        _BaseColor      ("Couleur",                 Color)          = (1,1,1,1)
        _BaseMap        ("Texture",                 2D)             = "white" {}

        // Grain papier : variation subtile sur les aplats
        // Simule la texture du papier aquarelle sous la peinture
        _GrainScale     ("Echelle grain",           Range(1, 20))   = 6.0
        _GrainStrength  ("Intensité grain",         Range(0, 0.15)) = 0.05

        // Variation de teinte : chaque zone a une couleur
        // tres legerement differente, comme une peinture faite a la main
        _ColorVariation ("Variation couleur",       Range(0, 0.1))  = 0.03

        // Eclairage ambiant : controle la luminosite globale
        // sans creer d'ombre directionnelle
        _AmbientStrength("Lumiere ambiante",        Range(0, 1))    = 0.85
    }

    SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType"     = "Opaque"
            "Queue"          = "Geometry"
        }

        Pass
        {
            Name "PaintedFlat"
            Tags { "LightMode" = "UniversalForward" }
            Cull Back
            ZWrite On

            HLSLPROGRAM
            #pragma vertex   vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
                float4 _BaseMap_ST;
                half4  _BaseColor;
                float  _GrainScale;
                float  _GrainStrength;
                float  _ColorVariation;
                float  _AmbientStrength;
            CBUFFER_END

            // ---- Noise procedural ----

            float hash(float2 p)
            {
                p = frac(p * float2(127.1, 311.7));
                p += dot(p, p + 19.19);
                return frac(p.x * p.y);
            }

            float valueNoise(float2 uv)
            {
                float2 i = floor(uv);
                float2 f = frac(uv);
                // Smoothstep cubique pour interpolation douce
                float2 s = f * f * (3.0 - 2.0 * f);

                return lerp(
                    lerp(hash(i),               hash(i + float2(1,0)), s.x),
                    lerp(hash(i + float2(0,1)), hash(i + float2(1,1)), s.x),
                    s.y
                );
            }

            // fBm 2 octaves : grain papier (pas besoin de plus pour un effet subtil)
            float grainNoise(float2 uv)
            {
                float v  = valueNoise(uv) * 0.6;
                      v += valueNoise(uv * 2.3 + 0.7) * 0.4;
                return v - 0.5; // centre sur 0 pour ne pas biaiser la couleur
            }

            // fBm 3 octaves : variation de teinte large (taches douces)
            float colorNoise(float2 uv)
            {
                float v  = valueNoise(uv) * 0.5;
                      v += valueNoise(uv * 2.1 + 0.3) * 0.3;
                      v += valueNoise(uv * 4.3 + 0.6) * 0.2;
                return v - 0.5;
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
                // Couleur de base
                half4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, i.uv) * _BaseColor;

                // 1. Variation de teinte (grandes taches douces)
                //    Simule les zones ou la peinture est plus epaisse/fine
                float cVar = colorNoise(i.uv * (_GrainScale * 0.3));
                col.rgb   += cVar * _ColorVariation;

                // 2. Grain papier fin (texture de surface)
                //    Simule la trame du papier aquarelle visible sous la peinture
                float grain = grainNoise(i.uv * _GrainScale);
                col.rgb    += grain * _GrainStrength;

                // 3. Eclairage plat et uniforme
                //    On ignore la direction de la lumiere pour garder l'aspect
                //    illustration 2D — juste l'ambiance generale de la scene
                float3 normalWS = normalize(i.normalWS);
                half3  ambient  = SampleSH(normalWS);
                col.rgb        *= lerp(ambient, half3(1,1,1), _AmbientStrength);

                return half4(saturate(col.rgb), 1.0);
            }
            ENDHLSL
        }

        // Shadow Caster
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
