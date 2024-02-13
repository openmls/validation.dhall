let types = ./types.dhall

let id = 1

let descText =
      ''
      # Leaf Node Validation

      The validity of a LeafNode needs to be verified at the following stages:
      - When a LeafNode is downloaded in a KeyPackage, before it is used to add the client to the group
      - When a LeafNode is received by a group member in an Add, Update, or Commit message
      - When a client validates a ratchet tree, e.g., when joining a group or after processing a Commit
      ''

let desc = types.RfcRef/single descText "section-7.3"

let checks =
        [ { id = 1
          , desc =
              types.RfcRef/single
                "Verify that the credential in the LeafNode is valid, as described in Section 5.3.1."
                "section-7.3-4.1"
          , status = types.Status.Unknown
          , test = types.CodeRefs/empty
          , code = types.CodeRefs/empty
          , notes = types.Notes/empty
          }
        , types.Check/new
            2
            ( types.RfcRef/single
                "Verify that the signature on the LeafNode is valid using signature_key."
                "section-7.3-4.2"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            3
            ( types.RfcRef/single
                "Verify that the LeafNode is compatible with the group's parameters. If the GroupContext has a required_capabilities extension, then the required extensions, proposals, and credential types MUST be listed in the LeafNode's capabilities field."
                "section-7.3-4.3"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            4
            ( types.RfcRef/single
                ''
                Verify that the credential type is supported by all members of
                the group, as specified by the capabilities field of each member's
                LeafNode, and that the capabilities field of this LeafNode
                indicates support for all the credential types currently in use by
                other members.
                ''
                "section-7.3-4.4"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            5
            ( types.RfcRef/new
                ''
                Verify the `lifetime` field: If the LeafNode appears in a message
                being sent by the client, e.g., a Proposal or a Commit, then the
                client MUST verify that the current time is within the range of
                the lifetime field.
                ''
                [ "section-7.3-4.5.1", "section-7.3-4.5.2.1" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            6
            ( types.RfcRef/new
                ''
                Verify the `lifetime` field: If instead the LeafNode appears in a
                message being received by the client, e.g., a Proposal, a Commit,
                or a ratchet tree of the group the client is joining, it is
                RECOMMENDED that the client verifies that the current time is
                within the range of the lifetime field. (This check is not
                mandatory because the LeafNode might have expired in the time
                between when the message was sent and when it was received.)
                ''
                [ "section-7.3-4.5.1", "section-7.3-4.5.2.2" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            7
            ( types.RfcRef/single
                ''
                Verify that the extensions in the LeafNode are supported by
                checking that the ID for each extension in the extensions field
                is listed in the capabilities.extensions field of the LeafNode.
                ''
                "section-7.3-4.6"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            8
            ( types.RfcRef/new
                ''
                Verify the `leaf_node_source` field: If the LeafNode appears in
                a KeyPackage, verify that leaf_node_source is set to key_package.
                ''
                [ "section-7.3-4.7.1", "section-7.3-4.7.2.1" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            9
            ( types.RfcRef/new
                ''
                Verify the `leaf_node_source` field: If the LeafNode appears in an
                Update proposal, verify that leaf_node_source is set to update and
                that encryption_key represents a different public key than the
                encryption_key in the leaf node being replaced by the Update proposal.
                ''
                [ "section-7.3-4.7.1", "section-7.3-4.7.2.2" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            10
            ( types.RfcRef/new
                ''
                Verify the `leaf_node_source` field: If the LeafNode appears in the
                leaf_node value of the UpdatePath in a Commit, verify that
                leaf_node_source is set to commit.
                ''
                [ "section-7.3-4.7.1", "section-7.3-4.7.2.3" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            11
            ( types.RfcRef/new
                ''
                Verify that the following fields are unique among the members of
                the group: `signature_key`
                ''
                [ "section-7.3-4.8.1", "section-7.3-4.7.8.1" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            12
            ( types.RfcRef/new
                ''
                Verify that the following fields are unique among the members of
                the group: `encryption_key`
                ''
                [ "section-7.3-4.8.1", "section-7.3-4.7.8.2" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        ]
      : List types.Check

in  types.CheckSet/new id desc checks
