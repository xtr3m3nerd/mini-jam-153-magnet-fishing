shader_type canvas_item;

uniform vec4 flashColor : source_color = vec4(1,1,1,1);
uniform float HovState : hint_range(0.0, 1) = 0;
uniform vec4 outlineColHov : source_color = vec4(0,0,0,1);

vec4 lighten(vec4 base, vec4 blend){
	return max(base, blend);
}

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 flashTex = lighten(pixelColor, flashColor);
	vec4 finalPixelCol = mix(pixelColor, flashTex, HovState/2.0);
	
	float outlineMask = (1.0f - pixelColor.r - pixelColor.g - pixelColor.b);
	vec4 outline = vec4(outlineColHov) * vec4 (1,1,1, outlineMask);
	COLOR = vec4(outlineMask, outlineMask, outlineMask, 1);
	COLOR = mix(finalPixelCol, outlineColHov, clamp(outlineMask * HovState, 0, 1));
	COLOR.a *= pixelColor.a;
	
	//COLOR = pixelColor;
}




//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
