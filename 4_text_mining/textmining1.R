#install.packages("tm")
#install.packages("wordcloud")
#install.packages("RColorBrewer")

# text mining package
library(tm)        
# wordcloud visualisation
library(wordcloud)  
library(RColorBrewer)

## documentation of the tm package:
## http://www.stats.bris.ac.uk/R/web/packages/tm/vignettes/tm.pdf


### 1.1 import data as Corpus, a way of representing text documents

## Reuters data:  http://disi.unitn.it/moschitti/corpora.htm
# Reuters21578-Apte-115Cat

# unzip zip file
unzip("./4_text_mining/data/Reuters21578-Apte-115Cat.zip", exdir="./4_text_mining/data/")

options(stringsAsFactors = FALSE)

# Trainig Data for Trade and MoneyFx categories

trade.directory <- "./4_text_mining/data/Reuters21578-Apte-115Cat/training/trade"
moneyfx.directory <- "./4_text_mining/data/Reuters21578-Apte-115Cat/training/money-fx"


?Corpus
### create corpus
# corpus <- Corpus(DirSource(directory = trade.directory, encoding = "ASCII"))
corpus <- VCorpus(DirSource(directory = moneyfx.directory, encoding = "ASCII"))

# text in elements in a vector
# corpus <- VCorpus(VectorSource(textVector))

class(corpus)

### 1.2 inspect corpus ###

# 1.2.1 concise overview
print(corpus)

# 1.2.2 more details
inspect(corpus[1:2])

# 1.2.3 - access individual documents using [[]], via position inthe corpus or via an identifier

meta(corpus[[2]])
meta(corpus[[2]],"id")


# 1.2.4 access a character representation of a document 

corpus[[1]][[1]]

# 1.2.4.1 using the inspect function to access a character representation of a document 
inspect(corpus[[1]])
class(corpus[[1]])



# 1.2.4.2 using the  as.character() function to access a character representation of a document 
as.character(corpus[[2]])
class(as.character(corpus[[2]]))
# view a series of documents as characters
lapply(corpus[1:2],as.character)



#### 2. TRANSFORMATIONS  ####
# modify the documents in it, e.g., stemming, stopword removal, etc
# done using tm_map()

corpus2 <- corpus
# 2.1 remove extra whitespace
corpus <- tm_map(corpus,stripWhitespace)

# 2.2 convert to lowercase
corpus <- tm_map(corpus,content_transformer(tolower))
inspect(corpus[[1]])

# 2.3 remove stopwords
# stopwords - words that are frequent but provide little information./174
# Some common English stop words include "I", "she'll", "the"
corpus <- tm_map(corpus,removeWords, stopwords("english"))
inspect(corpus[[1]])

# Add "word1" and "word" to the list: new_stops
# new_stops <- c("word1", "word2", stopwords("english"))
# corpus <- tm_map(corpus,removeWords, new_stops)

# 2.4 stemming
# stemming- reduce words to their word stem, base or root form
# eg. cats, catlike, and catty -> cat; fishing, fished, and fisher -> fish
corpus <- tm_map(corpus,stemDocument)
inspect(corpus[[1]])


#### 3. FILTERS #####

# 3.1 filter out documents satisfying given properties using tm_filter()


# 3.2 filter documents satisfying given properties- create indices based on selections and subset the corpus with them.
idx <- meta(corpus, "id") == '237' 
corpus[idx]


#### 4. TERM DOCUMENT MATRIX  ####

# 4.1 create term document matrix
dtm <- DocumentTermMatrix(corpus)
# inspect term document matrix - sample
inspect(dtm)

# full metrix in dense format
#as.matxix(dtm) 

#### 4.2 OPERATIONS ON TERM DOCUMENT MATRIX  ####

# 4.2.1 terms that occurs at least 5 times
findFreqTerms(dtm,5)

# 4.2.2 associations with at least 0.4 correlation with a word
findAssocs(dtm, "trade",0.4)

# 4.2.3  remove sparse terms 
# terms document matrices tend to get big. To reduce matrix size dramatically,
#   - remove sparse terms (terms occuring in a very few docs) 
# removeSparseTerms(x, sparse)
# x= Corpus, sparse = A numeric for the maximal allowed sparsity in the range from bigger zero to smaller one.

#removes those terms which have at least a 99.7% percentage of sparse (i.e., terms occurring 0 times in a document) elements.
inspect(removeSparseTerms(dtm,0.997))
inspect(dtm)
#new document term matrix with sparse terms removed
removedsparse <- removeSparseTerms(dtm,0.997)

# 4.2.4 term frequency

# counts for terms : sum of columns of document term matrix 
freq_up = colSums(as.matrix(removedsparse))
print(freq_up) # named vector of term counts

bag = as.matrix(freq_up) # convert named vector of term counts to matrix
str(bag) 

bag = sort(rowSums(bag), decreasing = T) # sort in descending order of term count
bag.df = data.frame(word = names(bag), freq = bag) # convert o to dataframe


############################
#### WORD CLOUD ####
############################
library(wordcloud) 
library(RColorBrewer)

set.seed(111)

#wordcloud(words = bag.df$word, freq = bag.df$freq, min.freq = 50,colors=brewer.pal(8, "Dark2"))
wordcloud(corpus, max.words = 50, random.order = FALSE, colors = brewer.pal(8,"Dark2"), scale = c(6, 0.5))
wordcloud(words = bag.df$word, freq = bag.df$freq, max.words = 50, random.order = FALSE, colors = brewer.pal(8,"Dark2"), scale = c(6, 0.5))

?wordcloud


############################
#### SENTIMENT ANALYSIS ####
############################

#install.packages("SentimentAnalysis")
library(SentimentAnalysis)

#analyse sentiment
#sentiment <- analyzeSentiment(text[1:100])  ## vector
sentiment <- analyzeSentiment(corpus) ## corpus

# Extract dictionary-based sentiment according to the QDAP dictionary
sentiment$SentimentQDAP

# View sentiment direction (i.e. positive, neutral and negative)
convertToDirection(sentiment$SentimentQDAP)

