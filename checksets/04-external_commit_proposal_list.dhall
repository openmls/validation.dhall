let types = ../types.dhall

let id = 4

let name = "External Commit Proposal List Validation"

let descText =
      ''
      <p>
      A group member creating a `Commit` and a group member processing a `Commit`
      MUST verify that the list of committed proposals is valid using one of the
      following procedures, depending on whether the `Commit` is external or not.
      If the list of proposals is invalid, then the Commit message MUST be
      rejected as invalid.
      </p>

      <p>
      For an external Commit, the list is valid if it contains only the following
      proposals (not necessarily in this order):
      </p>
      ''

let desc = types.RfcRef/new descText [ "section-12.2-1", "section-12.2-5" ]

let checks =
      [ types.Check/new
          1
          (types.RfcRef/single "Exactly one ExternalInit" "section-12.2-6.1")
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              At most one Remove proposal, with which the joiner removes an old
              version of themselves. If a Remove proposal is present, then the
              LeafNode in the path field of the external Commit MUST meet the
              same criteria as would the LeafNode in an Update for the removed
              leaf (see Section 12.1.2). In particular, the credential in the
              LeafNode MUST present a set of identifiers that is acceptable to
              the application for the removed participant.
              ''
              "section-12.2-6.2"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              We are checking that there is not more than one Remove proposal
              in external commits, but the application has to ensure that the
              provided key package satisfies the requirements.
              ''
          )
      , types.Check/new
          3
          ( types.RfcRef/single
              "Zero or more PreSharedKey proposals"
              "section-12.2-6.3"
          )
          types.Status.Complete
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              Since we can only include a non-negative integer number of proposals, it necessarily is "zero or more". There is no check required.
              ''
          )
      , types.Check/new
          4
          (types.RfcRef/single "No other proposals" "section-12.2-6.4")
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "The check is implemented, but we need to test that we do it correctly"
          )
      , types.Check/new
          5
          ( types.RfcRef/single
              ''
              External Commits MUST contain a path field (and is therefore a "full" Commit). The joiner is added at the leftmost free leaf node
              (just as if they were added with an Add proposal), and the path is calculated relative to that leaf node.
              ''
              "section-12.4.3.2-11.1"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "The check is implemented, but we need to test that we do it correctly"
          )
      , types.Check/new
          6
          ( types.RfcRef/single
              ''
              The Commit MUST NOT include any proposals by reference, since an external joiner cannot determine the validity of proposals sent
              within the group.
              ''
              "section-12.4.3.2-11.2"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "The check is implemented, but we need to test that we do it correctly"
          )
      , types.Check/new
          7
          ( types.RfcRef/single
              ''
              External Commits MUST be signed by the new member. In particular, the signature on the enclosing AuthenticatedContent MUST verify
              using the public key for the credential in the leaf_node of the path field.
              ''
              "section-12.4.3.2-11.3"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "The check is implemented, but we need to test that we do it correctly"
          )
      , types.Check/new
          8
          ( types.RfcRef/single
              ''
              The sender type for the AuthenticatedContent encapsulating the external Commit MUST be new_member_commit.
              ''
              "section-12.4.3.2-11.5"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "This is implicit, because it's the value on which our decision how to process the message is based."
          )
      ]

in  types.CheckSet/new id name desc checks
