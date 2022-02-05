import * as express from "express";
import * as fs from "fs";

const route = express.Router();

const versionPath = __dirname + "/../../../src/resource/version";
const builddatePath = __dirname + "/../../../src/resource/builddate";
const version = fs.readFileSync(versionPath, "utf-8") || "UNKNOWN VERSION";
const build = fs.readFileSync(builddatePath, "utf-8") || "UNKNOWN BUILDDATE";

route.get("/", (_, res) => {
  res.json({
    message: "Server Alive",
    date: Date.now(),
    version: version.trim(),
    build_date: build.trim(),
  });
});

export default route;
