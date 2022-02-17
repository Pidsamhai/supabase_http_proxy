import { Template } from "../types/template";
import axios, { Method } from "axios";
import { TemplateNotFound } from "../exception";
import { supabaseService } from "../services/supabase.service";
import { Request, Response } from "express";

export default async function (req: Request, res: Response): Promise<any> {
  console.debug(req.path);
  try {
    const template: Template = await supabaseService.getTemplate(
      req.params.template
    );
    const path = req.path.replace(`/${req.params.template}/`, "");
    const url = `${template.baseUrl}${path}`;
    const params: Record<string, string> = {};
    const header: Record<string, string> = {};

    Object.assign(params, req.query, template.params);
    Object.assign(header, template.headers);

    console.debug({
      template_id: req.params.template,
      method: req.method,
      path: path,
      header: req.headers,
      params: req.query,
      url: url,
    });
    const result = await axios.request({
      method: req.method as Method,
      headers: template.headers,
      url: url,
      params: params,
    });

    const contentType: string | undefined =
      result.headers["Content-type"] || result.headers["content-type"];

    if (contentType) {
      res.set("Content-type", contentType);
    }

    console.debug(result.headers);
    res.status(result.status).send(result.data);
  } catch (err) {
    console.error(err);
    if (err instanceof TemplateNotFound) {
      res.status(404).json({ message: err.message });
    } else {
      res.status(404).json({ message: "Not Found" });
    }
  }
}
