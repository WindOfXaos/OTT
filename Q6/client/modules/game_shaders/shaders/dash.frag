uniform sampler2D u_Tex0;
varying vec2 v_TexCoord;
uniform int u_Direction;

const int North = 0;
const int East = 1;
const int South = 2;
const int West = 3;

float outlineWidth = 0.001;
vec4 outline = vec4(1.0, 0.0, 0.0, 1.0);

vec4 outlineEdges(vec2 texCoord) {
   // Texture to be outlined
   vec4 texture = texture2D(u_Tex0, texCoord);

   // Get the sum of neighbor pixels alpha
   float alphaSum = texture2D(u_Tex0, texCoord + vec2(outlineWidth, 0)).a +
                    texture2D(u_Tex0, texCoord - vec2(outlineWidth, 0)).a +
                    texture2D(u_Tex0, texCoord + vec2(0, outlineWidth)).a +
                    texture2D(u_Tex0, texCoord - vec2(0, outlineWidth)).a;

   // if the sum of neighbor pixels alpha isn't zero and the current pixel 
   // is transparent then it is an edge pixel
   if (texture.a == 0.0 && alphaSum > 0.0) {
       return outline;
   } else {
       return texture;
   }
}

void main() {
    vec2 texCoord = v_TexCoord;

    // Offset for the duplicate trail texture
    vec2 trailOffset;

    // Reversing stretch effect with respect to direction
    // by doing more "fine tuning"
    if (u_Direction == North){
      trailOffset = vec2(0.0, 0.015);
      texCoord.y *= 4.0;
      texCoord.y -= 0.175;
    }
    else if (u_Direction == East) {
      trailOffset = vec2(0.015, 0.0);
      texCoord.x *= 4.0;
      texCoord.x -= 0.77;
    }
    else if (u_Direction == South) {
      trailOffset = vec2(0.0, 0.015);
      texCoord.y *= 4.0;
      texCoord.y -= 0.175;
    }
    else if (u_Direction == West) {
      trailOffset = vec2(0.015, 0.0);
      texCoord.x *= 4.0;
      texCoord.x -= 1.45;
    }

    // Main texture outlined
    vec4 mainTex = outlineEdges(texCoord);

    // Multiple trails with different offsets
    vec4 trailTex[4];
    for (int i = 0; i < 4; i++) {
      trailTex[i] = texture2D(u_Tex0, texCoord + trailOffset * (i - 1));
    }

    // Combine trails with the main texture
    vec4 output = mix(trailTex[0], mainTex, mainTex.a);
    for (int i = 1; i < 4; i++) {
        output = mix(trailTex[i], output, output.a);
    }

    gl_FragColor = output;
}
