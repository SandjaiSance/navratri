# Logboek

Werknotities en beslissingen per project, nieuwste bovenaan.

**Formaat per entry:**
```
## YYYY-MM-DD — [Project of onderwerp]
**Beslissing/actie:** ...
**Context:** ...
**Notities:** ...
```

---

## 2026-06-18 — Logboek prompt aangemaakt

**Beslissing/actie:** `/logboek` prompt aangemaakt in `.github/prompts/logboek.prompt.md`.

**Context:** Behoefte aan een snelle manier om werknotities toe te voegen aan het logboek vanuit Copilot Chat.

**Notities:**
- Gebruik: typ `/logboek [onderwerp]` in Copilot Chat
- De prompt voegt automatisch een nieuwe entry bovenaan in met datum, beslissing, context en notities
- Promptbestand: `.github/prompts/logboek.prompt.md`

---

## 2026-06-18 — GitHub Copilot / Elastic Stack

**Beslissing/actie:** Elastic Dashboard agent ontworpen maar nog niet opgeslagen.

**Context:**
- Workspace: `C:\Users\306605\OneDrive - TenneT TSO B.V\GithubCopilotWS`
- Agent-bestand klaarstaat als `elastic-dashboard.agent.md`
- Kan worden opgeslagen in gebruikersprofiel (`C:\Users\306605\AppData\Roaming\Code\User\prompts\`) of in de workspace (`.github/agents/`)

**Notities:**
- Elastic dashboards worden gebouwd in Kibana: data inladen → data view aanmaken → Lens visualisaties → dashboard samenstellen
- Agent heeft tools: `web`, `read`, `search` — geen terminal, geen bestandsbewerking
- Triggers: Kibana, KQL, EQL, ES|QL, Lens, Elastic Agent, Logstash

---
