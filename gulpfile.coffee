gulp = require("gulp")
uglify = require("gulp-uglify")
imagemin = require("gulp-imagemin")
browserify = require("browserify")
gutil = require("gulp-util")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
path = require("path")
browserSync  = require('browser-sync')
reload = browserSync.reload
coffeeify = require("coffeeify")
source = require('vinyl-source-stream')
uglify = require('gulp-uglify')
streamify = require('gulp-streamify')
livereload = require("gulp-livereload")

gulp.task 'browser-sync', ->
  browserSync(server: {baseDir: "./"})

paths =
  scripts: "./assets/javascripts/**/*.coffee"
  styles: "./assets/stylesheets/**/*.sass"
  images: "./assets/images/**/*"
  views: "./views/**/*.jade"
  dest: "./build/"

gulp.task "scripts", ->
  bundleStream = browserify(
    entries: ["./assets/javascripts/app.coffee"]
    debug: true
  ).bundle()

  bundleStream
    .on("error", gutil.log)
    .pipe(source("app.js"))
    .pipe(streamify(uglify()))
    .pipe(gulp.dest(path.join(paths.dest, "javascripts")))
    .pipe(livereload())

  gulp.src("./vendor/html5shiv/dist/html5shiv.min.js")
    .pipe(gulp.dest(path.join(paths.dest, "javascripts")))

gulp.task "styles", ->
  gulp.src(paths.styles)
    .pipe(sass(
      compass: true
      indentedSyntax: true
      errorLogToConsole: true
      onError: gutil.log
    ))
    .pipe(autoprefixer("last 1 version", "> 1%", "ie 8", "ie 7"))
    .on("error", gutil.log)
    .pipe(gulp.dest(path.join(paths.dest, "stylesheets")))
    .pipe(livereload())

gulp.task "images", ->
  gulp.src(paths.images)
    .pipe(imagemin(
      progressive: true
      svgoPlugins: [removeViewBox: true]
    ))
    .pipe(gulp.dest(paths.dist))
    .pipe(livereload())

gulp.task "livereload", ->
  livereload.reload()

gulp.task "watch", ->
  livereload.listen()
  gulp.watch paths.scripts, ["scripts"]
  gulp.watch paths.styles, ["styles"]
  gulp.watch paths.views, ["livereload"]

gulp.task "default", ["scripts", "styles", "watch"]
gulp.task "deploy", ["scripts", "styles"]
