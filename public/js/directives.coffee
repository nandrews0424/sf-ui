angular.module('app.directives')
  .directive('richTextEditor', ['$rootScope', ($rootScope) ->
    restrict: 'A'
    replace: true
    require: '?ngModel'
    transclude: true
    template: '<div></div>' # Wrapper <div> required.    
    compile: ($tElement, $tAttrs, $transclude) ->
      $transclude $rootScope.$new, (clone) ->    
        $tElement.append clone      
      
      ($scope, $element, $attrs, controller) ->
        
        textarea = $element.find('textarea')
        
        textarea.wysihtml5 
          color: true
          link: false
          image: false
          stylesheets: '/wysihtml5-bootstrap3-colors.css'

        editor = textarea.data('wysihtml5').editor

        editor.on 'focus', (e) ->          
          $(editor.composer.iframe).addClass('focused')

        editor.on 'blur', (e) ->
          $(editor.composer.iframe).removeClass('focused')

        #the javascript wrapper for bootstrap adds these
        $element.find('a').removeAttr('href')

        # Sync view -> model                
        $(editor.composer.sandbox.getDocument()).find('body').on 'keypress', _.debounce () ->          
          $scope.$apply ->          
            controller.$setViewValue unescape editor.getValue()
        , 100

        # Sync model -> view
        $scope.$watch $attrs.ngModel, (newValue, oldValue) ->          
          return if newValue == editor.getValue()
          editor.setValue newValue     
  ]).directive('checkbox', ->
    return {
      scope:
        ngModel: "=" 
        ngChecked: "="
      controller: ($scope, $element, $attrs) ->
        $scope.$watch 'ngChecked', (newVal, oldVal) ->          
          $scope.ngModel = $scope.ngChecked

      template: """
        <div class="check-box" ng-click="ngModel=!ngModel">
          <i class="" ng-show="ngModel"></i>
        </div>
      """
    }
  )
