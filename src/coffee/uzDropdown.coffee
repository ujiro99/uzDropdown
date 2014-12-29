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
               "placeholder='{{placeholder}}'" +
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
        placeholder: '@'
      link: (scope, element, attrs) ->
        KEY_ENTER   = 13
        KEY_UP      = 38
        KEY_DOWN    = 40
        SPLIT_SPACE = ' '

        # focus positon on dropdown contents.
        _selectIndex = 0

        # regex object cache for search
        _searchRegex = {}

        # escape Regex special characters.
        escapeRegExp = (str) ->
          return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

        scope.keyword = ''
        scope.result = []
        scope.format = attrs.format or "item.text"
        scope.selectedFormat = attrs.selectedFormat or "selected[0].text"

        ###
         filtering list
        ###
        scope.itemFilter = (item) ->
          # create regex object and cache it.
          if not _searchRegex[scope.keyword]
            _searchRegex = {}   # clear old regex objects.
            _searchRegex[scope.keyword] = []
            keywords = scope.keyword.split(SPLIT_SPACE)
            for k in keywords
              _searchRegex[scope.keyword].push new RegExp(escapeRegExp(k), ["i"])

          # filtering.
          target = eval(scope.format)
          isMatch = true
          for reg in _searchRegex[scope.keyword]
            isMatch &= reg.test(target)
          return isMatch

        ###
         on focus input, select all words.
        ###
        element[0].querySelector('input').onfocus = () ->
          this.select()

        ###
         on click contents, select item and update input field.
        ###
        scope.onClickItem = (item) ->
          scope.selected[0] = item
          scope.keyword = eval("scope." + scope.selectedFormat)

        ###
         Keydown event on input fileld.
          - select item (up and down).
          - confirm item selection (enter).
        ###
        scope.onKeydown = (keycode) ->
          if keycode is KEY_ENTER
            scope.keyword = eval("scope." + scope.selectedFormat)
            tmpSelected = scope.result[_selectIndex]
          else if keycode is KEY_DOWN then _selectIndex++
          else if keycode is KEY_UP then _selectIndex--

          if _selectIndex < 0
            _selectIndex = 0
          if _selectIndex >= scope.result.length
            _selectIndex = scope.result.length - 1
          tmpSelected = scope.result[_selectIndex]
          $timeout(() -> scope.selected[0] = tmpSelected)

        ###
         Update selection if result changed.
        ###
        scope.$watch 'result.length', () ->
          _selectIndex = 0
          $timeout(() -> scope.selected[0] = scope.result[_selectIndex])
    }
