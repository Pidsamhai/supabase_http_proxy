"use strict";
import * as express from "express";
import { Template } from "./template";
import axios, { Method } from "axios";
import * as fs from "fs";
import * as cors from "cors";
import * as apicache from "apicache";
import rateLimit from "express-rate-limit";
import { TemplateNotFound } from "./exception";
import { createClient } from "@supabase/supabase-js";
import * as dotenv from "dotenv";

dotenv.config();

const SUPABASE_API_URL = process.env.SUPABASE_API_URL || "";
const SUPABASE_SECRET_KEY = process.env.SUPABASE_SECRET_KEY || "";
const port = process.env.PORT || 9000;

const client = createClient(SUPABASE_API_URL, SUPABASE_SECRET_KEY);
const server = express();
const versionPath = __dirname + "/../src/resource/version";
const builddatePath = __dirname + "/../src/resource/builddate";
const version = fs.readFileSync(versionPath, "utf-8") || "UNKNOWN VERSION";
const build = fs.readFileSync(builddatePath, "utf-8") || "UNKNOWN BUILDDATE";

const cache = apicache.middleware;
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
});

server.use(cors());
server.use(cache("5 minutes"));
server.use(limiter);

server.get("/", (_, res) => {
  res.json({
    message: "Server Alive",
    date: Date.now(),
    version: version.trim(),
    build_date: build.trim(),
  });
});

server.all("/:template/*", async (req, res) => {
  try {
    const doc = await client.from("template").select("*").eq("uid", req.params.template);
    console.log(doc)
    if (doc.data == null || doc.data.length == 0) {
      throw new TemplateNotFound(req.params.template);
    }
    const template: Template = <Template>doc.data[0];
    const path = req.path.replace(`/${req.params.template}/`, "");
    const url = `${template.baseUrl}${path}`;
    const query: Record<string, string> = {};
    const header: Record<string, string> = {};

    Object.assign(query, req.query, template.params);
    Object.assign(header, template.headers);

    console.info({
      template_id: req.params.template,
      method: req.method,
      path: path,
      header: req.headers,
      query: req.query,
      url: url,
    });

    const result = await axios({
      method: req.method as Method,
      headers: template.headers,
      url: url,
      params: template.params,
    });

    if (result.headers["Content-type"] || result.headers["content-type"]) {
      res.set(
        "Content-type",
        result.headers["Content-type"] ?? result.headers["content-type"]
      );
    }

    console.log(result.headers);
    res.status(result.status).send(result.data);
  } catch (err) {
    console.log(err);
    if (err instanceof TemplateNotFound) {
      res.status(404).json({ message: err.message });
    } else {
      res.status(404).json({ message: "Not Found" });
    }
  }
});

server.use((_, res) => {
  res.status(404).json({ message: "Not Found" });
});

server.listen(port, () => {
  console.log("\x1b[36m",`Live on http://127.0.0.1:${port}`);
});
