server <- function(input, output, session) {
  # Variable to hold loaded data
  data_loaded <- reactiveValues(
    kleborate=NULL,
    metadata=NULL,
    mic_data=NULL
  )
  # Variable to hold selection info
  data_selected <- reactiveValues(
    rows=NA,
    species=NA,
    resistance_min=0,
    resistance_max=3,
    virulence_min=0,
    virulence_max=5
  )
  # Update row selection after user input/selection event
  compute_row_selection <- reactive({
    # Species
    v.species_selector <- data_loaded$kleborate$species %in% data_selected$species
    if ('others' %in% input$species_selector) {
      v.species_selector <- v.species_selector | (! data_loaded$kleborate$species %in% v.kpsc_names)
    }
    # Resistance
    v.res_selector_min <- data_loaded$kleborate$resistance_score >= data_selected$resistance_min
    v.res_selector_max <- data_loaded$kleborate$resistance_score <= data_selected$resistance_max
    v.res_selector <- v.res_selector_min & v.res_selector_max
    # Virulence
    v.vir_selector_min <- data_loaded$kleborate$virulence_score >= data_selected$virulence_min
    v.vir_selector_max <- data_loaded$kleborate$virulence_score <= data_selected$virulence_max
    v.vir_selector <- v.vir_selector_min & v.vir_selector_max
    # Combined
    return(v.species_selector & v.res_selector & v.vir_selector)
  })
  # Plot download UI/code
  download_modal <- function(download_button) {
    showModal(
      modalDialog(
        title='Plot download',
        fluidRow(
          column(
            6,
            numericInput('plot_dl_width', 'Width (px)', 1200),
          ),
          column(
            6,
            numericInput('plot_dl_height', 'Height (px)', 400),
          ),
        ),
        size='s',
        easyClose=TRUE,
        footer=div(
          style='margin-top: 15px',
          div(style='float: left', modalButton('Close')),
          div(style='float: right', download_button),
        ),
      )
    )
  }
  download_plot <- function(plot, s.filename) {
    # NOTE: orca requires dir change to root on macOS dev and Linux deploy
    withr::with_dir('/', orca(plot(), width=input$plot_dl_width, height=input$plot_dl_height, file=s.filename))
  }
  download_filename <- function(s.prefix, s.suffix) {
    paste0(
      s.prefix,
      '__res_',
      data_selected$resistance_min,
      '-',
      data_selected$resistance_max,
      '_vir_',
      data_selected$virulence_min,
      '-',
      data_selected$virulence_max,
      '.',
      s.suffix
    )
  }
  
  # Source sidebar code
  source('src/server_file_inputs.R', local=TRUE)
  source('src/server_sidebar_misc.R', local=TRUE)
  
  # Source tab code
  source('src/server_tab_misc.R', local=TRUE)
  source('src/server_tabs/summary_species.R', local=TRUE)
  source('src/server_tabs/genotype_st.R', local=TRUE)
  source('src/server_tabs/genotype_metadata.R', local=TRUE)
  source('src/server_tabs/convergence_st.R', local=TRUE)
  source('src/server_tabs/convergence_metadata.R', local=TRUE)
  source('src/server_tabs/ko_diversity_st.R', local=TRUE)
  source('src/server_tabs/temporal_trends.R', local=TRUE)
  source('src/server_tabs/cumulative_ko_prevalence.R', local=TRUE)
  source('src/server_tabs/mic_vs_genotypes.R', local=TRUE)
}
