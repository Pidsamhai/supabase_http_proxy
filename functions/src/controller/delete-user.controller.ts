import { supabaseService } from "./../services/supabase.service";
import { Request, Response } from "express";
import { UserNotFound } from "../exception";

export default async function (req: Request, res: Response) {
  try {
    await supabaseService.deleteUser(req.params.userId);
    res.sendStatus(204);
  } catch (error) {
    if (error instanceof UserNotFound) {
      res.status(404).json({ message: error.message });
      return;
    }
    res.status(410).json({ message: "Delete error" });
  }
}
