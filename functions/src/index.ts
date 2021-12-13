import * as functions from "firebase-functions";
import {initializeApp} from "firebase-admin";
import * as express from "express";
import {Template} from "./template";
import axios, {Method} from "axios";
import * as fs from "fs";
import * as cors from "cors";

const admin = initializeApp();
const server = express();
const db = admin.database();

const versionPath = __dirname + "/../src/resource/version";
const builddatePath = __dirname + "/../src/resource/builddate";
const version = fs.readFileSync(versionPath, "utf-8") || "UNKNOWN VERSION";
const build = fs.readFileSync(builddatePath, "utf-8") || "UNKNOWN BUILDDATE";

server.use(cors());

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
    const template: Template = <Template>(await db.ref("template")
        .child(req.params.template).get()).toJSON();
    const path = req.path.replace(`/${req.params.template}/`, "");
    const url = `${template.baseUrl}${path}`;
    const query = {};
    const header = {};
    Object.assign(query, req.query, template.params);
    Object.assign(header, req.headers, template.headers);
    console.info(
        {
          "template_id": req.params.template,
          "method": req.method,
          "path": path,
          "header": req.headers,
          "query": req.query,
        }
    );
    const result = await axios({
      method: req.method as Method,
      headers: header,
      url: url,
      params: query,
    });
    return res.status(result.status).json(result.data);
  } catch (err) {
    console.log(err);
    return res.status(404).json({message: "Not Found"});
  }
});

server.use((_, res) => {
  res.status(404).json({message: "Not Found"});
});

export const api = functions.region("asia-southeast1").https.onRequest(server);
