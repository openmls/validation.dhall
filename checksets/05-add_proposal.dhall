let types = ../types.dhall

let id = 5

let name = "Add Proposal Validation"

let descText =
      ''
      <p>
      An Add proposal requests that a client with a specified KeyPackage be added
      to the group.
      </p>
      ''

let desc =
      types.DocumentRef/single descText types.Document.MlsRfc "section-12.1.1"

let checks =
      [ types.Check/new
          1
          ( types.DocumentRef/single
              ''
              An Add proposal is invalid if the KeyPackage is invalid according to
              Section 10.1.
              ''
              types.Document.MlsRfc
              "section-12.1.1-3"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          2
          ( types.DocumentRef/single
              ''
              A client adding a new member to a group MUST verify that the LeafNode for
              the new member is compatible with the group's extensions. The capabilities
              field MUST indicate support for each extension in the GroupContext.
              An Add proposal is invalid if the KeyPackage is invalid according to
              Section 10.1.
              ''
              types.Document.MlsRfc
              "section-13.4-5.5"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
