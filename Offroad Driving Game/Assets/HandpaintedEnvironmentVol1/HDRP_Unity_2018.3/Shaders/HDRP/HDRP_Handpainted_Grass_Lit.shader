Shader "HandpaintedVol1/HDRP/Handpainted_Grass_Lit"
{
    Properties
    {
        Color_2F8B3538("Color Tint", Color) = (0,0,0,0)
[NoScaleOffset] Texture2D_3CC75AC0("Texture Map", 2D) = "white" {}
[NoScaleOffset] Texture2D_FEDE746A("Color Mask", 2D) = "white" {}
Vector1_C6529BE("Alpha Clip", Range(0, 1)) = 0
Vector1_B8E2FA07("Roughness", Range(0, 1)) = 0
Vector2_5BCDA59A("Wind Movement", Vector) = (6,0,0,0)
Vector1_22370713("Wind Density", Float) = 2
Vector1_B248DF79("Wind Strength", Float) = 0.3
[HideInInspector] _EmissionColor("Color", Color) = (1,1,1,1)

    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="TransparentCutout"
            "Queue"="AlphaTest+0"
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "META"
            Tags { "LightMode" = "META" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Default Stencil
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_LIGHT_TRANSPORT
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            float4 uv1 : TEXCOORD1; // optional
            float4 uv2 : TEXCOORD2; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_OneMinus_float4(float4 In, out float4 Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_OneMinus_float(float In, out float Out)
                    {
                        Out = 1 - In;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_73CA37A9_Out = Color_2F8B3538;
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float4 _Multiply_276D7695_Out;
                        Unity_Multiply_float(_Property_73CA37A9_Out, _SampleTexture2D_F31074AB_RGBA, _Multiply_276D7695_Out);
                    
                        float4 _SampleTexture2D_E9320E86_RGBA = SAMPLE_TEXTURE2D(Texture2D_FEDE746A, samplerTexture2D_FEDE746A, IN.uv0.xy);
                        float _SampleTexture2D_E9320E86_R = _SampleTexture2D_E9320E86_RGBA.r;
                        float _SampleTexture2D_E9320E86_G = _SampleTexture2D_E9320E86_RGBA.g;
                        float _SampleTexture2D_E9320E86_B = _SampleTexture2D_E9320E86_RGBA.b;
                        float _SampleTexture2D_E9320E86_A = _SampleTexture2D_E9320E86_RGBA.a;
                        float4 _OneMinus_24264195_Out;
                        Unity_OneMinus_float4(_SampleTexture2D_E9320E86_RGBA, _OneMinus_24264195_Out);
                        float4 _Lerp_777BCBBE_Out;
                        Unity_Lerp_float4(_Multiply_276D7695_Out, _SampleTexture2D_F31074AB_RGBA, _OneMinus_24264195_Out, _Lerp_777BCBBE_Out);
                        float _Property_5564B33E_Out = Vector1_B8E2FA07;
                        float _OneMinus_571D6552_Out;
                        Unity_OneMinus_float(_Property_5564B33E_Out, _OneMinus_571D6552_Out);
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Albedo = (_Lerp_777BCBBE_Out.xyz);
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Metallic = 0;
                        surface.Emission = float3(0, 0, 0);
                        surface.Smoothness = _OneMinus_571D6552_Out;
                        surface.Occlusion = 1;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.texCoord0 = input.texCoord0;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassLightTransport.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Default Stencil
        
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_SHADOWS
                #define USE_LEGACY_UNITY_MATRIX_VARIABLES
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.texCoord0 = input.texCoord0;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Default Stencil
        
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #define SCENESELECTIONPASS
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.texCoord0 = input.texCoord0;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "DepthOnly"
            Tags { "LightMode" = "DepthOnly" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Stencil setup
        Stencil
        {
           WriteMask 32
           Ref  32
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #pragma multi_compile _ WRITE_NORMAL_BUFFER
                #pragma multi_compile _ WRITE_MSAA_DEPTH
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            float4 uv1 : TEXCOORD1; // optional
            float4 uv2 : TEXCOORD2; // optional
            float4 uv3 : TEXCOORD3; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float3 positionRWS; // optional
            float3 normalWS; // optional
            float4 tangentWS; // optional
            float4 texCoord0; // optional
            float4 texCoord1; // optional
            float4 texCoord2; // optional
            float4 texCoord3; // optional
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            float4 interp02 : TEXCOORD2; // auto-packed
            float4 interp03 : TEXCOORD3; // auto-packed
            float4 interp04 : TEXCOORD4; // auto-packed
            float4 interp05 : TEXCOORD5; // auto-packed
            float4 interp06 : TEXCOORD6; // auto-packed
            float4 interp07 : TEXCOORD7; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            output.interp02.xyzw = input.tangentWS;
            output.interp03.xyzw = input.texCoord0;
            output.interp04.xyzw = input.texCoord1;
            output.interp05.xyzw = input.texCoord2;
            output.interp06.xyzw = input.texCoord3;
            output.interp07.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            output.tangentWS = input.interp02.xyzw;
            output.texCoord0 = input.interp03.xyzw;
            output.texCoord1 = input.interp04.xyzw;
            output.texCoord2 = input.interp05.xyzw;
            output.texCoord3 = input.interp06.xyzw;
            output.color = input.interp07.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Normal;
                        float Smoothness;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_OneMinus_float(float In, out float Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _Property_5564B33E_Out = Vector1_B8E2FA07;
                        float _OneMinus_571D6552_Out;
                        Unity_OneMinus_float(_Property_5564B33E_Out, _OneMinus_571D6552_Out);
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.Smoothness = _OneMinus_571D6552_Out;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.positionRWS = input.positionRWS;
                output.worldToTangent = BuildWorldToTangent(input.tangentWS, input.normalWS);
                output.texCoord0 = input.texCoord0;
                output.texCoord1 = input.texCoord1;
                output.texCoord2 = input.texCoord2;
                output.texCoord3 = input.texCoord3;
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassDepthOnly.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "GBuffer"
            Tags { "LightMode" = "GBuffer" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest Equal
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Stencil setup
        Stencil
        {
           WriteMask 39
           Ref  34
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_GBUFFER
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
                #pragma multi_compile _ LIGHT_LAYERS
                #ifndef DEBUG_DISPLAY
    #define SHADERPASS_GBUFFER_BYPASS_ALPHA_TEST
    #endif
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            float4 uv1 : TEXCOORD1; // optional
            float4 uv2 : TEXCOORD2; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float3 positionRWS; // optional
            float3 normalWS; // optional
            float4 tangentWS; // optional
            float4 texCoord0; // optional
            float4 texCoord1; // optional
            float4 texCoord2; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            float4 interp02 : TEXCOORD2; // auto-packed
            float4 interp03 : TEXCOORD3; // auto-packed
            float4 interp04 : TEXCOORD4; // auto-packed
            float4 interp05 : TEXCOORD5; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            output.interp02.xyzw = input.tangentWS;
            output.interp03.xyzw = input.texCoord0;
            output.interp04.xyzw = input.texCoord1;
            output.interp05.xyzw = input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            output.tangentWS = input.interp02.xyzw;
            output.texCoord0 = input.interp03.xyzw;
            output.texCoord1 = input.interp04.xyzw;
            output.texCoord2 = input.interp05.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_OneMinus_float4(float4 In, out float4 Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_OneMinus_float(float In, out float Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_73CA37A9_Out = Color_2F8B3538;
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float4 _Multiply_276D7695_Out;
                        Unity_Multiply_float(_Property_73CA37A9_Out, _SampleTexture2D_F31074AB_RGBA, _Multiply_276D7695_Out);
                    
                        float4 _SampleTexture2D_E9320E86_RGBA = SAMPLE_TEXTURE2D(Texture2D_FEDE746A, samplerTexture2D_FEDE746A, IN.uv0.xy);
                        float _SampleTexture2D_E9320E86_R = _SampleTexture2D_E9320E86_RGBA.r;
                        float _SampleTexture2D_E9320E86_G = _SampleTexture2D_E9320E86_RGBA.g;
                        float _SampleTexture2D_E9320E86_B = _SampleTexture2D_E9320E86_RGBA.b;
                        float _SampleTexture2D_E9320E86_A = _SampleTexture2D_E9320E86_RGBA.a;
                        float4 _OneMinus_24264195_Out;
                        Unity_OneMinus_float4(_SampleTexture2D_E9320E86_RGBA, _OneMinus_24264195_Out);
                        float4 _Lerp_777BCBBE_Out;
                        Unity_Lerp_float4(_Multiply_276D7695_Out, _SampleTexture2D_F31074AB_RGBA, _OneMinus_24264195_Out, _Lerp_777BCBBE_Out);
                        float _Property_5564B33E_Out = Vector1_B8E2FA07;
                        float _OneMinus_571D6552_Out;
                        Unity_OneMinus_float(_Property_5564B33E_Out, _OneMinus_571D6552_Out);
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Albedo = (_Lerp_777BCBBE_Out.xyz);
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Metallic = 0;
                        surface.Emission = float3(0, 0, 0);
                        surface.Smoothness = _OneMinus_571D6552_Out;
                        surface.Occlusion = 1;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.positionRWS = input.positionRWS;
                output.worldToTangent = BuildWorldToTangent(input.tangentWS, input.normalWS);
                output.texCoord0 = input.texCoord0;
                output.texCoord1 = input.texCoord1;
                output.texCoord2 = input.texCoord2;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassGBuffer.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "MotionVectors"
            Tags { "LightMode" = "MotionVectors" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // If velocity pass (motion vectors) is enabled we tag the stencil so it don't perform CameraMotionVelocity
        Stencil
        {
           WriteMask 128
           Ref 128
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_VELOCITY
                #pragma multi_compile _ WRITE_NORMAL_BUFFER
                #pragma multi_compile _ WRITE_MSAA_DEPTH
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_TEXCOORD3
            #define VARYINGS_NEED_COLOR
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            float4 uv1 : TEXCOORD1; // optional
            float4 uv2 : TEXCOORD2; // optional
            float4 uv3 : TEXCOORD3; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float3 positionRWS; // optional
            float3 normalWS; // optional
            float4 tangentWS; // optional
            float4 texCoord0; // optional
            float4 texCoord1; // optional
            float4 texCoord2; // optional
            float4 texCoord3; // optional
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToPS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            float4 interp02 : TEXCOORD2; // auto-packed
            float4 interp03 : TEXCOORD3; // auto-packed
            float4 interp04 : TEXCOORD4; // auto-packed
            float4 interp05 : TEXCOORD5; // auto-packed
            float4 interp06 : TEXCOORD6; // auto-packed
            float4 interp07 : TEXCOORD7; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            output.interp02.xyzw = input.tangentWS;
            output.interp03.xyzw = input.texCoord0;
            output.interp04.xyzw = input.texCoord1;
            output.interp05.xyzw = input.texCoord2;
            output.interp06.xyzw = input.texCoord3;
            output.interp07.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            output.tangentWS = input.interp02.xyzw;
            output.texCoord0 = input.interp03.xyzw;
            output.texCoord1 = input.interp04.xyzw;
            output.texCoord2 = input.interp05.xyzw;
            output.texCoord3 = input.interp06.xyzw;
            output.color = input.interp07.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Normal;
                        float Smoothness;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_OneMinus_float(float In, out float Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _Property_5564B33E_Out = Vector1_B8E2FA07;
                        float _OneMinus_571D6552_Out;
                        Unity_OneMinus_float(_Property_5564B33E_Out, _OneMinus_571D6552_Out);
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.Smoothness = _OneMinus_571D6552_Out;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.positionRWS = input.positionRWS;
                output.worldToTangent = BuildWorldToTangent(input.tangentWS, input.normalWS);
                output.texCoord0 = input.texCoord0;
                output.texCoord1 = input.texCoord1;
                output.texCoord2 = input.texCoord2;
                output.texCoord3 = input.texCoord3;
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassVelocity.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
        Pass
        {
            // based on HDLitPass.template
            Name "Forward"
            Tags { "LightMode" = "Forward" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One Zero
        
            Cull Off
        
            ZTest Equal
        
            ZWrite On
        
            ZClip [_ZClip]
        
            // Stencil setup
        Stencil
        {
           WriteMask 7
           Ref  2
           Comp Always
           Pass Replace
        }
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
        
            #pragma multi_compile _ LOD_FADE_CROSSFADE
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _ENERGY_CONSERVING_SPECULAR 1
            #define _DISABLE_SSR 1
            #define _DOUBLESIDED_ON 1
        
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            // This will be enabled in an upcoming change. 
            // #define SURFACE_GRADIENT
        
            // If we use subsurface scattering, enable output split lighting (for forward pass)
            #if defined(_MATERIAL_FEATURE_SUBSURFACE_SCATTERING) && !defined(_SURFACE_TYPE_TRANSPARENT)
            #define OUTPUT_SPLIT_LIGHTING
            #endif
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/NormalSurfaceGradient.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_FORWARD
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
                #pragma multi_compile _ SHADOWS_SHADOWMASK
                #pragma multi_compile DECALS_OFF DECALS_3RT DECALS_4RT
                #define LIGHTLOOP_TILE_PASS
                #pragma multi_compile USE_FPTL_LIGHTLIST USE_CLUSTERED_LIGHTLIST
                #pragma multi_compile SHADOW_LOW SHADOW_MEDIUM SHADOW_HIGH
                #ifndef DEBUG_DISPLAY
    #define SHADERPASS_FORWARD_BYPASS_ALPHA_TEST
    #endif
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_TANGENT_TO_WORLD
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD1
            #define VARYINGS_NEED_TEXCOORD2
            #define VARYINGS_NEED_CULLFACE
            #define HAVE_MESH_MODIFICATION
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
        
        #if (SHADERPASS == SHADERPASS_FORWARD)
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/Lighting.hlsl"
        
            #define HAS_LIGHTLOOP
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoopDef.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Lighting/LightLoop/LightLoop.hlsl"
        #else
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/Lit.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Decal/DecalUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Lit/LitDecalData.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderGraphFunctions.hlsl"
        
            // Used by SceneSelectionPass
            int _ObjectId;
            int _PassValue;
        
            //-------------------------------------------------------------------------------------
            // Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        // Generated Type: AttributesMesh
        struct AttributesMesh {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL; // optional
            float4 tangentOS : TANGENT; // optional
            float4 uv0 : TEXCOORD0; // optional
            float4 uv1 : TEXCOORD1; // optional
            float4 uv2 : TEXCOORD2; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float3 positionRWS; // optional
            float3 normalWS; // optional
            float4 tangentWS; // optional
            float4 texCoord0; // optional
            float4 texCoord1; // optional
            float4 texCoord2; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // optional
            #endif // SHADER_STAGE_FRAGMENT
        };
        struct PackedVaryingsMeshToPS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            float4 interp02 : TEXCOORD2; // auto-packed
            float4 interp03 : TEXCOORD3; // auto-packed
            float4 interp04 : TEXCOORD4; // auto-packed
            float4 interp05 : TEXCOORD5; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC; // unpacked
            #endif // SHADER_STAGE_FRAGMENT
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            output.interp02.xyzw = input.tangentWS;
            output.interp03.xyzw = input.texCoord0;
            output.interp04.xyzw = input.texCoord1;
            output.interp05.xyzw = input.texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            output.tangentWS = input.interp02.xyzw;
            output.texCoord0 = input.interp03.xyzw;
            output.texCoord1 = input.interp04.xyzw;
            output.texCoord2 = input.interp05.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            #if SHADER_STAGE_FRAGMENT
            output.cullFace = input.cullFace;
            #endif // SHADER_STAGE_FRAGMENT
            return output;
        }
        
        // Generated Type: VaryingsMeshToDS
        struct VaryingsMeshToDS {
            float3 positionRWS;
            float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToDS {
            float3 interp00 : TEXCOORD0; // auto-packed
            float3 interp01 : TEXCOORD1; // auto-packed
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToDS PackVaryingsMeshToDS(VaryingsMeshToDS input)
        {
            PackedVaryingsMeshToDS output;
            output.interp00.xyz = input.positionRWS;
            output.interp01.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToDS UnpackVaryingsMeshToDS(PackedVaryingsMeshToDS input)
        {
            VaryingsMeshToDS output;
            output.positionRWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        
            //-------------------------------------------------------------------------------------
            // End Interpolator Packing And Struct Declarations
            //-------------------------------------------------------------------------------------
        
            //-------------------------------------------------------------------------------------
            // Graph generated code
            //-------------------------------------------------------------------------------------
                    // Shared Graph Properties (uniform inputs)
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_2F8B3538;
                    float Vector1_C6529BE;
                    float Vector1_B8E2FA07;
                    float2 Vector2_5BCDA59A;
                    float Vector1_22370713;
                    float Vector1_B248DF79;
                    float4 _EmissionColor;
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_3CC75AC0); SAMPLER(samplerTexture2D_3CC75AC0); float4 Texture2D_3CC75AC0_TexelSize;
                    TEXTURE2D(Texture2D_FEDE746A); SAMPLER(samplerTexture2D_FEDE746A); float4 Texture2D_FEDE746A_TexelSize;
                
                // Vertex Graph Inputs
                    struct VertexDescriptionInputs {
                        float3 WorldSpaceNormal; // optional
                        float3 WorldSpaceTangent; // optional
                        float3 ObjectSpaceBiTangent; // optional
                        float3 WorldSpaceBiTangent; // optional
                        float3 ObjectSpacePosition; // optional
                        float3 WorldSpacePosition; // optional
                        float4 uv0; // optional
                    };
                // Vertex Graph Outputs
                    struct VertexDescription
                    {
                        float3 Position;
                    };
                    
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float3 TangentSpaceNormal; // optional
                        float4 uv0; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Normal;
                        float3 BentNormal;
                        float CoatMask;
                        float Metallic;
                        float3 Emission;
                        float Smoothness;
                        float Occlusion;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_OneMinus_float4(float4 In, out float4 Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_OneMinus_float(float In, out float Out)
                    {
                        Out = 1 - In;
                    }
                
                    void Unity_Multiply_float (float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }
                
                
    float2 unity_gradientNoise_dir(float2 p)
    {
        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
        p = p % 289;
        float x = (34 * p.x + 1) * p.x % 289 + p.y;
        x = (34 * x + 1) * x % 289;
        x = frac(x / 41) * 2 - 1;
        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
    }

                
    float unity_gradientNoise(float2 p)
    {
        float2 ip = floor(p);
        float2 fp = frac(p);
        float d00 = dot(unity_gradientNoise_dir(ip), fp);
        float d01 = dot(unity_gradientNoise_dir(ip + float2(0, 1)), fp - float2(0, 1));
        float d10 = dot(unity_gradientNoise_dir(ip + float2(1, 0)), fp - float2(1, 0));
        float d11 = dot(unity_gradientNoise_dir(ip + float2(1, 1)), fp - float2(1, 1));
        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
        return lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x);
    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    { Out = unity_gradientNoise(UV * Scale) + 0.5; }
                
                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }
                
                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }
                
                    void Unity_Multiply_float (float A, float B, out float Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
                    {
                        Out = lerp(A, B, T);
                    }
                
                    void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A - B;
                    }
                
                // Vertex Graph Evaluation
                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float2 _Property_6052D2F0_Out = Vector2_5BCDA59A;
                        float2 _Multiply_3D16E124_Out;
                        Unity_Multiply_float((_Time.y.xx), _Property_6052D2F0_Out, _Multiply_3D16E124_Out);
                    
                        float2 _TilingAndOffset_887DA191_Out;
                        Unity_TilingAndOffset_float((IN.ObjectSpacePosition.xy), float2 (1,1), _Multiply_3D16E124_Out, _TilingAndOffset_887DA191_Out);
                        float _Property_2E817894_Out = Vector1_22370713;
                        float _GradientNoise_1B938AB4_Out;
                        Unity_GradientNoise_float(_TilingAndOffset_887DA191_Out, _Property_2E817894_Out, _GradientNoise_1B938AB4_Out);
                        float _Add_372F5890_Out;
                        Unity_Add_float(0, _GradientNoise_1B938AB4_Out, _Add_372F5890_Out);
                        float _Subtract_6DB9C88F_Out;
                        Unity_Subtract_float(_Add_372F5890_Out, 0.5, _Subtract_6DB9C88F_Out);
                        float _Property_E36A855D_Out = Vector1_B248DF79;
                        float _Multiply_638C1FB_Out;
                        Unity_Multiply_float(_Subtract_6DB9C88F_Out, _Property_E36A855D_Out, _Multiply_638C1FB_Out);
                    
                        float _Split_56A7C5FA_R = IN.WorldSpacePosition[0];
                        float _Split_56A7C5FA_G = IN.WorldSpacePosition[1];
                        float _Split_56A7C5FA_B = IN.WorldSpacePosition[2];
                        float _Split_56A7C5FA_A = 0;
                        float _Add_E25A0519_Out;
                        Unity_Add_float(_Multiply_638C1FB_Out, _Split_56A7C5FA_R, _Add_E25A0519_Out);
                        float4 _Combine_A0BAC6E0_RGBA;
                        float3 _Combine_A0BAC6E0_RGB;
                        float2 _Combine_A0BAC6E0_RG;
                        Unity_Combine_float(_Add_E25A0519_Out, _Split_56A7C5FA_G, _Split_56A7C5FA_B, 0, _Combine_A0BAC6E0_RGBA, _Combine_A0BAC6E0_RGB, _Combine_A0BAC6E0_RG);
                        float4 _UV_41128FB0_Out = IN.uv0;
                        float _Split_D708506E_R = _UV_41128FB0_Out[0];
                        float _Split_D708506E_G = _UV_41128FB0_Out[1];
                        float _Split_D708506E_B = _UV_41128FB0_Out[2];
                        float _Split_D708506E_A = _UV_41128FB0_Out[3];
                        float3 _Lerp_FE42F72D_Out;
                        Unity_Lerp_float3(IN.WorldSpacePosition, (_Combine_A0BAC6E0_RGBA.xyz), (_Split_D708506E_R.xxx), _Lerp_FE42F72D_Out);
                        float3 _Subtract_E093ACDE_Out;
                        Unity_Subtract_float3(_Lerp_FE42F72D_Out, _WorldSpaceCameraPos, _Subtract_E093ACDE_Out);
                        float3 _Transform_393FA5B1_Out = TransformWorldToObject(_Subtract_E093ACDE_Out.xyz);
                        description.Position = _Transform_393FA5B1_Out;
                        return description;
                    }
                    
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _Property_73CA37A9_Out = Color_2F8B3538;
                        float4 _SampleTexture2D_F31074AB_RGBA = SAMPLE_TEXTURE2D(Texture2D_3CC75AC0, samplerTexture2D_3CC75AC0, IN.uv0.xy);
                        float _SampleTexture2D_F31074AB_R = _SampleTexture2D_F31074AB_RGBA.r;
                        float _SampleTexture2D_F31074AB_G = _SampleTexture2D_F31074AB_RGBA.g;
                        float _SampleTexture2D_F31074AB_B = _SampleTexture2D_F31074AB_RGBA.b;
                        float _SampleTexture2D_F31074AB_A = _SampleTexture2D_F31074AB_RGBA.a;
                        float4 _Multiply_276D7695_Out;
                        Unity_Multiply_float(_Property_73CA37A9_Out, _SampleTexture2D_F31074AB_RGBA, _Multiply_276D7695_Out);
                    
                        float4 _SampleTexture2D_E9320E86_RGBA = SAMPLE_TEXTURE2D(Texture2D_FEDE746A, samplerTexture2D_FEDE746A, IN.uv0.xy);
                        float _SampleTexture2D_E9320E86_R = _SampleTexture2D_E9320E86_RGBA.r;
                        float _SampleTexture2D_E9320E86_G = _SampleTexture2D_E9320E86_RGBA.g;
                        float _SampleTexture2D_E9320E86_B = _SampleTexture2D_E9320E86_RGBA.b;
                        float _SampleTexture2D_E9320E86_A = _SampleTexture2D_E9320E86_RGBA.a;
                        float4 _OneMinus_24264195_Out;
                        Unity_OneMinus_float4(_SampleTexture2D_E9320E86_RGBA, _OneMinus_24264195_Out);
                        float4 _Lerp_777BCBBE_Out;
                        Unity_Lerp_float4(_Multiply_276D7695_Out, _SampleTexture2D_F31074AB_RGBA, _OneMinus_24264195_Out, _Lerp_777BCBBE_Out);
                        float _Property_5564B33E_Out = Vector1_B8E2FA07;
                        float _OneMinus_571D6552_Out;
                        Unity_OneMinus_float(_Property_5564B33E_Out, _OneMinus_571D6552_Out);
                        float _Property_9799BE2A_Out = Vector1_C6529BE;
                        surface.Albedo = (_Lerp_777BCBBE_Out.xyz);
                        surface.Normal = IN.TangentSpaceNormal;
                        surface.BentNormal = IN.TangentSpaceNormal;
                        surface.CoatMask = 0;
                        surface.Metallic = 0;
                        surface.Emission = float3(0, 0, 0);
                        surface.Smoothness = _OneMinus_571D6552_Out;
                        surface.Occlusion = 1;
                        surface.Alpha = _SampleTexture2D_F31074AB_A;
                        surface.AlphaClipThreshold = _Property_9799BE2A_Out;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
            //-------------------------------------------------------------------------------------
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        VertexDescriptionInputs AttributesMeshToVertexDescriptionInputs(AttributesMesh input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
            output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
            output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
            output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
            output.ObjectSpacePosition =         input.positionOS;
            output.WorldSpacePosition =          GetAbsolutePositionWS(TransformObjectToWorld(input.positionOS));
            output.uv0 =                         input.uv0;
        
            return output;
        }
        
        AttributesMesh ApplyMeshModification(AttributesMesh input)
        {
            // build graph inputs
            VertexDescriptionInputs vertexDescriptionInputs = AttributesMeshToVertexDescriptionInputs(input);
        
            // evaluate vertex graph
            VertexDescription vertexDescription = VertexDescriptionFunction(vertexDescriptionInputs);
        
            // copy graph output to the results
            input.positionOS = vertexDescription.Position;
        
            return input;
        }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : VertexAnimation.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
        
        //-------------------------------------------------------------------------------------
        // TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
            FragInputs BuildFragInputs(VaryingsMeshToPS input)
            {
                FragInputs output;
                ZERO_INITIALIZE(FragInputs, output);
        
                // Init to some default value to make the computer quiet (else it output 'divide by zero' warning even if value is not used).
                // TODO: this is a really poor workaround, but the variable is used in a bunch of places
                // to compute normals which are then passed on elsewhere to compute other values...
                output.worldToTangent = k_identity3x3;
                output.positionSS = input.positionCS;       // input.positionCS is SV_Position
        
                output.positionRWS = input.positionRWS;
                output.worldToTangent = BuildWorldToTangent(input.tangentWS, input.normalWS);
                output.texCoord0 = input.texCoord0;
                output.texCoord1 = input.texCoord1;
                output.texCoord2 = input.texCoord2;
                #if SHADER_STAGE_FRAGMENT
                output.isFrontFace = IS_FRONT_VFACE(input.cullFace, true, false);       // TODO: SHADER_STAGE_FRAGMENT only
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.TangentSpaceNormal =          float3(0.0f, 0.0f, 1.0f);
                output.uv0 =                         input.texCoord0;
        
                return output;
            }
        
            // existing HDRP code uses the combined function to go directly from packed to frag inputs
            FragInputs UnpackVaryingsMeshToFragInputs(PackedVaryingsMeshToPS input)
            {
                UNITY_SETUP_INSTANCE_ID(input);
                VaryingsMeshToPS unpacked= UnpackVaryingsMeshToPS(input);
                return BuildFragInputs(unpacked);
            }
        
        //-------------------------------------------------------------------------------------
        // END TEMPLATE INCLUDE : SharedCode.template.hlsl
        //-------------------------------------------------------------------------------------
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData, out float3 bentNormalWS)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.baseColor =                 surfaceDescription.Albedo;
                surfaceData.perceptualSmoothness =      surfaceDescription.Smoothness;
                surfaceData.ambientOcclusion =          surfaceDescription.Occlusion;
                surfaceData.metallic =                  surfaceDescription.Metallic;
                surfaceData.coatMask =                  surfaceDescription.CoatMask;
        
        #ifdef _HAS_REFRACTION
                if (_EnableSSRefraction)
                {
        
                    surfaceData.transmittanceMask = (1.0 - surfaceDescription.Alpha);
                    surfaceDescription.Alpha = 1.0;
                }
                else
                {
                    surfaceData.ior = 1.0;
                    surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                    surfaceData.atDistance = 1.0;
                    surfaceData.transmittanceMask = 0.0;
                    surfaceDescription.Alpha = 1.0;
                }
        #else
                surfaceData.ior = 1.0;
                surfaceData.transmittanceColor = float3(1.0, 1.0, 1.0);
                surfaceData.atDistance = 1.0;
                surfaceData.transmittanceMask = 0.0;
        #endif
                
                // These static material feature allow compile time optimization
                surfaceData.materialFeatures = MATERIALFEATUREFLAGS_LIT_STANDARD;
        #ifdef _MATERIAL_FEATURE_SUBSURFACE_SCATTERING
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SUBSURFACE_SCATTERING;
        #endif
        #ifdef _MATERIAL_FEATURE_TRANSMISSION
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_TRANSMISSION;
        #endif
        #ifdef _MATERIAL_FEATURE_ANISOTROPY
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_ANISOTROPY;
        #endif
        
        #ifdef _MATERIAL_FEATURE_IRIDESCENCE
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_IRIDESCENCE;
        #endif
        #ifdef _MATERIAL_FEATURE_SPECULAR_COLOR
                surfaceData.materialFeatures |= MATERIALFEATUREFLAGS_LIT_SPECULAR_COLOR;
        #endif
        
        #if defined (_MATERIAL_FEATURE_SPECULAR_COLOR) && defined (_ENERGY_CONSERVING_SPECULAR)
                // Require to have setup baseColor
                // Reproduce the energy conservation done in legacy Unity. Not ideal but better for compatibility and users can unchek it
                surfaceData.baseColor *= (1.0 - Max3(surfaceData.specularColor.r, surfaceData.specularColor.g, surfaceData.specularColor.b));
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                // tangent-space normal
                float3 normalTS = float3(0.0f, 0.0f, 1.0f);
                normalTS = surfaceDescription.Normal;
        
                // compute world space normal
                GetNormalWS(fragInputs, normalTS, surfaceData.normalWS, doubleSidedConstants);
        
                bentNormalWS = surfaceData.normalWS;
        
                surfaceData.geomNormalWS = fragInputs.worldToTangent[2];
        
                surfaceData.tangentWS = normalize(fragInputs.worldToTangent[0].xyz);    // The tangent is not normalize in worldToTangent for mikkt. TODO: Check if it expected that we normalize with Morten. Tag: SURFACE_GRADIENT
                surfaceData.tangentWS = Orthonormalize(surfaceData.tangentWS, surfaceData.normalWS);
        
                // By default we use the ambient occlusion with Tri-ace trick (apply outside) for specular occlusion.
                // If user provide bent normal then we process a better term
        #if defined(_SPECULAR_OCCLUSION_CUSTOM)
                // Just use the value passed through via the slot (not active otherwise)
        #elif defined(_SPECULAR_OCCLUSION_FROM_AO_BENT_NORMAL)
                // If we have bent normal and ambient occlusion, process a specular occlusion
                surfaceData.specularOcclusion = GetSpecularOcclusionFromBentAO(V, bentNormalWS, surfaceData.normalWS, surfaceData.ambientOcclusion, PerceptualSmoothnessToPerceptualRoughness(surfaceData.perceptualSmoothness));
        #elif defined(_AMBIENT_OCCLUSION) && defined(_SPECULAR_OCCLUSION_FROM_AO)
                surfaceData.specularOcclusion = GetSpecularOcclusionFromAmbientOcclusion(ClampNdotV(dot(surfaceData.normalWS, V)), surfaceData.ambientOcclusion, PerceptualSmoothnessToRoughness(surfaceData.perceptualSmoothness));
        #else
                surfaceData.specularOcclusion = 1.0;
        #endif
        
        #if HAVE_DECALS
                if (_EnableDecals)
                {
                    DecalSurfaceData decalSurfaceData = GetDecalSurfaceData(posInput, surfaceDescription.Alpha);
                    ApplyDecalToSurfaceData(decalSurfaceData, surfaceData);
                }
        #endif
        
        #ifdef _ENABLE_GEOMETRIC_SPECULAR_AA
                surfaceData.perceptualSmoothness = GeometricNormalFiltering(surfaceData.perceptualSmoothness, fragInputs.worldToTangent[2], surfaceDescription.SpecularAAScreenSpaceVariance, surfaceDescription.SpecularAAThreshold);
        #endif
        
        #ifdef DEBUG_DISPLAY
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO: need to update mip info
                    surfaceData.metallic = 0;
                }
        
                // We need to call ApplyDebugToSurfaceData after filling the surfarcedata and before filling builtinData
                // as it can modify attribute use for static lighting
                ApplyDebugToSurfaceData(fragInputs.worldToTangent, surfaceData);
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
        #ifdef LOD_FADE_CROSSFADE // enable dithering LOD transition if user select CrossFade transition in LOD group
                uint3 fadeMaskSeed = asuint((int3)(V * _ScreenSize.xyx)); // Quantize V to _ScreenSize values
                LODDitheringTransition(fadeMaskSeed, unity_LODFade.x);
        #endif
        
                float3 doubleSidedConstants = float3(1.0, 1.0, 1.0);
        
                ApplyDoubleSidedFlipOrMirror(fragInputs, doubleSidedConstants);
        
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
                DoAlphaTest(surfaceDescription.Alpha, surfaceDescription.AlphaClipThreshold);
        
                float3 bentNormalWS;
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData, bentNormalWS);
        
                // Builtin Data
                // For back lighting we use the oposite vertex normal 
                InitBuiltinData(surfaceDescription.Alpha, bentNormalWS, -fragInputs.worldToTangent[2], fragInputs.positionRWS, fragInputs.texCoord1, fragInputs.texCoord2, builtinData);
        
                builtinData.emissiveColor = surfaceDescription.Emission;
        
                // TODO: Handle depth offset
                //builtinData.depthOffset = 0.0;
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
        
                PostInitBuiltinData(V, posInput, surfaceData, builtinData);
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForward.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.ShaderGraph.HDLitGUI"
    FallBack "Hidden/InternalErrorShader"
}
