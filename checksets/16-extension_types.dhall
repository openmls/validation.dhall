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

let desc =
      types.DocumentRef/single descText types.Document.MlsRfc "section-17.3"

let checks =
      [ types.Check/new
          1
          ( types.DocumentRef/new
              ''
              	      LeafNode: application_id, GREASE
                            ''
              types.Document.MlsRfc
              [ "section-17.3-3.3.1", "section-17.3-4" ]
          )
          types.Status.Unknown
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          2
          ( types.DocumentRef/new
              ''
              GroupInfo: ratchet_tree, external_pub, GREASE
              ''
              types.Document.MlsRfc
              [ "section-17.3-3.3.1", "section-17.3-4" ]
          )
          types.Status.Unknown
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          3
          ( types.DocumentRef/new
              ''
              GroupContext: required_capabilities, external_senders
              ''
              types.Document.MlsRfc
              [ "section-17.3-3.3.1", "section-17.3-4" ]
          )
          types.Status.Unknown
          types.Status.Unknown
          types.Notes/empty
      , types.Check/new
          4
          ( types.DocumentRef/new
              ''
              KeyPackage: GREASE
              ''
              types.Document.MlsRfc
              [ "section-17.3-3.3.1", "section-17.3-4" ]
          )
          types.Status.Unknown
          types.Status.Unknown
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
