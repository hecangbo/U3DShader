Shader "HCB/example/chapter6/DiffuseVertexLevel" {
	Properties{
		_Diffuse("Diffuse",Color)= (1,1,1,1)
	}
	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Diffuse;
			struct a2v{
				float4 vertex:POSITION;
				float3 normal:NORMAL;
			};
			struct v2f{
				float4 pos:SV_POSITION;
				fixed3 color:TEXCOORD0;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				float3 worldNormal = normalize(mul(v.normal, (float3x3)_World2Object));
				float3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				float3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				o.color = ambient + diffuse;
				return o;
			}

			fixed4 frag(v2f i):SV_TARGET
			{
				return fixed4(i.color,1.0); 
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
}
