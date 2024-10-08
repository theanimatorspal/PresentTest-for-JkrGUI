require "Present.Present"
require "ElementLibrary.Fancy.Fancy"

Pr = DefaultPresentation()

Pr:insert({
          Frame {},
          Frame {
                    gltf = FancyGLTF {
                              filename = "res/models/CesiumManBlend/CesiumMan.gltf",
                              skinning = true,
                              animation = vec2(0, 0.0),
                              r = vec4(0, 1, 0, 180),
                    },
          },

          Frame {
                    gltf = FancyGLTF {
                              r = vec4(0, 1, 0, 180),
                              d = vec3(2, 2, 2),
                              skinning = true,
                              animation = vec2(0, 10)
                    },
          }
}
)

Presentation(Pr)
