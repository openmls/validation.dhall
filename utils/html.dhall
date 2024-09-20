let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let Types = ../types.dhall

let XML = Prelude.XML

let Natural/digits
    : Natural -> Natural
    = \(num : Natural) ->
        if    Prelude.Natural.lessThan 10000 num
        then  5
        else  if Prelude.Natural.lessThan 1000 num
        then  4
        else  if Prelude.Natural.lessThan 100 num
        then  3
        else  if Prelude.Natural.lessThan 10 num
        then  2
        else  1

let Natural/padToText
    : Natural -> Natural -> Text
    = \(padTo : Natural) ->
      \(num : Natural) ->
        let digits = Natural/digits num

        let padCount = Natural/subtract digits padTo

        let zeroes = Prelude.Text.replicate padCount "0"

        let actualNumber = Natural/show num

        in  zeroes ++ actualNumber

let Url/link
    : Text -> Types.Url -> XML.Type
    = \(linkText : Text) ->
      \(url : Types.Url) ->
        XML.element
          { name = "a"
          , attributes = [ XML.attribute "href" url ]
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

let CodeRefs/asUl
    : Text -> Types.CodeRefs -> XML.Type
    = \(name : Text) ->
      \(ref : Types.CodeRefs) ->
        XML/asUl
          name
          ( Prelude.List.map
              Types.CodeRef
              XML.Type
              ( \(codeRef : Types.CodeRef) ->
                  XML.element
                    { name = "a"
                    , attributes = [ XML.attribute "href" codeRef.url ]
                    , content = [ XML.text codeRef.modPath ]
                    }
              )
              ref.refs
          )

let Check/tableRow
    : Types.Check -> XML.Type
    = \(check : Types.Check) ->
        let idString = "valn" ++ Natural/padToText 4 check.id

        let br =
              XML.element
                { name = "br"
                , attributes = XML.emptyAttributes
                , content = [] : List XML.Type
                }

        let checkLink =
              XML.element
                { name = "a"
                , attributes = [ XML.attribute "href" ("#" ++ idString) ]
                , content = [ XML.text "¶" ]
                }

        let linkCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ checkLink ]
                }

        let idCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ XML.text idString ]
                }

        let statusCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = [ XML.text (Types.Status/show check.status) ]
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
              if    Prelude.List.null Types.CodeRef check.code.refs
              then  [ XML.text "no refs to code.", br ]
              else  [ XML.text "code refs:", CodeRefs/asUl "impls" check.code ]

        let testsUl =
              if    Prelude.List.null Types.CodeRef check.test.refs
              then  [ XML.text "no refs to tests.", br ]
              else  [ XML.text "test refs:", CodeRefs/asUl "test" check.test ]

        let codeSearchA =
              [ XML.element
                  { name = "a"
                  , attributes =
                    [ XML.attribute
                        "href"
                        (     "https://github.com/search?type=code&q=repo%3Aopenmls%2Fopenmls%20"
                          ++  idString
                        )
                    ]
                  , content = [ XML.text "search code", br ]
                  }
              ]

        let notesCell =
              XML.element
                { name = "td"
                , attributes = XML.emptyAttributes
                , content = codeSearchA # notesUl # implsUl # testsUl
                }

        in  XML.element
              { name = "tr"
              , attributes = [ XML.attribute "id" idString ]
              , content =
                [ linkCell, idCell, statusCell, descCell, rfcLinksCell, notesCell ]
              }

let thead =
      XML/wrap
        "thead"
        ( XML/wrapList
            "tr"
            [ XML.element
                { name = "th"
                , attributes = XML.emptyAttributes
                , content = [ ]: List XML.Type
                }
            ,XML.element
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
