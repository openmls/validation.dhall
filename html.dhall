let Prelude = ./prelude.dhall

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

let XML/wrapList
    : Text -> List XML.Type -> XML.Type
    = \(elementName : Text) ->
      \(innerElements : List XML.Type) ->
        XML.element
          { name = elementName
          , attributes = XML.emptyAttributes
          , content = innerElements
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

        let rfcLinksCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ RfcRef/links check.desc ]
                }

        let statusCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ XML.text (Types.Status/show check.status) ]
                }

        let notesCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content =
                    Prelude.List.map Text XML.Type XML.text check.notes.notes
                }

        in  XML.element
              { name = "tr"
              , attributes = [ XML.attribute "id" (Natural/show check.id) ]
              , content =
                [ idCell, statusCell, descCell, rfcLinksCell, notesCell ]
              }

let thead =
      XML/wrap
        "thead"
        ( XML/wrapList
            "tr"
            [ XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ XML.text "id" ]
                }
            , XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ XML.text "status" ]
                }
            , XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ XML.text "description" ]
                }
            , XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ XML.text "links" ]
                }
            , XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ XML.text "notes" ]
                }
            ]
        )

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
                { name = "div"
                , attributes = [ XML.attribute "class" "check-set-desc" ]
                , content =
                  [ XML.rawText checkSet.desc.text, RfcRef/links checkSet.desc ]
                }
            , XML.element
                { name = "table"
                , attributes = XML.emptyAttributes
                , content =
                  [ thead
                  , XML/wrapList
                      "tbody"
                      ( Prelude.List.map
                          Types.Check
                          XML.Type
                          Check/tableRow
                          checkSet.checks
                      )
                  ]
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
                  , XML.leaf
                      { name = "link"
                      , attributes =
                        [ XML.attribute "rel" "stylesheet"
                        , XML.attribute "href" "axist.css"
                        ]
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
