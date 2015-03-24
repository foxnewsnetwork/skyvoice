class Arrows
  _instanceMemberOf = (klasses, instance) ->
    isMember = true
    (isMember = isMember && (instance instanceof klass)) for klass in klasses
    
  _compose = (f, g) -> 
    new Arrows (x) ->
      g.run f.run x

  _fmap = (f,g) ->
    new Arrows (xs) ->
      f.run(xs).map (x) -> g.run x

  _fork = (f,g) ->
    new Arrows (either) ->
      if either.isGood() then f.run(either.payload) else g.run(either.payload)

  _fanin = (f,g) ->
    new Arrows (either) ->
      if either.isGood() then Arrows.good(f.run either.payload) else Arrows.evil(g.run either.payload)

  _parallel = (f,g) ->
    new Arrows (tuple) ->
      [x,y] = tuple
      [f.run(x), g.run(y)]

  _fanout = (f,g) ->
    new Arrows (x) ->
      [f.run(x), g.run(x)]

  @good = (x) -> new Arrows.Either true, x
  @evil = (x) -> new Arrows.Either false, x
  @polarize = (isGood) -> new Arrows (x) -> if isGood(x) then Arrows.good(x) else Arrows.evil(x)
  
  @classof = (thing) ->
    return "arrow" if thing instanceof Arrows
    typeof thing

  @lift = (thing) ->
    switch @classof thing
      when "arrow" then thing
      when "function" then new Arrows thing
      else new Arrows -> thing

  constructor: (func) ->
    @func = func
    throw "cannot make arrow without a function" unless @func instanceof Function

  fork: (g) -> _fork @, Arrows.lift g

  compose: (g) -> _compose @, Arrows.lift g

  fmap: (g) -> _fmap @, Arrows.lift g

  fanin: (g) -> _fanin @, Arrows.lift g

  parallel: (g) -> _parallel @, Arrows.lift g

  fanout: (g) -> _fanout @, Arrows.lift g

  run: (x) -> @func x

  rescueFrom: ->
    [errorClasses..., handler] = arguments
    unless handler?
      handler = errorClasses[0]
      errorClasses = []
    Arrows.lift (args) =>
      try
        @run args
      catch error
        if (errorClasses.length is 0) || (_instanceMemberOf errorClasses, error)
          handler error, args
        else
          throw error


Arrows.id = Arrows.lift (x) -> x
Arrows.die = Arrows.lift (x) -> throw x

class Arrows.Either
  constructor: (isgood, payload) ->
    @isgood = isgood
    @payload = payload
  isGood: -> !!@isgood
  isEvil: -> not @isGood()

`export default Arrows`