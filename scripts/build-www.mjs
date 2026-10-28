// Copies the game into www/ for the phone apps. The apps must work offline,
// so the Google Fonts link is swapped for the copies in app-assets/fonts.
import { cpSync, mkdirSync, readFileSync, rmSync, writeFileSync } from "node:fs";

const html = readFileSync("index.html", "utf8");
const fontLink = /<link rel="stylesheet" href="https:\/\/fonts\.googleapis\.com[^>]*>/;
if (!fontLink.test(html)) throw new Error("Google Fonts link not found in index.html");

rmSync("www", { recursive: true, force: true });
mkdirSync("www");
writeFileSync("www/index.html", html.replace(fontLink, '<link rel="stylesheet" href="fonts/fonts.css">'));
cpSync("app-assets/fonts", "www/fonts", { recursive: true });
console.log("Built www/");
