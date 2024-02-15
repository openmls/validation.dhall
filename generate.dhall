let Prelude = ./prelude.dhall

let Types = ./types.dhall

let CheckSets = ./checksets.dhall

let Html = ./html.dhall

let XML = Prelude.XML

let checkSetHtmls =
      Prelude.List.map Types.CheckSet XML.Type Html.CheckSet/table CheckSets

let page = Html.outerTemplate "OpenMLS validation status" checkSetHtmls

in  "<!DOCTYPE html>" ++ XML.render page
