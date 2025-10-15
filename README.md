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
      , implStatus : Status
      , testStatus : Status
      , notes : Notes
      }
```

and can be instantiated using

```dhall
let Check/new
    : Natural -> RfcRef -> Status -> Status -> Notes -> Check
    = \(id : Natural) ->
      \(desc : RfcRef) ->
      \(implStatus : Status) ->
      \(testStatus : Status) ->
      \(notes : Notes) ->
        { id, desc, impltatus, testStatus, notes }
```

Unfortunately the Dhall linter is very keen to strip comments from the source, so the documentation lives here:

- `desc`: The description of the Check in the form of an RfcRef. An RfcRef consists of a piece of text and one or more links into the RFC in the form of the DOM ID of the element in which the check is mandated.
- `implStatus`: Whether we implemented the check in OpenMLS
- `testStatus`: Whether we test that the check is performed in OpenMLS
- `notes`: Notes about the Check. These contain just text without special meaning.
