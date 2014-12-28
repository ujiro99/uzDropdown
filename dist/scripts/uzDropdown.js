angular.module('uz', []).directive('uzDropdown', function($timeout) {
  return {
    restrict: 'E',
    template: "<div class='dropdown'>" + "<input tabindex='0'" + "class='dropdown-text dropdown-toggle'" + "ng-model='keyword'" + "ng-keydown='onKeydown($event.keyCode)'></input>" + "<div class='dropdown-box'><ul class='dropdown-content'>" + "<li ng-repeat='item in result = (items | filter:itemFilter)'" + "ng-click='selected[0] = item' " + "ng-class='{active: item === selected[0]}'>" + "<a><span>{{$eval($parent.format)}}</span></a>" + "</li>" + "</ul></div>",
    scope: {
      items: '=',
      selected: '=',
      itemFilter: '=filter'
    },
    link: function(scope, element, attrs) {
      var KEY_DOWN, KEY_ENTER, KEY_UP, selectIndex;
      KEY_ENTER = 13;
      KEY_UP = 38;
      KEY_DOWN = 40;
      selectIndex = 0;
      scope.format = attrs.format || "item.text";
      scope.keyword = '';
      scope.result = [];
      scope.selectedFormat = attrs.selectedFormat || "selected[0].text";
      scope.itemFilter = function(item) {
        return eval(scope.format).match(scope.keyword);
      };
      scope.onKeydown = function(keycode) {
        if (keycode === KEY_ENTER) {
          $timeout(function() {
            return angular.element(element[0].querySelector(".dropdown-toggle"))[0].blur();
          });
        } else if (keycode === KEY_DOWN) {
          selectIndex++;
        } else if (keycode === KEY_UP) {
          selectIndex--;
        }
        if (selectIndex < 0) {
          selectIndex = 0;
        }
        if (selectIndex >= scope.result.length) {
          selectIndex = scope.result.length - 1;
        }
        return $timeout(function() {
          return scope.selected[0] = scope.result[selectIndex];
        });
      };
      return element[0].querySelector(".dropdown-toggle").onblur = function() {
        return scope.keyword = eval("scope." + scope.selectedFormat);
      };
    }
  };
});
