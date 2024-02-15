let Prelude = https://prelude.dhall-lang.org/v22.0.0/package.dhall
let Types = ./types.dhall
let CheckSets = ./checksets.dhall
let Html = ./html.dhall
let XML = Prelude.XML

let CheckSet/render = \(checkSet: Types.CheckSet) -> XML.render (Html.CheckSet/table checkSet)

let checkSetHtmls = Prelude.List.map Types.CheckSet XML.Type Html.CheckSet/table CheckSets

let page = Html.outerTemplate "OpenMLS validation status" checkSetHtmls

in XML.render page


