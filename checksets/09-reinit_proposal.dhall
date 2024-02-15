let types = ../types.dhall

let id = 9

let name = "ReInit Proposal Validation"

let descText =
      ''
      <p>
      A ReInit proposal represents a request to reinitialize the group with different
      parameters, for example, to increase the version number or to change the cipher
      suite. The reinitialization is done by creating a completely new group and
      shutting down the old one.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.5"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              A ReInit proposal is invalid if the version field is less than the
              version for the current group.
              ''
              "section-12.1.5-3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
