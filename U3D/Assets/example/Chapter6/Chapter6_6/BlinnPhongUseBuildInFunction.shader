Shader "HCB/example/chapter6/BlinnPhongUseBuildInFunction" {
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,256)) = 20
	}
	SubShader{
		Pass{
			Tags{ "LightModel" = "ForwardBase" }
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
				float3 worldNormal : TEXCOORD0;
				float3 worldPos:TEXCOORD1;
			};
			v2f vert(a2v v) {
				v2f o;
				//Transform the vertex from object space to projection space
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				//Transform the normal fram object space to world space
				//o.worldNormal = mul(v.normal, (float3x3)_World2Object);
				//Use the build-in function to compute the normal in world space
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				//Transform the vertex from object space to world space
				o.worldPos = mul(_Object2World, v.vertex).xyz;
				return o;
			}
			fixed4 frag(v2f i) :SV_Target{
				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldNormal = normalize(i.worldNormal);
				//fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//Use the build-in function to compute the light direction in world space
				//Remember to normalize the result
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

				//Compute diffuse term
				fixed diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));
				//Get the reflect direction in world space
				fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

				//Get the view direction in world space
				//fixed3 viewDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz);
				//Use the build-in function to compute the view direction in world space
				//Remember to normalize the result
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				//Get the half direction in world space
				fixed3 halfDir = normalize(worldLightDir + viewDir);
				//Compute specular term
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
				return fixed4(ambient + diffuse + specular, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Specular"
}
