let types = ../types.dhall

let id = 12

let name = "Processing a Commit"

let descText =
      ''
      <p>A member of the group applies a Commit message by taking the following steps:</p>
      ''

let desc = types.RfcRef/single descText "section-12.4.2"

let checks =
        [ types.Check/new
            1
            ( types.RfcRef/single
                ''
                Verify that the epoch field of the enclosing FramedContent is equal to the
                epoch field of the current GroupContext object.
                ''
                "section-12.4.2-2.1"
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::PublicGroup::validate_commit"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/staged_commit.rs#L49-L57"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: find test refs")
        , types.Check/new
            2
            ( types.RfcRef/new
                ''
                Unprotect the Commit using the keys from the current epoch: If the message is
                encoded as PublicMessage, verify the membership MAC using the membership_key.
                ''
                [ "section-12.4.2-2.2.1", "section-12.4.2-2.2.2.1" ]
            )
            types.Status.Partial
            ( types.CodeRefs/new
                [ types.CodeRef/new
                    "openmls::group::mls_group::MlsGroup::process_message"
                    "https://github.com/openmls/openmls/blob/main/openmls/src/group/mls_group/processing.rs#L62-L63"
                , types.CodeRef/new
                    "openmls::group::public_group::PublicGroup::process_message"
                    "https://github.com/openmls/openmls/blob/main/openmls/src/group/public_group/process.rs#L149-L157"
                ]
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test refs")
        , types.Check/new
            3
            ( types.RfcRef/single
                ''
                Verify the signature on the FramedContent message as described in Section 6.1.
                ''
                "section-12.4.2-2.3"
            )
            types.Status.Partial
            ( types.CodeRefs/new
                [ types.CodeRef/new
                    "openmls::group::mls_group::MlsGroup::process_unverified_message"
                    "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/mls_group/processing.rs#L273-L274"
                , types.CodeRef/new
                    "openmls::group::public_group::PublicGroup::process_unverified_message"
                    "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/process.rs#L203-L204"
                ]
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: find test refs")
        , types.Check/new
            4
            ( types.RfcRef/single
                ''
                Verify that the proposals vector is valid according to the rules in Section 12.2.
                ''
                "section-12.4.2-2.4"
            )
            types.Status.Partial
            ( types.CodeRefs/new
                [ types.CodeRef/new
                    "openmls::group::mls_group::MlsGroup::stage_commit"
                    "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/mls_group/staged_commit.rs#L152-L154"
                , types.CodeRef/new
                    "openmls::group::public_group::PublicGroup::stage_commit"
                    "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/staged_commit.rs#L208"
                ]
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: find test refs")
        , types.Check/new
            5
            ( types.RfcRef/single
                ''
                Verify that all PreSharedKey proposals in the proposals vector are available.
                ''
                "section-12.4.2-2.5"
            )
            types.Status.Partial
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/single
                ''
                It's a bit unclear what is meant by this - do they mean the _proposal_ is available, or the _PSK_ is available?
                Because we know the proposal is available, otherwise we'd have a hard time processing it.
                We also fail if PSKs are missing.
                We need to test that we do the right thing here.
                ''
            )
        , types.Check/new
            6
            ( types.RfcRef/single
                ''
                Verify that the path value is populated if the proposals vector contains
                any Update or Remove proposals, or if it's empty. Otherwise, the path value
                MAY be omitted.
                ''
                "section-12.4.2-2.7"
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::PublicGroup::stage_diff"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/staged_commit.rs#L243-L246"
            )
            types.CodeRefs/empty
            ( types.Notes/single
                "TODO: Find Tests and reference them here or annotate them"
            )
        , types.Check/new
            7
            ( types.RfcRef/new
                ''
                If the path value is populated, validate it and apply it to the tree:
                Validate the LeafNode as specified in Section 7.3.
                The leaf_node_source field MUST be set to commit.
                ''
                [ "section-12.4.2-2.8.1", "section-12.4.2-2.8.2.2" ]
            )
            types.Status.Partial
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/single
                ''
                This is done when parsing the update path
                ''
            )
        , types.Check/new
            8
            ( types.RfcRef/new
                ''
                If the path value is populated, validate it and apply it to the tree:
                Verify that the encryption_key value in the LeafNode is different from
                the committer's current leaf node.
                ''
                [ "section-12.4.2-2.8.1", "section-12.4.2-2.8.2.3" ]
            )
            types.Status.Partial
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/simple
                "we check that it is different from the keys of _any_ current member. Still need to test this check."
            )
        , types.Check/new
            9
            ( types.RfcRef/new
                ''
                If the path value is populated, validate it and apply it to the tree:
                Verify that none of the public keys in the UpdatePath appear in any
                node of the new ratchet tree.
                ''
                [ "section-12.4.2-2.8.1", "section-12.4.2-2.8.2.4" ]
            )
            types.Status.Partial
            ( types.CodeRefs/single
                "openmls::group::public_group::PublicGroup::validate_key_uniqueness"
                "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L169-L298"
            )
            types.CodeRefs/empty
            (types.Notes/single "todo: add test refs")
        ]
      : List types.Check

in  types.CheckSet/new id name desc checks
