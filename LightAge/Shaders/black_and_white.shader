shader_type canvas_item;

uniform float threshold : hint_range(0, 1);

void fragment() {
	COLOR = texture(SCREEN_TEXTURE,SCREEN_UV,10);
	float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
	if(avg<threshold) {
		avg = 0.0;
	} else {
		avg = 1.0;
	}
	COLOR.rgb = vec3(avg);
}