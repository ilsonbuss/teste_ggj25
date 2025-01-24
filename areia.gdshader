shader_type spatial;

uniform sampler2D base_texture; // Textura base da areia
uniform sampler2D normal_map : hint_normal;  // Normal map para a superfície
uniform float grain_intensity = 0.5;        // Intensidade do brilho dos grãos
uniform vec3 light_color = vec3(1.0, 0.9, 0.6); // Cor do brilho (simulando o Sol)

render_mode depth_draw_opaque;

void fragment() {
    // Coordenadas UV para texturização
    vec2 uv = UV;

    // Textura base da areia
    vec3 base_color = texture(base_texture, uv).rgb;

    // Normal map para detalhes da superfície
    vec3 normal = texture(normal_map, uv).rgb * 2.0 - 1.0;
    normal = normalize(normal);

    // Calcula a direção da luz (assumindo direção fixa para simplicidade)
    vec3 light_dir = normalize(vec3(0.3, 1.0, 0.3));

    // Efeito de grãos de areia (ruído baseado em UV)
    float grain = fract(sin(dot(uv.xy * 50.0, vec2(12.9898, 78.233))) * 43758.5453);
    grain = pow(grain, 3.0) * grain_intensity;

    // Simula a interação da luz com os grãos de areia
    float light_intensity = max(dot(normal, light_dir), 0.0) + grain;
    vec3 final_color = base_color * light_intensity * light_color;

    // Definir a cor final e o alfa
    ALBEDO = final_color;
    ALPHA = 1.0;
}
