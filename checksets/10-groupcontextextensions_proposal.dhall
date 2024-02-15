let types = ../types.dhall

let id = 10

let name = "GroupContextExtensions Proposal Validation"

let descText =
      ''
      <p>
      A GroupContextExtensions proposal is used to update the list of extensions in the GroupContext for the group.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.7"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              A GroupContextExtensions proposal is invalid if it includes a required_capabilities
              extension and some members of the group do not support some of the required
              capabilities (including those added in the same Commit, and excluding those removed).
              ''
              "section-12.1.7-3"
          )
          types.Status.Unknown
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              For new members, support for required capabilities is enforced by existing members during
              the application of Add commits. Existing members should of course be in compliance already.
              In order to ensure this continues to be the case even as the group's extensions are updated,
              a GroupContextExtensions proposal is deemed invalid if it contains a required_capabilities
              extension that requires non-default capabilities not supported by all current members.
              ''
              "section-11.1.4"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/new
              [ "don't ask me why this isn't in section 12.1.7..."
              , "reported in https://github.com/xmtp/openmls/pull/19"
              ]
          )
      ]

in  types.CheckSet/new id name desc checks
