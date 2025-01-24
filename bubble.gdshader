shader_type spatial;

uniform float iridescence_strength : hint_range(0.0, 1.0) = 0.8;
uniform vec3 bubble_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float transparency : hint_range(0.0, 1.0) = 0.5;

// Habilitar transparência e controlar como o depth buffer é usado
render_mode blend_mix, depth_prepass_alpha, cull_back;


void fragment() {
    vec3 base_color = bubble_color;

    // Direção da visão
    vec3 view_dir = normalize(VIEW);

    // Fresnel
    float fresnel = pow(1.0 - dot(view_dir, NORMAL), 3.0);

    // Iridescência
    float iridescence = sin(TIME * 5.0 + NORMAL.x * 10.0) * 0.5 + 0.5;
    iridescence *= iridescence_strength;

    // Combinar cor base e iridescência
    vec3 final_color = mix(base_color, vec3(iridescence, iridescence, 1.0), iridescence);

    ALBEDO = final_color;
    ALPHA = transparency * fresnel;
}
