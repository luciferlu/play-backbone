coffeeify = require 'coffeeify'
shim = require 'browserify-shim'

module.exports = (grunt) ->
    require('matchdep').filterDev('grunt-*').concat(['gruntacular']).forEach(grunt.loadNpmTasks)

    images_replace = (content) ->
        content.replace /url\("(\.\.\/img\/)*([^;.]+)\.(gif|png)"\)/g, 'url("../images/$2.$3")'

    conf =
        components: './components'
        javascripts: './app'
        stylesheets: './stylesheets'
        images: './assets/images'
        fonts: './assets/fonts'
        dist:
            javascripts: '../public/javascripts'
            stylesheets: '../public/stylesheets'
            images: '../public/images'
            fonts: '../public/fonts'

    # Project configuration
    grunt.initConfig
        clean:
            app: 
                src: [
                    "#{conf.dist.javascripts}"
                    "#{conf.dist.stylesheets}"
                    "../public/images"
                    "../public/font"
                    "build/app"
                    "build/lib"
                ]
                options:
                    force: true
            vendor:
                src: ["build/vendor"]

        coffee:
            compile:
                files:
                    'build/lib/me/ezycode/me.ezcode.js': 'lib/me/ezcode-*/**/*.coffee'


        browserify2:
            app:
                options:
                    expose:
                        underscore: './components/underscore/underscore.js'
                        backbone: './components/backbone/backbone.js'
                        "dustjs-linkedin": './components/dustjs-linkedin/lib/dust.js'
                        "dustjs-linkedin-helpers": './components/dustjs-linkedin-helpers/lib/dust-helpers.js'
                        q: "./components/q/q.js"
                        "me.ezcode": './build/lib/me/ezycode/me.ezcode.js'
                entry: "#{conf.javascripts}/app.coffee"
                compile: "build/app/app.js"
                debug: true
                beforeHook: (bundle)->
                  bundle.transform coffeeify
                  shim bundle,
                    jquery: 
                        path: "./components/jquery/jquery.js"
                        exports: '$'
                    bootstrap:
                        path: "build/vendor/bootstrap/bootstrap.js"
                        exports: null
                        depends: 
                            jquery: '$'
                    templates:
                        path: "build/app/templates.js"
                        exports: null
                        depends:
                            "dustjs-linkedin": "dust"
                    "jquery-ui":
                        path: "build/vendor/jquery-ui/jquery-ui.custom.js"
                        exports: null
                        depends:
                            jquery: "jQuery"
                    dynatree:
                        path: "components/dynatree/src/jquery.dynatree.js"
                        exports: null
                        depends:
                            jquery: "$"
                            "jquery-ui": "UI"

        concat:
            options:
                #define a string to put between each file in the concatenated output
                separator: ';\n\n'
            templates:
                src: ["build/app/templates/**/*.js"]
                dest: "build/app/templates.js"
                nonull: true
            bootstrap:
                src: [
                    "#{conf.components}/bootstrap/js/bootstrap-transition.js"
                    "#{conf.components}/bootstrap/js/bootstrap-alert.js"
                    "#{conf.components}/bootstrap/js/bootstrap-button.js"
                    "#{conf.components}/bootstrap/js/bootstrap-carousel.js"
                    "#{conf.components}/bootstrap/js/bootstrap-collapse.js"
                    "#{conf.components}/bootstrap/js/bootstrap-dropdown.js"
                    "#{conf.components}/bootstrap/js/bootstrap-modal.js"
                    "#{conf.components}/bootstrap/js/bootstrap-tooltip.js"
                    "#{conf.components}/bootstrap/js/bootstrap-popover.js"
                    "#{conf.components}/bootstrap/js/bootstrap-scrollspy.js"
                    "#{conf.components}/bootstrap/js/bootstrap-tab.js"
                    "#{conf.components}/bootstrap/js/bootstrap-typeahead.js"
                    "#{conf.components}/bootstrap/js/bootstrap-affix.js"
                ]
                dest: "build/vendor/bootstrap/bootstrap.js"
                nonull: true
            "jquery-ui":
                src:[
                    "components/jquery-ui/ui/jquery.ui.core.js"
                    "components/jquery-ui/ui/jquery.ui.widget.js"
                ]
                dest: "build/vendor/jquery-ui/jquery-ui.custom.js"
                nonull: true

        uglify:
            dist:
                files:
                    "build/app/app.min.js": ["build/app/app.js"]
            vendor:
                files:
                    'build/vendor/bootstrap/bootstrap.min.js': ['build/vendor/bootstrap/bootstrap.js']
                    'build/vendor/jquery-ui/jquery-ui.custom.min.js': ['build/vendor/jquery-ui/jquery-ui.custom.js']

        less:
            dev:
                options:
                    paths: [
                        'app/assets/style'
                        # "build/vendor/bootstrap/css"
                        "build/vendor/dynatree/css"
                    ]
                files:
                    'build/app/css/app.css': [
                        'app/assets/style/app.less'
                    ]
            dist:
                options:
                    paths: [
                        'app/assets/style'
                        # "build/vendor/bootstrap/css"
                        "build/vendor/dynatree/css"
                    ]
                    yuicompress: true
                files:
                    'build/app/css/app.css': [
                        'app/assets/style/app.less'
                    ]
            bootstrap:
                files: [
                    'build/vendor/bootstrap/css/bootstrap.css': 'components/bootstrap/less/bootstrap.less'
                    'build/vendor/bootstrap/css/bootstrap-responsive.css': 'components/bootstrap/less/responsive.less'
                ]

        dust:
            templates:
                files: [
                    {
                        expand: true,
                        cwd: "app/templates/"
                        src:["**/*.dust"],
                        dest:"build/app/templates",
                        ext: ".js"
                    }
                ]
                options:
                    wrapper: false
                    relative: true
                    runtime: false
        cssmin:
            bootstrap:
                files: [
                    "build/vendor/bootstrap/css/bootstrap.min.css": "build/vendor/bootstrap/css/bootstrap.css"
                    'build/vendor/bootstrap/css/bootstrap-responsive.min.css': 'build/vendor/bootstrap/css/bootstrap-responsive.css'
                ]

        copy:
            dev:
                files: [
                    "../public/javascripts/app.js": "build/app/app.js"
                    "../public/stylesheets/app.css": "build/app/css/app.css"

                    "../public/stylesheets/bootstrap.css": "build/vendor/bootstrap/css/bootstrap.css"
                    "../public/stylesheets/bootstrap-responsive.css": "build/vendor/bootstrap/css/bootstrap-responsive.css"
                    {cwd:"build/vendor/bootstrap/images/", src:"*.png", dest:"../public/images/", filter: 'isFile', expand: true}

                    {cwd:"build/vendor/font-awesome/css/", src:"*.min.css", dest:"../public/stylesheets/", filter: 'isFile', expand: true}
                    {cwd:"build/vendor/font-awesome/font/", src:"**", dest:"../public/font/", filter: 'isFile', expand: true}

                    "../public/javascripts/html5shiv.js": "components/html5shiv/dist/html5shiv.js"
                    {cwd:"build/vendor/dynatree/images/", src:"*.gif", dest:"../public/images/", filter: 'isFile', expand: true}
                ]
            dist:
                files: [
                    "../public/javascripts/app.js": "build/app/app.min.js"
                    "../public/stylesheets/app.css": "build/app/css/app.css"

                    "../public/stylesheets/bootstrap.css": "build/vendor/bootstrap/css/bootstrap.min.css"
                    "../public/stylesheets/bootstrap-responsive.css": "build/vendor/bootstrap/css/bootstrap-responsive.min.css"
                    {cwd:"build/vendor/bootstrap/images/", src:"*.png", dest:"../public/images/", filter: 'isFile', expand: true}

                    {cwd:"build/vendor/font-awesome/css/", src:"*.min.css", dest:"../public/stylesheets/", filter: 'isFile', expand: true}
                    {cwd:"build/vendor/font-awesome/font/", src:"**", dest:"../public/font/", filter: 'isFile', expand: true}

                    "../public/javascripts/html5shiv.js": "build/vendor/html5shiv/html5shiv.js"

                    {cwd:"build/vendor/dynatree/images/", src:"*.gif", dest:"../public/images/", filter: 'isFile', expand: true}
                ]
            dynatree:
                files: [
                    "build/vendor/dynatree/css/ui.dynatree.css": "components/dynatree/src/skin-vista/ui.dynatree.css"
                    {cwd:"components/dynatree/src/skin-vista/", src:"*.gif", dest:"build/vendor/dynatree/images/", filter: 'isFile', expand: true}
                ]
                options:
                    processContent: (contents, srcpath) ->
                        if srcpath[(srcpath.length-4)..] is ".css"
                            images_replace contents
                        else
                            contents
                    processContentExclude: "**/*.gif"
            bootstrap:
                files: [
                    {cwd:"components/bootstrap/img/", src:"*.png", dest:"build/vendor/bootstrap/images/", filter: 'isFile', expand: true}
                ]
                options:
                    processContent: (contents, srcpath) ->
                        if srcpath[(srcpath.length-4)..] is ".css"
                            images_replace contents
                        else
                            contents
                    processContentExclude: "**/*.png"

            'font-awesome':
                files: [
                    {cwd:"components/font-awesome/font/", src:"**", dest:"build/vendor/font-awesome/font/", filter: 'isFile', expand: true}
                    {cwd:"components/font-awesome/css/", src:"*.css", dest:"build/vendor/font-awesome/css/", filter: 'isFile', expand: true}
                ]

            html5shiv:
                files: [
                    "build/vendor/html5shiv/html5shiv.js": "components/html5shiv/dist/html5shiv.js"
                ]

        watch:
            coffee:
                files: [
                    'app/*.coffee'
                    'app/**/*.coffee'
                ]
                tasks: ['browserify2:app', 'copy:dev']
            lib:
                files: [
                    'lib/**/*.coffee'
                ]
                tasks: ['coffee', 'browserify2:app', 'copy:dev']
            dust:
                files:[
                    'app/templates/**/*.dust'
                ]
                tasks: ['dust:templates', 'concat:templates', 'browserify2:app', 'copy:dev']

    # Aliases
    grunt.registerTask 'dev', [
        'clean:app'
        'dust:templates'
        'concat:templates'
        'coffee'
        'browserify2:app'
        'less:dev'
        'copy:dev'
    ]

    grunt.registerTask 'cleanAll', [
        'clean:app'
        'clean:vendor'
    ]

    grunt.registerTask 'dist', [
        'clean:app'
        'build-vendor'
        'dust:templates'
        'concat:templates'
        'coffee'
        'browserify2:app'
        'uglify:dist'
        'less:dist'
        'copy:dist'
    ]

    grunt.registerTask 'build-vendor', [
        'clean:vendor'
        'concat:bootstrap'
        'less:bootstrap'
        'cssmin:bootstrap'
        'copy:bootstrap'
        'copy:font-awesome'
        'copy:dynatree'
        'concat:jquery-ui'
        'copy:html5shiv'
        'uglify:vendor'
    ]

    grunt.registerTask 'default', [
        'dev'
        'watch'
    ]