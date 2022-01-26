import * as express from "express";
import deleteAccontCors from "../../cors";
import client from "../../supabase-client";

const route = express.Router();

route.delete("/:userId", async (req, res) => {
  try {
    const result = await client.auth.api.deleteUser(req.params.userId);
    console.log(result);
    if (result.error == null) {
      res.sendStatus(204);
    } else {
      res.status(result.error.status).json({ message: result.error.message });
    }
  } catch (error) {
    res.status(410).json({ message: "Delete error" });
  }
});

const baseRoute = express.Router();

baseRoute.use("/user", [deleteAccontCors, route]);

export default baseRoute;
