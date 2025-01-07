let types = ../types.dhall

let id = 2

let name = "Key Package Validation"

let descText =
      ''
      <p>The validity of a KeyPackage needs to be verified at a few stages:</p>
      <ul>
      <li>When a KeyPackage is downloaded by a group member, before it is used to add the client to the group</li>
      <li>When a KeyPackage is received by a group member in an Add message</li>
      </ul
      ''

let desc = types.RfcRef/single descText "section-10.1"

let checks =
      [ types.Check/new
          1
          ( types.RfcRef/single
              ''
              Verify that the cipher suite and protocol version of the KeyPackage
              match those in the GroupContext.
              ''
              "section-10.1-4.1"
          )
          types.Status.Complete
          types.CodeRefs/empty
          ( types.CodeRefs/single
              "openmls::group::tests_and_kats::tests::group_context_extensions::fail_key_package_version_valno201"
              "https://github.com/openmls/openmls/blob/96c38a806f9c706d2cf67566c9c846eee3ac4430/openmls/src/group/tests_and_kats/tests/group_context_extensions.rs#L716-821"
          )
          types.Notes/empty
      , types.Check/new
          2
          ( types.RfcRef/single
              ''
              Verify that the leaf_node of the KeyPackage is valid for a KeyPackage
              according to Section 7.3.
              ''
              "section-10.1-4.2"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          ( types.Notes/single
              "currently this is only done when processing adds in commit messages"
          )
      , types.Check/new
          3
          ( types.RfcRef/single
              ''
              Verify that the signature on the KeyPackage is valid using the public
              key in `leaf_node.credential`.
              ''
              "section-10.1-4.3"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::key_packages::KeyPackageIn::validate"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/key_packages/key_package_in.rs#L150"
          )
          types.CodeRefs/empty
          ( types.Notes/single
              ''
              this looks like a bug in the RFC. It should be signed using leaf_node.signature_key,
              but the credential can have opinions on whether that key is valid.
              ''
          )
      , types.Check/new
          4
          ( types.RfcRef/single
              ''
              Verify that the value of `leaf_node.encryption_key` is different from
              the value of the `init_key` field.
              ''
              "section-10.1-4.4"
          )
          types.Status.Partial
          ( types.CodeRefs/single
              "openmls::key_packages::KeyPackageIn::validate"
              "https://github.com/openmls/openmls/blob/5067034708f2332b0dfd8d7d28eb6618fd38f4c7/openmls/src/key_packages/key_package_in.rs#L160-L163"
          )
          types.CodeRefs/empty
          (types.Notes/single "todo: add test ref")
      , types.Check/new
          5
          ( types.RfcRef/single
              ''
              If a client receives a KeyPackage carried within an MLSMessage object, then it MUST
              verify that the version field of the KeyPackage has the same value as the version
              field of the MLSMessage.
              ''
              "section-10-7"
          )
          types.Status.Partial
          types.CodeRefs/empty
          types.CodeRefs/empty
          (types.Notes/single "todo: add test ref")
      ]

in  types.CheckSet/new id name desc checks
