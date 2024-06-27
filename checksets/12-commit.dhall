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
                "Verify that the credential in the LeafNode is valid, as described in Section 5.3.1."
                "section-12.4.2-2.1"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            2
            ( types.RfcRef/new
                ''
                Unprotect the Commit using the keys from the current epoch: If the message is
                encoded as PublicMessage, verify the membership MAC using the membership_key.
                ''
                [ "section-12.4.2-2.2.1", "section-12.4.2-2.2.2.1" ]
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            3
            ( types.RfcRef/single
                ''
                Verify the signature on the FramedContent message as described in Section 6.1.
                ''
                "section-12.4.2-2.3"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            4
            ( types.RfcRef/single
                ''
                Verify that the proposals vector is valid according to the rules in Section 12.2.
                ''
                "section-12.4.2-2.4"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        , types.Check/new
            5
            ( types.RfcRef/single
                ''
                Verify that all PreSharedKey proposals in the proposals vector are available.
                ''
                "section-12.4.2-2.5"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
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
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
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
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
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
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
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
            types.Status.Missing
            types.CodeRefs/empty
            types.CodeRefs/empty
            ( types.Notes/single
                ''
                reported in https://github.com/xmtp/openmls/pull/19
                ''
            )
        ]
      : List types.Check

in  types.CheckSet/new id name desc checks
