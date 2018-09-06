Shader "HCB/example/chapter6/HCBSpecularVertexLevel" {
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
	SubShader{
		Pass{
			Tags { "LightMode" = "ForwardBase" }
			//LOD 200

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f {
				float4 pos:SV_POSITION;
				fixed3 color : COLOR;
			};
			v2f vert(a2v v) {
				v2f o;
				//Transform the vertex from object space to projection space
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//Transform the normal fram object space to world space
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)_World2Object));
				//Get the light direction in world space
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				
				//Compute diffuse term
				fixed3 diffuse = _LightColor0.rgb* _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

				//高光反射
				//Get the reflect direction in world space
				//入射方向要求是由光源指向交点处，因此需要对worldLightDir取返后再传给reflect
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
				//Get the view direction in world space
				/*
				*通过_WorldSpaceCameraPos得到世界空间中的摄像机位置，再把顶点位置从模型空间变换到世界空间下，再通过和_WorldSpaceCameraPos相减即可得到世界空间下的视角方向
				*/
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, v.vertex).xyz);
				//Compute specular term
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

				//光照= 环境光+漫反射+高光反射
				o.color = ambient + diffuse + specular;
				return o;
			}
			fixed4 frag(v2f i) :SV_Target{
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
