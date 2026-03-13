# Cloudflare Turnstile in Oracle APEX - Complete Setup

## Stap 1: Cloudflare Turnstile Configureren

1. **Ga naar Cloudflare Dashboard:**
   - Log in op cloudflare.com
   - Ga naar je domain → Turnstile
   - Klik "Add Site" of "Create Widget"

2. **Noteer je keys:**
   - **Site Key** (publiek, voor client-side)
   - **Secret Key** (geheim, voor server-side verificatie)

3. **Configureer domein:**
   - Voeg je APEX domein toe aan allowed domains

---

## Stap 2: APEX Application Items Aanmaken

Ga naar **Shared Components → Application Items:**

- `G_TURNSTILE_SITE_KEY` = je site key
- `G_TURNSTILE_SECRET_KEY` = je secret key

---

## Stap 3: Download Pagina Maken

### Page Items:
- `P10_TURNSTILE_RESPONSE` (Hidden) - voor het Turnstile token

### HTML Region (voor CAPTCHA widget):

```html
<div id="turnstile-widget"></div>
```

### JavaScript in Page Properties → JavaScript → Execute when Page Loads:

```javascript
// Laad Turnstile script
if (!document.getElementById('turnstile-script')) {
    const script = document.createElement('script');
    script.id = 'turnstile-script';
    script.src = 'https://challenges.cloudflare.com/turnstile/v0/api.js';
    script.async = true;
    script.defer = true;
    document.head.appendChild(script);
}

// Render Turnstile widget wanneer script geladen is
function renderTurnstile() {
    if (typeof turnstile !== 'undefined') {
        turnstile.render('#turnstile-widget', {
            sitekey: '&G_TURNSTILE_SITE_KEY.',
            callback: function(token) {
                // Sla token op in hidden item
                apex.item('P10_TURNSTILE_RESPONSE').setValue(token);
            },
            'error-callback': function() {
                apex.message.showErrors([{
                    type: "error",
                    location: "page",
                    message: "CAPTCHA verificatie mislukt. Probeer opnieuw."
                }]);
            }
        });
    } else {
        setTimeout(renderTurnstile, 100);
    }
}

renderTurnstile();
```

---

## Stap 4: Download Button

Maak een button: **P10_DOWNLOAD**

### Button Properties:
- Action: Submit Page
- Execute Validations: Yes

---

## Stap 5: Server-side Verificatie (Validation)

**Type:** Function Body (returning Boolean)

**PL/SQL Code:**

```sql
declare
  l_response      varchar2(4000) := :P10_TURNSTILE_RESPONSE;
  l_secret_key    varchar2(200)  := :G_TURNSTILE_SECRET_KEY;
  l_request       clob;
  l_response_clob clob;
  l_success       varchar2(10);
  l_wallet_path   varchar2(200)  := 'file:/path/to/wallet'; -- pas aan
  l_wallet_pwd    varchar2(100)  := 'wallet_password'; -- pas aan
begin
  -- Check of token aanwezig is
  if l_response is null then
    apex_error.add_error(
      p_message => 'Voltooi eerst de CAPTCHA verificatie.',
      p_display_location => apex_error.c_inline_in_notification
    );
    return false;
  end if;

  -- Bouw request body
  l_request := 'secret=' || apex_util.url_encode(l_secret_key) ||
               '&response=' || apex_util.url_encode(l_response);

  -- Maak HTTPS connectie naar Cloudflare
  apex_web_service.g_request_headers.delete();
  apex_web_service.g_request_headers(1).name := 'Content-Type';
  apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';
  
  -- Optioneel: als je wallet nodig hebt voor HTTPS
  -- apex_web_service.set_wallet(l_wallet_path, l_wallet_pwd);

  -- Roep Cloudflare verificatie API aan
  l_response_clob := apex_web_service.make_rest_request(
    p_url => 'https://challenges.cloudflare.com/turnstile/v0/siteverify',
    p_http_method => 'POST',
    p_body => l_request
  );

  -- Parse JSON response
  apex_json.parse(l_response_clob);
  l_success := apex_json.get_varchar2('success');

  if l_success = 'true' then
    return true;
  else
    apex_error.add_error(
      p_message => 'CAPTCHA verificatie mislukt. Probeer opnieuw.',
      p_display_location => apex_error.c_inline_in_notification
    );
    return false;
  end if;

exception
  when others then
    apex_error.add_error(
      p_message => 'Fout bij CAPTCHA verificatie: ' || sqlerrm,
      p_display_location => apex_error.c_inline_in_notification
    );
    return false;
end;
```

**Error Message:**
```
CAPTCHA verificatie is verplicht.
```

---

## Stap 6: Download Process

**Process:** Execute Code  
**When Button Pressed:** P10_DOWNLOAD

```sql
declare
  l_file_blob blob;
  l_file_name varchar2(200) := 'jouw_bestand.pdf';
  l_mime_type varchar2(100) := 'application/pdf';
begin
  -- Haal je bestand op (uit tabel, directory, etc.)
  select file_blob, file_name, mime_type
  into l_file_blob, l_file_name, l_mime_type
  from jouw_files_tabel
  where file_id = :P10_FILE_ID;  -- pas aan

  -- Verstuur bestand naar browser
  sys.htp.init;
  sys.owa_util.mime_header(l_mime_type, false);
  sys.htp.p('Content-Length: ' || dbms_lob.getlength(l_file_blob));
  sys.htp.p('Content-Disposition: attachment; filename="' || l_file_name || '"');
  sys.owa_util.http_header_close;
  sys.wpg_docload.download_file(l_file_blob);
  
  apex_application.stop_apex_engine;
  
exception
  when others then
    apex_error.add_error(
      p_message => 'Download mislukt: ' || sqlerrm,
      p_display_location => apex_error.c_inline_in_notification
    );
end;
```

---

## Stap 7: Reset CAPTCHA na Submit

**Process:** Execute Code (na download)

```sql
begin
  :P10_TURNSTILE_RESPONSE := null;
end;
```

**JavaScript Execute Code (Dynamic Action na submit):**

```javascript
// Reset Turnstile widget
if (typeof turnstile !== 'undefined') {
    turnstile.reset();
}
```

---

## Extra: ACL voor HTTPS (als je geen wallet hebt)

Als je een fout krijgt over netwerkrechten:

```sql
begin
  dbms_network_acl_admin.append_host_ace(
    host => 'challenges.cloudflare.com',
    ace  => xs$ace_type(
      privilege_list => xs$name_list('http'),
      principal_name => 'APEX_210200',  -- pas aan naar jouw APEX schema
      principal_type => xs_acl.ptype_db
    )
  );
end;
/
```

---

## Testen

1. Open de download pagina
2. CAPTCHA widget wordt getoond
3. Vink CAPTCHA aan
4. Klik op Download button
5. Server verifieert token
6. Bij succes: download start
7. Bij falen: error message

**Klaar!** 🎉
