let types = ../types.dhall

let id = 15

let name = "External Proposal Validation"

let descText =
      ''
      <p>
      Proposals can be constructed and sent to the group by a party that is outside the group. 
      </p>
      ''

let desc =
      types.DocumentRef/single descText types.Document.MlsRfc "section-12.1.8-1"

let checks =
      [ types.Check/new
          1
          ( types.DocumentRef/new
              ''
              sender_type: external: The content_type of the message MUST be proposal.
              ''
              types.Document.MlsRfc
              [ "section-6.1-4", "section-6.1-5.2" ]
          )
          types.Status.Complete
          types.Status.Unknown
          ( types.Notes/single
              "This is implicit, because it's the value on which our decision how to process the message is based."
          )
      , types.Check/new
          2
          ( types.DocumentRef/new
              ''
              sender_type: external: the proposal_type MUST be a value that is allowed for external senders. Only the following types may be sent by an external sender: add, remove, psk, reinit, group_context_extensions.
              ''
              types.Document.MlsRfc
              [ "section-6.1-4", "section-6.1-5.2", "section-12.1.8-5" ]
          )
          types.Status.Complete
          types.Status.Unknown
          ( types.Notes/single
              "Not all of the accepted proposal types are implemented yet."
          )
      , types.Check/new
          3
          ( types.DocumentRef/new
              ''
              sender_type: new_member_proposal: The content_type of the message MUST be proposal.
              ''
              types.Document.MlsRfc
              [ "section-6.1-4", "section-6.1-5.4" ]
          )
          types.Status.Complete
          types.Status.Unknown
          ( types.Notes/single
              "This is implicit, because it's the value on which our decision how to process the message is based."
          )
      , types.Check/new
          4
          ( types.DocumentRef/new
              ''
              sender_type: new_member_proposal: The proposal_type of the Proposal MUST be add.
              ''
              types.Document.MlsRfc
              [ "section-6.1-4", "section-6.1-5.4" ]
          )
          types.Status.Complete
          types.Status.Complete
          types.Notes/empty
      , types.Check/new
          5
          ( types.DocumentRef/single
              ''
              An external proposal MUST be sent as a PublicMessage object, since the sender
              will not have the keys necessary to construct a PrivateMessage object.
              ''
              types.Document.MlsRfc
              "section-12.1.8-4"
          )
          types.Status.Missing
          types.Status.Missing
          (types.Notes/single "not yet implemented")
      , types.Check/new
          6
          ( types.DocumentRef/single
              ''
              The external SenderType requires that signers are pre-provisioned to the
              clients within a group and can only be used if the external_senders
              extension is present in the group's GroupContext.
              ''
              types.Document.MlsRfc
              "section-12.1.8-2"
          )
          types.Status.Missing
          types.Status.Missing
          (types.Notes/single "not yet implemented")
      ]

in  types.CheckSet/new id name desc checks
