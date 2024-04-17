Shader "Unlit/CoronaShader"
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
			#pragma exclude_renderers d3d11
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

				float3 pos = mul(unity_ObjectToWorld, vertex).xyz;
				float t = _Time.y * _Speed;

				o.srcPos = float4(pos, t);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
				float dist = length(i.srcPos.xyz)/100;
				return float4(dist, dist, dist, 1.0f);
            }
            ENDCG
        }
    }
}
