let types = ../types.dhall

let id = 13

let name = "Message Framing Validation"

let descText =
      ''
      <p>
      Handshake and application messages use a common framing structure. This
      framing provides encryption to ensure confidentiality within the group, as
      well as signing to authenticate the sender.
      </p>
      ''

let desc = types.RfcRef/single descText "section-7.6"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              Recipients of an MLSMessage MUST verify the signature with the key depending on the
              sender_type of the sender as described above.
              ''
              "section-6.1-6"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/new
              [ "NB: This is about picking the right key, not verifying the signature. That is done in valn1302 and valn1304."
              , "todo: find test refs"
              ]
          )
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              When decoding a PublicMessage into an AuthenticatedContent, the application MUST check
              membership_tag and MUST check that the FramedContentAuthData is valid.
              ''
              "section-6.2-6"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: find test refs")
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              The padding field is set by the sender, by first encoding the content (via the select)
              and the auth field, and then appending the chosen number of zero bytes. A receiver
              identifies the padding field in a plaintext decoded from PrivateMessage.ciphertext by
              first decoding the content and the auth field; then the padding field comprises any
              remaining octets of plaintext. The padding field MUST be filled with all zero bytes.
              A receiver MUST verify that there are no non-zero bytes in the padding field, and if
              this check fails, the enclosing PrivateMessage MUST be rejected as malformed. This
              check ensures that the padding process is deterministic, so that, for example, padding
              cannot be used as a covert channel.
              ''
              "section-6.3.1-3"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: find test refs")
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              When decoding a PrivateMessageContent, the application MUST check that the
              FramedContentAuthData is valid.
              ''
              "section-6.3.1-10"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: find test refs")
      , types.Check/new
          5
          ( types.RfcRef/single
              ''
              When constructing a SenderData object from a Sender object, the sender MUST verify
              Sender.sender_type is member and use Sender.leaf_index for SenderData.leaf_index.
              ''
              "section-6.3.2-3"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: find test refs")
      , types.Check/new
          6
          ( types.RfcRef/single
              ''
              When parsing a SenderData struct as part of message decryption, the recipient MUST
              verify that the leaf index indicated in the leaf_index field identifies a non-blank
              node.
              ''
              "section-6.3.2-9"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: find test refs")
      , types.Check/new
          7
          ( types.RfcRef/single
              ''
              On receiving a FramedContent containing a Proposal, a client MUST verify the signature
              inside FramedContentAuthData and that the epoch field of the enclosing FramedContent
              is equal to the epoch field of the current GroupContext object. If the verification is
              successful, then the Proposal should be cached in such a way that it can be retrieved
              by hash (as a ProposalOrRef object) in a later Commit message.
              ''
              "section-12.1-3"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: proper testing")
      ]

in  types.CheckSet/new id name desc checks
