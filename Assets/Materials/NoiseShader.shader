Shader "Unlit/NoiseShader"
{
	Properties
	{
		_Freq ("Frequency", Float) = 8
		_ssFreq ("Sunspot Frequency", Float) = 0.00001
		_Speed ("Speed", Float) = 0.05
		_Radius ("Radius", Float) = 10000
	}

    SubShader
    {
        Pass
        {
            CGPROGRAM
			// Upgrade NOTE: excluded shader from DX11; has structs without semantics (struct v2f members pos_t)
			// #pragma exclude_renderers d3d11
            #pragma vertex vert
            #pragma fragment frag
            // include file that contains UnityObjectToWorldNormal helper function
            #include "UnityCG.cginc"
			// include noiseSimplex algorithm from https://forum.unity.com/threads/2d-3d-4d-optimised-perlin-noise-cg-hlsl-library-cginc.218372/
			#include "noiseSimplex.cginc"
			#include "fractalNoise.cginc"

			uniform float
				_Freq,
				_Speed,
				_ssFreq,
				_Radius
			;

            struct v2f {
                // we'll output world space normal as one of regular ("texcoord") interpolators
                float4 pos : SV_POSITION;
				float4 srcPos : TEXCOORD0;
            };

            // vertex shader: takes object space normal as input too
            v2f vert (float4 vertex : POSITION, float3 normal : NORMAL)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);

				float3 pos = mul(unity_ObjectToWorld, vertex).xyz * _Freq;
				float t = _Time.y * _Speed;

				o.srcPos = float4(pos, t);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				//float4 pos_t = float4(i.pos.xyz, i.srcPos.y);
				float n = (fractal_noise(i.srcPos , 5, _Freq, 0.7) + 1.0) * 0.5;

				// Get worldspace position
				float sunspotSpeedModifier = 0.05;
				float4 sPosition = i.srcPos * _Radius;
				sPosition.w *= sunspotSpeedModifier;

				// Sunspots
				float s = 0.3;
				float t1 = snoise(sPosition * _ssFreq) - s;
				float t2 = snoise((sPosition + _Radius) * _ssFreq) - s;
				//float ss = (max(t1, 0.0) * max(t2, 0.0)) * 2.0;

				// Accumulate total noise
				float total = n;

				return float4(total, total, total, 1.0f);
            }
            ENDCG
        }
    }
}

