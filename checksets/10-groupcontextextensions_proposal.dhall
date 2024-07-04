let types = ../types.dhall

let id = 10

let name = "GroupContextExtensions Proposal Validation"

let descText =
      ''
      <p>
      A GroupContextExtensions proposal is used to update the list of extensions in the GroupContext for the group.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.7"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              A GroupContextExtensions proposal is invalid if it includes a required_capabilities
              extension and some members of the group do not support some of the required
              capabilities (including those added in the same Commit, and excluding those removed).
              ''
              "section-12.1.7-3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
