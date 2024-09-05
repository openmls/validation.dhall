let types = ../types.dhall

let id = 6

let name = "Update Proposal Validation"

let descText =
      ''
      <p>
      An Update proposal is a similar mechanism to Add with the distinction that it
      replaces the sender's LeafNode in the tree instead of adding a new leaf to the
      tree.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.2"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              An Update proposal is invalid if the LeafNode is invalid for an Update
              proposal according to Section 7.3.
              ''
              "section-12.1.2-3"
          )
          types.Status.Unknown
          ( types.CodeRefs/single
              "openmls::messages::proposals_in::UpdateProposalIn::validate"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/messages/proposals_in.rs#L200-L221"
          )
          types.CodeRefs/empty
          (types.Notes/single "todo: add test refs")
      ]

in  types.CheckSet/new id name desc checks
