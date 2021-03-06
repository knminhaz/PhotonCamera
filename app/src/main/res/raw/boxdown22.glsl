#version 300 es
precision mediump float;
precision mediump sampler2D;
uniform sampler2D InputBuffer;
uniform int CfaPattern;
uniform int yOffset;
out vec4 Output;
vec2 firstdiag(in ivec2 xy){
   return vec2(texelFetch(InputBuffer, (xy), 0).x,texelFetch(InputBuffer, (xy+ivec2(1,1)), 0).x);
}
vec2 seconddiag(in ivec2 xy){
    return vec2(texelFetch(InputBuffer, (xy+ivec2(0,1)), 0).x,texelFetch(InputBuffer, (xy+ivec2(1,0)), 0).x);
}
void main() {
    ivec2 xy = ivec2(gl_FragCoord.xy);
    xy+=ivec2(0,yOffset);
    xy*=2;
    vec4 outp;
    if(CfaPattern == 1 || CfaPattern == 2) {
        outp =vec4(seconddiag(xy).rg,(firstdiag(xy).r+firstdiag(xy).g)/2.0,1.0);
    } else {
        outp =vec4(firstdiag(xy).rg,(seconddiag(xy).r+seconddiag(xy).g)/2.0,1.0);
    }
    outp.a = outp.r+outp.g+outp.b;
    outp.rgb/=outp.a;
    Output = outp;
}
