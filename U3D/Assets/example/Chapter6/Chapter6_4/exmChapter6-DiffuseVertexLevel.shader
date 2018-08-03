Shader "HCB/example/chapter6/DiffuseVertexLevel" {
	Properties {
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader {
		Pass{
			Tags { "LightMode"="ForwardBase" }
			// LOD 200
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma enable_d3d11_debug_symbols
			#include "Lighting.cginc"
			fixed4 _Diffuse;
			struct a2v{
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};
			struct v2f{
				float4 pos: SV_POSITION;
				fixed3 color:COLOR;
			};
			v2f vert(a2v v){
				v2f o;
				//Transform the vertex from object space to projection space
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//Transform the normal from object space to world space
				//这个地方不懂，不是需要得到世界坐标系么？为什么使用_World2Object
				fixed3 worldNormal = normalize(mul(v.normal,(float3x3)_World2Object));

				//Get the light direction in world space
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				
				//Compute diffuse term
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				//光照=环境光+漫反射
				o.color = ambient + diffuse;
				return o;
			}
			fixed4 frag(v2f i):SV_TARGET{
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
