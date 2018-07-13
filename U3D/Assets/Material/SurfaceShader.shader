Shader "HCB/Custom/MySurfaceShader" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		[HideInInspector]
		[NoScaleOffset] _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		[Toggle]
		_Invert("Invert?", Float) = 0
		[Enum(One,1,Two,2)] _Num ("Num Enum", Float) = 1
		[PowerSlider(2.0)] _Shin ("Shin", Range (0.01, 1)) = 0.1
		[Space(50)] _Prop ("Prop", Float) = 0
		[Header(Float variable)] _P ("P", Float) = 0
		}
		SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
		float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
		// Albedo comes from a texture tinted by color
		fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
		o.Albedo = c.rgb;
		// Metallic and smoothness come from slider variables
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = c.a;
		}
		ENDCG
		}
		FallBack "Diffuse"
/*
		SubShader {
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			float4 vert(float4 v:POSITION):SV_POSITION{
				return mul(UNITY_MATRIX_MVP, v);
			}
			fixed4 frag():SV_POSITION1{
				return fixed4(1.0, 1.0, 1.0, 1.0);
			}
				ENDCG
		}
	}*/
}
