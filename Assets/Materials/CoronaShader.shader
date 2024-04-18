Shader "Unlit/CoronaShader"
{
	Properties
	{
		_Freq ("Frequency", Float) = 0.4
		_Strength ("Strength", Float) = 0.2
		_Speed ("Speed", Float) = 0.6
		_Size ("Size", Float) = 0.3
    _Thickness ("Thickness", Float) = 0.17
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
        _Thickness
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
				float t = _Time.y * _Size;

				o.srcPos = float4(pos, t);

                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
        float t = (_Time.y - length(i.srcPos.xyz)) * _Speed;
        float sx = snoise(_Freq * float4(i.srcPos.xyz, t));
        float sy = snoise(_Freq * float4((i.srcPos.xyz + 2000.0), t));
        float sz = snoise(_Freq * float4((i.srcPos.xyz + 4000.0), t));
        float3 jitter = float3(sx,sy,sz) * 0.2; 
        float3 nJitterDist = normalize(i.srcPos.xyz + jitter);
        float3 position = i.srcPos.xyz + snoise(float4(nJitterDist, t * _Thickness)/_Thickness) * .3;
        float dist = length(position + jitter * 2);
        float b = (_Size/(dist * dist) - 0.1) * _Strength;
				return float4(b,b,b, 1.0);
            }
            ENDCG
        }
    }
}
