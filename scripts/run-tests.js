import { chromium } from "playwright";
import fs from "fs";
import axios from "axios";
import yargs from "yargs";

const { url, api, token, failOn } = yargs
  .option("url", { type: "string", demandOption: true })
  .option("api", { type: "string", demandOption: true })
  .option("token", { type: "string", demandOption: true })
  .option("failOn", { type: "boolean", default: true }).argv;

(async () => {
  const browser = await chromium.launch({ args: ["--no-sandbox"] });
  const page = await browser.newPage();
  await page.goto(url);

  // inject axe
  const axeCode = fs.readFileSync(
    require.resolve("axe-core/axe.min.js"),
    "utf8"
  );
  await page.addScriptTag({ content: axeCode });
  const results = await page.evaluate(async () => await axe.run());

  // send to your API
  await axios.post(
    api,
    { results },
    {
      headers: { Authorization: `Bearer ${token}` },
    }
  );

  console.log(`Found ${results.violations.length} violations`);
  await browser.close();

  if (failOn && results.violations.length > 0) {
    console.error("🔴 Failing build due to violations");
    process.exit(1);
  }
  process.exit(0);
})();
