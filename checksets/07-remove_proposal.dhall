let types = ../types.dhall

let id = 7

let name = "Remove Proposal Validation"

let descText =
      ''
      <p>
      A Remove proposal requests that the member with the leaf index removed be removed from the group.
      </p>
      ''

let desc = types.RfcRef/single descText "section-12.1.3"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              A Remove proposal is invalid if the removed field does not identify a non-blank leaf node.
              ''
              "section-12.1.3-3"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::group::PublicGroup::validate_remove_proposals"
              "https://github.com/openmls/openmls/blob/main/openmls/src/group/public_group/validation.rs#L424"
          )
          types.CodeRefs/empty
          ( types.Notes/single
              "the tests we have a are not great. The check and basic tests were added in PR https://github.com/openmls/openmls/pull/1655"
          )
      ]

in  types.CheckSet/new id name desc checks
