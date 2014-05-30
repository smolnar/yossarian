Yossarian.EventsPaginationView = Ember.View.extend
  tagName: 'div'
  attributeBindings: ['currentPage']
  classNames: ['row']

  currentPageDidChange: (->
    $('html, body').animate(scrollTop: $('#events').offset().top - 120, 500)
  ).observes('currentPage')
