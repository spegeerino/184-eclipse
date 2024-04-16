#ifndef FRACTAL_NOISE
#define FRACTAL_NOISE
#endif

/* A basic implementation of 4D fractal noise, where the 4th coordinate varies according to time. */

float fractal_noise(float4 position, int octaves, float frequency, float persistence) {
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
