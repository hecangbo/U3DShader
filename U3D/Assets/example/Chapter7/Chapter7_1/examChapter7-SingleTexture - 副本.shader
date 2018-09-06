Shader "HCB/example/chapter7/HCBSingle Texture" {
	Properties {
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Main Tex", 2D) = "white" {}
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
	SubShader{
		Pass{
			Tags { "LightMode" = "ForwardBase" }
			//LOD 200

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Color;
			sampler2D _MainTex;
			//纹理名_ST声明某个纹理的属性。其中ST是scale与translation的缩写。_MainTex_ST.xy存储的是缩放值，而_MainTex_ST.zw存储的是偏移值
			float4 _MainTex_ST;		
			fixed4 _Specular;
			float _Gloss;
			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 texcoord:TEXCOORD0;
			};
			struct v2f {
				float4 pos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float3 worldPos:TEXCOORD1;
				float2 uv:TEXCOORD2;
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
				
				//o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				//Or just call the build-in function
				o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}
			fixed4 frag(v2f i) :SV_Target{
				fixed3 worldNormal = normalize(i.worldNormal);
				//fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				//Use the build-in function to compute the light direction in world space
				//Remember to normalize the result
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));

				//Use the texture to sample the diffuse color
				fixed3 albedo = tex2D(_MainTex, i.uv).rgb * _Color.rgb;

				//Get ambient term
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;


				//Compute diffuse term
				fixed diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, worldLightDir));
				

				//Get the view direction in world space
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
