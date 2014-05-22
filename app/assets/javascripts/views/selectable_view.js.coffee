Yossarian.SelectableItemView = Ember.View.extend
  tagName: 'div'
  itemClass: (->
    'active' if @get('content') in @get('parentView.selected')
  ).property('parentView.selected.@each')

  click: (event) ->
    unless @get('parentView.action')
      Ember.warn 'You did not specify action for item click.'
    else
      @get('controller').send(@get('parentView.action'), @get('content'))

Yossarian.SelectableCollectionView = Ember.CollectionView.extend
  tagName: 'div'
  itemViewClass: Yossarian.SelectableItemView.extend()
