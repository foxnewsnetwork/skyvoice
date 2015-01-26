`import Arrows from './arrows'`
 
shareRx = /https?:\/\/youtu\.be\/([a-z0-9-_=%\+]+)/i
watchRx = /https?:\/\/www\.youtube\.com\/watch\?v=([a-z0-9-_=%\+]+)/i
embedRx = /https?:\/\/www\.youtube\.com\/embed\/([a-z0-9-_=%\+]+)/i

failNull = Arrows.lift ->
looksShareLike = Arrows.lift (url) -> if shareRx.exec(url) then Arrows.good(url) else Arrows.evil(url) 
looksWatchLike = Arrows.lift (url) -> if watchRx.exec(url) then Arrows.good(url) else Arrows.evil(url)
looksEmbedLike = Arrows.lift (url) -> if embedRx.exec(url) then Arrows.good(url) else Arrows.evil(url)

stripShareId = Arrows.lift (url) -> shareRx.exec(url)[1]
stripWatchId = Arrows.lift (url) -> watchRx.exec(url)[1]
stripEmbedId = Arrows.lift (url) -> embedRx.exec(url)[1]

attemptShareStyle = looksShareLike.compose stripShareId.fork failNull
attemptWatchStyle = looksWatchLike.compose stripWatchId.fork attemptShareStyle
youtubeVideoidReader = looksEmbedLike.compose stripEmbedId.fork attemptWatchStyle

`export default youtubeVideoidReader`
