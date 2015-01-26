`import youtubeVideoidReader from 'fate/utils/youtube-videoid-reader'`

module 'youtubeVideoidReader'

# Replace this with your real tests.
test 'it works', ->
  result = youtubeVideoidReader
  ok result

test 'given some youtube urls, it can strip out the video portion', ->
  url = "https://www.youtube.com/watch?v=9Z4KjRns8O0"
  vid = "9Z4KjRns8O0"
  equal youtubeVideoidReader.run(url), vid

test 'given a share url, it should work also', ->
  url = "http://youtu.be/9Z4KjRns8O0"
  vid = "9Z4KjRns8O0"
  equal youtubeVideoidReader.run(url), vid

test 'given a embed url, it should still work', ->
  url = "https://www.youtube.com/embed/kS_DvUlrukk?asdf=fasdf&stuff=more-stuff"
  vid = "kS_DvUlrukk"
  equal youtubeVideoidReader.run(url), vid

test 'given a crap url, it should be null', ->
  url = "http://www.reddit.com/r/DotA2/"
  vid = null
  equal youtubeVideoidReader.run(url), vid