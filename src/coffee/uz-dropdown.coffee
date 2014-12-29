angular.module('uz', [])
  .directive 'uzDropdown', () ->

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
        "<li ng-repeat='item in result = itemFilter(items)'" +
            "ng-click='onClickItem(item)'" +
            "ng-class='{active: item === selected[0]}'>" +
        "<a><span>{{$format(format, item)}}</span></a>" +
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
        DEFAULT_FORMAT = '{0}'

        # focus positon on dropdown contents.
        _selectIndex = 0

        # escape Regex special characters.
        escapeRegExp = (str) ->
          return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

        # format string
        scope.$format = (fmtStr, obj) ->
          rep_fn = undefined
          if typeof obj == "object"
            rep_fn = (m, k) ->
              keys = k.split('.')
              tmp = obj
              for key in keys then tmp = tmp[key]
              return tmp
          else
            args = arguments
            rep_fn = (m, k) -> return args[parseInt(k) + 1]
          return fmtStr.replace(/\{(.+?)\}/g, rep_fn)

        scope.keyword = ''
        scope.result = []
        scope.format = attrs.format or DEFAULT_FORMAT

        ###
         filtering list.
        ###
        scope.itemFilter = (items) ->
          if not scope.keyword then return items

          # make regexp object for filtering
          regs = []
          keywords = scope.keyword.split(SPLIT_SPACE)
          for k in keywords
            regs.push(new RegExp(escapeRegExp(k), ["i"]))

          # filtering.
          filteredItems = []
          for item, i in items
            target = scope.$format(scope.format, item)
            isMatch = true
            for reg in regs then isMatch &= reg.test(target)
            filteredItems.push item if isMatch

          return filteredItems

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
          scope.keyword = scope.$format(scope.format , item)

        ###
         Keydown event on input fileld.
          - select item (up and down).
          - confirm item selection (enter).
        ###
        scope.onKeydown = (keycode) ->
          if keycode is KEY_ENTER
            tmpSelected = scope.result[_selectIndex]
            scope.keyword = scope.$format(scope.format , tmpSelected) if tmpSelected
          else if keycode is KEY_DOWN then _selectIndex++
          else if keycode is KEY_UP then _selectIndex--
          if _selectIndex < 0
            _selectIndex = 0
          if _selectIndex >= scope.result.length
            _selectIndex = scope.result.length - 1
          tmpSelected = scope.result[_selectIndex]
          scope.selected[0] = tmpSelected

        ###
         Update selection if result changed.
        ###
        scope.$watch 'result.length', () ->
          _selectIndex = 0
          scope.selected[0] = scope.result[_selectIndex]
    }
