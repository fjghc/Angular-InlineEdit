module = angular.module('InlineEdit', [])

template = """
           <span class="InlineEditWidget">
             <span ng:show="editing" class="InlineEditing">
                <span class="transclude-root" ng:transclude></span>
             </span>

             <span class="InlineEditable" ng:hide="editing"  ng:dblclick="enter()">{{altModel || model}}&nbsp;</span>

           </span>
           """

module.directive "cbInline", ($timeout) ->
  transclude: "element"   # Transclude the entire element wrapping this attribute
  priority: 2             # Higher priority to allow ngModel to bind correctly

  # Re-bind the value of the trigger elements 'ng:model' attribute to the 'model' value in our isolated scope
  scope:
    model:    "=ngModel"
    altModel: "=cbInline"

  template: template,
  replace: true

  link: (scope, elm, attr) ->

    # Remember the intitial value
    originalValue = scope.model

    # Get a reference to the transcluded element (The input field)
    transcluded = elm.find(".transclude-root").children().first()

    # Catch the escape key and cancel the inline edit
    transcluded.bind "keydown", (e) ->
      scope.$apply scope.cancel  if e.keyCode is 27

    # Catch the blur (field exit) operation and revert to display mode
    transcluded.bind "blur", ->
      scope.$apply scope.leave

    # Triggered when double clicking on the display value
    scope.enter = ->

      # Trigger editing mode
      scope.editing = true

      # Update the original value
      originalValue = scope.model

      # HACK - Use timeout to trigger focus() to the input element. This needs
      # to happen asynchronously for the browser to register it
      $timeout (->
        input = elm.find("input")
        input[0].focus()
        input[0].select()
      ), 0, false

    # Triggered when the field is exited
    scope.leave = ->
      scope.editing = false

    # Cancel editing and revert to the previous value
    scope.cancel = ->
      scope.editing = false
      scope.model = originalValue
