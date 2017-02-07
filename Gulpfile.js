'use strict';

var gulp = require('gulp'),
  sass = require('gulp-sass'),
  minifycss = require('gulp-minify-css'),
  rename = require('gulp-rename'),
  less = require('gulp-less'),
  haml = require('gulp-haml');

gulp.task('sass', function() {
  gulp.src('./assets/sass/**/*.scss')
    .pipe(sass())
    .pipe(sass().on('error', sass.logError))
    .pipe(gulp.dest('./assets/css'))
    .pipe(rename('foodster.css'))
    .pipe(minifycss())
    .pipe(rename('foodster.min.css'))
    .pipe(gulp.dest('./assets/css'));
});

gulp.task('less', function() {
  return gulp.src('./assets/less/**/[^_]*.less')
    .pipe(less())
    .pipe(gulp.dest('./assets/css'))
    .pipe(minifycss())
    .pipe(rename('foodster.min.css'))
    .pipe(gulp.dest('./assets/css'));
});

gulp.task('default', function() {
  gulp.watch('./assets/sass/**/*.scss', ['sass'])
  gulp.watch('./assets/less/**/*.less', ['less']);
});
