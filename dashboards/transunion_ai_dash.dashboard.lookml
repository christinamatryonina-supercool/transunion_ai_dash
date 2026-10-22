---
# =============================================================================
# TransUnion GEO - ONE dashboard, 3 native tabs (Looker 26.4+), one shared filter bar
# - GA4: Date, AI Engine, Market, Device filter sessions AND conversions
# - Scrunch: Date, AI Engine, Market, Persona, Topic, Sentiment mode
# =============================================================================
- dashboard: transunion_ai_dash
  title: TransUnion · AI Search & GEO Performance
  description: GA4 AI referral traffic + Scrunch AI visibility · 3 tabs · one shared filter bar
  layout: newspaper
  crossfilter_enabled: true
  filters_location_top: true
  tabs:
  - name: Executive Summary
    label: Executive Summary
  - name: AI Traffic & Conversions
    label: AI Traffic & Conversions
  - name: Prompt & Persona Intelligence
    label: Prompt & Persona Intelligence
  filters:
  - name: Date Range
    title: Date Range
    type: field_filter
    default_value: 28 days
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: transunion_ai
    explore: scrunch_responses
    field: scrunch_response.period
  - name: AI Engine
    title: AI Engine
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config: &id001
      type: tag_list
      display: popover
    model: transunion_ai
    explore: ai_platform_suggest
    field: dim_ai_platform.ai_platform
  - name: Market
    title: Market
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config: *id001
    model: transunion_ai
    explore: suggest_ga4
    field: ga4_daily.country
  - name: Device (GA4)
    title: Device (GA4)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: transunion_ai
    explore: suggest_ga4
    field: ga4_daily.device_category
  - name: Persona (Scrunch)
    title: Persona (Scrunch)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config: *id001
    model: transunion_ai
    explore: suggest_scrunch
    field: scrunch_response.persona_name
  - name: Topic (Scrunch)
    title: Topic (Scrunch)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config: *id001
    model: transunion_ai
    explore: suggest_scrunch
    field: scrunch_response.primary_topic
  - name: 'Sentiment: ''none'''
    title: 'Sentiment: ''none'''
    type: field_filter
    default_value: neutral
    allow_multiple_values: false
    required: true
    ui_config:
      type: button_toggles
      display: inline
    model: transunion_ai
    explore: scrunch_responses
    field: scrunch_response.sentiment_none_mode
  elements:
  - name: exec_logo
    type: text
    title_text: ''
    body_text: '![TransUnion](https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77)'
    tab_name: Executive Summary
    row: 0
    col: 0
    width: 4
    height: 2
  - name: exec_header
    type: text
    title_text: AI Search & GEO Performance
    subtitle_text: Executive Summary · TransUnion visibility in AI answers vs competitors, and the traffic it drives
    body_text: ''
    tab_name: Executive Summary
    row: 0
    col: 4
    width: 20
    height: 2
  - name: exec_kpi_sov
    title: Share of Voice
    model: transunion_ai
    explore: scrunch_brands
    type: single_value
    fields:
    - scrunch_brand.tu_share_of_voice
    - scrunch_brand.tu_share_of_voice_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: TU mentions / all brands' mentions in AI answers
    listen:
      Date Range: scrunch_brand.period
      AI Engine: scrunch_brand.ai_platform
      Market: scrunch_brand.country
      Persona (Scrunch): scrunch_brand.persona_name
      Topic (Scrunch): scrunch_brand.primary_topic
    tab_name: Executive Summary
    row: 2
    col: 0
    width: 4
    height: 4
  - name: exec_kpi_mentions
    title: TU Mentions
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.brand_mentions
    - scrunch_response.brand_mentions_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Executive Summary
    row: 2
    col: 4
    width: 4
    height: 4
  - name: exec_kpi_citations
    title: TU Citations
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.cited_responses
    - scrunch_response.cited_responses_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: AI answers linking to transunion.com
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Executive Summary
    row: 2
    col: 8
    width: 4
    height: 4
  - name: exec_kpi_first
    title: First-Mention Rate
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.first_mention_rate
    - scrunch_response.first_mention_rate_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: TU mentions in the top part of the answer
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Executive Summary
    row: 2
    col: 12
    width: 4
    height: 4
  - name: exec_kpi_sentiment
    title: Net Sentiment
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.net_sentiment
    - scrunch_response.net_sentiment_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
      'Sentiment: ''none''': scrunch_response.sentiment_none_mode
    tab_name: Executive Summary
    row: 2
    col: 16
    width: 4
    height: 4
  - name: exec_kpi_ai_sessions
    title: AI-Referral Sessions
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.ai_sessions
    - ga4_daily.ai_sessions_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: GA4 sessions from all AI sources
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: Executive Summary
    row: 2
    col: 20
    width: 4
    height: 4
  - name: exec_kpi_ai_share
    title: AI Share of Traffic
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.ai_share
    - ga4_daily.ai_share_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: AI sessions / all sessions (ignores the AI Engine filter)
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
    tab_name: Executive Summary
    row: 6
    col: 0
    width: 6
    height: 3
  - name: exec_kpi_ai_signups
    title: AI Signups
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.signups
    - ga4_daily.signups_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: &id002
      ga4_daily.is_ai_referral: 'Yes'
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: Executive Summary
    row: 6
    col: 6
    width: 6
    height: 3
  - name: exec_kpi_ai_conv
    title: AI Conversion Rate
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.conversion_rate
    - ga4_daily.conversion_rate_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: Executive Summary
    row: 6
    col: 12
    width: 6
    height: 3
  - name: exec_kpi_ai_revenue
    title: AI Revenue
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.purchase_revenue
    - ga4_daily.purchase_revenue_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: Executive Summary
    row: 6
    col: 18
    width: 6
    height: 3
  - name: exec_sov_trend
    title: Share of Voice · Daily
    model: transunion_ai
    explore: scrunch_brands
    type: looker_line
    fields:
    - scrunch_brand.report_date
    - scrunch_brand.brand_name
    - scrunch_brand.mentions
    show_view_names: false
    pivots:
    - scrunch_brand.brand_name
    fill_fields:
    - scrunch_brand.report_date
    filters:
      scrunch_brand.period_type: CP
    sorts:
    - scrunch_brand.report_date
    dynamic_fields:
    - category: table_calculation
      expression: ${scrunch_brand.mentions} / sum(pivot_row(${scrunch_brand.mentions}))
      label: Share of Voice
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: share_of_voice
      _type_hint: number
    hidden_fields:
    - scrunch_brand.mentions
    point_style: none
    interpolation: monotone
    x_axis_gridlines: false
    y_axis_gridlines: true
    legend_position: center
    series_colors:
      TransUnion - share_of_voice: '#00A6CA'
      Experian - share_of_voice: '#7B3F98'
      Equifax - share_of_voice: '#C8102E'
      Credit Karma - share_of_voice: '#2DB34A'
      WalletHub - share_of_voice: '#F7931E'
    listen:
      Date Range: scrunch_brand.period
      AI Engine: scrunch_brand.ai_platform
      Market: scrunch_brand.country
      Persona (Scrunch): scrunch_brand.persona_name
      Topic (Scrunch): scrunch_brand.primary_topic
    tab_name: Executive Summary
    row: 9
    col: 0
    width: 16
    height: 8
  - name: exec_sov_table
    title: Market Share Breakdown
    model: transunion_ai
    explore: scrunch_brands
    type: looker_grid
    fields:
    - scrunch_brand.brand_domain
    - scrunch_brand.mentions
    - scrunch_brand.first_mention_rate
    - scrunch_brand.sentiment_index
    show_view_names: false
    sorts:
    - scrunch_brand.mentions desc
    dynamic_fields:
    - category: table_calculation
      expression: ${scrunch_brand.mentions} / sum(${scrunch_brand.mentions})
      label: SOV
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: sov
      _type_hint: number
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    series_labels:
      scrunch_brand.brand_domain: Domain
      scrunch_brand.first_mention_rate: First-Mention
      scrunch_brand.sentiment_index: Sentiment
    series_cell_visualizations:
      sov: &id003
        is_active: true
        palette:
          palette_id: tu-bar
          collection_id: legacy
          custom_colors:
          - '#E6F6FA'
          - '#00A6CA'
    listen:
      Date Range: scrunch_brand.period
      AI Engine: scrunch_brand.ai_platform
      Market: scrunch_brand.country
      Persona (Scrunch): scrunch_brand.persona_name
      Topic (Scrunch): scrunch_brand.primary_topic
    tab_name: Executive Summary
    row: 9
    col: 16
    width: 8
    height: 8
  - name: exec_top_sources
    title: Most-Cited Sources in AI Answers
    model: transunion_ai
    explore: scrunch_citations
    type: looker_grid
    fields:
    - scrunch_citation.citation_domain
    - scrunch_citation.citation_source_type
    - scrunch_citation.responses_citing
    - scrunch_citation.citations
    - scrunch_citation.avg_citation_position
    show_view_names: false
    sorts:
    - scrunch_citation.responses_citing desc
    limit: 15
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    series_cell_visualizations:
      scrunch_citation.responses_citing: *id003
    note_state: collapsed
    note_display: hover
    note_text: Scrunch citations · Ahrefs DR placements added when the API is live
    listen:
      Date Range: scrunch_citation.period
      AI Engine: scrunch_citation.ai_platform
      Market: scrunch_citation.country
      Persona (Scrunch): scrunch_citation.persona_name
      Topic (Scrunch): scrunch_citation.primary_topic
    tab_name: Executive Summary
    row: 17
    col: 0
    width: 14
    height: 8
  - name: exec_status_mix
    title: TU Status by AI Engine
    model: transunion_ai
    explore: scrunch_responses
    type: looker_bar
    fields:
    - scrunch_response.ai_platform
    - scrunch_response.transunion_status
    - scrunch_response.responses
    show_view_names: false
    pivots:
    - scrunch_response.transunion_status
    sorts:
    - scrunch_response.ai_platform
    stacking: percent
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: false
    series_colors:
      Cited - scrunch_response.responses: '#12B76A'
      Mentioned - scrunch_response.responses: '#F79009'
      Missing - scrunch_response.responses: '#F04438'
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Executive Summary
    row: 17
    col: 14
    width: 10
    height: 8
  - name: exec_footnote
    type: text
    title_text: ''
    body_text: '<sub>**vs PP** = change vs previous period of the same length · Brand = named in the AI answer, Citation = linked source · First-Mention = top part of the answer · AI sessions are a floor: Google AI Overviews / AI Mode arrive as google / organic</sub>'
    tab_name: Executive Summary
    row: 25
    col: 0
    width: 24
    height: 2
  - name: traffic_logo
    type: text
    title_text: ''
    body_text: '![TransUnion](https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77)'
    tab_name: AI Traffic & Conversions
    row: 0
    col: 0
    width: 4
    height: 2
  - name: traffic_header
    type: text
    title_text: AI Search & GEO Performance
    subtitle_text: AI Referral Traffic & Conversions · GA4 · every filter applies to sessions and conversions
    body_text: ''
    tab_name: AI Traffic & Conversions
    row: 0
    col: 4
    width: 20
    height: 2
  - name: traffic_kpi_sessions
    title: AI Sessions
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.ai_sessions
    - ga4_daily.ai_sessions_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 2
    col: 0
    width: 4
    height: 4
  - name: traffic_kpi_share
    title: AI Share of Traffic
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.ai_share
    - ga4_daily.ai_share_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    note_state: collapsed
    note_display: hover
    note_text: AI sessions / all sessions (ignores the AI Engine filter)
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
    tab_name: AI Traffic & Conversions
    row: 2
    col: 4
    width: 4
    height: 4
  - name: traffic_kpi_engagement
    title: Engagement Rate
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.engagement_rate
    - ga4_daily.engagement_rate_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 2
    col: 8
    width: 4
    height: 4
  - name: traffic_kpi_duration
    title: Avg Session Duration
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.avg_session_duration
    - ga4_daily.avg_session_duration_pp
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 2
    col: 12
    width: 4
    height: 4
  - name: traffic_kpi_signups
    title: AI Signups
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.signups
    - ga4_daily.signups_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 2
    col: 16
    width: 4
    height: 4
  - name: traffic_kpi_revenue
    title: AI Revenue
    model: transunion_ai
    explore: ga4_ai_traffic
    type: single_value
    fields:
    - ga4_daily.purchase_revenue
    - ga4_daily.purchase_revenue_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    filters: *id002
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 2
    col: 20
    width: 4
    height: 4
  - name: traffic_trend
    title: Daily AI Sessions by Engine
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_area
    fields:
    - ga4_daily.report_date
    - ga4_daily.ai_platform
    - ga4_daily.sessions
    show_view_names: false
    pivots:
    - ga4_daily.ai_platform
    fill_fields:
    - ga4_daily.report_date
    filters:
      ga4_daily.is_ai_referral: 'Yes'
      ga4_daily.period_type: CP
    sorts:
    - ga4_daily.report_date
    stacking: normal
    interpolation: monotone
    x_axis_gridlines: false
    y_axis_gridlines: true
    legend_position: center
    series_colors:
      ChatGPT - ga4_daily.sessions: '#10A37F'
      Gemini - ga4_daily.sessions: '#4285F4'
      Copilot - ga4_daily.sessions: '#0078D4'
      Perplexity - ga4_daily.sessions: '#1FB8CD'
      Claude - ga4_daily.sessions: '#D97757'
      Meta AI - ga4_daily.sessions: '#0866FF'
      Grok - ga4_daily.sessions: '#1D1D1F'
      DeepSeek - ga4_daily.sessions: '#4D6BFE'
      Other AI Assistant - ga4_daily.sessions: '#98A2B3'
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 6
    col: 0
    width: 24
    height: 8
  - name: traffic_volume_quality
    title: Volume vs Quality by AI Engine
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_column
    fields:
    - ga4_daily.ai_platform
    - ga4_daily.sessions
    - ga4_daily.engagement_rate
    show_view_names: false
    filters: *id002
    sorts:
    - ga4_daily.sessions desc
    series_types:
      ga4_daily.engagement_rate: line
    y_axes:
    - label: Sessions
      orientation: left
      series:
      - id: ga4_daily.sessions
      showLabels: true
      showValues: true
    - label: Engagement
      orientation: right
      series:
      - id: ga4_daily.engagement_rate
      showLabels: true
      showValues: true
      valueFormat: 0%
    series_colors:
      ga4_daily.sessions: '#00A6CA'
      ga4_daily.engagement_rate: '#0B2E4F'
    x_axis_gridlines: false
    y_axis_gridlines: false
    legend_position: center
    show_value_labels: false
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 14
    col: 0
    width: 12
    height: 8
  - name: traffic_matrix
    title: AI Platform Performance & Engagement
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_grid
    fields:
    - ga4_daily.ai_platform
    - ga4_daily.total_users
    - ga4_daily.sessions
    - ga4_daily.pages_per_session
    - ga4_daily.avg_session_duration
    - ga4_daily.engagement_rate
    show_view_names: false
    filters: *id002
    sorts:
    - ga4_daily.sessions desc
    dynamic_fields:
    - category: table_calculation
      expression: ${ga4_daily.sessions} / sum(${ga4_daily.sessions})
      label: Share
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: share
      _type_hint: number
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    series_labels:
      ga4_daily.total_users: Users
      ga4_daily.avg_session_duration: Avg Duration
    series_cell_visualizations:
      ga4_daily.sessions: *id003
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 14
    col: 12
    width: 12
    height: 8
  - name: traffic_device
    title: Device Mix · AI Traffic
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_pie
    fields:
    - ga4_daily.device_category
    - ga4_daily.sessions
    show_view_names: false
    filters: *id002
    sorts:
    - ga4_daily.sessions desc
    inner_radius: 60
    value_labels: legend
    label_type: labPer
    series_colors:
      Mobile: '#00A6CA'
      Desktop: '#0B2E4F'
      Tablet: '#7FD3E6'
      Unknown: '#D0D5DD'
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 22
    col: 0
    width: 8
    height: 8
  - name: traffic_map
    title: AI Sessions by Market
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_geo_choropleth
    fields:
    - ga4_daily.country
    - ga4_daily.ai_sessions
    show_view_names: false
    sorts:
    - ga4_daily.ai_sessions desc
    map: world
    map_projection: ''
    quantize_colors: false
    colors:
    - '#E6F6FA'
    - '#00A6CA'
    - '#0B2E4F'
    outer_border_color: '#FFFFFF'
    inner_border_color: '#FFFFFF'
    empty_color: '#F2F4F7'
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 22
    col: 8
    width: 16
    height: 8
  - name: traffic_conversions
    title: Downstream Conversions by AI Engine
    model: transunion_ai
    explore: ga4_ai_traffic
    type: looker_grid
    fields:
    - ga4_daily.ai_platform
    - ga4_daily.sessions
    - ga4_daily.signups
    - ga4_daily.signup_rate
    - ga4_daily.visits_dss
    - ga4_daily.visits_acr
    - ga4_daily.business_conversions
    - ga4_daily.conversion_rate
    - ga4_daily.purchase_revenue
    show_view_names: false
    filters: *id002
    sorts:
    - ga4_daily.sessions desc
    show_totals: true
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    series_cell_visualizations:
      ga4_daily.signups: *id003
    note_state: collapsed
    note_display: hover
    note_text: DSS / ACR provisional until TU confirms Visits_DSS / ACR / Phx
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 30
    col: 0
    width: 16
    height: 8
  - name: traffic_products
    title: AI Sessions by Product
    model: transunion_ai
    explore: ga4_products
    type: looker_bar
    fields:
    - ga4_daily.product
    - ga4_daily.ai_sessions
    - ga4_daily.ai_share
    show_view_names: false
    sorts:
    - ga4_daily.ai_sessions desc
    series_types:
      ga4_daily.ai_share: scatter
    series_colors:
      ga4_daily.ai_sessions: '#00A6CA'
      ga4_daily.ai_share: '#0B2E4F'
    show_value_labels: true
    x_axis_gridlines: false
    y_axis_gridlines: false
    legend_position: center
    note_state: collapsed
    note_display: hover
    note_text: GA4 subproperties (DSS, ACR, B2B...) - subsets of GA4 US, never added to totals
    listen:
      Date Range: ga4_daily.period
      Market: ga4_daily.country
      Device (GA4): ga4_daily.device_category
      AI Engine: ga4_daily.ai_platform
    tab_name: AI Traffic & Conversions
    row: 30
    col: 16
    width: 8
    height: 8
  - name: traffic_footnote
    type: text
    title_text: ''
    body_text: '<sub>**vs PP** = change vs previous period of the same length · All AI sources included (Top 5 flag optional) · Date, AI Engine, Market and Device filter sessions AND conversions · AI sessions are a floor: Google AI Overviews / AI Mode arrive as google / organic, app traffic without referrer as direct</sub>'
    tab_name: AI Traffic & Conversions
    row: 38
    col: 0
    width: 24
    height: 2
  - name: prompts_logo
    type: text
    title_text: ''
    body_text: '![TransUnion](https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77)'
    tab_name: Prompt & Persona Intelligence
    row: 0
    col: 0
    width: 4
    height: 2
  - name: prompts_header
    type: text
    title_text: AI Search & GEO Performance
    subtitle_text: Prompt & Persona Intelligence · Scrunch · how AI engines answer consumer questions
    body_text: ''
    tab_name: Prompt & Persona Intelligence
    row: 0
    col: 4
    width: 20
    height: 2
  - name: prompts_kpi_prompts
    title: Prompts Tracked
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.prompts_tracked
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 2
    col: 0
    width: 6
    height: 3
  - name: prompts_kpi_mention
    title: Mention Rate
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.mention_rate
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 2
    col: 6
    width: 6
    height: 3
  - name: prompts_kpi_citation
    title: Citation Rate
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.citation_rate
    custom_color_enabled: true
    custom_color: '#0B2E4F'
    show_single_value_title: true
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 2
    col: 12
    width: 6
    height: 3
  - name: prompts_kpi_sentiment
    title: Net Sentiment
    model: transunion_ai
    explore: scrunch_responses
    type: single_value
    fields:
    - scrunch_response.net_sentiment
    - scrunch_response.net_sentiment_pp
    custom_color_enabled: true
    custom_color: '#00A6CA'
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs PP
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
      'Sentiment: ''none''': scrunch_response.sentiment_none_mode
    tab_name: Prompt & Persona Intelligence
    row: 2
    col: 18
    width: 6
    height: 3
  - name: prompts_matrix
    title: Core Prompt Tracking Matrix
    model: transunion_ai
    explore: scrunch_responses
    type: looker_grid
    fields:
    - scrunch_response.prompt
    - scrunch_response.persona_name
    - scrunch_response.ai_platform
    - scrunch_response.latest_status
    - scrunch_response.top_winner_domain
    - scrunch_response.mention_rate
    - scrunch_response.citation_rate
    - scrunch_response.first_mention_rate
    - scrunch_response.responses
    show_view_names: false
    sorts:
    - scrunch_response.prompt
    - scrunch_response.ai_platform
    limit: 500
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    series_labels:
      scrunch_response.prompt: Prompt
      scrunch_response.ai_platform: AI Engine
      scrunch_response.latest_status: TU Status
      scrunch_response.first_mention_rate: First-Mention
    series_cell_visualizations:
      scrunch_response.mention_rate: *id003
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 5
    col: 0
    width: 24
    height: 10
  - name: prompts_topic_heatmap
    title: Sentiment & Positioning · Topic × AI Engine
    model: transunion_ai
    explore: scrunch_responses
    type: looker_grid
    fields:
    - scrunch_response.primary_topic
    - scrunch_response.ai_platform
    - scrunch_response.responses
    - scrunch_response.sentiment_index
    show_view_names: false
    pivots:
    - scrunch_response.ai_platform
    sorts:
    - scrunch_response.ai_platform
    show_row_numbers: false
    table_theme: white
    header_text_alignment: left
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting:
    - type: along a scale...
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: legacy
        palette_id: legacy_diverging1
      bold: false
      italic: false
      strikethrough: false
      fields:
      - scrunch_response.sentiment_index
    series_labels:
      scrunch_response.primary_topic: Brand Attribute / Topic
      scrunch_response.sentiment_index: Sentiment
    note_state: collapsed
    note_display: hover
    note_text: Sentiment -1 to +1 (interim for Sentiment Weight Index) · Product tag TUCE / TUCP pending TU
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 15
    col: 0
    width: 16
    height: 9
  - name: prompts_persona
    title: Visibility by Persona
    model: transunion_ai
    explore: scrunch_responses
    type: looker_bar
    fields:
    - scrunch_response.persona_name
    - scrunch_response.mention_rate
    - scrunch_response.citation_rate
    show_view_names: false
    sorts:
    - scrunch_response.mention_rate desc
    show_value_labels: true
    label_value_format: 0%
    x_axis_gridlines: false
    y_axis_gridlines: false
    legend_position: center
    series_colors:
      scrunch_response.mention_rate: '#00A6CA'
      scrunch_response.citation_rate: '#0B2E4F'
    listen:
      Date Range: scrunch_response.period
      AI Engine: scrunch_response.ai_platform
      Market: scrunch_response.country
      Persona (Scrunch): scrunch_response.persona_name
      Topic (Scrunch): scrunch_response.primary_topic
    tab_name: Prompt & Persona Intelligence
    row: 15
    col: 16
    width: 8
    height: 9
  - name: prompts_footnote
    type: text
    title_text: ''
    body_text: <sub>**Cited** = transunion.com linked as a source · **Mentioned** = named in the answer · **Missing** = neither · Winner domain = most-linked domain per answer</sub>
    tab_name: Prompt & Persona Intelligence
    row: 24
    col: 0
    width: 24
    height: 2
