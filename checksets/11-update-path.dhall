let types = ../types.dhall

let id = 11

let name = "Update Path Validation"

let descText =
      ''
      <p>
      As described in Section 12.4, each Commit message may optionally contain an UpdatePath, with a new LeafNode and set of parent nodes for the sender's filtered direct path. For each parent node, the UpdatePath contains a new public key and encrypted path secret. The parent nodes are kept in the same order as the filtered direct path.
      </p>
      ''

let desc = types.RfcRef/single descText "section-7.6"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              For each UpdatePathNode, the resolution of the corresponding copath node MUST exclude all new leaf nodes added as part of the current Commit. The length of the encrypted_path_secret vector MUST be equal to the length of the resolution of the copath node (excluding new leaf nodes), with each ciphertext being the encryption to the respective resolution node.
              ''
              "section-7.6-3"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
               "reported in https://github.com/xmtp/openmls/pull/19"
          )
      ]

in  types.CheckSet/new id name desc checks
