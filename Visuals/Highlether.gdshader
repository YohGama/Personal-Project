shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);  // Outline color
uniform float outline_width : hint_range(0, 10) = 2.0;  // Outline width
uniform int pattern : hint_range(0, 2) = 0;             // Outline pattern (diamond, circle, square)
uniform bool inside = false;                            // Inside or outside the shape
uniform bool add_margins = true;                        // Only useful when inside is false

uniform float darkness_factor : hint_range(0.0, 1.0) = 0.5; // Darkness factor for sprite darkening

void vertex() {
    if (add_margins) {
        VERTEX += (UV * 2.0 - 1.0) * outline_width; // Expand vertex positions to apply outline width
    }
}

// Function to check if a neighboring pixel is of a different color (for outline detection)
bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
    for (float i = -ceil(outline_width); i <= ceil(outline_width); i++) {
        float x = abs(i) > outline_width ? outline_width * sign(i) : i;
        float offset;

        if (pattern == 0) {
            offset = outline_width - abs(x); // Diamond pattern
        } else if (pattern == 1) {
            offset = floor(sqrt(pow(outline_width + 0.5, 2) - x * x)); // Circle pattern
        } else if (pattern == 2) {
            offset = outline_width; // Square pattern
        }

        for (float j = -ceil(offset); j <= ceil(offset); j++) {
            float y = abs(j) > offset ? offset * sign(j) : j;
            vec2 xy = uv + texture_pixel_size * vec2(x, y);

            // Check if the neighboring pixel is transparent or outside the boundaries
            if ((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a <= 0.0) == inside) {
                return true;
            }
        }
    }

    return false;
}

void fragment() {
    vec2 uv = UV;
    vec4 original_color = texture(TEXTURE, uv); // Get the original color of the pixel

    // Apply the outline effect if necessary
    if (add_margins) {
        vec2 texture_pixel_size = vec2(1.0) / (vec2(1.0) / TEXTURE_PIXEL_SIZE + vec2(outline_width * 2.0));

        uv = (uv - texture_pixel_size * outline_width) * TEXTURE_PIXEL_SIZE / texture_pixel_size;

        if (uv != clamp(uv, vec2(0.0), vec2(1.0))) {
            COLOR.a = 0.0; // Transparent on the border
        } else {
            COLOR = texture(TEXTURE, uv); // Get the color from the texture
        }
    } else {
        COLOR = original_color; // Directly use the original texture color
    }

    // Apply outline color if it is detected as part of the outline area
    if ((COLOR.a > 0.0) == inside && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
        COLOR.rgb = inside ? mix(COLOR.rgb, outline_color.rgb, outline_color.a) : outline_color.rgb;
        COLOR.a += (1.0 - COLOR.a) * outline_color.a;
    }

    // Apply the darkness effect only on the sprite, not the outline
    if (COLOR.a > 0.0 && COLOR.rgb != outline_color.rgb) {
        vec4 sprite_color = original_color; // Get the sprite (texture) color
        sprite_color.rgb *= 1.0 - darkness_factor; // Darken the sprite color
        COLOR = sprite_color; // Apply the darkened sprite color
    }
}
