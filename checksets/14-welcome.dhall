let types = ../types.dhall

let id = 14

let name = "Welcome Validation"

let descText =
      ''
      <p>
      On receiving a Welcome message, a client processes it using the following steps:
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.4.3.1-7"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              If a PreSharedKeyID is part of the GroupSecrets and the client is not in possession of
              the corresponding PSK, return an error. Additionally, if a PreSharedKeyID has type
              resumption with usage reinit or branch, verify that it is the only such PSK.
              ''
              "section-12.4.3.1-10.1"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "reinit and branch are not implement so far")
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              Verify the signature on the GroupInfo object. The signature input comprises all of the
              fields in the GroupInfo object except the signature field. The public key is taken
              from the LeafNode of the ratchet tree with leaf index signer. If the node is blank or
              if signature verification fails, return an error.
              ''
              "section-12.4.3.1-12.1"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              Verify that the group_id is unique among the groups that the client is currently
              participating in.
              ''
              "section-12.4.3.1-12.2"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "This is an application-level concern. We only handle individual groups"
          )
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              Verify that the cipher_suite in the GroupInfo matches the cipher_suite in the
              KeyPackage.
              ''
              "section-12.4.3.1-12.3"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              This one is a bit unclear. It does not clearly stated which key package is meant
              (though we can guess it's the new member's key package), and also GroupInfo itself
              doesn't even have a cipher_suite.
              And what about the cipher_suite of the Welcome message itself?
              The current status is that we don't do the check, be compare the cipher_suite fields
              of key package and welcome message.
              ''
          )
      , types.Check/new
          5
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              Verify that the tree hash of the ratchet tree matches the tree_hash field in GroupInfo.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.4.2.1" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          6
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For each non-empty parent node, verify that it is "parent-hash valid", as described in
              Section 7.9.2.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.4.2.2" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          7
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For each non-empty leaf node, validate the LeafNode as described in Section 7.3.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.4.2.3" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          8
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree:
              For each non-empty parent node and each entry in the node's unmerged_leaves field:
              Verify that the entry represents a non-blank leaf node that is a descendant of the
              parent node.
              ''
              [ "section-12.4.3.1-12.4.1"
              , "section-12.4.3.1-12.4.2.4.1"
              , "section-12.4.3.1-12.4.2.4.2.1"
              ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          9
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For each non-empty parent node and each entry in the node's unmerged_leaves field:
              Verify that every non-blank intermediate node between the leaf node and the parent
              node also has an entry for the leaf node in its unmerged_leaves.
              ''
              [ "section-12.4.3.1-12.4.1"
              , "section-12.4.3.1-12.4.2.4.1"
              , "section-12.4.3.1-12.4.2.4.2.2"
              ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          10
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For each non-empty parent node and each entry in the node's unmerged_leaves field:
              Verify that the encryption key in the parent node does not appear in any other node of
              the tree.
              ''
              [ "section-12.4.3.1-12.4.1"
              , "section-12.4.3.1-12.4.2.4.1"
              , "section-12.4.3.1-12.4.2.4.2.3"
              ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "The test might be missing")
      , types.Check/new
          11
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              Verify the confirmation tag in the GroupInfo using the derived confirmation key and
              the confirmed_transcript_hash from the GroupInfo.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.9" ]
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          12
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              If a PreSharedKeyID was used that has type resumption with usage reinit or branch,
              verify that the epoch field in the GroupInfo is equal to 1.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.11.1" ]
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "reinit isn't currently implemented")
      , types.Check/new
          13
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For usage reinit, verify that the last Commit to the referenced group contains a
              ReInit proposal and that the group_id, version, cipher_suite, and
              group_context.extensions fields of the GroupInfo match the ReInit proposal.
              Additionally, verify that all the members of the old group are also members of the new
              group, according to the application.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.11.2.1" ]
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "reinit isn't currently implemented")
      , types.Check/new
          14
          ( types.RfcRef/new
              ''
              Verify the integrity of the ratchet tree: 
              For usage branch, verify that the version and cipher_suite of the new group match
              those of the old group, and that the members of the new group compose a subset of the
              members of the old group, according to the application.
              ''
              [ "section-12.4.3.1-12.4.1", "section-12.4.3.1-12.11.2.2" ]
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "branching isn't currently implemented")
      ]

in  types.CheckSet/new id name desc checks
