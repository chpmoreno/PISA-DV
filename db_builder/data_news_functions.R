get_google_page_urls <- function(u) {
  # read in page contents
  html <- getURL(u)
  # parse HTML into tree structure
  doc <- xmlParse(html)
  # extract the links
  links <- xpathSApply(doc, "//item/link", xmlValue)
  # free doc from memory
  free(doc)
  # clean the links
  links <- sapply(strsplit(links, split= "\\url="), function(x) x[length(x)])
  return(links)
}

google_query <- function(lang = "es", country.code = "CO", country = "Colombia") {
  country <- str_replace_all(country, " ", "%20")
  google_url <- paste0("https://news.google.com/news?hl=", lang,"&cr=country", country.code, 
                       "&q=", country, "+PISA+2012&ie=utf-8&output=rss&num=100&tbs=cdr%3A1%2Ccd_min%3A12%2F1%2F2013%2Ccd_max%3A12%2F1%2F2016")
  return(google_url)
}

#  google_result_urls <- google_query(lang = lang, country.code = country.code, country = country) %>% 
#    get_google_page_urls()

google_result_sentences <- function(google_result_urls) {
  sentences = NULL
  for(i in google_result_urls){
    doc.html = tryCatch({htmlTreeParse(i, useInternal = TRUE)}, 
                        error = function(e) NA)
    if(!is.na(doc.html)) {
      # Extract all the paragraphs (HTML tag is p, starting at
      # the root of the document). Unlist flattens the list to
      # create a character vector.
      doc.text = tryCatch({unlist(xpathApply(doc.html, '//p', xmlValue))}, 
                          error = function(e) NA)
      if(is.null(doc.text)){
        doc.text <- NA
      }
      
      if(!is.na(doc.text)) {
        # Replace all \n by spaces
        doc.text <- gsub('\\n', ' ', doc.text)
        
        # Join all the elements of the character vector into a single
        # character string, separated by spaces
        doc.text <- paste(doc.text, collapse = ' ')
        
        # join the sentences of all the news
        sentences <- c(sentences, get_sentences(doc.text))  
      }
    }
  }
  sentences_sentiment <- process_sentiment(sentences)
  return(list(sentences = sentences, sent_sent = sentences_sentiment))
}

google_result_freq <- function(lang = "en", country.code = "US", country = "United States",
                               length_freq = "100",
                               api_key = "trnsl.1.1.20161222T111612Z.ae22ce7b308587d0.42487210053207aed5d7eb02abcfac330497675c") {
  google_sentences <- google_query(lang = lang, country.code = country.code, country = country) %>% 
    get_google_page_urls() %>% google_result_sentences()
  
  google_search_corpus <- google_sentences$sentences %>% VectorSource() %>% Corpus()
  
  google_search_corpus <- tm_map(google_search_corpus, PlainTextDocument)
  
  google_search_corpus <- tm_map(google_search_corpus, removePunctuation)
  
  google_search_corpus <- tm_map(google_search_corpus, removeNumbers)
  
  google_search_corpus <- tm_map(google_search_corpus, removeWords, stopwords('english'))
  
  google_search_corpus <- tm_map(google_search_corpus, removeWords, stopwords('spanish'))
  
  freq <- rowSums(as.matrix(TermDocumentMatrix(google_search_corpus)))
  freq <- freq[!(names(freq) %in% c(stopwords('english'), stopwords("spanish"), 
                                    str_to_lower(month.name),
                                    "pisa", "oecd"))]
  freq.df <- data.frame(names = as.character(names(freq)), freq = as.numeric(freq)) %>% 
    filter(freq > 2) %>% arrange(desc(freq)) %>% slice(1:length_freq)
  
  names_translate <- NULL
  for(i in 1:nrow(freq.df)){
    names_translate <- c(names_translate,
                         translate(api_key, text = as.character(freq.df$names[i]), lang = "es-en")$text)
  }
  freq.df$translation <- names_translate
  
  return(list(freq.df = freq.df, sentence_sentiment = google_sentences$sent_sent))
}

process_sentiment <- function (rawtext, mymethod = "syuzhet") {
  chunkedtext <- data_frame(x = rawtext) %>% 
    group_by(linenumber = ceiling(row_number() / 10)) %>% 
    summarize(text = str_c(x, collapse = " "))
  mySentiment <- data.frame(cbind(linenumber = chunkedtext$linenumber, 
                                  sentiment = get_sentiment(chunkedtext$text, method = mymethod)))
  return(mySentiment)
}

plot_sentiment <- function (mySentiment) {
  g <- ggplot(data = mySentiment, 
              aes(x = linenumber, y = sentiment)) +
    geom_point(aes(colour = sentiment)) +
    scale_colour_gradient(low = "red", high = "blue") + 
    theme_bw() +
    labs(y = "Sentiment", x = "", caption = "Source: Google News.") +
    ggtitle("Sentiment Analysis PISA news")
}