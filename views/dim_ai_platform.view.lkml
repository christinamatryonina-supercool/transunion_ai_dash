# =============================================================================

# Shared AI platform list - one value set for the AI Engine filter (GA4 + Scrunch)
# =============================================================================

view: dim_ai_platform {
  derived_table: {
    sql: SELECT DISTINCT AI_PLATFORM FROM DWH.DBO.DIM_AI_PLATFORM WHERE IS_ACTIVE ;;
  }
  dimension: ai_platform {
    primary_key: yes
    label: "AI Engine"
    sql: ${TABLE}.AI_PLATFORM ;;
  }
}
