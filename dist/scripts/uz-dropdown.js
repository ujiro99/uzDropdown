/**!
  uz-dropdown 0.4.5
  https://github.com/ujiro99/uzDropdown
  License: MIT

  Copyright (C) 2014 ujiro99
*/
angular.module('uz', []).directive('uzDropdown', function () {
  return {
    restrict: 'E',
    template: '<div class=\'dropdown\'>' + '<input tabindex=\'0\'' + 'class=\'dropdown-text dropdown-toggle\'' + 'ng-model=\'keyword\'' + 'placeholder=\'{{placeholder}}\'' + 'ng-blur=\'onBlur()\'' + 'ng-keydown=\'onKeydown($event.keyCode)\'></input>' + '<div class=\'dropdown-box\'><ul class=\'dropdown-content\'>' + '<li ng-repeat=\'item in result = (itemFilter(items) | orderBy:order)\'' + 'ng-click=\'onClickItem(item)\'' + 'ng-mouseover=\'onMouseoverItem($index)\'' + 'ng-class=\'{selected: item === selected[0], focused: $index === focusIndex}\'>' + '<a><span>{{$format(format, item)}}</span></a></li>' + '<li ng-if=\'result.length == 0\'><a><span>not found ...</span></a></li>' + '<li ng-if=\'result.length >= listMax\' ng-mouseover=\'onMouseover()\'>' + '<a><span>more ...</span></a></li>' + '</ul></div>',
    scope: {
      items: '=',
      selected: '=',
      keyword: '=',
      placeholder: '@'
    },
    link: function (scope, element, attrs) {
      var DEFAULT_FORMAT, KEY_DOWN, KEY_ENTER, KEY_UP, LIST_MAX_INITIAL, SPLIT_SPACE, confirm, escapeRegExp;
      KEY_ENTER = 13;
      KEY_UP = 38;
      KEY_DOWN = 40;
      LIST_MAX_INITIAL = 100;
      SPLIT_SPACE = ' ';
      DEFAULT_FORMAT = '{0}';
      scope.items = scope.items || [];
      scope.selected = scope.selected || [];
      scope.result = [];
      scope.format = attrs.format || DEFAULT_FORMAT;
      scope.order = attrs.orderby || '';
      scope.listMax = LIST_MAX_INITIAL;
      scope.focusIndex = 0;
      /*
       escape Regex special characters.
      */
      escapeRegExp = function (str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
      };
      /*
       format string
      */
      scope.$format = function (fmtStr, obj) {
        var args, rep_fn;
        rep_fn = void 0;
        if (typeof obj === 'object') {
          rep_fn = function (m, k) {
            var key, keys, tmp, _i, _len;
            keys = k.split('.');
            tmp = obj;
            for (_i = 0, _len = keys.length; _i < _len; _i++) {
              key = keys[_i];
              tmp = tmp[key];
            }
            return tmp;
          };
        } else {
          args = arguments;
          rep_fn = function (m, k) {
            return args[parseInt(k) + 1];
          };
        }
        return fmtStr.replace(/\{(.+?)\}/g, rep_fn);
      };
      /*
       filtering list.
      */
      scope.itemFilter = function (items) {
        var end, filteredItems, i, isMatch, item, k, keywords, reg, regs, target, _i, _j, _k, _len, _len1, _len2;
        if (items == null || items.length === 0) {
          return [];
        }
        if (!scope.keyword) {
          end = items.length < scope.listMax ? items.length : scope.listMax;
          return items.slice(0, end);
        }
        regs = [];
        keywords = scope.keyword.split(SPLIT_SPACE);
        for (_i = 0, _len = keywords.length; _i < _len; _i++) {
          k = keywords[_i];
          regs.push(new RegExp(escapeRegExp(k), ['i']));
        }
        filteredItems = [];
        for (i = _j = 0, _len1 = items.length; _j < _len1; i = ++_j) {
          item = items[i];
          target = scope.$format(scope.format, item);
          isMatch = true;
          for (_k = 0, _len2 = regs.length; _k < _len2; _k++) {
            reg = regs[_k];
            isMatch &= reg.test(target);
          }
          if (isMatch && filteredItems.length < scope.listMax) {
            filteredItems.push(item);
          }
        }
        return filteredItems;
      };
      /*
       on focus to input, select all words.
      */
      element[0].querySelector('input').onfocus = function () {
        return this.select();
      };
      /*
       on blur from input, reset state.
      */
      scope.onBlur = function () {
        if (!scope.keyword) {
          scope.selected[0] = void 0;
        }
        return scope.listMax = LIST_MAX_INITIAL;
      };
      /*
       on click contents, select item and update input field.
      */
      scope.onClickItem = function (item) {
        scope.selected[0] = item;
        return scope.keyword = scope.$format(scope.format, item);
      };
      /*
       Keydown event on input fileld.
        - move focus on items (up and down).
        - confirm item selection (enter).
      */
      scope.onKeydown = function (keycode) {
        if (keycode === KEY_ENTER) {
          confirm();
        } else if (keycode === KEY_DOWN) {
          scope.focusIndex++;
        } else if (keycode === KEY_UP) {
          scope.focusIndex--;
        }
        if (scope.focusIndex < 0) {
          scope.focusIndex = 0;
        }
        if (scope.focusIndex >= scope.result.length) {
          return scope.focusIndex = scope.result.length - 1;
        }
      };
      /*
       confirm selection by focused item.
      */
      confirm = function () {
        var tmpSelected;
        tmpSelected = scope.result[scope.focusIndex];
        if (tmpSelected) {
          scope.keyword = scope.$format(scope.format, tmpSelected);
        }
        return scope.selected[0] = tmpSelected;
      };
      /*
       on mouseover last item, load more items.
      */
      scope.onMouseover = function () {
        return scope.listMax += 100;
      };
      /*
       on mouseover last item, update focus index.
      */
      scope.onMouseoverItem = function (index) {
        return scope.focusIndex = index;
      };
      /*
       Update selection if result changed.
      */
      return scope.$watch('result.length', function () {
        return scope.focusIndex = 0;
      });
    }
  };
});