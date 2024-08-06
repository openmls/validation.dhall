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
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::public_group::PublicGroup::validate_group_context_extensions_proposal"
              "https://github.com/openmls/openmls/blob/58df3c7639e5ca3c2e52a35a97c0dbeffd7d77bf/openmls/src/group/public_group/validation.rs#L565-L567"
          )
          ( types.CodeRefs/single
              "openmls::group::tests_and_kats::tests::group_context_extensions::fail_unsupported_gces_add_valno1001"
              "https://github.com/openmls/openmls/blob/96c38a806f9c706d2cf67566c9c846eee3ac4430/openmls/src/group/tests_and_kats/tests/group_context_extensions.rs#L919-L1051"
          )
          types.Notes/single "currently, we only test for missing supported extension types, not proposal or proposal types."
      ]

in  types.CheckSet/new id name desc checks
