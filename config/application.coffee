###
Exports an object that defines
 all of the configuration needed by the projects'
 depended-on grunt tasks.

You can find the parent object in: node_modules/lineman/config/application.js
###

module.exports = require(process.env['LINEMAN_MAIN']).config.extend 'application',
  # Override application configuration here. Common examples follow in the comments.

  #  API Proxying
  #
  #  During development, you'll likely want to make XHR (AJAX) requests to an API on the same
  #  port as your lineman development server. By enabling the API proxy and setting the port, all
  #  requests for paths that don't match a static asset in ./generated will be forwarded to
  #  whatever service might be running on the specified port.
  #
  #  server: {
  #    apiProxy: {
  #      enabled: true,
  #      host: 'localhost',
  #      port: 3000
  #    }
  #  }

  prependTasks:
    common: ["ember_handlebars"]

  removeTasks:
    common: "handlebars"

  loadNpmTasks: ['grunt-ember-handlebars']

  ember_handlebars:
    options:
      processName: (name) -> name.match(/app\/templates\/([^.]*)/)[1]
    compile:
      files:
        "generated/template/handlebars.js": "<%= files.template.handlebars %>"

  watch:
    handlebars:
      tasks: ["ember_handlebars:compile", "concat:js"]

  aws:
    bucket: 'angular-site'

  aws_s3:
    options:
      region: 'us-east-1',
      uploadConcurrency: 5,
      downloadConcurrency: 5

  production:
    options:
      bucket: '<%= aws.bucket %>',
      mime: 'dist/assets/production/LICENCE': 'text/plain'
    files: [{action:'upload', expand: true, cwd: 'app/', src: ['**']}]

  clean_production:
    options:
      bucket: '<%= aws.bucket %>',
      debug: true
    files: [{dest: '*', action: 'delete'}]

  download_production:
    options:
      bucket: '<%= aws.bucket %>'
    files: [{dest: 'app/', cwd: 'backup/', action: 'download'}]
  secret:
    options:
      bucket: '<%= aws.bucket %>',
      access: 'private'
    files: [{expand: true, cwd: 'secret_garden/', src: ['*.key'], dest: 'secret/'}]