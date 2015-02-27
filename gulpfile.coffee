gulp = require("gulp")
uglify = require("gulp-uglify")
browserify = require("browserify")
gutil = require("gulp-util")
sass = require("gulp-sass")
autoprefixer = require("gulp-autoprefixer")
path = require("path")
coffeeify = require("coffeeify")
source = require('vinyl-source-stream')
streamify = require('gulp-streamify')
cssmin = require('gulp-cssmin')
livereload = require("gulp-livereload")

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
  ).transform("coffeeify").bundle()

  bundleStream
    .on("error", gutil.log)
    .pipe(source("app.js"))
    .pipe(streamify(uglify()))
    .pipe(gulp.dest(path.join(paths.dest, "javascripts")))

  gulp.src("./vendor/html5shiv/dist/html5shiv.min.js")
    .pipe(gulp.dest(path.join(paths.dest, "javascripts")))

gulp.task "styles", ->
  gulp.src(paths.styles)
    .pipe(sass(
      indentedSyntax: true
      errorLogToConsole: true
      onError: gutil.log
    ))
    .pipe(autoprefixer("last 1 version", "> 1%", "ie 8", "ie 7"))
    .pipe(cssmin())
    .on("error", gutil.log)
    .pipe(gulp.dest(path.join(paths.dest, "stylesheets")))

gulp.task "livereload", ->
  livereload.reload()

gulp.task "watch", ->
  livereload.listen()
  gulp.watch paths.scripts, ["scripts", "livereload"]
  gulp.watch paths.styles, ["styles", "livereload"]
  gulp.watch paths.views, ["livereload"]

gulp.task "default", ["scripts", "styles", "watch"]
gulp.task "deploy", ["scripts", "styles"]
