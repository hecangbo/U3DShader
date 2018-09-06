﻿Shader "HCB/example/chapter11/SequenceAnimation" {
	Properties {
		_Color ("Color", Color) = (1, 1, 1, 1)
		_MainTex("Image Sequence", 2D) = "white" {}
		_HorizontalAmount("Horizontal Amount", Float) = 4
		_VerticalAmount("Vertical Amount", Float) = 4
		_Speed("Speed", Range(1, 100)) = 30
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector" = "True""RenderType" = "Transparent"}
		
		pass {
			Tags {"LightMode" = "ForwardBase"}
			ZWrite  Off
			Blend SrcAlpha OneMinusSrcAlpha 
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			fixed4 _Color; 
			sampler2D _MainTex; 
			float4 _MainTex_ST;
			float _HorizontalAmount; 
			float _VerticalAmount; 
			float _Speed; 

			struct a2v {
				float4 vertex:POSITION; 
				float2 texcoord:TEXCOORD0; 
			}; 
			struct v2f {
				float4 pos:SV_POSITION; 
				float2 uv:TEXCOORD0; 
			};
			v2f vert(a2v v) {
				v2f o; 
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex); 
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex); 
				return o; 
			}
			fixed4 frag (v2f i):SV_Target {
				float time = floor(_Time.y * _Speed); 
				float row = floor(time /_HorizontalAmount); 
				float column = time - row * _HorizontalAmount; 

				half2 uv = i.uv + half2(column,  - row); 
				uv.x /= _HorizontalAmount; 
				uv.y /= _VerticalAmount; 

				fixed4 c = tex2D(_MainTex, uv); 
				c.rgb *= _Color; 
				return c; 
			}
			ENDCG
		}
	}
	FallBack "Transparent/VertexLit"
}
