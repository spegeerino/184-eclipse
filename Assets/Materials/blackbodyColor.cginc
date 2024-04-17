#ifndef BLACKBODY_COLOR
#define BLACKBODY_COLOR
#endif

/* A helper function to find the color of blackbody radiation depending on temperature. */

float blackbody_color(float4 temperature) {
    float u = (temperature - 800.0) / (29200.0);
    sampler1D tempTex
    float3 color = tex1d()
	float total = 0.0;
	float maxAmplitude = 0.0;
	float amplitude = 1.0;

	for(int i = 0; i < octaves; i++) {
		total += snoise(position * frequency) * amplitude;
		frequency *= 2;
		maxAmplitude += amplitude;
		amplitude *= persistence;
	}

	return total / maxAmplitude;
}