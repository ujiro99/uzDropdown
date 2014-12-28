angular.module('uz', [])
  .directive 'uzDropdown', ($timeout) ->
    return {
      restrict: 'E'
      template:
        # "result: <pre><code>{{result}}</code></pre>" + # for debug
        "<div class='dropdown'>" +
        "<input tabindex='0'" +
               "class='dropdown-text dropdown-toggle'" +
               "ng-model='keyword'" +
               "ng-keydown='onKeydown($event.keyCode)'></input>" +
        "<div class='dropdown-box'><ul class='dropdown-content'>" +
        "<li ng-repeat='item in result = (items | filter:itemFilter)'" +
            "ng-click='onClickItem(item)'" +
            "ng-class='{active: item === selected[0]}'>" +
        "<a><span>{{$eval($parent.format)}}</span></a>" +
        "</li></ul></div>"
      scope:
        items: '='
        selected: '='
        itemFilter: '=filter'
      link: (scope, element, attrs) ->
        KEY_ENTER   = 13
        KEY_UP      = 38
        KEY_DOWN    = 40

        selectIndex = 0
        inputElem = element[0].querySelector(".dropdown-toggle")

        scope.format = attrs.format or "item.text"
        scope.keyword = ''
        scope.result = []
        scope.selectedFormat = attrs.selectedFormat or "selected[0].text"

        scope.itemFilter = (item) ->
          return eval(scope.format).match(scope.keyword)

        scope.onClickItem = (item) ->
          scope.selected[0] = item
          scope.keyword = eval("scope." + scope.selectedFormat)

        scope.onKeydown = (keycode) ->
          if keycode is KEY_ENTER
            scope.keyword = eval("scope." + scope.selectedFormat)
            selected = scope.result[selectIndex]
          else if keycode is KEY_DOWN then selectIndex++
          else if keycode is KEY_UP then selectIndex--

          if selectIndex < 0
            selectIndex = 0
          if selectIndex >= scope.result.length
            selectIndex = scope.result.length - 1
          selected = scope.result[selectIndex]
          $timeout(() -> scope.selected[0] = selected)

        scope.$watch 'result.length', () ->
          selectIndex = 0
          selected = scope.result[selectIndex]
          $timeout(() -> scope.selected[0] = selected)
    }
