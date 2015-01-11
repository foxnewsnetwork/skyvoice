`import Arrows from 'fate/utils/arrows'`

module 'Arrows'

# Replace this with your real tests.
test 'it works', ->
  result = Arrows
  ok result

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