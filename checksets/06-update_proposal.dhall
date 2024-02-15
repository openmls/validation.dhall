let types = ../types.dhall

let id = 6

let name = "Update Proposal Validation"

let descText =
      ''
      <p>
      An Update proposal is a similar mechanism to Add with the distinction that it
      replaces the sender's LeafNode in the tree instead of adding a new leaf to the
      tree.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.2"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              An Update proposal is invalid if the LeafNode is invalid for an Update
              proposal according to Section 7.3.
              ''
              "section-12.1.2-3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
