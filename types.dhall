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
    = { url : Text }

let Url/new
    : Text -> Url
    = \(url : Text) -> { url }

let CodeRef
    : Type
    = { modPath : Text, url : Url }

let CodeRef/new
    : Text -> Url -> CodeRef
    = \(modPath : Text) -> \(url : Url) -> { modPath, url }

let CodeRefs
    : Type
    = { refs : List CodeRef }

let CodeRefs/new
    : List CodeRef -> CodeRefs
    = \(refs : List CodeRef) -> { refs }

let CodeRefs/empty
    : CodeRefs
    = CodeRefs/new ([] : List CodeRef)

let CodeRefs/single
    : Text -> CodeRefs
    -- : Text -> Url -> CodeRefs
    = \(modPath : Text) ->
      --\(url : Url) ->
        CodeRefs/new [ CodeRef/new modPath ] -- url ]

let RfcRef
    : Type
    = { text : Text, rfcFragments : List Text }

let RfcRef/single
    : Text -> Text -> RfcRef
    = \(text : Text) ->
      \(rfcFragment : Text) ->
        let rfcFragments = [ rfcFragment ] in { text, rfcFragments }

let RfcRef/new
    : Text -> List Text -> RfcRef
    = \(text : Text) -> \(rfcFragments : List Text) -> { text, rfcFragments }

let RfcRef/urls
    : RfcRef -> List Url
    = \(ref : RfcRef) ->
        Prelude.List.map
          Text
          Url
          ( \(fragment : Text) ->
              { url = "https://www.rfc-editor.org/rfc/rfc9420.html#${fragment}"
              }
          )
          ref.rfcFragments

let Check
    : Type
    = { id : Natural
      , desc : RfcRef
      , status : Status
      , code : CodeRefs
      , test : CodeRefs
      , notes : Notes
      }

let Check/new
    : Natural -> RfcRef -> Status -> CodeRefs -> CodeRefs -> Notes -> Check
    = \(id : Natural) ->
      \(desc : RfcRef) ->
      \(status : Status) ->
      \(code : CodeRefs) ->
      \(test : CodeRefs) ->
      \(notes : Notes) ->
        { id, desc, status, notes, code, test }

let CheckSet
    : Type
    = { id : Natural, name : Text, desc : RfcRef, checks : List Check }

let CheckSet/new
    : Natural -> Text -> RfcRef -> List Check -> CheckSet
    = \(id : Natural) ->
      \(name : Text) ->
      \(desc : RfcRef) ->
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

in  { CodeRef
    , CodeRef/new
    , CodeRefs
    , CodeRefs/new
    , CodeRefs/empty
    , CodeRefs/single
    , Notes
    , Notes/new
    , Notes/single
    , Notes/empty
    , Url
    , Url/new
    , RfcRef
    , RfcRef/single
    , RfcRef/new
    , RfcRef/urls
    , Check
    , Check/new
    , CheckSet
    , CheckSet/new
    , CheckSet/checkById
    , Status
    , Status/show
    }
