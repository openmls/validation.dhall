let types = ../types.dhall

let id = 8

let name = "PreSharedKey Proposal Validation"

let descText =
      ''
      <p>
      A PreSharedKey proposal can be used to request that a pre-shared key be injected
      into the key schedule in the process of advancing the epoch.
      </p>
      <p>
      A PreSharedKey proposal is invalid if any of the following is true:
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.4"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              The PreSharedKey proposal is not being processed as part of a
              reinitialization of the group (see Section 11.2), and the PreSharedKeyID
              has psktype set to resumption and usage set to reinit.
              ''
              "section-12.1.4-4.1"
          )
          types.Status.Complete
          types.Status.Unknown
          (types.Notes/single "ReInit is not implemented")
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              The PreSharedKey proposal is not being processed as part of a subgroup
              branching operation (see Section 11.3), and the PreSharedKeyID has
              psktype set to resumption and usage set to branch.
              ''
              "section-12.1.4-4.2"
          )
          types.Status.Complete
          types.Status.Unknown
          (types.Notes/single "Subgroup branching is not implemented")
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              The psk_nonce is not of length KDF.Nh.
              ''
              "section-12.1.4-4.3"
          )
          types.Status.Complete
          types.Status.Unknown
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
