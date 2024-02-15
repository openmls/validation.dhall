let types = ../types.dhall

let id = 7

let name = "Remove Proposal Validation"

let descText =
      ''
      <p>
      A Remove proposal requests that the member with the leaf index removed be removed from the group.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.3"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              A Remove proposal is invalid if the removed field does not identify a non-blank leaf node.
              ''
              "section-12.1.3-3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
