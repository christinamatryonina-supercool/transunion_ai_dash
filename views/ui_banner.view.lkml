# =============================================================================

# UI banner - hero header per dashboard tab (HTML in a single-value tile)
# - TransUnion palette: navy #0A4A6E, teal #00A6CA, yellow #FFE600
# - Wordmark built in HTML (no image): crisp, cannot break or be cropped
# - Simple CSS only (no flexbox) - Looker strips some layout CSS in tiles
# =============================================================================

view: ui_banner {
  derived_table: { sql: SELECT 1 AS id ;; }

  dimension: id { primary_key: yes hidden: yes sql: ${TABLE}.id ;; }

  measure: header_exec {
    label: "Header · Executive"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;letter-spacing:0.2px;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">Executive Summary</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin:2px 0 10px 0;">TransUnion visibility in AI answers vs competitors, and the traffic it drives.</div>
        <div><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#0A4A6E;background:#E6F6FA;border-radius:999px;padding:4px 11px;">Scrunch · AI answers</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#0A4A6E;background:#E6F6FA;border-radius:999px;padding:4px 11px;">GA4 · AI referrals</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#0A4A6E;background:#FFE600;border-radius:999px;padding:4px 11px;">vs PP = previous period</span></div>
      </div> ;;
  }
  measure: header_traffic {
    label: "Header · AI Traffic"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;letter-spacing:0.2px;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">AI Traffic &amp; Conversions</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin:2px 0 10px 0;">Visits from ChatGPT, Gemini, Copilot, Perplexity &amp; Claude: engagement and conversions.</div>
        <div><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#0A4A6E;background:#E6F6FA;border-radius:999px;padding:4px 11px;">GA4 · 3 sites + 5 products</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#FFFFFF;background:rgba(255,255,255,0.16);border-radius:999px;padding:4px 11px;">Date · Engine · Market · Device</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#0A4A6E;background:#FFE600;border-radius:999px;padding:4px 11px;">vs PP = previous period</span></div>
      </div> ;;
  }
  measure: header_prompts {
    label: "Header · Prompts"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:16px;padding:18px 28px 16px 28px;background:linear-gradient(115deg,#033E5E 0%,#0A4A6E 45%,#00A6CA 100%);text-align:left;font-family:Roboto,Arial,sans-serif;">
        <div style="line-height:24px;">
          <span style="font-size:22px;font-weight:700;color:#FFFFFF;letter-spacing:0.2px;vertical-align:middle;">TransUnion</span><span style="display:inline-block;margin-left:5px;width:20px;height:20px;line-height:20px;border:2px solid #7FD3E6;border-radius:50%;color:#7FD3E6;font-size:10px;font-weight:700;text-align:center;vertical-align:top;">tu</span>
          <span style="font-size:11px;letter-spacing:2px;text-transform:uppercase;color:#7FD3E6;font-weight:700;margin-left:14px;vertical-align:middle;">AI Search &amp; GEO</span>
        </div>
        <div style="width:44px;height:4px;background:#FFE600;border-radius:2px;margin:10px 0 8px 0;"></div>
        <div style="font-size:24px;line-height:30px;font-weight:700;color:#FFFFFF;">Prompt &amp; Persona Intelligence</div>
        <div style="font-size:13px;line-height:18px;color:#D6EEF5;margin:2px 0 10px 0;">What consumers ask AI engines, and how each engine describes TransUnion.</div>
        <div><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#067647;background:#E7F8EF;border-radius:999px;padding:4px 11px;">● Cited</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#B54708;background:#FEF6E7;border-radius:999px;padding:4px 11px;">● Mentioned</span><span style="display:inline-block;margin:0 6px 0 0;font-size:11px;font-weight:600;color:#B42318;background:#FEECEB;border-radius:999px;padding:4px 11px;">● Missing</span></div>
      </div> ;;
  }
}
