let Prelude = https://prelude.dhall-lang.org/v22.0.0/package.dhall

let Types = ./types.dhall

let XML = Prelude.XML

let Url/link
    : Text -> Types.Url -> XML.Type
    = \(linkText : Text) ->
      \(url : Types.Url) ->
        XML.element
          { name = "a"
          , attributes = [ XML.attribute "href" url.url ]
          , content = [ XML.text linkText ]
          }

let XML/wrap
    : Text -> XML.Type -> XML.Type
    = \(elementName : Text) ->
      \(innerElement : XML.Type) ->
        XML.element
          { name = elementName
          , attributes = XML.emptyAttributes
          , content = [ innerElement ]
          }

let XML/asUl
    : Text -> List XML.Type -> XML.Type
    = \(className : Text) ->
      \(items : List XML.Type) ->
        XML.element
          { name = "ul"
          , attributes = [ XML.attribute "class" className ]
          , content = Prelude.List.map XML.Type XML.Type (XML/wrap "li") items
          }

let RfcRef/links
    : Types.RfcRef -> XML.Type
    = \(ref : Types.RfcRef) ->
        XML/asUl
          "rfcref-links"
          ( Prelude.List.map
              Types.Url
              XML.Type
              (Url/link "link")
              (Types.RfcRef/urls ref)
          )

let Check/tableRow
    : Types.Check -> XML.Type
    = \(check : Types.Check) ->
        let idCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ XML.text (Natural/show check.id) ]
                }

        let descCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ XML.text check.desc.text ]
                }

        let rfcLinks = RfcRef/links check.desc

        let rfcLinksCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ rfcLinks ]
                }

        in  XML.element
              { name = "tr"
              , attributes = [ XML.attribute "id" (Natural/show check.id) ]
              , content = [ idCell, descCell, rfcLinksCell ]
              }

let CheckSet/table
    : Types.CheckSet -> XML.Type
    = \(checkSet : Types.CheckSet) ->
        XML.element
          { name = "div"
          , attributes = XML.emptyAttributes
          , content =
            [ XML.element
                { name = "h2"
                , attributes = XML.emptyAttributes
                , content = [ XML.text checkSet.name ]
                }
            , XML.element
                { name = "p"
                , attributes = XML.emptyAttributes
                , content =
                  [ XML.rawText checkSet.desc.text, RfcRef/links checkSet.desc ]
                }
            , XML.element
                { name = "table"
                , attributes = XML.emptyAttributes
                , content =
                    Prelude.List.map
                      Types.Check
                      XML.Type
                      Check/tableRow
                      checkSet.checks
                }
            ]
          }

let outerTemplate
    : Text -> List XML.Type -> XML.Type
    = \(title : Text) ->
      \(body : List XML.Type) ->
        XML.element
          { name = "html"
          , attributes = XML.emptyAttributes
          , content =
            [ XML.element
                { name = "head"
                , attributes = XML.emptyAttributes
                , content =
                  [ XML.element
                      { name = "title"
                      , attributes = XML.emptyAttributes
                      , content = [ XML.text title ]
                      }
                  ]
                }
            , XML.element
                { name = "body"
                , attributes = XML.emptyAttributes
                , content = body
                }
            ]
          }

in  { Check/tableRow, CheckSet/table, outerTemplate }
