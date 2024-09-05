let types = ../types.dhall

let id = 5

let name = "Add Proposal Validation"

let descText =
      ''
      <p>
      An Add proposal requests that a client with a specified KeyPackage be added
      to the group.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.1"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              An Add proposal is invalid if the KeyPackage is invalid according to
              Section 10.1.
              ''
              "section-12.1.1-3"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::messages::proposals_in::AddProposalIn::validate"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/messages/proposals_in.rs#L156"
          )
          types.CodeRefs/empty
          (types.Notes/single "todo: add test refs")
      ]

in  types.CheckSet/new id name desc checks
