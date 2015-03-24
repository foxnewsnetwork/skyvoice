
# Takes two parameters: container and app
firelink = (upstream: pu, downstream: pd) ->
  ids = []
  ids.push pu.get("id") if pu.get? and pu.get("id")?
  ids.push pu.id if pu.id?
  ids.push pd.get("id") if pd.get? and pd.get("id")?
  ids.push pd.id if pd.id?
  ids.join "~>"

initialize = (ctn, app) ->
  app.register 'util:firelink', firelink, instantiate: false

  app.inject "component:inbound-pipe", "firelink", "util:firelink"
  app.inject "component:inbound-pipe", "store", "store:main"

  app.inject "component:outbound-pipe", "firelink", "util:firelink"
  app.inject "component:outbound-pipe", "store", "store:main"

FirepipeInitializer =
  name: 'firepipe'
  initialize: initialize

`export {initialize}`
`export default FirepipeInitializer`
