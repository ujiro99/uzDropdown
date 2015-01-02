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

  <link rel="stylesheet" href="./dist/css/uz-dropdown.css">
  <script src="./dist/scripts/uz-dropdown.js"></script>
  ```

2. In javascript, inject module named `uz`, and make list data.

  ```html
  <script>
    angular.module('myApp', ['uz'])
      .controller("MainCtrl", function($scope) {
        $scope.items = ["one", "two", "three", "four"];
        $scope.selected = [];
        $scope.keyword  = "";
    });
  </script>
  ```

3. Use `uz-dropdown` with list data.

  ```html
    <uz-dropdown
      items='items'
      selected='selected'
      format='item'
      keyword='keyword'
      placeholder='input keyword ...'>
    </uz-dropdown>
  ```

## Options

Attribute | Options       | Default                    | Description
---       | ---           | ---                        | ---
`items`   | *Array of Object*| -                       | dropdown's list data.
`selected`|*Array of Object*|-| selected object on dropdown.
`format`  |*string*|`{0}`| In dropdown, objects will be shown using this value. (*1)
`keyword` |*string*|``| Search keyword.
`orderBy` |*string*|``| Order key which is used in item's property name.
`placeholder`    | *string*      | -   | placeholder on input area.

### *1 format
Type of Item | Format | Example
---  | ---     | ---
Array| `{0}, {1}, ... {n}` | `"No.{0} {1}"`, `"No.{0} {1} ${2}"`
Object| `{key_1}, ... {key_n}` | `"No.{id} {name} ${price}"`
Object in Object| `{key_1.key_2}, ...` | `"No.{id} {param.name} ${param.price}"`


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
