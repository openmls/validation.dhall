let types = ../types.dhall

let id = 15

let name = "External Proposal Validation"

let descText =
      ''
      <p>
      Proposals can be constructed and sent to the group by a party that is outside the group. 
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.8-1"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/new
              ''
              sender_type: external: The content_type of the message MUST be proposal.
              ''
              [ "section-6.1-4", "section-6.1-5.2" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "This is implicit, because it's the value on which our decision how to process the message is based."
          )
      , types.Check/new
          2
          ( types.RfcRef/new
              ''
              sender_type: external: the proposal_type MUST be a value that is allowed for external senders. Only the following types may be sent by an external sender: add, remove, psk, reinit, group_context_extensions.
              ''
              [ "section-6.1-4", "section-6.1-5.2", "section-12.1.8-5" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "Not all of the accepted proposal types are implemented yet."
          )
      , types.Check/new
          3
          ( types.RfcRef/new
              ''
              sender_type: new_member_proposal: The content_type of the message MUST be proposal.
              ''
              [ "section-6.1-4", "section-6.1-5.4" ]
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "This is implicit, because it's the value on which our decision how to process the message is based."
          )
      , types.Check/new
          4
          ( types.RfcRef/new
              ''
              sender_type: new_member_proposal: The proposal_type of the Proposal MUST be add.
              ''
              [ "section-6.1-4", "section-6.1-5.4" ]
          )
          types.Status.Complete
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
