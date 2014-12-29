uzDropdown
==========

Simple dropdown menu as a AngularJs directive.

## install

Install this component using  [Bower](http://bower.io/):

    $ bower instal uz-dropdown --save

Or [download as Zip](https://github.com/ujiro99/uzDropdown/archive/master.zip).


## Usage

1. In html, load script and css files with AngularJs.

  ```html
  <script src="../angular/angular.min.js"></script>

  <link rel="stylesheet" href="./dist/css/dropdown.css">
  <script src="./dist/scripts/uzDropdown.js"></script>
  ```

2. In javascript, inject module named `uz`, and make list data.

  ```html
  <script>
    angular.module('myApp', ['uz'])
      .controller("MainCtrl", function($scope) {
        $scope.items = ["one", "two", "three", "four"];
        $scope.selected = [];
    });
  </script>
  ```

3. Use `uz-dropdown` with list data.

  ```html
    <uz-dropdown
      items='items'
      selected='selected'
      format='item'
      selected-format='selected[0]'
      placeholder='input keyword ...'>
    </uz-dropdown>
  ```

## Options

Attribute | Options       | Default                    | Description
---       | ---           | ---                        | ---
`items`   | *Array of Object*| -                       | dropdown's list data.
`selected`|*Array of Object*|-| selected object on dropdown.
`format`  |*string*|`item.text`| In dropdown, objects will be shown using `$eval` to this value.
`selected-format`  |*string*|`selected[0].text`| In input area, objects will be shown using `$eval` to this value.
`placeholder`    | *string*      | -   | placeholder on input area.


## Development

In order to run it locally you'll need to fetch some dependencies and a basic server setup.

* Install [Bower](http://bower.io/) & [Grunt](http://gruntjs.com/):

  ```sh
  $ [sudo] npm install -g bower grunt-cli
  ```

* Install local dependencies:

  ```sh
  $ bower install && npm install
  ```

* Build source files automatically,
  and also starts liveReload server:

  ```sh
  $ grunt watch
  ```

## License

[MIT License](http://opensource.org/licenses/MIT) © ujiro99
