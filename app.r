# Make sure to install new packages if you haven't already
# install.packages(c("shinydashboardPlus", "shinyBS", "cachem", "bit64", "shinyjs", "numbers", "ggplot2", "plotly", "DT", "randtests", "rmarkdown", "shinyalert", "stringr"))

library(bit64)
library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyBS)
library(numbers)
library(ggplot2)
library(plotly)
library(DT)
library(randtests)
library(rmarkdown)
library(shinyalert)
library(stringr)
library(cachem)

# --- Improved Custom Theme ---
custom_theme <- theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, color = "#2c3e50"),
    plot.subtitle = element_text(hjust = 0.5, size = 12, color = "#34495e"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#f7f7f7", color = NA),
    plot.background = element_rect(fill = "#f7f7f7", color = NA),
    text = element_text(family = "sans")
  )

# --- LCG Presets ---
lcg_presets_fa <- list(
  "سفارشی" = "Custom",
  "پیش‌فرض (خوب)" = "Good",
  "RANDU (نمونه تاریخی بد)" = "RANDU",
  "Numerical Recipes" = "NumRec",
  "glibc (مورد استفاده در GCC)" = "glibc"
)
lcg_presets_en <- list(
  "Custom" = "Custom",
  "Default (Good)" = "Good",
  "RANDU (Historically Bad)" = "RANDU",
  "Numerical Recipes" = "NumRec",
  "glibc (used by GCC)" = "glibc"
)
lcg_params <- list(
  "Good" = c(a = 101, b = 3, m = 1024),
  "RANDU" = c(a = 65539, b = 0, m = 2147483648),
  "NumRec" = c(a = 1664525, b = 1013904223, m = 4294967296),
  "glibc" = c(a = 1103515245, b = 12345, m = 2147483648)
)

# --- اصلاح اسم‌های فارسی ---
fa_translations_list <- list(
  app_title = "آزمایشگاه مولدهای اعداد تصادفی",
  sidebar_simulator = "شبیه‌ساز",
  sidebar_history = "تاریخچه",
  sidebar_about = "درباره برنامه",
  sidebar_developer = "توسعه‌دهنده",
  sidebar_support = "حمایت از پروژه",
  language_label = "زبان / Language:",
  generator_type_label = "نوع مولد:",
  generator_type_lcg = "مولد همنهشتی خطی (LCG)",
  generator_type_ms = "روش مربع میانی (تاریخی)",
  controls_title = "تنظیمات",
  preset_label = "انتخاب پیش‌فرض:",
  multiplier = "ضریب (a):",
  increment = "افزایش (b):",
  modulus = "پیمانه (m):",
  seed = "مقدار اولیه:",
  n_values = "تعداد اعداد (N):",
  generate_btn = "تولید و تحلیل",
  theory_title = "تحلیل نظری (زنده)",
  hull_dobell_check = "بررسی قضیه هال-دابل:",
  tab_summary = "خلاصه تحلیل",
  tab_gfx_2d = "نمودارهای دوبعدی",
  tab_spectral = "تحلیل طیفی",
  tab_tests = "آزمون‌های آماری",
  tab_data = "داده‌ها و دانلود",
  dist_plot_title = "نمودار توزیع",
  lag_plot_title = "نمودار تأخیر",
  acf_plot_title = "نمودار خودهمبستگی (ACF)",
  lag2_plot_title = "نمودار تأخیر-۲",
  plot_3d_title = "نمودار سه‌بعدی تأخیر",
  tests_title = "نتایج آزمون‌ها",
  chisq_test = "آزمون کای-اسکوئر برای یکنواختی",
  ks_test = "آزمون کولموگروف-اسمیرنوف (K-S)",
  runs_test = "آزمون Runs برای استقلال",
  data_title = "جدول داده‌های تولیدشده",
  download_csv = "دانلود CSV",
  download_html = "دانلود گزارش HTML",
  history_lcg_title = "دریک هنری لمر (D. H. Lehmer)",
  history_lcg_text = "دی. اچ. لمر، ریاضیدان آمریکایی بود که به خاطر کارهایش در نظریه محاسباتی اعداد شناخته می‌شود. او آزمون لوکاس-لمر برای اعداد اول مرسن را توسعه داد و به همراه پدرش، الک‌های لمر را ساخت. کارهای او در محاسبات الکترونیکی اولیه، بنیادین بود.",
  history_ms_title = "جان فون نویمان (John von Neumann)",
  history_ms_text = "جان فون نویمان، ریاضیدان مجارستانی-آمریکایی بود که سهم بزرگی در ریاضیات، فیزیک نظری، علوم کامپیوتر و آمار داشت. او چهره کلیدی در پروژه منهتن، توسعه کامپیوتر انیاک، و پایه‌گذاری نظریه بازی‌ها و اتوماتای سلولی بود.",
  about_title = "درباره این برنامه",
  about_p1 = "این یک آزمایشگاه مجازی برای تحلیل و مقایسه مولدهای اعداد شبه‌تصادفی است.",
  about_formula_desc = "این برنامه دو نوع مولد اصلی را شبیه‌سازی می‌کند:",
  how_to_use = "راهنمای استفاده:",
  about_li1 = "از منوی «نوع مولد»، الگوریتم مورد نظر (LCG یا مربع میانی) را انتخاب کنید.",
  about_li2 = "پارامترهای مربوطه (مانند مقدار اولیه و تعداد اعداد) را تنظیم نمایید.",
  about_li3 = "روی دکمه «تولید و تحلیل» کلیک کنید.",
  about_li4 = "نتایج را در تب‌های مختلف (خلاصه تحلیل، نمودارها، آزمون‌ها) بررسی کنید.",
  dev_title = "درباره توسعه‌دهنده",
  dev_name = "امیرعلی ستوتی",
  dev_bio = "دانشجوی کارشناسی آمار دانشگاه فردوسی مشهد",
  dev_goal = "هدف از ساخت برنامه:",
  dev_goal_text = "این برنامه به عنوان پروژه درس «شبیه‌سازی» طراحی و پیاده‌سازی شده است.",
  support_title = "حمایت از پروژه",
  support_text = "اگر این برنامه برای شما مفید بوده و از کار با آن لذت برده‌اید، می‌توانید با هدیه دادن یک قهوه، از توسعه و بهبود آن حمایت کنید. هر حمایتی، انگیزه‌ای بزرگ برای ادامه این مسیر است.",
  analysis_period_error = "⚠️ تحلیل نظری برای اعداد بسیار بزرگ امکان‌پذیر نیست.",
  analysis_period_ok = "✅ دوره کامل: این مولد دارای دوره تناوب کامل است.",
  analysis_period_bad = "❌ دوره ناقص: این مولد دارای دوره تناوب کامل نیست.",
  analysis_chisq_ok = "✅ یکنواختی (کای-اسکوئر): توزیع یکنواخت به نظر می‌رسد.",
  analysis_chisq_bad = "❌ عدم یکنواختی (کای-اسکوئر): توزیع یکنواخت نیست.",
  analysis_ks_ok = "✅ یکنواختی (K-S): توزیع یکنواخت به نظر می‌رسد.",
  analysis_ks_bad = "❌ عدم یکنواختی (K-S): توزیع یکنواخت نیست.",
  analysis_runs_ok = "✅ استقلال: ترتیب اعداد تصادفی است.",
  analysis_runs_bad = "❌ وابستگی: ترتیب اعداد تصادفی نیست.",
  validation_m = "پیمانه (m) باید یک عدد صحیح بزرگتر یا مساوی ۲ باشد.",
  validation_a = "ضریب (a) باید یک عدد صحیح مثبت باشد.",
  validation_b = "افزایش (b) باید یک عدد صحیح غیرمنفی باشد.",
  validation_ms_seed = "برای روش مربع میانی، مقدار اولیه باید یک عدد ۴ رقمی باشد.",
  validation_n_range = "تعداد اعداد باید بین ۱۰ تا ۵۰۰۰۰ باشد.",
  validation_seed_finite = "مقدار اولیه باید یک عدد معتبر باشد.",
  validation_m_large = "پیمانه بیش از حد بزرگ است.",
  validation_a_large = "ضریب نامعتبر یا بیش از حد بزرگ است.",
  validation_b_range = "افزایش باید بین ۰ تا m-1 باشد.",
  help_title = "راهنما",
  help_dist = "این نمودار نشان می‌دهد که اعداد تولیدشده تا چه حد به صورت یکنواخت در بازه [0, 1] پخش شده‌اند.",
  help_lag = "این نمودار هر عدد را در برابر عدد بعدی رسم می‌کند. در یک مولد خوب، نقاط باید تصادفی باشند.",
  help_acf = "این نمودار وابستگی هر عدد را با اعداد قبلی نشان می‌دهد. در یک مولد خوب، میله‌ها باید کوتاه باشند.",
  help_spectral = "تحلیل طیفی، ساختار هندسی اعداد را در ابعاد بالاتر بررسی می‌کند. مولدهای ضعیف الگوهای خطی نشان می‌دهند.",
  help_tests = "آزمون‌های آماری، یکنواختی و استقلال اعداد را ارزیابی می‌کنند. مقدار p بزرگتر از ۰.۰۵ نتیجه مطلوب است.",
  about_lcg_title = "مولد همنهشتی خطی (LCG)",
  about_ms_title = "روش مربع میانی",
  generating_data = "در حال تولید داده‌ها...",
  running_tests = "در حال اجرای آزمون‌ها..."
)

en_translations_list <- list(
  app_title = "Random Number Generator Lab",
  sidebar_simulator = "Simulator",
  sidebar_history = "History",
  sidebar_about = "About",
  sidebar_developer = "Developer",
  sidebar_support = "Support",
  language_label = "زبان / Language:",
  generator_type_label = "Generator Type:",
  generator_type_lcg = "Linear Congruential Generator (LCG)",
  generator_type_ms = "Middle-Square Method (Historical)",
  controls_title = "Controls",
  preset_label = "Choose a Preset:",
  multiplier = "Multiplier (a):",
  increment = "Increment (b):",
  modulus = "Modulus (m):",
  seed = "Seed:",
  n_values = "Number of Values (N):",
  generate_btn = "Generate & Analyze",
  theory_title = "Theoretical Analysis (Live)",
  hull_dobell_check = "Hull-Dobell Theorem Check:",
  tab_summary = "Summary Analysis",
  tab_gfx_2d = "2D Plots",
  tab_spectral = "Spectral Analysis",
  tab_tests = "Statistical Tests",
  tab_data = "Data & Download",
  dist_plot_title = "Distribution Plot",
  lag_plot_title = "Lag Plot",
  acf_plot_title = "Autocorrelation (ACF)",
  lag2_plot_title = "Lag-2 Plot",
  plot_3d_title = "3D Lag Plot",
  tests_title = "Test Results",
  chisq_test = "Chi-squared Test for Uniformity",
  ks_test = "Kolmogorov-Smirnov (K-S) Test",
  runs_test = "Runs Test for Independence",
  data_title = "Generated Data Table",
  download_csv = "Download CSV",
  download_html = "Download HTML Report",
  history_lcg_title = "D. H. Lehmer",
  history_lcg_text = "D. H. Lehmer was an American mathematician known for his work in computational number theory. He developed the Lucas–Lehmer test for Mersenne primes and, along with his father, created Lehmer sieves. His work was foundational in early electronic computing.",
  history_ms_title = "John von Neumann",
  history_ms_text = "John von Neumann was a Hungarian-American mathematician who made significant contributions to mathematics, theoretical physics, computer science, and statistics. He was a key figure in the Manhattan Project, the development of the ENIAC computer, and laid the foundations for game theory and cellular automata.",
  about_title = "About This Application",
  about_p1 = "This is a virtual laboratory for analyzing and comparing pseudo-random number generation algorithms.",
  about_formula_desc = "This application simulates two main types of generators:",
  how_to_use = "How to Use:",
  about_li1 = "From the 'Generator Type' menu, select your desired algorithm (LCG or Middle-Square).",
  about_li2 = "Set the relevant parameters (like seed and number of values).",
  about_li3 = "Click the 'Generate & Analyze' button.",
  about_li4 = "Review and compare the results across the different tabs.",
  dev_title = "About The Developer",
  dev_name = "Amirali Satvati",
  dev_bio = "B.Sc. Statistics Student at Ferdowsi University of Mashhad",
  dev_goal = "Purpose of the App:",
  dev_goal_text = "This application was designed and implemented as a project for the 'Simulation' course.",
  support_title = "Support the Project",
  support_text = "If you found this application helpful and enjoy using it, consider supporting its development and improvement by buying me a coffee. Every contribution is a great motivation to continue this journey.",
  analysis_period_error = "⚠️ Theoretical analysis not possible for such large numbers.",
  analysis_period_ok = "✅ Full Period: This generator has a full period.",
  analysis_period_bad = "❌ Not Full Period: This generator does not have a full period.",
  analysis_chisq_ok = "✅ Uniform (Chi-sq): The distribution appears uniform.",
  analysis_chisq_bad = "❌ Not Uniform (Chi-sq): The distribution is not uniform.",
  analysis_ks_ok = "✅ Uniform (K-S): The distribution appears uniform.",
  analysis_ks_bad = "❌ Not Uniform (K-S): The distribution is not uniform.",
  analysis_runs_ok = "✅ Independence: The sequence appears to be random.",
  analysis_runs_bad = "❌ Dependence: The sequence is not random.",
  validation_m = "Modulus (m) must be an integer >= 2.",
  validation_a = "Multiplier (a) must be a positive integer.",
  validation_b = "Increment (b) must be a non-negative integer.",
  validation_ms_seed = "For the Middle-Square method, the seed must be a 4-digit number.",
  validation_n_range = "Number of values must be between 10 and 50,000.",
  validation_seed_finite = "Seed must be a valid finite number.",
  validation_m_large = "Modulus is too large.",
  validation_a_large = "Multiplier is invalid or too large.",
  validation_b_range = "Increment must be between 0 and m-1.",
  help_title = "Help",
  help_dist = "This plot shows how uniformly the generated numbers are distributed over the interval [0, 1].",
  help_lag = "This plot graphs each number against the next one. For a good generator, points should be random.",
  help_acf = "This plot shows the dependency of each number on its predecessors. For a good generator, bars should be short.",
  help_spectral = "Spectral analysis examines the geometric structure of numbers in higher dimensions. Weak generators reveal linear patterns.",
  help_tests = "Statistical tests evaluate uniformity and independence. A p-value > 0.05 is a desirable result.",
  about_lcg_title = "Linear Congruential Generator (LCG)",
  about_ms_title = "Middle-Square Method",
  generating_data = "Generating data...",
  running_tests = "Running tests..."
)

# --- Setup caching ---
cache_lcg <- cachem::cache_mem(max_size = 50 * 1024^2)
cache_ms <- cachem::cache_mem(max_size = 50 * 1024^2)

# --- Upgraded UI with shinydashboard ---
ui <- dashboardPage(
  skin = "blue",
  header = dashboardHeader(
    title = tagList(
      span(class = "logo-lg", textOutput("app_title")),
      icon("flask-vial")
    )
  ),
  sidebar = dashboardSidebar(
    width = 250,
    sidebarMenu(
      id = "sidebar_tabs",
      menuItem(textOutput("sidebar_simulator"), tabName = "simulator", icon = icon("cogs")),
      menuItem(textOutput("sidebar_history"), tabName = "history", icon = icon("history")),
      menuItem(textOutput("sidebar_about"), tabName = "about", icon = icon("info-circle")),
      menuItem(textOutput("sidebar_developer"), tabName = "developer", icon = icon("user-circle")),
      menuItem(textOutput("sidebar_support"), tabName = "support", icon = icon("heart", style = "color: #e41b17;")),
      shiny::div(style = "padding: 15px;",
                 radioButtons("language", label = textOutput("language_label"),
                              choices = c("فارسی" = "fa", "English" = "en"),
                              selected = "fa", inline = TRUE)
      )
    )
  ),
  body = dashboardBody(
    useShinyjs(),
    tags$head(
      tags$style(HTML("
        @import url('https://fonts.googleapis.com/css2?family=Vazirmatn&family=Roboto:wght@300;400;700&display=swap');
        
        .right-to-left { direction: rtl; text-align: right; font-family: 'Vazirmatn', sans-serif; }
        .left-to-right { direction: ltr; text-align: left; font-family: 'Roboto', sans-serif; }

        .right-to-left .main-header .logo { float: right; font-family: 'Vazirmatn', sans-serif; }
        .right-to-left .main-sidebar { right: 0; left: auto; }
        .right-to-left .main-header .navbar { margin-left: 0; margin-right: 250px; }
        .right-to-left .content-wrapper, .right-to-left .right-side, .right-to-left .main-footer { margin-left: 0; margin-right: 250px; }
        .right-to-left .selectize-input, .right-to-left .selectize-dropdown { text-align: right !important; }
        .right-to-left .box-header .box-title { float: right; }
        .right-to-left .box.collapsible.collapsed .box-header .box-title { padding-left: 35px !important; }
        .right-to-left .col-sm-1, .right-to-left .col-sm-2, .right-to-left .col-sm-3, .right-to-left .col-sm-4, .right-to-left .col-sm-5, .right-to-left .col-sm-6, .right-to-left .col-sm-7, .right-to-left .col-sm-8, .right-to-left .col-sm-9, .right-to-left .col-sm-10, .right-to-left .col-sm-11, .right-to-left .col-sm-12 { float: right; }
        
        .left-to-right .main-header .logo { float: left; }
        .left-to-right .main-sidebar { left: 0; right: auto; }
        .left-to-right .main-header .navbar { margin-right: 0; margin-left: 250px; }
        .left-to-right .content-wrapper, .left-to-right .right-side, .left-to-right .main-footer { margin-right: 0; margin-left: 250px; }

        .profile-user-img { margin: 0 auto; width: 100px; padding: 3px; border: 3px solid #d2d6de; }
        .vazir-font { font-family: 'Vazirmatn', sans-serif !important; }
        .help-btn { margin-left: 10px; margin-right: 10px; opacity: 0.7; transition: opacity 0.3s ease; }
        .help-btn:hover { opacity: 1; }
        .btn-success { transition: all 0.3s ease; box-shadow: 0 2px 5px rgba(0,0,0,0.2); }
        .btn-success:hover { transform: scale(1.05); box-shadow: 0 4px 8px rgba(0,0,0,0.3); }
        .box { box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        #language label, .radio-inline { color: #FFFFFF !important; }
        .donation-banner { transition: transform 0.2s ease-in-out; display: inline-block; }
        .donation-banner:hover { transform: scale(1.05); }
      "))
    ),
    tabItems(
      tabItem(tabName = "simulator",
              fluidRow(
                column(width = 3,
                       box(title = textOutput("controls_title_text"), status = "primary", solidHeader = TRUE, width = NULL, collapsible = TRUE,
                           uiOutput("generator_type_ui"),
                           shiny::div(id = "lcg_controls",
                                      uiOutput("preset_selector_ui"),
                                      numericInput("a", "Multiplier (a):", value = 101),
                                      bsTooltip("a", "Multiplier 'a' for LCG. Must be > 0.", placement = "right", trigger = "hover"),
                                      numericInput("b", "Increment (b):", value = 3),
                                      bsTooltip("b", "Increment 'b' for LCG. Must be >= 0.", placement = "right", trigger = "hover"),
                                      numericInput("m", "Modulus (m):", value = 1024, min = 2),
                                      bsTooltip("m", "Modulus 'm' for LCG. Must be >= 2.", placement = "right", trigger = "hover")
                           ),
                           numericInput("seed", "Seed:", value = 1234),
                           bsTooltip("seed", "The starting value for the generator.", placement = "right", trigger = "hover"),
                           sliderInput("N", "Number of values (N):", min = 10, max = 50000, value = 1000, step = 100),
                           actionButton("generate", "Generate & Analyze", icon = icon("play-circle"), class = "btn-success btn-lg", width = "100%")
                       ),
                       shiny::div(id = "theory_box",
                                  box(title = textOutput("theory_title_text"), status = "info", solidHeader = TRUE, width = NULL, collapsible = TRUE,
                                      h5(textOutput("hull_dobell_check_text")),
                                      verbatimTextOutput("period_info")
                                  )
                       )
                ),
                column(width = 9,
                       uiOutput("main_tabs_ui")
                )
              )
      ),
      tabItem(tabName = "history", uiOutput("history_ui")),
      tabItem(tabName = "about", uiOutput("about_ui")),
      tabItem(tabName = "developer", uiOutput("developer_ui")),
      tabItem(tabName = "support", uiOutput("support_ui"))
    )
  )
)


# --- Server Logic ---
server <- function(input, output, session) {
  
  shinyjs::hide("theory_box")
  
  translations <- reactive({
    req(input$language)
    if (input$language == "fa") {
      fa_translations_list
    } else {
      en_translations_list
    }
  })
  
  observe({
    T <- translations()
    direction_class <- ifelse(input$language == "fa", "right-to-left vazir-font", "left-to-right")
    
    runjs(paste0("
      $('body').removeClass('right-to-left vazir-font left-to-right').addClass('", direction_class, "');
      $('.selectize-control').each(function() {
        if (this.selectize) {
          var currentVal = this.selectize.getValue();
          this.selectize.destroy();
          $(this).prev('select').selectize();
          if (currentVal) {
            $(this).prev('select')[0].selectize.setValue(currentVal);
          }
        }
      });
    "))
    
    output$app_title <- renderText({ T$app_title })
    output$sidebar_simulator <- renderText({ T$sidebar_simulator })
    output$sidebar_history <- renderText({ T$sidebar_history })
    output$sidebar_about <- renderText({ T$sidebar_about })
    output$sidebar_developer <- renderText({ T$sidebar_developer })
    output$sidebar_support <- renderText({ T$sidebar_support })
    output$language_label <- renderText({ T$language_label })
    
    output$controls_title_text <- renderText({ T$controls_title })
    updateNumericInput(session, "a", label = T$multiplier)
    updateNumericInput(session, "b", label = T$increment)
    updateNumericInput(session, "m", label = T$modulus)
    updateNumericInput(session, "seed", label = T$seed)
    updateSliderInput(session, "N", label = T$n_values)
    updateActionButton(session, "generate", label = T$generate_btn)
    
    output$theory_title_text <- renderText({ T$theory_title })
    output$hull_dobell_check_text <- renderText({ T$hull_dobell_check })
  })
  
  output$generator_type_ui <- renderUI({
    T <- translations()
    selectInput("generator_type", T$generator_type_label,
                choices = setNames(c("LCG", "MS"), c(T$generator_type_lcg, T$generator_type_ms)))
  })
  
  output$preset_selector_ui <- renderUI({
    T <- translations()
    choices <- if (input$language == "fa") lcg_presets_fa else lcg_presets_en
    selectInput("preset", T$preset_label, choices = choices, selected = isolate(input$preset))
  })
  
  observeEvent(input$generator_type, {
    req(input$generator_type)
    if(input$generator_type == "LCG") {
      shinyjs::show("lcg_controls")
      shinyjs::show("theory_box")
    } else {
      shinyjs::hide("lcg_controls")
      shinyjs::hide("theory_box")
    }
  }, ignoreNULL = TRUE)
  
  output$main_tabs_ui <- renderUI({
    T <- translations()
    tabBox(id = "output_tabs", width = NULL,
           tabPanel(T$tab_summary, value = "tab_summary", icon = icon("comment-dots"), uiOutput("analysis_summary")),
           tabPanel(T$tab_gfx_2d, value = "tab_gfx_2d",
                    fluidRow(
                      box(title = tagList(T$dist_plot_title, actionButton("help_dist", icon("question-circle"), class = "btn-xs help-btn")), status = "info", width = 12, solidHeader = TRUE, plotlyOutput("dist_plot", height = "350px")),
                      box(title = tagList(T$lag_plot_title, actionButton("help_lag", icon("question-circle"), class = "btn-xs help-btn")), status = "info", width = 6, solidHeader = TRUE, plotlyOutput("lag_plot", height = "300px")),
                      box(title = tagList(T$acf_plot_title, actionButton("help_acf", icon("question-circle"), class = "btn-xs help-btn")), status = "info", width = 6, solidHeader = TRUE, plotlyOutput("acf_plot", height = "300px"))
                    )
           ),
           tabPanel(T$tab_spectral, value = "tab_spectral",
                    box(title = tagList(T$plot_3d_title, actionButton("help_spectral", icon("question-circle"), class = "btn-xs help-btn")), status = "info", width = 12, solidHeader = TRUE,
                        fluidRow(
                          column(6, plotlyOutput("lag2_plot", height = "500px")),
                          column(6, plotlyOutput("plot_3d", height = "500px"))
                        )
                    )
           ),
           tabPanel(T$tab_tests, value = "tab_tests",
                    box(title = tagList(T$tests_title, actionButton("help_tests", icon("question-circle"), class = "btn-xs help-btn")), status = "warning", solidHeader = TRUE, width = NULL,
                        h4(T$chisq_test), verbatimTextOutput("chisq_test"), hr(),
                        h4(T$ks_test), verbatimTextOutput("ks_test"), hr(),
                        h4(T$runs_test), verbatimTextOutput("runs_test")
                    )
           ),
           tabPanel(T$tab_data, value = "tab_data",
                    box(title = T$data_title, status = "success", solidHeader = TRUE, width = NULL,
                        downloadButton("download_data_csv", T$download_csv),
                        downloadButton("download_report_html", T$download_html),
                        hr(),
                        DT::dataTableOutput("data_table")
                    )
           )
    )
  })
  
  observeEvent(input$preset, {
    req(input$preset)
    if (isTRUE(input$preset != "Custom") && input$preset %in% names(lcg_params)) {
      preset_params <- lcg_params[[input$preset]]
      updateNumericInput(session, "a", value = unname(preset_params[["a"]]))
      updateNumericInput(session, "b", value = unname(preset_params[["b"]]))
      updateNumericInput(session, "m", value = unname(preset_params[["m"]]))
    }
  }, ignoreNULL = TRUE, ignoreInit = TRUE)
  
  theoretical_analysis <- reactive({
    req(input$generator_type == "LCG", input$a, input$b, input$m,
        is.numeric(input$a), is.numeric(input$b), is.numeric(input$m))
    
    T <- translations()
    
    validate(
      need(input$m >= 2, T$validation_m),
      need(input$a > 0, T$validation_a),
      need(input$b >= 0, T$validation_b),
      need(input$m < 1e15, T$validation_m_large),
      need(input$a < 1e15, T$validation_a_large)
    )
    
    tryCatch({
      a <- input$a; b <- input$b; m <- input$m
      cond1 <- coprime(b, m)
      
      prime_factors_m <- if(m > 1 && m < 1e12) {
        tryCatch(unique(primeFactors(m)), error = function(e) numeric(0))
      } else {
        numeric(0)
      }
      
      cond2 <- if(length(prime_factors_m) > 0) {
        all((as.integer64(a) - 1) %% as.integer64(prime_factors_m) == 0)
      } else TRUE
      
      cond3 <- if (m %% 4 == 0) (a - 1) %% 4 == 0 else TRUE
      full_period <- cond1 && cond2 && cond3
      
      list(full_period = full_period, cond1 = cond1, cond2 = cond2, cond3 = cond3, error = NULL)
    }, error = function(e) {
      list(error = T$analysis_period_error)
    })
  }) %>% debounce(500)
  
  output$period_info <- renderText({
    res <- theoretical_analysis()
    if (!is.null(res$error)) return(res$error)
    
    T <- translations()
    result_text <- ifelse(res$full_period, 
                          if(input$language == "fa") "دوره کامل (m)" else "Full Period (m)",
                          if(input$language == "fa") "دوره ناقص" else "NOT Full Period")
    cond1_text <- paste("1. coprime(b, m):", ifelse(res$cond1, "✅", "❌"))
    cond2_text <- paste("2. a-1 divisible by primes of m:", ifelse(res$cond2, "✅", "❌"))
    cond3_text <- paste("3. a-1 divisible by 4 (if needed):", ifelse(res$cond3, "✅", "❌"))
    paste(result_text, cond1_text, cond2_text, cond3_text, sep = "\n")
  })
  
  lcg_generator <- function(a, b, m, seed, N) {
    a64 <- as.integer64(a); b64 <- as.integer64(b); m64 <- as.integer64(m)
    seed64 <- as.integer64(seed)
    x_values <- integer64(N)
    x_values[1] <- (a64 * seed64 + b64) %% m64
    for (i in 2:N) {
      x_values[i] <- (a64 * x_values[i-1] + b64) %% m64
    }
    u <- as.numeric(x_values) / as.numeric(m64)
    data.frame(x = as.numeric(x_values), u = u)
  }
  
  ms_generator <- function(seed, N){
    x_vals <- numeric(N)
    current_seed <- seed
    for (i in 1:N) {
      squared <- as.integer64(current_seed)^2
      sq_str <- format(squared, scientific = FALSE)
      sq_str <- stringr::str_pad(sq_str, 8, pad = "0", side = "left")
      current_seed <- as.numeric(substr(sq_str, 3, 6))
      x_vals[i] <- current_seed
    }
    data.frame(x = x_vals, u = x_vals / 10000)
  }
  
  memoized_lcg <- memoise::memoise(lcg_generator, cache = cache_lcg)
  memoized_ms <- memoise::memoise(ms_generator, cache = cache_ms)
  
  data_values <- eventReactive(input$generate, {
    req(input$seed, input$N)
    
    T <- translations()
    
    validate(
      need(input$N >= 10 && input$N <= 50000, T$validation_n_range),
      need(is.finite(input$seed), T$validation_seed_finite),
      need(abs(input$seed) < 1e12, T$validation_seed_finite)
    )
    
    if(isolate(input$generator_type) == "LCG") {
      validate(
        need(input$m < 1e15, T$validation_m_large),
        need(input$a < 1e15 && input$a > 0, T$validation_a_large),
        need(input$b >= 0 && input$b < input$m, T$validation_b_range)
      )
    } else {
      validate(need(is.numeric(input$seed) && nchar(as.character(abs(floor(input$seed)))) == 4, T$validation_ms_seed))
    }
    
    shinyjs::disable("generate")
    
    df <- withProgress(message = T$generating_data, value = 0, {
      if(isolate(input$generator_type) == "LCG") {
        memoized_lcg(input$a, input$b, input$m, input$seed, input$N)
      } else {
        memoized_ms(abs(floor(input$seed)), input$N)
      }
    })
    
    shinyjs::enable("generate")
    return(na.omit(df))
  })
  
  statistical_tests <- eventReactive(input$generate, {
    df <- data_values()
    req(nrow(df) > 0)
    
    T <- translations()
    
    if (length(unique(df$u)) < 2) {
      return(list(chisq_res = NULL, ks_res = NULL, runs_res = NULL))
    }
    
    withProgress(message = T$running_tests, value = 0, {
      breaks <- max(10, floor(nrow(df)/5))
      
      incProgress(1/3, detail = "Chi-squared")
      chisq_res <- tryCatch(chisq.test(table(cut(df$u, breaks = breaks))), error = function(e) NULL)
      
      incProgress(1/3, detail = "K-S")
      ks_res <- tryCatch(ks.test(df$u, "punif"), error = function(e) NULL)
      
      incProgress(1/3, detail = "Runs")
      runs_res <- tryCatch(runs.test(df$u), error = function(e) NULL)
      
      list(chisq_res = chisq_res, ks_res = ks_res, runs_res = runs_res)
    })
  }) %>% bindCache(input$generate, input$seed, input$N, input$a, input$b, input$m, input$generator_type)
  
  output$history_ui <- renderUI({
    T <- translations()
    fluidRow(
      box(title = T$history_lcg_title, status = "primary", solidHeader = TRUE, width = 6, collapsible = TRUE,
          fluidRow(
            column(width = 8, 
                   p(T$history_lcg_text)
            ),
            column(width = 4,
                   tags$figure(
                     tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/4/4d/Derrick_Henry_Lehmer_1984_%28rescanned%2C_cropped%29.jpg", 
                              style = "width:100%; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.2);"),
                     tags$figcaption(style="text-align:center; font-size: 12px;", "D. H. Lehmer")
                   )
            )
          )
      ),
      box(title = T$history_ms_title, status = "primary", solidHeader = TRUE, width = 6, collapsible = TRUE,
          fluidRow(
            column(width = 8,
                   p(T$history_ms_text)
            ),
            column(width = 4,
                   tags$figure(
                     tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/JohnvonNeumann-LosAlamos.gif/368px-JohnvonNeumann-LosAlamos.gif", 
                              style = "width:100%; border-radius: 5px; box-shadow: 0 2px 4px rgba(0,0,0,0.2);"),
                     tags$figcaption(style="text-align:center; font-size: 12px;", "John von Neumann")
                   )
            )
          )
      )
    )
  })
  
  output$about_ui <- renderUI({
    T <- translations()
    fluidRow(
      box(title = T$about_title, status = "primary", solidHeader = TRUE, width = 12,
          p(T$about_p1),
          h4(T$how_to_use),
          tags$ul(
            tags$li(T$about_li1),
            tags$li(T$about_li2),
            tags$li(T$about_li3),
            tags$li(T$about_li4)
          ),
          hr(),
          p(T$about_formula_desc),
          tags$ul(
            tags$li(tags$b("LCG: "), "X_{n+1} = (a × X_n + b) mod m"),
            tags$li(tags$b("Middle-Square: "), "Extract middle digits from X_n²")
          )
      )
    )
  })
  
  output$developer_ui <- renderUI({
    T <- translations()
    box(title = T$dev_title, status = "primary", solidHeader = TRUE, width = 6,
        tags$img(class = "profile-user-img img-responsive img-circle", src = "https://lh3.googleusercontent.com/d/1wDMr7jWsxxMAxAZHZukYIALU8VRf04L9=s220", alt = "Profile Picture"),
        h3(T$dev_name, class = "text-center"),
        p(T$dev_bio, class = "text-muted text-center"),
        hr(),
        p(tags$b(T$dev_goal), T$dev_goal_text),
        hr(),
        tags$div(class = "text-center",
                 tags$a(href = "https://www.linkedin.com/in/amirali-satvati/", target = "_blank", icon("linkedin", "fa-2x"), style="margin: 0 10px;"),
                 tags$a(href = "https://github.com/amiralisatvati", target = "_blank", icon("github", "fa-2x"), style="margin: 0 10px;")
        )
    )
  })
  
  output$support_ui <- renderUI({
    T <- translations()
    fluidRow(
      column(width = 6, offset = 3,
             box(title = T$support_title, status = "primary", solidHeader = TRUE, width = NULL,
                 p(T$support_text, style = "font-size: 16px; text-align: center;"),
                 hr(),
                 tags$div(class = "text-center",
                          HTML('<a href="https://www.coffeebede.com/amiralisatvati" target="_blank" class="donation-banner"><img class="img-fluid" src="https://coffeebede.ir/DashboardTemplateV2/app-assets/images/banner/default-yellow.svg" style="max-width: 250px;"/></a>')
                 )
             )
      )
    )
  })
  
  output$analysis_summary <- renderUI({
    req(input$generate, data_values(), statistical_tests())
    test_res <- statistical_tests()
    T <- translations()
    
    period_res <- if(isolate(input$generator_type) == "LCG") {
      theory_res <- theoretical_analysis()
      if (!is.null(theory_res$error)) list(text=T$analysis_period_error, color="red") 
      else if(isTRUE(theory_res$full_period)) list(text=T$analysis_period_ok, color="green")
      else list(text=T$analysis_period_bad, color="red")
    } else { NULL }
    
    chisq_res <- if(is.null(test_res$chisq_res) || is.na(test_res$chisq_res$p.value)) list(text="-", color="grey")
    else if(test_res$chisq_res$p.value > 0.05) list(text=T$analysis_chisq_ok, color="green")
    else list(text=T$analysis_chisq_bad, color="red")
    
    ks_res <- if(is.null(test_res$ks_res) || is.na(test_res$ks_res$p.value)) list(text="-", color="grey")
    else if(test_res$ks_res$p.value > 0.05) list(text=T$analysis_ks_ok, color="green")
    else list(text=T$analysis_ks_bad, color="red")
    
    runs_res <- if(is.null(test_res$runs_res) || is.na(test_res$runs_res$p.value)) list(text="-", color="grey")
    else if(test_res$runs_res$p.value > 0.05) list(text=T$analysis_runs_ok, color="green")
    else list(text=T$analysis_runs_bad, color="red")
    
    fluidRow(
      if(!is.null(period_res)) infoBox(if(input$language == "fa") "دوره تناوب" else "Period", period_res$text, icon = icon("sync"), color = period_res$color, width = 6),
      infoBox(if(input$language == "fa") "آزمون کای-اسکوئر" else "Chi-Squared", chisq_res$text, icon = icon("ruler-combined"), color = chisq_res$color, width = 6),
      infoBox(if(input$language == "fa") "آزمون K-S" else "K-S Test", ks_res$text, icon = icon("chart-area"), color = ks_res$color, width = 6),
      infoBox(if(input$language == "fa") "آزمون Runs" else "Runs Test", runs_res$text, icon = icon("running"), color = runs_res$color, width = 6)
    )
  })
  
  observeEvent(input$generate, {
    shinyjs::runjs("$('#output_tabs').hide().fadeIn(600);")
  })
  
  output$dist_plot <- renderPlotly({
    df <- data_values()
    p <- ggplot(df, aes(x = u)) +
      geom_histogram(aes(y = after_stat(density), text = after_stat(paste("Count:", ..count..))), 
                     binwidth = 0.1, fill = "#3498db", color="white", alpha = 0.8) +
      geom_density(color = "#e67e22", linewidth = 1.2) +
      labs(x = "Value", y = "Density") + custom_theme
    ggplotly(p, tooltip = "text")
  }) %>% bindCache(data_values())
  
  output$lag_plot <- renderPlotly({
    df <- data_values()
    lag_df <- data.frame(u_i = head(df$u, -1), u_i_plus_1 = tail(df$u, -1))
    p <- ggplot(lag_df, aes(x = u_i, y = u_i_plus_1)) +
      geom_hex(bins = 30) +
      scale_fill_viridis_c(option="C") +
      labs(x = "u[i]", y = "u[i+1]") + custom_theme
    ggplotly(p)
  }) %>% bindCache(data_values())
  
  output$lag2_plot <- renderPlotly({
    df <- data_values(); req(nrow(df) >= 3)
    T <- translations()
    lag2_df <- data.frame(u_i = head(df$u, -2), u_i_plus_2 = tail(df$u, -2))
    p <- ggplot(lag2_df, aes(x = u_i, y = u_i_plus_2)) + 
      geom_point(alpha = 0.4, color = "#2980b9", size=1) + 
      labs(title = T$lag2_plot_title, x = "u[i]", y = "u[i+2]") + custom_theme
    ggplotly(p)
  }) %>% bindCache(data_values())
  
  output$plot_3d <- renderPlotly({
    df <- data_values(); req(nrow(df) >= 3)
    df_3d <- data.frame(x = head(df$u, -2), y = df$u[2:(nrow(df)-1)], z = tail(df$u, -2))
    plot_ly(df_3d, x = ~x, y = ~y, z = ~z, type = 'scatter3d', mode = 'markers', 
            marker = list(size = 2.5, opacity = 0.7, color = ~z, colorscale = 'Viridis'))
  }) %>% bindCache(data_values())
  
  output$acf_plot <- renderPlotly({
    df <- data_values()
    req(nrow(df) > 10)
    
    if(var(df$u) == 0 || length(unique(df$u)) < 2) {
      return(plotly_empty() %>% 
               layout(title = list(text = if(input$language == "fa") "ACF: واریانس صفر" else "ACF: No variance")))
    }
    
    tryCatch({
      acf_res <- acf(df$u, plot = FALSE, lag.max = min(50, nrow(df) - 1))
      acf_df <- data.frame(lag = acf_res$lag[-1], acf = acf_res$acf[-1])
      p <- ggplot(acf_df, aes(x = lag, y = acf)) + 
        geom_segment(aes(xend=lag, yend=0), color="#2c3e50", linewidth=1.5) +
        geom_point(color="#c0392b", size=2) +
        labs(x = "Lag", y = "ACF") + custom_theme
      ggplotly(p)
    }, error = function(e) {
      plotly_empty() %>% layout(title = list(text = paste("ACF Error:", e$message)))
    })
  }) %>% bindCache(data_values())
  
  output$chisq_test <- renderPrint({ statistical_tests()$chisq_res })
  output$ks_test <- renderPrint({ statistical_tests()$ks_res })
  output$runs_test <- renderPrint({ statistical_tests()$runs_res })
  output$data_table <- DT::renderDataTable({ 
    DT::datatable(data_values(), options=list(pageLength=10, scrollX=TRUE)) 
  })
  
  observeEvent(input$help_dist, { T <- translations(); shinyalert(title = T$help_title, text = T$help_dist, type = "info") })
  observeEvent(input$help_lag, { T <- translations(); shinyalert(title = T$help_title, text = T$help_lag, type = "info") })
  observeEvent(input$help_acf, { T <- translations(); shinyalert(title = T$help_title, text = T$help_acf, type = "info") })
  observeEvent(input$help_spectral, { T <- translations(); shinyalert(title = T$help_title, text = T$help_spectral, type = "info") })
  observeEvent(input$help_tests, { T <- translations(); shinyalert(title = T$help_title, text = T$help_tests, type = "info") })
  
  output$download_data_csv <- downloadHandler(
    filename = function() { paste0("generator_data_", Sys.Date(), ".csv") },
    content = function(file) { write.csv(data_values(), file, row.names = FALSE) }
  )
  
  rmd_content_string <- '
---
title: "Generator Analysis Report"
output: html_document
params:
  data: NA
  inputs: NA
  tests: NA
  theory: NA
  T_fa: NA
  T_en: NA
  gen_type: NA
---

```{r setup, include=FALSE}
library(ggplot2); library(knitr);
custom_theme <- theme_minimal(base_size = 14) + theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
```

# `r params$T_en$app_title` / `r params$T_fa$app_title`

## `r params$T_en$controls_title` / `r params$T_fa$controls_title`
```{r, echo=FALSE}
inputs_df <- if(params$gen_type == "LCG") {
  as.data.frame(params$inputs)
} else {
  as.data.frame(list(seed = params$inputs$seed, N = params$inputs$N))
}
knitr::kable(t(inputs_df), col.names="Value")
```

## `r params$T_en$tab_summary` / `r params$T_fa$tab_summary`
```{r, echo=FALSE, results="asis"}
T_en <- params$T_en
T_fa <- params$T_fa
theory_res <- params$theory
test_res <- params$tests

if(params$gen_type == "LCG") {
  period_text_en <- if (!is.null(theory_res$error)) { T_en$analysis_period_error } else if(isTRUE(theory_res$full_period)) { T_en$analysis_period_ok } else { T_en$analysis_period_bad }
  period_text_fa <- if (!is.null(theory_res$error)) { T_fa$analysis_period_error } else if(isTRUE(theory_res$full_period)) { T_fa$analysis_period_ok } else { T_fa$analysis_period_bad }
  cat(paste0("<p><b>EN:</b> ", period_text_en, "<br><b>FA:</b> ", period_text_fa, "</p>"))
}

chisq_text_en <- if(is.null(test_res$chisq_res) || is.na(test_res$chisq_res$p.value)) {"-"} else if(test_res$chisq_res$p.value > 0.05) { T_en$analysis_chisq_ok } else { T_en$analysis_chisq_bad }
chisq_text_fa <- if(is.null(test_res$chisq_res) || is.na(test_res$chisq_res$p.value)) {"-"} else if(test_res$chisq_res$p.value > 0.05) { T_fa$analysis_chisq_ok } else { T_fa$analysis_chisq_bad }
cat(paste0("<p><b>EN:</b> ", chisq_text_en, "<br><b>FA:</b> ", chisq_text_fa, "</p>"))

ks_text_en <- if(is.null(test_res$ks_res) || is.na(test_res$ks_res$p.value)) {"-"} else if(test_res$ks_res$p.value > 0.05) { T_en$analysis_ks_ok } else { T_en$analysis_ks_bad }
ks_text_fa <- if(is.null(test_res$ks_res) || is.na(test_res$ks_res$p.value)) {"-"} else if(test_res$ks_res$p.value > 0.05) { T_fa$analysis_ks_ok } else { T_fa$analysis_ks_bad }
cat(paste0("<p><b>EN:</b> ", ks_text_en, "<br><b>FA:</b> ", ks_text_fa, "</p>"))

runs_text_en <- if(is.null(test_res$runs_res) || is.na(test_res$runs_res$p.value)) {"-"} else if(test_res$runs_res$p.value > 0.05) { T_en$analysis_runs_ok } else { T_en$analysis_runs_bad }
runs_text_fa <- if(is.null(test_res$runs_res) || is.na(test_res$runs_res$p.value)) {"-"} else if(test_res$runs_res$p.value > 0.05) { T_fa$analysis_runs_ok } else { T_fa$analysis_runs_bad }
cat(paste0("<p><b>EN:</b> ", runs_text_en, "<br><b>FA:</b> ", runs_text_fa, "</p>"))
```

## `r params$T_en$dist_plot_title` / `r params$T_fa$dist_plot_title`
```{r, echo=FALSE, warning=FALSE}
ggplot(params$data, aes(x = u)) + geom_histogram(binwidth = 0.05, fill = "#3498db", alpha=0.8) + labs(x = "Value", y = "Density") + custom_theme
```

## `r params$T_en$lag_plot_title` / `r params$T_fa$lag_plot_title`
```{r, echo=FALSE, warning=FALSE}
lag_df <- data.frame(u_i = head(params$data, -1)$u, u_i_plus_1 = tail(params$data, -1)$u)
ggplot(lag_df, aes(x = u_i, y = u_i_plus_1)) + geom_point(alpha = 0.5, color="#2980b9") + labs(x = "u[i]", y = "u[i+1]") + custom_theme
```

## `r params$T_en$data_title` / `r params$T_fa$data_title`
```{r, echo=FALSE}
knitr::kable(head(params$data, 20))
```
'

  output$download_report_html <- downloadHandler(
    filename = function() { 
      paste0("generator_report_", format(Sys.Date(), "%Y%m%d"), ".html") 
    },
    content = function(file) {
      validate(
        need(!is.null(data_values()), "No data generated"),
        need(nrow(data_values()) > 0, "Empty dataset")
      )
      
      temp_report <- file.path(tempdir(), "report.Rmd")
      writeLines(rmd_content_string, temp_report, useBytes = TRUE)
      
      safe_inputs <- list(
        a = as.numeric(isolate(input$a)),
        b = as.numeric(isolate(input$b)),
        m = as.numeric(isolate(input$m)),
        seed = as.numeric(isolate(input$seed)),
        N = as.integer(isolate(input$N))
      )
      
      params_to_pass <- list(
        data = data_values(),
        inputs = safe_inputs,
        tests = statistical_tests(),
        theory = if(isolate(input$generator_type) == "LCG") theoretical_analysis() else NULL,
        T_fa = fa_translations_list,
        T_en = en_translations_list,
        gen_type = isolate(input$generator_type)
      )
      
      tryCatch({
        rmarkdown::render(
          temp_report, output_file = file,
          params = params_to_pass,
          envir = new.env(parent = globalenv())
        )
      }, error = function(e) {
        showNotification(paste("Report generation failed:", e$message), type = "error", duration = 10)
      })
    }
  )
}

shinyApp(ui = ui, server = server)