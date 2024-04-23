attribute highp vec2 a_TexCoord;
attribute highp vec2 a_Vertex;
uniform highp mat3 u_TextureMatrix;
uniform highp mat3 u_TransformMatrix;
uniform highp mat3 u_ProjectionMatrix;
varying highp vec2 v_TexCoord;

uniform int u_Direction;

const int North = 0;
const int East = 1;
const int South = 2;
const int West = 3;

mat3 getScaleByDirection() {
  float scaleFactor = 4;

  // Stretching drawing quad with respect to direction to give space for duplicates(trails)
  // by doing some fine tuning -nothing fine here tbh- to reach the desired state
  if (u_Direction == North){
    a_Vertex.y += scaleFactor * scaleFactor;
    return mat3(
        1.0, 0.0, 0.0,
        0.0, scaleFactor, 0.0,
        0.0, 0.0, 1.0
    );
  }
  else if (u_Direction == East) {
    a_Vertex.x += scaleFactor;
    return mat3(
        scaleFactor, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
    );
  }
  else if (u_Direction == South) {
    a_Vertex.y += scaleFactor;
    return mat3(
        1.0, 0.0, 0.0,
        0.0, scaleFactor, 0.0,
        0.0, 0.0, 1.0
    );
  }
  else if (u_Direction == West) {
    a_Vertex.x += scaleFactor * scaleFactor;
    return mat3(
        scaleFactor, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0
    );
  }
}

highp vec4 calculatePosition() {
    // Apply scaling matrix to sctretch the drawing quad vertically
    // and render multiple trails in the fragment shader
    mat3 scale = getScaleByDirection();

    return vec4(u_ProjectionMatrix * u_TransformMatrix * vec3(a_Vertex.xy, 1.0) * scale, 1.0);
}

void main()
{
    gl_Position = calculatePosition();
    v_TexCoord = (u_TextureMatrix * vec3(a_TexCoord,1.0)).xy;
}
