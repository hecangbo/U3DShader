Shader "HCB/example/chapter6/SpecularVertexLevel" {
	Properties{
		_Diffuse("Diffuse",Color)=(1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8,256)) = 20
	}
	SubShader{
		Pass{
			Tags{"LightMode"= "ForWardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			fixed _Gloss;

			struct a2v{
				fixed4 vertex:POSITION;
				fixed3 normal:NORMAL;
			};
			struct v2f{
				fixed4 pos:SV_POSITION;
				fixed3 color:TEXCOORD0;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(mul(v.normal, (fixed3x3)_World2Object));
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(_Object2World, v.vertex).xyz);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)),_Gloss);

				o.color = ambient + diffuse + specular;
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				return fixed4(i.color, 1.0);
			}

			ENDCG
		}
	}
	FallBack "Specular"
}
