angular.module('uz', []).directive('uzDropdown', [
  '$timeout',
  function ($timeout) {
    return {
      restrict: 'E',
      template: '<div class=\'dropdown\'>' + '<input tabindex=\'0\'' + 'class=\'dropdown-text dropdown-toggle\'' + 'ng-model=\'keyword\'' + 'placeholder=\'{{placeholder}}\'' + 'ng-keydown=\'onKeydown($event.keyCode)\'></input>' + '<div class=\'dropdown-box\'><ul class=\'dropdown-content\'>' + '<li ng-repeat=\'item in result = (items | filter:itemFilter)\'' + 'ng-click=\'onClickItem(item)\'' + 'ng-class=\'{active: item === selected[0]}\'>' + '<a><span>{{$eval($parent.format)}}</span></a>' + '</li></ul></div>',
      scope: {
        items: '=',
        selected: '=',
        placeholder: '@'
      },
      link: function (scope, element, attrs) {
        var KEY_DOWN, KEY_ENTER, KEY_UP, SPLIT_SPACE, escapeRegExp, _searchRegex, _selectIndex;
        KEY_ENTER = 13;
        KEY_UP = 38;
        KEY_DOWN = 40;
        SPLIT_SPACE = ' ';
        _selectIndex = 0;
        _searchRegex = {};
        escapeRegExp = function (str) {
          return str.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, '\\$&');
        };
        scope.keyword = '';
        scope.result = [];
        scope.format = attrs.format || 'item.text';
        scope.selectedFormat = attrs.selectedFormat || 'selected[0].text';
        /*
       filtering list
      */
        scope.itemFilter = function (item) {
          var isMatch, k, keywords, reg, target, _i, _j, _len, _len1, _ref;
          if (!_searchRegex[scope.keyword]) {
            _searchRegex = {};
            _searchRegex[scope.keyword] = [];
            keywords = scope.keyword.split(SPLIT_SPACE);
            for (_i = 0, _len = keywords.length; _i < _len; _i++) {
              k = keywords[_i];
              _searchRegex[scope.keyword].push(new RegExp(escapeRegExp(k), ['i']));
            }
          }
          target = eval(scope.format);
          isMatch = true;
          _ref = _searchRegex[scope.keyword];
          for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
            reg = _ref[_j];
            isMatch &= reg.test(target);
          }
          return isMatch;
        };
        /*
       on focus input, select all words.
      */
        element[0].querySelector('input').onfocus = function () {
          return this.select();
        };
        /*
       on click contents, select item and update input field.
      */
        scope.onClickItem = function (item) {
          scope.selected[0] = item;
          return scope.keyword = eval('scope.' + scope.selectedFormat);
        };
        /*
       Keydown event on input fileld.
        - select item (up and down).
        - confirm item selection (enter).
      */
        scope.onKeydown = function (keycode) {
          var tmpSelected;
          if (keycode === KEY_ENTER) {
            scope.keyword = eval('scope.' + scope.selectedFormat);
            tmpSelected = scope.result[_selectIndex];
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
          return $timeout(function () {
            return scope.selected[0] = tmpSelected;
          });
        };
        /*
       Update selection if result changed.
      */
        return scope.$watch('result.length', function () {
          _selectIndex = 0;
          return $timeout(function () {
            return scope.selected[0] = scope.result[_selectIndex];
          });
        });
      }
    };
  }
]);