let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let Types = ../types.dhall

let CheckSets = ../checksets.dhall

let Html = ../utils/html.dhall

let XML = Prelude.XML

let checkSetHtmls =
      Prelude.List.map Types.CheckSet XML.Type Html.CheckSet/table CheckSets

let footer =
      XML.element
        { name = "footer"
        , attributes = XML.emptyAttributes
        , content =
          [ XML.element
              { name = "a"
              , attributes = [ XML.attribute "href" "bookmarklet.html" ]
              , content = [ XML.rawText "highlighting bookmarklet page" ]
              }
          ]
        }

let page =
      Html.outerTemplate
        "OpenMLS validation status"
        (checkSetHtmls # [ footer ])

in  "<!DOCTYPE html>" ++ XML.render page
