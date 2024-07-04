let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let types = ../types.dhall

let XML = Prelude.XML

let Url/link
    : Text -> types.Url -> XML.Type
    = \(linkText : Text) ->
      \(url : types.Url) ->
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
    : types.RfcRef -> XML.Type
    = \(ref : types.RfcRef) ->
        XML/asUl
          "rfcref-links"
          ( Prelude.List.map
              types.Url
              XML.Type
              (Url/link "link")
              (types.RfcRef/urls ref)
          )

let CodeRefs/asUl
    : Text -> types.CodeRefs -> XML.Type
    = \(name : Text) ->
      \(ref : types.CodeRefs) ->
        XML/asUl
          name
          ( Prelude.List.map
              types.CodeRef
              XML.Type
              ( \(codeRef : types.CodeRef) ->
                  XML.element
                    { name = "a"
                    , attributes = [ XML.attribute "href" codeRef.url.url ]
                    , content = [ XML.text codeRef.modPath ]
                    }
              )
              ref.refs
          )

let Check/tableRow
    : types.Check -> XML.Type
    = \(check : types.Check) ->
        let br =
              XML.element
                { name = "br"
                , attributes = XML.emptyAttributes
                , content = [] : List XML.Type
                }

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
                , content = [ XML.text (types.Status/show check.status) ]
                }

        let notesUl =
              if    Prelude.List.null Text check.notes.notes
              then  [ XML.text "no notes.", br ]
              else  [ XML.text "notes:"
                    , XML/asUl
                        "notes"
                        ( Prelude.List.map
                            Text
                            XML.Type
                            XML.text
                            check.notes.notes
                        )
                    ]

        let implsUl =
              if    Prelude.List.null types.CodeRef check.code.refs
              then  [ XML.text "no refs to code.", br ]
              else  [ XML.text "code refs:", CodeRefs/asUl "impls" check.code ]

        let testsUl =
              if    Prelude.List.null types.CodeRef check.test.refs
              then  [ XML.text "no refs to tests.", br ]
              else  [ XML.text "test refs:", CodeRefs/asUl "test" check.test ]

        let notesCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = notesUl # implsUl # testsUl
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
                , content = [ XML.text "notes & code refs" ]
                }
            ]
        )

let CheckSet/table
    : types.CheckSet -> XML.Type
    = \(checkSet : types.CheckSet) ->
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
                          types.Check
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
                  , XML.element
                      { name = "style"
                      , attributes = [ XML.attribute "type" "text/css" ]
                      , content = [ XML.rawText ../assets/axist.css as Text ]
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
