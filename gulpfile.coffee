gulp = require("gulp")
coffee = require("gulp-coffee")
uglify = require("gulp-uglify")
imagemin = require("gulp-imagemin")
browserify = require("browserify")
source = require('vinyl-source-stream')
newer = require('gulp-newer')
gutil = require("gulp-util")
sass = require("gulp-ruby-sass")
autoprefixer = require("gulp-autoprefixer")
path = require("path")
bower = require('gulp-bower')
livereload = require('connect-livereload')
refresh = require('gulp-livereload')
lrserver = require('tiny-lr')()

livereloadport = 35729
paths =
  scripts: ["./assets/javascripts/**/*.coffee"]
  styles: ["./assets/stylesheets/**/*.sass", "./assets/stylesheets/**/*.scss"]
  images: ["./assets/images/**/*"]
  views: ["./views/*.jade", "./views/**/*.jade"]
  dest: "build"

gulp.task 'bower', ->
  bower().pipe gulp.dest(paths.dest)

gulp.task "scripts", ->
  dest = path.join paths.dest, "javascripts"
  bundleStream = browserify(
    entries: ["./assets/javascripts/app.coffee"]
    extenstions: [".coffee"]
  ).bundle(debug: true)

  bundleStream
    .on("error", gutil.log)
    .on('error', gutil.beep)
    .pipe(source('app.js'))
    .pipe(gulp.dest(path.join paths.dest, "javascripts"))
    .pipe(refresh(lrserver))

gulp.task "styles", ->
  dest = path.join paths.dest, "stylesheets"
  gulp.src("./assets/stylesheets/app.sass")
    .pipe(sass(sourcemap: true, compass: true))
    .on('error', gutil.log)
		.on('error', gutil.beep)
    .pipe(autoprefixer("last 1 version", "> 1%", "ie 8", "ie 7"))
    .pipe(gulp.dest(dest))
    .pipe(refresh(lrserver))

gulp.task "images", ->
  dest = path.join paths.dest, "images"
  gulp.src(paths.images)
    .pipe(newer dest)
    .pipe(imagemin optimizationLevel: 5)
    .pipe(gulp.dest(dest))
    .pipe(refresh(lrserver))

gulp.task "express", ->
  app = require("./app.coffee")
  app.use livereload(port: livereloadport)
  app.listen(4000)

gulp.task "views", ->
  dest = path.join paths.dest, "views"
  gulp.src(paths.views)
    .pipe(newer dest)
    .pipe(gulp.dest(dest))
    .pipe(refresh(lrserver))

gulp.task "watch", ->
  lrserver.listen(livereloadport)

  gulp.watch paths.scripts, ["scripts"]
  gulp.watch paths.styles, ["styles"]
  gulp.watch paths.images, ["images"]
  gulp.watch paths.views, ["views"]

gulp.task "default", [
  "bower",
  "scripts",
  "styles",
  "images",
  "views",
  "watch",
  "express"
]
