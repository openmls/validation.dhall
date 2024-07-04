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
          types.Status.Complete
          ( types.CodeRefs/single
              "openmls::group::public_group::PublicGroup::validate_group_context_extensions_proposal"
              -- "https://github.com/openmls/openmls/blob/58df3c7639e5ca3c2e52a35a97c0dbeffd7d77bf/openmls/src/group/public_group/validation.rs#L565-L567"
          )
          ( types.CodeRefs/single
              "openmls::group::mls_group::test_mls_group::group_context_extensions::fail_unsupported_gces_add_valno1001"
              -- "https://github.com/openmls/openmls/blob/e5d2a3920d386ce33fb0b6ac08f68e7a527096fa/openmls/src/group/mls_group/test_mls_group.rs#L2078-L2210"
          )
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
