# OpenMLS Validation Repo

This repository compiles the checks mandated by the MLS spec and their status of being implemented and tested in OpenMLS in a machine-readable format. The mandated checks are bundled into checksets. A checkset is intended to describe all the checks that need to be done given a particular piece of data.

## Repository Layout

- `/types.dhall`: defines the types needed to represent the check sets, as well as functions for working with them
- `/checksets.dhall`: imports all the checksets from /checksets
- `/checksets/*.dhall`: One checkset per file
- `views/` contains the dhall code generating the visual representations
- `views/dashboad.dhall`: generates the dashboard
- `views/bookmarkletPage.dhall` generates the page containing the bookmarklet for highlighting the RFC

## Reference

### Check

A check is defined by

```dhall
let Check
    : Type
    = { id : Natural
      , desc : RfcRef
      , status : Status
      , code : CodeRefs
      , test : CodeRefs
      , notes : Notes
      }
```

and can be instantiated using

```dhall
let Check/new
    : Natural -> RfcRef -> Status -> CodeRefs -> CodeRefs -> Notes -> Check
    = \(id : Natural) ->
      \(desc : RfcRef) ->
      \(status : Status) ->
      \(code : CodeRefs) ->
      \(test : CodeRefs) ->
      \(notes : Notes) ->
        { id, desc, status, notes, code, test }
```

Unfortunately the Dhall linter is very keen to strip comments from the source, so the documentation lives here:

- `desc`: The description of the Check in the form of an RfcRef. An RfcRef consists of a piece of text and one or more links into the RFC in the form of the DOM ID of the element in which the check is mandated.
- `status`: Whether we implemented and or tested the check in OpenMLS
- `code`: References into the code, describing where the Check is implemented. The type is CodeRefs, which is a list of CodeRef, which contains a string that is a module path.
- `test`: Same as `code`, but instead of describing where the check is *implemented*, it describes where the check is *tested*.
- `notes`: Notes about the Check. These contain just text without special meaning.
