import * as express from "express";
import { Template } from "../../types/template";
import axios, { Method } from "axios";
import { TemplateNotFound } from "../../exception";
import client from "../../supabase-client";
import * as apicache from "apicache";
const cache = apicache.middleware;

const route = express.Router();

route.all("/:template/*", async (req, res) => {
  try {
    const doc = await client
      .from("template")
      .select("*")
      .eq("uid", req.params.template)
      .single();
    if (doc.data == null || doc.error != null) {
      throw new TemplateNotFound(req.params.template);
    }
    const template: Template = <Template>doc.data;
    const path = req.path.replace(`/${req.params.template}/`, "");
    const url = `${template.baseUrl}${path}`;
    const params: Record<string, string> = {};
    const header: Record<string, string> = {};

    Object.assign(params, req.query, template.params);
    Object.assign(header, template.headers);

    console.info({
      template_id: req.params.template,
      method: req.method,
      path: path,
      header: req.headers,
      params: req.query,
      url: url,
    });

    const result = await axios({
      method: req.method as Method,
      headers: template.headers,
      url: url,
      params: params,
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

const baseRoute = express.Router();

baseRoute.use("/template", [cache("5 minutes"), route]);

export default baseRoute;
