shader_type spatial;

uniform float outline_size = 0.02;
uniform vec4 outline_color = vec4(0.0, 0.0, 0.0, 1.0);

void vertex() {
    // Expand the vertex position along the normal to create the outline
    VERTEX += NORMAL * outline_size;
}

void fragment() {
    // Only render the outline color
    ALBEDO = outline_color.rgb;
    ALPHA = outline_color.a;

    // Discard fragments facing the camera (to avoid coloring the original mesh)
    if (dot(NORMAL, (VIEW_MATRIX * vec4(0.0, 0.0, 1.0, 0.0)).xyz) > 0.0) {
        discard;
    }
}
