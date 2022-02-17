import { Request, Response } from "express";
import * as path from "path";

export default function (_req: Request, res: Response) {
  res.sendFile(path.resolve(__dirname, "..", "..", "public/index.html"));
}
