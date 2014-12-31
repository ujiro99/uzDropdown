/**!
  uz-dropdown 0.4.3
  https://github.com/ujiro99/uzDropdown
  License: MIT

  Copyright (C) 2014 ujiro99
*/
angular.module('uz', []).directive('uzDropdown', function () {
  return {
    restrict: 'E',
    template: '<div class=\'dropdown\'>' + '<input tabindex=\'0\'' + 'class=\'dropdown-text dropdown-toggle\'' + 'ng-model=\'keyword\'' + 'placeholder=\'{{placeholder}}\'' + 'ng-blur=\'onBlur()\'' + 'ng-keydown=\'onKeydown($event.keyCode)\'></input>' + '<div class=\'dropdown-box\'><ul class=\'dropdown-content\'>' + '<li ng-repeat=\'item in result = itemFilter(items)\'' + 'ng-click=\'onClickItem(item)\'' + 'ng-class=\'{active: item === selected[0]}\'>' + '<a><span>{{$format(format, item)}}</span></a></li>' + '<li ng-if=\'result.length == 0\'><a><span>not found ...</span></a></li>' + '<li ng-if=\'result.length >= listMax\' ng-mouseover=\'onMouseover()\'>' + '<a><span>more ...</span></a></li>' + '</ul></div>',
    scope: {
      items: '=',
      selected: '=',
      placeholder: '@'
    },
    link: function (scope, element, attrs) {
      var DEFAULT_FORMAT, KEY_DOWN, KEY_ENTER, KEY_UP, LIST_MAX_INITIAL, SPLIT_SPACE, escapeRegExp, _selectIndex;
      KEY_ENTER = 13;
      KEY_UP = 38;
      KEY_DOWN = 40;
      LIST_MAX_INITIAL = 100;
      SPLIT_SPACE = ' ';
      DEFAULT_FORMAT = '{0}';
      _selectIndex = 0;
      scope.items = scope.items || [];
      scope.selected = scope.selected || [];
      scope.keyword = '';
      scope.result = [];
      scope.format = attrs.format || DEFAULT_FORMAT;
      scope.listMax = LIST_MAX_INITIAL;
      escapeRegExp = function (str) {
        return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
      };
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
        - select item (up and down).
        - confirm item selection (enter).
      */
      scope.onKeydown = function (keycode) {
        var tmpSelected;
        if (keycode === KEY_ENTER) {
          tmpSelected = scope.result[_selectIndex];
          if (tmpSelected) {
            scope.keyword = scope.$format(scope.format, tmpSelected);
          }
        } else if (keycode === KEY_DOWN) {
          _selectIndex++;
        } else if (keycode === KEY_UP) {
          _selectIndex--;
        }
        if (_selectIndex < 0) {
          _selectIndex = 0;
        }
        if (_selectIndex >= scope.result.length) {
          _selectIndex = scope.result.length - 1;
        }
        tmpSelected = scope.result[_selectIndex];
        return scope.selected[0] = tmpSelected;
      };
      /*
       on mouseover last item, load more items.
      */
      scope.onMouseover = function () {
        return scope.listMax += 100;
      };
      /*
       Update selection if result changed.
      */
      return scope.$watch('result.length', function () {
        _selectIndex = 0;
        return scope.selected[0] = scope.result[_selectIndex];
      });
    }
  };
});