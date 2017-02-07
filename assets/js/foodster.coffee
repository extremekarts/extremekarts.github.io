---

---

#============================================
#Contact Map
#==============================================
loadGoogleMap = ->
  # Set mapPoint, latitude and longitude, zoom, and other info needed for Google Map
  mapPoint =
    lat: -36.9440831
    lng: 174.8787796
    zoom: 15
    infoText: "<p>82b Kerwyn Ave<br/>East Tamaki / Highbrook<br/>Auckland</p>"
    linkText: "View on Google Maps"
    mapAddress: "82 Kerwyn Ave, East Tamaki, Auckland 2013"
    icon: "assets/images/map_pin.png"

  if $("#homepage_map").length
    console.log 1
    map = undefined
    mapstyles = [stylers: [saturation: -100]]
    infoWindow = new google.maps.InfoWindow()
    pointLatLng = new google.maps.LatLng(mapPoint.lat, mapPoint.lng)

    # Define options for the Google Map
    mapOptions =
      zoom: mapPoint.zoom
      center: pointLatLng
      zoomControl: true
      panControl: false
      streetViewControl: false
      mapTypeControl: false
      overviewMapControl: false
      scrollwheel: false
      styles: mapstyles

    # Create new Google Map object for full width map section on homepage
    map = new google.maps.Map(document.getElementById("homepage_map"), mapOptions)

    marker = new google.maps.Marker(
      position: pointLatLng
      map: map
      title: mapPoint.linkText
      icon: mapPoint.icon
    )
    mapLink = "https://www.google.com/maps/preview?ll=" + mapPoint.lat + "," + mapPoint.lng + "&z=14&q=" + mapPoint.mapAddress

    # Set the info window content
    html = "<div class=\"infowin\">" + mapPoint.infoText + "<a href=\"" + mapLink + "\" target=\"_blank\">" + mapPoint.linkText + "</a>" + "</div>"

    # Add map marker
    google.maps.event.addListener marker, "mouseover", ->
      infoWindow.setContent html
      infoWindow.open map, marker
      return


    # Function for when the map marker is clicked
    google.maps.event.addListener marker, "click", ->
      window.open mapLink, "_blank"
      return

  return

#============================================
#Match height of header carousel to window height
#==============================================
matchCarouselHeight = ->
  # Adjust Header carousel .item height to same as window height
  wH = $(window).height()
  $("#hero-carousel .item").css "height", wH
  return
$ ->
  loadGoogleMap()
  $("#video").get(0).pause() unless $("#video").length is 0
  $("input,textarea").jqBootstrapValidation
    preventSubmit: true
    submitError: ($form, event, errors) ->

    submitSuccess: ($form, event) ->
      event.preventDefault()
      name = $("input#first_name1").val() + " " + $("input#last_name1").val()
      email = $("input#email1").val()
      phone = $("input#phone1").val()
      reservDate = $("input#reserv_date1").val()
      numGuests = $("input#numb_guests1").val()
      altDate = $("input#alt_reserv_date1").val()
      bookingTime = $("input#time1").val()
      message = $("textarea#message").val()
      $.ajax
        url: "././assets/php/mail/booking.php"
        type: "POST"
        data:
          name: name
          phone: phone
          email: email
          reservDate: reservDate
          numGuests: numGuests
          altDate: altDate
          bookingTime: bookingTime
          message: message

        cache: false
        success: ->
          $("#success").html "<div class='alert alert-success'>"
          $("#success > .alert-success").html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;").append "</button>"
          $("#success > .alert-success").append "<strong>Your booking has been submitted. </strong>"
          $("#success > .alert-success").append "</div>"
          $("#contactForm").trigger "reset"
          return

        error: ->
          $("#success").html "<div class='alert alert-danger'>"
          $("#success > .alert-danger").html("<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;").append "</button>"
          $("#success > .alert-danger").append "<strong>Sorry, the mail server is not responding. Please try again later!"
          $("#success > .alert-danger").append "</div>"
          $("#contactForm").trigger "reset"
          return

      return

    filter: ->
      $(this).is ":visible"

  return


#====================================================================================================
#Any JS inside $(window).load function is called when the window is ready and all assets are downloaded
#======================================================================================================
$(document).ready ->
  # Remove loading screen when window is loaded after 1.5 seconds
  setTimeout (->
    $(window).trigger "resize"
    $(".loading-screen").fadeOut() # fade out the loading-screen div

    # Play video once the page is fully loaded and loading screen is hidden
    $("#video").get(0).play() unless $("#video").length is 0
    return
  ), 1500 # 1.5 second delay so that we avoid the 'flicker' of the loading screen showing for a split second and then hiding immediately when its not needed

  return


#==================================================
#Any JS inside $(window).resize(function() runs when the window is resized
#====================================================
$(window).resize ->
  # Call the matchCarouselheight() function when the window is resized
  matchCarouselHeight()
  return


#==================================================
#Any JS inside $(window).scroll(function() runs when the window is scrolled
#====================================================
$(window).scroll ->
  if $(this).scrollTop() > 100
    $(".scroll-up").fadeIn()
  else
    $(".scroll-up").fadeOut()
  return


#==================================================
#Any JS inside $(function() runs when jQuery is ready
#====================================================
$ ->
  # Call matchCarouselHeight() function
  matchCarouselHeight()

  #Highlight the top nav as scrolling occurs
  $("body").scrollspy
    target: ".navbar-shrink"
    offset: 85


  # Smooth scrolling links - requires jQuery Easing plugin
  $("a.page-scroll").bind "click", (event) ->
    $anchor = $(this)
    if $anchor.hasClass("header-scroll")
      $("html, body").stop().animate
        scrollTop: $($anchor.attr("href")).offset().top
      , 1500, "easeInOutExpo"
    else
      $("html, body").stop().animate
        scrollTop: $($anchor.attr("href")).offset().top - 75
      , 1500, "easeInOutExpo"
    event.preventDefault()
    return


  # Call the matchCarouselHeight() function when the carousel slide.bs event is triggered
  $("#hero-carousel").on "slide.bs.carousel", ->
    matchCarouselHeight()
    return


  # Initialise WOW.js for section animation triggered when page scrolling
  new WOW().init()
  return
