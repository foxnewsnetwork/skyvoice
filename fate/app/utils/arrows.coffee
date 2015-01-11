class Arrows
  _compose = (f, g) -> 
    new Arrows (x) ->
      g.run f.run x

  _fmap = (f,g) ->
    new Arrows (xs) ->
      f.run(xs).map (x) -> g.run x
  
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

  compose: (g) -> _compose @, Arrows.lift g

  fmap: (g) -> _fmap @, Arrows.lift g

  run: (x) -> @func x

`export default Arrows`