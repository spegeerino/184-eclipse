Shader "Unlit/CoronaShader"
{
	Properties
	{
		_Freq ("Frequency", Float) = 0.1
		_Strength ("Strength", Float) = 0.4
		_Speed ("Speed", Float) = 2
		_Size ("Size", Float) = 0.1
    _Thickness ("Thickness", Float) = 1
    _Exponent ("Exponent", Float) = 8
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
				_Strength,
				_Size,
        _Thickness,
        _Exponent
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

				float3 pos = mul(unity_ObjectToWorld, vertex).xyz;
				float t = _Time.y;

				o.srcPos = float4(pos, t);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
        // time minus distance from center makes light appear to move outwards
        float t = (i.srcPos.w - length(i.srcPos.xyz)) * _Speed; 
        // new conceptual idea
        // sample from the noise function to determine positive/negative magnetic field
        // helmet streamers originate from boundaries between magnetic polarity;
        // send streamers from places with noise close to 0 (can tweak threshold to increase/decrease number of streamers) 
        // float threshold = 0.01;
        // float s_freq = 2;
        // float s_int = 100;
        // float3 nDist = normalize(i.srcPos.xyz);
        // float noise_field = snoise(s_freq * float4((nDist + 10000.0), i.srcPos.w));
        // float streamer_b = (threshold - abs(noise_field)) * s_int;

        // produces lines emanating from sun
        float sx = snoise(_Freq * float4(i.srcPos.xyz, t));
        float sy = snoise(_Freq * float4((i.srcPos.xyz + 2000.0), t));
        float sz = snoise(_Freq * float4((i.srcPos.xyz + 4000.0), t));
        float3 jitter = float3(sx,sy,sz) * 0.12; 
        float3 nJitterDist = normalize(i.srcPos.xyz + jitter);
        float3 position = i.srcPos.xyz + snoise(float4(nJitterDist, t * _Thickness)/_Thickness) * .2;
        float dist = length(position + jitter * 2);
        float b = (_Size/(pow(dist, _Exponent) - pow(0.1, _Exponent))) * _Strength;
        float unExposure = 3.0;
        float unGamma = 2.0;
        b = 1.0 - exp(b * -unExposure); // HDR exposure
        b = pow(b, unGamma);
				return float4(b,b,b, 0.99);
            }
            ENDCG
        }
    }
}
