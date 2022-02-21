import { supabaseService } from "./../services/supabase.service";
import { Request, Response } from "express";
import * as jwt from "njwt";
import { TokenExpired, UserNotFound } from "../exception";

export default async function (req: Request, res: Response): Promise<void> {
  try {
    const token = jwt.verify(
      req.headers.authorization?.split(" ")[1] ?? "",
      process.env.JWT_SECRET
    );
    if (token?.isExpired() == true) {
      throw new TokenExpired();
    }
    const userId = token?.body.toJSON()["sub"] as string | undefined;
    await supabaseService.deleteUser(userId!);
    res.sendStatus(204);
  } catch (error: any) {
    if (error.name == "JwtParseError" || error instanceof TokenExpired) {
      res.status(401).json({ message: "Unauthorized" });
      return;
    }
    if (error instanceof UserNotFound) {
      res.status(404).json({ message: error.message });
      return;
    }
    res.status(410).json({ message: "Delete error" });
  }
}
