Shader "HCB/example/chapter6/SpecularBlinnPhong" {
	Properties{
		_Diffuse("Diffuse",Color)=(1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
	SubShader{
		Pass{
			Tags{"LightMode" = "ForwardBase"}
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
				fixed3 worldNormal:TEXCOORD0;
				fixed3 worldPos:TEXCOORD1;
			};

			v2f vert(a2v v){
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = mul(v.normal ,(fixed3x3)_World2Object);
				o.worldPos= mul(_Object2World, v.vertex).xyz;
				return o;
			}

			fixed4 frag(v2f i):SV_Target{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				//Get the view direction in world space
				fixed3 viewDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
				//Get the half direction in world space
				fixed3 halfDir = normalize(worldLight + viewDir);

				fixed3 specular = _LightColor0.rgb * _Specular * pow(saturate(dot(worldNormal, halfDir)), _Gloss);
				return fixed4(ambient+diffuse + specular, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
