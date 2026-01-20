let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let Types = ../types.dhall

let CheckSets = ../checksets.dhall

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

let Check/toId
    : Types.Check -> Text
    = \(check : Types.Check) -> "valn" ++ Natural/padToText 4 check.id

let Status/isComplete
    : Types.Status -> Bool
    = \(status : Types.Status) ->
        merge
          { Unknown = False, Missing = False, Partial = False, Complete = True }
          status

let allChecks =
      Prelude.List.concatMap
        Types.CheckSet
        Types.Check
        (\(cs : Types.CheckSet) -> cs.checks)
        CheckSets

let completeChecks =
      Prelude.List.filter
        Types.Check
        (\(check : Types.Check) -> Status/isComplete check.implStatus)
        allChecks

let checkIds = Prelude.List.map Types.Check Text Check/toId completeChecks

let generateCheckCommand
    : Text -> Text
    = \(id : Text) -> "if ! rg -q '${id}' .; then missing+=(\"${id}\"); fi"

let checkCommands = Prelude.List.map Text Text generateCheckCommand checkIds

let script =
      ''
      #!/bin/bash
      missing=()
      ${Prelude.Text.concatSep "\n" checkCommands}
      if [ ''${#missing[@]} -gt 0 ]; then
        echo "Missing check IDs:"
        printf '%s\n' "''${missing[@]}"
        exit 1
      fi
      ''

in  script
