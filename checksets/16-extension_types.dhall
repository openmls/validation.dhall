let types = ../types.dhall

let id = 16

let name = "Extension Type Validation"

let descText =
      ''
      <p>
	The "MLS Extension Types" registry lists identifiers for extensions to the MLS protocol.
      </p>
      <p>
	This checkset lists the extension types that are valid for each object.
      </p>
      <ul>
	<li>KP: KeyPackage objects</li>
	<li>LN: LeafNode objects</li>
	<li>GC: GroupContext objects</li>
	<li>GI: GroupInfo objects</li>
      </ul>
      ''

let desc = types.RfcRef/single descText "section-17.3"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/new
              ''
	      LN: application_id
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
              GI: ratchet_tree, external_pub
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
              GC: required_capabilities, external_senders
              ''
              ["section-17.3-3.3.1", "section-17.3-4"]
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/empty)
      ]

in  types.CheckSet/new id name desc checks
