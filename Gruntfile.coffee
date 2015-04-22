module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    coffee:
      glob_to_multiple:
        expand: true
        cwd: 'src'
        src: ['*.coffee']
        dest: 'lib'
        ext: '.js'

    coffeelint:
      options:
        max_line_length:
          level: 'ignore'

      src: ['src/**/*.coffee']
      test: ['spec/**/*.coffee']
      gruntfile: ['Gruntfile.coffee']

    shell:
      rebuild:
        command: 'npm build .'
        options:
          stdout: true
          stderr: true
          failOnError: true

      test:
        command: 'node_modules/.bin/jasmine-focused --captureExceptions --forceexit --coffee spec'
        options:
          stdout: true
          stderr: true
          failOnError: true

  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-coffeelint')
  grunt.registerTask 'clean', ->
    rm = require('rimraf').sync
    rm('lib')
    rm('build')
  grunt.registerTask('lint', ['coffeelint'])
  grunt.registerTask('default', ['lint', 'coffee', 'shell:rebuild'])
  grunt.registerTask('test', ['default', 'shell:test'])
  grunt.registerTask('prepublish', ['clean', 'coffee', 'lint', 'shell:rebuild'])
