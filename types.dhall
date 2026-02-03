let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let Status
    : Type
    = < Unknown | Missing | Partial | Complete >

let Status/show
    : Status -> Text
    = \(status : Status) ->
        merge
          { Unknown = "Unknown"
          , Missing = "Missing"
          , Partial = "Partial"
          , Complete = "Complete"
          }
          status

let Notes
    : Type
    = { notes : List Text }

let Notes/new
    : List Text -> Notes
    = \(notes : List Text) -> { notes }

let Notes/single
    : Text -> Notes
    = \(note : Text) -> Notes/new [ note ]

let Notes/empty
    : Notes
    = Notes/new ([] : List Text)

let Url
    : Type
    = Text

let Url/new
    : Text -> Url
    = \(url : Text) -> url

let Document
    : Type
    = < MlsRfc | MlsExtensions | Other >

let Document/show
    : Document -> Text
    = \(doc : Document) ->
        merge
          { MlsRfc = "RFC 9420"
          , MlsExtensions = "MLS Extensions"
          , Other = "Other"
          }
          doc

let Document/baseUrl
    : Document -> Text
    = \(doc : Document) ->
        merge
          { MlsRfc = "https://www.rfc-editor.org/rfc/rfc9420.html"
          , MlsExtensions =
              "https://datatracker.ietf.org/doc/html/draft-ietf-mls-extensions"
          , Other = "https://"
          }
          doc

let DocumentRef
    : Type
    = { text : Text, document : Document, fragments : List Text }

let DocumentRef/single
    : Text -> Document -> Text -> DocumentRef
    = \(text : Text) ->
      \(doc : Document) ->
      \(fragment : Text) ->
        { text, document = doc, fragments = [ fragment ] }

let DocumentRef/new
    : Text -> Document -> List Text -> DocumentRef
    = \(text : Text) ->
      \(doc : Document) ->
      \(fragments : List Text) ->
        { text, document = doc, fragments }

let DocumentRef/urls
    : DocumentRef -> List Url
    = \(ref : DocumentRef) ->
        let baseUrl = Document/baseUrl ref.document

        in  Prelude.List.map
              Text
              Url
              (\(fragment : Text) -> "${baseUrl}#${fragment}")
              ref.fragments

let Check
    : Type
    = { id : Natural
      , desc : DocumentRef
      , implStatus : Status
      , testStatus : Status
      , notes : Notes
      }

let Check/new
    : Natural -> DocumentRef -> Status -> Status -> Notes -> Check
    = \(id : Natural) ->
      \(desc : DocumentRef) ->
      \(implStatus : Status) ->
      \(testStatus : Status) ->
      \(notes : Notes) ->
        { id, desc, implStatus, testStatus, notes }

let CheckSet
    : Type
    = { id : Natural, name : Text, desc : DocumentRef, checks : List Check }

let CheckSet/new
    : Natural -> Text -> DocumentRef -> List Check -> CheckSet
    = \(id : Natural) ->
      \(name : Text) ->
      \(desc : DocumentRef) ->
      \(checks : List Check) ->
        let checks =
              Prelude.List.map
                Check
                Check
                (\(check : Check) -> check with id = check.id + 100 * id)
                checks

        in  { id, name, desc, checks }

let Natural/equals
    {- tests whether two natural numbers are equal by testing whether both
    -- a-b and b-a (clamping!) are zero -}
    : Natural -> Natural -> Bool
    = \(a : Natural) ->
      \(b : Natural) ->
        let b_minus_a = Natural/subtract a b

        let a_minus_b = Natural/subtract b a

        let a_lte_b = Natural/isZero a_minus_b

        let b_lte_a = Natural/isZero b_minus_a

        in  a_lte_b && b_lte_a

let CheckSet/checkById
    : CheckSet -> Natural -> Optional Check
    = \(checkSet : CheckSet) ->
      \(id : Natural) ->
        Prelude.List.index
          0
          Check
          ( Prelude.List.filter
              Check
              ((\(check : Check) -> Natural/equals id check.id) : Check -> Bool)
              checkSet.checks
          )

in  { Notes
    , Notes/new
    , Notes/single
    , Notes/empty
    , Url
    , Url/new
    , Document
    , Document/show
    , Document/baseUrl
    , DocumentRef
    , DocumentRef/single
    , DocumentRef/new
    , DocumentRef/urls
    , Check
    , Check/new
    , CheckSet
    , CheckSet/new
    , CheckSet/checkById
    , Status
    , Status/show
    }
