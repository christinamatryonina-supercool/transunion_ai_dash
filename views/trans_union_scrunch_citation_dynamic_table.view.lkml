# =============================================================================

# Scrunch - 1 row per response x distinct URL linked in the answer
# DWH.DBO."TransUnion_Scrunch_Citation_Dynamic_Table"
# =============================================================================

view: scrunch_citation {
  sql_table_name: DWH.DBO."TransUnion_Scrunch_Citation_Dynamic_Table" ;;

  filter: period {
    type: date
    label: "Date Range"
    description: "Current period (CP). PP = same number of days right before."
  }
  dimension: period_type {
    type: string
    label: "Period (CP / PP)"
    sql: CASE
           WHEN ${TABLE}.REPORT_DATE >= {% date_start period %}::DATE
            AND ${TABLE}.REPORT_DATE <  {% date_end period %}::DATE THEN 'CP'
           WHEN ${TABLE}.REPORT_DATE >= DATEADD(day, DATEDIFF(day, {% date_end period %}::DATE, {% date_start period %}::DATE), {% date_start period %}::DATE)
            AND ${TABLE}.REPORT_DATE <  {% date_start period %}::DATE THEN 'PP'
         END ;;
  }
  dimension: is_cp { hidden: yes type: yesno sql: ${period_type} = 'CP' ;; }

  dimension: pk {
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.RESPONSE_ID || '|' || ${TABLE}.CITATION_URL ;;
  }

  dimension_group: report {
    type: time
    label: "Report"
    timeframes: [raw, date, week, month]
    datatype: date
    convert_tz: no
    sql: ${TABLE}.REPORT_DATE ;;
  }

  dimension: citation_domain { group_label: "Citation" label: "Domain" sql: ${TABLE}.CITATION_DOMAIN ;; }
  dimension: citation_url {
    group_label: "Citation"
    label: "URL"
    sql: ${TABLE}.CITATION_URL ;;
    link: { label: "Open page" url: "{{ value }}" }
  }
  dimension: citation_source_type {
    group_label: "Citation"
    label: "Source Type"
    description: "brand = TransUnion | competitor | other"
    sql: CASE ${TABLE}.CITATION_SOURCE_TYPE WHEN 'brand' THEN 'TransUnion' WHEN 'competitor' THEN 'Competitor' ELSE 'Other' END ;;
  }
  dimension: is_transunion_citation { group_label: "Citation" type: yesno sql: ${TABLE}.IS_TRANSUNION_CITATION ;; }

  dimension: prompt       { group_label: "Prompt" sql: ${TABLE}.PROMPT ;; }
  dimension: persona_name { group_label: "Prompt" label: "Persona" sql: ${TABLE}.PERSONA_NAME ;; }
  dimension: primary_topic { group_label: "Prompt" label: "Brand Attribute / Topic" sql: ${TABLE}.PRIMARY_TOPIC ;; }
  dimension: ai_platform  { group_label: "AI" label: "AI Engine" suggest_explore: ai_platform_suggest suggest_dimension: dim_ai_platform.ai_platform sql: ${TABLE}.AI_PLATFORM ;; }
  dimension: country      { group_label: "Market" sql: ${TABLE}.COUNTRY ;; }

  measure: citations {
    label: "Citations"
    description: "Distinct URL x response"
    type: sum
    sql: IFF(${is_cp}, ${TABLE}.CITATION_COUNT, NULL) ;;
    value_format_name: decimal_0
  }
  measure: responses_citing {
    label: "Responses Citing"
    type: count_distinct
    sql: IFF(${is_cp}, ${TABLE}.RESPONSE_ID, NULL) ;;
    value_format_name: decimal_0
  }
  measure: avg_citation_position {
    label: "Avg Citation Position"
    description: "1 = first source linked"
    type: average
    sql: IFF(${is_cp}, ${TABLE}.FIRST_CITATION_POSITION, NULL) ;;
    value_format_name: decimal_1
  }
}
