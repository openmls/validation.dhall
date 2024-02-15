let Prelude = https://prelude.dhall-lang.org/v22.0.0/package.dhall

let Status
    : Type
    = < Unknown | Missing | Partial | Complete >

let Notes
    : Type
    = { notes : List Text }

let Notes/new
    : List Text -> Notes
    = \(notes : List Text) -> { notes }

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
    = { modPath : Text }

let CodeRef/new
    : Text -> CodeRef
    = \(modPath : Text) -> { modPath }

let CodeRefs
    : Type
    = { refs : List CodeRef }

let CodeRefs/new
    : List CodeRef -> CodeRefs
    = \(refs : List CodeRef) -> { refs }

let CodeRefs/empty
    : CodeRefs
    = CodeRefs/new ([] : List CodeRef)

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

in  { CodeRef
    , CodeRef/new
    , CodeRefs
    , CodeRefs/new
    , CodeRefs/empty
    , Notes
    , Notes/new
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
    , Status
    }
