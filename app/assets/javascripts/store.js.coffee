# http://emberjs.com/guides/models/using-the-store/

Yossarian.Store = DS.Store.extend
  adapter: '-active-model'

DS.ActiveModelAdapter.reopen
  namespace: 'api/v1'
