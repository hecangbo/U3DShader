﻿Shader "HCB/example/chapter6/DiffuseHalfLambert" {
	Properties{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader{
		Pass{
			Tags{ "LightMode" = "ForwardBase" }
			// LOD 200

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Diffuse;
			struct a2v {
				float4 vertex: POSITION;
				float3 normal: NORMAL;
			};
			struct v2f {
				float4 pos: SV_POSITION;
				fixed3 worldNormal : TEXCOORD;
			};
			v2f vert(a2v v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)_World2Object);
				return o;
			}
			fixed4 frag(v2f i) :SV_TARGET{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//Compute diffuse term
				fixed halfLambert =0.5 * dot(worldNormal, worldLightDir) + 0.5;
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;
				fixed3 color = ambient + diffuse;
			return fixed4(color, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
