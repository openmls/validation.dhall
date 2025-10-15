let types = ../types.dhall

let id = 2

let name = "Key Package Validation"

let descText =
      ''
      <p>The validity of a KeyPackage needs to be verified at a few stages:</p>
      <ul>
      <li>When a KeyPackage is downloaded by a group member, before it is used to add the client to the group</li>
      <li>When a KeyPackage is received by a group member in an Add message</li>
      </ul
      ''

let desc = types.RfcRef/single descText "section-10.1"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              Verify that the cipher suite and protocol version of the KeyPackage
              match those in the GroupContext.
              ''
              "section-10.1-4.1"
          )
          types.Status.Complete
          types.Status.Complete
          types.Notes/empty
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              Verify that the leaf_node of the KeyPackage is valid for a KeyPackage
              according to Section 7.3.
              ''
              "section-10.1-4.2"
          )
          types.Status.Complete
          types.Status.Unknown
          ( types.Notes/single
              ''
              This is checked when processing adds in commit messages.
              It is the responsibility of the caller to validate key packages before using them in Add proposals.
              ''
          )
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              Verify that the signature on the KeyPackage is valid using the public
              key in `leaf_node.credential`.
              ''
              "section-10.1-4.3"
          )
          types.Status.Complete
          types.Status.Unknown
          ( types.Notes/single
              ''
              this looks like a bug in the RFC. It should be signed using leaf_node.signature_key,
              but the credential can have opinions on whether that key is valid.
              ''
          )
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              Verify that the value of `leaf_node.encryption_key` is different from
              the value of the `init_key` field.
              ''
              "section-10.1-4.4"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          5
          ( types.RfcRef/single
              ''
              If a client receives a KeyPackage carried within an MLSMessage object, then it MUST
              verify that the version field of the KeyPackage has the same value as the version
              field of the MLSMessage.
              ''
              "section-10-7"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
