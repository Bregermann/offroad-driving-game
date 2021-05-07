Shader "HandpaintedVol1/HDRP/Particle_Unlit"
{
    Properties
    {
        [NoScaleOffset] Texture2D_23DD87FD("Albedo", 2D) = "white" {}

    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="HDRenderPipeline"
            "RenderType"="Transparent"
            "Queue"="Transparent+0"
        }
        
        Pass
        {
            // based on HDUnlitPassForward.template
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One OneMinusSrcAlpha
        
            Cull Back
        
            ZTest LEqual
        
            ZWrite Off
        
            // Default Stencil
        
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            //enable GPU instancing support
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Wind.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_SHADOWS
                #define USE_LEGACY_UNITY_MATRIX_VARIABLES
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
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
            float4 uv0 : TEXCOORD0; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 interp01 : TEXCOORD1; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            output.interp01.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            output.color = input.interp01.xyzw;
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
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_23DD87FD); SAMPLER(samplerTexture2D_23DD87FD); float4 Texture2D_23DD87FD_TexelSize;
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    // Subgraph function
                    void sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(float4 Vector4_D4823111, SurfaceDescriptionInputs IN, out float4 Output1, out float4 Output2)
                    {
                    float4 _Property_C185F2BC_Out = Vector4_D4823111;
                    float4 _Multiply_A9E570A4_Out;
                    Unity_Multiply_float(IN.VertexColor, _Property_C185F2BC_Out, _Multiply_A9E570A4_Out);
                    
                    float _Split_9332C9F_R = _Multiply_A9E570A4_Out[0];
                    float _Split_9332C9F_G = _Multiply_A9E570A4_Out[1];
                    float _Split_9332C9F_B = _Multiply_A9E570A4_Out[2];
                    float _Split_9332C9F_A = _Multiply_A9E570A4_Out[3];
                    float4 _Combine_9E4C1326_RGBA;
                    float3 _Combine_9E4C1326_RGB;
                    float2 _Combine_9E4C1326_RG;
                    Unity_Combine_float(_Split_9332C9F_R, _Split_9332C9F_G, _Split_9332C9F_B, 0, _Combine_9E4C1326_RGBA, _Combine_9E4C1326_RGB, _Combine_9E4C1326_RG);
                    Output1 = (float4(_Combine_9E4C1326_RGB, 1.0));
                    Output2 = (_Split_9332C9F_A.xxxx);
                    }
                
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_3A74E746_RGBA = SAMPLE_TEXTURE2D(Texture2D_23DD87FD, samplerTexture2D_23DD87FD, IN.uv0.xy);
                        float _SampleTexture2D_3A74E746_R = _SampleTexture2D_3A74E746_RGBA.r;
                        float _SampleTexture2D_3A74E746_G = _SampleTexture2D_3A74E746_RGBA.g;
                        float _SampleTexture2D_3A74E746_B = _SampleTexture2D_3A74E746_RGBA.b;
                        float _SampleTexture2D_3A74E746_A = _SampleTexture2D_3A74E746_RGBA.a;
                        float4 _Subgraph_175E8EF_Output1;
                        float4 _Subgraph_175E8EF_Output2;
                        sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(_SampleTexture2D_3A74E746_RGBA, IN, _Subgraph_175E8EF_Output1, _Subgraph_175E8EF_Output2);
                        surface.Alpha = (_Subgraph_175E8EF_Output2).x;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
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
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
        
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
        
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
        
        #if defined(DEBUG_DISPLAY)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
        
                builtinData.opacity = surfaceDescription.Alpha;
        
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
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
            // based on HDUnlitPassForward.template
            Name "META"
            Tags { "LightMode" = "META" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One OneMinusSrcAlpha
        
            Cull Off
        
            ZTest LEqual
        
            ZWrite Off
        
            // Default Stencil
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            //enable GPU instancing support
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Wind.hlsl"
        
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
            #define VARYINGS_NEED_COLOR
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
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
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 interp01 : TEXCOORD1; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            output.interp01.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            output.color = input.interp01.xyzw;
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
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_23DD87FD); SAMPLER(samplerTexture2D_23DD87FD); float4 Texture2D_23DD87FD_TexelSize;
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    // Subgraph function
                    void sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(float4 Vector4_D4823111, SurfaceDescriptionInputs IN, out float4 Output1, out float4 Output2)
                    {
                    float4 _Property_C185F2BC_Out = Vector4_D4823111;
                    float4 _Multiply_A9E570A4_Out;
                    Unity_Multiply_float(IN.VertexColor, _Property_C185F2BC_Out, _Multiply_A9E570A4_Out);
                    
                    float _Split_9332C9F_R = _Multiply_A9E570A4_Out[0];
                    float _Split_9332C9F_G = _Multiply_A9E570A4_Out[1];
                    float _Split_9332C9F_B = _Multiply_A9E570A4_Out[2];
                    float _Split_9332C9F_A = _Multiply_A9E570A4_Out[3];
                    float4 _Combine_9E4C1326_RGBA;
                    float3 _Combine_9E4C1326_RGB;
                    float2 _Combine_9E4C1326_RG;
                    Unity_Combine_float(_Split_9332C9F_R, _Split_9332C9F_G, _Split_9332C9F_B, 0, _Combine_9E4C1326_RGBA, _Combine_9E4C1326_RGB, _Combine_9E4C1326_RG);
                    Output1 = (float4(_Combine_9E4C1326_RGB, 1.0));
                    Output2 = (_Split_9332C9F_A.xxxx);
                    }
                
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_3A74E746_RGBA = SAMPLE_TEXTURE2D(Texture2D_23DD87FD, samplerTexture2D_23DD87FD, IN.uv0.xy);
                        float _SampleTexture2D_3A74E746_R = _SampleTexture2D_3A74E746_RGBA.r;
                        float _SampleTexture2D_3A74E746_G = _SampleTexture2D_3A74E746_RGBA.g;
                        float _SampleTexture2D_3A74E746_B = _SampleTexture2D_3A74E746_RGBA.b;
                        float _SampleTexture2D_3A74E746_A = _SampleTexture2D_3A74E746_RGBA.a;
                        float4 _Subgraph_175E8EF_Output1;
                        float4 _Subgraph_175E8EF_Output2;
                        sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(_SampleTexture2D_3A74E746_RGBA, IN, _Subgraph_175E8EF_Output1, _Subgraph_175E8EF_Output2);
                        surface.Color = (_Subgraph_175E8EF_Output1.xyz);
                        surface.Alpha = (_Subgraph_175E8EF_Output2).x;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
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
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
        
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
        
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
        
                builtinData.opacity = surfaceDescription.Alpha;
        
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
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
            // based on HDUnlitPassForward.template
            Name "SceneSelectionPass"
            Tags { "LightMode" = "SceneSelectionPass" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One OneMinusSrcAlpha
        
            Cull Back
        
            ZTest LEqual
        
            ZWrite Off
        
            // Default Stencil
        
            ColorMask 0
        
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            //enable GPU instancing support
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Wind.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_DEPTH_ONLY
                #define SCENESELECTIONPASS
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
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
            float4 uv0 : TEXCOORD0; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 interp01 : TEXCOORD1; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            output.interp01.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            output.color = input.interp01.xyzw;
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
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_23DD87FD); SAMPLER(samplerTexture2D_23DD87FD); float4 Texture2D_23DD87FD_TexelSize;
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    // Subgraph function
                    void sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(float4 Vector4_D4823111, SurfaceDescriptionInputs IN, out float4 Output1, out float4 Output2)
                    {
                    float4 _Property_C185F2BC_Out = Vector4_D4823111;
                    float4 _Multiply_A9E570A4_Out;
                    Unity_Multiply_float(IN.VertexColor, _Property_C185F2BC_Out, _Multiply_A9E570A4_Out);
                    
                    float _Split_9332C9F_R = _Multiply_A9E570A4_Out[0];
                    float _Split_9332C9F_G = _Multiply_A9E570A4_Out[1];
                    float _Split_9332C9F_B = _Multiply_A9E570A4_Out[2];
                    float _Split_9332C9F_A = _Multiply_A9E570A4_Out[3];
                    float4 _Combine_9E4C1326_RGBA;
                    float3 _Combine_9E4C1326_RGB;
                    float2 _Combine_9E4C1326_RG;
                    Unity_Combine_float(_Split_9332C9F_R, _Split_9332C9F_G, _Split_9332C9F_B, 0, _Combine_9E4C1326_RGBA, _Combine_9E4C1326_RGB, _Combine_9E4C1326_RG);
                    Output1 = (float4(_Combine_9E4C1326_RGB, 1.0));
                    Output2 = (_Split_9332C9F_A.xxxx);
                    }
                
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_3A74E746_RGBA = SAMPLE_TEXTURE2D(Texture2D_23DD87FD, samplerTexture2D_23DD87FD, IN.uv0.xy);
                        float _SampleTexture2D_3A74E746_R = _SampleTexture2D_3A74E746_RGBA.r;
                        float _SampleTexture2D_3A74E746_G = _SampleTexture2D_3A74E746_RGBA.g;
                        float _SampleTexture2D_3A74E746_B = _SampleTexture2D_3A74E746_RGBA.b;
                        float _SampleTexture2D_3A74E746_A = _SampleTexture2D_3A74E746_RGBA.a;
                        float4 _Subgraph_175E8EF_Output1;
                        float4 _Subgraph_175E8EF_Output2;
                        sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(_SampleTexture2D_3A74E746_RGBA, IN, _Subgraph_175E8EF_Output1, _Subgraph_175E8EF_Output2);
                        surface.Alpha = (_Subgraph_175E8EF_Output2).x;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
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
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
        
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
        
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
        
        #if defined(DEBUG_DISPLAY)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
        
                builtinData.opacity = surfaceDescription.Alpha;
        
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
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
            // based on HDUnlitPassForward.template
            Name "ForwardOnly"
            Tags { "LightMode" = "ForwardOnly" }
        
            //-------------------------------------------------------------------------------------
            // Render Modes (Blend, Cull, ZTest, Stencil, etc)
            //-------------------------------------------------------------------------------------
            Blend One OneMinusSrcAlpha
        
            Cull Back
        
            ZTest LEqual
        
            ZWrite Off
        
            // Default Stencil
        
            
            //-------------------------------------------------------------------------------------
            // End Render Modes
            //-------------------------------------------------------------------------------------
        
            HLSLPROGRAM
        
            #pragma target 4.5
            #pragma only_renderers d3d11 ps4 xboxone vulkan metal switch
            //#pragma enable_d3d11_debug_symbols
        
            //enable GPU instancing support
            #pragma multi_compile_instancing
        
            //-------------------------------------------------------------------------------------
            // Variant Definitions (active field translations to HDRP defines)
            //-------------------------------------------------------------------------------------
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _BLENDMODE_ALPHA 1
            //-------------------------------------------------------------------------------------
            // End Variant Definitions
            //-------------------------------------------------------------------------------------
        
            #pragma vertex Vert
            #pragma fragment Frag
        
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Wind.hlsl"
        
            // define FragInputs structure
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/FragInputs.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPass.cs.hlsl"
        
            //-------------------------------------------------------------------------------------
            // Defines
            //-------------------------------------------------------------------------------------
                    #define SHADERPASS SHADERPASS_FORWARD_UNLIT
                #pragma multi_compile _ DEBUG_DISPLAY
                #pragma multi_compile _ LIGHTMAP_ON
                #pragma multi_compile _ DIRLIGHTMAP_COMBINED
                #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        
            // this translates the new dependency tracker into the old preprocessor definitions for the existing HDRP shader code
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
        
            //-------------------------------------------------------------------------------------
            // End Defines
            //-------------------------------------------------------------------------------------
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl"
        #ifdef DEBUG_DISPLAY
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Debug/DebugDisplay.hlsl"
        #endif
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Material.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/Unlit/Unlit.hlsl"
        
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/BuiltinUtilities.hlsl"
            #include "Packages/com.unity.render-pipelines.high-definition/Runtime/Material/MaterialUtilities.hlsl"
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
            float4 uv0 : TEXCOORD0; // optional
            float4 color : COLOR; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        
        // Generated Type: VaryingsMeshToPS
        struct VaryingsMeshToPS {
            float4 positionCS : SV_Position;
            float4 texCoord0; // optional
            float4 color; // optional
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        struct PackedVaryingsMeshToPS {
            float4 interp00 : TEXCOORD0; // auto-packed
            float4 interp01 : TEXCOORD1; // auto-packed
            float4 positionCS : SV_Position; // unpacked
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC; // unpacked
            #endif // UNITY_ANY_INSTANCING_ENABLED
        };
        PackedVaryingsMeshToPS PackVaryingsMeshToPS(VaryingsMeshToPS input)
        {
            PackedVaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.interp00.xyzw = input.texCoord0;
            output.interp01.xyzw = input.color;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif // UNITY_ANY_INSTANCING_ENABLED
            return output;
        }
        VaryingsMeshToPS UnpackVaryingsMeshToPS(PackedVaryingsMeshToPS input)
        {
            VaryingsMeshToPS output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.interp00.xyzw;
            output.color = input.interp01.xyzw;
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
                    CBUFFER_END
                
                    TEXTURE2D(Texture2D_23DD87FD); SAMPLER(samplerTexture2D_23DD87FD); float4 Texture2D_23DD87FD_TexelSize;
                
                // Pixel Graph Inputs
                    struct SurfaceDescriptionInputs {
                        float4 uv0; // optional
                        float4 VertexColor; // optional
                    };
                // Pixel Graph Outputs
                    struct SurfaceDescription
                    {
                        float3 Color;
                        float Alpha;
                        float AlphaClipThreshold;
                    };
                    
                // Shared Graph Node Functions
                
                    void Unity_Multiply_float (float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }
                
                    void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
                    {
                        RGBA = float4(R, G, B, A);
                        RGB = float3(R, G, B);
                        RG = float2(R, G);
                    }
                
                    // Subgraph function
                    void sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(float4 Vector4_D4823111, SurfaceDescriptionInputs IN, out float4 Output1, out float4 Output2)
                    {
                    float4 _Property_C185F2BC_Out = Vector4_D4823111;
                    float4 _Multiply_A9E570A4_Out;
                    Unity_Multiply_float(IN.VertexColor, _Property_C185F2BC_Out, _Multiply_A9E570A4_Out);
                    
                    float _Split_9332C9F_R = _Multiply_A9E570A4_Out[0];
                    float _Split_9332C9F_G = _Multiply_A9E570A4_Out[1];
                    float _Split_9332C9F_B = _Multiply_A9E570A4_Out[2];
                    float _Split_9332C9F_A = _Multiply_A9E570A4_Out[3];
                    float4 _Combine_9E4C1326_RGBA;
                    float3 _Combine_9E4C1326_RGB;
                    float2 _Combine_9E4C1326_RG;
                    Unity_Combine_float(_Split_9332C9F_R, _Split_9332C9F_G, _Split_9332C9F_B, 0, _Combine_9E4C1326_RGBA, _Combine_9E4C1326_RGB, _Combine_9E4C1326_RG);
                    Output1 = (float4(_Combine_9E4C1326_RGB, 1.0));
                    Output2 = (_Split_9332C9F_A.xxxx);
                    }
                
                // Pixel Graph Evaluation
                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_3A74E746_RGBA = SAMPLE_TEXTURE2D(Texture2D_23DD87FD, samplerTexture2D_23DD87FD, IN.uv0.xy);
                        float _SampleTexture2D_3A74E746_R = _SampleTexture2D_3A74E746_RGBA.r;
                        float _SampleTexture2D_3A74E746_G = _SampleTexture2D_3A74E746_RGBA.g;
                        float _SampleTexture2D_3A74E746_B = _SampleTexture2D_3A74E746_RGBA.b;
                        float _SampleTexture2D_3A74E746_A = _SampleTexture2D_3A74E746_RGBA.a;
                        float4 _Subgraph_175E8EF_Output1;
                        float4 _Subgraph_175E8EF_Output2;
                        sg_ParticleVertexColor_SurfaceDescriptionInputs_44A76D36(_SampleTexture2D_3A74E746_RGBA, IN, _Subgraph_175E8EF_Output1, _Subgraph_175E8EF_Output2);
                        surface.Color = (_Subgraph_175E8EF_Output1.xyz);
                        surface.Alpha = (_Subgraph_175E8EF_Output2).x;
                        surface.AlphaClipThreshold = 0;
                        return surface;
                    }
                    
            //-------------------------------------------------------------------------------------
            // End graph generated code
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
                output.color = input.color;
                #if SHADER_STAGE_FRAGMENT
                #endif // SHADER_STAGE_FRAGMENT
        
                return output;
            }
        
            SurfaceDescriptionInputs FragInputsToSurfaceDescriptionInputs(FragInputs input, float3 viewWS)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
        
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
        
        
        
            void BuildSurfaceData(FragInputs fragInputs, inout SurfaceDescription surfaceDescription, float3 V, PositionInputs posInput, out SurfaceData surfaceData)
            {
                // setup defaults -- these are used if the graph doesn't output a value
                ZERO_INITIALIZE(SurfaceData, surfaceData);
        
                // copy across graph values, if defined
                surfaceData.color = surfaceDescription.Color;
        
        #if defined(DEBUG_DISPLAY)
                if (_DebugMipMapMode != DEBUGMIPMAPMODE_NONE)
                {
                    // TODO
                }
        #endif
            }
        
            void GetSurfaceAndBuiltinData(FragInputs fragInputs, float3 V, inout PositionInputs posInput, out SurfaceData surfaceData, out BuiltinData builtinData)
            {
                SurfaceDescriptionInputs surfaceDescriptionInputs = FragInputsToSurfaceDescriptionInputs(fragInputs, V);
                SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(surfaceDescriptionInputs);
        
                // Perform alpha test very early to save performance (a killed pixel will not sample textures)
                // TODO: split graph evaluation to grab just alpha dependencies first? tricky..
        
                BuildSurfaceData(fragInputs, surfaceDescription, V, posInput, surfaceData);
        
                // Builtin Data
                ZERO_INITIALIZE(BuiltinData, builtinData); // No call to InitBuiltinData as we don't have any lighting
        
                builtinData.opacity = surfaceDescription.Alpha;
        
        
        #if (SHADERPASS == SHADERPASS_DISTORTION)
                builtinData.distortion = surfaceDescription.Distortion;
                builtinData.distortionBlur = surfaceDescription.DistortionBlur;
        #else
                builtinData.distortion = float2(0.0, 0.0);
                builtinData.distortionBlur = 0.0;
        #endif
            }
        
            //-------------------------------------------------------------------------------------
            // Pass Includes
            //-------------------------------------------------------------------------------------
                #include "Packages/com.unity.render-pipelines.high-definition/Runtime/RenderPipeline/ShaderPass/ShaderPassForwardUnlit.hlsl"
            //-------------------------------------------------------------------------------------
            // End Pass Includes
            //-------------------------------------------------------------------------------------
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.ShaderGraph.HDUnlitGUI"
    FallBack "Hidden/InternalErrorShader"
}
