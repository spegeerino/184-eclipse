Shader "Unlit/NoiseShader"
{
	Properties
	{
		_Freq ("Frequency", Float) = 1
		_Speed ("Speed", Float) = 1
	}

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // include file that contains UnityObjectToWorldNormal helper function
            #include "UnityCG.cginc"
			// include noiseSimplex algorithm from https://forum.unity.com/threads/2d-3d-4d-optimised-perlin-noise-cg-hlsl-library-cginc.218372/
			#include "noiseSimplex.cginc"

			uniform float
				_Freq,
				_Speed
			;

            struct v2f {
                // we'll output world space normal as one of regular ("texcoord") interpolators
                float4 pos : SV_POSITION;
				float3 srcPos : TEXCOORD0;
            };

            // vertex shader: takes object space normal as input too
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);

				o.srcPos = mul(unity_ObjectToWorld, vertex).xyz;
				o.srcPos *= _Freq;
				o.srcPos.y += _Time.y * _Speed;

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				float ns = snoise(i.srcPos) / 2 + 0.5f;
				return float4(ns, ns, ns, 1.0f);
                fixed4 c = 0;
            }
            ENDCG
        }
    }
}

