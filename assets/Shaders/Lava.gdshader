shader_type canvas_item;
render_mode blend_mix;

uniform float lavaOpacity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D lavaGradient;
uniform sampler2D lavaDistortion : repeat_enable;
uniform float noiseScaleX : hint_range(0.0, 0.2) = 0.01;
uniform float noiseScaleY : hint_range(0.0, 0.2) = 0.01;
uniform float distortionScale = 80.0;
uniform float distortionStrength = 50.0;
uniform float surfaceHeight = 0.0;

varying vec2 world_position;

float screen(float base, float blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}


void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 UV_in_world_space = world_position.xy;
	vec4 distortion = texture(lavaDistortion, vec2(UV_in_world_space.x/distortionScale/5.0 + TIME/100.0, sin(TIME/2.0)/30.0 + UV_in_world_space.y/distortionScale));
	
	
	
	float noise1 = worley(UV_in_world_space + vec2(TIME*1.5, TIME*2.0 + distortion.r*distortionStrength), noiseScaleX, noiseScaleY);
	float noise2 = worley(UV_in_world_space -  vec2(TIME*3.0, distortion.g*distortionStrength), noiseScaleX/1.5 , noiseScaleY/1.5);
	
	
	
	float GradientStrength = clamp(screen(noise1, noise2) - sin(TIME)/15.0, 0, 1);
	
	vec4 finalColor = texture(lavaGradient, vec2(GradientStrength, 0.4));
	
	COLOR = vec4(GradientStrength, GradientStrength, GradientStrength, 1);
	COLOR = finalColor;

	COLOR.a = lavaOpacity + GradientStrength/3.0 + sin(TIME)/8.0;
	
	float heightMaskSignwave = sin(UV_in_world_space.x/20.0 + TIME);
	heightMaskSignwave += sin(UV_in_world_space.x/9.7 - TIME*0.2);
	
	float heightMask = 0.0;
	if (UV_in_world_space.y > surfaceHeight + heightMaskSignwave*3.0) {
		heightMask = 1.0;
	}
	
	
	
	COLOR.a *= heightMask;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
