let types = ../types.dhall

let id = 1

let name = "Leaf Node Validation"

let descText =
      ''
      <p>The validity of a LeafNode needs to be verified at the following stages:</p>
      <ul>
      <li>When a LeafNode is downloaded in a KeyPackage, before it is used to add the client to the group</li>
      <li>When a LeafNode is received by a group member in an Add, Update, or Commit message</li>
      <li>When a client validates a ratchet tree, e.g., when joining a group or after processing a Commit</li>
      </ul>
      ''

let desc = types.RfcRef/single descText "section-7.3"

let checks =
        [ types.Check/new
            1
            ( types.RfcRef/single
                "Verify that the credential in the LeafNode is valid, as described in Section 5.3.1."
                "section-7.3-4.1"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/single
                "This is about what leaf nodes get passed into OpenMLS rather than what we do with them. Therefore this is an application-level check."
            )
        , types.Check/new
            2
            ( types.RfcRef/single
                "Verify that the signature on the LeafNode is valid using signature_key."
                "section-7.3-4.2"
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::key_packages::KeyPackageIn::validate"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/key_packages/key_package_in.rs#L150"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test ref")
        , types.Check/new
            3
            ( types.RfcRef/single
                "Verify that the LeafNode is compatible with the group's parameters. If the GroupContext has a required_capabilities extension, then the required extensions, proposals, and credential types MUST be listed in the LeafNode's capabilities field."
                "section-7.3-4.3"
            )
            types.Status.Partial
            types.CodeRefs/empty
            ( types.CodeRefs/new
                [ types.CodeRef/new
                    "openmls::group::tests_and_kats::tests::group_context_extensions::fail_insufficient_capabilities_add_valno103"
                    "https://github.com/openmls/openmls/blob/96c38a806f9c706d2cf67566c9c846eee3ac4430/openmls/src/group/tests_and_kats/tests/group_context_extensions.rs#L430-L539"
                , types.CodeRef/new
                    "openmls::group::tests_and_kats::tests::group_context_extensions::fail_insufficient_capabilities_update_valno103"
                    "https://github.com/openmls/openmls/blob/96c38a806f9c706d2cf67566c9c846eee3ac4430/openmls/src/group/tests_and_kats/tests/group_context_extensions.rs#L541-L714"
                ]
            )
            ( types.Notes/new
                [ "reported in https://github.com/xmtp/openmls/pull/19"
                , "We currently test this when an Add and Update proposal is being committed."
                ]
            )
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
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::validation::validate_capabilities"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L303-L383"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test refs")
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
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::key_packages::KeyPackageIn::validate"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/key_packages/key_package_in.rs#L193-L194"
            )
            types.CodeRefs/empty
            ( types.Notes/new
                [ ''
                  probably only done for key packages, but these should be the only
                  leaf nodes with lifetimes anyway''
                , "todo: add test refs"
                ]
            )
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
            types.Status.Partial
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/single
                "check is implemented, still needs to be tested."
            )
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
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::validation::validate_capabilities"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L303-L383"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test ref")
        , types.Check/new
            8
            ( types.RfcRef/new
                ''
                Verify the `leaf_node_source` field: If the LeafNode appears in
                a KeyPackage, verify that leaf_node_source is set to key_package.
                ''
                [ "section-7.3-4.7.1", "section-7.3-4.7.2.1" ]
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::key_packages::KeyPackageIn::validate"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/key_packages/key_package_in.rs#L148-L154"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test refs")
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
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::PublicGroup::validate_key_uniqueness"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L280-L282"
            )
            types.CodeRefs/empty
            ( types.Notes/new
                [ "we might be more restrictive here, because we don't accept colliding keys at all, not just in Update proposals"
                , "todo: add test refs"
                ]
            )
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
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::treesync::treekem::UpdatePathIn::into_verified"
                "https://github.com/openmls/openmls/blob/20042d7ed0df813cbe792a2c216092d85845dff4/openmls/src/treesync/treekem.rs#L411-L423"
            )
            types.CodeRefs/empty
            (types.Notes/single "TODO: find and document where this is tested")
        , types.Check/new
            11
            ( types.RfcRef/new
                ''
                Verify that the following fields are unique among the members of
                the group: `signature_key`
                ''
                [ "section-7.3-4.8.1", "section-7.3-4.7.8.1" ]
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::validation::validate_key_uniqueness"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L169-L298"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test ref")
        , types.Check/new
            12
            ( types.RfcRef/new
                ''
                Verify that the following fields are unique among the members of
                the group: `encryption_key`
                ''
                [ "section-7.3-4.8.1", "section-7.3-4.7.8.2" ]
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::validation::validate_key_uniqueness"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L169-L298"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test ref")
        , types.Check/new
            13
            ( types.RfcRef/new
                ''
                Verify that the credential type used in the LeafNode is included in the credentials field of the capabilities field.
                ''
                [ "section-7.2-7" ]
            )
            types.Status.Partial
            types.CodeRefs/empty
            types.CodeRefs/empty
            (types.Notes/single "todo: add test ref")
        ]
      : List types.Check

in  types.CheckSet/new id name desc checks
