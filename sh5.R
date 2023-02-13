library(tidyverse)
library(shiny)
library(shinyjs)
library(shinyWidgets)
library(DT)
library(shinycssloaders)
library(shinydashboard)

con <- dbConnect(MariaDB(),
                   host="localhost",
                   user="root",
                   password="root123",
                   db="reviews"
)



### UI ####

ui <- dashboardPage(
  dashboardHeader(
    title = "KNOWABLE"),
  dashboardSidebar(sidebarMenu(
    menuItem("Analysis", tabName = "tab1"),
    menuItem("How does it work", tabName = "tab2"),
    menuItem("Contact us", tabName = "tab3")
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1",
              h1("KNOWABLE", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center'),
              h4("Get clarity with Knowable", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center'),
              br(),
              fluidPage(
                div(
                  id = "domain-text",
                  style = 'display:flex; align-items:center; justify-content:center',
                  textInput("domain", label = NULL, placeholder = "Enter a domain"),
                  tags$style("#domain_text{
                    color: #FAA916;
                    font-size: 15px;}")),
                br(),
                div(style = 'color: #FAA916; border-color: #FAA916; display:flex; align-items:center; justify-content:center',
                    actionButton("submit", "Run Analysis", icon("code")))
              )),
      tabItem(tabName = "tab2",
              h1("How does it work", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center'),
              h4("Lorem ipsum dolor sit amet. Est itaque ipsam sit inventore pariatur non doloremque ullam et minus totam a adipisci optio. Quo veniam rerum ex quibusdam perspiciatis a officia molestiae. Sed officia culpa ut voluptas facere ex nostrum iure est dolorem optio non laborum dolorem sed totam repellendus aut voluptas rerum. Aut rerum eveniet id eligendi provident eum quia quasi sit voluptates veritatis ab voluptatem consequatur. </p><p>Quo aperiam ullam qui molestiae aliquid ut perspiciatis fugit in deserunt eaque quo vitae nesciunt id sunt possimus ad rerum ipsum! Aut sunt tempora in voluptas minima vel delectus error est explicabo reprehenderit 33 necessitatibus dolorem et earum sapiente ea porro minus. </p><p>Ea officia Quis aut fugiat officiis aut perspiciatis tenetur ab quia assumenda nam nobis magni et fugit eius. Ut voluptas quae qui tempore enim et molestiae debitis non nemo deleniti aut similique dolores sed sapiente similique? Id explicabo Quis et voluptates numquam sed illo voluptatem sit dicta nobis id cupiditate sint. Ut exercitationem tempora non alias quaerat aut optio minus eos itaque suscipit qui enim odit qui consequatur earum!
          Lorem ipsum dolor sit amet. Est itaque ipsam sit inventore pariatur non doloremque ullam et minus totam a adipisci optio. Quo veniam rerum ex quibusdam perspiciatis a officia molestiae. Sed officia culpa ut voluptas facere ex nostrum iure est dolorem optio non laborum dolorem sed totam repellendus aut voluptas rerum. Aut rerum eveniet id eligendi provident eum quia quasi sit voluptates veritatis ab voluptatem consequatur. </p><p>Quo aperiam ullam qui molestiae aliquid ut perspiciatis fugit in deserunt eaque quo vitae nesciunt id sunt possimus ad rerum ipsum! Aut sunt tempora in voluptas minima vel delectus error est explicabo reprehenderit 33 necessitatibus dolorem et earum sapiente ea porro minus. </p><p>Ea officia Quis aut fugiat officiis aut perspiciatis tenetur ab quia assumenda nam nobis magni et fugit eius. Ut voluptas quae qui tempore enim et molestiae debitis non nemo deleniti aut similique dolores sed sapiente similique? Id explicabo Quis et voluptates numquam sed illo voluptatem sit dicta nobis id cupiditate sint. Ut exercitationem tempora non alias quaerat aut optio minus eos itaque suscipit qui enim odit qui consequatur earum!
          Lorem ipsum dolor sit amet. Est itaque ipsam sit inventore pariatur non doloremque ullam et minus totam a adipisci optio. Quo veniam rerum ex quibusdam perspiciatis a officia molestiae. Sed officia culpa ut voluptas facere ex nostrum iure est dolorem optio non laborum dolorem sed totam repellendus aut voluptas rerum. Aut rerum eveniet id eligendi provident eum quia quasi sit voluptates veritatis ab voluptatem consequatur. </p><p>Quo aperiam ullam qui molestiae aliquid ut perspiciatis fugit in deserunt eaque quo vitae nesciunt id sunt possimus ad rerum ipsum! Aut sunt tempora in voluptas minima vel delectus error est explicabo reprehenderit 33 necessitatibus dolorem et earum sapiente ea porro minus. </p><p>Ea officia Quis aut fugiat officiis aut perspiciatis tenetur ab quia assumenda nam nobis magni et fugit eius. Ut voluptas quae qui tempore enim et molestiae debitis non nemo deleniti aut similique dolores sed sapiente similique? Id explicabo Quis et voluptates numquam sed illo voluptatem sit dicta nobis id cupiditate sint. Ut exercitationem tempora non alias quaerat aut optio minus eos itaque suscipit qui enim odit qui consequatur earum!
          Lorem ipsum dolor sit amet. Est itaque ipsam sit inventore pariatur non doloremque ullam et minus totam a adipisci optio. Quo veniam rerum ex quibusdam perspiciatis a officia molestiae. Sed officia culpa ut voluptas facere ex nostrum iure est dolorem optio non laborum dolorem sed totam repellendus aut voluptas rerum. Aut rerum eveniet id eligendi provident eum quia quasi sit voluptates veritatis ab voluptatem consequatur. </p><p>Quo aperiam ullam qui molestiae aliquid ut perspiciatis fugit in deserunt eaque quo vitae nesciunt id sunt possimus ad rerum ipsum! Aut sunt tempora in voluptas minima vel delectus error est explicabo reprehenderit 33 necessitatibus dolorem et earum sapiente ea porro minus. </p><p>Ea officia Quis aut fugiat officiis aut perspiciatis tenetur ab quia assumenda nam nobis magni et fugit eius. Ut voluptas quae qui tempore enim et molestiae debitis non nemo deleniti aut similique dolores sed sapiente similique? Id explicabo Quis et voluptates numquam sed illo voluptatem sit dicta nobis id cupiditate sint. Ut exercitationem tempora non alias quaerat aut optio minus eos itaque suscipit qui enim odit qui consequatur earum!
          Lorem ipsum dolor sit amet. Est itaque ipsam sit inventore pariatur non doloremque ullam et minus totam a adipisci optio. Quo veniam rerum ex quibusdam perspiciatis a officia molestiae. Sed officia culpa ut voluptas facere ex nostrum iure est dolorem optio non laborum dolorem sed totam repellendus aut voluptas rerum. Aut rerum eveniet id eligendi provident eum quia quasi sit voluptates veritatis ab voluptatem consequatur. </p><p>Quo aperiam ullam qui molestiae aliquid ut perspiciatis fugit in deserunt eaque quo vitae nesciunt id sunt possimus ad rerum ipsum! Aut sunt tempora in voluptas minima vel delectus error est explicabo reprehenderit 33 necessitatibus dolorem et earum sapiente ea porro minus. </p><p>Ea officia Quis aut fugiat officiis aut perspiciatis tenetur ab quia assumenda nam nobis magni et fugit eius. Ut voluptas quae qui tempore enim et molestiae debitis non nemo deleniti aut similique dolores sed sapiente similique? Id explicabo Quis et voluptates numquam sed illo voluptatem sit dicta nobis id cupiditate sint. Ut exercitationem tempora non alias quaerat aut optio minus eos itaque suscipit qui enim odit qui consequatur earum!
          ", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center')
      ),
      tabItem(tabName = "tab3",
              h1("Contact us", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center'),
              h3("If you need help, have any questions or experience troubles, please do not hesitate contacting us", style = 'color: #dcdabc; display:flex; align-items:center; justify-content:center'),
              br(),
              div(style = 'display: flex; align-items:center; justify-content: center',
                  tags$input(type="text", id="name", placeholder="Name", class = "this.style")),
              br(),
              div(style = 'display: flex; align-items:center; justify-content: center',
                  tags$input(type="text", id="email", placeholder="Email", class = "this.style")),
              br(),
              div(style = 'display: flex; align-items:center; justify-content: center',
                  tags$input(type="textarea", id="message",placeholder = "Message", class= "this.style")),
              br(),
              div(style = 'color: #FAA916; border-color: #FAA916; display: flex; align-items:center; justify-content: center',
                  actionButton("submit2","Submit",))
      )),
    tags$style(".this.style {
             color: #FAA916;
             font-size: 16px;}"),
    tags$head(tags$style(HTML("
                           /* logo */
                             .skin-blue .main-header .logo {
                               background-color: #242325;
                               color: #FAA916;
                             }
                           
                           /* logo when hovered */
                             .skin-blue .main-header .logo:hover {
                               background-color: #242325;
                             }
                           
                           /* navbar (rest of the header) */
                             .skin-blue .main-header .navbar {
                               background-color: #242325;
                             }
                           
                           /* main sidebar */
                             .skin-blue .main-sidebar {
                               background-color: #242325;
                             }
                           
                           /* active selected tab in the sidebarmenu */
                             .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                               background-color: #FAA916;
                             }
                           
                           /* other links in the sidebarmenu */
                             .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                               background-color: #242325;
                                 color: #dcdabc;
                                 font-weight: 700;
                             }
                           
                           /* other links in the sidebarmenu when hovered */
                             .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                               background-color: #FAA916;
                             }
                           /* toggle button when hovered  */
                             .skin-blue .main-header .navbar .sidebar-toggle:hover{
                               background-color: #242325;
                             }
                           
                           /* body */
                             .content-wrapper, .right-side {
                               background-color: #242325;
                             }" ))),
    #Table outlay
    DT::dataTableOutput("demo_datatable",
                        width = "auto",
                        height = "auto"),
    list(tags$head(
      tags$style("demo_datatable span {color: White ; background: Ghostwhite;}"))),
    tags$head(tags$style("#demo_datatable table {color: White;}")),
    tags$style(HTML(".dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter, .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_processing,.dataTables_wrapper .dataTables_paginate .paginate_button, .dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
            color: Ghostwhite !important;}")),
    verbatimTextOutput("reviews", placeholder = FALSE)))






#### Define the server function ####
server <- function(input, output){
  
  # Connect to the MySql database
  #con <- dbConnect(MySQL(), user = "root", password = "root123", 
  #                 dbname = "knowable", host = "127.0.0.1")
  
  
  
  # Create a reactive expression that depends on the user's input
  # Define the function that we want to implement
  trustpilot <- function(domain) {
    url <-
      paste0("https://dk.trustpilot.com/review/",
             domain)
    #Vi definerer url'en som skal analyseres.
    #For at se hvor mange sider af reviews der skal gennemg??s, m?? vi f??rst finde antallet at reviews
    
    totalReviews <- try(read_html(url) %>%
                          html_node(".styles_header__yrrqf .typography_body-l__KUYFJ") %>%
                          html_text())
    if (inherits(totalReviews, "try-error")) {
      return("") #An error occurred while accessing the URL. Please check that the domain name is correct and try again.
    }
    totalReviews <-
      as.numeric(gsub("[^0-9]+", "", totalReviews))
    
    #Vi laver en tom variabel som senere vil v??re brugt til opfyldning af 'actual' review data
    
    reviews = data.frame()
    
    #Her bliver printet ud hvor mange sider der er
    cat("\014")
    cat(paste0(
      "The script will run on ",
      ceiling(totalReviews / 20),
      " pages!\n"
    ))
    limit = ceiling(totalReviews / 20)
    Sys.sleep(2)
    
    #Der laves et loop som g??r gennem alle siderne
    for (i in (1:limit)) {
      #p??begynder scraping
      page <- read_html(paste0(url, "?page=", i))
      
      review_card <- page %>%
        html_nodes(".styles_reviewCard__hcAvl")
      
      name <- review_card %>%
        html_nodes(".styles_consumerDetails__ZFieb .typography_appearance-default__AAY17") %>%
        html_text()
      
      #Indsamler hvor mange reviews den enkelte bruger har lavet p?? Trustpilot (er brugeren trustworthy?)
      reviewCount <- review_card %>%
        html_nodes(
          ".styles_consumerExtraDetails__fxS4S span.typography_appearance-subtle__8_H2l"
        ) %>%
        html_text() %>%
        trim()
      reviewCount <-
        as.numeric(gsub("[^0-9]", "", reviewCount))
      
      #V??rdier for stjernerne - l??ses ind som tal (digits)
      rating <- review_card %>%
        html_nodes(".styles_reviewHeader__iU9Px img") %>%
        html_attr("alt")
      rating <- as.integer(gsub(".*?([0-9]+).*", "\\1", rating))
      
      #datoerne for n??r reviewet er skrevet
      published <-
        review_card %>% html_nodes(".styles_datesWrapper__RCEKH time") %>% html_attr("datetime")  %>%
        substr(1, 10) %>%
        as.Date()
      
      #Titlen p?? reviewet
      title <- review_card %>%
        html_nodes(".link_notUnderlined__szqki .typography_appearance-default__AAY17") %>%
        html_text() %>%
        trim()
      
      #Her kan vi s?? se 'the actual review'
      content <- review_card %>%
        html_nodes(".typography_body-l__KUYFJ.typography_color-black__5LYEn") %>%
        html_text() %>%
        trim()
      
      #Her kan vi s?? se om der er nogle 'replies'
      haveReply <- html_children(review_card) %>%
        html_text()
      haveReply <-
        unlist(gregexpr("Besvarelse fra", haveReply, perl = TRUE)) > 0
      
      
      #Liste af alle 'replies'
      reply <- review_card %>%
        html_nodes(".styles_message__shHhX") %>%
        html_text() %>%
        trim()
      
      #Det her loop bruges til at finde udaf om et review har f??et et reply - hvis NA udskrives, har det ikke f??et et reply
      replies <- NULL
      k <- 1
      for (j in 1:(length(name))) {
        if (haveReply[j]) {
          replies <- c(replies, reply[k])
          k <- k + 1
        } else {
          replies <- c(replies, NA)
        }
      }
      
      
      #Respond datoer, hvis der ikke er lavet et respond s?? kommer den som NA
      respondDate <- review_card %>%
        html_nodes(".styles_replyDate__Iem0_") %>%
        html_attr("datetime") %>%
        substr(1, 10) %>%
        as.Date()
      
      replyDate <- NULL
      d <- 1
      for (j in 1:(length(name))) {
        if (haveReply[j]) {
          replyDate <- c(replyDate, respondDate[d])
          k <- k + 1
        } else {
          replyDate <- as.Date(c(replyDate, NA))
        }
      }
      
      
      #Her bygger vi dataframen der skal spytte al vores data ud
      
      tryCatch ({
        reviews = rbind(
          reviews,
          data.frame(
            name = name,
            reviewCount = reviewCount,
            rating = rating,
            published = published,
            title = title,
            content = content,
            reply = replies,
            respondDate = replyDate,
            stringsAsFactors = FALSE
          )
        )
      },
      error = function(e)  {
        print(e)
      })
      
      #Da man afslutter en funktion, laves alle faktor kolonner om til characters - ogs?? tilf??jes der et kolonne med antal af characters i reviewet
      #print(paste0(url, "?page=", i, " has been scraped"))
    }
    
    reviews <- factorToCharacter(reviews)
    reviews$contentLength <- nchar(reviews$content)
    reviews <- reviews[!duplicated(reviews),]
    
    #print(class(reviews))
    #husk at gemme reviews i en database - RmariaDB ind til SQL
    #dbwrite funktionen i mariadb - overwrite = TRUE
    
    return(reviews)
    
    # Write the data frame to the database
    tabname <- gsub("\\.","",domain)
    dbWriteTable(conn = con, value = reviews, name = tabname, overwrite = T, append = F)
    
  }
  
  # Output the result of the function to the result output area
  #output$demo_datatable <- DT::renderDataTable({
  #  input$submit
  #  Sys.sleep(1.5)
  #  trustpilot(input$domain)
  #}, options = list(pageLength = 10))
  
  # Disconnect from the database when the app is closed
  onStop(function(){
    dbDisconnect(con)
  })
}

# Create the Shiny app by calling shinyApp and passing it the UI and server functions
shinyApp(ui = ui, server = server)


