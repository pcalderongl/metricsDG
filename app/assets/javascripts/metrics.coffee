# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@changeEnvironmentData = (environmentType, application) ->
  jQuery.ajax
    url: '/changeEnvironmentData'
    type: 'GET'
    data: {'environment': environmentType, 'application': application}
    dataType: 'html'
    success: (data) ->
      jQuery('#versionsDiv').html data
      return
  return


# refreshPartial = ->
#   $.ajax url: 'metrics/changeEnvironmentData'
#   return
#
# $(document).ready ->
#   # will call refreshPartial every 3 seconds
#   setInterval refreshPartial, 30000
#   return
