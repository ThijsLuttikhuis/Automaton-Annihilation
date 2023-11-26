shader_type canvas_item;

uniform float outline_width = 2.0;
uniform bool ghost_greyout = false;
uniform vec4 outline_color : source_color;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	
	if (ghost_greyout) {
		COLOR = texture(TEXTURE, UV);
    	float avg = (COLOR.r + COLOR.g + COLOR.b) / 3.0;
		float alpha = min(COLOR.a, 0.3);
    	COLOR.rgba = vec4(avg, avg, avg, alpha);
	}
	else {
		vec2 ps = TEXTURE_PIXEL_SIZE;
		float a;
		float maxa = col.a;
		float mina = col.a;

		a = texture(TEXTURE, UV + vec2(0.0, -outline_width) * ps).a;
		maxa = max(a, maxa);
		mina = min(a, mina);

		a = texture(TEXTURE, UV + vec2(0.0, outline_width) * ps).a;
		maxa = max(a, maxa);
		mina = min(a, mina);

		a = texture(TEXTURE, UV + vec2(-outline_width, 0.0) * ps).a;
		maxa = max(a, maxa);
		mina = min(a, mina);

		a = texture(TEXTURE, UV + vec2(outline_width, 0.0) * ps).a;
		maxa = max(a, maxa);
		mina = min(a, mina);

		COLOR = mix(col, outline_color, maxa - mina);
	}
}