shader_type canvas_item;
render_mode blend_add;

uniform float scroll_speed = 0.08;
uniform float uvScale = 1.0;
uniform vec4 colorMod = vec4(0.2,0.2,0.0,1.0);
//uniform vec2 texture_scroll = vec2(1.0, 0.0);

void fragment()
{
    vec2 uv = UV;
    uv.x = UV.x * 1.0 + pow(abs(sin(3.14 * UV.x/2.0)),2.0);
    
    //COLOR = texture(TEXTURE, uv + texture_scroll);
    COLOR = texture(TEXTURE, (uv * uvScale) + (scroll_speed * TIME));
	COLOR = COLOR * colorMod;
}