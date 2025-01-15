let Prelude =
      https://prelude.dhall-lang.org/v22.0.0/package.dhall
        sha256:1c7622fdc868fe3a23462df3e6f533e50fdc12ecf3b42c0bb45c328ec8c4293e

let XML = Prelude.XML

let Property
    : Type
    = { key : Text, value : Text }

let Property/highlight
    : Property
    = { key = "background-color", value = "#fde995" }

let Property/cssText
    : Property -> Text
    = \(prop : Property) -> prop.key ++ ":" ++ prop.value ++ ";"

let PropertyList = List Property

let PropertyList/cssText =
      \(list : PropertyList) ->
        Prelude.Text.concatMapSep "\n" Property Property/cssText list

let IdSelector
    : Type
    = { id : Text }

let IdSelector/cssText
    : IdSelector -> Text
    = \(sel : IdSelector) -> "#" ++ Prelude.Text.replace "." "\\." sel.id

let IdSelectorList = List IdSelector

let IdSelectorList/cssText =
      \(list : IdSelectorList) ->
        Prelude.Text.concatMapSep ",%0a" IdSelector IdSelector/cssText list

let IdSelectorsRule
    : Type
    = { selectors : IdSelectorList, properties : PropertyList }

let IdSelectorsRule/cssText =
      \(rule : IdSelectorsRule) ->
        let selectors = IdSelectorList/cssText rule.selectors

        let properties = PropertyList/cssText rule.properties

        in  "${selectors} { ${properties} }"

let IdSelectorsRule/styleBlock =
      \(rule : IdSelectorsRule) ->
        XML.element
          { name = "style"
          , attributes = [ XML.attribute "type" "text/css" ]
          , content = [ XML.rawText (IdSelectorsRule/cssText rule) ]
          }

let IdSelectorsRule/bookmarklet =
      \(rule : IdSelectorsRule) ->
        let cssText = IdSelectorsRule/cssText rule

        let jsBody =
              ''
              let cssBody = document.createTextNode(String.raw`${cssText}`);
              let styleElem = document.createElement('style');
              document.head.appendChild(styleElem);
              styleElem.setAttribute('type', 'text/css');
              styleElem.appendChild(cssBody);
              ''

        let jsWrapped = "void function(){${jsBody}}()"

        in  "javascript:${jsWrapped}"

in  { Property
    , Property/highlight
    , IdSelector
    , IdSelectorsRule
    , IdSelectorsRule/cssText
    , IdSelectorsRule/styleBlock
    , IdSelectorsRule/bookmarklet
    }
