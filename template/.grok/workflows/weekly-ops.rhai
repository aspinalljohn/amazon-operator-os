let meta = #{
    name: "weekly-ops",
    description: "Fan out listing, ads, inventory, customer, and creative, then compile the weekly operator report. Use for /prove and /weekly.",
    when_to_use: "When the operator runs /prove or /weekly, or wants six dated artifacts from connected sources and logic.md.",
    phases: [
        #{ title: "Specialists", detail: "parallel listing, ads, inventory, customer, creative" },
        #{ title: "Report", detail: "ops compiles weekly-report" },
    ],
};

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

fn specialist_prompt(seat, artifact, report_date, asin_line, extra) {
    let p = "";
    p += "You are the " + seat + " agent for this Amazon brand. Cwd is the business folder.\n";
    p += "Use tools (read_file, grep, glob, bash). Read files before you write anything. Do not answer from memory.\n\n";
    p += "1. Read AGENTS.md, then reference/sources.md, then reference/logic.md.\n";
    p += "2. Then read connected sources listed in sources.md (status connected). Newest file in a bucket wins. A missing source is not demanded as a file.\n";
    p += "3. Follow the " + seat + " agent definition and its skill. logic.md metrics, flags, exceptions, and brief contents win over any skill default.\n";
    p += "4. Write the named artifact: " + artifact + "\n";
    p += "5. Use date " + report_date + " in dated filenames. Do not invent a date. This date is the run date.\n";
    p += asin_line;
    p += "6. Write (not in the data) only after you have read sources.md and tried the connected files. An empty (not in the data) is valid only after reading. Never invent numbers.\n";
    p += "7. Do not edit exports/. Do not push live changes to Amazon. Do not spawn children.\n";
    p += extra;
    p
}

let mode = if args == () { () } else { args.mode };
let report_date = if args == () { () } else { args.date };
let asin = if args == () { () } else { args.asin };

if mode == () || (mode != "prove" && mode != "weekly") {
    pause("verification", "Pass args.mode as prove or weekly.");
}
if report_date == () || report_date == "" {
    pause("verification", "Pass args.date as YYYY-MM-DD. Workflows cannot call timestamp().");
}

let asin_text = trimmed(asin);
let asin_line = "";
if asin_text != "" {
    asin_line += "Listing and Creative share this ASIN: " + asin_text + ". Hero in logic.md is context, not a skip.\n";
} else {
    asin_line += "No ASIN was passed. Use the first ASIN in reference/asins.md, else the first ASIN in the connected listings source. Listing and Creative must share that same ASIN. Hero in logic.md is context, not a skip.\n";
}

let listing_path = "reports/listing-audit-<asin>.md";
let creative_path = "reports/creative-brief-<asin>.md";
if asin_text != "" {
    listing_path = "reports/listing-audit-" + asin_text + ".md";
    creative_path = "reports/creative-brief-" + asin_text + ".md";
}
let ads_path = "reports/ppc-exception-brief-" + report_date + ".md";
let inventory_path = "reports/inventory-risk-" + report_date + ".md";
let customer_path = "reports/review-intelligence-" + report_date + ".md";
let weekly_path = "reports/weekly-report-" + report_date + ".md";

phase("Specialists");
log("weekly-ops " + mode + " " + report_date + " — five specialists in parallel");

let listing_extra = "";
listing_extra += "Follow listing-audit (plus title-compress, Q&A, attributes, AI-shopping gaps as sections of the same file). Artifact is " + listing_path + ".\n";

let ads_extra = "";
ads_extra += "Follow ppc-exception-brief. Flag campaigns and terms from logic.md ads flags (TACOS, ACOS, wasted spend — their names). Do not treat 35% ACOS as the flag when logic names TACOS. Artifact is " + ads_path + ".\n";

let inventory_extra = "";
inventory_extra += "Follow inventory-risk. Flag SKUs from logic.md cover/stockout flags. Artifact is " + inventory_path + ".\n";

let customer_extra = "";
customer_extra += "Follow review-intelligence. Also write drafts/review-replies-" + report_date + ".md (3 reply drafts). Artifact is " + customer_path + ".\n";

let creative_extra = "";
creative_extra += "Follow image-stack-brief and aplus-brief into one file. Briefs only, not pixels. Artifact is " + creative_path + ".\n";

let listing_prompt = specialist_prompt("listing", listing_path, report_date, asin_line, listing_extra);
let ads_prompt = specialist_prompt("ads", ads_path, report_date, asin_line, ads_extra);
let inventory_prompt = specialist_prompt("inventory", inventory_path, report_date, "", inventory_extra);
let customer_prompt = specialist_prompt("customer", customer_path, report_date, "", customer_extra);
let creative_prompt = specialist_prompt("creative", creative_path, report_date, asin_line, creative_extra);

let jobs = [];
jobs.push(#{
    prompt: listing_prompt,
    label: "listing",
    capability_mode: "read-write",
    agent_type: "listing",
    phase: "Specialists",
});
jobs.push(#{
    prompt: ads_prompt,
    label: "ads",
    capability_mode: "read-write",
    agent_type: "ads",
    phase: "Specialists",
});
jobs.push(#{
    prompt: inventory_prompt,
    label: "inventory",
    capability_mode: "read-write",
    agent_type: "inventory",
    phase: "Specialists",
});
jobs.push(#{
    prompt: customer_prompt,
    label: "customer",
    capability_mode: "read-write",
    agent_type: "customer",
    phase: "Specialists",
});
jobs.push(#{
    prompt: creative_prompt,
    label: "creative",
    capability_mode: "read-write",
    agent_type: "creative",
    phase: "Specialists",
});

let results = parallel(jobs);

let listing_r = ();
let ads_r = ();
let inventory_r = ();
let customer_r = ();
let creative_r = ();
if results.len() > 0 { listing_r = results[0]; }
if results.len() > 1 { ads_r = results[1]; }
if results.len() > 2 { inventory_r = results[2]; }
if results.len() > 3 { customer_r = results[3]; }
if results.len() > 4 { creative_r = results[4]; }

let listing_slot = slot_note(listing_r, listing_path);
let ads_slot = slot_note(ads_r, ads_path);
let inventory_slot = slot_note(inventory_r, inventory_path);
let customer_slot = slot_note(customer_r, customer_path);
let creative_slot = slot_note(creative_r, creative_path);

if listing_slot == "(not in the data)" { log("listing slot failed — weekly report will show (not in the data)"); }
if ads_slot == "(not in the data)" { log("ads slot failed — weekly report will show (not in the data)"); }
if inventory_slot == "(not in the data)" { log("inventory slot failed — weekly report will show (not in the data)"); }
if customer_slot == "(not in the data)" { log("customer slot failed — weekly report will show (not in the data)"); }
if creative_slot == "(not in the data)" { log("creative slot failed — weekly report will show (not in the data)"); }

let attachments = #{
    listing: listing_slot,
    ads: ads_slot,
    inventory: inventory_slot,
    customer: customer_slot,
    creative: creative_slot,
};

phase("Report");
log("ops compiling " + weekly_path);

let ops_prompt = "";
ops_prompt += "You are the ops agent for this Amazon brand. Cwd is the business folder.\n";
ops_prompt += "Use tools (read_file, grep, glob, bash, write). Read files before you write anything. Do not answer from memory.\n\n";
ops_prompt += "1. Read AGENTS.md, then reference/sources.md, then reference/logic.md.\n";
ops_prompt += "2. Then read connected sources listed in sources.md (status connected). Newest file in a bucket wins.\n";
ops_prompt += "3. Follow weekly-operator-report. North star and watch list come from logic.md, not a generic revenue/ACOS dashboard.\n";
ops_prompt += "4. Write " + weekly_path + " using date " + report_date + ". Do not invent a date.\n";
ops_prompt += "5. Attach specialist files that exist. Failed slots are (not in the data) — do not crash.\n";
ops_prompt += "Specialist attachments for this run (exact strings):\n";
ops_prompt += json_encode(attachments) + "\n";
ops_prompt += "If a slot is (not in the data), write that under Specialist attachments. Still write the weekly report.\n";
ops_prompt += "6. Write (not in the data) only after you have read sources.md and tried the connected files. Never invent numbers.\n";
ops_prompt += "7. Name missing sources under Sources / Source failures. Do not edit exports/. Do not spawn children.\n";
ops_prompt += "8. Mode is " + mode + ". Same report shape for prove and weekly.\n";

let ops_r = agent(
    ops_prompt,
    #{
        label: "ops",
        capability_mode: "read-write",
        agent_type: "ops",
        phase: "Report",
    },
);

let weekly_slot = slot_note(ops_r, weekly_path);
if weekly_slot == "(not in the data)" {
    log("ops weekly-report slot failed — still completing with (not in the data)");
}

complete(#{
    mode: mode,
    date: report_date,
    asin: asin_text,
    weekly_report: weekly_slot,
    specialists: attachments,
});
