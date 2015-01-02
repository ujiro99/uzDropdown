angular.module('uz', [])
  .directive 'uzDropdown', () ->

    return {
      restrict: 'E'
      template:
#       "result: <pre><code>{{result}}</code></pre>" + # for debug
        "<div class='dropdown'>" +
        "<input tabindex='0'" +
               "class='dropdown-text dropdown-toggle'" +
               "ng-model='keyword'" +
               "placeholder='{{placeholder}}'" +
               "ng-blur='onBlur()'" +
               "ng-keydown='onKeydown($event.keyCode)'></input>" +
        "<div class='dropdown-box'><ul class='dropdown-content'>" +
        "<li ng-repeat='item in result = (itemFilter(items) | orderBy:order)'" +
            "ng-click='onClickItem(item)'" +
            "ng-mouseover='onMouseoverItem($index)'" +
            "ng-class='{selected: item === selected[0], focused: $index === focusIndex}'>" +
        "<a><span>{{$format(format, item)}}</span></a></li>" +
        "<li ng-if='result.length == 0'><a><span>not found ...</span></a></li>" +
        "<li ng-if='result.length >= listMax' ng-mouseover='onMouseover()'>" +
        "<a><span>more ...</span></a></li>" +
        "</ul></div>"
      scope:
        items: '='
        selected: '='
        keyword: '='
        placeholder: '@'
      link: (scope, element, attrs) ->
        KEY_ENTER        = 13
        KEY_UP           = 38
        KEY_DOWN         = 40
        LIST_MAX_INITIAL = 100
        SPLIT_SPACE      = ' '
        DEFAULT_FORMAT   = '{0}'

        # initialize.
        scope.items    = scope.items or []
        scope.selected = scope.selected or []
        scope.result   = []
        scope.format   = attrs.format or DEFAULT_FORMAT
        scope.order    = attrs.orderby or ''
        scope.listMax  = LIST_MAX_INITIAL

        # focus positon on dropdown contents.
        scope.focusIndex = 0

        ###
         escape Regex special characters.
        ###
        escapeRegExp = (str) ->
          return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

        ###
         format string
        ###
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

        ###
         filtering list.
        ###
        scope.itemFilter = (items) ->
          return [] if not items? or items.length is 0
          if not scope.keyword
            end = if items.length < scope.listMax then items.length else scope.listMax
            return items.slice(0, end)

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
            if isMatch and filteredItems.length < scope.listMax
              filteredItems.push item

          return filteredItems

        ###
         on focus to input, select all words.
        ###
        element[0].querySelector('input').onfocus = () ->
          this.select()

        ###
         on blur from input, reset state.
        ###
        scope.onBlur = () ->
          if not scope.keyword
            scope.selected[0] = undefined
          scope.listMax = LIST_MAX_INITIAL

        ###
         on click contents, select item and update input field.
        ###
        scope.onClickItem = (item) ->
          scope.selected[0] = item
          scope.keyword = scope.$format(scope.format, item)

        ###
         Keydown event on input fileld.
          - move focus on items (up and down).
          - confirm item selection (enter).
        ###
        scope.onKeydown = (keycode) ->
          if keycode is KEY_ENTER then confirm()
          else if keycode is KEY_DOWN then scope.focusIndex++
          else if keycode is KEY_UP then scope.focusIndex--
          if scope.focusIndex < 0
            scope.focusIndex = 0
          if scope.focusIndex >= scope.result.length
            scope.focusIndex = scope.result.length - 1

        ###
         confirm selection by focused item.
        ###
        confirm = () ->
          tmpSelected = scope.result[scope.focusIndex]
          scope.keyword = scope.$format(scope.format, tmpSelected) if tmpSelected
          scope.selected[0] = tmpSelected

        ###
         on mouseover last item, load more items.
        ###
        scope.onMouseover = () ->
          scope.listMax += 100

        ###
         on mouseover last item, update focus index.
        ###
        scope.onMouseoverItem = (index) ->
          scope.focusIndex = index

        ###
         Update selection if result changed.
        ###
        scope.$watch 'result.length', () ->
          scope.focusIndex = 0

    }
