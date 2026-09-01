let meta = #{
    name: "overnight-ops",
    description: "Ops checks daily connected sources against logic.md, writes the morning brief, then fans out at most 2 flagged specialists (inventory, ads, customer). Never listing or creative. Use for scheduled overnight and /overnight --now.",
    when_to_use: "When the overnight wrapper fires, the operator runs /overnight or /overnight --now, or wants a morning brief from daily connected sources.",
    phases: [
        #{ title: "Checks", detail: "ops pulls daily connected sources, runs logic.md checks, writes skeleton brief, returns spawn list" },
        #{ title: "Specialists", detail: "parallel at most 2 flagged specialists; never listing or creative" },
        #{ title: "Attach", detail: "ops attaches artifact paths and delivers" },
    ],
};

// Callers pass agent_budget 8 (ops checks + cap 2 specialists + 2 retries each + attach).

fn trimmed(s) {
    if type_of(s) == "string" {
        s.trim();
        s
    } else {
        ""
    }
}

fn slot_note(r, ok_path) {
    if r != () && r.success {
        ok_path
    } else {
        "(not in the data)"
    }
}

fn is_overnight_seat(seat) {
    seat == "inventory" || seat == "ads" || seat == "customer"
}

fn specialist_prompt(seat, artifact, report_date, extra) {
    let p = "";
    p += "You are the " + seat + " agent for this Amazon brand. Cwd is the business folder.\n";
    p += "Use tools (read_file, grep, glob, bash). Read files before you write anything. Do not answer from memory.\n\n";
    p += "1. Read AGENTS.md, then reference/sources.md, then reference/logic.md.\n";
    p += "2. Then read connected sources listed in sources.md (status connected). Newest file in a bucket wins. A missing source is not demanded as a file.\n";
    p += "3. Follow the " + seat + " agent definition and its skill. logic.md metrics, flags, exceptions, and brief contents win over any skill default.\n";
    p += "4. Write the named artifact: " + artifact + "\n";
    p += "5. Use date " + report_date + " in dated filenames. Do not invent a date. This date is the run date.\n";
    p += "6. Write (not in the data) only after you have read sources.md and tried the connected files. An empty (not in the data) is valid only after reading. Never invent numbers.\n";
    p += "7. Do not edit exports/. Do not push live changes to Amazon. Do not spawn children.\n";
    p += extra;
    p
}

let checks_schema = #{
    "type": "object",
    "required": ["brief_path", "zero_sources", "incomplete", "priority", "seats"],
    "properties": #{
        "brief_path": #{ "type": "string" },
        "zero_sources": #{ "type": "boolean" },
        "incomplete": #{ "type": "boolean" },
        "priority": #{
            "type": "array",
            "maxItems": 3,
            "items": #{ "type": "string" },
        },
        "seats": #{
            "type": "array",
            "maxItems": 3,
            "items": #{ "type": "string" },
        },
        "flags": #{
            "type": "array",
            "maxItems": 20,
            "items": #{ "type": "string" },
        },
    },
};

let report_date = if args == () { () } else { args.date };
if report_date == () || report_date == "" {
    pause("verification", "Pass args.date as YYYY-MM-DD. Workflows cannot call timestamp().");
}

let cap = 2;
let retry_cap = 2;
let default_priority = ["inventory", "ads", "customer"];

let brief_path = "reports/morning-brief-" + report_date + ".md";
let ads_path = "reports/ppc-exception-brief-" + report_date + ".md";
let inventory_path = "reports/inventory-risk-" + report_date + ".md";
let customer_path = "reports/review-intelligence-" + report_date + ".md";

phase("Checks");
log("overnight-ops " + report_date + " — ops checks first, then cap " + cap.to_string() + " specialists");

let ops_prompt = "";
ops_prompt += "You are the ops agent for this Amazon brand. Cwd is the business folder.\n";
ops_prompt += "Use tools (read_file, grep, glob, bash, write). Read files before you write anything. Do not answer from memory.\n\n";
ops_prompt += "Follow overnight-ops for this Checks pass. Date is " + report_date + ".\n";
ops_prompt += "1. Read AGENTS.md, then reference/sources.md, then reference/logic.md.\n";
ops_prompt += "2. Pull only sources with freshness daily and status connected. Retry a failing source at most twice. One pass.\n";
ops_prompt += "3. Run checks from logic.md (Rules, Metrics I watch flag column, Exceptions, Overrides). Do not apply skill-default ACOS or cover numbers.\n";
ops_prompt += "4. Write the skeleton morning brief to " + brief_path + ". Do not POST yet.\n";
ops_prompt += "5. If ZERO sources could be read, write one line only: Overnight run could not read any source. Prefix INCOMPLETE BRIEF when any daily source is missing or unreadable.\n";
ops_prompt += "6. Build spawn from tripped flags only. Map inventory-seat flags to inventory, ads-seat flags to ads, customer-seat flags to customer.\n";
ops_prompt += "7. Priority from logic.md ## Overnight. Default inventory, ads, customer. Logic may reorder those three. Cap is 2 — logic may not raise it. If logic sets cap above 2, keep 2.\n";
ops_prompt += "8. Return priority (the three seats in Overnight order) and seats (every flagged overnight seat in that order, inventory/ads/customer only). You may return up to 3. The workflow truncates to cap 2. Quiet morning: seats is empty.\n";
ops_prompt += "9. Do not spawn children. Do not edit exports/.\n";

let ops_r = agent(
    ops_prompt,
    #{
        label: "ops-checks",
        capability_mode: "read-write",
        agent_type: "ops",
        phase: "Checks",
        output_schema: checks_schema,
    },
);

let zero_sources = false;
let incomplete = false;
let checks_failed = false;
let priority = [];
let spawn_raw = [];
if ops_r != () && ops_r.success && ops_r.output != () {
    let o = ops_r.output;
    if o.brief_path != () && trimmed(o.brief_path) != "" {
        brief_path = trimmed(o.brief_path);
    }
    if o.zero_sources == true { zero_sources = true; }
    if o.incomplete == true { incomplete = true; }
    if o.priority != () {
        for p in o.priority {
            let seat = trimmed(p);
            if is_overnight_seat(seat) {
                let seen = false;
                for e in priority { if e == seat { seen = true; } }
                if !seen { priority.push(seat); }
            }
        }
    }
    if o.seats != () {
        for s in o.seats {
            let seat = trimmed(s);
            if is_overnight_seat(seat) { spawn_raw.push(seat); }
        }
    }
} else {
    log("ops checks failed or returned no schema — failure-safe one-liner, no specialists");
    incomplete = true;
    checks_failed = true;
    zero_sources = true;
}

if priority.len() == 0 {
    for p in default_priority { priority.push(p); }
}

let ordered = [];
for p in priority {
    for s in spawn_raw {
        if s == p {
            let already = false;
            for e in ordered { if e == s { already = true; } }
            if !already { ordered.push(s); }
        }
    }
}

let spawn_list = [];
let si = 0;
for s in ordered {
    if si < cap { spawn_list.push(s); }
    si += 1;
}

if zero_sources {
    spawn_list = [];
    log("zero sources readable — no specialists");
}

phase("Specialists");
log("overnight seat cap " + cap.to_string() + ": " + json_encode(spawn_list));

let jobs = [];
for seat in spawn_list {
    let artifact = "";
    let extra = "";
    if seat == "inventory" {
        artifact = inventory_path;
        extra += "Follow inventory-risk. Flag SKUs from logic.md cover/stockout flags. Artifact is " + artifact + ".\n";
    }
    if seat == "ads" {
        artifact = ads_path;
        extra += "Follow ppc-exception-brief. Flag campaigns and terms from logic.md ads flags (TACOS, ACOS, wasted spend — their names). Do not treat 35% ACOS as the flag when logic names TACOS. Artifact is " + artifact + ".\n";
    }
    if seat == "customer" {
        artifact = customer_path;
        extra += "Follow review-intelligence. Also write drafts/review-replies-" + report_date + ".md (3 reply drafts). Artifact is " + artifact + ".\n";
    }
    if artifact != "" {
        jobs.push(#{
            prompt: specialist_prompt(seat, artifact, report_date, extra),
            label: seat,
            capability_mode: "read-write",
            agent_type: seat,
            phase: "Specialists",
        });
    }
}

let results = [];
if jobs.len() > 0 {
    results = parallel(jobs);
}

let retried = [];
let ri = 0;
for r in results {
    let cur = r;
    let failed = cur == () || (cur != () && !cur.success);
    let tries = 0;
    while failed && tries < retry_cap && ri < jobs.len() {
        let job = jobs[ri];
        log("retry specialist " + job.label + " " + (tries + 1).to_string() + "/" + retry_cap.to_string());
        cur = agent(
            job.prompt,
            #{
                label: job.label,
                capability_mode: "read-write",
                agent_type: job.label,
                phase: "Specialists",
            },
        );
        failed = cur == () || (cur != () && !cur.success);
        tries += 1;
    }
    retried.push(cur);
    ri += 1;
}
if retried.len() > 0 {
    results = retried;
}

let att_inventory = "";
let att_ads = "";
let att_customer = "";
let ji = 0;
for seat in spawn_list {
    let artifact = "";
    if seat == "inventory" { artifact = inventory_path; }
    if seat == "ads" { artifact = ads_path; }
    if seat == "customer" { artifact = customer_path; }
    let r = ();
    if ji < results.len() { r = results[ji]; }
    let slot = slot_note(r, artifact);
    if seat == "inventory" { att_inventory = slot; }
    if seat == "ads" { att_ads = slot; }
    if seat == "customer" { att_customer = slot; }
    if slot == "(not in the data)" { log(seat + " slot failed — brief will show (not in the data)"); }
    ji += 1;
}
let attachments = #{
    inventory: att_inventory,
    ads: att_ads,
    customer: att_customer,
};

phase("Attach");
log("ops attaching specialist paths to " + brief_path);

let attach_prompt = "";
attach_prompt += "You are the ops agent for this Amazon brand. Cwd is the business folder.\n";
attach_prompt += "Use tools (read_file, grep, glob, bash, write). Read files before you write anything. Do not answer from memory.\n\n";
attach_prompt += "Follow overnight-ops for this Attach + Deliver pass. Date is " + report_date + ".\n";
attach_prompt += "1. Read " + brief_path + " if it exists.\n";
attach_prompt += "   checks_failed=" + checks_failed.to_string() + " zero_sources=" + zero_sources.to_string() + " incomplete=" + incomplete.to_string() + ".\n";
attach_prompt += "   If the brief is missing, or checks_failed, or zero_sources: write one line only: Overnight run could not read any source. Prefix INCOMPLETE BRIEF. Never a clean empty brief. Do not invent a full brief after a failed Checks pass.\n";
attach_prompt += "2. Attach specialist artifact paths onto Flagged lines (the specialist-path slot). Failed slots are (not in the data) — do not crash.\n";
attach_prompt += "Specialist attachments for this run (exact strings):\n";
attach_prompt += json_encode(attachments) + "\n";
attach_prompt += "3. Do not spawn children. Never add a listing or creative path. Cap was 2.\n";
attach_prompt += "4. Deliver now. Read reference/delivery.md. Write the file first.\n";
attach_prompt += "   method none (or empty): Delivery: skipped. Do not POST.\n";
attach_prompt += "   method slack or webhook: POST the brief body to url. Retry at most twice. HTTP 2xx → Delivery: sent. After two failed attempts → Delivery: failed. Do not crash.\n";
attach_prompt += "   Do not copy the URL or other secrets into the brief.\n";
attach_prompt += "5. Prefix title INCOMPLETE BRIEF when any daily source was missing or unreadable. zero_sources=" + zero_sources.to_string() + " incomplete=" + incomplete.to_string() + ".\n";
attach_prompt += "6. Do not edit exports/.\n";

let attach_r = agent(
    attach_prompt,
    #{
        label: "ops-attach",
        capability_mode: "read-write",
        agent_type: "ops",
        phase: "Attach",
    },
);

let brief_slot = slot_note(attach_r, brief_path);
if brief_slot == "(not in the data)" {
    log("ops attach/deliver failed — still completing with (not in the data)");
}

complete(#{
    date: report_date,
    brief: brief_slot,
    cap: cap,
    seats: spawn_list,
    specialists: attachments,
    zero_sources: zero_sources,
    incomplete: incomplete,
    checks_failed: checks_failed,
});
