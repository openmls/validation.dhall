let types = ../types.dhall

let id = 3

let name = "Regular Commit Proposal List Validation"

let descText =
      ''
      <p>
      A group member creating a `Commit` and a group member processing a `Commit`
      MUST verify that the list of committed proposals is valid using one of the
      following procedures, depending on whether the `Commit` is external or not.
      If the list of proposals is invalid, then the Commit message MUST be
      rejected as invalid.
      </p>

      <p>
      For a regular, i.e., not external, Commit, the list is invalid if any of
      the following occurs:
      </p>
      ''

let desc = types.RfcRef/new descText [ "section-12.2-1", "section-12.2-2" ]

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              It contains an individual proposal that is invalid as specified invalid
              Section 12.1.
              ''
              "section-12.2-3.1"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::public_group::PublicGroup::validate_commit"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/staged_commit.rs#L42-L165"
          )
          types.CodeRefs/empty
          ( types.Notes/new
              [ "The use of the ? operator means that if any of the checks fails, the function returns an error"
              , "todo: add test ref"
              ]
          )
      , types.Check/new
          2
          ( types.RfcRef/single
              "It contains an Update proposal generated by the committer."
              "section-12.2-3.2"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::public_group::PublicGroup::validate_commit"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L436-L458"
          )
          types.CodeRefs/empty
          (types.Notes/single "todo: add tests ref")
      , types.Check/new
          3
          ( types.RfcRef/single
              "It contains a Remove proposal that removes the committer."
              "section-12.2-3.3"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::mls_group::MlsGroup::from_committed_proposals"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/mls_group/proposal_store.rs#L239-L270"
          )
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              It contains multiple Update and/or Remove proposals that apply to
              the same leaf. If the committer has received multiple such
              proposals they SHOULD prefer any Remove received, or the most
              recent Update if there are no Removes.
              ''
              "section-12.2-3.4"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/new
              [ ''
                reported in https://github.com/xmtp/openmls/pull/19
                ''
              , ''
                this check seems contradictory; if a forbidden thing happens, use this
                resolution strategy. We likely don't do the right thing, but it's also
                not clear what the right thing would be.
                ''
              ]
          )
      , types.Check/new
          5
          ( types.RfcRef/single
              ''
              It contains multiple Add proposals that contain KeyPackages that
              represent the same client according to the application (for 
              example, identical signature keys).
              ''
              "section-12.2-3.5"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/new
              [ ''
                reported in https://github.com/xmtp/openmls/pull/19
                ''
              , ''
                possibly an app-level concern, but then we at least need to give the app the
                tools to valiate this
                ''
              ]
          )
      , types.Check/new
          6
          ( types.RfcRef/single
              ''
              It contains an Add proposal with a KeyPackage that represents a
              client already in the group according to the application, unless
              there is a Remove proposal in the list removing the matching
              client from the group.
              ''
              "section-12.2-3.6"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/new
              [ ''
                reported in https://github.com/xmtp/openmls/pull/19
                ''
              , ''
                possibly an app-level concern, but then we at least need to give the app the
                tools to valiate this
                ''
              ]
          )
      , types.Check/new
          7
          ( types.RfcRef/single
              ''
              It contains multiple PreSharedKey proposals that reference then
              same PreSharedKeyID.
              ''
              "section-12.2-3.7"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::public_group::PublicGroup::validate_pre_shared_key_proposals"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/group/public_group/validation.rs#L467-L492"
          )
          types.CodeRefs/empty
          types.Notes/empty
      , types.Check/new
          8
          ( types.RfcRef/single
              "It contains multiple GroupContextExtension proposals."
              "section-12.2-3.8"
          )
          types.Status.Complete
          ( types.CodeRefs/single
              "openmls::group::public_group::validate_group_context_extensions_proposal"
              "https://github.com/openmls/openmls/blob/58df3c7639e5ca3c2e52a35a97c0dbeffd7d77bf/openmls/src/group/public_group/validation.rs#L537-L598"
          )
          ( types.CodeRefs/single
              "openmls::group::tests_and_kats::tests::group_context_extensions::fail_3gce_proposals_1_commit_valno308"
              "https://github.com/openmls/openmls/blob/96c38a806f9c706d2cf67566c9c846eee3ac4430/openmls/src/group/tests_and_kats/tests/group_context_extensions.rs#L823-L917"
          )
          types.Notes/empty
      , types.Check/new
          9
          ( types.RfcRef/single
              ''
              It contains a ReInit proposal together with any other proposal. If
              the committer has received other proposals during the epoch, they
              SHOULD prefer them over the ReInit proposal, allowing the ReInit
              to be resent and applied in a subsequent epoch.
              ''
              "section-12.2-3.9"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , types.Check/new
          10
          ( types.RfcRef/single
              "It contains an ExternalInit proposal."
              "section-12.2-3.10"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , types.Check/new
          11
          ( types.RfcRef/single
              ''
              It contains a Proposal with a non-default proposal type that is not
              supported by some members of the group that will process the Commit
              (i.e., members being added or removed by the Commit do not need to
              support the proposal type).
              ''
              "section-12.2-3.11"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , types.Check/new
          12
          ( types.RfcRef/single
              ''
              After processing the Commit the ratchet tree is invalid, in
              particular, if it contains any leaf node that is invalid according
              to Section 7.3.
              ''
              "section-12.2-3.12"
          )
          types.Status.Missing
          types.CodeRefs/empty
          types.CodeRefs/empty
          types.Notes/empty
      ]

in  types.CheckSet/new id name desc checks
