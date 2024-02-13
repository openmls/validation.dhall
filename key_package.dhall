let types = ./types.dhall

let id = 2

let descText =
      ''
      # Key Package Validation

      The validity of a KeyPackage needs to be verified at a few stages:
      - When a KeyPackage is downloaded by a group member, before it is used to add the client to the group
      -When a KeyPackage is received by a group member in an Add message
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
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
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
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              Verify that the signature on the KeyPackage is valid using the public
              key in `leaf_node.credential`.
              ''
              "section-10.1-4.3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              Verify that the value of `leaf_node.encryption_key` is different from
              the value of the `init_key` field.
              ''
              "section-10.1-4.4"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types/CheckSet/new id desc checks
