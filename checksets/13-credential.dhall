let types = ../types.dhall

let id = 13

let name = "Credential Validation"

let descText =
      ''
      <p>
      Whenever a new credential is introduced in the group, it MUST be validated with the AS.
      </p>
      <p>
      <b>This is an application validation.</b>
      </p>
      <p>
       In particular, at the following events in the protocol:
      <ul>
        <li>  When a member receives a KeyPackage that it will use in an Add proposal to add a new member to the group</li>
        <li>  When a member receives a GroupInfo object that it will use to join a group, either via a Welcome or via an external Commit</li>
        <li>  When a member receives an Add proposal adding a member to the group</li>
        <li>  When a member receives an Update proposal whose LeafNode has a new credential for the member</li>
        <li>  When a member receives a Commit with an UpdatePath whose LeafNode has a new credential for the committer</li>
        <li>  When an external_senders extension is added to the group</li>
        <li>  When an existing external_senders extension is updated</li>
      </ul>
      </p>
      ''

let desc = types.RfcRef/single descText "section-5.3.1"

let checks =
        [ types.Check/new
            1
            ( types.RfcRef/single
                "In cases where a member's credential is being replaced, such as the Update and Commit cases above, the AS MUST also verify that the set of presented identifiers in the new credential is valid as a successor to the set of presented identifiers in the old credential, according to the application's policy."
                "section-5.3.1-5"
            )
            types.Status.Unknown
            types.CodeRefs/empty
            types.CodeRefs/empty
            types.Notes/empty
        ]
    :  List types.Check

in  types.CheckSet/new id name desc checks

