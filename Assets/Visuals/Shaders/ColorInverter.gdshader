shader_type canvas_item;

// Control the darkness factor; higher values make it darker
uniform float darkness_factor : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 color = texture(TEXTURE, UV);        // Get the original color of the pixel
    color.rgb *= 1.0 - darkness_factor;       // Reduce brightness based on darkness_factor
    COLOR = color;                            // Output the modified color
}
