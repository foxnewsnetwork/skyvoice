`import Arrows from 'apiv1/utils/arrows'`
Adjectives = [
  "beautiful", 
  "ugly", 
  "stunning", 
  "Japanese", 
  "fat", 
  "overweight", 
  "hateful", 
  "lovely", 
  "black", 
  "hated", 
  "short", 
  "tall", 
  "despised", 
  "hairy", 
  "Jewish",
  "genderfluid",
  "transqueer",
  "transfatty",
]
Nouns = [
  "rabbit",
  "bunny",
  "faggot",
  "singer",
  "songwriter",
  "D-list celebrity",
  "lady", 
  "princess",
  "queer",
  "steer",
  "twink",
  "African American",
  "fatty",
  "fudge-packer",
  "horse",
  "mule",
  "boy",
  "girl",
  "person",
  "genderfluid",
  "transqueer",
  "transfat",
  "Jew",
  "Nazi",
  "SJW"
]
Articles = ["the", "a"]
Places = [
  "Angkor Wat",
  "the HAES movement",
  "the Bill and Melinda Gates Foundation",
  "Brazzers",
  "Hacker News",
  "the gay and proud",
  "pornhub fame",
  "Google M&A",
  "UC Berkeley",
  "Stanfurd",
  "the gainfully unemployed",
  "rape-me-in-the-ass state prison"
]
Actions = [
  "likes big butts and cannot lie",
  "hates small dicks",
  "eats only organic non-GMO",
  "lives in San Francisco",
  "can't take a joke",
  "demands social justice",
  "needs a privilege checking",
  "knows tfw no gf",
  "neither defecates nor urinates",
  "enjoys erotic fiction",
  "listens to audio books",
  "fears spiders and spiderman",
  "fantasizes about men"
]
Somethings = [
  "terrible herpes",
  "no sense of humor",
  "no purpose in life",
  "too much feels",
  "a sandy cat",
  "an endless chain of excuses",
  "first world problems",
  "the AIDS",
  "the ebola virus",
  "only one butt cheek",
  "love from Russia"
]
l = (x) ->
  console.log x
  x
doNothing = (noun) -> noun
ofPlace = (noun) -> [_.sample(Articles), noun, "of", _.sample(Places)].join " "
whoAction = (noun) -> [_.sample(Articles), noun, "who", _.sample(Actions)].join " "
withSomething = (noun) -> [_.sample(Articles), noun, "with", _.sample(Somethings)].join " "
Modifier = [ doNothing, ofPlace, whoAction, withSomething ]
pickAdjective = Arrows.lift -> _.sample Adjectives
pickNoun = Arrows.lift -> _.sample Nouns
prependNoun2Adj = Arrows.lift ([adj, noun]) -> adj + " " + noun
modifyPhrase = Arrows.lift (phrase) -> _.sample(Modifier) phrase
nameGeneratorProcess = Arrows.id
  .compose pickAdjective.parallel pickNoun
  .compose(prependNoun2Adj)
  .compose(modifyPhrase)

phraseBuilder = ->
  nameGeneratorProcess.run(0)

`export default phraseBuilder`
