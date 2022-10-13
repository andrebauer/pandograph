#!/usr/bin/env node
import { program } from 'commander';
import * as puppeteer from 'puppeteer';
import { readFileSync, writeFileSync } from 'fs';
import path from 'path';
import mkdirp from 'mkdirp';
import {fileURLToPath} from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// import { parse } from 'scratchblocks/syntax/index.js';
// import * as scratch3 from 'scratchblocks/scratch3/index.js';

async function svg(url, defs, css) {
  const browser = await puppeteer.launch(); // { headless: false });
  const page = await browser.newPage();
  await page.goto(url, {}); // { waitUntil: 'networkidle2', timeout: 30000 });
  const html = await page.content();
  const el = await page.$("#export-svg");
  const text = decodeURIComponent(await(await el.getProperty("href")).jsonValue());
  await browser.close();

  const svg = text.replace("data:image/svg+xml;utf8,",""); // res
  const styled_svg = svg.replace("</svg>", "<style>" + css + "</style></svg>")
  return styled_svg
}

program
  .name('scratchblock.js')

program.command('svg')
  .option('-o, --output <string>')
  .option('-i, --input <string>')
  .action(async ( options) => {

    const urlPrefix = "https://scratchblocks.github.io/#?style=scratch3&lang=de&script=";

    const css = readFileSync(path.join(__dirname, "style.css"), "utf8")

    const input = options.input || '/dev/stdin'

    const content = readFileSync(input, 'utf8').toString();
    const script =  encodeURIComponent(content);
    const url = urlPrefix + script;

    const svg1 = await svg(url, css); // parse(content, { languages: ['en']})

    if (options.output) {
      await mkdirp(path.dirname(options.output))
      writeFileSync(options.output, svg1, 'utf8')
    } else {
      console.log(svg1);
    }
})

program.parse(process.argv);

/*
const view = scratch3.newView(content, {
    style: 'scratch3',
    scale: 0.675,
  });
*/
