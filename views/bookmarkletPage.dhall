let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e
let XML = Prelude.XML

let Types = ../types.dhall

let Css = ../utils/css.dhall
let Html = ../utils/html.dhall

let checksets = ../checksets.dhall

let Check/fragments = \(check : Types.Check) -> check.desc.rfcFragments

let CheckSet/fragments =
      \(checkSet : Types.CheckSet) ->
        Prelude.List.foldLeft
            Types.Check
            checkSet.checks
            (List Text)
            (\(acc : List Text) -> \(cur : Types.Check) -> acc # Check/fragments cur)
            ([]: List Text)

let fragments = Prelude.List.concatMap Types.CheckSet Text CheckSet/fragments checksets

let cssSelectors =
      Prelude.List.map
        Text
        Css.IdSelector
        (\(fragment : Text) -> { id = fragment })
        fragments

let cssProperties = [ Css.Property/highlight ]

let cssRule
    : Css.IdSelectorsRule
    = { selectors = cssSelectors, properties = cssProperties }

let bookmarklet = Css.IdSelectorsRule/bookmarklet cssRule

let linkElem =
      XML.element
        { name = "a"
        , attributes = [ XML.attribute "href" bookmarklet ]
        , content = [ XML.rawText "✨ Highlight MLS RFC" ]
        }

let label = XML.rawText "Drag this to your bookmarks bar:"

let page=  Html.outerTemplate "Bookmarklet page" [ label, linkElem ]
in  "<!DOCTYPE html>" ++ XML.render page
