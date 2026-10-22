# =============================================================================

# UI banner - hero header per dashboard tab (HTML rendered in a single-value tile)
# - One-row derived table, no warehouse cost worth mentioning
# - Logo: change LOGO_URL below in all three measures (host a transparent PNG/SVG for best result)
# =============================================================================

view: ui_banner {
  derived_table: { sql: SELECT 1 AS id ;; }

  dimension: id { primary_key: yes hidden: yes sql: ${TABLE}.id ;; }

  measure: header_exec {
    label: "Header · Executive"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:18px;padding:20px 28px;background:linear-gradient(115deg,#071E36 0%,#0B2E4F 45%,#00A6CA 100%);display:flex;align-items:center;gap:24px;text-align:left;font-family:Inter,Roboto,Arial,sans-serif;box-shadow:0 8px 24px rgba(11,46,79,.25);">
        <img src="https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77" style="height:58px;max-width:170px;object-fit:contain;border-radius:12px;background:#FFFFFF;padding:6px 12px;">
        <div style="flex:1;">
          <div style="font-size:11px;letter-spacing:2.5px;text-transform:uppercase;color:#7FD3E6;font-weight:700;">TransUnion · AI Search &amp; GEO</div>
          <div style="font-size:28px;line-height:1.15;font-weight:700;color:#FFFFFF;margin-top:4px;">Executive Summary</div>
          <div style="font-size:13px;color:#CFEAF2;margin-top:6px;">How visible TransUnion is inside AI answers vs competitors, and the traffic, signups and revenue it drives.</div>
        </div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;justify-content:flex-end;max-width:320px;">
          <span style="font-size:11px;font-weight:600;color:#0B2E4F;background:#E6F6FA;border-radius:999px;padding:5px 12px;">Scrunch · AI answers</span>
          <span style="font-size:11px;font-weight:600;color:#0B2E4F;background:#E6F6FA;border-radius:999px;padding:5px 12px;">GA4 · AI referrals</span>
          <span style="font-size:11px;font-weight:600;color:#FFFFFF;background:rgba(255,255,255,.18);border-radius:999px;padding:5px 12px;">vs PP = previous period</span>
        </div>
      </div> ;;
  }

  measure: header_traffic {
    label: "Header · AI Traffic"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:18px;padding:20px 28px;background:linear-gradient(115deg,#071E36 0%,#0B2E4F 45%,#10A37F 100%);display:flex;align-items:center;gap:24px;text-align:left;font-family:Inter,Roboto,Arial,sans-serif;box-shadow:0 8px 24px rgba(11,46,79,.25);">
        <img src="https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77" style="height:58px;max-width:170px;object-fit:contain;border-radius:12px;background:#FFFFFF;padding:6px 12px;">
        <div style="flex:1;">
          <div style="font-size:11px;letter-spacing:2.5px;text-transform:uppercase;color:#9BE7CF;font-weight:700;">TransUnion · AI Search &amp; GEO</div>
          <div style="font-size:28px;line-height:1.15;font-weight:700;color:#FFFFFF;margin-top:4px;">AI Traffic &amp; Conversions</div>
          <div style="font-size:13px;color:#CFEAF2;margin-top:6px;">Who arrives from ChatGPT, Gemini, Copilot, Perplexity &amp; Claude, how deeply they engage, and what they convert into.</div>
        </div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;justify-content:flex-end;max-width:320px;">
          <span style="font-size:11px;font-weight:600;color:#0B2E4F;background:#E7F8EF;border-radius:999px;padding:5px 12px;">GA4 · 3 sites + 5 products</span>
          <span style="font-size:11px;font-weight:600;color:#FFFFFF;background:rgba(255,255,255,.18);border-radius:999px;padding:5px 12px;">Date · Engine · Market · Device</span>
        </div>
      </div> ;;
  }

  measure: header_prompts {
    label: "Header · Prompts"
    type: max
    sql: ${TABLE}.id ;;
    html:
      <div style="width:100%;box-sizing:border-box;border-radius:18px;padding:20px 28px;background:linear-gradient(115deg,#071E36 0%,#2A1B5C 50%,#7B3F98 100%);display:flex;align-items:center;gap:24px;text-align:left;font-family:Inter,Roboto,Arial,sans-serif;box-shadow:0 8px 24px rgba(11,46,79,.25);">
        <img src="https://ml.globenewswire.com/Resource/Download/2b06d0f7-df02-4246-8367-417848756c77" style="height:58px;max-width:170px;object-fit:contain;border-radius:12px;background:#FFFFFF;padding:6px 12px;">
        <div style="flex:1;">
          <div style="font-size:11px;letter-spacing:2.5px;text-transform:uppercase;color:#D9C2F0;font-weight:700;">TransUnion · AI Search &amp; GEO</div>
          <div style="font-size:28px;line-height:1.15;font-weight:700;color:#FFFFFF;margin-top:4px;">Prompt &amp; Persona Intelligence</div>
          <div style="font-size:13px;color:#E6DAF5;margin-top:6px;">What consumers ask AI engines, which persona asks it, and how each engine describes TransUnion.</div>
        </div>
        <div style="display:flex;gap:8px;flex-wrap:wrap;justify-content:flex-end;max-width:320px;">
          <span style="font-size:11px;font-weight:600;color:#067647;background:#E7F8EF;border-radius:999px;padding:5px 12px;">● Cited</span>
          <span style="font-size:11px;font-weight:600;color:#B54708;background:#FEF6E7;border-radius:999px;padding:5px 12px;">● Mentioned</span>
          <span style="font-size:11px;font-weight:600;color:#B42318;background:#FEECEB;border-radius:999px;padding:5px 12px;">● Missing</span>
        </div>
      </div> ;;
  }
}
