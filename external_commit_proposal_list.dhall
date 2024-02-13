let types = ./types.dhall

let id = 4

let descText =
      ''
      # Proposal List Validation

      A group member creating a `Commit` and a group member processing a `Commit`
      MUST verify that the list of committed proposals is valid using one of the
      following procedures, depending on whether the `Commit` is external or not.
      If the list of proposals is invalid, then the Commit message MUST be
      rejected as invalid.

      For an external Commit, the list is valid if it contains only the following
      proposals (not necessarily in this order):
      ''

let desc = types.RfcRef/new descText [ "section-12.2-1", "section-12.2-5" ]

let checks =
      [ types.Check/new
          1
          ( RfcRef/single
              "Exactly one ExternalInit"
              "section-12.2-6.1"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          2
          ( RfcRef/single
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
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          3
          ( RfcRef/single
              "Zero or more PreSharedKey proposals"
              "section-12.2-6.3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          4
          ( RfcRef/single
              "No other proposals"
              "section-12.2-6.4"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types/CheckSet/new id desc checks
