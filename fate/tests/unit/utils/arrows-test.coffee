`import Arrows from 'fate/utils/arrows'`

module 'Arrows'

# Replace this with your real tests.
test 'it works', ->
  result = Arrows
  ok result

test 'id', ->
  nine = Arrows.id.run 9
  equal nine, 9

test 'fork', ->
  divisibleBy3 = Arrows.lift (x) -> if x%3 is 0 then Arrows.good(x) else Arrows.evil(x)
  fizzify = Arrows.lift -> "fizz"
  fizz = divisibleBy3.compose(fizzify.fork Arrows.id)
  equal fizz.run(3), "fizz"
  equal fizz.run(4), 4

test "parallel", ->
  plus1 = Arrows.lift (x) -> x + 1
  times2 = Arrows.lift (x) -> x * 2
  plus3 = Arrows.lift (x) -> x + 3
  times4 = Arrows.lift (x) -> x * 4
  par = (plus1.parallel times4).compose(times2.parallel plus3)
  actual = par.run [7,8]
  expected = [16, 35]
  equal actual.toString(), expected.toString()

test "fanout", ->
  eatsPoop = Arrows.lift (x) -> x + " eats poop"
  eatsCake = Arrows.lift (y) -> y + " eats cake"
  eats = eatsPoop.fanout eatsCake
  actual = eats.run "Bob"
  expected = ["Bob eats poop", "Bob eats cake"]
  equal actual.toString(), expected.toString()

test "rescueFrom", ->
  getFit = Arrows.lift (person) -> person + " gets fit. "
  goOnTracks = Arrows.lift (x) -> "#{x} goes on train tracks. "
  makeVid = Arrows.lift (x) -> "#{x} makes workout video. "
  hitByTrain = Arrows.lift (x) -> throw new Error("hit by train")
  makeProfit = Arrows.lift (x) -> "#{x} makes it rich"

  brightIdea = goOnTracks.compose(makeVid).compose(hitByTrain).compose(makeProfit)
  businessPlan = brightIdea.rescueFrom (error, args) ->
    equal error.message, "hit by train"
    "#{args}But makes no money"
  
  path2OneMinuteWorkout = getFit.compose(businessPlan)

  actual = path2OneMinuteWorkout.run "Greg Plitt"
  expected = "Greg Plitt gets fit. But makes no money"
  equal actual, expected

test 'polarize', ->
  decideFizz = Arrows.polarize (x) -> x % 2 is 0
  fizzify = Arrows.lift -> 'even'
  buzzify = Arrows.lift -> 'odd'
  classifier = Arrows.id.fmap decideFizz.compose fizzify.fork buzzify
  actual = classifier.run [1,2,3,4,5]
  expected = ['odd', 'even', 'odd','even','odd']
  equal actual.join("-"), expected.join("-")

test 'proper composition', ->
  four = Arrows.lift 4
  times2 = (x) -> x * 2
  plus3 = (x) -> x + 3
  minus4 = (x) -> x - 4
  sevenArrow = four.compose(times2).compose(plus3).compose(minus4)
  equal sevenArrow.run(), 7

test 'just composition', ->
  times2 = Arrows.lift (x) -> x * 2
  plus3 = (x) -> x + 3
  minus4 = (x) -> x - 4
  transform = times2.compose(plus3).compose(minus4)
  equal transform.run(0), -1

test 'fmap composition', ->
  numbers = Arrows.lift [1,2,3,4]
  minus1 = Arrows.lift (x) -> x - 1
  times2 = (x) -> x * 2
  plus3 = (x) -> x + 3
  transform = minus1.compose(times2).compose(plus3)
  ns = numbers.fmap transform
  equal ns.run().toString(), [3,5,7,9].toString()

test 'classof arrow', ->
  four = Arrows.lift 4
  equal Arrows.classof(four), "arrow"

test 'classof function', ->
  time2 = (x) -> x * 2
  equal Arrows.classof(time2), "function"

test 'lifting an arrow should do nothing', ->
  a = Arrows.lift 4
  aa = Arrows.lift a
  equal aa, a

test 'sanity test', ->
  equal [1,2,3,4].toString(), [1,2,3,4].toString()