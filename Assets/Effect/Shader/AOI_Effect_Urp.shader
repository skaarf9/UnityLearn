Shader "AOI/Effect/AOI_Effect_Urp"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("SrcBlend", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("DstBlend", Float) = 1
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode ("CullMode", float) = 2
        [Enum(Off, 0, On, 1)]_ZWriteMode ("ZWriteMode", float) = 0
         [Toggle]_CustomData1XY("CustomData1XY",float) = 0
         [Toggle]_CustomData1ZW("CustomData1ZW",float) = 0
         [Toggle]_CustomData2X("CustomData2XY",float) = 0
         //[Toggle]_CustomData2ZW("CustomData2ZW",float) = 0
        _BlendType("blendType",float) = 0
        _CullType("cullType",float) = 0
        _ZTestMode("ZTestMode",float) = 4
        _MainTex ("Texture", 2D) = "white" {}
        [HDR]_Color("Color",COLOR) = (1,1,1,1)
       
        _MainTex_Uspeed("MainTex_Uspeed",float) = 0
        _MainTex_Vspeed("MainTex_Vspeed",float) = 0
         [Toggle]_MainTex_Alpha_R("MainTex_Alpha_R",float) = 0
         [Toggle] _BackColor_ON("开启背面颜色",float) = 0
         [HDR]_BackColor("背面颜色",COLOR) = (1,1,1,1)
         [Toggle(_ADDTEX_ON)]_AddTexOn("AddTexOn",float) = 0
        _AddTex("AddTex",2D) = "white"{}
         [HDR]_AddTex_Color("Color",COLOR) = (1,1,1,1)
        _AddTex_Uspeed("AddTex_Uspeed",float) = 0
        _AddTex_Vspeed("AddTex_Vspeed",float) = 0
        _AddLerpValue("AddLerpValue",Range(0,1)) = 0
        _MaskTex("MaskTex",2D) = "white"{}
        [Toggle]_MaskTex_RA("MaskTex_RA",float) = 0
        _Mask_Uspeed("Mask_Uspeed",float) = 0
        _Mask_Vspeed("Mask_Vspeed",float) = 0
        _DissolveTex("DissolveTex",2D) = "white"{}
        _Dissolve_Uspeed("Dissolve_Uspeed",float) = 0
        _Dissolve_Vspeed("Dissolve_Vspeed",float) = 0
        _DissolveValue("DissolveValue",Range(0,1.2)) = 0
        [Toggle(SOFTA_DISSOLVE)]_SoftaDissolveON("SoftaDissolveON",float) = 0
        [Toggle]_DissolveMainTexON("DissolveMainTexON",float) = 0
        _SoftaDissolve("SoftaDissolve",Range(0,1)) = 0
        [HDR]_DissolveColor("DissolveColor",COLOR)  = (1,1,1,1)
        _LineWidth("LineWidth",Range(0,0.85)) = 0
         [Toggle(_SOFT_PARTICLE_ON)]_SoftParticleOn("SOFT_PARTICLE_ON",float) = 0
        _Soft_Particle("Soft_Particle",Range(0,1)) = 1
         [Toggle(_FRESNE_ON)]_FresnelOn("FRESNE_ON",float) = 0
        _FresnelBase("fresnelBase", Range(0, 1)) = 0
        _FresnelScale("fresnelScale", Range(0, 1)) = 1
        _FresnelIndensity("fresnelIndensity", Range(0, 10)) = 1
        [HDR]_FresnelCol("_fresnelCol", Color) = (1,1,1,1)
        _Alpha ("Alpha",Range(0,1)) = 1 
        _BloomFactor("BloomFactor",Range(0,1)) = 1

       _NoiseTex ("Noise Texture (RG)", 2D) = "white" {} //屏幕扭曲
	   _HeatTime  ("Heat Time", range (0,1.5)) = 1
	   _HeatForce  ("Heat Force", range (0,6)) = 0.1

        _MainTexAngle("MainTexAngle",float) = 0
        _AddTexAngle("AddTexAngle",float) = 0
        _MaskTexAngle("MaskTexAngle",float) = 0


        [Toggle]_Noise_On("_Noise_On",float) = 0
        _NoiseTexture("NoiseTexture", 2D) = "white" {}
        _NoiseTex_Uspeed("NoiseTex_Uspeed",float) = 0
        _NoiseTex_Vspeed("NoiseTex_Vspeed",float) = 0
        _Noise_Intensity("Noise_Intensity",Range(0,1)) = 0
        _Alpha_Intensity("Alpha_Intensity",float) = 1
        [Toggle(_BILLBOARD_ON)]_BillboardOn("BillboardOn",float) = 0
        _VerticalBillborading("VerticalBillborading",Range(0,1))=0

        [Toggle(_VNOISE_ON)] _VNoise_ON("VNoise_ON",float) = 0
        _VertexNoiseTex("VertexNoiseTex",2D) = "white"{}
        _VertexNoiseSize("VertexNoiseSize",float) = 0
        _VertexNoiseSpeedU("VertexNoiseSpeedU",float) = 0
         _VertexNoiseSpeedV("VertexNoiseSpeedU",float) = 0
         _VertexNoisePower("VertexNoisePower",float) = 0
    }
    SubShader
    {
      
        Tags{"Queue"="Transparent"}
        Pass
        {
             Name "EfTransparent"
             Tags{"LightMode" = "UniversalForward" "Queue"="Transparent"}
            Blend [_SrcBlend] [_DstBlend]
            Cull [_CullMode]
            ZTest [_ZTestMode]
            ZWrite [_ZWriteMode]
            ColorMask RGB
            CGPROGRAM
            #pragma shader_feature USE_DISSOLVE
            #pragma shader_feature SOFTA_DISSOLVE
            #pragma shader_feature _SOFT_PARTICLE_ON
            #pragma shader_feature _ADDTEX_ON
            #pragma shader_feature _FRESNE_ON
            #pragma shader_feature _BILLBOARD_ON
            #pragma shader_feature _VNOISE_ON
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"
            #pragma target 3.0
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float4 vertexColor : COLOR;
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 projPos : TEXCOORD1;
                float3 N:TEXCOORD2;
                float3 V:TEXCOORD3;
                float4 vertexColor : TEXCOORD4;
                float4 customData1 : TEXCOORD5;
                float4 customData2 : TEXCOORD6;
            };
            float _BlendType;
            uniform sampler2D _CameraDepthTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _MainTex_Uspeed;
            float _MainTex_Vspeed;
            float _MainTex_Alpha_R;
            sampler2D _AddTex;
             float4 _AddTex_ST;
            float4 _AddTex_Color;
            float _AddTex_Uspeed;
            float _AddTex_Vspeed;
            float _AddLerpValue;
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _MaskTex_RA;
            float _Mask_Uspeed;
            float _Mask_Vspeed;
            sampler2D _DissolveTex;
            float4 _DissolveTex_ST;
            float _DissolveValue;
            float _Soft_Particle;
            float _FresnelBase;
            float _FresnelScale;
            float _FresnelIndensity;
            float4 _FresnelCol;
            float _Alpha;
            float _BloomFactor;
            float _CustomData1XY;
            float _CustomData1ZW;
            float _CustomData2X;
          
            float4 _BackColor;
            float _MainTexAngle;
            float _AddTexAngle;
            float _MaskTexAngle;

            float _Noise_On;
            sampler2D _NoiseTexture;
            float4 _NoiseTexture_ST;
            float _NoiseTex_Uspeed;
            float _NoiseTex_Vspeed;
            float _Noise_Intensity;
            float _BackColor_ON;
            float _Alpha_Intensity;
            float _VerticalBillborading;

            sampler2D _VertexNoiseTex;
             float4 _VertexNoiseTex_ST;
            float _VertexNoiseSize;
            float _VertexNoiseSpeedU;
            float _VertexNoiseSpeedV;
            float _VertexNoisePower;

            float _Dissolve_Uspeed;
            float _Dissolve_Vspeed;
            float _SoftaDissolve;
            float _LineWidth;
            float4 _DissolveColor;
            float _DissolveMainTexON;
          //  float _SoftaDissolveON;
            v2f vert (appdata v)
            {
                 v2f o;
                 #if defined(_VNOISE_ON)
                 float2 uv = TRANSFORM_TEX(v.texcoord.xy,_VertexNoiseTex)+float2(_VertexNoiseSpeedU,_VertexNoiseSpeedV)*_Time.y; 
                 float3 vertexValue = (float4(v.normal,0.0)*pow(tex2Dlod( _VertexNoiseTex,float4(uv,0,0.0)),_VertexNoisePower)*_VertexNoiseSize).xyz;
                 v.vertex.xyz+=vertexValue;
                 #endif
                 //广告牌效果
                 #if defined(_BILLBOARD_ON) 
                     //选择模型空间的原点作为广告牌的锚点
                     float3 center = float3(0,0,0);
                     //计算模型空间中的视线方向
                     float3 objViewDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
                     //根据观察方向和锚点计算目标法线向量
                     float3 normalDir = objViewDir - center;
                     /*
                       更具 _VerticalBillborading来控制垂直方向的约束
                       当 _VerticalBillborading 为 1 时,法线方向固定，为视角方向
                       当 _VerticalBillborading 为 0 时,向上方向固定，为(0,1,0)
                     */
                     normalDir.y *= _VerticalBillborading;
                     normalDir =normalize(normalDir);

                     float3 upDir = abs(normalDir.y)>0.999?float3(0, 0, 1):float3(0, 1, 0);
                     float3 rightDir = normalize(cross(normalDir, upDir))*-1;
                     upDir = normalize(cross(normalDir, rightDir));
 
                     //用旋转矩阵对顶点进行偏移
                     float3 centerOffs = v.vertex.xyz - center;
                     float3 localPos =center +  rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
 
                     //将偏移之后的值作为新的顶点传递计算
                     o.vertex = UnityObjectToClipPos(float4(localPos,1));
                 #else
                     
                     o.vertex = UnityObjectToClipPos(v.vertex);
                 #endif

                o.uv =v.texcoord.xy;
                o.projPos = ComputeScreenPos (o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.N = mul(v.normal,(float3x3)unity_WorldToObject);
                o.V = WorldSpaceViewDir(v.vertex);
                o.vertexColor = v.vertexColor;
                o.customData1 = v.texcoord1.xyzw;
                 o.customData2 = v.texcoord2.xyzw;
            
                return o;
            }

            float2 RotateUV(float2 inputUV,float rAngle){
                   if(rAngle==0)return inputUV;
                  //uv值的区间是（0，1），所以中心点就是（0.5，0.5）
                   float center = float2(0.5, 0.5);
                  //将uv坐标移到中心
                   float2 uv = inputUV.xy - center;
                    //输入的_Angle值为了方便理解设定为-360-360.  经过转换后的angle值为（-pi * 2） - （pi*2）区间
                    float angle = rAngle * (3.14 * 2 / 360);
                    //矩阵旋转
                    uv = float2(uv.x * cos(angle) - uv.y * sin(angle),
                         uv.x * sin(angle) + uv.y * cos(angle));
                    
                    //还原uv坐标
                    uv += float2(0.5, 0.5);

                    return uv;
            }

            float4 frag (v2f i,float facing : VFACE) : SV_Target
            {
                float4 debugColor = 1.0;
                float isFrontFace = ( facing >= 0 ? 1 : 0 ); 

                float2 _noise = 0.0;
                if(_Noise_On){
                    float2  _noiseOffset = half2(_NoiseTex_Uspeed,_NoiseTex_Vspeed)*_Time.y;
                    float4 noiseCol = tex2D(_NoiseTexture,TRANSFORM_TEX(i.uv, _NoiseTexture)+_noiseOffset);
                    _noise = noiseCol.xy*_Noise_Intensity;
                }
                // sample the texture
               // float4 col = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex)+float2(_MainTex_Uspeed,_MainTex_Vspeed)*_Time.y);
                _MainTex_Uspeed = _CustomData1XY?i.customData1.x:_MainTex_Uspeed*_Time.y;
                _MainTex_Vspeed =  _CustomData1XY?i.customData1.y:_MainTex_Vspeed*_Time.y;
              
                float4 col = tex2D(_MainTex, TRANSFORM_TEX(RotateUV(i.uv,_MainTexAngle), _MainTex)+float2(_MainTex_Uspeed,_MainTex_Vspeed)+_noise);
                col.rgb = _BlendType<1?col.rgb*col.a:col.rgb;
                col.a = _MainTex_Alpha_R?col.r:col.a;
                col.rgb*= _Color.rgb*i.vertexColor.rgb;
                #ifdef _ADDTEX_ON
                _AddTex_Uspeed =  _CustomData1XY?i.customData1.x:_AddTex_Uspeed*_Time.y;
                _AddTex_Vspeed =  _CustomData1XY?i.customData1.y:_AddTex_Vspeed*_Time.y;
                float4 addMap = tex2D(_AddTex, TRANSFORM_TEX(RotateUV(i.uv,_AddTexAngle), _AddTex)+float2(_AddTex_Uspeed,_AddTex_Vspeed)+_noise);
                addMap.rgb = _BlendType<1?addMap.rgb*addMap.a:addMap.rgb;
                addMap*=_AddTex_Color;
               // col = lerp(col,addMap,_AddLerpValue);
                 col *= addMap;
               /// float stemp = step(0.01,col.r);
                // col.rgb = col.rgb*col.a+addMap.rgb*(1-col.a);
                #endif
              
                
               if(_BackColor_ON){
                col.rgb=isFrontFace?col.rgb:_BackColor.rgb;
                }
               

                  _Mask_Uspeed =   _CustomData1ZW?i.customData1.z:_Mask_Uspeed*_Time.y; 
                  _Mask_Vspeed =   _CustomData1ZW?i.customData1.w:_Mask_Vspeed*_Time.y; 
                float4 maskMap = tex2D(_MaskTex, TRANSFORM_TEX(RotateUV(i.uv,_MaskTexAngle), _MaskTex)+float2(_Mask_Uspeed,_Mask_Vspeed));
                  col = col*(_MaskTex_RA?maskMap.a:maskMap.r);

                 #if defined(USE_DISSOLVE)
                float dissolveClip = tex2D(_DissolveTex, TRANSFORM_TEX(i.uv, _DissolveTex)+float2(_Dissolve_Uspeed,_Dissolve_Vspeed)*_Time.y).r;
                _DissolveValue = _CustomData2X?i.customData2.x:_DissolveValue;
               // 
                 #if defined(SOFTA_DISSOLVE)
                    float clempResult00 = clamp((dissolveClip.x+1.0)-(2.0*_DissolveValue),0.0,1.0);
                    float smoothstepResult00 = smoothstep(0.0,(1.0-_SoftaDissolve),clempResult00);
                    if(_BlendType<0.5){
                     col.rgb *= smoothstepResult00;
                     }else{
                      col.a *= smoothstepResult00;
                    }
                 
                    float dissolveLineSource = _DissolveMainTexON>0.5? col.x:smoothstepResult00; 
                    float4 dissolveLine = (step(dissolveLineSource,0.85)-step((dissolveLineSource+_LineWidth),0.85))*_DissolveColor;
                    col.rgb += dissolveLine.rgb;
                #else
                 clip(dissolveClip-_DissolveValue);
                #endif
                #endif
              

                //软粒子
                #ifdef _SOFT_PARTICLE_ON
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                col *=saturate((sceneZ-partZ)/_Soft_Particle);
                #endif

                #ifdef _FRESNE_ON
                float fresnel = pow( 1-saturate(dot(normalize(i.N),normalize(i.V))),_FresnelIndensity)*_FresnelScale+_FresnelBase;
                col=lerp( col,_FresnelCol,fresnel*_FresnelCol.a*isFrontFace);
                #endif
                _Alpha*=i.vertexColor.a*_Alpha_Intensity;
               
                half4 _a = _BlendType? half4(1,1,1,_Alpha):half4(_Alpha,_Alpha,_Alpha,1);
                col*=_a;
                col.a = saturate( col.a);
                return col; //
            }
            ENDCG
        }

          Pass
        {
 
            Tags{"LightMode" = "TransparentBloomFactor"}
        
            ZWrite Off
            Cull Off
            ColorMask A
            Blend Zero OneMinusSrcAlpha
            CGPROGRAM
            #pragma shader_feature USE_DISSOLVE
            #pragma shader_feature _SOFT_PARTICLE_ON
            #pragma shader_feature _ADDTEX_ON
            #pragma shader_feature _FRESNE_ON
             #pragma shader_feature _BILLBOARD_ON
            #pragma shader_feature _VNOISE_ON
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest 
           

            #include "UnityCG.cginc"

           struct appdata
            {
                float4 vertex : POSITION;
                float3 normal :NORMAL;
                float4 vertexColor : COLOR;
                float4 texcoord : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 projPos : TEXCOORD1;
                float3 N:TEXCOORD2;
                float3 V:TEXCOORD3;
                float4 vertexColor : TEXCOORD4;
                float4 customData1 : TEXCOORD5;
                float4 customData2 : TEXCOORD6;
            };
            float _BlendType;
            uniform sampler2D _CameraDepthTexture;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _MainTex_Uspeed;
            float _MainTex_Vspeed;
            float _MainTex_Alpha_R;
            sampler2D _AddTex;
             float4 _AddTex_ST;
            float4 _AddTex_Color;
            float _AddTex_Uspeed;
            float _AddTex_Vspeed;
            float _AddLerpValue;
            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float _MaskTex_RA;
            float _Mask_Uspeed;
            float _Mask_Vspeed;
            sampler2D _DissolveTex;
            float4 _DissolveTex_ST;
            float _DissolveValue;
            float _Soft_Particle;
            float _FresnelBase;
            float _FresnelScale;
            float _FresnelIndensity;
            float4 _FresnelCol;
            float _Alpha;
            float _BloomFactor;
            float _CustomData1XY;
            float _CustomData1ZW;
            float _CustomData2X;
          
            float4 _BackColor;
            float _MainTexAngle;
            float _AddTexAngle;
            float _MaskTexAngle;

            float _Noise_On;
            sampler2D _NoiseTexture;
            float4 _NoiseTexture_ST;
            float _NoiseTex_Uspeed;
            float _NoiseTex_Vspeed;
            float _Noise_Intensity;
            float _BackColor_ON;
            float _Alpha_Intensity;
            float _VerticalBillborading;

            sampler2D _VertexNoiseTex;
             float4 _VertexNoiseTex_ST;
            float _VertexNoiseSize;
            float _VertexNoiseSpeedU;
            float _VertexNoiseSpeedV;
            float _VertexNoisePower;

            float _Dissolve_Uspeed;
            float _Dissolve_Vspeed;
            float _SoftaDissolve;
            float _LineWidth;
            float4 _DissolveColor;
            float _DissolveMainTexON;
          //  float _SoftaDissolveON;
            v2f vert (appdata v)
            {
                 v2f o;
                 #if defined(_VNOISE_ON)
                 float2 uv = TRANSFORM_TEX(v.texcoord.xy,_VertexNoiseTex)+float2(_VertexNoiseSpeedU,_VertexNoiseSpeedV)*_Time.y; 
                 float3 vertexValue = (float4(v.normal,0.0)*pow(tex2Dlod( _VertexNoiseTex,float4(uv,0,0.0)),_VertexNoisePower)*_VertexNoiseSize).xyz;
                 v.vertex.xyz+=vertexValue;
                 #endif
                 //广告牌效果
                 #if defined(_BILLBOARD_ON) 
                     //选择模型空间的原点作为广告牌的锚点
                     float3 center = float3(0,0,0);
                     //计算模型空间中的视线方向
                     float3 objViewDir = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
                     //根据观察方向和锚点计算目标法线向量
                     float3 normalDir = objViewDir - center;
                     /*
                       更具 _VerticalBillborading来控制垂直方向的约束
                       当 _VerticalBillborading 为 1 时,法线方向固定，为视角方向
                       当 _VerticalBillborading 为 0 时,向上方向固定，为(0,1,0)
                     */
                     normalDir.y *= _VerticalBillborading;
                     normalDir =normalize(normalDir);

                     float3 upDir = abs(normalDir.y)>0.999?float3(0, 0, 1):float3(0, 1, 0);
                     float3 rightDir = normalize(cross(normalDir, upDir))*-1;
                     upDir = normalize(cross(normalDir, rightDir));
 
                     //用旋转矩阵对顶点进行偏移
                     float3 centerOffs = v.vertex.xyz - center;
                     float3 localPos =center +  rightDir * centerOffs.x + upDir * centerOffs.y + normalDir * centerOffs.z;
 
                     //将偏移之后的值作为新的顶点传递计算
                     o.vertex = UnityObjectToClipPos(float4(localPos,1));
                 #else
                     
                     o.vertex = UnityObjectToClipPos(v.vertex);
                 #endif

                o.uv =v.texcoord.xy;
                o.projPos = ComputeScreenPos (o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);
                o.N = mul(v.normal,(float3x3)unity_WorldToObject);
                o.V = WorldSpaceViewDir(v.vertex);
                o.vertexColor = v.vertexColor;
                o.customData1 = v.texcoord1.xyzw;
                 o.customData2 = v.texcoord2.xyzw;
            
                return o;
            }

            float2 RotateUV(float2 inputUV,float rAngle){
                   if(rAngle==0)return inputUV;
                  //uv值的区间是（0，1），所以中心点就是（0.5，0.5）
                   float center = float2(0.5, 0.5);
                  //将uv坐标移到中心
                   float2 uv = inputUV.xy - center;
                    //输入的_Angle值为了方便理解设定为-360-360.  经过转换后的angle值为（-pi * 2） - （pi*2）区间
                    float angle = rAngle * (3.14 * 2 / 360);
                    //矩阵旋转
                    uv = float2(uv.x * cos(angle) - uv.y * sin(angle),
                         uv.x * sin(angle) + uv.y * cos(angle));
                    
                    //还原uv坐标
                    uv += float2(0.5, 0.5);

                    return uv;
            }

            float4 frag (v2f i,float facing : VFACE) : SV_Target
            {
                float4 debugColor = 1.0;
                float isFrontFace = ( facing >= 0 ? 1 : 0 ); 

                float2 _noise = 0.0;
                if(_Noise_On){
                    float2  _noiseOffset = half2(_NoiseTex_Uspeed,_NoiseTex_Vspeed)*_Time.y;
                    float4 noiseCol = tex2D(_NoiseTexture,TRANSFORM_TEX(i.uv, _NoiseTexture)+_noiseOffset);
                    _noise = noiseCol.xy*_Noise_Intensity;
                }
                // sample the texture
               // float4 col = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex)+float2(_MainTex_Uspeed,_MainTex_Vspeed)*_Time.y);
                _MainTex_Uspeed = _CustomData1XY?i.customData1.x:_MainTex_Uspeed*_Time.y;
                _MainTex_Vspeed =  _CustomData1XY?i.customData1.y:_MainTex_Vspeed*_Time.y;
              
                float4 col = tex2D(_MainTex, TRANSFORM_TEX(RotateUV(i.uv,_MainTexAngle), _MainTex)+float2(_MainTex_Uspeed,_MainTex_Vspeed)+_noise);
                col.rgb = _BlendType<1?col.rgb*col.a:col.rgb;
                col.a = _MainTex_Alpha_R?col.r:col.a;
                col.rgb*= _Color.rgb*i.vertexColor.rgb;
                #ifdef _ADDTEX_ON
                _AddTex_Uspeed =  _CustomData1XY?i.customData1.x:_AddTex_Uspeed*_Time.y;
                _AddTex_Vspeed =  _CustomData1XY?i.customData1.y:_AddTex_Vspeed*_Time.y;
                float4 addMap = tex2D(_AddTex, TRANSFORM_TEX(RotateUV(i.uv,_AddTexAngle), _AddTex)+float2(_AddTex_Uspeed,_AddTex_Vspeed)+_noise);
                addMap.rgb = _BlendType<1?addMap.rgb*addMap.a:addMap.rgb;
                addMap*=_AddTex_Color;
               // col = lerp(col,addMap,_AddLerpValue);
                 col *= addMap;
               /// float stemp = step(0.01,col.r);
                // col.rgb = col.rgb*col.a+addMap.rgb*(1-col.a);
                #endif
              
                
               if(_BackColor_ON){
                col.rgb=isFrontFace?col.rgb:_BackColor.rgb;
                }
               

                  _Mask_Uspeed =   _CustomData1ZW?i.customData1.z:_Mask_Uspeed*_Time.y; 
                  _Mask_Vspeed =   _CustomData1ZW?i.customData1.w:_Mask_Vspeed*_Time.y; 
                float4 maskMap = tex2D(_MaskTex, TRANSFORM_TEX(RotateUV(i.uv,_MaskTexAngle), _MaskTex)+float2(_Mask_Uspeed,_Mask_Vspeed));
                  col = col*(_MaskTex_RA?maskMap.a:maskMap.r);

                 #if defined(USE_DISSOLVE)
                float dissolveClip = tex2D(_DissolveTex, TRANSFORM_TEX(i.uv, _DissolveTex)+float2(_Dissolve_Uspeed,_Dissolve_Vspeed)*_Time.y).r;
                _DissolveValue = _CustomData2X?i.customData2.x:_DissolveValue;
               // 
                 #if defined(SOFTA_DISSOLVE)
                    float clempResult00 = clamp((dissolveClip.x+1.0)-(2.0*_DissolveValue),0.0,1.0);
                    float smoothstepResult00 = smoothstep(0.0,(1.0-_SoftaDissolve),clempResult00);
                    if(_BlendType<0.5){
                     col.rgb *= smoothstepResult00;
                     }else{
                      col.a *= smoothstepResult00;
                    }
                 
                    float dissolveLineSource = _DissolveMainTexON>0.5? col.x:smoothstepResult00; 
                    float4 dissolveLine = (step(dissolveLineSource,0.85)-step((dissolveLineSource+_LineWidth),0.85))*_DissolveColor;
                    col.rgb += dissolveLine.rgb;
                #else
                 clip(dissolveClip-_DissolveValue);
                #endif
                #endif
              

                //软粒子
                #ifdef _SOFT_PARTICLE_ON
                float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                col *=saturate((sceneZ-partZ)/_Soft_Particle);
                #endif

                #ifdef _FRESNE_ON
                float fresnel = pow( 1-saturate(dot(normalize(i.N),normalize(i.V))),_FresnelIndensity)*_FresnelScale+_FresnelBase;
                col=lerp( col,_FresnelCol,fresnel*_FresnelCol.a*isFrontFace);
                #endif
                _Alpha*=i.vertexColor.a*_Alpha_Intensity;
               
                half4 _a = _BlendType? half4(1,1,1,_Alpha):half4(_Alpha,_Alpha,_Alpha,1);
                col*=_a;
                col.a = saturate( col.a);

                 float temp = max(col.r ,col.g);
                 temp = max(temp,col.b);

                 col.w = _BloomFactor?clamp(col.w *temp * _BloomFactor, 0, 1):clamp(col.w * _BloomFactor, 0, 1);

                return col;
            }
            ENDCG
        }

         Pass
         //扭曲Shader
        {
            Tags { "LightMode" = "Grab" "Queue"="Transparent" }
	        Blend SrcAlpha OneMinusSrcAlpha
            Cull Off Lighting Off ZWrite Off ZTest LEqual
            CGPROGRAM
            #pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float4 texcoord: TEXCOORD0;
                 float4 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvmain : TEXCOORD1;
				fixed4 color : COLOR;
			};

			float _HeatForce;
			float _HeatTime;
			
			float4 _NoiseTex_ST;
			sampler2D _NoiseTex;
			sampler2D _MaskTex;
            float4 _MaskTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;
				o.uvmain = TRANSFORM_TEX( v.texcoord.xy, _MaskTex );
				o.color  = v.color;
				return o;
			}

			 sampler2D _CameraColorMap;

			half4 frag( v2f i ) : COLOR
			{

				//noise effect
				half4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz*_HeatTime);
				half4 offsetColor2 = tex2D(_NoiseTex, i.uvmain - _Time.yx*_HeatTime);
				i.uvgrab.x += ((offsetColor1.r + offsetColor1.r) - 1) * (_HeatForce *i.color.a);
				i.uvgrab.y += ((offsetColor2.g + offsetColor2.g) - 1) * (_HeatForce *i.color.a);
	

				half4 col = tex2Dproj(_CameraColorMap, UNITY_PROJ_COORD(i.uvgrab));
				//improved, let the alpha always be 1.
				col.a = 1.0f;
				half4 tint = tex2D( _MaskTex, i.uvmain);
				tint.r = 1.0f;
				tint.g = 1.0f;
				tint.b = 1.0f;
               
				return col*tint;
			}
            ENDCG
        }
         Pass
        {
            Name "EfGeometry"
            Tags{"LightMode" = "EfGeometry"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                //float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

           // sampler2D _MainTex;
           // float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
              //  o.uv = TRANSFORM_TEX(v.uv, _MainTex);
               
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                //fixed4 col = tex2D(_MainTex, i.uv);

                return 0.0;
            }
            ENDCG
        }

    }
    CustomEditor "ShaderEffectEditor"
}
