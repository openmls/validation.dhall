let types = ../types.dhall

let id = 16

let name = "Extension Types"

let descText =
      ''
      <p>
	The "MLS Extension Types" registry lists identifiers for extensions to the MLS protocol.
      </p>
      ''

let desc = types.RfcRef/single descText "section-17.3"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/new
              ''
              The messages in which the extension may appear: application_id: LN.
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
	, types.Check/new
          2
          ( types.RfcRef/new
              ''
              The messages in which the extension may appear: ratchet_tree: GI.
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
	, types.Check/new
          3
          ( types.RfcRef/new
              ''
              The messages in which the extension may appear: required_capabilities: GC.
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
	, types.Check/new
          4
          ( types.RfcRef/new
              ''
              The messages in which the extension may appear: external_pub: GI.
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
	, types.Check/new
          5
          ( types.RfcRef/new
              ''
              The messages in which the extension may appear: external_senders: GC.
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
      ]

in  types.CheckSet/new id name desc checks
