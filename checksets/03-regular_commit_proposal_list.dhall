let Types = ../types.dhall

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

let desc = Types.RfcRef/new descText [ "section-12.2-1", "section-12.2-2" ]

let checks =
      [ Types.Check/new
          1
          ( Types.RfcRef/single
              ''
              It contains an individual proposal that is invalid as specified invalid
              Section 12.1.
              ''
              "section-12.2-3.1"
          )
          Types.Status.Unknown
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          Types.Notes/empty
      , Types.Check/new
          2
          ( Types.RfcRef/single
              "It contains an Update proposal generated by the committer."
              "section-12.2-3.2"
          )
          Types.Status.Unknown
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          Types.Notes/empty
      , Types.Check/new
          3
          ( Types.RfcRef/single
              "It contains a Remove proposal that removes the committer."
              "section-12.2-3.3"
          )
          Types.Status.Unknown
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          Types.Notes/empty
      , Types.Check/new
          4
          ( Types.RfcRef/single
              ''
              It contains multiple Update and/or Remove proposals that apply to
              the same leaf. If the committer has received multiple such
              proposals they SHOULD prefer any Remove received, or the most
              recent Update if there are no Removes.
              ''
              "section-12.2-3.4"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          5
          ( Types.RfcRef/single
              ''
              It contains multiple Add proposals that contain KeyPackages that
              represent the same client according to the application (for 
              example, identical signature keys).
              ''
              "section-12.2-3.5"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          6
          ( Types.RfcRef/single
              ''
              It contains an Add proposal with a KeyPackage that represents a
              client already in the group according to the application, unless
              there is a Remove proposal in the list removing the matching
              client from the group.
              ''
              "section-12.2-3.6"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          7
          ( Types.RfcRef/single
              ''
              It contains multiple PreSharedKey proposals that reference then
              same PreSharedKeyID.
              ''
              "section-12.2-3.7"
          )
          Types.Status.Unknown
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          Types.Notes/empty
      , Types.Check/new
          8
          ( Types.RfcRef/single
              "It contains multiple GroupContextExtension proposals."
              "section-12.2-3.8"
          )
          Types.Status.Complete
          ( Types.CodeRefs/new
              [ Types.CodeRef/new
                  "openmls::group::public_group::validate_group_context_extensions_proposal"
                  ( Types.Url/new
                      "https://github.com/openmls/openmls/blob/58df3c7639e5ca3c2e52a35a97c0dbeffd7d77bf/openmls/src/group/public_group/validation.rs#L537-L598"
                  )
              ]
          )
          ( Types.CodeRefs/new
              [ Types.CodeRef/new
                  "openmls::group::mls_group::test_mls_group::group_context_extension_proposal"
                  ( Types.Url/new
                      "https://github.com/openmls/openmls/blob/58df3c7639e5ca3c2e52a35a97c0dbeffd7d77bf/openmls/src/group/mls_group/test_mls_group.rs#L1146-L1354"
                  )
              ]
          )
          Types.Notes/empty
      , Types.Check/new
          9
          ( Types.RfcRef/single
              ''
              It contains a ReInit proposal together with any other proposal. If
              the committer has received other proposals during the epoch, they
              SHOULD prefer them over the ReInit proposal, allowing the ReInit
              to be resent and applied in a subsequent epoch.
              ''
              "section-12.2-3.9"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          10
          ( Types.RfcRef/single
              "It contains an ExternalInit proposal."
              "section-12.2-3.10"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          11
          ( Types.RfcRef/single
              ''
              It contains a Proposal with a non-default proposal type that is not
              supported by some members of the group that will process the Commit
              (i.e., members being added or removed by the Commit do not need to
              support the proposal type).
              ''
              "section-12.2-3.11"
          )
          Types.Status.Missing
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          ( Types.Notes/single
              ''
              reported in https://github.com/xmtp/openmls/pull/19
              ''
          )
      , Types.Check/new
          12
          ( Types.RfcRef/single
              ''
              After processing the Commit the ratchet tree is invalid, in
              particular, if it contains any leaf node that is invalid according
              to Section 7.3.
              ''
              "section-12.2-3.12"
          )
          Types.Status.Unknown
          Types.CodeRefs/empty
          Types.CodeRefs/empty
          Types.Notes/empty
      ]

in  Types.CheckSet/new id name desc checks
