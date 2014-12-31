module.exports = (grunt) ->

  # Load plugins automatically
  require("load-grunt-tasks") grunt


  # set variables
  config =
    src: 'src',
    dist: 'dist'
    mainfile: 'uz-dropdown.js'
    bower: grunt.file.readJSON("./bower.json")
    banner : '/**!\n' +
             '  uz-dropdown <%= config.bower.version %>\n' +
             '  <%= config.bower.homepage %>\n' +
             '  License: <%= config.bower.license %>\n\n' +
             '  Copyright (C) 2014 <%= config.bower.authors[0] %>\n*/'


  # configure
  grunt.initConfig

    config: config

    esteWatch:
      options:
        dirs: [
            '<%= config.src %>/coffee/**/',
            '<%= config.src %>/stylus/**/',
          ]
        livereload:
          enabled: true
          port: 35729
          extensions: ['coffee', 'styl', 'html']
      # extension settings
      coffee: (path) ->
        grunt.config 'coffee.options.bare', true
        grunt.config 'coffee.compile.files', [
          nonull: true
          expand: true
          src:  path.slice(path.indexOf('/', 4))
          cwd:  '<%= config.src %>/coffee/'
          dest: '<%= config.dist %>/scripts/'
          ext:  '.js'
        ]
        'coffee:compile'
      styl: (path) ->
        grunt.config 'stylus.options.compress', false
        grunt.config 'stylus.compile.files', [
          nonull: true
          expand: true
          src:  path.slice(path.indexOf('/', 4))
          cwd:  '<%= config.src %>/stylus/'
          dest: '<%= config.dist %>/css/'
          ext:  '.css'
        ]
        'stylus:compile'

    coffee:
      options:
        bare: true
      production:
        options:
          join: true
        files: [
          '<%= config.dist %>/scripts/<%= config.mainfile %>': [
            '<%= config.src %>/coffee/*.coffee'
          ]
        ]
      develop:
        files: [
          expand: true
          src:  ['**/*.coffee']
          cwd:  '<%= config.src %>/coffee/'
          dest: '<%= config.dist %>/scripts/'
          ext:  '.js'
        ]

    stylus:
      production:
        files: [
          expand: true
          src:  ['**/*.styl']
          cwd:  '<%= config.src %>/stylus/'
          dest: '<%= config.dist %>/css/'
          ext:  '.css'
        ]
      develop:
        options:
          compress: false
        files: [
          expand: true
          src:  ['**/*.styl']
          cwd:  '<%= config.src %>/stylus/'
          dest: '<%= config.dist %>/css/'
          ext:  '.css'
        ]

    bower:
      install:
        options:
          targetDir: 'bower_components/'
          install: true
          verbose: true
          cleanTargetDir: false
          cleanBowerDir: false

    ngmin:
      production:
        src:  '<%= config.dist %>/scripts/<%= config.mainfile %>'
        dest: '<%= config.dist %>/scripts/<%= config.mainfile %>'

    uglify:
      production:
        src:  '<%= config.dist %>/scripts/<%= config.mainfile %>'
        dest: '<%= config.dist %>/scripts/uz-dropdown.min.js'

     cssmin:
      minify:
        expand: true
        src:  '*.css'
        cwd:  '<%= config.dist %>/css/'
        dest: '<%= config.dist %>/css/'
        ext:  '.min.css'

    # Empties folders to start fresh
    clean:
      dist:
        files: [
          dot: true
          src: ["<%= config.dist %>/*"]

    usebanner:
      options:
        banner: config.banner
      files:
        src: [
          'dist/css/uz-dropdown.*css',
          'dist/scripts/uz-dropdown.*js'
        ]

    # Excec test.
    exec:
      test: "open ./demo.html"

  # tasks
  grunt.registerTask 'watch', ['esteWatch']
  grunt.registerTask 'minify', ['ngmin', 'uglify', 'cssmin']
  grunt.registerTask 'test', ['exec:test']

  grunt.registerTask 'dev', [
    'bower:install',
    'coffee:develop',
    'stylus:develop']

  grunt.registerTask 'production', [
    'bower:install',
    'coffee:production',
    'stylus:production',
    'minify',
    'usebanner'
  ]
