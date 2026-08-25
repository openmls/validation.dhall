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

let desc =
      types.DocumentRef/single descText types.Document.MlsRfc "section-12.1.2"

let checks =
      [ types.Check/new
          1
          ( types.DocumentRef/single
              ''
              An Update proposal is invalid if the LeafNode is invalid for an Update
              proposal according to Section 7.3.
              ''
              types.Document.MlsRfc
              "section-12.1.2-3"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          2
          ( types.DocumentRef/single
              ''
              To that end, it requires that we check that the LeafNodes in KeyPackages
              that are added support all extensions in the group context[^1]. However, it
              doesn't seem to require that the same check is mandated for LeafNodes in
              Update proposals or update paths.
              ''
              types.Document.Other
              "mailarchive.ietf.org/arch/msg/mls/k18P4FP7dfS2cBmP0kL6Uh50-ok/"
          )
          types.Status.Complete
          types.Status.Complete
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
