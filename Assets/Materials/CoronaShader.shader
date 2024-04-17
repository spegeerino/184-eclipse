Shader "Unlit/CoronaShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "DisableBatching" = "True" }

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

/*
			v2f vert (float4 vertex : POSITION) {
				v2f o;
                o.pos = UnityObjectToClipPos(vertex);

				float3 pos = mul(unity_ObjectToWorld, vertex).xyz * _Freq;
				float t = _Time.y * _Speed;

			}
			*/

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv.xy;

				// billboard mesh towards camera
				float3 vpos = mul((float3x3)unity_ObjectToWorld, v.vertex.xyz);
				float4 worldCoord = float4(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23, 1);
				float4 viewPos = mul(UNITY_MATRIX_V, worldCoord) + float4(vpos, 0);
				float4 outPos = mul(UNITY_MATRIX_P, viewPos);

				o.pos = outPos;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float dist = length(i.pos.xyz) / 500;
				//return float4(dist, dist, dist, 1.0);
				float brightness = (1.0 / (dist * dist) - 0.1) * 0.7;
				return float4(brightness, brightness, brightness, 1.0);
			}
			ENDCG
		}
	}
}
